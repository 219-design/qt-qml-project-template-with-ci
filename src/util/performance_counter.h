#ifndef PROJ_LIB_UTIL_PERFORMANCE_COUNTER_H
#define PROJ_LIB_UTIL_PERFORMANCE_COUNTER_H

#include <algorithm>
#include <array>
#include <iterator>
#include <optional>

#include <QElapsedTimer>
#include <QObject>
#include <QQmlEngine>
#include <QQuickWindow>

namespace project
{
struct FrameReport
{
    qint32 m_afterAnimating;
    qint32 m_beforeRendering;
    qint32 m_afterRendering;
};

struct Report
{
    Report() = default;
    Report& operator=( const Report& ) = default;

    // Gets the current frame that timing data should be written into.
    FrameReport& GetFrameReportToWriteInto();
    // Moves the internal pointer to the next frame to write into, moving the cache into the heap-allocated backlog if space is needed.
    void FinishFrame();

    static constexpr size_t k_maxNumberOfFrames = 15;

    // The number of frame reports that have been fully filled, with all 3 timestamps having been written.
    // This means that this is also the index of the FrameReport where new values should be written,
    // and that this should be incremented whenever the last timestamp is written.
    size_t m_framesFilledCount;
    std::array<FrameReport, k_maxNumberOfFrames> m_frames;
    std::vector<FrameReport> m_backloggedFrames;
};

struct ReportRequest
{
    ReportRequest();
    explicit ReportRequest( QString name );

    // Called automatically from the GUI thread while the render thread is waiting
    void Synchronize();

    // Called by users from GUI thread
    void RequestStop();

    // Called automatically from the render thread
    void Finalize();

    void ExportReport();

    // Fully owned by the GUI thread
    QString m_name;
    // Written by the GUI thread before synchronization, read by the render thread after synchronization.
    QElapsedTimer m_timer;
    // Written by the GUI thread requesting that the report finish after the next render.
    bool m_requestedToStopGUIThread = false;
    // Copied based on m_requestedToStopGUIThread during synchronization.
    bool m_requestedToStopRenderThread = false;
    // Written to on the render thread once the frame that m_requestedToStopRenderThread was set in has finished.
    // Once this is true, the report can be cleared out during the next synchronization.
    bool m_finalized = false;
    std::optional<Report> m_report;
};

// This object currently sits at 800 bytes, which means it should fit in a single page of memory.
class PerformanceCounter : public QObject
{
    Q_OBJECT

public:
    PerformanceCounter( QObject* parent, QQuickWindow* window );

    void ExportContextPropertiesToQml( QQmlEngine* engine );

    // All public methods must be called by the GUI thread
    void StartReport( const QString& reportName );
    void StopReport( const QString& reportName );

    static constexpr size_t k_maxNumberOfReports = 3;

private slots:
    // This happens on the GUI thread and can be used to synchronize between GUI and rendering thread resources.
    void AfterAnimating();
    // This happens on the rendering thread
    void BeforeRendering();
    // This happens on the rendering thread
    void AfterRendering();

private:
    // This must be called on the rendering thread
    void AddReportToInternalStorage( Report report );
    void ConnectToWindowIfNecessary();

    std::array<ReportRequest, k_maxNumberOfReports> m_reports;

    // Whether the private slots have been connected to the window's signals.
    bool m_connectedToWindow = false;
    QQuickWindow* m_window;
};

} // namespace project

#endif // PROJ_LIB_UTIL_PERFORMANCE_COUNTER_H

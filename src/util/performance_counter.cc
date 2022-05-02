#include "performance_counter.h"

#include <QQuickWindow>

#include <QQmlContext>

namespace project
{
PerformanceCounter::PerformanceCounter( QObject* parent, QQuickWindow* window )
    : QObject( parent ), m_window( window )
{
}

void PerformanceCounter::ExportContextPropertiesToQml( QQmlEngine* engine )
{
    engine->rootContext()->setContextProperty( "performanceCounter", this );
}

void PerformanceCounter::ConnectToWindowIfNecessary()
{
    if( m_connectedToWindow )
    {
        return;
    }
    connect( m_window, &QQuickWindow::afterAnimating, this, &PerformanceCounter::AfterAnimating );
    connect( m_window, &QQuickWindow::beforeRendering, this, &PerformanceCounter::BeforeRendering );
    connect( m_window, &QQuickWindow::afterRendering, this, &PerformanceCounter::AfterRendering );
}

void PerformanceCounter::StartReport( const QString& name )
{
    for( auto& reportRequest : m_reports )
    {
        if( reportRequest.m_name.isEmpty() )
        {
            reportRequest = ReportRequest( name );
            return;
        }
    }
}

void PerformanceCounter::AfterAnimating()
{
    for( auto& reportRequest : m_reports )
    {
        reportRequest.Synchronize();
        if( reportRequest.m_report.has_value() )
        {
            reportRequest.m_report->GetFrameReportToWriteInto().m_afterAnimating = static_cast<qint32>( reportRequest.m_timer.elapsed() );
        }
    }
}

void PerformanceCounter::BeforeRendering()
{
    for( auto& reportRequest : m_reports )
    {
        if( reportRequest.m_report.has_value() )
        {
            reportRequest.m_report->GetFrameReportToWriteInto().m_beforeRendering = static_cast<qint32>( reportRequest.m_timer.elapsed() );
        }
    }
}

void PerformanceCounter::AfterRendering()
{
    for( auto& reportRequest : m_reports )
    {
        if( reportRequest.m_report.has_value() )
        {
            reportRequest.m_report->GetFrameReportToWriteInto().m_beforeRendering = static_cast<qint32>( reportRequest.m_timer.elapsed() );
            reportRequest.m_report->FinishFrame();
            if( reportRequest.m_requestedToStopRenderThread )
            {
                reportRequest.Finalize();
            }
        }
    }
}

ReportRequest::ReportRequest()
    : m_name(), m_timer()
{
}
ReportRequest::ReportRequest( QString name )
    : m_name( name ), m_timer()
{
    m_timer.start();
}

// Called automatically from the GUI thread while the render thread is waiting
void ReportRequest::Synchronize()
{
    if( m_finalized )
    {
        *this = ReportRequest();
    }
    else
    {
        if( ( m_name.data() != nullptr ) && !m_report.has_value() )
        {
            m_report.emplace();
        }
        m_requestedToStopRenderThread = m_requestedToStopGUIThread;
    }
}

// Called by users from GUI thread
void ReportRequest::RequestStop()
{
    m_requestedToStopGUIThread = true;
}

// Called automatically from the render thread
void ReportRequest::Finalize()
{
    ExportReport();
    m_finalized = true;
}

struct MinMax
{
    qint32 m_min = std::numeric_limits<qint32>::max();
    qint32 m_max = std::numeric_limits<qint32>::min();

    void Update( qint32 val )
    {
        m_min = std::min( m_min, val );
        m_max = std::max( m_max, val );
    }
};

void ReportRequest::ExportReport()
{
    auto log = qDebug();
    log = log << "Exporting report for: " << m_name << Qt::endl;
    log = log << Qt::right << qSetFieldWidth( 3 );
    qint32 previousGuiUpdate = 0;
    qint32 previousRenderFinish = 0;

    MinMax guiFrameDurationExtents;
    MinMax renderFrameDurationExtents;
    MinMax synchronizingExtents;
    MinMax renderingExtents;

    for( const FrameReport& frame : m_report->m_backloggedFrames )
    {
        qint32 guiFrameDuration = frame.m_afterAnimating - previousGuiUpdate;
        previousGuiUpdate = frame.m_afterAnimating;
        qint32 renderFrameDuration = frame.m_afterRendering - previousRenderFinish;
        previousRenderFinish = frame.m_afterRendering;
        qint32 synchronizing = frame.m_beforeRendering - frame.m_afterAnimating;
        qint32 rendering = frame.m_afterRendering - frame.m_beforeRendering;
        log << synchronizing << ", " << rendering << ", " << guiFrameDuration << ", " << renderFrameDuration;
        guiFrameDurationExtents.Update( guiFrameDuration );
        renderFrameDurationExtents.Update( renderFrameDuration );
        synchronizingExtents.Update( synchronizing );
        renderingExtents.Update( rendering );
    }
    for( size_t i = 0; i < m_report->m_framesFilledCount; i++ )
    {
        const FrameReport& frame = m_report->m_frames[ i ];
        qint32 guiFrameDuration = frame.m_afterAnimating - previousGuiUpdate;
        previousGuiUpdate = frame.m_afterAnimating;
        qint32 renderFrameDuration = frame.m_afterRendering - previousRenderFinish;
        previousRenderFinish = frame.m_afterRendering;
        qint32 synchronizing = frame.m_beforeRendering - frame.m_afterAnimating;
        qint32 rendering = frame.m_afterRendering - frame.m_beforeRendering;
        log << synchronizing << ", " << rendering << ", " << guiFrameDuration << ", " << renderFrameDuration;
        guiFrameDurationExtents.Update( guiFrameDuration );
        renderFrameDurationExtents.Update( renderFrameDuration );
        synchronizingExtents.Update( synchronizing );
        renderingExtents.Update( rendering );
    }

    log << "GUI Frame Duration Extents " << guiFrameDurationExtents.m_min << ", " << guiFrameDurationExtents.m_max;
    log << "Render Frame Duration Extents " << renderFrameDurationExtents.m_min << ", " << renderFrameDurationExtents.m_max;
    log << "Synchronizing Extents " << synchronizingExtents.m_min << ", " << synchronizingExtents.m_max;
    log << "Rendering Extents " << renderingExtents.m_min << ", " << renderingExtents.m_max;
}

FrameReport& Report::GetFrameReportToWriteInto()
{
    return m_frames[ m_framesFilledCount ];
}

void Report::FinishFrame()
{
    m_framesFilledCount++;
    if( m_framesFilledCount == m_frames.size() )
    {
        size_t currentBacklogSize = m_backloggedFrames.size();
        m_backloggedFrames.resize( currentBacklogSize + m_frames.size() );
        memcpy( m_frames.data(), m_backloggedFrames.data() + currentBacklogSize, sizeof( FrameReport ) * m_frames.size() );
        m_framesFilledCount = 0;
    }
}
} // namespace project

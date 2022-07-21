//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJ_LIB_UTIL_TIMER_SERVICE_H
#define PROJ_LIB_UTIL_TIMER_SERVICE_H

#include <QtCore/QObject>
#include <QtCore/QTimer>

#include <optional>

namespace project
{
// The data needed to fake a QTimer.
struct FakeTimerData
{
    bool isSingleShot = false;
    std::optional<int> startTime;
    int interval = 0;
};

// A timer object that either wraps a real QTimer or a fake.
class Timer : public QObject
{
    Q_OBJECT

public:
    explicit Timer( QObject* parent = nullptr );
    virtual ~Timer();

    // Wrap similar QTimer methods.
    void SetSingleShot( bool singleshot );
    bool IsSingleShot() const;
    void SetInterval( int msecs );
    void Start();
    void Start( int msecs );
    void Stop();

signals:
    void Timeout();

private:
    void TimeoutInternal();

    friend class TimerService;
    // It is guaranteed that exactly one of these will have a value.
    std::optional<QTimer> m_timerImpl;
    std::optional<FakeTimerData> m_fakeTimer;
};

class TimerService
{
public:
    // Enters testing mode where there is a fake time controlled by a singleton instance.
    static void BecomeTest();

    // Gets the current fake time. Only valid when in test mode.
    static int GetCurrentTime();
    // Advances the current fake time by some delta. Calls any timer callbacks that happen during the delta.
    // Only valid when in test mode.
    static void AdvanceCurrentTime( int msecs );
    // Sets the current fake time to a value, ignoring any timer callbacks. It is allowed to go backwards.
    // This should only be used between tests when all Timers are irrelevant.
    static void ResetCurrentTime( int msecs );

private:
    // Registers a Timer, which must happen automatically exactly once during the constructor.
    static void RegisterTimer( Timer* timer );
    void RegisterTimerInternal( Timer* timer );
    // Unregisters a Timer, which must happen automatically exactly once during the destructor.
    static void UnregisterTimer( Timer* timer );
    void UnregisterTimerInternal( Timer* timer );

    // Befriend the Timer class so that registration can happen during the constructor but never outside it.
    friend class Timer;

    // The singleton instance.
    static TimerService k_instance;

    // Whether this is running inside tests. This should only ever change once to become true during testing.
    bool m_useFakeTimer = false;

    // The current fake time when running tests.
    int m_currentTime = 0;

    // Every registered Timer, only filled when in testing mode.
    std::vector<Timer*> m_registeredTimers;
};
} // namespace project

#endif // PROJ_LIB_UTIL_TIMER_SERVICE_H

//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "timer_service.h"

namespace project
{
TimerService TimerService::k_instance;

Timer::Timer( QObject* parent )
    : QObject( parent )
{
    TimerService::RegisterTimer( this );
    if( m_timerImpl.has_value() )
    {
        connect( &( *m_timerImpl ), &QTimer::timeout, this, &Timer::Timeout );
    }
}

Timer::~Timer()
{
    TimerService::UnregisterTimer( this );
}

void Timer::SetSingleShot( bool singleshot )
{
    if( m_timerImpl.has_value() )
    {
        m_timerImpl->setSingleShot( singleshot );
    }
    else
    {
        m_fakeTimer->isSingleShot = singleshot;
    }
}

bool Timer::IsSingleShot() const
{
    if( m_timerImpl.has_value() )
    {
        return m_timerImpl->isSingleShot();
    }
    else
    {
        return m_fakeTimer->isSingleShot;
    }
}

void Timer::SetInterval( int msecs )
{
    if( m_timerImpl.has_value() )
    {
        m_timerImpl->setInterval( msecs );
    }
    else
    {
        m_fakeTimer->interval = msecs;
    }
}

void Timer::Start()
{
    if( m_timerImpl.has_value() )
    {
        m_timerImpl->start();
    }
    else
    {
        m_fakeTimer->startTime = TimerService::GetCurrentTime();
    }
}

void Timer::Start( int msecs )
{
    if( m_timerImpl.has_value() )
    {
        m_timerImpl->start( msecs );
    }
    else
    {
        m_fakeTimer->startTime = TimerService::GetCurrentTime();
        m_fakeTimer->interval = msecs;
    }
}

void Timer::Stop()
{
    if( m_timerImpl.has_value() )
    {
        m_timerImpl->stop();
    }
    else
    {
        m_fakeTimer->startTime.reset();
    }
}

void Timer::TimeoutInternal()
{
    if( m_fakeTimer->isSingleShot )
    {
        m_fakeTimer->startTime.reset();
    }
    else
    {
        m_fakeTimer->startTime = *m_fakeTimer->startTime + m_fakeTimer->interval;
    }
    emit Timeout();
}

void TimerService::RegisterTimer( Timer* timer )
{
    k_instance.RegisterTimerInternal( timer );
}

void TimerService::RegisterTimerInternal( Timer* timer )
{
    if( m_useFakeTimer )
    {
        timer->m_fakeTimer.emplace();
    }
    else
    {
        timer->m_timerImpl.emplace();
    }
    m_registeredTimers.push_back( timer );
}

void TimerService::UnregisterTimer( Timer* timer )
{
    k_instance.UnregisterTimerInternal( timer );
}

void TimerService::UnregisterTimerInternal( Timer* timer )
{
    for( auto iter = m_registeredTimers.rbegin(); iter != m_registeredTimers.rend(); iter++ )
    {
        if( *iter == timer )
        {
            m_registeredTimers.erase( ( iter + 1 ).base() );
        }
    }
}

void TimerService::BecomeTest()
{
    k_instance.m_useFakeTimer = true;
}

int TimerService::GetCurrentTime()
{
    return k_instance.m_currentTime;
}

void TimerService::AdvanceCurrentTime( int msecs )
{
    k_instance.m_currentTime += msecs;

    while( true )
    {
        Timer* timerToUpdate = nullptr;
        int earliestTimerTrigerTime = k_instance.m_currentTime + 1;
        for( auto timer : k_instance.m_registeredTimers )
        {
            if( timer->m_fakeTimer->startTime.has_value() )
            {
                int timerTriggerTime = *timer->m_fakeTimer->startTime + timer->m_fakeTimer->interval;
                if( earliestTimerTrigerTime == -1 || timerTriggerTime < earliestTimerTrigerTime )
                {
                    earliestTimerTrigerTime = timerTriggerTime;
                    timerToUpdate = timer;
                }
            }
        }
        if( timerToUpdate == nullptr )
        {
            break;
        }
        timerToUpdate->TimeoutInternal();
    }
}

void TimerService::ResetCurrentTime( int msecs )
{
    k_instance.m_currentTime = msecs;
}

} // namespace project
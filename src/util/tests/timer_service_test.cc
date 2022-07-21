//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "gmock/gmock.h"
#include "gtest/gtest.h"

#include <QSignalSpy>
#include <QString>

#include "src/util/timer_service.h"

namespace
{
using ::testing::AllOf;
using ::testing::Each;
using ::testing::ElementsAre;
using ::testing::Eq;
using ::testing::Field;
using ::testing::IsFalse;
using ::testing::IsTrue;
using ::testing::MockFunction;
using ::testing::NotNull;
using ::testing::Pointee;
using ::testing::Return;
using ::testing::Test;
using ::testing::UnorderedElementsAre;

using project::Timer;
using project::TimerService;

class TimerServiceTest : public Test
{
public:
    TimerServiceTest()
    {
        TimerService::BecomeTest();
        TimerService::ResetCurrentTime( 1000 );
    }

    virtual ~TimerServiceTest()
    {
    }

    void ConnectCallbackToTimer( Timer* timer, MockFunction<void()>* callback )
    {
        timer->connect( timer, &Timer::Timeout, timer, callback->AsStdFunction() );
    }
};

TEST_F( TimerServiceTest, Interleaved )
{
    // Make 3 timers, one repeating.
    Timer recurringTimer;
    Timer earlyTimer;
    earlyTimer.SetSingleShot( true );
    Timer lateTimer;
    lateTimer.SetSingleShot( true );

    MockFunction<void()> recurringCallback;
    ConnectCallbackToTimer( &recurringTimer, &recurringCallback );
    MockFunction<void()> earlyCallback;
    ConnectCallbackToTimer( &earlyTimer, &earlyCallback );
    MockFunction<void()> lateCallback;
    ConnectCallbackToTimer( &lateTimer, &lateCallback );

    // Interleave the callbacks to the recurring timer should happen before, between, and after the other timers.
    recurringTimer.Start( 1000 );
    earlyTimer.Start( 1500 );
    lateTimer.Start( 2500 );

    {
        ::testing::InSequence s;
        // At 1000ms
        EXPECT_CALL( recurringCallback, Call() ).Times( 1 );
        // At 1500ms
        EXPECT_CALL( earlyCallback, Call() ).Times( 1 );
        // At 2000ms
        EXPECT_CALL( recurringCallback, Call() ).Times( 1 );
        // At 2500ms
        EXPECT_CALL( lateCallback, Call() ).Times( 1 );
        // At 3000ms and 4000ms
        EXPECT_CALL( recurringCallback, Call() ).Times( 2 );

        // Advance time enough to trigger the recurring timer 4 times.
        project::TimerService::AdvanceCurrentTime( 4000 );
    }
}

TEST_F( TimerServiceTest, OnlyRelevantTimersTrigger )
{
    Timer earlyTimer;
    earlyTimer.SetSingleShot( true );
    Timer lateTimer;
    lateTimer.SetSingleShot( true );

    MockFunction<void()> earlyCallback;
    ConnectCallbackToTimer( &earlyTimer, &earlyCallback );
    MockFunction<void()> lateCallback;
    ConnectCallbackToTimer( &lateTimer, &lateCallback );

    earlyTimer.Start( 500 );
    lateTimer.Start( 1500 );

    // The early timer should be called, but the late timer shoudln't be because its time hasn't been reached.
    EXPECT_CALL( earlyCallback, Call() ).Times( 1 );
    EXPECT_CALL( lateCallback, Call() ).Times( 0 );

    TimerService::AdvanceCurrentTime( 1000 );
}

TEST_F( TimerServiceTest, TimerStartTimeMatters )
{
    // Create 3 timers.
    // One will start early but end later.
    // One will start after the first but end before it.
    // One will start after the first and end after it.
    Timer earlyStartLateTriggerTimer;
    earlyStartLateTriggerTimer.SetSingleShot( true );
    Timer lateStartEarlyTriggerTimer;
    lateStartEarlyTriggerTimer.SetSingleShot( true );
    Timer lateStartLatestTriggerTimer;
    lateStartLatestTriggerTimer.SetSingleShot( true );

    MockFunction<void()> elCallback;
    ConnectCallbackToTimer( &earlyStartLateTriggerTimer, &elCallback );
    MockFunction<void()> leCallback;
    ConnectCallbackToTimer( &lateStartEarlyTriggerTimer, &leCallback );
    MockFunction<void()> llCallback;
    ConnectCallbackToTimer( &lateStartLatestTriggerTimer, &llCallback );

    {
        ::testing::InSequence s;

        EXPECT_CALL( leCallback, Call() ).Times( 1 );
        EXPECT_CALL( elCallback, Call() ).Times( 1 );
        EXPECT_CALL( llCallback, Call() ).Times( 0 );

        // The (early, late) timer will start at 0 but end at 3000
        // The (late, early) timer will start at 500 but end at 2000
        // The (late, latest) timer will start at 500 but end at 4000
        // The simulation will run until 3000, which should trigger the first two timers but not the latest one.
        earlyStartLateTriggerTimer.Start( 3000 );
        TimerService::AdvanceCurrentTime( 500 );
        lateStartEarlyTriggerTimer.Start( 1500 );
        lateStartLatestTriggerTimer.Start( 3500 );
        TimerService::AdvanceCurrentTime( 2500 );
    }
}

TEST_F( TimerServiceTest, ChangingInterval )
{
    Timer becomesEarlyTimer;
    becomesEarlyTimer.SetSingleShot( true );
    Timer becomesLateTimer;
    becomesLateTimer.SetSingleShot( true );

    MockFunction<void()> earlyCallback;
    ConnectCallbackToTimer( &becomesEarlyTimer, &earlyCallback );
    MockFunction<void()> lateCallback;
    ConnectCallbackToTimer( &becomesLateTimer, &lateCallback );

    // Change the intervals to make one occur earlier than the other, creating them with the opposite ordering.
    becomesEarlyTimer.Start( 1500 );
    becomesLateTimer.Start( 500 );
    becomesEarlyTimer.SetInterval( 500 );
    becomesLateTimer.SetInterval( 1500 );

    // The early timer should be called, but the late timer shoudln't be because its time hasn't been reached.
    EXPECT_CALL( earlyCallback, Call() ).Times( 1 );
    EXPECT_CALL( lateCallback, Call() ).Times( 0 );

    TimerService::AdvanceCurrentTime( 1000 );
}

} // namespace

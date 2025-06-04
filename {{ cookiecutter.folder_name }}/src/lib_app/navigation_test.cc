//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#include "gtest/gtest.h"

#include <QString>

namespace
{
class NavigationTest : public ::testing::Test
{
protected:
    NavigationTest()
        : m_name( "Fake Dialog" ), m_got_focus( false )
    {
    }

    void GetFocus()
    {
        m_got_focus = true;
    }
    void LoseFocus()
    {
        m_got_focus = false;
    }

    const QString m_name;

    bool m_got_focus;
};

TEST_F( NavigationTest, NameIsFakeDialog )
{
    EXPECT_EQ( m_name, QString( "Fake Dialog" ) );
}

TEST_F( NavigationTest, InitiallyLacksFocus )
{
    EXPECT_EQ( m_got_focus, false );
}

TEST_F( NavigationTest, GotFocus )
{
    GetFocus();
    EXPECT_EQ( m_got_focus, true );

    LoseFocus();
    EXPECT_EQ( m_got_focus, false );
}

} // namespace

//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "gmock/gmock.h"
#include "gtest/gtest.h"

#include "src/lib_example_shared/example_shared.h"

namespace
{
class ExampleSharedTest : public ::testing::Test
{
protected:
    ExampleSharedTest()
    {
    }

    project::ExampleClass m_example;
};

TEST_F( ExampleSharedTest, FunctionWorks )
{
    EXPECT_THAT( m_example.ExampleFunction( 10 ), ::testing::Eq( 15 ) );
}

} // namespace

#include "every_so_often.h"

namespace project
{
namespace
{
constexpr std::chrono::milliseconds kPaddingInCaseZero{ 20 };
} // namespace

EverySoOften::EverySoOften( std::chrono::milliseconds howOften )
    // clang-format off
    : m_howOften( howOften ),
      // Set m_timeOfLastAction to something that GUARANTEES that the first 'Do' will succeed:
      m_timeOfLastAction( std::chrono::system_clock::now() -
                          // now MINUS something means we're setting m_timeOfLastAction to a PAST time
                          ((m_howOften+kPaddingInCaseZero) * 2) )
// clang-format on
{
}

// The action will only be taken if the time elapsed since the last action is
// greater than the duration used when constructing this object.
void EverySoOften::Do( std::function<void()> doThis )
{
    const std::chrono::time_point<std::chrono::system_clock> now = std::chrono::system_clock::now();

    if( std::chrono::duration_cast<std::chrono::milliseconds>( now - m_timeOfLastAction ) > m_howOften )
    {
        m_timeOfLastAction = now;
        doThis();
    }
}

} // namespace project

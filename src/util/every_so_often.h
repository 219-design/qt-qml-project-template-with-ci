#ifndef PROJ_LIB_UTIL_EVERY_SO_OFTEN_H
#define PROJ_LIB_UTIL_EVERY_SO_OFTEN_H

#include <chrono>
#include <functional>

namespace project
{
class EverySoOften
{
public:
    explicit EverySoOften( std::chrono::milliseconds howOften );

    // The action will only be taken if the time elapsed since the last action is
    // greater than the duration used when constructing this object.
    void Do( std::function<void()> doThis );

private:
    const std::chrono::milliseconds m_howOften;
    std::chrono::time_point<std::chrono::system_clock> m_timeOfLastAction;
};
} // namespace project

#endif // PROJ_LIB_UTIL_EVERY_SO_OFTEN_H

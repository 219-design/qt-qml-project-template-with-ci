#ifndef PROJ_LIB_UTIL_USAGE_LOG_H
#define PROJ_LIB_UTIL_USAGE_LOG_H

#include <QDebug>

#include <memory> // gets us pointer_traits
#include <string>

namespace project
{
// TODO: consider adding a template arg for __LINE__, using https://stackoverflow.com/q/3773378/10278
template <class WrappedPtrIsh> // WrappedPtrIsh can be a raw pointer or a smart ptr
class Log
{
public:
    typedef typename std::pointer_traits<WrappedPtrIsh>::element_type obj_type;

    // Look for uses of this helper throughout view_model_collection.cc to see
    // how it makes it less tedious to comprehensively log all interactions with
    // any member-object you with to track.
    explicit Log( std::string s, const WrappedPtrIsh& wrapped )
        : str( s ), w( wrapped )
    {
    }

    obj_type* operator->()
    {
        // Clearly label these special log lines, so that anyone who gets
        // curious about them can locate this template class and understand why
        // these log lines are a bit different.
        constexpr char PREFIX[] = "usage_log_t. (uses name mangling) about to call:";
        std::string nextFuncCall = "::" + str;
        // typeid().name yields a MANGLED type name, but it is "close enough"
        nextFuncCall = typeid( obj_type ).name() + nextFuncCall;
        qInfo() << PREFIX << nextFuncCall.c_str();
        return &*w; // <-- this looks funny, but works for raw pointer and unique_ptr
    }

private:
    const std::string str;
    const WrappedPtrIsh& w;
};

} // namespace project

#endif // PROJ_LIB_UTIL_USAGE_LOG_H

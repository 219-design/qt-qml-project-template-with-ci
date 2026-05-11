// This file is used to configure ASan, and also to suppress LSan leak reports
// from third-party code that we cannot do anything about.

// to quiet this: -Werror=missing-declarations ("no previous declaration for...")
extern "C" const char* __lsan_default_suppressions();
extern "C" const char* __asan_default_options();
extern "C" const char* __ubsan_default_options();

extern "C" const char* __lsan_default_suppressions()
{
    // See: https://github.com/google/sanitizers/issues/1628#issuecomment-1457253550

    // Please make sure the code below declares a single string which contains
    // LSan suppressions delimited by newlines.
    return "leak:libfontconfig.so\n"
           "leak:libfontconfig.so\n"; // intentional duplicate so we have 2, to show format
}

extern "C" const char* __asan_default_options()
{
    // Turn on static init order fiasco detection for ASan.
    return "check_initialization_order=true:"
           "strict_init_order=true:"
           "detect_stack_use_after_return=1:"
           "print_stacktrace=1";

    // Options can also be passed at launch via env var:
    //
    // ASAN_OPTIONS=check_initialization_order=true:strict_init_order=true ./app
}

extern "C" const char* __ubsan_default_options()
{
    return "print_stacktrace=1:"
           "print_stacktrace=1:"; // intentional duplicate so we have 2, to show format
}

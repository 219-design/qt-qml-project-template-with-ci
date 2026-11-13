# debug_util_flexible_assert

https://github.com/pestophagous/debug_util_flexible_assert

## Quick Explanation

This header provides `FASSERT`, which is a cross-platform way to encode
assertions into your codebase that are "more flexible" than those provided by
`<cassert>` [1].

Here are some key differences:

- `FASSERT` can be enabled/disabled independently of `NDEBUG`, which is useful
  if you wish to keep assertions enabled even in a "release" or "production"
  build.
- `FASSERT` produces interactive assertion failures, allowing you to choose to
  ignore a failure (and therefore to attempt to continue execution) when your
  `FASSERT`-ed assumption is violated
- `FASSERT` interactive failures are presented in a platform-appropriate way,
  intended to work well across the following: Microsoft Windows, Mac OS X, Linux
- `FASSERT` can be suppressed **at program launch** by using `export
  FLEX_SUPALL_ASRT=1` (allowing you to skip all assertion-checking without
  recompiling the executable)
- `FASSERT` can also be stripped **at compilation** by passing
  `-DFLEX_DISABLE_ASSERT` to the build.

[1] https://en.cppreference.com/w/cpp/error/assert

------------------------------------------------------------

## Example Usage

#### `FASSERT` always takes exactly 2 arguments:

1. the logical expression asserted to always be true in a correct program, and
2. a message to be shown to the tester/user/coder when the expression-check
"fails" (aka computes to false).

```cpp
    // execution will pause at next line if x<=0
    FASSERT( x > 0, "passing 0 or negative to this code is an error" );
```

#### `FFAIL` can be used as shorthand for `assert(false)`:

...to mark blocks of code that should never be reached. `FFAIL` takes a single
argument, which is the failure message.

```cpp
     if( something_that_should_never_happen )
     {
         FFAIL( "do not want to get here" );
         return;
     }
```

#### Helper functions can disable assertions (CODE SMELL HIGH ALERT!)

The following would be a CODE SMELL in most cases. However, it may be useful for
portions of unit test suites or in other very limited use cases.

The PREFERRED way to disable assertions would be one of either:

1. disabled at launch with `export FLEX_SUPALL_ASRT=1`
2. disabled at compile time with `-DFLEX_DISABLE_ASSERT`

For completeness, here is the SMELLY way to programmatically disable/reenable
assertions:

```cpp
        Suppress_All_Assertions();
        // ...
        // Any code called here that would normally assert will now omit assertion-checking
        // ...
        UnSuppress_All_Assertions();
```

> Tip: Render *.md files locally with Chrome browser http://stackoverflow.com/a/15626336

# CMake Usage Guide by 219 Design, LLC

First things first: Read the CMake "bible" before doing anything non-trivial
----------------------------------

The following e-book ($30 USD as of 2023) is truly the gold standard for
illuminating all things CMake. Page for page, you won't find more consistently
useful and correct tips and explanations anywhere else.

 - [https://crascit.com/professional-cmake/](https://crascit.com/professional-cmake/)

Modern CMake Habits:
------------------

Note that the majority of these habits can be broadly summarized as: *scope!
scope! scope! narrow your scope!*

### prefer-least-scope-commands ###

Avoid commands that affect more than one target.

 - To be *avoided*: `add_compile_options`, `include_directories`, `link_directories`, `link_libraries`

Always look for a similar command that operates on a single target.

 - To be *preferred*: `target_compile_options`, `target_include_directories`, `target_link_directories`, `target_link_libraries`

--------------------------------------------------------------------------------
### avoid-broad-scope-variables ###

Be wary of changing language-wide variables. The changes will apply to all compiler
invocations across all configurations.

 - *Avoid* mutating: `CMAKE_C_FLAGS`, `CMAKE_CXX_FLAGS`

Instead, consider applying your compiler flags in a narrower way, such as with
`target_compile_options` or even `set_source_files_properties`

--------------------------------------------------------------------------------
### examine-broad-scope-variables-before-mutating ###

If you decided to mutate a variable that affects all targets, such as
`CMAKE_RUNTIME_OUTPUT_DIRECTORY`, then consider whether you can mutate it only
when no disturbance will occur.

For example:
```
# Good practice: only set OUTPUT_DIRECTORY if it was not previously set:
if(NOT
   CMAKE_RUNTIME_OUTPUT_DIRECTORY
)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
      ${stageDir}/${CMAKE_INSTALL_BINDIR}
  )
endif()
```

The rationale for only mutating these global locations if they are empty is as
follows: our CMake-based project may end up nested in a sub-folder of a parent
project at some point. If there is an outer/parent project, then the outermost
parent should be in charge of global binary output locations.

--------------------------------------------------------------------------------
### avoid-global-dirs ###

Many, many CMakeLists.txt files out in the wild make heavy use of these, but
they are to be avoided!

 - Avoid: `CMAKE_BINARY_DIR`
 - Avoid: `CMAKE_SOURCE_DIR`

Instead, please...

 - Prefer: `PROJECT_BINARY_DIR`
 - Prefer: `PROJECT_SOURCE_DIR`

Rationale:

In almost all cases, what you really *intend* is to reference the `PROJECT_*`
values of these locations. However, you might fail to recognize that this is
your true intent, because in 9 out of 10 times, the `PROJECT_*_DIR` variables
and the `CMAKE_*_DIR` variables will expand to the same paths.

Making a habit of preferring the `PROJECT_*` variables helps make it easy to
drop your project into a larger CMake-based parent project later on. For as long
as your project is the top-level project, it does no harm to use the `PROJECT_*`
prefix variables. And once your project gets subsumed under a larger project,
you would discover that:

 - Adding a new outer project will render *these* incorrect:
     - `"${CMAKE_SOURCE_DIR}/our_utils/our_gui_helpers/"`
 - Because the expansion now results in something roughly like:
     - undesirable: `"large_outer_monorepo/our_utils/our_gui_helpers/"`
 - Instead of something like:
     - desirable: `"large_outer_monorepo/subprojects/gui_project_01/our_utils/our_gui_helpers/"`

--------------------------------------------------------------------------------
### explicit-visibility-on-properties ###

Whenever possible, deliberately choose and explicitly state one of `PRIVATE`,
`PUBLIC`, or `INTERFACE` for each property you set on a target.

In particular, always set `PRIVATE` (or other choice as appropriate) when using
the commands `target_link_libraries` and `target_compile_options`.

For full details, consult CMake docs or the "bible" mentioned above.

As a quick explanation, `PRIVATE` will constrain library dependencies (such as
`-pthread`) to only those commands that compile your target, whereas `PUBLIC`
causes those choices to propagate outward to any targets that depend on your
target. `PUBLIC` will at times be the correct decision. If you are unsure, start
with `PRIVATE` and then adjust as needed.

--------------------------------------------------------------------------------

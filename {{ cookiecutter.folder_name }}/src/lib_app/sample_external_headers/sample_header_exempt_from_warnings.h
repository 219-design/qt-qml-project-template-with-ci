//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//

#ifndef PROJ_SAMPLE_HEADER_EXEMPT_FROM_WARNINGS_H
#define PROJ_SAMPLE_HEADER_EXEMPT_FROM_WARNINGS_H

/*
  This messy header file exists to help demonstrate the purpose of:
      - "src/lib_app/quarantined_awaiting_warning_fixes.h"

  If you try to add a pound-include of this messy header in one of the other
  source files of this project, the BUILD WILL FAIL due to the compiler warnings
  that are triggered by this header (combined with our use of warnings-as-errors).

  However, the workaround is to instead use the following pound-include:
      #include "src/lib_app/quarantined_awaiting_warning_fixes.h"

  This is useful when you must include headers from a legacy code project that
  your co-workers are also actively editing (and therefore you need to
  continually bring in those changes and rebuild), and when that legacy code
  base has not yet been made warning-free.
 */
{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
struct SampleHelper
{
    int member = 0;

    int Test( int argument ) // [-Werror=unused-parameter]
    {
        // [-Werror=return-type]
    }

    void ShadowTest()
    {
        int member = 1; // [-Werror=shadow]
    }

    static constexpr double NUM = 3.33333;
    bool x = (bool) NUM; // [-Werror=old-style-cast]
};

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_SAMPLE_HEADER_EXEMPT_FROM_WARNINGS_H

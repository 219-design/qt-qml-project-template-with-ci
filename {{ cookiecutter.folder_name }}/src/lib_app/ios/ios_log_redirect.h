//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJECT_LIB_APP_IMPL_IOS_LOG_REDIRECT_H
#define PROJECT_LIB_APP_IMPL_IOS_LOG_REDIRECT_H

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void WhenOnIos_RerouteStdoutStderrToDeviceFilesystem();
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJECT_LIB_APP_IMPL_IOS_LOG_REDIRECT_H

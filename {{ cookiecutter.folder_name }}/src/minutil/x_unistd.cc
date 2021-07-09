#include "x_unistd.h"

#if defined( WIN32 ) || defined( _WIN32 )
#    include <windows.h>
#else
#    include <unistd.h>
#endif

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void MilliSleep( const int ms )
{
#if defined( WIN32 ) || defined( _WIN32 )
    Sleep( ms );
#else
    usleep( ms * 1000 ); // usleep takes sleep time in us (1 millionth of a second)
#endif
}
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

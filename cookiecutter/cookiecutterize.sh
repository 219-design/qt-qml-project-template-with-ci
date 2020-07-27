#!/bin/bash
# This script turns the 219 Design starter Qt project into a cookiecutter template

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
cd $CUR_GIT_ROOT

# Escapes literal {{ in the code. See https://jinja.palletsprojects.com/en/2.11.x/templates/#escaping
grep -l -R --binary-files=without-match "{{" src .github | xargs sed -i "s/{{/{{ '{{' }}/g"

# Modifies the copyright
git mv LICENSE.txt 219Design.LICENSE.txt
grep -l -E -R --binary-files=without-match 'Copyright \(c\) [0-9]{4}, 219 Design, LLC' src |\
    xargs sed -Ei -e "s/[0-9]{4}, 219 Design, LLC/{{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})/g"\
    -e "s#https://www.219design.com#{{ cookiecutter.website }}#g"
find src/ -type f | xargs sed -i "/Software | Electrical | Mechanical | Product Design/d"

## Sets a custom namespace for the project
## Unfortunately sed doesn't play nicely with multi-line matches. Perl to the rescue
FILE_LIST=$(grep -l -E -R --binary-files=without-match '^namespace project' src)
echo "$FILE_LIST" | xargs -I ';;;' perl -0777 -i -pe "s/namespace project\n\{/{% set nslist = cookiecutter.cpp_namespace.split('::') %}\n{% for ns in nslist %}\nnamespace {{ ns }}\n{\n{% endfor %}/g" ';;;'
echo "$FILE_LIST" | xargs -I ';;;' sed -i "s#^} // namespace project#{% for ns in nslist %}\n} // namespace {{ ns }}\n{% endfor %}#g" ';;;'
grep -l -R --binary-files=without-match "project::" src | xargs sed -i "s/project::/{{ cookiecutter.cpp_namespace | replace('.', '::') }}::/g"

# Customizes the App.Desktop entry and the Window title
sed -i -e "s/Name=.*/Name={{ cookiecutter.project_name }}/g"\
    -e "/Comment=.*/d"\
    tools/AppImage/app.desktop
sed -i -e "s/Hello World/Hello {{ cookiecutter.folder_name }}/g" src/lib_app/qml/*.qml

# Finally, moves the project folder to a cookiecutter namespace
mkdir "{{ cookiecutter.folder_name }}"
rm src/lib_app/qml/images qmake.conf clang-format
git add "{{ cookiecutter.folder_name }}"
shopt -s dotglob nullglob extglob # so hidden files move, too. https://unix.stackexchange.com/q/6393/11592
git mv -k !(.gitmodules|..|.) "{{ cookiecutter.folder_name }}"/
git mv -k "{{ cookiecutter.folder_name }}"/cookiecutter/* .
git mv -k init_repo.sh "{{ cookiecutter.folder_name }}"/
rm -r "{{ cookiecutter.folder_name }}"/cookiecutter

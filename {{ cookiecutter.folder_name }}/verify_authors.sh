#!/bin/bash

#
# Copyright (c) 2022, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -euo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

function error() {
    echo $@ >& /dev/stderr
}

function missing_primary_branch() {
    error "Did you use the wrong branch?"
    git branch -a
}

PRIMARY_BRANCH=origin/master
echo "Primary branch is ${PRIMARY_BRANCH}."

trap missing_primary_branch EXIT
ancestor_commit=$(git merge-base ${PRIMARY_BRANCH} HEAD)
trap "" EXIT
echo "The most recent common ancestor commit with the primary branch is ${ancestor_commit}."

authors=$(cat AUTHORS)
git_authors=$(git shortlog -se ${ancestor_commit}..HEAD | cut -f 2)
git_committers=$(git shortlog -se --committer ${ancestor_commit}..HEAD | cut -f 2)

echo
echo "AUTHORS file lines:"
for author in $authors
do
    echo $author
done

echo
echo "git Authors:"
for git_author in $git_authors
do
    echo $git_author
done

echo
echo "git Committers:"
for git_committer in $git_committers
do
    echo $git_committer
done

echo

echo "Checking git Authors."
for git_author in $git_authors
do
    found=0
    for author in $authors
    do
        if [ "$git_author" == "$author" ]
        then
            found=1
        fi
    done

    if [ 0 -eq $found ]
    then
        error "Failed to find git author \"${git_author}\" in AUTHORS file."
        error "Note that \`git commit --amend\` is not sufficient to change a commit author."
        exit -1
    fi
done
echo "Verified git Authors."

echo "Checking git Committers."
for git_committer in $git_committers
do
    found=0
    for author in $authors
    do
        if [ "$git_committer" == "$author" ]
        then
            found=1
        fi
    done

    if [ 0 -eq $found ]
    then
        error "Failed to find git committer \"${git_committer}\" in AUTHORS file."
        error "Note that you can't see the committer with \`git log\` but can with \`git log --pretty=full\`."
        exit -1
    fi
done
echo "Verified git Committers."

echo "Contributions verified."

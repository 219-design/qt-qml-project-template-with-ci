if(MSVC)

  # '/EHs', catch C++ exceptions AND assume that extern C functions may also
  # throw an exception
  #
  # '/Gy', enable function-level linking, required for for Edit and Continue. We
  # may not need this, but there's a comment in the documentation about C++
  # member functions not being "packaged" without this.
  #
  # '/FC',  use full pathnames in diagnostics (full paths will show up in "Error
  # List" in visual studio)
  list(
    APPEND
    MYAPP_COMPILER_WARNINGS
    "/EHs"
    "/Gy"
    "/FC"
    "/MP"
    "/W4"
    "/Wall"
  )

  # Best way I found to replicate what our qmake-based build always "magically"
  # provided in the '*.pro' files as QT_INSTALL_HEADERS
  execute_process(
    COMMAND qmake -query QT_INSTALL_HEADERS
    OUTPUT_VARIABLE QTDIR_FOR_WARNING_EXEMPTION
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  string(
    REGEX
    REPLACE "/"
            "\\\\"
            QTDIR_FOR_WARNING_EXEMPTION
            ${QTDIR_FOR_WARNING_EXEMPTION}
  )

  # https://forum.qt.io/topic/124893/msvc-code-analysis-throwing-warnings-for-qt-framework-code
  # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
  #
  # The "SHELL:" thing is a semi-desperate workaround for yet another cmake WTF.
  # The goal of the workaround is to thwart the cmake behavior of de-duplicating
  # flags passed to target_compile_options. If "/external:I" is de-duplicated,
  # our overall windows compiler command is WRONG, because "/external:I" needs
  # to reappear in front of every system path we want to mark as external. Note
  # that each time we use "/external:I" we must use a unique number of blank
  # spaces after the "SHELL:" prefix. Differentiating (isolating, uniquely
  # defining) each token based on differing counts of blank spaces is key to the
  # workaround.
  #
  # Nice-to-have: Considering that many of the "/wdNNNN" suppressions are for
  # the sake of compiling Qt moc generated code as part of our libraries where
  # we use Qt moc macros, there is probably a way for us to put all the moc
  # generated files into a separate library or 'file group' of some kind and
  # only apply the suppressions there.
  #
  # Per microsoft docs on cl.exe:
  #
  # CL [option...] file... [lib...] [@command-file] [/link link-opt...]
  #
  # Order of the options is supposed to never (or rarely?) matter, but I
  # observed issues until the "/experimental" items were moved to the bottom and
  # until "/WX" was moved after the "/wdNNNN" items.
  list(
    APPEND
    MYAPP_COMPILER_WARNINGS
    "-std:c++17"
    "/wd4464"
    "/wd4514"
    "/wd4625"
    "/wd4626"
    "/wd4668"
    "/wd4710"
    "/wd4711"
    "/wd4820"
    "/wd5026"
    "/wd5027"
    "/wd5045"
    "/WX"
    "/experimental:external"
    "/external:W0"
    "SHELL:/external:I"
    "$ENV{WindowsSdkDir}"
    "SHELL: /external:I"
    "${QTDIR_FOR_WARNING_EXEMPTION}"
    "SHELL:  /external:I"
    "${PROJECT_SOURCE_DIR}/src/assert"
    "SHELL:   /external:I"
    "$ENV{VSINSTALLDIR}"
  )

endif() # if (MSVC) ... this whole file is MSVC-only

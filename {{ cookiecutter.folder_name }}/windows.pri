win_build_folder_subdir=""

win32 {

    CONFIG(debug, debug|release) {
        win_build_folder_subdir="/debug/"
    } else {
        win_build_folder_subdir="/release/"
    }

    QMAKE_CXXFLAGS_WARN_ON -= -W3 # get rid of Qt default

    QMAKE_CXXFLAGS += "\
       /EHs \
       /Gy \
       /FC \
       /MP \
       /W4 \
       /Wall \
       /WX \
       "

    # '/EHs', # catch C++ exceptions AND assume that extern C functions may also throw an exception
    # '/Gy', # enable function-level linking, required for for Edit and Continue.  We may not need this, but there's a comment in the documentation about C++ member functions not being "packaged" without this.
    # '/FC', # use full pathnames in diagnostics (full paths will show up in "Error List" in visual studio

    # https://forum.qt.io/topic/124893/msvc-code-analysis-throwing-warnings-for-qt-framework-code
    # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
    QMAKE_CXXFLAGS += "\
       /experimental:external \
       /external:W0 \
       /external:I $$[QT_INSTALL_HEADERS] \
       /external:I $$shell_quote($$(WindowsSdkDir)) \
       /wd4464 \
       /wd4514 \
       /wd4625 \
       /wd4626 \
       /wd4668 \
       /wd4710 \
       /wd4711 \
       /wd4820 \
       /wd5026 \
       /wd5027 \
       /wd5045 \
       /wd5204 \
       "
}

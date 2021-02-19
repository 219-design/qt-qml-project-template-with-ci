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
       /W4 \
       /Wall \
       /WX \
       "

    # '/EHs', # catch C++ exceptions AND assume that extern C functions may also throw an exception
    # '/Gy', # enable function-level linking, required for for Edit and Continue.  We may not need this, but there's a comment in the documentation about C++ member functions not being "packaged" without this.
    # '/FC', # use full pathnames in diagnostics (full paths will show up in "Error List" in visual studio

    # For now, just disable warnings coming from Qt headers (and googletest headers)
    QMAKE_CXXFLAGS += "\
       /wd4365 \
       /wd4464 \
       /wd4571 \
       /wd4619 \
       /wd4625 \
       /wd4626 \
       /wd4668 \
       /wd4710 \
       /wd4711 \
       /wd4820 \
       /wd4946 \
       /wd5026 \
       /wd5027 \
       /wd5039 \
       /wd5045 \
       /wd5219 \
       "
}

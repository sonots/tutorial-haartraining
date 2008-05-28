lib_LIBRARIES = libcvhaartraining.a

bin_PROGRAMS = opencv-haartraining opencv-createsamples opencv-performance

ALL_CV_LIBS =                                       \
    libcvhaartraining.a                             \
    $(top_builddir)/otherlibs/highgui/libhighgui.la \
    $(top_builddir)/cv/src/libcv.la                 \
    $(top_builddir)/cxcore/src/libcxcore.la

libcvhaartraining_a_SOURCES = \
    cvboost.cpp           \
    cvhaarclassifier.cpp  \
    cvhaartraining.cpp    \
    cvcommon.cpp          \
    cvsamples.cpp

opencv_haartraining_SOURCES = haartraining.cpp
opencv_haartraining_LDADD = $(ALL_CV_LIBS)

opencv_createsamples_SOURCES = createsamples.cpp
opencv_createsamples_LDADD = $(ALL_CV_LIBS)

opencv_performance_SOURCES = performance.cpp
opencv_performance_LDADD = $(ALL_CV_LIBS)

noinst_HEADERS = cvclassifier.h _cvhaartraining.h _cvcommon.h

EXTRA_DIST =

INCLUDES =                                \
    -I$(top_srcdir)/cxcore/include    \
    -I$(top_srcdir)/cv/include        \
    -I$(top_srcdir)/otherlibs/highgui \
    -I$(srcdir)/../include            \
    -I.

#CXX=@CXXOPENMP@

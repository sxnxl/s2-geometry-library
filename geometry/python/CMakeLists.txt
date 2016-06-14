project(s2-python CXX)
set(PROJECT_NAME s2-python)

cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
add_definitions(-DS2_USE_EXACTFLOAT -DHASH_NAMESPACE=std)
set_property(GLOBAL PROPERTY CXX_STANDARD 11)
set_property(GLOBAL PROPERTY CXX_STANDARD_REQUIRED ON)

Find_Package(SWIG REQUIRED)
Find_Package(PythonLibs $ENV{TRAVIS_PYTHON_VERSION} REQUIRED)
Find_Package(PythonInterp $ENV{TRAVIS_PYTHON_VERSION} REQUIRED)

include(UseSWIG)

include_directories(
	../s2
	..
	${PYTHON_INCLUDE_PATH}
)

set_source_files_properties(s2.i PROPERTIES CPLUSPLUS ON)
swig_add_module(s2 python s2.i)
swig_link_libraries(s2 s2 s2cellid s2util ${PYTHON_LIBRARIES})

IF($ENV{TRAVIS_PYTHON_VERSION} MATCHES "2.7") 
    set(PYTHON_COMMAND python2.7)
ELSE($ENV{TRAVIS_PYTHON_VERSION} MATCHES "2.7") 
    set(PYTHON_COMMAND python)
ENDIF($ENV{TRAVIS_PYTHON_VERSION} MATCHES "2.7") 

execute_process(COMMAND ${PYTHON_COMMAND} -c "from __future__ import print_function; from distutils.sysconfig import get_python_lib; from os.path import join; print (join(get_python_lib(), 's2'))" OUTPUT_VARIABLE PYTHON_SITE_PACKAGES OUTPUT_STRIP_TRAILING_WHITESPACE)

install(TARGETS _s2 DESTINATION ${PYTHON_SITE_PACKAGES})
install(FILES __init__.py s2.py DESTINATION ${PYTHON_SITE_PACKAGES})


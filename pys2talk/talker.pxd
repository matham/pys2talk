
include "s2_defines.pxi"

from pys2talk.timer cimport Timer


cdef class Talker(object):

    cdef public Timer timer

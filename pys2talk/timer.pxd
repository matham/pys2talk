
include 's2_defines.pxi'


cdef class Timer(object):

    cdef LARGE_INTEGER llFrequency
    cdef LARGE_INTEGER llStart

    cdef void ResetTimer(self) nogil
    cdef double Seconds(self) nogil

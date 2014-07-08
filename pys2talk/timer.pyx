

__all__ = ('Timer', )


from pys2talk.exception import TalkerException


cdef class Timer(object):

    def __cinit__(self, **kwargs):
        self.ResetTimer()

    cdef void ResetTimer(self) nogil:
        QueryPerformanceFrequency(&self.llFrequency)
        QueryPerformanceCounter(&self.llStart)

    cdef double Seconds(self) nogil:
        cdef LARGE_INTEGER llTime
        QueryPerformanceCounter(&llTime)

        if llTime.QuadPart < self.llStart.QuadPart:   # It overflowed
            llTime.QuadPart = (llTime.QuadPart +
                               (LLONG_MAX - self.llStart.QuadPart))
        else:
            llTime.QuadPart = llTime.QuadPart - self.llStart.QuadPart
        return llTime.QuadPart * (1.0 / self.llFrequency.QuadPart)  # to secs

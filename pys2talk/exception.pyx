''' The PyS2Talk exception module.
'''

__all__ = ('TalkerException', )


include 's2_defines.pxi'


from cpython.ref cimport PyObject

cdef extern from "Python.h":
    PyObject* PyString_FromString(const char *v)


cdef dict err_codes = {TKE_BAD_PARAMS: 'Unusable parameter values', }
''' The talkers error codes.
'''


class TalkerException(Exception):
    '''
    Talker exception class. Accepts Widnows/Spike2 error codes and/or error
    messages. It converts error codes to messages where possible.

    :Parameters:
        `win`: int
            a window error code. Can be None if only `msg` is provided.
        `s2`: int
            a talker error code. Can be None if only `msg` is provided.
        `msg`: str
            a (optional) error message.

    The error codes Barst returns is in this range. This class attempts to
    convert the code into an error messages as well as convert the mapped code
    back into it's original code (i.e. the inverse of the table above).

    '''

    error_value = 0
    '''
    The actual barst error code. Defaults to zero.
    '''
    error_source = ''
    '''
    The source of the error. E.g. win.
    '''

    def __init__(self, int win=0, int s2=0, msg='', **kwargs):
        cdef LPSTR win_msg
        cdef DWORD res
        cdef object result = ''
        cdef int value = 0

        if s2:
            if s2 in err_codes:
                result = err_codes[s2]
            else:
                result = 'Unknown error code'
            self.error_source = 'Talker'
            value = s2
        elif win:
            res = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                NULL, <DWORD>win, 0, <LPSTR>&win_msg, 0, NULL)
            if res:
                result = <object>PyString_FromString(win_msg)
                LocalFree(win_msg)
            else:
                result = 'Unknown Windows error code'
            self.error_source = 'Windows'
            value = win
        else:
            result = 'Unknown error code'

        if msg:
            if value:
                result = '{}: {} [{}, error code {}]'.format(self.error_source,
                    msg, result, value)
            else:
                result = '{}: {}'.format(self.error_source, msg)
        else:
            result = '{}: {}, error code {}'.format(self.error_source, result,
                                                    value)
        self.error_value = value
        super(TalkerException, self).__init__(self, result, **kwargs)

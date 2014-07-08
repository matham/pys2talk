'''Defines all the structs and types used with pys2talk.
'''

from libc.stdint cimport int64_t, uint64_t, int32_t, uint32_t, uint16_t,\
int16_t, uint8_t, int8_t, uintptr_t
from libcpp cimport bool


cdef extern from * nogil:
    ctypedef unsigned long DWORD
    ctypedef unsigned long ULONG
    ctypedef int BOOL
    ctypedef void *HANDLE
    ctypedef char *LPSTR
    ctypedef const char *LPCSTR
    ctypedef DWORD *LPDWORD
    ctypedef const void *LPCVOID
    ctypedef void *LPVOID
    ctypedef char *va_list
    ctypedef HANDLE HLOCAL

    struct _SECURITY_ATTRIBUTES:
        pass
    ctypedef _SECURITY_ATTRIBUTES SECURITY_ATTRIBUTES
    ctypedef _SECURITY_ATTRIBUTES *LPSECURITY_ATTRIBUTES
    struct _OVERLAPPED:
        pass
    ctypedef _OVERLAPPED OVERLAPPED
    ctypedef _OVERLAPPED *LPOVERLAPPED
    union _LARGE_INTEGER:
        pass
    ctypedef _LARGE_INTEGER LARGE_INTEGER

    DWORD OPEN_EXISTING
    DWORD ERROR_PIPE_BUSY
    DWORD PIPE_READMODE_MESSAGE
    DWORD PIPE_WAIT
    DWORD GENERIC_READ
    DWORD GENERIC_WRITE
    DWORD FORMAT_MESSAGE_ALLOCATE_BUFFER
    DWORD FORMAT_MESSAGE_FROM_SYSTEM
    DWORD FORMAT_MESSAGE_IGNORE_INSERTS
    HANDLE INVALID_HANDLE_VALUE

    HANDLE __stdcall CreateFileA(LPCSTR lpFileName, DWORD dwDesiredAccess,
         DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
         HANDLE hTemplateFile)
    DWORD __stdcall GetLastError()
    BOOL __stdcall WaitNamedPipeA(LPCSTR lpNamedPipeName, DWORD nTimeOut)
    BOOL __stdcall SetNamedPipeHandleState(HANDLE hNamedPipe, LPDWORD lpMode,
                                           LPDWORD lpMaxCollectionCount,
                                           LPDWORD lpCollectDataTimeout)
    BOOL __stdcall CloseHandle(HANDLE hObject)
    BOOL __stdcall WriteFile(HANDLE hFile, LPCVOID lpBuffer,
        DWORD nNumberOfBytesToWrite, LPDWORD lpNumberOfBytesWritten,
        LPOVERLAPPED lpOverlapped)
    BOOL __stdcall ReadFile(HANDLE hFile, LPVOID lpBuffer,
        DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead,
        LPOVERLAPPED lpOverlapped)
    DWORD __stdcall FormatMessageA(DWORD dwFlags, LPCVOID lpSource,
        DWORD dwMessageId, DWORD dwLanguageId, LPSTR lpBuffer, DWORD nSize,
        va_list *Arguments)
    HLOCAL __stdcall LocalFree(HLOCAL hMem)


cdef extern from "s2talk.h":
    int TALK_SPEC_VER
    bytes TALK_MASTER_PIPE
    bytes TALK_TALKER_PIPE
    DWORD TALK_TALKER_BSIZE
    DWORD TALK_MAX_PKT

    DWORD TALK_NAME_SZ
    DWORD TALK_DESC_SZ
    DWORD TALK_CTITL_SZ
    DWORD TALK_CUNIT_SZ

    DWORD TCT_ADC
    DWORD TCT_EVENT
    DWORD TCT_MARKER
    DWORD TCT_ADCMARK
    DWORD TCT_REALMARK
    DWORD TCT_TEXTMARK
    DWORD TCT_REALWAVE
    DWORD TCT_LEVEL

    DWORD TKS_DISCONNECT
    DWORD TKS_IDLE
    DWORD TKS_ACTIVE

    DWORD TKC_TALKERCONNECT
    DWORD TKC_GETINFO
    DWORD TKC_GETCHAN
    DWORD TKC_GETCONFIG
    DWORD TKC_SETCONFIG
    DWORD TKC_LOCALCONFIG
    DWORD TKC_DLGINFO
    DWORD TKC_DLGITEM
    DWORD TKC_DLGGET
    DWORD TKC_DLGSET
    DWORD TKC_SAMPLECLEAR
    DWORD TKC_ENABLECHAN
    DWORD TKC_QUERYREADY
    DWORD TKC_SAMPLESTART
    DWORD TKC_TALKERCLOSE
    DWORD TKC_SAMPLESTOP
    DWORD TKC_TALKERIDLE
    DWORD TKC_TALKERDATA
    DWORD TKC_TALKERPROBLEM
    DWORD TKC_SAMPLEKEY
    DWORD TKC_TALKERMDATA
    DWORD TKC_DRIFTINFO

    DWORD TKC_RESPONSE_BIT
    DWORD TKC_ERROR_BIT

    DWORD TKC_EXTRA_TIMEOUT

    DWORD TKE_BAD_PACKET
    DWORD TKE_BAD_VERSION
    DWORD TKE_BAD_COMMAND
    DWORD TKE_BAD_CHAN
    DWORD TKE_TIMEOUT
    DWORD TKE_NO_CONFIG
    DWORD TKE_BAD_CONFIG
    DWORD TKE_FAILURE
    DWORD TKE_BAD_PARAMS

    struct TalkPacket:
        int nSize
        int nCode
        int nParam1
        int nParam2
        double dParam1
        double dParam2
        char szParam[256]

    struct TalkerInfo:
        int nSize
        int nCode
        int nChans
        int nVer
        double dParam1
        double dParam2
        char szDesc[256]
        char szName[TALK_NAME_SZ]
        int nVerComp
        int nConfigID
        int nFlags
        int nSpare[32]

    DWORD TKF_LOCCONF
    DWORD TKF_REMOTE
    DWORD TKF_SPCONF
    DWORD TKF_NODRDB

    struct TalkerChanInfo:
        int nSize
        int nCode
        int nChan
        int nParam2
        double dParam1
        double dParam2
        char szDesc[256]
        int nType
        int nFlags
        char szTitle[TALK_CTITL_SZ]
        char szUnits[TALK_CUNIT_SZ]
        int nCount
        double dScale
        double dOffset
        int nTrig
        int nTrace
        double dIRate
        double dWRate
        double dMax
        double dMin
        int nSpare[32]

    DWORD TCF_DELETEBAD
    DWORD TCF_S2TIMED
    DWORD TCF_MYTIME
    DWORD TCF_MYRATE
    DWORD TCF_LCLOCK

    struct TalkerDlgInfo:
        int nSize
        int nCode
        int nItems
        int nParam2
        double dWide
        double dHigh
        char szTitle[256]
        int nSpare[32]

    struct TalkerDlgItem:
        int nSize
        int nCode
        int nItem
        int nType
        double dX
        double dY
        char szText[256]
        double dWide
        double dHigh
        double dLo
        double dHi
        double dSpin
        int nPre
        char szList[1024]
        char szLegal[256]
        int nSpare[32]

    DWORD TDT_TEXT
    DWORD TDT_GROUP
    DWORD TDT_CHECK
    DWORD TDT_INT
    DWORD TDT_LIST
    DWORD TDT_REAL
    DWORD TDT_STRING

    struct TalkerDriftInfo:
        int nSize
        int nCode
        int nFlags
        int nDrBf
        double dSDDump
        double dSDUse
        char szParam[256]
        int nDiffAvg
        int nSlopeAcc
        int nSlopeAvg
        int nSpare[32]

    struct TalkerData:
        int nSize
        int nCode
        int nChan
        int nItems
        double dStart
        double dNow
        int nFlags
        int nItemSize
        int nSpare[8]

    struct TalkerMData:
        int nSize
        int nCode
        int nBlocks
        int nFlags
        double dNow
        double dParam2
        int nSpare[8]

    struct TalkerMChan:
        int nChan
        int nFlags
        int nItems
        int nItemSize
        double dStart
        int nSpare[4]

    DWORD TDF_CONTIG
    DWORD TDF_FLUSH
    DWORD TDF_RISING

    struct TalkDataMarker:
        double dTime
        long lMark

    struct TalkDataRealMark:
        double dTime
        long lMark
        double adVals[64]

    struct TalkDataTextMark:
        double dTime
        long lMark
        char szText[80]

    struct TalkDataAdcMark:
        double dTime
        long lMark
        short asVals[1024]

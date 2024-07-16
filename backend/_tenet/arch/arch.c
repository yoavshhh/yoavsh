#include "arch.h"

#if   defined(CORE_X86_64)
    #include "x86_64.h"
#elif defined(CORE_X86_32)
    #include "x86_32.h"
#else

    // fallback to this machine's architecture
    #include <boost/predef.h>
    #if defined(BOOST_ARCH_X86)
        #if   defined(BOOST_ARCH_X86_64)
            #include "x86_64.h"
        #elif defined(BOOST_ARCH_X86_32)
            #include "x86_32.h"
        #else
            #error "architecture not supported"
        #endif // BOOST_ARCH_X86_*
    #else
        #error "architecture not supported"
    #endif // BOOST_ARCH_*

#endif // CORE_*
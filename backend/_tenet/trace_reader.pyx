#!python
# distutils: include_dirs=deps/predef/include/

cdef extern from "arch/arch.h":
    int POINTER_SIZE

from libc.stdlib cimport malloc, free
from libc.stdint cimport uint8_t, uint32_t, uint64_t
if POINTER_SIZE == 4:
    from libc.stdint cimport uint32_t as tsize_t
elif POINTER_SIZE == 8:
    from libc.stdint cimport uint64_t as tsize_t

cdef:
    struct _registers_x86_64:
        uint64_t rax
        uint64_t rbx
        uint64_t rcx
        uint64_t rdx
        uint64_t rbp
        uint64_t rsp
        uint64_t rsi
        uint64_t rdi
        uint64_t r8
        uint64_t r9
        uint64_t r10
        uint64_t r11
        uint64_t r12
        uint64_t r13
        uint64_t r14
        uint64_t r15
        uint64_t rip

    enum access_type:
        ACCESS_READ
        ACCESS_WRITE

    struct mem_access:
        tsize_t addr
        access_type access_type
        tsize_t len
        char* value

    struct context:
        size_t timepoint
        _registers_x86_64 *regs
        mem_access mem_access

    void init_context(context* self):
        self.timepoint = 0
    
    struct pst_node:
        void* val
        pst_node *l
        pst_node *r
    
    void init_pst_node(pst_node* self, void* val):
        self.val = val
        self.l = NULL
        self.r = NULL
    
    class memory_layout:
        cdef:
            readonly tsize_t size
            pst_node* nodes
            context* contexts

        def __cinit__(self, tsize_t size):
            self.size = size
            self.nodes = <pst_node *>malloc((sizeof(pst_node)) * size)
            if self.nodes is NULL:
                raise MemoryError("malloc failed")
            self.contexts = <context *>malloc((sizeof(context)) * size)
            if self.contexts is NULL:
                raise MemoryError("malloc failed")
            
            for i in range(self.size):
                init_context(&self.contexts[i])
                init_pst_node(&self.nodes[i], &self.contexts[i])

        def __dealloc__(self):
            if self.contexts is not NULL:
                free(self.contexts)
            if self.nodes is not NULL:
                free(self.nodes)

        def get_timepoint(self, tsize_t idx):
            if idx >= self.size:
                raise ValueError("index out of range")
            return (<context*>self.nodes[idx].val).timepoint


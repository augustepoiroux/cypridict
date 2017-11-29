# the pxd files in cython work like the header files - they
# contain declaration which are only included by cython modules.
# In addition, if the cython needs to call functions from the C libraries,
# pxd files are the best place to include the C headers, and import
# the function or type declarations.

# in order to use the uint32_t integer type, just import from the
# libc.stdint pxd file, which is already declared by cython.
# NOTE THAT if uint32_t is not imported explicitly, then the first parameter
# in the following function maxheap_create(uint32_t, ...) would be regarded as
# a normal python parameter, but not a parameter with uint32_t type.
from libc.stdint cimport uint32_t

# when import a custom header file, remember to add a 'extern' keyword.
# And it's OK just to declare the struct name, but omit the details of
# struct itself, because cython does NOT care that.
cdef extern from "maxheap.h":
    ctypedef struct maxheap_t:
        pass

    # Just copy the function or function pointer's declarations as specified
    # in the C header file.
    ctypedef int (*compare)(void *, void *)
    ctypedef void *(*copy)(void *, void *)
    ctypedef void (*swap)(void *, void *)
    maxheap_t *maxheap_create(uint32_t, size_t, compare, copy, swap)
    void    maxheap_free(maxheap_t*)
    int     maxheap_push(maxheap_t*, void *)
    void    *maxheap_pop(maxheap_t*)
    void    *maxheap_min(maxheap_t*)


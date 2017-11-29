cimport cymaxheap  # import the declaration in cymaxheap.pxd
from libc.stdint cimport uint32_t  # import the integer type from C

# define a struct that would be stored in the heap.
# NOTE THAT all structs, defined in pyx files, would not be exported
# with this module. Rather, as it serves as the parameter type of the
# exported class, MaxHeap in this case, it could be substituted by
# a python dictionary object wherever it's required.
# e.g. heap.push({"id":1, "price":10.0})
cdef struct good_t:
    int id
    long double price

# define the required C functions for comparison, copy and swap of good_t
cdef int good_cmp(void *self, void *other):
    cdef good_t *pself = <good_t *>self
    cdef good_t *pother = <good_t *>other
    # NOTE THAT <*type*> is the special form for coercion in cython
    if pself.price < pother.price:
        return 1
    elif pself.price > pother.price:
        return -1
    else:
        return 0

cdef void *good_copy(void *self, void *other):
    # NOTE THAT cython does NOT support unary operator * in C,
    # use some_pointer[0], instead of *some_pointer to reference
    # the pointer
    (<good_t *>self)[0] = (<good_t *>other)[0]
    return self

cdef void good_swap(void *self, void *other):
    if self == other:
        return
    cdef good_t temp = (<good_t *>self)[0]
    (<good_t *>self)[0] = (<good_t *>other)[0]
    (<good_t *>other)[0] = temp
    return


cdef class MaxHeap:
    """ Minimum heap container, a wrapper based on an implementation in C.

    >>>from maxheap import MaxHeap
    >>>heap=MaxHeap()
    >>>heap.push({"id":1, "price":1.0})
    >>>heap.peek()
    {"id":1, "price":1.0}
    >>>item=heap.pop()
    item == {"id":1, "price":1.0}
    >>>heap.peek()
    raise IndexError
    >>>heap.pop()
    raise IndexError
    """
    cdef cymaxheap.maxheap_t *_c_maxheap

    # cython garantees that __cinit__ would be called when a new
    # MaxHeap object is instantiated. Likewise, when this object
    # is no longer referenced by any others, __dealloc__ would be
    # called before this object is reclaimed by python runtime
    def __cinit__(self):
        cdef uint32_t initial_number = 0
        self._c_maxheap = cymaxheap.maxheap_create(initial_number,
                            sizeof(good_t),
                            <cymaxheap.compare>good_cmp,
                            <cymaxheap.copy>good_copy,
                            <cymaxheap.swap>good_swap)
        if self._c_maxheap is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._c_maxheap is not NULL:
            cymaxheap.maxheap_free(self._c_maxheap)

    # since __cinit__ has already created the heap itself, no further
    # operations need to be done in __init__
    def __init__(self):
        pass

    cdef void _c_push(self, void *item):
        cymaxheap.maxheap_push(self._c_maxheap, item)

    cpdef push(self, good_t item):
        self._c_push(&item)

    cdef good_t * _c_pop(self):
        return <good_t*>cymaxheap.maxheap_pop(self._c_maxheap)

    # NOTE THAT by defining a function through 'def', it means it's a
    # regular python function. Therefore, whenever it encounters an exception
    # during the running of function, the exception would be automatically
    # propagated to the caller by cython. Howerver, if define a function
    # through 'cdef' or 'cpdef', in order to to propagate exception, you have to
    # declare it explcitely by 'except?/*/-1' statement, otherwise, the exception
    # would be ignored by default, and just posts a warning in the runtime
    def pop(self):
        cdef good_t *data = self._c_pop()
        if data is NULL:
            raise IndexError("Can not pop from an empty heap.")
        else:
            return data[0]

    cdef good_t * _c_peek(self):
        return <good_t*>cymaxheap.maxheap_min(self._c_maxheap)

    def peek(self):
        cdef good_t *data = self._c_peek()
        if data is NULL:
            raise IndexError("Can not peek from an empty heap.")
        else:
            return data[0]

#cython: initializedcheck=False, nonecheck=False
cimport cypridict  # import the declaration in cypridict.pxd
from libc.stdint cimport uint32_t  # import the integer type from C

# define a struct that would be stored in the heap.
# NOTE THAT all structs, defined in pyx files, would not be exported
# with this module. Rather, as it serves as the parameter type of the
# exported class, MaxHeap in this case, it could be substituted by
# a python dictionary object wherever it's required.
# e.g. heap.push({"id":1, "priority":10.0})
cdef struct good_t:
	int id
	long double priority

# define the required C functions for comparison, copy and swap of good_t
cdef int good_cmp(void *self, void *other):
	cdef good_t *pself = <good_t *>self
	cdef good_t *pother = <good_t *>other
	# NOTE THAT <*type*> is the special form for coercion in cython
	if pself.priority < pother.priority:
		return 1
	elif pself.priority > pother.priority:
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


cdef class priority_dict:

	cdef cypridict.maxheap_t *_c_maxheap
	cdef unsigned int length
	cdef dict priorities

	# cython guarantees that __cinit__ would be called when a new
	# MaxHeap object is instantiated. Likewise, when this object
	# is no longer referenced by any others, __dealloc__ would be
	# called before this object is reclaimed by python runtime
	def __cinit__(self):
		self._create_heap()

	def __dealloc__(self):
		if self._c_maxheap is not NULL:
			cypridict.maxheap_free(self._c_maxheap)

	def __init__(self, priorities={}):
		self.length = 0
		self.priorities = priorities
		if self.priorities != {}:
			self._rebuild_heap()

	cdef _create_heap(self):
		cdef uint32_t initial_number = 0
		self._c_maxheap = cypridict.maxheap_create(initial_number,
							sizeof(good_t),
							<cypridict.compare>good_cmp,
							<cypridict.copy>good_copy,
							<cypridict.swap>good_swap)
		if self._c_maxheap is NULL:
			raise MemoryError()

	cdef _dealloc_heap(self):
		if self._c_maxheap is not NULL:
			cypridict.maxheap_free(self._c_maxheap)

	cdef _rebuild_heap(self):
		self._dealloc_heap()
		self._create_heap()
		cdef tuple item
		cdef good_t data
		for item in self.priorities.iteritems():
			data = {'id': item[0], 'priority': item[1]}
			self._c_push(&data)
		self.length = len(self.priorities)

	cdef void _c_push(self, void *item):
		cypridict.maxheap_push(self._c_maxheap, item)

	def __setitem__(self, key, val):
		self.priorities[key] = val
		cdef good_t item = {'id': key, 'priority': val}
		if self.length < 2*len(self.priorities):
			self._c_push(&item)
		else:
			# When the heap grows larger than 2 * len(self), we rebuild it
			# from scratch to avoid wasting too much memory.
			self._rebuild_heap()
		self.length += 1

	cdef good_t * _c_pop(self):
		return <good_t*>cypridict.maxheap_pop(self._c_maxheap)

	def pop(self):
		cdef good_t *data = self._c_pop()
		if data is NULL:
			return -1
		while (data[0].id not in self.priorities) or (self.priorities[data[0].id] != data[0].priority):
			data = self._c_pop()
			if data is NULL:
				return -1
		self.length -= 1
		del self.priorities[data.id]
		return data[0].id

	cdef good_t * _c_peek(self):
		return <good_t*>cypridict.maxheap_max(self._c_maxheap)

	def peek(self):
		cdef good_t *data = self._c_peek()
		if data is NULL:
			return -1
		else:
			return data[0].id

	def __len__(self):
		return len(self.priorities)

	def heap_size(self):
		return self.length

	def __iter__(self):
		return self.priorities.iteritems()

	def build_dict(self, dict pris):
		self.priorities = pris
		self._rebuild_heap()

	def delete(self):
		self.priorities = {}
		if self._c_maxheap is not NULL:
			cypridict.maxheap_free(self._c_maxheap)
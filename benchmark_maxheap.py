import maxheap
from random import random
import timeit

def test():
	heap = maxheap.MaxHeap()
	for i in xrange(100000):
		heap.push({"id":i, "price":random()})
	
	while 1:
		try:
			heap.pop()
		except IndexError:
			break


t = timeit.Timer("benchmark_maxheap.test()", "import benchmark_maxheap")
print "Cython extension completed in, ", t.timeit(1), "seconds."

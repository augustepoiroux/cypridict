import pridict
from random import random
import timeit


def test():
    heap = pridict.priority_dict()
    for i in range(100000):
        heap[i] = random()

    while 1:
        item = heap.pop()
        if item == -1:
            break


t = timeit.Timer("benchmark_pridict.test()", "import benchmark_pridict")
print("Cython extension completed in, ", t.timeit(1), "seconds.")

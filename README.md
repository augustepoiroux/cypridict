# cyheap - A Whirlwind Tutorial of Cython

cyheap, a python extension of [maximum heap](http://en.wikipedia.org/wiki/Binary_heap), is originally implemented by C and wrapped to a python extension by Cython.

## Introduction

This project is intended to be a tutorial regarding HOWTO wrap a C library by Cython to be a efficient python extension.
    
cyheap consists of three parts, the maximum heap dynamic library(implemented in C), its python extension(wrapped by Cython), and the related benchmark applications. In addition to the [official tutorial](http://docs.cython.org/src/userguide/tutorial.html), it serves as a moderate example to show how to wrap a C library by Cython, e.g. how to define structures, functions, python extension and take advantage of C libraries.
    
Through introducing compile-time type information and wrapping the C library by
Cython, under the same benchmark environment, cyheap is 40+ times faster than
its counterpart, which is implemented in pure Python with same algorithm.
Further, it is almost four times faster than the heapq - the standard library of heap in Python.
    
Owing to its high performance, [numpy](http://numpy.scipy.org/) has been taking full advantage of Cython to speed up the efficience of modules for scientific computing and other time critical scenarios.
    
## Install

1. Build and install the C library
    
        $ make
        $ sudo make install

2. Setup the python extension
    
        $ python setup.py build_ext --inplace
    
3. Test the python extension
    
        $ python -m unittest test_maxheap
    
        or by the nosetests.  
    
        $ nosetests
    
Note that `sudo make install` will copy the library libmaxheap.so.1.0.0 to /usr/lib, then call the `ldconfig` automatically, finally make a symbol link libmaxheap.so to libmaxheap.so.1. So if you want to uninstall the library completely, you need to remove all these files manually.
    
## Uninstall

    $ make clean
    
## Usage

1. To run benchmarks.

    * Benchmark of python extension(maxheap)
    
        $ python benchmark_maxheap.py

    * Benchmark of pure python implementation of maxheap

        $ python benchmark_pyheap.py

    * Benchmark of heap from the python standard library-heapq
      
        $ python benchmark_heapq.py

2. To use the pyheap.

        $ python
        >>>from maxheap import MaxHeap
        >>>heap = MaxHeap()
        >>>heap.push({"id":1, "price":1.0})
        >>>item = heap.peek()
        >>>item = heap.pop()
    
    Note that peek or pop from a empty heap will raise an IndexError.
    
3. To run the test. 

    * Test the C library
    
        $ make test_array
        $ make test_heap
        $ ./test_array
        $ ./test_heap

    * Test maxheap

        $ python test_maxheap.py
      
## Structure of Project

1. C library files
    * array.h/c, maxheap.h/c, test_array.c, test_heap.c
2. Cython files
    * cymaxheap.pxd, cymaxheap.pyx, cymaxheap.c, setup.py
3. Benchmark and test files
    * benchmark_heapq/maxheap/pyheap.py, test_maxheap.py

enjoy!

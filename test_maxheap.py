import pytest
from maxheap import MaxHeap
from random import random

class TestMaxHeap(object):
    """
    Testcase of MaxHeap class.

    Usage:
        Easiest way >>>nosetests
        Or >>>python -m unittest test_maxheap
    """

    def test_peek(self):
        item = {"id":1, "price":1.0}
        heap = MaxHeap()
        heap.push(item)
        assert heap.peek() == item

    def test_pop(self):
        item_0 = {"id":1, "price":1.23456}
        item_1 = {"id":2, "price":2.34567}
        item_2 = {"id":3, "price":0.00}
        heap = MaxHeap()
        heap.push(item_0)
        heap.push(item_1)
        heap.push(item_2)
        assert heap.pop() == item_1
        assert heap.pop() == item_0
        assert heap.pop() == item_2

    def test_peek_empty_heap(self):
        heap = MaxHeap()
        pytest.raises(IndexError, heap.peek)

    def test_pop_empty_heap(self):
        heap = MaxHeap()
        pytest.raises(IndexError, heap.pop)
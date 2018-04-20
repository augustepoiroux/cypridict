import pytest
from pridict import priority_dict
from random import random

class TestPriDict(object):
	"""
	Testcase of priority_dict class.
	"""

	@pytest.fixture
	def pdict(self):
		pdict = priority_dict()
		yield pdict
		del pdict

	def test_peek(self, pdict):
		pdict[1] = 1.0
		assert pdict.peek() == 1

	def test_pop(self, pdict):
		pdict[1] = 1.23456
		pdict[2] = 2.34567
		pdict[3] = 0.00
		assert len(pdict) == 3
		assert pdict.pop() == 2
		assert len(pdict) == 2
		assert pdict.pop() == 1
		assert len(pdict) == 1
		assert pdict.pop() == 3
		assert len(pdict) == 0

	def test_replace(self, pdict):
		pdict[1] = 1.23456
		pdict[2] = 2.34567
		pdict[3] = 0.00
		pdict[1] = 3.4567
		assert pdict.pop() == 1
		assert pdict.pop() == 2
		assert pdict.pop() == 3
		assert pdict.pop() == -1

	def test_get(self, pdict):
		pdict[1] = 1.23456
		pdict[2] = 2.34567
		pdict[3] = 0.00
		py_dict = dict(pdict)
		assert py_dict[1] == 1.23456
		assert py_dict[2] == 2.34567
		assert py_dict[3] == 0.00

	def test_build(self):
		py_dict = {}
		py_dict[1] = 1.23456
		py_dict[2] = 2.34567
		py_dict[3] = 0.00
		pdict = priority_dict(py_dict)
		assert len(pdict) == 3
		assert pdict.heap_size() == 3
		assert pdict.pop() == 2
		assert pdict.pop() == 1
		assert pdict.pop() == 3

	def test_rebuild(self, pdict):
		pdict[1] = 1.23456
		pdict[2] = 2.34567
		pdict[3] = 0.00
		assert len(pdict) == 3
		assert pdict.heap_size() == 3
		pdict[1] = 2.23456
		pdict[2] = 3.34567
		pdict[3] = 4.00
		assert len(pdict) == 3
		assert pdict.heap_size() == 6
		pdict[1] = 5.23456
		assert len(pdict) == 3
		assert pdict.heap_size() == 4        
		assert pdict.pop() == 1
		assert pdict.pop() == 3
		assert pdict.pop() == 2
		assert pdict.pop() == -1

	def test_peek_empty_pdict(self, pdict):
		assert pdict.peek() == -1

	def test_pop_empty_pdict(self, pdict):
		assert pdict.pop() == -1
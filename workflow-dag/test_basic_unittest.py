"""Unit test of the CompareXComMapsOperator.
"""
import unittest

def add(x, y) -> int:
    return x + y

class TestBasic(unittest.TestCase):
    def test_addition_results_in_correct_value(self):
        self.assertEqual(2, add(1, 1))


suite = unittest.TestLoader().loadTestsFromTestCase(TestBasic)
unittest.TextTestRunner(verbosity=2).run(suite)
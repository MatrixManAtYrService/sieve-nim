import unittest

from sieve import greatestPrimeLessThan

test "answer":
  check greatestPrimeLessThan(1000000) == 999983

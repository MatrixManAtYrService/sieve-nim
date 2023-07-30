import unittest

from sieve/runtime import greatestPrimeLessThan

test "runtime answer":
  check greatestPrimeLessThan(1000000) == 999983

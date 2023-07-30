from math import sqrt, ceil
from sequtils import newSeqWith

proc greatestPrimeLessThan*(n: int): int =
  var sieve = newSeqWith(n, true)
  sieve[0] = false
  sieve[1] = false

  var js : seq[int] = @[]

  for i in 2..<int(sqrt(float(n)).ceil()):
    if sieve[i]:
      for j in countup(i*i, n-1, i):
        js.add(j)
        sieve[j] = false
      js = @[]

  for i in countdown(n-1, 2):
    if sieve[i]:
      return i

  return -1

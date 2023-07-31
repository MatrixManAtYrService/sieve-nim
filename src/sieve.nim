# I wanted two modules because I wanted to compile each part separately
# see <repo root>/scripts/compare.py, which does so.

# As far as projects that depend on sieve are concerned, only the runtime
# module matters.  This file exists so that they don't have to worry about
# the runtime/compiletime distinction.
include sieve/runtime

# Typically, you'd just put your nim code directly in this file

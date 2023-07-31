# Sieve

This is an implementation of [The Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).
Its real purpose is to serve as an example of packaging Nim code with Nix.

It's a bit of an exploration.
I'll update this readme if I become convinced that it's an exploration of a place worth going.

## Dependencies

0. [Install nix](https://nixos.wiki/wiki/Nix_Installation_Guide)

1. [Enable flakes](https://nixos.wiki/wiki/Flakes)

2. Enter a dev-shell based on the contents of [flake.nix](flake.nix) by running `nix develop`

## Things to Try:

#### Run the unit tests

```
nimble test
```

#### Compare compile and run times

```
python scripts/compare.py
```

#### Build this flake's outputs

```
nix build
```

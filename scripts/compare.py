# Forgive me for using python in a nim example repo.
#
# I had difficulty using nimscript for this because it involves manipulating
# OS processes.  You can manipulate OS processes with nim, but you can't do 
# so within a browser.  I ran into difficulty while trying to automate this 
# with nimscript because it was trying to preserve compatibility with both 
# process-oriented and browser-oriented execution.

import subprocess
import resource
from sys import stderr
from pathlib import Path
from dataclasses import dataclass


repo_root = Path(__file__).parent.parent

# for measuring compile time
base = repo_root / "src/sieve/"
runtime_module = base / "runtime.nim"
compiletime_module = base / "compiletime.nim"

# for measuring run time
test_base = repo_root / "tests"
runtime_test_module = test_base / "test_sieve_runtime.nim"
compiletime_test_module = test_base / "test_sieve_compiletime.nim"


def run(cmd: str) -> int:
    "Run the command, how long did it take?"
    start = resource.getrusage(resource.RUSAGE_CHILDREN)
    subprocess.run(cmd, check=True)
    end = resource.getrusage(resource.RUSAGE_CHILDREN)
    return end.ru_utime - start.ru_utime


@dataclass
class Times:
    name: str
    build_duration: int
    run_duration: int | None = None


def build(nimfile: Path, name: str, and_run: bool = False) -> Times:
    # assemble command
    cmd = ["nim", "compile", "-f", f"--path:{repo_root}/src", str(nimfile.absolute())]
    print("\n\n")
    print("$ " + " ".join(cmd), file=stderr)

    # time its execution
    build_duration = run(cmd)

    # src/foo.nim compiles to a binary at src/foo
    artifact = nimfile.parent / nimfile.stem
    assert artifact.exists()

    if and_run:
        run_duration = run([str(artifact.absolute())])
    else:
        run_duration = None

    return Times(
        name=name,
        build_duration=build_duration,
        run_duration=run_duration,
    )


def assert_faster(
    slower: Times, faster: Times, dimension: str = "run", factor: int = 1.1
):
    match dimension:
        case "run":
            print(slower.name, "(run)", slower.run_duration)
            print(faster.name, "(run)", faster.run_duration)
            assert slower.run_duration * factor > faster.run_duration
        case "build":
            print(slower.name, "(build)", slower.build_duration)
            print(faster.name, "(build)", faster.build_duration)
            assert slower.build_duration * factor > faster.build_duration
        case _:
            raise ValueError(f"Unexpected dimension: {dimension}")


def main():
    # doing the heavy lifting at compile time makes the compilation
    # take much longer (duh)
    print("Comparing Build Times")
    assert_faster(
        slower=build(compiletime_module, "Compiletime Seive"),
        faster=build(runtime_module, "Runtime Seive"),
        dimension="build",
    )

    # ...but it makes things much faster at runtime
    print("Comparing Run Times")
    assert_faster(
        slower=build(runtime_test_module, "Runtime Seive", and_run=True),
        faster=build(compiletime_test_module, "Compiletime Seive", and_run=True),
        dimension="run",
    )

    print("OK")


if __name__ == "__main__":
    main()

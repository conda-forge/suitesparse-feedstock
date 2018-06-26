import os
import sys
from subprocess import check_output


def check_install_name(name):
    """Verify that the install_name is correct on mac"""
    libname = "lib" + name + ".dylib"
    path = os.path.join(sys.prefix, "lib", libname)
    otool = check_output(["otool", "-L", path]).decode("utf8")
    self_line = otool.splitlines()[1]
    install_name = self_line.strip().split()[0]
    expected = "@rpath/" + libname
    assert install_name == expected, "{} != {}".format(install_name, expected)


if sys.platform == "darwin":
    for lib in (
        "amd",
        "btf",
        "camd",
        "ccolamd",
        "cholmod",
        "colamd",
        "cxsparse",
        "klu",
        "ldl",
        "rbio",
        "spqr",
        "suitesparseconfig",
        "umfpack",
    ):
        check_install_name(lib)

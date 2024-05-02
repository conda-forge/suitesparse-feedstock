import os
import re
import sys
from subprocess import check_output


def check_install_name(name):
    """Verify that the install_name is correct on mac"""
    libname = "lib" + name + ".dylib"
    path = os.path.join(sys.prefix, "lib", libname)
    otool = check_output(["otool", "-L", path]).decode("utf8")
    self_line = otool.splitlines()[1]
    install_name = self_line.strip().split()[0]
    pat = r"@rpath/lib{}\.\d+\.dylib".format(name)
    assert re.match(pat, install_name), "{} != {}".format(install_name, pat)


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

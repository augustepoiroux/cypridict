from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext

ext_modules = [
    Extension(
        name="pridict",
        sources=["cypridict.pyx", "array.c", "maxheap.c"],
    )
]

setup(
    name="Priority Dictionary build on a max heap.",
    cmdclass={"build_ext": build_ext},
    ext_modules=ext_modules,
)

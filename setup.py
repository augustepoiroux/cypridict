from setuptools import setup, Extension
from Cython.Build import build_ext

setup(
    cmdclass={'build_ext': build_ext},
    ext_modules=[
        Extension(
            name="pridict.cypridict",
            sources=[
                "pridict/cypridict.pyx",
                "pridict/array.c",
                "pridict/maxheap.c",
            ],
        )
    ],
    packages=["pridict"],
    package_data={"pridict": ["*.h", "*.pxd", "py.typed", "*.pyi"]},
)

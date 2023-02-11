from setuptools import setup, Extension, find_packages

from Cython.Distutils import build_ext

setup(
    cmdclass={"build_ext": build_ext},
    ext_modules=[
        Extension(
            name="pridict",
            sources=[
                "src/pridict/cypridict.pyx",
                "src/pridict/array.c",
                "src/pridict/maxheap.c",
            ],
        )
    ],
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    package_data={"pridict": ["*.h", "*.pxd", "py.typed", "*.pyi"]},
)

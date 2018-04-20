from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


ext_modules = [Extension("pridict",
                         ["cypridict.pyx"],
                         libraries=['maxheap'],
                         library_dirs=["/usr/local/lib"],
                         include_dirs=["/usr/local/include"],
                         runtime_library_dirs=["/usr/local/lib"])]

setup(
    name = "Priority Dictionary build on a max heap.",
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules
)
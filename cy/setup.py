from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

setup(
    ext_modules = cythonize([Extension("read_mesh", ["read_mesh.pyx"],
                                        libraries = ["thingy", "m"])
    ])
)

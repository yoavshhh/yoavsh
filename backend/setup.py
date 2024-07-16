from setuptools import Extension, setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize([
            Extension(
                name="_tenet.trace_reader",
                sources=[
                    '_tenet/*.pyx',
                    '_tenet/arch/arch.c'
                ],
            ),
        ],
        language_level="3"
    )
)
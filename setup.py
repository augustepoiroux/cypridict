from setuptools import setup, Extension, find_packages

setup(
    ext_modules=[
        Extension(
            name="pridict",
            sources=[
                "pridict/cypridict.c",
            ],
        )
    ],
    packages=["pridict"],
    # package_dir={"": "src"},
    package_data={"pridict": ["*.h", "py.typed", "*.pyi"]},
)

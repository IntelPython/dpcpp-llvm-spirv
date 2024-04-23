# SPDX-FileCopyrightText: 2020 - 2022 Intel Corporation
#
# SPDX-License-Identifier: Proprietary

import os
import os.path

from setuptools import setup
from setuptools.command.install import install

pkg_version = os.getenv("DPCPP_LLVM_SPIRV_VERSION", "0.0.0+dev")

with open(os.path.join("dpcpp_llvm_spirv", "_version.py"), "w") as fh:
    fh.write(f"__version__ = '{pkg_version}'")
    fh.write("\n")

setup(
    name="dpcpp-llvm-spirv",
    packages=[
        "dpcpp_llvm_spirv",
    ],
    version=pkg_version,
    author="Intel Corp.",
    author_email="scripting@intel.com",
    description="llvm-spirv helper",
    long_description="Python package vendoring llvm-spirv executable from Intel(R) oneAPI DPC++ compiler package",
    url="https://github.com/IntelPython/dpcpp-llvm-spirv",
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    license="Intel End User License Agreement for Developer Tools",
    package_data={
        "dpcpp_llvm_spirv": [
            "bin/llvm-spirv*",
            "lib/libonnxruntime.*",  # linux
            "bin/onnxruntime.*",  # windows
        ]
    },
)

#!/bin/bash

set -ex

echo -e "Start building dpcpp-llvm-spirv package \n"
src="${SRC_DIR}"

echo "Python: ${PYTHON}"
[ -z "${PYTHON}" ] && exit 1

export DPCPP_LLVM_SPIRV_VERSION="${PKG_VERSION}"
echo -e "Inferred DPCPP_LLVM_SPIRV_VERSION=${DPCPP_LLVM_SPIRV_VERSION}"

BUILD_ARGS="--single-version-externally-managed --record=llvm_spirv_record.txt"
WHEELS_BUILD_ARGS="-p manylinux2014_x86_64 --python-tag py$PY_VER"

pushd $src/package
echo -e "Start vendoring of llvm-spirv executable \n"
mkdir -p $src/package/dpcpp_llvm_spirv/bin
cp ${BUILD_PREFIX}/bin-llvm/llvm-spirv $src/package/dpcpp_llvm_spirv/bin/

if [ -n "${WHEELS_OUTPUT_FOLDER}" ]; then
  # Build wheel package
  $PYTHON setup.py install ${BUILD_ARGS} bdist_wheel ${WHEELS_BUILD_ARGS}
  cp dist/dpcpp_llvm_spirv*.whl ${WHEELS_OUTPUT_FOLDER}
else
  pushd $src/package
  ${PYTHON} setup.py install ${BUILD_ARGS}
  cat llvm_spirv_record.txt
fi
echo "done. \n"

popd

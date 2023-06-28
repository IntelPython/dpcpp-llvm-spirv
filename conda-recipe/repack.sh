#!/bin/bash

set -ex

echo -e "Start building dpcpp-llvm-spirv package \n"
src="${SRC_DIR}"

echo "Python: ${PYTHON}"
[ -z "${PYTHON}" ] && exit 1

export DPCPP_LLVM_SPIRV_VERSION="${PKG_VERSION}"
echo -e "Inferred DPCPP_LLVM_SPIRV_VERSION=${DPCPP_LLVM_SPIRV_VERSION}"

BUILD_ARGS="--single-version-externally-managed --record=llvm_spirv_record.txt"
WHEELS_BUILD_ARGS="-p manylinux2014_x86_64"

if [ -n "${WHEELS_OUTPUT_FOLDER}" ]; then
  # Build wheel package
  pushd $src/package
  cp ${BUILD_PREFIX}/bin-llvm/llvm-spirv $src/package/dpcpp_llvm_spirv/
  $PYTHON setup.py install ${BUILD_ARGS} bdist_wheel ${WHEELS_BUILD_ARGS} 
  cp dist/dpcpp_llvm_spirv*.whl ${WHEELS_OUTPUT_FOLDER}
  popd
else
  pushd $src/package
  ${PYTHON} setup.py install ${BUILD_ARGS}
  cat llvm_spirv_record.txt

  echo -e "Done building the Python package. Start vendoring of llvm-spirv executable \n"

  pushd ${BUILD_PREFIX}/
  cp bin-llvm/llvm-spirv $(${PYTHON} -c "import dpcpp_llvm_spirv as p; print(p.get_llvm_spirv_path())")
  echo "copy llvm-spirv to: $(${PYTHON} -c "import dpcpp_llvm_spirv as p; print(p.get_llvm_spirv_path())")"
  popd
  echo "done. \n"
fi
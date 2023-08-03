
set "DPCPP_LLVM_SPIRV_VERSION=%PKG_VERSION%"
echo "Inferred DPCPP_LLVM_SPIRV_VERSION=%DPCPP_LLVM_SPIRV_VERSION%"

set "BUILD_ARGS=--single-version-externally-managed --record=llvm_spirv_record.txt"

if not exist %BUILD_PREFIX%\Library\bin-llvm\llvm-spirv.exe (exit 1)

pushd %SRC_DIR%\package
if not exist %SRC_DIR%\package\dpcpp_llvm_spirv\bin mkdir %SRC_DIR%\package\dpcpp_llvm_spirv\bin
copy %BUILD_PREFIX%\Library\bin-llvm\llvm-spirv.exe %SRC_DIR%\package\dpcpp_llvm_spirv\bin\

rem Workaround to remove spaces from the env value
set WHEELS_OUTPUT_FOLDER=%WHEELS_OUTPUT_FOLDER: =%
if NOT "%WHEELS_OUTPUT_FOLDER%"=="" (
  %PYTHON% setup.py install %BUILD_ARGS% bdist_wheel -p win_amd64
  if errorlevel 1 exit 1
  copy dist\dpcpp_llvm_spirv*.whl %WHEELS_OUTPUT_FOLDER%
  if errorlevel 1 exit 1
) ELSE (
  %PYTHON% setup.py install %BUILD_ARGS%
  if errorlevel 1 exit 1
  type llvm_spirv_record.txt
)

popd

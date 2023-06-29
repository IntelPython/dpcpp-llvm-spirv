
set "DPCPP_LLVM_SPIRV_VERSION=%PKG_VERSION%"
echo "Inferred DPCPP_LLVM_SPIRV_VERSION=%DPCPP_LLVM_SPIRV_VERSION%"

set "BUILD_ARGS=--single-version-externally-managed --record=llvm_spirv_record.txt"

if not exist %BUILD_PREFIX%\Library\bin-llvm\llvm-spirv.exe (exit 1)

if NOT "%WHEELS_OUTPUT_FOLDER%"=="" (
  pushd %SRC_DIR%\package
  if not exist %SRC_DIR%\package\dpcpp_llvm_spirv\bin mkdir %SRC_DIR%\package\dpcpp_llvm_spirv\bin
  copy %BUILD_PREFIX%\Library\bin-llvm\llvm-spirv.exe %SRC_DIR%\package\dpcpp_llvm_spirv\bin\
  %PYTHON% setup.py install %BUILD_ARGS% bdist_wheel
  if errorlevel 1 exit 1
  copy dist\dpcpp_llvm_spirv*.whl %WHEELS_OUTPUT_FOLDER%
  if errorlevel 1 exit 1
  popd
) ELSE (
  pushd %SRC_DIR%\package
  %PYTHON% setup.py install %BUILD_ARGS%
  type llvm_spirv_record.txt
  popd

  pushd %BUILD_PREFIX%\
  %PYTHON% -c "import dpcpp_llvm_spirv as p; print(p.get_llvm_spirv_path())" > Output
  set /p DIRSTR= < Output

  copy Library\bin-llvm\llvm-spirv.exe %DIRSTR%
  if errorlevel 1 exit 1
  del Output
  popd
)


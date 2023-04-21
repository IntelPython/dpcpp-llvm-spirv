
set /P DPCPP_LLVM_SPIRV_VERSION < %PYTHON% get_icpx_version.py
echo "Inferred DPCPP_LLVM_SPIRV_VERSION=%DPCPP_LLVM_SPIRV_VERSION%"

pushd %SRC_DIR%\package
%PYTHON% setup.py install --single-version-externally-managed --record=llvm_spirv_record.txt
type llvm_spirv_record.txt
popd

pushd %BUILD_PREFIX%\
%PYTHON% -c "import dpcpp_llvm_spirv as p; print(p.get_llvm_spirv_path())" > Output
set /p DIRSTR= < Output
if not exist Library\bin-llvm\llvm-spirv.exe (exit 1)
copy Library\bin-llvm\llvm-spirv.exe %DIRSTR%
if errorlevel 1 exit 1
del Output
popd

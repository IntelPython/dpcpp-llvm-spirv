from os import remove
from subprocess import check_call
from tempfile import NamedTemporaryFile

from dpcpp_llvm_spirv import get_llvm_spirv_path

test_ll = """source_filename = "<string>"
target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-unknown"

define i32 @mult(i32 %a, i32 %b) #0 {
  %1 = mul nsw i32 %a, %b
  ret i32 %1
}"""

expected_spvasm = """; SPIR-V
; Version: 1.0
; Generator: Khronos LLVM/SPIR-V Translator; 14
; Bound: 9
; Schema: 0
               OpCapability Addresses
               OpCapability Linkage
               OpCapability Kernel
          %1 = OpExtInstImport "OpenCL.std"
               OpMemoryModel Physical64 OpenCL
               OpSource Unknown 0
               OpName %mult "mult"
               OpName %a "a"
               OpName %b "b"
               OpDecorate %mult LinkageAttributes "mult" Export
       %uint = OpTypeInt 32 0
          %3 = OpTypeFunction %uint %uint %uint
       %mult = OpFunction %uint None %3
          %a = OpFunctionParameter %uint
          %b = OpFunctionParameter %uint
          %7 = OpLabel
          %8 = OpIMul %uint %a %b
               OpReturnValue %8
               OpFunctionEnd
"""


def main():
    ll_file = NamedTemporaryFile(prefix="multiply", suffix=".ll")
    ll_file.write(test_ll.encode())
    ll_file.flush()

    name = ll_file.name[:-3]

    check_call(["llvm-as", name + ".ll", "-o", name + ".bc"])
    check_call(
        [
            get_llvm_spirv_path(),
            "-spirv-max-version=1.0",
            name + ".bc",
            "-o",
            name + ".spv",
        ]
    )
    check_call(["spirv-dis", name + ".spv", "-o", name + ".spvasm"])

    spv_file = open(name + ".spvasm", "r")

    got_spvasm = spv_file.read()

    assert got_spvasm == expected_spvasm

    # close file and remove all temp files
    spv_file.close()
    ll_file.close()
    remove(name + ".bc")
    remove(name + ".spv")
    remove(name + ".spvasm")


if __name__ == "__main__":
    main()

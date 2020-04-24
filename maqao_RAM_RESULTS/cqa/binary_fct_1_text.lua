_cqa_text_report = {
  paths = {
    {
      hint = {
        {
          workaround = "Recompile with march=skylake.\nCQA target is Core_7x_V1 (Intel Kaby Lake Core Processors) but specialization flags are -march=x86-64",
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - CVTSD2SS: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Use double instead of single precision only when/where needed by numerical stability and avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. In C/C++, FP constants are double precision by default and must be suffixed by 'f' to make them single precision.",
          details = " - CVTSD2SS: 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions (typically from/to single/double precision).",
        },
        {
          title = "Type of elements and instruction set",
          txt = "No instructions are processing arithmetic or math operations on FP elements. This function is probably writing/copying data or processing integer elements.",
        },
        {
          title = "Matching between your function (in the source code) and the binary function",
          txt = "The binary function does not contain any FP arithmetical operations.\nThe binary function is loading 12 bytes.\nThe binary function is storing 32 bytes.",
        },
      },
      expert = {
        {
          title = "ASM code",
          txt = "In the binary file, the address of the function is: 1a96\n\nInstruction                | Nb FU | P0   | P1   | P2   | P3   | P4 | P5   | P6   | P7   | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------\nPUSH %RBP                  | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %RSP,%RBP              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nPUSH %RBX                  | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %EDI,-0x34(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %RSI,-0x40(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV -0x34(%RBP),%EAX       | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nMOV %EAX,%EDX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nSUB $0x1,%RDX              | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOV %RDX,-0x28(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %EAX,%EDX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOV %RDX,%RCX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOV $0,%EBX                | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nPXOR %XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOVSD %XMM0,-0x18(%RBP)    | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOVL $0,-0x1c(%RBP)        | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 2       | 1\nJMP 1b12 <baseline+0x7c>   | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 1    | 0    | 0       | 1-2\nCVTSD2SS -0x18(%RBP),%XMM0 | 2     | 0.50 | 0.50 | 0.50 | 0.50 | 0  | 1    | 0    | 0    | 5       | 1\nPOP %RBX                   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nPOP %RBP                   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nRET                        | 1     | 0    | 0    | 0.33 | 0.33 | 0  | 0    | 1    | 0.33 | 0       | 1\n",
        },
        {
          title = "General properties",
          txt = "nb instructions    : 20\nnb uops            : 21\nloop length        : 61\nused x86 registers : 8\nused mmx registers : 0\nused xmm registers : 1\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 5\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 5.25 cycles\nfront end            : 5.25 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | P0   | P1   | P2   | P3   | P4   | P5   | P6   | P7\n--------------------------------------------------------------\nuops   | 1.50 | 1.25 | 4.00 | 4.00 | 7.00 | 1.25 | 2.00 | 4.00\ncycles | 1.50 | 1.25 | 4.00 | 4.00 | 7.00 | 1.25 | 2.00 | 4.00\n\nCycles executing div or sqrt instructions: NA\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 5.25\nDispatch  : 7.00\nOverall L1: 7.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 8%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 0%\nother  : 16%\nFP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nINT+FP\nall    : 7%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 0%\nother  : 14%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 20%\nload   : 12%\nstore  : 18%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 25%\nother  : 22%\nFP\nall    : 25%\nload   : 25%\nstore  : 25%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 25%\nINT+FP\nall    : 21%\nload   : 18%\nstore  : 20%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 25%\nother  : 23%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each call to the function takes 7.00 cycles. At this rate:\n - 2% of peak load performance is reached (1.71 out of 64.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 14% of peak store performance is reached (4.57 out of 32.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Found no such bottlenecks.",
        },
      },
      header = {
        "0% of peak computational performance is used (0.00 out of 4.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 7.00 to 1.00 cycles (7.00x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one\n - Make array accesses unit-stride:\n  * If your function streams arrays of structures (AoS), try to use structures of arrays instead (SoA):\nfor(i) a[i].x = b[i].x; (slow, non stride 1) => for(i) a.x[i] = b.x[i]; (fast, stride 1)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized function can use their full power.\n",
          title = "Vectorization",
          txt = "Your function is probably not vectorized.\nOnly 21% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your function, you can lower the cost of an iteration from 7.00 to 1.25 cycles (5.60x speedup).",
        },
        {
          workaround = " - Write less array elements\n - Provide more information to your compiler:\n  * use the 'restrict' C99 keyword\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by writing data to caches/RAM (the store unit is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 7.00 to 5.25 cycles (1.33x speedup).\n",
        },
      },
      potential = {
      },
    },
  },
  AVG = {
      hint = {
        {
          workaround = "Recompile with march=skylake.\nCQA target is Core_7x_V1 (Intel Kaby Lake Core Processors) but specialization flags are -march=x86-64",
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - CVTSD2SS: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Use double instead of single precision only when/where needed by numerical stability and avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. In C/C++, FP constants are double precision by default and must be suffixed by 'f' to make them single precision.",
          details = " - CVTSD2SS: 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions (typically from/to single/double precision).",
        },
        {
          title = "Type of elements and instruction set",
          txt = "No instructions are processing arithmetic or math operations on FP elements. This function is probably writing/copying data or processing integer elements.",
        },
        {
          title = "Matching between your function (in the source code) and the binary function",
          txt = "The binary function does not contain any FP arithmetical operations.\nThe binary function is loading 12 bytes.\nThe binary function is storing 32 bytes.",
        },
      },
      expert = {
        {
          title = "ASM code",
          txt = "In the binary file, the address of the function is: 1a96\n\nInstruction                | Nb FU | P0   | P1   | P2   | P3   | P4 | P5   | P6   | P7   | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------\nPUSH %RBP                  | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %RSP,%RBP              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nPUSH %RBX                  | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %EDI,-0x34(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %RSI,-0x40(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV -0x34(%RBP),%EAX       | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nMOV %EAX,%EDX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nSUB $0x1,%RDX              | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOV %RDX,-0x28(%RBP)       | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOV %EAX,%EDX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOV %RDX,%RCX              | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOV $0,%EBX                | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nPXOR %XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 0       | 0.25\nMOVSD %XMM0,-0x18(%RBP)    | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nMOVL $0,-0x1c(%RBP)        | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 2       | 1\nJMP 1b12 <baseline+0x7c>   | 1     | 0    | 0    | 0    | 0    | 0  | 0    | 1    | 0    | 0       | 1-2\nCVTSD2SS -0x18(%RBP),%XMM0 | 2     | 0.50 | 0.50 | 0.50 | 0.50 | 0  | 1    | 0    | 0    | 5       | 1\nPOP %RBX                   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nPOP %RBP                   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nRET                        | 1     | 0    | 0    | 0.33 | 0.33 | 0  | 0    | 1    | 0.33 | 0       | 1\n",
        },
        {
          title = "General properties",
          txt = "nb instructions    : 20\nnb uops            : 21\nloop length        : 61\nused x86 registers : 8\nused mmx registers : 0\nused xmm registers : 1\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 5\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 5.25 cycles\nfront end            : 5.25 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | P0   | P1   | P2   | P3   | P4   | P5   | P6   | P7\n--------------------------------------------------------------\nuops   | 1.50 | 1.25 | 4.00 | 4.00 | 7.00 | 1.25 | 2.00 | 4.00\ncycles | 1.50 | 1.25 | 4.00 | 4.00 | 7.00 | 1.25 | 2.00 | 4.00\n\nCycles executing div or sqrt instructions: NA\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 5.25\nDispatch  : 7.00\nOverall L1: 7.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 8%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 0%\nother  : 16%\nFP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nINT+FP\nall    : 7%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 0%\nother  : 14%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 20%\nload   : 12%\nstore  : 18%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 25%\nother  : 22%\nFP\nall    : 25%\nload   : 25%\nstore  : 25%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 25%\nINT+FP\nall    : 21%\nload   : 18%\nstore  : 20%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: 25%\nother  : 23%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each call to the function takes 7.00 cycles. At this rate:\n - 2% of peak load performance is reached (1.71 out of 64.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 14% of peak store performance is reached (4.57 out of 32.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Found no such bottlenecks.",
        },
      },
      header = {
        "0% of peak computational performance is used (0.00 out of 4.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 7.00 to 1.00 cycles (7.00x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one\n - Make array accesses unit-stride:\n  * If your function streams arrays of structures (AoS), try to use structures of arrays instead (SoA):\nfor(i) a[i].x = b[i].x; (slow, non stride 1) => for(i) a.x[i] = b.x[i]; (fast, stride 1)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized function can use their full power.\n",
          title = "Vectorization",
          txt = "Your function is probably not vectorized.\nOnly 21% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your function, you can lower the cost of an iteration from 7.00 to 1.25 cycles (5.60x speedup).",
        },
        {
          workaround = " - Write less array elements\n - Provide more information to your compiler:\n  * use the 'restrict' C99 keyword\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by writing data to caches/RAM (the store unit is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 7.00 to 5.25 cycles (1.33x speedup).\n",
        },
      },
      potential = {
      },
    },
  common = {
    header = {
      "The function is defined in /home/pavel/Documents/COURS/IATIC_4/AOA/Alpha0_CPU/kernel.c:33-41.\n",
      "Warnings:\nIgnoring paths for analysis",
    },
  },
}

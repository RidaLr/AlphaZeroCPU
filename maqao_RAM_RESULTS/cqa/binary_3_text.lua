_cqa_text_report = {
  paths = {
    {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - rand@plt: 1 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          workaround = "Recompile with march=skylake.\nCQA target is Core_7x_V1 (Intel Kaby Lake Core Processors) but specialization flags are -march=x86-64",
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - ADD: 1 occurrences\n - CVTSI2SD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Use double instead of single precision only when/where needed by numerical stability and avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. In C/C++, FP constants are double precision by default and must be suffixed by 'f' to make them single precision.",
          details = " - CVTSI2SD: 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions (typically from/to single/double precision).",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 1 FP arithmetical operations:\n - 1: divide\nThe binary loop is loading 36 bytes (4 double precision FP elements).\nThe binary loop is storing 12 bytes (1 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.02 FP operations per loaded or stored byte.",
        },
        {
          workaround = "Unroll your loop if trip count is significantly higher than target unroll factor and if some data references are common to consecutive iterations. This can be done manually. Or by recompiling with -funroll-loops and/or -floop-unroll-and-jam.",
          title = "Unroll opportunity",
          txt = "Loop is potentially data access bound.",
        },
      },
      expert = {
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1823\n\nInstruction               | Nb FU | P0   | P1   | P2   | P3   | P4 | P5   | P6   | P7   | Latency | Recip. throughput\n---------------------------------------------------------------------------------------------------------------------\nCALL 10e0 <rand@plt>      | 2     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 1    | 0.33 | 0       | 2\nCVTSI2SD %EAX,%XMM0       | 2     | 0.50 | 0.50 | 0    | 0    | 0  | 1    | 0    | 0    | 6       | 2\nMOV -0x18(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nMOVSXD %EAX,%RDX          | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOVSXD %EBX,%RAX          | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nIMUL %RDX,%RAX            | 1     | 0    | 1    | 0    | 0    | 0  | 0    | 0    | 0    | 3       | 1\nLEA (,%RAX,8),%RDX        | 1     | 0    | 0.50 | 0    | 0    | 0  | 0.50 | 0    | 0    | 1       | 0.50\nMOV -0x30(%RBP),%RAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nADD %RAX,%RDX             | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOVSD 0x967(%RIP),%XMM1   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 0       | 0.50\nDIVSD %XMM1,%XMM0         | 1     | 1    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 13-14   | 4\nMOV -0x14(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nCLTQ\nMOVSD %XMM0,(%RDX,%RAX,8) | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nADDL $0x1,-0x14(%RBP)     | 2     | 0.50 | 0.50 | 0.83 | 0.83 | 1  | 0.50 | 0.50 | 0.33 | 5       | 1\nMOV -0x14(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nCMP -0x24(%RBP),%EAX      | 1     | 0.25 | 0.25 | 0.50 | 0.50 | 0  | 0.25 | 0.25 | 0    | 1       | 0.50\nJL 17e4 <init_array+0x3c> | 1     | 0.50 | 0    | 0    | 0    | 0  | 0    | 0.50 | 0    | 0       | 0.50-1\n",
        },
        {
          title = "General properties",
          txt = "nb instructions    : 18\nnb uops            : 19\nloop length        : 71\nused x86 registers : 4\nused mmx registers : 0\nused xmm registers : 2\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 4\n",
        },
        {
          title = "Front-end",
          txt = "ASSUMED MACRO FUSION\nFIT IN UOP CACHE\nmicro-operation queue: 4.75 cycles\nfront end            : 4.75 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | P0   | P1   | P2   | P3   | P4   | P5   | P6   | P7\n--------------------------------------------------------------\nuops   | 3.00 | 3.00 | 3.50 | 3.50 | 3.00 | 3.00 | 3.00 | 3.00\ncycles | 3.00 | 3.00 | 3.50 | 3.50 | 3.00 | 3.00 | 3.00 | 3.00\n\nCycles executing div or sqrt instructions: 4.00\nLongest recurrence chain latency (RecMII): 0.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 4.75\nDispatch  : 3.50\nDIV/SQRT  : 4.00\nData deps.: 0.00\nOverall L1: 4.75\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nFP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nINT+FP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 16%\nload   : 12%\nstore  : 12%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 18%\nFP\nall    : 25%\nload   : 25%\nstore  : 25%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 25%\nINT+FP\nall    : 20%\nload   : 18%\nstore  : 18%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 20%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 4.75 cycles. At this rate:\n - 11% of peak load performance is reached (7.58 out of 64.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 7% of peak store performance is reached (2.53 out of 32.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Performance is limited by instruction throughput (loading/decoding program instructions to execution core) (front-end is a bottleneck).\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [CLTQ] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "1% of peak computational performance is used (0.21 out of 16.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 4.75 to 4.00 cycles (1.19x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly:\nC storage order is row-major: for(i) for(j) a[j][i] = b[j][i]; (slow, non stride 1) => for(i) for(j) a[i][j] = b[i][j]; (fast, stride 1)\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA):\nfor(i) a[i].x = b[i].x; (slow, non stride 1) => for(i) a.x[i] = b.x[i]; (fast, stride 1)\n",
          details = "All SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is not vectorized.\nOnly 20% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 4.75 to 2.00 cycles (2.38x speedup).",
        },
        {
          title = "Execution units bottlenecks",
          txt = "Found no such bottlenecks but see expert reports for more complex bottlenecks.",
        },
      },
      potential = {
      },
    },
  },
  AVG = {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - rand@plt: 1 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          workaround = "Recompile with march=skylake.\nCQA target is Core_7x_V1 (Intel Kaby Lake Core Processors) but specialization flags are -march=x86-64",
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - ADD: 1 occurrences\n - CVTSI2SD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Use double instead of single precision only when/where needed by numerical stability and avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. In C/C++, FP constants are double precision by default and must be suffixed by 'f' to make them single precision.",
          details = " - CVTSI2SD: 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions (typically from/to single/double precision).",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 1 FP arithmetical operations:\n - 1: divide\nThe binary loop is loading 36 bytes (4 double precision FP elements).\nThe binary loop is storing 12 bytes (1 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.02 FP operations per loaded or stored byte.",
        },
        {
          workaround = "Unroll your loop if trip count is significantly higher than target unroll factor and if some data references are common to consecutive iterations. This can be done manually. Or by recompiling with -funroll-loops and/or -floop-unroll-and-jam.",
          title = "Unroll opportunity",
          txt = "Loop is potentially data access bound.",
        },
      },
      expert = {
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1823\n\nInstruction               | Nb FU | P0   | P1   | P2   | P3   | P4 | P5   | P6   | P7   | Latency | Recip. throughput\n---------------------------------------------------------------------------------------------------------------------\nCALL 10e0 <rand@plt>      | 2     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 1    | 0.33 | 0       | 2\nCVTSI2SD %EAX,%XMM0       | 2     | 0.50 | 0.50 | 0    | 0    | 0  | 1    | 0    | 0    | 6       | 2\nMOV -0x18(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nMOVSXD %EAX,%RDX          | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOVSXD %EBX,%RAX          | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nIMUL %RDX,%RAX            | 1     | 0    | 1    | 0    | 0    | 0  | 0    | 0    | 0    | 3       | 1\nLEA (,%RAX,8),%RDX        | 1     | 0    | 0.50 | 0    | 0    | 0  | 0.50 | 0    | 0    | 1       | 0.50\nMOV -0x30(%RBP),%RAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nADD %RAX,%RDX             | 1     | 0.25 | 0.25 | 0    | 0    | 0  | 0.25 | 0.25 | 0    | 1       | 0.25\nMOVSD 0x967(%RIP),%XMM1   | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 0       | 0.50\nDIVSD %XMM1,%XMM0         | 1     | 1    | 0    | 0    | 0    | 0  | 0    | 0    | 0    | 13-14   | 4\nMOV -0x14(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nCLTQ\nMOVSD %XMM0,(%RDX,%RAX,8) | 1     | 0    | 0    | 0.33 | 0.33 | 1  | 0    | 0    | 0.33 | 3       | 1\nADDL $0x1,-0x14(%RBP)     | 2     | 0.50 | 0.50 | 0.83 | 0.83 | 1  | 0.50 | 0.50 | 0.33 | 5       | 1\nMOV -0x14(%RBP),%EAX      | 1     | 0    | 0    | 0.50 | 0.50 | 0  | 0    | 0    | 0    | 2       | 0.50\nCMP -0x24(%RBP),%EAX      | 1     | 0.25 | 0.25 | 0.50 | 0.50 | 0  | 0.25 | 0.25 | 0    | 1       | 0.50\nJL 17e4 <init_array+0x3c> | 1     | 0.50 | 0    | 0    | 0    | 0  | 0    | 0.50 | 0    | 0       | 0.50-1\n",
        },
        {
          title = "General properties",
          txt = "nb instructions    : 18\nnb uops            : 19\nloop length        : 71\nused x86 registers : 4\nused mmx registers : 0\nused xmm registers : 2\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 4\n",
        },
        {
          title = "Front-end",
          txt = "ASSUMED MACRO FUSION\nFIT IN UOP CACHE\nmicro-operation queue: 4.75 cycles\nfront end            : 4.75 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | P0   | P1   | P2   | P3   | P4   | P5   | P6   | P7\n--------------------------------------------------------------\nuops   | 3.00 | 3.00 | 3.50 | 3.50 | 3.00 | 3.00 | 3.00 | 3.00\ncycles | 3.00 | 3.00 | 3.50 | 3.50 | 3.00 | 3.00 | 3.00 | 3.00\n\nCycles executing div or sqrt instructions: 4.00\nLongest recurrence chain latency (RecMII): 0.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 4.75\nDispatch  : 3.50\nDIV/SQRT  : 4.00\nData deps.: 0.00\nOverall L1: 4.75\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nFP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\nINT+FP\nall    : 0%\nload   : 0%\nstore  : 0%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 0%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 16%\nload   : 12%\nstore  : 12%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 18%\nFP\nall    : 25%\nload   : 25%\nstore  : 25%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 25%\nINT+FP\nall    : 20%\nload   : 18%\nstore  : 18%\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nother  : 20%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 4.75 cycles. At this rate:\n - 11% of peak load performance is reached (7.58 out of 64.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 7% of peak store performance is reached (2.53 out of 32.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Performance is limited by instruction throughput (loading/decoding program instructions to execution core) (front-end is a bottleneck).\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [CLTQ] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "1% of peak computational performance is used (0.21 out of 16.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 4.75 to 4.00 cycles (1.19x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly:\nC storage order is row-major: for(i) for(j) a[j][i] = b[j][i]; (slow, non stride 1) => for(i) for(j) a[i][j] = b[i][j]; (fast, stride 1)\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA):\nfor(i) a[i].x = b[i].x; (slow, non stride 1) => for(i) a.x[i] = b.x[i]; (fast, stride 1)\n",
          details = "All SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is not vectorized.\nOnly 20% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 4.75 to 2.00 cycles (2.38x speedup).",
        },
        {
          title = "Execution units bottlenecks",
          txt = "Found no such bottlenecks but see expert reports for more complex bottlenecks.",
        },
      },
      potential = {
      },
    },
  common = {
    header = {
      "The loop is defined in /home/pavel/Documents/COURS/IATIC_4/AOA/Alpha0_CPU/driver.c:110-111.\n",
      "The related source loop is not unrolled or unrolled with no peel/tail loop.",
    },
    nb_paths = 1,
  },
}

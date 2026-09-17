# SAR ADC Design and Verification Report

[← System-level project report](../../Project_Report.md)

## Architecture

The SAR ADC top-level schematic integrates differential bootstrapped sampling, a differential capacitive DAC, a dynamic comparator, clock generation, SAR control logic, and an output register.

| Direct top-level block | Instances | Function |
| :--- | ---: | :--- |
| BSW | 2 | Differential bootstrapped input sampling |
| CDAC | 1 | Differential charge-redistribution DAC |
| CLK_GEN | 1 | Conversion-clock sequencing |
| COMP | 1 | Differential comparison |
| SAR_LOGIC | 1 | Successive-approximation control |
| OUT_REG | 1 | Conversion-result storage |

## Complete block hierarchy

| Block | Used by | Function |
| :--- | :--- | :--- |
| [`BSW`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/BSW/BSW.sch) | SAR_ADC | Bootstrapped switch |
| [`CDAC`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/CDAC/CDAC.sch) | SAR_ADC | Capacitive DAC |
| [`CLK_GEN`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/CLK_GEN/CLK_GEN.sch) | SAR_ADC | Clock generator |
| [`COMP`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/COMP/COMP.sch) | SAR_ADC | Comparator wrapper |
| [`DLY_CELL`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/DLY_CELL/DLY_CELL.sch) | CLK_GEN | Delay cell |
| [`INV`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sch) | CLK_GEN, TSPC_FF | Inverter |
| [`INV2`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/INV2/INV2.sch) | CLK_GEN | Secondary inverter implementation |
| [`MUX`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/MUX/MUX.sch) | CLK_GEN | Multiplexer |
| [`NAND`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/NAND/NAND.sch) | CLK_GEN | NAND logic |
| [`OUT_REG`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/OUT_REG/OUT_REG.sch) | SAR_ADC | Output register |
| [`RS_LATCH`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/RS_LATCH/RS_LATCH.sch) | COMP | Comparator decision latch |
| [`SAR_ADC`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SAR_ADC/SAR_ADC.sch) | Top level | ADC integration |
| [`SAR_LOGIC`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SAR_LOGIC/SAR_LOGIC.sch) | SAR_ADC | Conversion-state logic |
| [`SA_LATCH`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SA_LATCH/SA_LATCH.sch) | COMP | StrongARM latch |
| [`SW_NW`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SW_NW/SW_NW.sch) | CDAC | DAC switch network |
| [`TG_SW`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/TG_SW/TG_SW.sch) | CDAC, SW_NW | Transmission-gate switch |
| [`TSPC_FF`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/TSPC_FF/TSPC_FF.sch) | CLK_GEN, SAR_LOGIC, OUT_REG | Dynamic flip-flop |
| [`XOR`](../../Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/XOR/XOR.sch) | CLK_GEN, COMP | XOR logic |

Every block currently stored in `SAR_ADC_BLOCKS` is reachable from the `SAR_ADC` top level.

## Verification status

| Item | Status |
| :--- | :---: |
| Schematic hierarchy | Complete |
| Symbol-path audit | Pass |
| Block testbenches | Not available |
| Static transfer results | Pending |
| Dynamic FFT results | Pending |
| PVT verification | Pending |
| Monte Carlo verification | Pending |
| Generated plots | Pending |

## Required signoff results

- Input sampling capacitance and acquisition settling.
- Offset and decision time of the comparator.
- CDAC settling, monotonicity, DNL, and INL.
- Conversion timing and output-code correctness.
- SNDR, ENOB, SFDR, and SNR across input frequency.
- Power and energy per conversion.
- PVT and mismatch sensitivity.
- AFE-to-ADC interface settling and kickback.

No ADC performance value is reported until dedicated testbenches and analysis artifacts are generated.

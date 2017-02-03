# 3-Stage-Pipeline
A Three Stage Pipeline 16-bit processor implemented in Verilog 

Find tentative design at:
https://docs.google.com/presentation/d/1UTbuw8olqJFvrFJ2w_zIRk5LXlS1WgDOVkUarwExFcI/edit?usp=sharing

## Ports.io

### Fetch Instruction Unit

#### Core Components
    1. Program Counter
    2. Instruction Register

#### Input
    1. Instruction (to be executed)

#### Output
    1. Instruction Address (to be read)
    2. Instruction (transfer to next unit)

### Decode & Fetch Operand Unit

#### Input
    1. Instruction (to be decoded)
    2. Value of 2 source registers, srcRegVal1 and srcRegVal2
    3. Status of 2 source registers, i.e., whether are being computed by the Execute Unit currently, inuse1 and inuse2 

#### Output
    1. Source register address, srcReg1 and srcReg2 (to be read)
    2. Destination register address, nextDestReg (to set inuse bit)
    3. Opcode of instruction, opcode
    4. Destination register address, destReg for next instruction
    5. Source register values, srcVal1 and srcVal2
    6. Address of memory location in case of LOAD/Store
    7. Inuse bits for source registers, used1 and used2 

### Register File

#### Core Components
    1. 16-bit registers x16
    2. Inuse bits x16

#### Input
    1. Source register address, srcReg1 and srcReg2 (to be read)
    2. Destination register address of next instruction (to set inuse bit)
    3. Destination register address of current instruction, destReg and value to be stored there, destVal

#### Output
    1. Value of 2 source registers, srcRegVal1 and srcRegVal2
    2. Status of 2 source registers, i.e., whether are being computed by the Execute Unit currently, inuse1 and inuse2 

### Execute & Store Back Unit

Note: Register values can be changed during a cycle (not only on posedges). This unit takes only 1 cycle.

#### Core Components
    1. Processor Status Word
    2. LastDestVal (stores the value computed in the last cycle)

#### Input
    1. Opcode of instruction, opcode
    2. Destination register address, destReg for next instruction
    3. Source register values, srcVal1 and srcVal2
    4. Address of memory location in case of LOAD/Store
    5. Inuse bits for source registers, used1 and used2 
    6. Memory read value for LOAD instruction

#### Output
    1. Memory write value for STORE instruction
    2. Memory address for LOAD/STORE instruction
    3. Destination register address, destReg
    4. Destination register value, destVal

# The core architecture

https://evalandaply.neocities.org/books/lowlevelprogramming.pdf - page 34 
https://github.com/ecoshub/nasm_c_source

## Model of computation

Model of computation is a set of basic operations and their respective costs.

Computer architecture describes the functionnality, organization, and implementation of computer systems.
- central processing unit (CPU) can execute instructions, fetched from memory by a control unit.
- the artihmetic logic unity (ALU) performs the needed computations. The memory also stores data.
- memory stores only bits
- memory stores both encoded instructions and data to operate on. (bit strings)
- memory is organized into cells, which are labeled with their respective indices in a naturay way.
- cell size may vary
- modern computers take one byte (eight bits) as a memory cell size. So, the 0-th byte holds the first eight bits of the memory, etc.
- the program consists of instructions that are fetched one after another. Their execution is sequential.

## Von neumann architecture
Control Unit + ALU <-> memory

0000 0000  11011100
0000 0001  10011110
0000 0002  11111001

FFFF FFFF  00110010

Problems
- Nothing is possible without querying slow Memory
- Lack of interactivity
- Multitasking
- No support for code isolation in procedures, or for context saving

## Assembly language
Assembly language for a chosen processor is a programming language consisting of mnemonics for
each possible binary encoded instruction (machine code). It makes programming in machine codes much
easier, because the programmer then does not have to memorize the binary encoding of instructions, only
their names and parameters.

Memory state and values of registers fully describe the CPU state (from a programmer’s point of
view). Understanding an instruction means understanding its effects on memory and registers.

> The purpose of an operating system (OS) is (among others) to manage the resources (such as external devices) so that user applications 
will not cause chaos by interacting with the same devices concurrently.

## Intel 64 architecture
Intel has been developing its main processor family since the 1970s. Each model was intended to
preserve the binary compatibility with older models. It means that even modern processors can execute
code written and compiled for older models. It leads to a tremendous amount of legacy. Processors can
operate in a number of modes: real mode, protected, virtual, etc. If not specified explicitly, we will describe
how a CPU operates in the newest, so-called **long mode**.

Intel 64 incorporates multiple extensions of von Neumann’s architecture.
> Registers: memory cells placed directly on the CPU chip
> Hardware stack: a stack is a data structure, it support pushing, popping. A hardware stack implements this abstraction on top of
memory through special instructions and a register, pointing at the last stack element. A stack is used not
only in computations but to store local variables and implement function call sequence in programming
languages.
> Interrupts: allows one to change program execution order based on events external to the program itself. After a signal (external or internal) is 
caught, a program’s execution is suspended, some registers are saved, and the CPU starts executing a special routine to handle the situation.
--> a signal from external devices, zero division, invalid instructions (when CPU failed to recognize an instruction by its binary representation)
> Protection rings: A CPU is always in a state corresponding to one of the so-called protection rings. Each
ring defines a set of allowed instructions. 
> Virtual memory: abstraction over physical Memory


## registers
Instructions have to be fetched from memory, operands have to be fetched from memory; some
instructions store results also in memory. It creates a bottleneck and leads to wasted CPU time when it waits
for the data response from the memory chip.

> To avoid constant wait, a processor was equipped with its own memory cells, called **registers**.
> Registers are based on **transistors**, while main memory uses **condensers**. We could have implemented main memory on transistors and gotten a much faster circuit. There are several reasons engineers prefer other ways of speeding up computations.
--> Registers are more expensive.
--> Instructions encode the register’s number as part of their codes. To address more registers the instructions have to grow in size.
--> Registers add complexity to the circuits to address them. More complex circuits are
harder to speed up. It is not easy to set up a large register file to work on 5 GHz.

### If everything has to be fetched into registers before the computations are made and flushed into memory after, where’s the profit?
common programming patterns such as loops, function, and data reusage, not some law of nature.
This property is called **locality of reference** and there are two main types of it: **temporal and spatial.**

1. Temporal locality means that accesses to one address are likely to be close in time.
2. Spatial locality means that after accessing address of A, the next memory access will likely to be close.

Typical programs are using the following pattern: the data working set is small and can be kept inside
registers. After fetching the data into registers once we will work with them for quite some time, and then the
results will be flushed into memory. The data stored in memory will rarely be used by the program. In case
we need to work with this data we will lose performance because
• We need to fetch data into the registers.
• If all registers are occupied with data we still need later on, we will have to spill some of
them, which means save their contents into temporally allocated memory cells.



## General purpose Registers
They are interchangeable and can be used in many different commands.
These are 64-bit registers with the names r0, r1, …, r15.

For example, **r1** is alternatively named **rcx**, where c stands for “cycle.” There is an instruction loop, which uses rcx as a cycle counter but accepts no operands explicitly

Unlike the hardware stack, which is implemented on top of the main memory, registers are a completely different kind of memory. Thus they do not have addresses, as the main memory’s cells do!


-----
NAME        ALIAS       DESCRIPTION
r0          rax         Kind of an “accumulator,” used in arithmetic instructions. For example, an instruction
                        div is used to divide two integers. It accepts one operand and uses rax implicitly as
                        the second one. After executing div rcx a big 128-bit wide number, stored in parts in
                        two registers rdx and rax is divided by rcx and the result is stored again in rax.

r3          rbx         Base register. Was used for base addressing in early processor models.

r1          rcx         Used for cycles (eg in loop)

r2          rdx         Stores data during input/output operations

r4          rsp         Stores the address of the topmost element in the hardware stack

r5          rbp         Stack frame’s base. “Calling convention”.

r6          rsi         Source index in string manipulation commands (such as movsd)

r7          rdi         Destination index in string manipulation commands (such as movsd)

r8

r9...r15    no          Appeared later. Used mostly to store temp variables.  (but sometimes used implicitly, like r10, which                        saves the CPU flags when syscall instruction is executed.)

-----

> You usually do not want to use rsp and rbp registers because of their very special meaning
> However, you can perform arithmetic operations on them directly, which makes them general purpose

### 64-Bit General Purpose registers
r0      r1      r2      r3      r4      r5      r6      r7
rax     rcx     rdx     rbx     rsp     rbp     rsi     rdi

Addressing a part of a register is possible. For each register you can address its lowest 32 bits, lowest 16 bits, or lowest 8 bits.

- d for double word—lower 32 bits;
- w for word—lower 16 bits;
- b for byte—lower 8 bits.

For example:
- r7b is the lowest byte of register r7;
- r3w consists of the lowest two bytes of r3; 
- r0d consists of the lowest four bytes of r0 

- rax, rbx, rcx, and rdx follows the same pattern; only the middle letter (a for rax) is changing.
- The other four registers do not allow an access to their second lowest bytes (like rax does by the name of ah). The lowest byte naming differs slightly for rsi, rdi, rsp, and rbp.
- The smallest parts of rsi and rdi are sil and dil 
- The smallest parts pf rsp and rbp are spl and bpl 
- the names r0-r7 are rarely seen 
- rsp relates a lot more information, than r4. The other eight (r8-r15) can only be named using an indexed convention

## others registers 
The other registers have special meaning. Some registers have system-wide importance and thus cannot be
modified except by the OS.


A programmer has access to **rip** register. It is a **64-bit register**, which always *stores an address of the
next instruction to be executed.*
Branching instructions (e.g., jmp) are in fact modifying it.

> All instructions have different size!

### rflags
It stores flags, which reflect the current program state—for example, what was the result of the last arithmetic instruction:was it negative, did an overflow happened, etc
Its smaller parts are called eflags (32 bit) and flags (16 bit).




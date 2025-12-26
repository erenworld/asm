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


### The difference between sar and shr 
the diff is how they treat the most significant bit (MSB) during a right shift.
- shr: shift logical right, Fills vacated high bits with 0, Does not preserve the sign, treat the value as unsigned
- sar: shift arithmetic right, fills vacated high bits with the original MSB, Preserves the sign, Treats the value as signed 
shr → zeros come in
sar → sign bit propagates

### How do you write numbers in different number systems in a way understandable to NASM? 
- Decimal (base 10): 42 - No prefix or suffix
- Hexadecimal (base 16) - Suffix h (most common in Intel syntax) and Prefix 0x (also accepted)
Rule: if the first hex digit is a letter, prefix with 0:
mov eax, 0FFh      ; correct
; mov eax, FFh    ; invalid
- Binary (base 2): suffix b 
- Octal (base 8): Suffix o (or q)

### How would you write 255 in binary and hexadecimal in NASM?
Decimal 255 means:
it is the largest value that fits in 8 bits
In binary, that means all bits are 1.
binary: 11111111b 
hexadecimal: 1111 1111 (each group of 1 is F in HEX)
-> 0FFh 


### what are the values of the registers when program start ?
When a program starts, the value of most registers is not well defined (it can be absolutely random).
It is a great source of rookie mistakes, as one tends to assume that they are zeroed.

### Convert 13 to binary
| Division | Quotient | Remainder |
| -------- | -------- | --------- |
| 13 ÷ 2   | 6        | **1**     |
| 6 ÷ 2    | 3        | **0**     |
| 3 ÷ 2    | 1        | **1**     |
| 1 ÷ 2    | 0        | **1**     |


### local labels
.loop 
it starts with a dot. This label is local.

### relative addressing 
`lea rsi, [codes + rax]`
Square brackets denote indirect addressing; the address is written inside them.
mov rsi, rax—copies rax into rsi

la taille de l’instruction `mov` est déterminée par le registre, pas par la mémoire.
[rax] signifie seulement :
« l’adresse contenue dans rax »

Destination : rsi → 8 bytes
Source : [rax] → mémoire (taille inconnue)

👉 La taille est imposée par le registre de destination, pas par le registre qui contient l’adresse.

## lea - load effective address 
lea ne lit jamais la mémoire.
Il calcule une adresse comme une opération arithmétique.

## Order of execution
All commands are executed consecutively except when special jump instructions occur. There is an
unconditional jump instruction `jmp` addr.
Conditional jumps rely on contents of `rflags` register. For example, jz address jumps to address only if
zero flag is set 

# cmp 
cmp subtracts the second operand from the first; it does not store the result anywhere, but it sets the
appropriate flags based on it (e.g., if operands are equal, it will set zero flag). test does the same thing but
uses logical AND instead of subtraction

# jmp - “Continue execution from somewhere else”
Without jmp, a program could only run linearly.
jmp exists to change the control flow:
- skip instructions
- create loops
- implement if / else
- implement function calls (with call + ret)

-> jmp modifies the instruction pointer (rip in x86-64).

| Instruction | Condition        | Uses flags |
| ----------- | ---------------- | ---------- |
| `jmp`       | none             | no         |
| `je / jz`   | equal / zero     | yes        |
| `jne / jnz` | not equal        | yes        |
| `jl / jg`   | signed compare   | yes        |
| `jb / ja`   | unsigned compare | yes        |

jF  → saute si le flag est à 1
jnF → saute si le flag est à 0

js  neg   ; jump if sign (négatif)
jns pos   ; jump if not sign (positif ou zéro)

| Tu compares              | Utilise   |
| ------------------------ | --------- |
| tailles, index, adresses | `ja / jb` |
| nombres mathématiques    | `jg / jl` |


```asm

mov rax, 1 
jmp done 
mov rax, 2 ; never executed 
done: 

// infinite loop 
mov rax, 5 

.loop 
    dec rcx 
    jmp loop 


// loop 
mov rax, 5 

.loop 
    dec rcx  ; sets Zero Flag (ZF)
    jnz loop ; jump is not zero, when rcx == 0, loop stops
```

### pseudo code
rbx = 1 si rax < 42, sinon rbx = 0.

```
cmp rax, 42 ; compare rax avec 42, ne change aucun registre
jl yes      ; si rax est plus petit, on saute à yes 
mov rbx, 0 
jmp ex      ; empêche d’aller dans yes
yes: 
    mov rbx, 1 ; rbx = 1 puis on sort
ex: 
```

### test 
tester si un registre est zéro 
test fait un ET logique (AND) mais ne garde pas le résultat.
Il sert uniquement à mettre à jour les flags.
- Si rax == 0 → résultat = 0 → ZF = 1 
- Si rax != 0 → résultat ≠ 0 → ZF = 0

#### What is the difference between je and jz?
je (jump if equal) et jz (jump if zero) sont exactement la même instruction au niveau CPU.

## Function calls 
Routines (functions) allow one to isolate a piece of program logic and use it as a black box. It is a necessary
mechanism to provide abstraction. Abstraction allows you to build more complex systems by encapsulating
complex algorithms under opaque interfaces.

Instruction call <address> is used to perform calls. It does exactly the following:

push rip
jmp <address>

-> The address now stored in the stack (former rip contents) is called return address.

## functions arguments
The address now stored in the stack (former rip contents) is called `return address.`
The first six arguments are passed in **rdi, rsi, rdx, rcx, r8, and r9**, respectively. The rest is passed on to the stack in reverse order.

#### how functions use registers
executing a function can change registers. There are two types of registers.
1. **Callee-saved** registers must be restored by the procedure being called. So, if it needs to change them, it has to change them back.
These registers are callee-saved: rbx, rbp, rsp, r12-r15, a total of seven registers.


2. **Caller-saved** registers should be saved before invoking a function and restored after. One
does not have to save and restore them if their value will not be of importance after

Conventions
-> Saving and restoring callee-saved registers.
-> Being always aware that caller-saved registers can be changed during function execution.

### functions calls bugs 
Après un call, certains registres peuvent être modifiés par la fonction appelée. Si tu les réutilises sans les sauvegarder → bug.

**Registres callee-saved** (la fonction DOIT les restaurer)
Si la fonction modifie l’un de ceux-ci, elle doit le remettre comme avant avant ret.

```
push rbx        ; sauvegarde
mov  rbx, 42
; ...
pop  rbx        ; restauration
ret
```

**Registres caller-saved**
Si tu veux qu’un de ces registres survive à un call, tu le sauves toi-même.
```
mov rax, 5
call foo
add rax, 1   ; BUG potentiel
```
```
mov rax, 5
push rax
call foo
pop rax
add rax, 1
```

## Pattern of calling a function 
• Save all caller-saved registers you want to survive function call
(you can use push for that).
• Store arguments in the relevant registers (rdi, rsi, etc.).
• Invoke function using call.
• After function returns, rax will hold the return value.
• Restore caller-saved registers stored before the function call.

## Syscall 
The arguments for system calls are stored in a different set of registers than those for functions. The fourth argument is stored in r10, while a function accepts the fourth argument in rcx!

les arguments
| Argument       | Registre |
| -------------- | -------- |
| syscall number | `rax`    |
| 1              | `rdi`    |
| 2              | `rsi`    |
| 3              | `rdx`    |
| 4              | `r10`    |
| 5              | `r8`     |
| 6              | `r9`     |

le 4ᵉ argument est en r10, PAS en rcx
l’instruction syscall écrase rcx
le CPU utilise rcx pour stocker l’adresse de retour


#### where return values are stored ? 
in rax before the function ends its
execution. If you need to return two values, you are allowed to use rdx for the second one.


#### Pourquoi rsp fait partie des registres qu’on ne doit jamais laisser modifiés après une fonction ?
rsp pointe vers le sommet de la pile (stack).


#### on execute ce qu'il y a dans .data ?
Le CPU n’exécute jamais ce qui est dans section .data.
.data → données
.text → instructions

#### .text ?
.text = zone de mémoire exécutable
Le CPU lit cette zone instruction par instruction
Tout ce qui est ici est du code

#### global _start ?
point d'entrée

#### print_newline:
ceci est un label
une addresse dans .text
Écrire un seul octet (\n) sur la sortie standard.

#### un syscall ?
“Fais cette opération pour moi, avec ces paramètres.”

`write(fd, buffer, size)`

Le noyau a besoin de :
1. quel service ?
2. avec quels paramètres ?

rax = 1        ; write
rdi = fd
rsi = adresse du buffer
rdx = nombre d'octets
syscall


## Endianness - l’ordre des octets en mémoire pour un nombre multi-octets.
The bits in each byte are stored in a straightforward way, but the bytes are stored from the least
significant to the most significant.
This applies only to memory operations: in registers, the bytes are stored in a natural way. Different
processors have different conventions on how the bytes are stored.
- Big endian multibyte numbers are stored in memory starting with the most
significant bytes.
addresse basse -> haute 
12 34

- Little endian multibyte numbers are stored in memory starting with the least significant bytes.Octet de poids faible d’abord (adresse la plus basse).
Adresse haute → basse
34 12


> These conventions do not concern arrays and strings. However, if each character is encoded using 2
bytes rather than just 1, those bytes will be stored in reverse order.

? The advantage of little endian is that we can discard the most significant bytes effectively converting the
number from a wider format to a narrower one, like 8 bytes.

> Big endian is a native format often used inside network packets (e.g., TCP/IP). It is also an internal
number format for Java Virtual Machine.

Define quadword -> 8 octets (64 bits)
`dq 0x1234`
0x0000000000001234
Little endian: 34 12 00 00 00 00 00 00
Big endian: 00 00 00 00 00 00 12 34



## strings
1. Strings start with their explicit length.

`db 27, 'Selling England by the Pound`

2. A special character denotes the string ending. null terminated.

`db 'Selling England by the Pound', 0`


## Constant Precomputation (pré-calcul des constantes)
Le principe : tout calcul qui ne dépend que de constantes est fait par l’assembleur, pas par le CPU à l’exécution.
```
lab: db 0 
... 
mov rax, lab + 1 + 2*3 
```
lab est une adresse connue à l’assemblage 1 et 2*3 sont des constantes
NASM évalue cette expression à l’assemblage et génère du code équivalent à :

`mov rax, lab + 7`


## Pointers and different addressing types 
Pointers are addresses of memory cells. They can be stored in memory or in registers. 
The size of a pointer is 8 bytes. Data usually occupies several memory cells. The pointers hold no information about the pointed data length. When trying towrite somewhere a value whose size is not specified and can not be deduced (for example, mov [myvariable], 4), we can get
compilation errors.

```nasm
section .data 
test: dq -1 

section .text 

mov byte[test], 1 ;1 
mov word[test], 1 ;2 
mov dword[test], 1 ;4
move qword[test], 1 ;8 
```


#### Pourquoi _start doit être global ?
Pour que le linker sache où commencer l’exécution.

#### section .data, Est-ce que le CPU exécute .data ?
Section contenant les données statiques (lisibles/écrites).
Non, seulement .text

#### Que se passe-t-il si on exécute du code dans .data ?
segfault/instructions invalid 

#### Intel64 follows little endian convention or big endian ? 
little endian 

#### how one encode operands in instructions.
1. immediately: an instruction is itself contained in memory. The operands in some forms are its parts. Those have addresses of their own.
This is the way to move a number 10 into rax.
`mov rax, 10`

2. through a register 
this instruction transfer rbx into rax 
`mov rax, rbx`

3. by direct memory addressing 
this instruction transfers 8 bytes starting at the tenth address into rax 
`mov rax, [10]`

We can also take the address from register:
`mov r9, 10`
`mov rax, [r9]`

we can use Precomputation:

```
buffer: dq 8841, 99, 00 
mov rax, [buffer+8]
```
The address inside this instruction was precomputed, because both base and
offset are constants in control of compiler.

4. Base-indexed with scale and displacement
Most addressing modes are generalized by this mode. 

Address = base + index*scale + displacement

- base is immediate or register 
- scale can only be immediate equal to 1, 2, 4, 8 
- index is immediate or a register 
- displacement is always immediate


#### can you spot a bug ? When will they occur ?
```
global _start
section .data
test_string: db "abcdef", 0
section .text
strlen:
    push r13                ; save callee saved register
    xor r13, r13            ; initialized counter
.loop:
    cmp byte [rdi+r13], 0
    je .end
    inc r13
    jmp .loop
.end:
    mov rax, r13
    pop r13                 ; restore    
    ret
_start:
    mov rdi, test_string
    call strlen
    mov rdi, rax
    mov rax, 60
    syscall
```

**bug 1** - r13 is never initialized, r13 is used as the index/counter, but it is never set to 0 before the loop.
On x86-64, registers do not start at 0. r13 contains whatever value happened to be there before.
The behavior is undefined.

correct pattern -> `xor r13, r13`


**bug 2** - ABI violation 
```
inc r13 
mov rax, r13 
ret 
```
r13 is a callee-saved register in the System V AMD64 ABI that means 
if a function modifies r13 it must restore it before using it 

When it occurs
- When strlen is called from any real program (not just _start)
- The caller may rely on r13 staying unchanged
- This silently corrupts the caller’s state

#### What is the connection between rax, eax, ax, ah, and al?
different views of the same physical CPU register on x86/64.
smaller names refer to lower portions of the larger one.

|--------------------------- rax (64 bits) ---------------------------|
|           eax (32 bits)            |
|     ax (16 bits)      |
| ah (8) | al (8) |

rax: full 64-bit register
eax: lower 32 bits of rax
ax: lower 16 bits of eax 
ah: high 8 bits of ax (bits 8–15)
al: low 8 bits of ax (bits 0–7)

###### Rules
- if you write to `eax`, the upper 32 bits of `rax` are automaticcaly set to zero. `mov eax, 1  rax == 0x0000001`
- writing to `ax, ah, or al` does NOT zero upper bits. Only those specific bits are modified; the rest of rax sta s unchanged.
- all names refer to the same hardware register. Changing one affects the others because they overlap.

al/ah/ax → from 8086 (16-bit)
eax → added with 80386 (32-bit)
rax → added with x86-64

#### if rax = 0x1122334455667788. What are al, ah, ax, eax?
0x11 22 33 44 55 66 77 88

al = dernier byte -> 88 
ah = byte au dessus de al -> 77 
ax = 2 derniers bytes ensemble -> 77 88
eax = 4 derniers bytes 55 66 77 88

#### logiciel 32-bit vs 64-bit (low-level) 
Quand on te propose un logiciel en 32 bits ou 64 bits, ça parle de l’architecture CPU ciblée par le binaire.
La taille des registres généraux et des adresses mémoire changent.

32 bits
- registres : eax, ebx, ecx, …
- taille d’un pointeur : 32 bits

64 bits
- registres : rax, rbx, rcx, …
- taille d’un pointeur : 64 bits

`void *p;`
en 32 bits → sizeof(p) = 4
en 64 bits → sizeof(p) = 8


# Checklist
- r* → 8 bytes
- e* → 4 bytes
- *x → 2 bytes
- *l → 1 byte

----- 
[ code ]      → instructions exécutées
[ data ]      → données globales
[ stack ]     → variables temporaires, retours de fonctions
[ heap ]      → allocations dynamiques (malloc)
----- 

- xor
- jmp, ja, and similar ones
- cmp
- mov
- inc, dec
- add, imul, mul, sub, idiv, div
- neg
- call, ret
- push, pop

## Function Definitions

### `exit`
Accepts an exit code and terminates the current process.

---

### `string_length`
Accepts a pointer to a string and returns its length.

---

### `print_string`
Accepts a pointer to a null-terminated string and prints it to stdout.

---

### `print_char`
Accepts a character code directly as its first argument and prints it to stdout.

---

### `print_newline`
Prints a character with code `0xA`.

---

### `print_uint`
Outputs an unsigned 8-byte integer in decimal format.

**Implementation note:**  
It is recommended to create a buffer on the stack and store the division results there.  
Each time, divide the current value by 10 and store the corresponding digit in the buffer.  
Each digit must be converted to its ASCII code (e.g. `0x04` becomes `0x34`).

---

### `print_int`
Outputs a signed 8-byte integer in decimal format.

---

### `read_char`
Reads one character from stdin and returns it.  
If the end of the input stream occurs, returns `0`.

---

### `read_word`
Accepts a buffer address and its size as arguments.  
Reads the next word from stdin (skipping whitespaces) into the buffer.

- Stops and returns `0` if the word is too large for the buffer.
- Otherwise returns the buffer address.
- The resulting string is null-terminated.

---

### `parse_uint`
Accepts a null-terminated string and attempts to parse an unsigned number from its beginning.

- Parsed number is returned in `rax`
- Number of parsed characters is returned in `rdx`

---

### `parse_int`
Accepts a null-terminated string and attempts to parse a signed number from its beginning.

- Parsed number is returned in `rax`
- Number of parsed characters (including the sign, if present) is returned in `rdx`
- No spaces are allowed between the sign and the digits

---

### `string_equals`
Accepts two pointers to strings and compares them.

- Returns `1` if they are equal
- Returns `0` otherwise

---

### `string_copy`
Accepts:
- a pointer to a source string
- a pointer to a destination buffer
- the buffer length

Copies the string into the destination buffer.

- Returns the destination address if the string fits
- Returns `0` otherwise


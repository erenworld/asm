#!/bin/sh
nasm -f elf64 hello.asm -o hello.o
gcc hello.o -o hello
./hello

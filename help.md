docker run -it --rm \
  --platform linux/amd64 \
  -v "$PWD":/work \
  -w /work \
  ubuntu:22.04

apt update
apt install -y nasm gcc

nasm -f elf64 exit.asm -o exit.o
ld exit.o -o exit
./exit
echo $?

Un binaire, c’est comme une clé :
“64 bits” = longueur de la clé
architecture = forme des dents
OS = serrure
Même longueur ≠ même serrure.

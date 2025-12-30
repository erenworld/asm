NAME = test_strlen
ASM = nasm
ASMFLAGS = -f elf64
LD = ld
SRC = tests/test_strlen.asm mystrlen.asm
OBJ = $(SRC:.asm=.o)

# Docker settings
DOCKER_IMAGE = asm_test
DOCKER_RUN = docker run --rm -v $(PWD):/work $(DOCKER_IMAGE)

all: $(NAME)

$(NAME): $(OBJ)
	$(LD) $(OBJ) -o $(NAME)

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all

# Docker targets
docker-build:
	docker build -t $(DOCKER_IMAGE) .

docker-test: docker-build
	$(DOCKER_RUN) make re
	$(DOCKER_RUN) ./$(NAME)

docker-shell: docker-build
	$(DOCKER_RUN) /bin/bash

docker-clean:
	docker rmi $(DOCKER_IMAGE) || true

.PHONY: clean fclean re docker-build docker-test docker-shell docker-clean

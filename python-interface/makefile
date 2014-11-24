
TARGETS = poisson
DATA = meshes/example.*

ROOT_DIR = ..
include ../Rules.mk

poisson: triangle_meshes.o fe.o glue.o poisson.o
	$(CC) -o $@ $^ $(LFLAGS) $(CCFLAGS) -lgfortran


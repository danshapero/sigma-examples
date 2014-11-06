
ROOT_DIR = ..
include ../Rules.mk

TARGETS = poisson

poisson: triangle_meshes.o fe.o poisson.o
	$(FC) -o $@ $^ $(LFLAGS) $(FCFLAGS)



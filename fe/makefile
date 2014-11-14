
TARGETS = poisson

ROOT_DIR = ..
include ../Rules.mk

poisson: triangle_meshes.o fe.o poisson.o
	$(FC) -o $@ $^ $(LFLAGS) $(FCFLAGS)



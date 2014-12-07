
TARGETS = poisson
DATA = meshes/example.*

ROOT_DIR = ..
include ../Rules.mk

mesh:
	cd meshes && python make_mesh.py && cd ../

poisson: triangle_meshes.o fe.o fe_solver.o poisson.o
	$(CC) -o $@ $^ $(LFLAGS) $(CCFLAGS) -lgfortran -lm



TARGETS = c_mesh_test
DATA = meshes/example.*

ROOT_DIR = ..
include ../Rules.mk

c_mesh_test: triangle_meshes.o glue.o c_mesh_test.o
	$(CC) -o $@ $^ $(LFLAGS) $(CCFLAGS) -lgfortran


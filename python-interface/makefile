
TARGETS = glue_test c_mesh_test
DATA = meshes/example.*

ROOT_DIR = ..
include ../Rules.mk

glue_test: triangle_meshes.o glue.o glue_test.o
	$(CC) -o $@ $^ $(LFLAGS) $(CCFLAGS) -lgfortran

c_mesh_test: triangle_meshes.o c_mesh_test.o
	$(CC) -o $@ $^ $(LFLAGS) $(CCFLAGS) -lgfortran


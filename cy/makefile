
TARGETS = read_mesh.so read_mesh.c

ROOT_DIR = ..
include ../Rules.mk

meshes:
	cd meshes && python make_mesh.py && cd ../

read_mesh.c: read_mesh.pyx
	cython read_mesh.pyx

read_mesh.o: read_mesh.c
	$(CC) -c read_mesh.c -pthread -O2 -fwrapv -fno-strict-aliasing -I/usr/include/python2.7 $(CCFLAGS)

read_mesh.so: read_mesh.o fe.o fe_solver.o
	$(CC) -shared -o read_mesh.so fe.o fe_solver.o read_mesh.o -lgfortran $(LFLAGS)

all: read_mesh.so meshes


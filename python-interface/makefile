
TARGETS = sigma_wrapper.so sigma_wrapper.c

ROOT_DIR = ..
include ../Rules.mk

meshes:
	cd meshes && python make_mesh.py && cd ../

sigma_wrapper.c: sigma_wrapper.pyx
	cython sigma_wrapper.pyx

sigma_wrapper.o: sigma_wrapper.c
	$(CC) -c sigma_wrapper.c -pthread -O2 -fwrapv -fno-strict-aliasing -I/usr/include/python2.7 $(CCFLAGS)

sigma_wrapper.so: sigma_wrapper.o fe.o fe_solver.o
	$(CC) -shared -o sigma_wrapper.so fe.o fe_solver.o sigma_wrapper.o -lgfortran $(LFLAGS)

all: sigma_wrapper.so meshes


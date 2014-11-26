
CC = gcc
CCFLAGS = -std=c99

meshes:
	cd meshes && python make_mesh.py && cd ../

libthingy.so: thingy.o
	$(CC) -shared -o libthingy.so thingy.o -lm

thingy.o: thingy.c thingy.h
	$(CC) -c thingy.c $(CCFLAGS) -fPIC

read_mesh.so: libthingy.so
	LDFLAGS="-L./" python setup.py build_ext --inplace

all: read_mesh.so meshes



.PHONY: clean
.SECONDARY:

CC = gcc
FC = gfortran

LFLAGS = -lsigma -L$(SIGMA_DIR)/lib
IFLAGS = -I$(SIGMA_DIR)/include
CCFLAGS = -std=c99 -fPIC
FCFLAGS = -fPIC

all: $(TARGETS)

%.o: %.f90
	$(FC) -o $@ -c $< $(FCFLAGS) $(IFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CCFLAGS) $(IFLAGS)

clean:
	rm -rf *.o *.mod *.pyc $(TARGETS) $(DATA)


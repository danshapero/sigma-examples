
.PHONY: clean
.SECONDARY:

CC = gcc
FC = gfortran

FCFLAGS = -g -fbounds-check
LFLAGS = -lsigma -L$(SIGMA_DIR)/lib
IFLAGS = -I$(SIGMA_DIR)/include

all: $(TARGETS)

%.o: %.f90
	$(FC) -o $@ -c $< $(FCFLAGS) $(IFLAGS)

clean:
	rm -rf *.o *.mod *.pyc $(TARGETS)


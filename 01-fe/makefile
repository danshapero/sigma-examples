
TARGETS = poisson
DATA = u.txt u.png meshes/example.*

ROOT_DIR = ..
include ../Rules.mk

poisson: triangle_meshes.o fe.o poisson.o
	$(FC) -o $@ $^ $(LFLAGS) $(FCFLAGS)

run: poisson
	@echo
	@echo o Making an example triangular mesh in folder examples/
	@cd meshes && python make_mesh.py && cd ../
	@echo o Solving Poisson problem on example mesh.
	@./poisson
	@echo o Plotting output, saving result to u.png.
	@python plot_output.py

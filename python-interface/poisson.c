
#include "triangle_meshes.h"
#include "fe_solver.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define max(a, b) (a < b) ? b : a;
#define min(a, b) (a < b) ? a : b;

int main(int argc, char **argv) {
    triangle_mesh mesh;
    bool success = read_mesh(&mesh, "meshes/example.2");

    if (success) {
        printf("Successfully read mesh! Hoorah!\n");
    } else {
        printf("Womp womp, failed to read mesh.\n");
        return 1;
    }

    /* Allocate some vectors */
    double *u = calloc(mesh.num_nodes, sizeof(double));
    double *f = calloc(mesh.num_nodes, sizeof(double));

    for (int i = 0; i < mesh.num_nodes; i++) {
        u[i] = 0.0;

        /* Fill the RHS vector with some silly trig function */
        f[i] = sin(mesh.x[i]) * cos(mesh.y[i]);
    }

    printf("Solving -D^2 u = f, where f(x, y) = sin(x) * cos(y)\n");

    /* Call the Fortran function which uses SiGMA to do all the
       numerical work */
    fe_solve(mesh.num_nodes,
            mesh.num_edges,
            mesh.num_triangles,
            mesh.x,
            mesh.y,
            mesh.edges,
            mesh.triangles,
            mesh.node_boundary,
            f, u);

    /* Get the minimum and maximum of the solution */
    double mi = 0.0, ma = 0.0;

    for (int i = 0; i < mesh.num_nodes; i++) {
        mi = min(mi, u[i]);
        ma = max(ma, u[i]);
    }

    printf("Minimum and maximum of solution u: (%g, %g)\n", mi, ma);

    free(u);
    destroy_mesh(&mesh);

    printf("All done!\n");

    return 0;
}

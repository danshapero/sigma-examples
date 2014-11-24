
#include "triangle_meshes.h"
#include "glue.h"
#include <stdio.h>
#include <stdlib.h>

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

    double *u = calloc(mesh.num_nodes, sizeof(double));

    for (int i = 0; i < mesh.num_nodes; i++) u[i] = 0.0;

    driver(mesh.num_nodes, mesh.num_edges, mesh.num_triangles,
            mesh.x, mesh.y, mesh.edges, mesh.triangles, mesh.node_boundary, u);

    double mi = 0.0, ma = 0.0;

    for (int i = 0; i < mesh.num_nodes; i++) {
        mi = min(mi, u[i]);
        ma = max(ma, u[i]);
    }

    printf("%g %g\n", mi, ma);

    free(u);
    destroy_mesh(&mesh);

    return 0;
}

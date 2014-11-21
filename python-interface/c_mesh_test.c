
#include "triangle_meshes.h"
#include "glue.h"
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char **argv) {
    triangle_mesh mesh;
    bool success = read_mesh(&mesh, "meshes/example.2");

    if (success) {
        printf("Successfully read mesh! Hoorah!\n");
    } else {
        printf("Womp womp, failed to read mesh.\n");
        return 1;
    }

    double *u = (double *) malloc( mesh.num_nodes * sizeof(double) );

    for (int i = 0; i < mesh.num_nodes; i++) u[i] = 0.0;

    driver(mesh.num_nodes, mesh.num_edges, mesh.num_triangles,
            u, mesh.x, mesh.y, mesh.edges, mesh.triangles);

    printf("%lf %lf\n", u[0], u[1]);

    return 0;
}

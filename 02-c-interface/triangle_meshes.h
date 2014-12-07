
#ifndef TRIANGLE_MESHES_H
#define TRIANGLE_MESHES_H

#include <stdbool.h>

typedef struct {
    int num_nodes, num_edges, num_triangles;
    int *edges, *triangles, *neighbors;
    int *node_boundary, *edge_boundary;
    double *x, *y;
} triangle_mesh;

bool read_mesh(triangle_mesh *mesh, const char *filename);
void destroy_mesh(triangle_mesh *mesh);

#endif


#include "triangle_meshes.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


bool read_mesh(triangle_mesh *mesh, const char *file_name) {
    char node_file_name[80];
    strcpy(node_file_name, file_name);
    strcat(node_file_name, ".node");

    FILE *fid = fopen(node_file_name, "r");

    if (!fid) return false;

    int num_nodes = 0, dummy;
    fscanf(fid, "%d %d %d %d", &num_nodes, &dummy, &dummy, &dummy);

    double *x = mesh->x;
    double *y = mesh->y;
    int *node_boundary = mesh->node_boundary;

    x = (double *) malloc(num_nodes * sizeof(double));
    y = (double *) malloc(num_nodes * sizeof(double));
    node_boundary = (int *) malloc(num_nodes * sizeof(int));

    for (int i = 0; i < num_nodes; i++) {
        fscanf(fid, "%d %lf %lf %d", &dummy, x + i, y + i, node_boundary + i);
    }

    fclose(fid);

    return true;
}

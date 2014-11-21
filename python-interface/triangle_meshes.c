
#include "triangle_meshes.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


bool read_mesh(triangle_mesh *mesh, const char *file_name) {

    /* Read in the node file */
    char node_file_name[80];
    strcpy(node_file_name, file_name);
    strcat(node_file_name, ".node");

    FILE *fid = fopen(node_file_name, "r");

    if (!fid) return false;

    int num_nodes = 0, dummy;
    fscanf(fid, "%d %d %d %d", &num_nodes, &dummy, &dummy, &dummy);

    mesh->x = calloc(num_nodes, sizeof(double));
    mesh->y = calloc(num_nodes, sizeof(double));
    mesh->node_boundary = calloc(num_nodes, sizeof(int));

    for (int i = 0; i < num_nodes; i++) {
        fscanf(fid, "%d %lf %lf %d", &dummy, mesh->x + i,
                                             mesh->y + i,
                                             mesh->node_boundary + i);
    }

    mesh->num_nodes = num_nodes;

    fclose(fid);


    /* Read in the edge file */
    char edge_file_name[80];
    strcpy(edge_file_name, file_name);
    strcat(edge_file_name, ".edge");

    fid = fopen(edge_file_name, "r");

    if (!fid) return false;

    int num_edges = 0;
    fscanf(fid, "%d %d", &num_edges, &dummy);

    mesh->edges = calloc(2 * num_edges, sizeof(int));
    mesh->edge_boundary = calloc(num_edges, sizeof(int));

    for (int i = 0; i < num_edges; i++) {
        fscanf(fid, "%d %d %d %d", &dummy, mesh->edges + 2*i,
                                           mesh->edges + 2*i + 1,
                                           mesh->edge_boundary + i);
    }

    mesh->num_edges = num_edges;

    fclose(fid);


    /* Read in the triangle file */
    char element_file_name[80];
    strcpy(element_file_name, file_name);
    strcat(element_file_name, ".ele");

    fid = fopen(element_file_name, "r");

    if (!fid) return false;

    int num_triangles = 0;
    fscanf(fid, "%d %d %d", &num_triangles, &dummy, &dummy);

    mesh->triangles = calloc(3 * num_triangles, sizeof(int));

    for (int i = 0; i < num_triangles; i++) {
        fscanf(fid, "%d %d %d %d", &dummy, mesh->triangles + 3*i,
                                           mesh->triangles + 3*i + 1,
                                           mesh->triangles + 3*i + 2);
    }

    mesh->num_triangles = num_triangles;

    fclose(fid);


    /* Read in the neighbor file */
    char neighbor_file_name[80];
    strcpy(neighbor_file_name, file_name);
    strcat(neighbor_file_name, ".neigh");

    fid = fopen(neighbor_file_name, "r");

    if (!fid) return false;

    fscanf(fid, "%d %d", &num_triangles, &dummy);

    mesh->neighbors = calloc(3 * num_triangles, sizeof(int));

    for (int i = 0; i < num_triangles; i++) {
        fscanf(fid, "%d %d %d %d", &dummy, mesh->neighbors + 3*i,
                                           mesh->neighbors + 3*i + 1,
                                           mesh->neighbors + 3*i + 2);
    }

    fclose(fid);

    return true;
}

void destroy_mesh(triangle_mesh *mesh) {
    mesh->num_nodes = 0;
    mesh->num_edges = 0;
    mesh->num_triangles = 0;

    free(mesh->edges);
    free(mesh->triangles);
    free(mesh->neighbors);
    free(mesh->node_boundary);
    free(mesh->edge_boundary);
    free(mesh->x);
    free(mesh->y);
}


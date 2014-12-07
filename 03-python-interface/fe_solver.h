
#ifndef FE_SOLVER_H
#define FE_SOLVER_H

void fe_solve(  int num_nodes,
                int num_edges,
                int num_triangles,
                double x[num_nodes],
                double y[num_nodes],
                int edges[2 * num_edges],
                int triangles[3 * num_triangles],
                int boundary[num_nodes],
                double f[num_nodes],
                double u[num_nodes] );

#endif


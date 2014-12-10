
import numpy as np
cimport numpy as np

cimport cython


cdef extern:
    void fe_solve(  int num_nodes,
                    int num_edges,
                    int num_triangles,
                    double *x, double *y,
                    int *edges,
                    int *triangles,
                    int *boundary,
                    double *f,
                    double *u   )


np.import_array()


@cython.boundscheck(False)
@cython.wraparound(False)
# ------------------------------------------------------------------------ #
def poisson_solve(  double[:] x,
                    double[:] y,
                    int[:] boundary,
                    int[:,:] edges,
                    int[:,:] triangles,
                    double[:] f):
# ------------------------------------------------------------------------ #
    """
    Solve the Poisson problem on a triangular mesh with a given right-hand
    side by invoking a Fortran procedure

    Parameters:
    ==========
    x, y: the coordinates of the mesh points
    boundary: boundary marker of each node; 0 if inside, >= 1 if node
    edges, triangles: lists of edges & triangles of the triangulation
    f: vector of nodal values for the right-hand side vector

    Returns:
    =======
    u: solution to Poisson problem
    """

    cdef int num_nodes = 0
    cdef int num_edges = 0
    cdef int num_triangles = 0

    # Get the mesh size
    num_nodes = x.shape[0]
    num_edges = edges.shape[0]
    num_triangles = triangles.shape[0]

    # Call a Fortran procedure to solve the PDE
    cdef double[:] u = np.zeros(num_nodes, dtype=np.double)
    fe_solve(num_nodes, num_edges, num_triangles,
            &x[0], &y[0], &edges[0,0], &triangles[0,0], &boundary[0],
            &f[0], &u[0])

    # Turn the typed memory view of the solution `u` into a numpy array
    U = np.asarray(u)

    return U


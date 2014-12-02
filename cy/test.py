
from sigma_wrapper import *
import matplotlib.pyplot as plt
import numpy as np

if __name__ == "__main__":
    x, y, boundary, edges, triangles, u = poisson_solve("meshes/example.2")
    triangles = np.asarray(map(lambda k: k - 1, triangles))
    plt.figure()
    plt.gca().set_aspect('equal')
    plt.tricontourf(x, y, triangles, u, 36, shading = 'faceted')
    plt.colorbar()
    plt.show()

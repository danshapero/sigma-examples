
from read_mesh import *
import numpy as np
import matplotlib.pyplot as plt

x, y, ele, bnd = read_triangle_mesh("meshes/example.2")

nn = len(x)
u = np.zeros(nn)

fid = open("u.txt", "r")
for i in range(nn):
    u[i] = float(fid.readline())
fid.close()

plt.figure()
plt.gca().set_aspect('equal')
plt.tricontourf(x, y, ele, u, 48, shading='faceted')
plt.colorbar()
plt.savefig("u.png")

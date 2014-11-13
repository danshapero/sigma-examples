
import os

import numpy as np
import matplotlib.pyplot as plt


# ----------------------------------
# Fetch the meshes from the internet
url = "http://students.washington.edu/shapero/sigma-example-data/"
for extension in ["node", "ele", "neigh", "edge", "poly"]:
    os.system("wget " + url + "helheim.2." + extension + " -P meshes")


# -----------------
# Read in the nodes
fid = open("meshes/helheim.2.node", "r")

nn, _, _, _ = map(int, fid.readline().split())

x = np.zeros(nn)
y = np.zeros(nn)

for i in range(nn):
    x[i], y[i] = map(float, fid.readline().split())[1:3]

fid.close()


# ---------------------
# Read in the triangles
fid = open("meshes/helheim.2.ele", "r")
ne, _, _ = map(int, fid.readline().split())

ele = np.zeros((ne, 3), dtype = int)

for i in range(ne):
    ele[i, :] = map(int, fid.readline().split())[1:] - np.ones(3, dtype = int)

fid.close()


# -------------
# Plot the mesh
plt.figure()
plt.gca().set_aspect("equal")
plt.triplot(x/1000.0, y/1000.0, ele)
plt.title("Oh look. You found a mesh. Hurray.")
plt.show()



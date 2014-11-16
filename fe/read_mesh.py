
import numpy as np


# ------------------------------------------------------------------------ #
def read_triangle_mesh(filename):                                          #
# ------------------------------------------------------------------------ #
    fid = open(filename + ".node", "r")
    nn = int( fid.readline().split()[0] )

    x = np.zeros(nn)
    y = np.zeros(nn)
    bnd = np.zeros(nn, dtype = int)

    for i in range(nn):
        line = fid.readline().split()
        x[i] = float(line[1])
        y[i] = float(line[2])
        bnd[i] = int(line[3])

    fid.close()

    fid = open(filename + ".ele", "r")
    ne = int( fid.readline().split()[0] )

    ele = np.zeros((ne, 3), dtype = int)

    for i in range(ne):
        ele[i,:] = map(lambda j: j-1, map(int, fid.readline().split()[1:]))

    fid.close()

    return x, y, ele, bnd


import os
from math import sin, cos, tanh, atanh, sqrt
import numpy as np

pi = np.pi
nn = 64

# ---------------------------------------------------------------------------- #
# Generate an initial coarse mesh                                              #
# ---------------------------------------------------------------------------- #

if not os.path.exists("example.poly"):
    R = np.asarray([1.0, 0.3, 0.225, 0.1])
    X = np.asarray([0.0, 0.3, -0.65, 0.02])
    Y = np.asarray([0.0, 0.3, 0.05, -0.5])

    x = np.zeros(4 * nn)
    y = np.zeros(4 * nn)

    for i in range(4):
        for k in range(nn):
            x[k + i*nn] = X[i] + R[i] * cos(2 * pi * k / nn)
            y[k + i*nn] = Y[i] + R[i] * sin(2 * pi * k / nn)

    fid = open("example.poly", "w")

    # Write out the nodes
    fid.write("{0} {1} {2} {3}\n".format(4*nn, 2, 0, 1))

    for k in range(4*nn):
        fid.write("{0} {1} {2} {3}\n".format(k + 1, x[k], y[k], k / nn + 1))

    # Write out the edges
    fid.write("{0} {1}\n".format(4*nn, 1))
    for q in range(4):
        for k in range(nn):
            fid.write("{0} {1} {2} {3}\n".format(q*nn + k + 1,
                               q*nn + k + 1, q*nn + (k + 1) % nn + 1, q + 1))

    # Write out the holes
    fid.write("3\n")
    fid.write("1 0.3 0.4\n")
    fid.write("2 -0.65 0.05\n")
    fid.write("3 0.02 -0.5\n")

    fid.close()



# ---------------------------------------------------------------------------- #
# Generate a refined mesh                                                      #
# ---------------------------------------------------------------------------- #

if not os.path.exists("example.1.node"):
    coarse_area = 0.005

    os.system("triangle -pqnea" + str(coarse_area) + " example.poly > /dev/null")

    # Load in the nodes of the generated mesh
    fid = open("example.1.node", "r")

    nn, _, _, _ = map(int, fid.readline().split())

    x = np.zeros(nn)
    y = np.zeros(nn)

    for k in range(nn):
        x[k], y[k] = map(float, fid.readline().split()[1:3])

    fid.close()


    # Load in the triangles of the generated mesh
    fid = open("example.1.ele", "r")

    ne, _, _ = map(int, fid.readline().split())

    triangles = np.zeros((ne, 3), dtype = int)

    for k in range(ne):
        triangles[k,:] = map(lambda j: j-1,
                                map(int, fid.readline().split()[1:]))

    fid.close()


if not os.path.exists("example.2.node"):
    # Generate the .area file for the refined mesh
    area = np.zeros(ne)
    r = np.zeros(4)

    fine_area = 0.01 * coarse_area
    alpha = atanh

    phi = lambda z: tanh(atanh(fine_area/coarse_area) + z)

    for k in range(ne):
        xk = sum(x[triangles[k,:]])/3
        yk = sum(y[triangles[k,:]])/3

        for i in range(4):
            r[i] = 2*R[i]*abs( sqrt((xk - X[i])**2 + (yk - Y[i])**2) - R[i] )

        area[k] = coarse_area * phi( np.min(r) )

    fid = open("example.1.area", "w")
    fid.write("{0}\n".format(ne))
    for k in range(ne):
        fid.write("{0} {1}\n".format(k + 1, area[k]))
    fid.close()

    os.system("triangle -rqnea example.1 > /dev/null")


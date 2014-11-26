
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#define PI 4*atan(1.0)
#define max(a, b) (a < b) ? b : a
#define min(a, b) (a < b) ? a : b

double bessel(double x, int n) {
    int N = 128;
    double tau = 0.0, z = 0.0, dx = PI / (N + 1);

    for (int k = 0; k < N; k++) {
        tau = k * dx;
        z += cos(n*tau - x*sin(tau)) * dx / PI;
    }

    return z;
}


void make_a_thing(int num_nodes, double *x, double *y, double *u) {
    double z;
    for (int i = 0; i < num_nodes; i++) {
        z = x[i]*x[i] + y[i]*y[i];
        u[i] = bessel(sqrt(z), 0);
    }
}

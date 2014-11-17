
#include "triangle_meshes.h"
#include <stdio.h>


int main(int argc, char **argv) {
    triangle_mesh mesh;
    bool success = read_mesh(&mesh, "meshes/example.2");

    if (success) {
        printf("Successfully read mesh! Hoorah!\n");
    } else {
        printf("Womp womp, failed to read mesh.\n");
        return 1;
    }

    return 0;
}

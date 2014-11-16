!--------------------------------------------------------------------------!
program poisson                                                            !
!--------------------------------------------------------------------------!

use sigma
use fe

implicit none

    type(triangle_mesh) :: mesh
    type(cs_graph), pointer :: g
    type(csr_matrix) :: A, B
    type(bicgstab_solver) :: bcg
    type(sparse_ldu_solver) :: ildu
    real(dp), allocatable :: u(:), f(:), z(:)
    integer :: i, j, k, d, nn
    integer, allocatable :: nodes(:)
    logical :: success

    call init_seed()

    success = mesh%read_mesh("meshes/example.2")

    if (.not. success) then
        print *, "Oh no! Failed to read mesh!"
        call exit(1)
    endif

    nn = mesh%num_nodes

    print *, "    + Successfully read triangular mesh."
    print *, "        - Number of nodes:    ", mesh%num_nodes
    print *, "        - Number of edges:    ", mesh%num_edges
    print *, "        - Number of triangles:", mesh%num_triangles

    allocate(g)
    call build_connectivity_graph(g, mesh)
    call A%set_dimensions(nn, nn)
    call B%set_dimensions(nn, nn)
    call A%set_graph(g)
    call B%set_graph(g)
    call A%zero()
    call B%zero()

    call fill_poisson_stiffness_matrix(A, mesh)
    call fill_p1_mass_matrix(B, mesh)

    print *, "    + Built finite element stiffness and mass matrices."
    print *, "    + Generating random right-hand side for Poisson problem."

    allocate(u(nn), f(nn), z(nn))
    u = 0.0_dp
    f = 0.0_dp

    call random_number(z)
    z = z - 0.5_dp

    call B%matvec(z, f)

    d = g%get_max_degree()
    allocate(nodes(d))

    do i = 1, nn
        if (mesh%node_boundary(i) /= 0) then
            call g%get_neighbors(nodes, i)
            d = g%get_degree(i)

            do k = 1, d
                j = nodes(k)
                call A%set(i, j, 0.0_dp)
            enddo

            call A%set(i, i, 1.0_dp)

            f(i) = 0.0_dp
        endif
    enddo


    call bcg%setup(A)

    call bcg%solve(A, u, f)

    print *, "    + Done solving Poisson problem."
    print *, "      BiCG-Stab solver iterations:", bcg%iterations
    print *, "    + Writing output to file u.txt."


    open(file = "u.txt", unit = 10)
    do i = 1, nn
        write(10, *) u(i)
    enddo
    close(10)


    call bcg%destroy()
    call B%destroy()
    call A%destroy()
    call g%destroy()
    deallocate(g)
    deallocate(u, f, z)

end program poisson

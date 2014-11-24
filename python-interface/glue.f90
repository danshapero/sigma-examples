!==========================================================================!
module glue                                                                !
!==========================================================================!

use iso_c_binding
use sigma
use fe

implicit none


contains



!--------------------------------------------------------------------------!
subroutine driver(num_nodes, num_edges, num_triangles, &                   !
                        & x, y, edges, triangles, boundary, u) bind(c)     !
!--------------------------------------------------------------------------!
    ! imput/output variables
    integer(c_int), intent(in), value :: num_nodes, num_edges, num_triangles
    real(c_double), intent(in) :: x(num_nodes), y(num_nodes)
    integer(c_int), intent(in) :: edges(2, num_edges), &
                                & triangles(3, num_triangles), &
                                & boundary(num_nodes)
    real(c_double), intent(inout) :: u(num_nodes)
    ! local variables
    integer :: i, j, k, d
    integer, allocatable :: nodes(:)
    type(cs_graph), pointer :: g
    type(csr_matrix) :: A, B
    type(bicgstab_solver) :: bcg
    type(sparse_ldu_solver) :: ildu
    real(dp) :: f(num_nodes), z(num_nodes)

    allocate(g)
    call build_connectivity_graph(g, num_nodes, num_edges, edges)

    call A%set_dimensions(num_nodes, num_nodes)
    call B%set_dimensions(num_nodes, num_nodes)

    call A%set_graph(g)
    call B%set_graph(g)
    call A%zero()
    call B%zero()

    call fill_poisson_stiffness_matrix(A, x, y, triangles)
    call fill_p1_mass_matrix(B, x, y, triangles)

    u = 0.0_dp
    f = 0.0_dp

    call init_seed()

    call random_number(z)
    z = z - 0.5_dp

    call B%matvec(z, f)

    d = g%get_max_degree()
    allocate(nodes(d))

    do i = 1, num_nodes
        if (boundary(i) /= 0) then
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
    call ildu%setup(A)

    call bcg%solve(A, u, f, ildu)

    call bcg%destroy()
    call ildu%destroy()
    call B%destroy()
    call A%destroy()
    call g%destroy()
    deallocate(g)

end subroutine driver



end module glue


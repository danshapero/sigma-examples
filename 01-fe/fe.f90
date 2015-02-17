!==========================================================================!
module fe                                                                  !
!==========================================================================!
!==== This module contains procedures for generating matrices that     ====!
!==== discretize partial differential equations via the finite element ====!
!==== method.                                                          ====!
!==========================================================================!

use triangle_meshes
use sigma

implicit none


contains


!--------------------------------------------------------------------------!
subroutine build_connectivity_graph(g, mesh)                               !
!--------------------------------------------------------------------------!
! This procedure takes in a Triangle mesh and builds the graph `g` which   !
! represents the connectivity between all of the nodes. It is one of the   !
! first phases in constructing a finite element discretization.            !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(graph_interface), intent(inout) :: g
    type(triangle_mesh), intent(in) :: mesh
    ! local variables
    integer :: i, j, k, nn

    nn = mesh%num_nodes

    call g%init(nn, nn)
    call g%build(nn, nn, get_edges, make_cursor)

contains
    !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - !
    function make_cursor() result(cursor)                                  !
    ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -!
        type(graph_edge_cursor) :: cursor

        cursor%first = 1
        cursor%last = 2 * mesh%num_edges + mesh%num_nodes

        cursor%current = 0

    end function make_cursor


    !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - !
    subroutine get_edges(edges, cursor, num_edges, num_returned)           !
    ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -!
    ! Not going to lie, this is a little ugly. We need an edge iterator to !
    ! go through all of the edges of the mesh, but only half the edges are !
    ! stored in the mesh data structure. So we have to iterate through the !
    ! edges once, then another time reversing the direction of the edges.  !
    ! Then we have to include all the diagonal elements.                   !
    !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - !
        ! input/output variables
        integer, intent(in) :: num_edges
        integer, intent(out) :: edges(2, num_edges)
        type(graph_edge_cursor), intent(inout) :: cursor
        integer, intent(out) :: num_returned
        ! local variables
        integer :: k, ord(2)

        edges = 0

        if (cursor%current < 2 * mesh%num_edges) then
            k = mod(cursor%current, mesh%num_edges)
            num_returned = min(num_edges, mesh%num_edges - k)

            ord = [1, 2]
            if (cursor%current >= mesh%num_edges) ord = [2, 1]
            edges(:, 1: num_returned) = mesh%edges(ord, k+1: k+num_returned)
        else
            num_returned = min(num_edges, cursor%last - cursor%current)
            k = cursor%current - 2 * mesh%num_edges
            edges(1, 1: num_returned) = [(i, i = k+1, k+num_returned)]
            edges(2, 1: num_returned) = [(i, i = k+1, k+num_returned)]
        endif

        cursor%current = cursor%current + num_returned

    end subroutine get_edges

end subroutine build_connectivity_graph



!--------------------------------------------------------------------------!
subroutine fill_poisson_stiffness_matrix(A, mesh)                          !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(sparse_matrix_interface), intent(inout) :: A
    type(triangle_mesh), intent(in) :: mesh
    ! local variables
    integer :: i, j, k, n, nt, ele(3)
    real(dp) :: AE(3, 3), V(3, 2), det, area

    associate(x => mesh%x, triangles => mesh%triangles)

    call A%zero()

    nt = mesh%num_triangles
    do n = 1, nt
        ele = triangles(:, n)
        AE = 0.0_dp

        do i = 1, 3
            j = ele(mod(i, 3)     + 1)
            k = ele(mod(i + 1, 3) + 1)

            V(i, 1) = x(2, j) - x(2, k)
            V(i, 2) = x(1, k) - x(1, j)
        enddo

        det = V(1, 1)*V(2, 2) - V(1, 2)*V(2, 1)
        area = dabs(det) / 2

        AE = 0.25 / area * matmul(V, transpose(V))

        call A%add(ele, ele, AE)
    enddo

    end associate

end subroutine fill_poisson_stiffness_matrix



!--------------------------------------------------------------------------!
subroutine fill_p1_mass_matrix(B, mesh)                                    !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(sparse_matrix_interface), intent(inout) :: B
    type(triangle_mesh), intent(in) :: mesh
    ! local variables
    integer :: i, j, k, n, nt, ele(3)
    real(dp) :: BE(3, 3), area

    associate(x => mesh%x, triangles => mesh%triangles)

    call B%zero()

    nt = mesh%num_triangles
    do n = 1, nt
        ele = mesh%triangles(:, n)
        BE = 0.0_dp

        do j = 1, 2
            do i = 1, 2
                BE(i, j) = x(i, ele(j)) - x(i, ele(3))
            enddo
        enddo
        area = 0.5 * dabs(BE(1, 1)*BE(2, 2) - BE(1, 2)*BE(2, 1))

        BE = area / 12.0_dp
        do i = 1, 3
            BE(i, i) = area / 6.0_dp
        enddo

        call B%add(ele, ele, BE)

    enddo

    end associate

end subroutine fill_p1_mass_matrix




end module fe

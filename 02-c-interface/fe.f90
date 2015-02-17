!==========================================================================!
module fe                                                                  !
!==========================================================================!

use sigma

implicit none

contains




!--------------------------------------------------------------------------!
subroutine build_connectivity_graph(g, nn, ne, mesh_edges)                 !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(graph_interface), intent(inout) :: g
    integer, intent(in) :: nn, ne, mesh_edges(:,:)
    ! local variables
    integer :: i, j, k

    call g%init(nn, nn)
    call g%build(nn, nn, get_edges, make_cursor)

contains
    !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - !
    function make_cursor() result(cursor)                                  !
    ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -!
        type(graph_edge_cursor) :: cursor

        cursor%first = 1
        cursor%last = 2 * ne + nn

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

        if (cursor%current < 2 * ne) then
            k = mod(cursor%current, ne)
            num_returned = min(num_edges, ne - k)

            ord = [1, 2]
            if (cursor%current >= ne) ord = [2, 1]
            edges(:, 1: num_returned) = mesh_edges(ord, k+1: k+num_returned)
        else
            num_returned = min(num_edges, cursor%last - cursor%current)
            k = cursor%current - 2 * ne
            edges(1, 1: num_returned) = [(i, i = k+1, k+num_returned)]
            edges(2, 1: num_returned) = [(i, i = k+1, k+num_returned)]
        endif

        cursor%current = cursor%current + num_returned

    end subroutine get_edges

end subroutine build_connectivity_graph



!--------------------------------------------------------------------------!
subroutine fill_poisson_stiffness_matrix(A, x, y, triangles)               !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(sparse_matrix_interface), intent(inout) :: A
    real(dp), intent(in) :: x(:), y(:)
    integer, intent(in) :: triangles(:,:)
    ! local variables
    integer :: i, j, k, n, nt, ele(3)
    real(dp) :: AE(3, 3), V(3, 2), det, area

    call A%zero()

    nt = size(triangles, 2)
    do n = 1, nt
        ele = triangles(:, n)
        AE = 0.0_dp

        do i = 1, 3
            j = ele(mod(i, 3)   + 1)
            k = ele(mod(i+1, 3) + 1)

            V(i, 1) = y(j) - y(k)
            V(i, 2) = x(k) - x(j)
        enddo

        det = V(1, 1)*V(2, 2) - V(1, 2)*V(2, 1)
        area = dabs(det) / 2

        AE = 0.25 / area * matmul(V, transpose(V))

        call A%add(ele, ele, AE)
    enddo

end subroutine fill_poisson_stiffness_matrix



!--------------------------------------------------------------------------!
subroutine fill_p1_mass_matrix(B, x, y, triangles)                         !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(sparse_matrix_interface), intent(inout) :: B
    real(dp), intent(in) :: x(:), y(:)
    integer, intent(in) :: triangles(:,:)
    ! local variables
    integer :: i, j, k, n, nt, ele(3)
    real(dp) :: BE(3, 3), area

    call B%zero()

    nt = size(triangles, 2)
    do n = 1, nt
        ele = triangles(:, n)
        BE = 0.0_dp

        do i = 1, 2
            BE(1, i) = x(ele(i)) - x(ele(3))
            BE(2, i) = y(ele(i)) - y(ele(3))
        enddo
        area = dabs(BE(1, 1)*BE(2, 2) - BE(1, 2)*BE(2, 1)) / 2

        BE = area / 12.0_dp
        do i = 1, 3
            BE(i, i) = area / 6.0_dp
        enddo

        call B%add(ele, ele, BE)
    enddo

end subroutine fill_p1_mass_matrix




end module fe

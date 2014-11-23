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





end module fe

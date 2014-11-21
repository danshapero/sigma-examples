!==========================================================================!
module glue                                                                !
!==========================================================================!

use iso_c_binding
use sigma

implicit none


contains



!--------------------------------------------------------------------------!
subroutine driver(num_nodes, num_edges, num_triangles, &                   !
                                    & u, x, y, edges, triangles) bind(c)   !
!--------------------------------------------------------------------------!
    ! imput/output variables
    integer(c_int), intent(in), value :: num_nodes, num_edges, num_triangles
    real(c_double), intent(inout) :: u(num_nodes)
    real(c_double), intent(in) :: x(num_nodes), y(num_nodes)
    integer(c_int), intent(in) :: edges(2 * num_edges), &
                                & triangles(3 * num_triangles)
    ! local variables
    integer :: i, j, k

    do i = 1, num_nodes
        u(i) = 1.0
    enddo

end subroutine driver




end module glue

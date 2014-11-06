!==========================================================================!
module triangle_meshes                                                     !
!==========================================================================!
!==== This module contains procedures for reading triangular meshes as ====!
!==== generated by the programs Triangle / Tetgen.                     ====!
!==========================================================================!

use types, only: dp

implicit none


!--------------------------------------------------------------------------!
type :: triangle_mesh                                                      !
!--------------------------------------------------------------------------!
    integer :: num_nodes, num_edges, num_triangles
    integer, allocatable  :: edges(:,:), triangles(:,:), neighbors(:,:)
    integer, allocatable  :: node_boundary(:), edge_boundary(:)
    real(dp), allocatable :: x(:,:)
contains
    procedure :: read_mesh
    procedure, private :: read_nodes
    procedure, private :: read_edges
    procedure, private :: read_triangles
    procedure, private :: read_neighbors
    procedure, private :: destroy
end type triangle_mesh


private
public :: triangle_mesh


contains



!--------------------------------------------------------------------------!
subroutine read_mesh(mesh, filename)                                      !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(triangle_mesh), intent(inout) :: mesh 
    character(len=*), intent(in) :: filename
    ! local variables
    logical :: file_read_success

    file_read_success = mesh%read_nodes(filename)
    file_read_success = mesh%read_edges(filename)
    file_read_success = mesh%read_triangles(filename)
    file_read_success = mesh%read_neighbors(filename)

end subroutine read_mesh



!--------------------------------------------------------------------------!
function read_nodes(mesh, filename) result(success)                        !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(triangle_mesh), intent(inout) :: mesh
    character(len=*), intent(in) :: filename
    logical :: success
    ! local variables
    integer :: i, k, d, nn

    inquire(file = filename // ".node", exist = success)

    if (success) then
        open(file = filename // ".node", unit = 10)

        read(10, *) nn, d, i, i

        mesh%num_nodes = nn

        allocate(mesh%node_boundary(nn), mesh%x(d, nn))

        do i = 1, nn
            read(10, *) k, mesh%x(:, i), mesh%node_boundary(i)
        enddo

        close(10)
    endif

end function read_nodes



!--------------------------------------------------------------------------!
function read_edges(mesh, filename) result(success)                        !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(triangle_mesh), intent(inout) :: mesh
    character(len=*), intent(in) :: filename
    logical :: success
    ! local variables
    integer :: i, k, ne

    inquire(file = filename // ".edge", exist = success)

    if (success) then
        open(file = filename // ".edge", unit = 10)

        read(10, *) ne, k

        mesh%num_edges = ne

        allocate(mesh%edges(2, ne), mesh%edge_boundary(ne))

        do i = 1, ne
            read(10, *) k, mesh%edges(:, i), mesh%edge_boundary(i)
        enddo

        close(10)
    endif

end function read_edges



!--------------------------------------------------------------------------!
function read_triangles(mesh, filename) result(success)                    !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(triangle_mesh), intent(inout) :: mesh
    character(len=*), intent(in) :: filename
    logical :: success
    ! local variables
    integer :: i, k, nt

    inquire(file = filename // ".ele", exist = success)

    if (success) then
        open(file = filename // ".ele", unit = 10)

        read(10, *) nt, i, k

        mesh%num_triangles = nt

        allocate(mesh%triangles(3, nt))

        do i = 1, nt
            read(10, *) k, mesh%triangles(:, i)
        enddo

        close(10)
    endif

end function read_triangles



!--------------------------------------------------------------------------!
function read_neighbors(mesh, filename) result(success)                    !
!--------------------------------------------------------------------------!
    ! input/output variables
    class(triangle_mesh), intent(inout) :: mesh
    character(len=*), intent(in) :: filename
    logical :: success
    ! local variables
    integer :: i, k, nt

    inquire(file = filename // ".neigh", exist = success)

    if (success) then
        open(file = filename // ".neigh", unit = 10)

        read(10, *) nt, k

        allocate(mesh%neighbors(3, mesh%num_triangles))

        do i = 1, mesh%num_triangles
            read(10, *) k, mesh%neighbors(:, i)
        enddo

        close(10)
    endif

end function read_neighbors



!--------------------------------------------------------------------------!
subroutine destroy(mesh)                                                   !
!--------------------------------------------------------------------------!
    class(triangle_mesh), intent(inout) :: mesh

    deallocate(mesh%x, mesh%edges, mesh%triangles, mesh%neighbors, &
                & mesh%node_boundary, mesh%edge_boundary)

    mesh%num_nodes = 0
    mesh%num_triangles = 0
    mesh%num_edges = 0

end subroutine destroy




end module triangle_meshes



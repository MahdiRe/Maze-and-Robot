/* Maze
 * Author: Mahdi
 * Creation date: 12/10/2020
 */
MACHINE
    Maze

CONSTANTS
    Grid, Internal_wall, Entrance_squar, Exit_squar, X_range, Y_range

PROPERTIES
    /*
     * X_range is a subset of natural number and contains numbers from 1 to 7
     * Y_range is a subset of natural number and contains numbers from 1 to 5
    */
    X_range <: NATURAL1 & X_range = 1..7 &
    Y_range <: NATURAL1 & Y_range = 1..5 &
    /*
     * Grid is a set of relation between X_range and Y_range
    */
    Grid : X_range <-> Y_range &
    Grid = X_range * Y_range &

    /*
     * Internal_wall is a subset of Grid
     * It has a set of ordered pairs
    */
    Internal_wall <: Grid &
    Internal_wall = { ( 1|->3 ), ( 2|->1 ), ( 2|->3 ), ( 2|->5 ), ( 3|->3 ), ( 4|->2 ),
                      ( 4|->3 ), ( 4|->4 ), ( 6|->1 ), ( 6|->2 ), ( 6|->4 ), ( 7|->4 ) } &

    /*
     * Entrance_squar is an element of Grid & mapped domain 1 to range 1
    */
    Entrance_squar : Grid &
    Entrance_squar = 1 |-> 1 &

    /*
     * Exit_squar is an element of Grid & mapped domain 1 to range 5
    */
    Exit_squar : Grid &
    Exit_squar = 1 |-> 5

END

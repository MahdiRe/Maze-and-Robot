/* Robot
 * Author: Mahdi
 * Creation date: 12/15/2020
 */
MACHINE
    Robot

SEES
    Maze

SETS
    DIRECTION = { North, South, East, West };
    REPORT = { MovedNorth, MovedSouth, MovedEast, MovedWest, 
               MovedNorth_Failed_InternalWall, MovedSouth_Failed_InternalWall,
               MovedWest_Failed_InternalWall, MovedEast_Failed_InternalWall,
               MovedNorth_Failed_OutsideMaze, MovedSouth_Failed_OutsideMaze,
               MovedWest_Failed_OutsideMaze, MovedEast_Failed_OutsideMaze,
               Teleported, Teleport_Failed_InternalWall, Teleport_Failed_OutsideMaze,
               Teleport_Failed_SamePosition, Yes, No }

DEFINITIONS
    /* Is the position belongs to Internal_wall? */
    isInternalWall(position) == (position : Internal_wall);

    /* Is the position is outside the maze? */
    outsideMaze(position) == (position /: Grid);

    /* Is the position x & y is inside the maze? */
    insideMaze(xx, yy) == (xx <= 7 & yy <=5)

VARIABLES
    xx, yy, route 

INVARIANT
    xx : NATURAL1 & xx <= 7 &
    yy : NATURAL1 & yy <= 5 &
    route : seq(Grid)

INITIALISATION
    xx, yy, route := prj1(NATURAL1, NATURAL1)(Entrance_squar), prj2(NATURAL1, NATURAL1)(Entrance_squar), []

OPERATIONS

    /*
     1) move - gets the direction and moves the robot after validation.
     2) teleport - teleports the robot to a given position after validation.
     3) getPosition - shows the robot's current position.
     4) foundExit - reports whether the robot has reached the Exit_squar.
     5) hasVisitedSquar - reports whether the robot has visited the current squar already.
     6) robotsRoute - shows the routing of the robot.
    */

    report <-- move(direction) = 
        PRE
            direction: DIRECTION & report: REPORT
        THEN
            CASE direction OF EITHER
                North THEN
                    IF (isInternalWall(xx |-> succ(yy)))
                    THEN
                        report := MovedNorth_Failed_InternalWall
                    ELSIF(outsideMaze(xx |-> succ(yy)))
                    THEN
                        report := MovedNorth_Failed_OutsideMaze
                    ELSE
                        route := route <- (xx |-> yy) ||
                        yy, report := succ(yy), MovedNorth
                    END
            OR
                South THEN
                    IF (isInternalWall(xx |-> pred(yy)))
                    THEN
                        report := MovedSouth_Failed_InternalWall
                    ELSIF(outsideMaze(xx |-> pred(yy)))
                    THEN
                        report := MovedSouth_Failed_OutsideMaze
                    ELSE
                        route := route <- (xx |-> yy) ||
                        yy, report := pred(yy), MovedSouth
                    END
            OR
                East THEN
                    IF (isInternalWall(succ(xx) |-> yy))
                    THEN
                        report := MovedEast_Failed_InternalWall
                    ELSIF(outsideMaze(succ(xx) |-> yy))
                    THEN
                        report := MovedEast_Failed_OutsideMaze
                    ELSE
                        route := route <- (xx |-> yy) ||
                        xx, report := succ(xx), MovedEast
                    END
            OR
                West THEN
                    IF (isInternalWall(pred(xx) |-> yy))
                    THEN
                        report := MovedWest_Failed_InternalWall
                    ELSIF(outsideMaze(pred(xx) |-> yy))
                    THEN
                        report := MovedWest_Failed_OutsideMaze
                    ELSE
                        route := route <- (xx |-> yy) ||
                        xx, report := pred(xx), MovedWest
                    END
                END
            END
        END;


    report <-- teleport(x_teleport, y_teleport) = 
        PRE
            x_teleport: NATURAL1 & x_teleport <= 7 &
            y_teleport: NATURAL1 & y_teleport <= 5
    
        THEN
            IF (isInternalWall(x_teleport |-> y_teleport))
            THEN
                report := Teleport_Failed_InternalWall
            ELSIF(outsideMaze(x_teleport |-> y_teleport))
            THEN
                report := Teleport_Failed_OutsideMaze 
            ELSIF(x_teleport = xx & y_teleport = yy)
            THEN
                report := Teleport_Failed_SamePosition
            ELSE
                route := route <- (xx |-> yy) ||
                xx, yy, report := x_teleport, y_teleport, Teleported
            END
        END;
            
    position <-- getPosition =
        BEGIN
            position := (xx |-> yy)
        END;

    report <-- foundExit =
        PRE
            report : REPORT
        THEN
            IF((xx |-> yy) = Exit_squar)
            THEN
                report := Yes
            ELSE
                report := No
            END
        END;

    report <-- hasVisitedSquar(x_position, y_position) =
        PRE
            x_position: NATURAL1 & y_position: NATURAL1 &
            insideMaze(x_position, y_position)
        THEN
            IF((x_position |-> y_position) : ran(route))
            THEN
                report := Yes
            ELSE
                report := No
            END
        END;

    robots_route <-- robotsRoute =
        BEGIN
            robots_route := route
        END
END

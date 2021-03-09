classdef moveSimple < movement.move
    %MOVESIMPLE Concrete instance of a move class to represent NetLogo move
    %   This moveSimple class is a concrete instance of a move abstract
    %   class that represents an implementation of the NetLogo style
    %   movement.  That is the object moves in a certain direction but at
    %   each step rolls a dice to see how far it turns left, and then again
    %   for a right turn.
    %
    %   Dr Peter Brady <pbrady@mathworks.com>
    %   2021-03-08
    %   © 2021 The MathWorks, Inc.
    
    properties
        maxTurnAngle double;
    end
    
    methods
        function obj = moveSimple(options)
            %MOVESIMPLE Constructor for this object
            arguments
                options.maxTurnAngle double = 50
            end
            
            obj.maxTurnAngle = options.maxTurnAngle;
        end
        
        function obj = nextStep(obj, animal, world)
            % NEXTSTEP Concrete instance of the abstract movement operation

            currCoord = animal.Coordinate;
            
            
            baseVector = animal.directionUnitVector;
            myAngle = atan2(baseVector(2), ...
                baseVector(1));
            myTurn = (randi([0 obj.maxTurnAngle]) ...
                + randi([-obj.maxTurnAngle 0])) / 180 * pi;
            myAngle = myAngle + myTurn;
            animal.directionUnitVector(1) = cos(myAngle);
            animal.directionUnitVector(2) = sin(myAngle);
            nextStep = animal.directionUnitVector' ...
                * animal.movePerStep;
            
            % Step:
            nextCoord = currCoord + nextStep;
            
            % Unwrap in case we go out of bounds:
            nextCoord = obj.unwrapCoord(nextCoord, world.edgeLength);
            
            animal.Coordinate = nextCoord;
        end
    end
end


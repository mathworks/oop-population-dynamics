classdef moveSimple < move
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = moveSimple()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function obj = nextStep(obj, animal, world)
            % Base movement method
            currCoord = animal.Coordinate;
            
            % Random walk:
            % nextStep = randi(3, 2, 1, 'int16') - int16(2);
            
            % NetLogo style:
            baseVector = animal.directionUnitVector;
            myAngle = atan2(baseVector(2), ...
                baseVector(1));
            myTurn = (randi([0 50]) + randi([-50 0])) / 180 * pi;
            myAngle = myAngle + myTurn;
            animal.directionUnitVector(1) = cos(myAngle);
            animal.directionUnitVector(2) = sin(myAngle);
            nextStep = animal.directionUnitVector';
            
            % Step:
            nextCoord = currCoord + nextStep;
            
            % Unwrap in case we go out of bounds:
            nextCoord = obj.unwrapCoord(nextCoord, world.edgeLength);
            
            animal.Coordinate = nextCoord;
        end
    end
end


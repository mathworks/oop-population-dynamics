classdef animal < organism
    %ANIMAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Marker string % Marker for this species
    end
    
    properties (Access = private)
        directionUnitVector double = [1, 1]
        movePerStep double = 1
    end
    
    methods
        function obj = animal(options)
            %ANIMAL Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                options.Name string = ""
                options.FeedsOn string = ""
                options.Colour = [0, 0, 0] / 255;
                options.ProbReproduce = 0;
                options.GainFromFood = 1;
                options.Energy = 1;
                options.Marker = 'o';
                options.Coordinate = [1, 1];
            end
            
            obj.Species = options.Name;
            obj.FeedsOn = options.FeedsOn;
            obj.Colour = options.Colour;
            obj.GainFromFood = options.GainFromFood;
            obj.Energy = options.Energy;
            obj.Marker = options.Marker;
            obj.Coordinate = options.Coordinate;
            obj.ProbReproduce = options.ProbReproduce;
            obj.directionUnitVector = randi([0 100], [1 2]) / 100;
        end
        
        function obj = move(obj, edgeLength)
            % Base movement method
            currCoord = obj.Coordinate;
            
            % Random walk:
            % nextStep = randi(3, 2, 1, 'int16') - int16(2);
            
            % NetLogo style:
            baseVector = obj.directionUnitVector;
            myAngle = atan2(baseVector(2), ...
                baseVector(1));
            myTurn = (randi([0 50]) + randi([-50 0])) / 180 * pi;
            myAngle = myAngle + myTurn;
            obj.directionUnitVector(1) = cos(myAngle);
            obj.directionUnitVector(2) = sin(myAngle);
            nextStep = obj.directionUnitVector';
            
            % Step:
            nextCoord = currCoord + nextStep;
            
            % Unwrap in case we go out of bounds:
            for kk = 1:2
                if nextCoord(kk) > (edgeLength + 0.5)
                    nextCoord(kk) = nextCoord(kk) - edgeLength;
                end
                if nextCoord(kk) < 0.5
                    nextCoord(kk) = nextCoord(kk) + edgeLength;
                end
            end
            
            obj.Coordinate = nextCoord;
        end
        
        function obj = increaseEnergy(obj)
            obj.Energy = obj.Energy + obj.GainFromFood;
        end
    end
end


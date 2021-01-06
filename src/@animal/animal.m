classdef animal < organism
    %ANIMAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Marker string % Marker for this species
    end
    
    methods
        function obj = animal(Name, FeedsOn, options)
            %ANIMAL Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                Name string
                FeedsOn string
                options.Colour = [0, 0, 0] / 255;
                options.ProbReproduce = 0;
                options.GainFromFood = 1;
                options.Energy = 1;
                options.Marker = 'o';
                options.Coordinate = [2, 2];
            end
            
            obj.Species = Name;
            obj.FeedsOn = FeedsOn;
            obj.Colour = options.Colour;
            obj.GainFromFood = options.GainFromFood;
            obj.Energy = options.Energy;
            obj.Marker = options.Marker;
            obj.Coordinate = options.Coordinate;
            obj.ProbReproduce = options.ProbReproduce;
        end
        
        function obj = move(obj, edgeLength)
            % Base movement of an animal based on a random walk
            currCoord = obj.Coordinate;
            nextStep = randi(3, 2, 1, 'int16') - int16(2);
            nextCoord = currCoord + nextStep;
            
            for kk = 1:2
                if nextCoord(kk) > edgeLength
                    nextCoord(kk) = nextCoord(kk) - int16(edgeLength);
                end
                if nextCoord(kk) < 1
                    nextCoord(kk) = nextCoord(kk) + int16(edgeLength);
                end
            end
            
            obj.Coordinate = nextCoord;
        end
    end
end


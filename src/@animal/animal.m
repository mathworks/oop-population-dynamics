classdef animal < organism
    %ANIMAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Marker string % Marker for this species
    end
    
    properties (Access = public)
        directionUnitVector double = [1, 1]
        movePerStep double = 1
        
        move
    end
    
    methods
        function obj = animal(options)
            %ANIMAL Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                options.Name string = ""
                options.FeedsOn string = ""
                options.Colour = [0, 0, 0] / 255;
                options.LineColour;
                options.ProbReproduce = 0;
                options.GainFromFood = 1;
                options.Energy = 1;
                options.Marker = 'o';
                options.Coordinate = [1, 1];
                
                options.move = movement.moveSimple();
            end
            
            obj.Species = options.Name;
            obj.FeedsOn = options.FeedsOn;
            obj.Colour = options.Colour;
            if isfield(options, 'LineColour')
                obj.LineColour = options.LineColour;
            else
                obj.LineColour = obj.Colour;
            end
            obj.GainFromFood = options.GainFromFood;
            obj.Energy = options.Energy;
            obj.Marker = options.Marker;
            obj.Coordinate = options.Coordinate;
            obj.ProbReproduce = options.ProbReproduce;
            obj.directionUnitVector = randi([0 100], [1 2]) / 100;
            
            obj.move = options.move;
        end
        
        function newAnimal = breed(obj)
            newAnimal = animal.empty;
            breedDiceRoll = randi([0, 100], 1) / 100;
            if breedDiceRoll < obj.ProbReproduce
                obj.Energy = obj.Energy / 2;
                newAnimal = copy(obj);
            end
        end
        
        function nextStep(obj, world)
            obj.move.nextStep(obj, world);
        end
    end
end


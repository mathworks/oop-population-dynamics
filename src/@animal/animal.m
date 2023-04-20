classdef animal < organism
    %ANIMAL Concrete instance of an organism to represent a generic animal
    %   This class inherits all properties of the organism class and then
    %   implements some additional layers, as well as providing concrete
    %   instances of the abstract methods of organism, specific for animals
    %   to be modelled.
    %
    %   Dr Peter Brady <pbrady@mathworks.com>
    %   2021-03-08
    %   Copyright © 2021-2023 The MathWorks, Inc.
    
    properties
        Marker string % Marker for this species on the graph when plotting
    end
    
    properties (Access = public)
        directionUnitVector double = [1, 1]
        movePerStep double = 1
        
        move
    end
    
    methods
        function obj = animal(options)
            %ANIMAL Constructor for this object.
            arguments
                % Define arguments and defaults for all properties, for
                % ordering list the organism first, then animals, etc.
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
            
            obj.Name = options.Name;
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
            % NEWANIMAL Method to simulate this animal breeding.  It does
            % two things: (1) halves the energy that this animal has with
            % half staying here and the second going to the child. (2)
            % clones the animal to create a new animal.
            newAnimal = animal.empty;
            breedDiceRoll = randi([0, 100], 1) / 100;
            if breedDiceRoll < obj.ProbReproduce
                obj.Energy = obj.Energy / 2;
                newAnimal = copy(obj);
            end
        end
        
        function nextStep(obj, world)
            % NEXTSTEP Method to cause this animal to take the next step.
            % Generally this would be a method that is implemented in a
            % move class and this is a conveniance method to minimise
            % nesting levels when called at a world level.
            obj.move.nextStep(obj, world);
        end
    end
end


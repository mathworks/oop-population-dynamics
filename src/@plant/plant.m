classdef plant < organism
    %PLANT Concrete instance of an organism to represent a generic plant
    %   This class inherits all properties of the organism class and then
    %   implements some additional layers, as well as providing concrete
    %   instances of the abstract methods of organism, specific for plants
    %   to be modelled.
    %
    %   Dr Peter Brady <pbrady@mathworks.com>
    %   2021-03-08
    %   Copyright © 2021-2023 The MathWorks, Inc.
    
    properties (Access = public)
        StepDied (1,1) double % To track how long to regrow
        ColourDead (3,1) double % To track the alive colour
        ColourAlive (3,1) double % To track the dead colour
        TimeToRegrow (1,1) double % how long to stay dead
    end
    
    methods
        function obj = plant(options)
            %PLANT Constructor for this object.
            arguments
                % Define arguments and defaults for all properties, for
                % ordering list the organism first, then plants, etc.
                options.Name string = ""
                options.FeedsOn string = ""
                options.Colour = [70, 242, 128] / 255;
                options.LineColour = [70, 242, 128] / 255;
                options.Coordinate = [1, 1];
                options.ProbReproduce = 1;
                options.Energy = Inf;
                options.GainFromFood = 1;
                options.IsAlive = true;
                
                options.ColourAlive = [70, 242, 128] / 255;
                options.ColourDead = [240, 197, 149] / 255;
                options.TimeToRegrow = 30;
            end
            % Properties from organism:
            obj.Name = options.Name;
            obj.FeedsOn = options.FeedsOn;
            obj.Colour = options.Colour;
            obj.LineColour = options.LineColour;
            obj.Coordinate = options.Coordinate;
            obj.ProbReproduce = options.ProbReproduce;
            obj.Energy = options.Energy;
            obj.GainFromFood = options.GainFromFood;
            obj.IsAlive = options.IsAlive;
            
            % Properties from plant:
            obj.StepDied = -1;
            obj.ColourAlive = options.ColourAlive;
            obj.ColourDead = options.ColourDead;
            obj.TimeToRegrow = options.TimeToRegrow;
        end
        
        function isEaten(obj, currTimeStep)
            % ISEATEN method to change the plant's internal representation
            % if it is eaten by a harbivore.
            obj.Energy = obj.Energy - 1;
            if obj.Energy <= 0
                obj.IsAlive = false;
                obj.StepDied = currTimeStep;
                obj.Colour = obj.ColourDead;
            end
        end
        
        function grow(obj, currTimeStep)
            % GROW method to grow the plant, may optionally bring the plant
            % back to life it it is "dead" say if grass is eaten to the
            % ground it may take 20 periods to regrow sufficiently to be
            % considered alive and suitable to be eaten again.
            if ~obj.IsAlive
                if currTimeStep >= obj.StepDied + obj.TimeToRegrow
                    obj.IsAlive = true;
                    obj.Colour = obj.ColourAlive;
                    obj.Energy = 1;
                end
            end
        end
    end
end


classdef plant < organism
    %PLANT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        StepDied double % To track how long to regrow
        ColourDead (3,1) double % To track the alive colour
        ColourAlive (3,1) double % To track the dead colour
    end
    
    methods
        function obj = plant(options)
            %PLANT Construct an instance of this class
            %   Detailed explanation goes here
            arguments
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
                options.ColourDead = [63, 93, 35] / 255;
            end
            % Properties from organism:
            obj.Species = options.Name;
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
        end
        
        function isEaten(obj, currTimeStep)
            obj.Energy = obj.Energy - 1;
            if obj.Energy <= 0
                obj.IsAlive = false;
                obj.StepDied = currTimeStep;
            end
        end
    end
end


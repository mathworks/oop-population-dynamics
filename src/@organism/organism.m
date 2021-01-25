classdef (Abstract) organism < handle
    %ORGANISM Base abstract class for plants and animals
    %   Detailed explanation goes here
    
    properties (Access = public)
        Species string % Name of the species, e.g. sheep, kangaroo, dingo
        FeedsOn string % Name of the species that we feed on
        Colour (3, 1) double % Default colour to plot this cell as
        LineColour (3, 1) double % Line colour can be different to world colour
        Coordinate (2, 1) double % Coordinate that this organism is at
        ProbReproduce (1,1) double % Probability of breeding this turn
        Energy (1,1) double % Energy when zero organism dies
        GainFromFood (1,1) double % How much energy gain from one food
        IsAlive (1,1) logical = true % Logical to test if alive
    end
    
    methods
        % Method signatures
        eats(obj, world)
        
        function obj = organism
            % Abstract constructor of this class.  Must have a concrete
            % method in the final subclass.
        end
        
        function increaseEnergy(obj)
            obj.Energy = obj.Energy + obj.GainFromFood;
        end
        function expendEnergy(obj)
            obj.Energy = obj.Energy - 1;
            if obj.Energy <= 0
                obj.IsAlive = false;
            end
        end
    end
end


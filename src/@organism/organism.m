classdef (Abstract) organism
    %ORGANISM Base abstract class for plants and animals
    %   Detailed explanation goes here
    
    properties (Access = public)
        Species string % Name of the species, e.g. sheep, kangaroo, dingo
        FeedsOn string % Name of the species that we feed on
        Colour (3, 1) double % Default colour to plot this cell as
        Coordinate (2, 1) int16 % Coordinate that this organism is at
        ProbReproduce (1,1) double % Probability of breeding this turn
        FigObj (1,1) % Line or patch object to draw the organism
    end
    
    methods
        function obj = organism
            % Abstract constructor of this class.  Must have a concrete
            % method in the final subclass.
        end
    end
end


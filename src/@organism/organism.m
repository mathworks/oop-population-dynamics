classdef (Abstract) organism < handle & ...
        matlab.mixin.Copyable
    %ORGANISM Base abstract class for plants and animals
    %   This class forms the basis for all organisms that we will be
    %   simulating within the world.  It is an abstract class in that we
    %   can not directly create an instance of this class but we do define
    %   common properties and methods that, if not defined here, must be
    %   defined in the subclasses - a concrete method.  For methods that
    %   are defined here we may, but do not have to, override them in our
    %   subclasses.
    %
    %   Dr Peter Brady <pbrady@mathworks.com>
    %   2021-03-08
    %   © 2021 The MathWorks, Inc.
    
    properties (Access = public)
        Name string % Name of the species, e.g. sheep, kangaroo, dingo
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
        % Method signatures contained in external files
        eats(obj, world)
        
        function obj = organism
            % Abstract constructor of this class.  Must have a concrete
            % method in the final subclass.
        end
        
        % Concrete methods that may be overriden in subclasses but in most
        % cases should be good enough.
        function increaseEnergy(obj)
            % increaseEnergy
            %   Method that represents an organism eating its food and the
            %   resultant energy gain
            %
            %   Input/s:
            %       -) the object itself
            %
            %   Output/s:
            %       -) none
            obj.Energy = obj.Energy + obj.GainFromFood;
        end
        function expendEnergy(obj)
            % expendEnergy
            %   Method that represents the organism expending energy during
            %   a timestep, where if the energy becomes too low, dies.
            %
            %   Input/s:
            %       -) the object itself
            %
            %   Output/s:
            %       -) none
            obj.Energy = obj.Energy - 1;
            if obj.Energy <= 0
                obj.IsAlive = false;
            end
        end
    end
end


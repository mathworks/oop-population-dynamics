classdef (Abstract) move
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % Method signatures that must be instantiated in a concrete class
        obj = nextStep(obj, animal, world)
        
        % Default constructor
        function obj = move()
        end
    end
    
    methods (Static)
        function nextCoord = unwrapCoord(nextCoord, edgeLength)
            for ii = 1:2
                if nextCoord(ii) > (edgeLength + 0.5)
                    nextCoord(ii) = nextCoord(ii) - edgeLength;
                end
                if nextCoord(ii) < 0.5
                    nextCoord(ii) = nextCoord(ii) + edgeLength;
                end
            end
        end
    end
end


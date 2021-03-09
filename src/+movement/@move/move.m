classdef (Abstract) move
    %MOVE Base abstract class for movements that animals can use.
    %   This class forms the basis for all movement types that animals can
    %   use within their own objects.  As such it is abstract and will
    %   never be instantiated itself.
    %
    %   Dr Peter Brady <pbrady@mathworks.com>
    %   2021-03-08
    %   © 2021 The MathWorks, Inc.
    
    methods
        % Method signatures that must be instantiated in a concrete class
        obj = nextStep(obj, animal, world)
        
        function obj = move()
            % Abstract constructor of this class.  Must have a concrete
            % method in the final subclass.
        end
    end
    
    % We use a static method block to include some common functions that
    % are strictly independent of an object block.
    methods (Static)
        function nextCoord = unwrapCoord(nextCoord, edgeLength)
            % UNWRAPCOORD Method to wrap animal if it moves off the grid
            %   This static method "unwraps" the coordinates of the animal
            %   in case it moves off the grid.  The animal is wrapped to
            %   the other side of the grid so is not lost.
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


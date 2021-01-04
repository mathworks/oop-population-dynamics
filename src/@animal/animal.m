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
            end
            
            obj.Species = Name;
            obj.FeedsOn = FeedsOn;
            obj.Colour = options.Colour;
        end
    end
end


classdef plant < organism
    %PLANT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
    end
    
    methods
        function obj = plant(Name, FeedsOn, options)
            %PLANT Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                Name string
                FeedsOn string
                options.Colour = [70, 242, 128] / 255;
            end
           
            obj.Species = Name;
            obj.FeedsOn = FeedsOn;
            obj.Colour = options.Colour;
        end
    end
end


classdef plant < organism
    %PLANT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
    end
    
    methods
        function obj = plant(options)
            %PLANT Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                options.Name string = ""
                options.FeedsOn string = ""
                options.Colour = [70, 242, 128] / 255;
                options.Energy = Inf;
                options.Coordinate = [1, 1];
            end
           
            obj.Species = options.Name;
            obj.FeedsOn = options.FeedsOn;
            obj.Colour = options.Colour;
            obj.Energy = options.Energy;
            obj.Coordinate = options.Coordinate;
        end
    end
end


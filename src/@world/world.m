classdef world
    %WORLD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        % Size of one edge of the world:
        edgeLength int16 = 100
        populationCounts double
    end
    
    %TODO: make these private when finished:
    properties (Access = public)
        worldGrid
        myAnimals
        figWorld
        figPops
        myAxes
        plantRGBMatrix
        nSteps
        
    end
    
    methods
        % Method signatures
        obj = plotWorld(obj)
        
        % Full methods    
        function obj = world(organisms, options)
            %WORLD Construct an instance of this class
            %   This constructor builds the initial arrays and sets up the
            %   simulation ready to run.
            
            arguments
                organisms
                options.nSteps = 1000
            end
            
            % Base properties.
            obj.nSteps = options.nSteps;
            
            % Create the base world grid
            aCell = plant('Grass', 'Earth', ...
                'LivesForEver', true);
            obj.worldGrid = repmat(aCell, 100, 100);
            
            obj.myAnimals = {};
            
            % Unpack the organisms
            for ii = 1:numel(organisms)
                switch organisms{ii}.Class
                    case 'animal'
                        myAnimal = animal(organisms{ii}.Name, ...
                            organisms{ii}.FeedsOn, ...
                            'Colour', organisms{ii}.Colour);
                        myAnimal.ProbReproduce = organisms{ii}.Reproduce;
                        obj.myAnimals{end+1} = repmat(myAnimal, ...
                            organisms{ii}.InitialCount, 1);
                        for jj = 1:organisms{ii}.InitialCount
                            obj.myAnimals{end}(jj).Coordinate = ...
                                randi(obj.edgeLength, 2, 1);
                        end
                        
                    otherwise
                        error('WORLD:Construct:UnknownClass', ...
                            'Unknown class: %s', ...
                            thisOrganism.Class)
                end
            end
            
            % Build the first plant grid, then update as needed
            % Build the grass grid:
            obj.plantRGBMatrix = zeros(obj.edgeLength, obj.edgeLength, 3);
            for ii = 1:obj.edgeLength
                for jj = 1:obj.edgeLength
                    obj.plantRGBMatrix(ii, jj, :) = obj.worldGrid(ii, jj).Colour;
                end
            end
        end
        
        function obj = run(obj)
            for ii = 1:obj.nSteps
                obj = plotWorld(obj);
                obj = plotPops(obj, ii);
%                 obj = stepPlants(obj);
                obj = stepAnimals(obj);
            end
        end
        
        function obj = plotPops(obj, currStep)
            nOrganisms = numel(obj.myAnimals);
            if isempty(obj.figPops)
                obj.figPops = figure;
                obj.populationCounts = NaN(obj.nSteps, nOrganisms);
            end
            
            clf(obj.figPops)
            popAxes = gca(obj.figPops);
            myLines = zeros(numel(obj.myAnimals), 1);
            myLegendItems = cell(numel(obj.myAnimals), 1);
            for ii = 1:numel(obj.myAnimals)
                obj.populationCounts(currStep, ii) = numel(obj.myAnimals{ii});
                myLines(ii) = line(popAxes, ...
                    1:currStep, ...
                    obj.populationCounts(1:currStep, ii), ...
                    'Color', obj.myAnimals{ii}(1).Colour, ...
                    'Linewidth', 1);
                myLegendItems{ii} = obj.myAnimals{ii}(1).Species;
            end
            legend(myLines, myLegendItems)
            popAxes.YLim(1) = 0;          
        end
        
%         function stepPlants(obj)
%             % Not needed for V1
%         end
        
        function obj = stepAnimals(obj)
            for ii = 1:numel(obj.myAnimals)
                for jj = 1:numel(obj.myAnimals{ii})
                    currCoord = obj.myAnimals{ii}(jj).Coordinate;
                    nextStep = randi(3, 2, 1, 'int16') - int16(2);
                    nextCoord = currCoord + nextStep;
                    
                    for kk = 1:2
                        if nextCoord(kk) > obj.edgeLength
                            nextCoord(kk) = nextCoord(kk) - int16(obj.edgeLength);
                        end
                        if nextCoord(kk) < 1
                            nextCoord(kk) = nextCoord(kk) + int16(obj.edgeLength);
                        end
                    end
                    
                    obj.myAnimals{ii}(jj).Coordinate = nextCoord;
                    
                    % Do we breed?
                    breedDiceRoll = randi([0, 100], 1) / 100;
                    if breedDiceRoll < obj.myAnimals{ii}(jj).ProbReproduce
                        
                    end
                end
            end
        end
    end
end


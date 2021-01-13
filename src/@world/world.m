classdef world < handle
    %WORLD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = public, Dependent = true)
        worldColour
        animalLocations
    end
    
    properties (Access = public)
        % Size of one edge of the world:
        edgeLength double = 100
        populationCounts double
    end
    
    %TODO: make these private when finished:
    properties (Access = public)
        worldGrid
        myAnimals
        figPops
        myAxes
        nSteps
        worldPatches
        axWorld
        foodWeb
        foodOrder
    end
    
    methods
        % Method signatures
        obj = plotWorld(obj)
        obj = eats(obj, idxSpecies, idxAnimal)
        obj = getFoodWeb(obj)
        obj = stepAnimals(obj)
        
        % Full methods    
        function obj = world(organisms, initialCounts, options)
            %WORLD Construct an instance of this class
            %   This constructor builds the initial arrays and sets up the
            %   simulation ready to run.
            
            arguments
                organisms
                initialCounts
                options.nSteps = 1000
                options.worldSideLen = 100;
            end
            
            % Base properties.
            obj.nSteps = options.nSteps;

            % Prepare to unpack
            obj.myAnimals = {};
            animalCounter = 1;
            
            % Unpack the organisms
            for ii = 1:numel(organisms)
                organism = organisms{ii};
                switch class(organism)
                    case 'plant'
                        % Build the world grid
                        obj.worldGrid = repmat(organism, ...
                            options.worldSideLen, ...
                            options.worldSideLen);
                        for jj = 1:obj.edgeLength
                            for kk = 1:obj.edgeLength
                                obj.worldGrid(jj, kk) = ...
                                    plant('Name', organism.Species, ...
                                    'FeedsOn', organism.FeedsOn, ...
                                    'Colour', organism.Colour, ...
                                    'Coordinate', [jj, kk]);
                            end
                        end
                    case 'animal'
                        % Build each animal individually directly on the
                        % world grid:
                        clear groupAnimals
                        groupAnimals(initialCounts(ii), 1) = ...
                            animal('Name', organism.Species, ...
                            'FeedsOn', organism.FeedsOn, ...
                            'ProbReproduce', organism.ProbReproduce, ...
                            'GainFromFood', organism.GainFromFood, ...
                            'Energy', 1, ...
                            'Colour', organism.Colour, ...
                            'Marker', organism.Marker, ...
                            'Coordinate', [0, 0]); %#ok<AGROW>
                        for jj = 1:initialCounts(ii)
                            % Build the basic properties for this animal
                            groupAnimals(jj) = animal('Name', organism.Species, ...
                                'FeedsOn', organism.FeedsOn, ...
                                'ProbReproduce', organism.ProbReproduce, ...
                                'GainFromFood', organism.GainFromFood, ...
                                'Energy', randi([1, organism.GainFromFood], 1), ...
                                'Colour', organism.Colour, ...
                                'Marker', organism.Marker, ...
                                'Coordinate', randi(obj.edgeLength, 2, 1));
                        end
                        obj.myAnimals{animalCounter} = groupAnimals;
                        animalCounter = animalCounter + 1;
                    otherwise
                        error('WORLD:Construct:UnknownClass', ...
                            'Unknown class: %s', ...
                            thisOrganism.Class)
                end
            end
           
            % Create the food web
            obj = getFoodWeb(obj);
            
            % initial set up so plot
            plotWorld(obj);
            obj = plotPops(obj, ii);
        end
        
        function obj = run(obj)
            for ii = 1:obj.nSteps
                obj = stepPlants(obj);
                obj = stepAnimals(obj);
                % End of timestep so:
                if endCheck(obj)
                    break
                end
                plotWorld(obj);
                obj = plotPops(obj, ii);
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
            legend(myLines, myLegendItems, ...
                'Location', 'NorthWest')
            popAxes.YLim(1) = 0;          
        end
        
%         function stepPlants(obj)
%             % Not needed for V1
%         end
        
        
        
        function myFigure = plotFoodWeb(obj)
            myFigure = figure();
            myAxes = axes(myFigure);
            plot(myAxes, obj.foodWeb)
        end
    end
    
    methods (Access = private)
        function atTheEnd = endCheck(obj)
            atTheEnd = false;
            
            for ii = 1:numel(obj.myAnimals)
                if numel(obj.myAnimals{ii}) == 0
                    atTheEnd = true;
                    break
                end
            end
        end
    end
    
    methods % get/set
        function colourGrid = get.worldColour(obj)
            colourGrid = zeros(obj.edgeLength, obj.edgeLength, 3);
            for ii = 1:obj.edgeLength
                for jj = 1:obj.edgeLength
                    colourGrid(ii, jj, :) = obj.worldGrid(ii, jj).Colour;
                end
            end
        end
        
        function animalLocs = get.animalLocations(obj)
            for ii = 1:numel(obj.myAnimals)
                myAnimal = obj.myAnimals{ii};
                animalLocs(ii).Colour = myAnimal(ii).Colour; %#ok<AGROW>
                animalLocs(ii).Marker = myAnimal(ii).Marker; %#ok<AGROW>
                animalLocs(ii).coord = [myAnimal.Coordinate]'; %#ok<AGROW>
            end
        end
    end
end


classdef world < handle
    %WORLD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = public, Dependent = true)
        worldColour
        animalLocations
        plantAliveCount
    end
    
    properties (Access = public)
        % Size of one edge of the world:
        edgeLength double = 100
        populationCounts double
    end
    
    %TODO: make these private when finished:
    properties (Access = public)
        worldGrid plant
        myAnimals
        handleSurface
        handleAnimals
        nSteps
        worldPatches
        figToPlot
        axWorld
        axPops
        printPlots = false
        showPlots = true
        foodWeb
        foodOrder
        currTimeStep double = 0
        debug = false
    end
    
    methods
        % Method signatures
        obj = plotWorld(obj)
        obj = getFoodWeb(obj)
        obj = stepAnimals(obj, currTimeStep)
        [myOrganism, idxAnimals] = isAnimalFromWeb(obj, idxSpecies)
        
        % Full methods    
        function obj = world(organisms, initialCounts, options)
            %WORLD Construct an instance of this class
            %   This constructor builds the initial arrays and sets up the
            %   simulation ready to run.
            
            arguments
                organisms
                initialCounts
                options.nSteps = 1000
                options.worldSideLen = 100
                options.debug = false
                options.printPlots = false
                options.showPlots = true
            end
            
            % Base properties.
            obj.nSteps = options.nSteps;
            obj.edgeLength = options.worldSideLen;
            obj.debug = options.debug;
            obj.printPlots = options.printPlots;
            obj.showPlots = options.showPlots;

            % Prepare to unpack
            obj.myAnimals = {};
            animalCounter = 1;
            
            % Unpack the organisms
            for ii = 1:numel(organisms)
                organism = organisms{ii};
                switch class(organism)
                    case 'plant'
                        % Build the world grid
                        obj.worldGrid(obj.edgeLength, obj.edgeLength) = organism;
                        for jj = 1:obj.edgeLength
                            for kk = 1:obj.edgeLength
                                obj.worldGrid(jj, kk) = copy(organism);
                                obj.worldGrid(jj, kk).Coordinate = [jj, kk];
                                if ~isinf(organism.Energy)
                                    probAlive = randi([0 1], 1);
                                    if ~probAlive
                                        obj.worldGrid(jj, kk).IsAlive = false;
                                        obj.worldGrid(jj, kk).Energy = 0;
                                        obj.worldGrid(jj, kk).Colour = organism.ColourDead;
                                        obj.worldGrid(jj, kk).StepDied = randi([1, organism.TimeToRegrow], 1) - 30 + 1;
                                    end
                                end
                            end
                        end
                    case 'animal'
                        % Build each animal individually directly on the
                        % world grid:
                        %TODO: this needs to be fixed to clone and organism
                        clear groupAnimals
                        groupAnimals(initialCounts(ii), 1) = ...
                            animal('Name', organism.Name, ...
                            'FeedsOn', organism.FeedsOn, ...
                            'ProbReproduce', organism.ProbReproduce, ...
                            'GainFromFood', organism.GainFromFood, ...
                            'Energy', 2 * randi([1, organism.GainFromFood], 1), ...
                            'Colour', organism.Colour, ...
                            'LineColour', organism.LineColour, ...
                            'Marker', organism.Marker, ...
                            'Coordinate', [0, 0]); %#ok<AGROW>
                        for jj = 1:initialCounts(ii)
                            % Build the basic properties for this animal
                            groupAnimals(jj) = animal('Name', organism.Name, ...
                                'FeedsOn', organism.FeedsOn, ...
                                'ProbReproduce', organism.ProbReproduce, ...
                                'GainFromFood', organism.GainFromFood, ...
                                'Energy', randi([1, organism.GainFromFood], 1), ...
                                'Colour', organism.Colour, ...
                                'LineColour', organism.LineColour, ...
                                'Marker', organism.Marker, ...
                                'Coordinate', randi(obj.edgeLength, 2, 1));
                        end
                        obj.myAnimals{animalCounter} = groupAnimals;
                        animalCounter = animalCounter + 1;
                    otherwise
                        error('WORLD:Construct:UnknownClass', ...
                            'Unknown class: %s', ...
                            class(organism))
                end
            end
           
            % Create the food web
            obj = getFoodWeb(obj);
            
            % initial set up so plot
            if obj.showPlots
                doPlots(obj)
            end
        end
        
        function obj = run(obj)
            for ii = 1:obj.nSteps
                obj.currTimeStep = ii;
                obj = stepPlants(obj);
                obj = stepAnimals(obj);
                % End of timestep so:
                if endCheck(obj)
                    break
                end
                if obj.showPlots
                    doPlots(obj)
                end
            end
        end
        
        function obj = plotPops(obj)
            % Must be run after plotWorld to create the figures
            plantDivider = 4;
            nOrganisms = numel(obj.myAnimals);
            if isempty(obj.populationCounts)
                obj.populationCounts = NaN(obj.nSteps + 1, nOrganisms + 1);
            end
            
            persistent myLineProps myLegendText
            if obj.currTimeStep == 0
                myLineProps = struct(...
                    'Color', [1,1,1], ...
                    'LineWidth', 1);
            end
            
            cla(obj.axPops)
            myLines = zeros(numel(obj.myAnimals) + 1, 1);
            for ii = 1:numel(obj.myAnimals)
                if obj.currTimeStep == 0
                    myLineProps(ii) = struct(...
                        'Color', obj.myAnimals{ii}(1).LineColour, ...
                        'LineWidth', 1);
                    myLegendText{ii} = obj.myAnimals{ii}(1).Name;
                end
                
                obj.populationCounts(obj.currTimeStep+1, ii) = numel(obj.myAnimals{ii});
                myLines(ii) = line(obj.axPops, ...
                    0:obj.currTimeStep, ...
                    obj.populationCounts(1:obj.currTimeStep+1, ii), ...
                    myLineProps(ii));
                
            end
            obj.populationCounts(obj.currTimeStep+1, end) = obj.plantAliveCount;
            if obj.currTimeStep == 0
                myLineProps(end+1) = struct(...
                    'Color', obj.worldGrid(1,1).ColourAlive, ...
                    'LineWidth', 1);
                myLegendText{end+1} = ['Plants (/', num2str(plantDivider), ')'];
            end
            myLines(end) = line(obj.axPops, ...
                0:obj.currTimeStep, ...
                obj.populationCounts(1:obj.currTimeStep+1, end) / plantDivider, ...
                myLineProps(end));
            legend(obj.axPops, myLines, myLegendText, ...
                'Location', 'NorthWest')
            obj.axPops.YLim = [0 Inf];
            
            
            xlabel('Simulation Step')
            ylabel('Population Sizes')
            persistent handleTitle
            titleText = ['Population Counts at Step: ', num2str(obj.currTimeStep)];
            if isempty(handleTitle)
                handleTitle = title(obj.axPops, titleText);
            else
                handleTitle.String = titleText;
            end
        end
        
%         function stepPlants(obj)
%             % Not needed for V1
%         end
        
        
        
        function varargout = plotFoodWeb(obj)
            myFigure = figure;
            myAxes = axes(myFigure);
            plot(myAxes, obj.foodWeb);
            
            if nargout == 1
                varargout{1} = myFigure;
            end
        end
        
        function idxOfPrey = getAnimalIdxByName(obj, speciesName)
            idxOfPrey = -1;
            for ii = 1:numel(obj.myAnimals)
                if ~isempty(obj.myAnimals{ii}) ...
                        && speciesName == obj.myAnimals{ii}(1).Name
                    idxOfPrey = ii;
                    break;
                end
            end
        end
        
        function doPlots(obj)
            plotWorld(obj);
            plotPops(obj);
            drawnow();
            if obj.printPlots
                fName = sprintf('simFigure_%04d.png', ...
                    obj.currTimeStep);
                exportgraphics(obj.figToPlot, ...
                    fName, ...
                    'Resolution', 300)
            end
        end
    end
    
    methods (Access = private)
        function atTheEnd = endCheck(obj)
%             atTheEnd = false;
            
            % if any animal is living continue
            atTheEnd = true;
            for ii = 1:numel(obj.myAnimals)
                if ~isempty(obj.myAnimals{ii})
                    atTheEnd = false;
                    break
                end
            end
        end
    end
    
    methods % get/set
        function colourGrid = get.worldColour(obj)
            % NB: ii and jj are transposed to match the CDATA array we are
            % using later in the code to only update rather than full
            % redraw
            colourGrid = zeros(obj.edgeLength, obj.edgeLength, 3);
            for ii = 1:obj.edgeLength
                for jj = 1:obj.edgeLength
                    colourGrid(jj, ii, :) = obj.worldGrid(ii, jj).Colour;
                end
            end
        end
        
        function animalLocs = get.animalLocations(obj)
            for ii = 1:numel(obj.myAnimals)
                myAnimal = obj.myAnimals{ii};
                animalLocs(ii).coord = [myAnimal.Coordinate]'; %#ok<AGROW>
            end
        end
        
        function plantSum = get.plantAliveCount(obj)
            plantSum = sum([obj.worldGrid(:).IsAlive]);
        end
    end
end


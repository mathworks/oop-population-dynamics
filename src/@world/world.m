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
        figPops
        handleSurface
        handleAnimals
        nSteps
        worldPatches
        axWorld
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
                options.worldSideLen = 100;
                options.debug = false;
            end
            
            % Base properties.
            obj.nSteps = options.nSteps;
            obj.edgeLength = options.worldSideLen;
            obj.debug = options.debug;

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
                            animal('Name', organism.Species, ...
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
                            groupAnimals(jj) = animal('Name', organism.Species, ...
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
                            thisOrganism.Class)
                end
            end
           
            % Create the food web
            obj = getFoodWeb(obj);
            
            % initial set up so plot
            plotWorld(obj);
            obj = plotPops(obj);
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
                plotWorld(obj);
                obj = plotPops(obj);
            end
        end
        
        function obj = plotPops(obj)
            plantDivider = 4;
            nOrganisms = numel(obj.myAnimals);
            if isempty(obj.figPops)
                obj.figPops = figure;
                obj.populationCounts = NaN(obj.nSteps + 1, nOrganisms + 1);
            end
            
            clf(obj.figPops)
            popAxes = gca(obj.figPops);
            myLines = zeros(numel(obj.myAnimals) + 1, 1);
            myLegendItems = cell(numel(obj.myAnimals) + 1, 1);
            for ii = 1:numel(obj.myAnimals)
                obj.populationCounts(obj.currTimeStep+1, ii) = numel(obj.myAnimals{ii});
                myLines(ii) = line(popAxes, ...
                    0:obj.currTimeStep, ...
                    obj.populationCounts(1:obj.currTimeStep+1, ii), ...
                    'Color', obj.myAnimals{ii}(1).LineColour, ...
                    'Linewidth', 1);
                myLegendItems{ii} = obj.myAnimals{ii}(1).Species;
            end
            obj.populationCounts(obj.currTimeStep+1, end) = obj.plantAliveCount;
            myLines(end) = line(popAxes, ...
                1:obj.currTimeStep+1, ...
                obj.populationCounts(1:obj.currTimeStep+1, end) / plantDivider, ...
                'Color', obj.worldGrid(1,1).ColourAlive, ...
                'LineWidth' , 1);
            myLegendItems{end} = ['Plants (/', num2str(plantDivider), ')'];
            legend(myLines, myLegendItems, ...
                'Location', 'NorthWest')
            popAxes.YLim(1) = 0;          
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
                if speciesName == obj.myAnimals{ii}(1).Species
                    idxOfPrey = ii;
                    break;
                end
            end
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
                animalLocs(ii).Colour = myAnimal(1).Colour; %#ok<AGROW>
                animalLocs(ii).Marker = myAnimal(1).Marker; %#ok<AGROW>
                animalLocs(ii).coord = [myAnimal.Coordinate]'; %#ok<AGROW>
            end
        end
        
        function plantSum = get.plantAliveCount(obj)
            plantSum = sum([obj.worldGrid(:).IsAlive]);
        end
    end
end


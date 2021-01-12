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
    end
    
    methods
        % Method signatures
        obj = plotWorld(obj)
        obj = eats(obj, idxSpecies, idxAnimal)
        
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
            
            % Create the base world grid with plants:
            aCell = plant('Grass', 'Earth');
            aCell.Energy = Inf; % So lives forever.
            obj.worldGrid = repmat(aCell, ...
                options.worldSideLen, ...
                options.worldSideLen);

            obj.myAnimals = {};
            
            % Unpack the organisms
            for ii = 1:numel(organisms)
                organism = organisms{ii};
                switch class(organism)
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
                        obj.myAnimals{ii} = groupAnimals;
                    otherwise
                        error('WORLD:Construct:UnknownClass', ...
                            'Unknown class: %s', ...
                            thisOrganism.Class)
                end
            end
            
            % initial set up so plot
            plotWorld(obj);
        end
        
        function obj = run(obj)
            for ii = 1:obj.nSteps
                obj = plotPops(obj, ii);
%                 obj = stepPlants(obj);
                obj = stepAnimals(obj);
                % End of timestep so:
                plotWorld(obj);
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
                myCurrAnimals = obj.myAnimals{ii};
                idxDeaths = [];
                bornAnimals = {};
                
                for jj = 1:numel(myCurrAnimals)
                    % Move
                    myCurrAnimals(jj) = ...
                        myCurrAnimals(jj).move(obj.edgeLength);

                    % Eat
                    obj = eats(obj, ii, jj);
                    
                    % Expend energy
                    myCurrAnimals(jj).Energy = myCurrAnimals(jj).Energy - 1;
                    if myCurrAnimals(jj).Energy <= 0
                        % We die
                        idxDeaths(end+1) = jj; %#ok<AGROW>
                        continue
                    end
                    
                    % Do we breed?
                    breedDiceRoll = randi([0, 100], 1) / 100;
                    if breedDiceRoll < myCurrAnimals(jj).ProbReproduce
                        myCurrAnimals(jj).Energy = myCurrAnimals(jj).Energy / 2;
                        newAnimal = animal(...
                                'Name', myCurrAnimals(jj).Species, ...
                                'FeedsOn', myCurrAnimals(jj).FeedsOn, ...
                                'Colour', myCurrAnimals(jj).Colour, ...
                                'ProbReproduce', myCurrAnimals(jj).ProbReproduce, ...
                                'GainFromFood', myCurrAnimals(jj).GainFromFood, ...
                                'Energy', myCurrAnimals(jj).Energy, ...
                                'Marker', myCurrAnimals(jj).Marker, ...
                                'Coordinate', myCurrAnimals(jj).Coordinate);
                        if isempty(bornAnimals)
                            bornAnimals = newAnimal;
                        else
                            bornAnimals(end+1, 1) = newAnimal; %#ok<AGROW>
                        end
%                         localX = bornAnimals(end, 1).Coordinate(1);
%                         localY = bornAnimals(end, 1).Coordinate(2);
                    end
                end
                
                % Kill hungry animals and birth new ones
                %TODO: this is hack, probably should be a handle class
                if ~isempty(idxDeaths)
                    for kk = 1:numel(idxDeaths)
                        idxToDelete = idxDeaths(kk);
                    end
                    myCurrAnimals(idxDeaths) = [];
                end
                
                if ~isempty(bornAnimals)
                    myCurrAnimals = vertcat(myCurrAnimals, bornAnimals);
                end
                
                obj.myAnimals{ii} = myCurrAnimals;
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


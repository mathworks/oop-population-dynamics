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
        figPops
        myAxes
        nSteps
        worldPatches
    end
    
    methods
        % Method signatures
        obj = plotWorld(obj)
        obj = eats(obj, idxSpecies, idxAnimal)
        
        % Full methods    
        function obj = world(organisms, options)
            %WORLD Construct an instance of this class
            %   This constructor builds the initial arrays and sets up the
            %   simulation ready to run.
            
            arguments
                organisms
                options.nSteps = 1000
                options.worldSideLen = 100;
            end
            
            % Base properties.
            obj.nSteps = options.nSteps;
            
            % Create the base world grid
            aCell = plant('Grass', 'Earth');
            aCell.Energy = Inf; % So lives forever.
            obj.worldGrid = repmat(aCell, ...
                options.worldSideLen, ...
                options.worldSideLen);
            
            obj.myAnimals = {};
            
            % Unpack the organisms
            for ii = 1:numel(organisms)
                switch organisms{ii}.Class
                    case 'animal'
                        % Build the basic properties for this species
                        myAnimal = animal(organisms{ii}.Name, ...
                            organisms{ii}.FeedsOn, ...
                            'Colour', organisms{ii}.Colour);
                        myAnimal.ProbReproduce = organisms{ii}.Reproduce;
                        myAnimal.Marker = organisms{ii}.Marker;
                        myAnimal.GainFromFood = organisms{ii}.GainFromFood;
                        
                        % Breed across the board
                        obj.myAnimals{end+1} = repmat(myAnimal, ...
                            organisms{ii}.InitialCount, 1);
                        
                        % Randomly distribute across the grid and set
                        % properties per animal
                        for jj = 1:organisms{ii}.InitialCount
                            obj.myAnimals{end}(jj).Coordinate = ...
                                randi(obj.edgeLength, 2, 1);
                            obj.myAnimals{end}(jj).Energy = ...
                                randi([1, organisms{ii}.GainFromFood], 1);
                        end
                        
                    otherwise
                        error('WORLD:Construct:UnknownClass', ...
                            'Unknown class: %s', ...
                            thisOrganism.Class)
                end
            end
            
            % Set up the world figure
            obj = plotWorld(obj);
        end
        
        function obj = run(obj)
            for ii = 1:obj.nSteps
                obj = plotPops(obj, ii);
%                 obj = stepPlants(obj);
                obj = stepAnimals(obj);
                % End of timestep so:
                drawnow
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
                idxDeaths = [];
                bornAnimals = {};
                
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
                    obj.myAnimals{ii}(jj).FigObj.XData = obj.myAnimals{ii}(jj).Coordinate(1);
                    obj.myAnimals{ii}(jj).FigObj.YData = obj.myAnimals{ii}(jj).Coordinate(2);
                    
                    % Eat
                    obj = eats(obj, ii, jj);
                    
                    % Expend energy
                    obj.myAnimals{ii}(jj).Energy = obj.myAnimals{ii}(jj).Energy - 1;
                    if obj.myAnimals{ii}(jj).Energy <= 0
                        % We die
                        idxDeaths(end+1) = jj; %#ok<AGROW>
                        continue
                    end
                    
                    % Do we breed?
                    breedDiceRoll = randi([0, 100], 1) / 100;
                    if breedDiceRoll < obj.myAnimals{ii}(jj).ProbReproduce
                        obj.myAnimals{ii}(jj).Energy = obj.myAnimals{ii}(jj).Energy / 2;
                        bornAnimals{end+1} = obj.myAnimals{ii}(jj); %#ok<AGROW>
                    end
                end
                
                % Kill hungry animals and birth new ones
                %TODO: this is hack, probably should be a handle class
                if ~isempty(idxDeaths)
                    for kk = 1:numel(idxDeaths)
                        idxToDelete = idxDeaths(kk);
                        delete(obj.myAnimals{ii}(idxToDelete).FigObj)
                    end
                    obj.myAnimals{ii}(idxDeaths) = [];
                end
                
                if ~isempty(bornAnimals)
                    obj.myAnimals{ii} = vertcat(obj.myAnimals{ii}, bornAnimals{:});
                end
            end
        end
    end
end


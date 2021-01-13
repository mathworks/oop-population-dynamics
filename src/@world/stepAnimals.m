function obj = stepAnimals(obj)

% Do the animals in reverse food chain order, that is process the prey
% before the predator.

for ii = numel(obj.foodOrder):-1:1
    [isAnimal, idxAnimal]= isAnimalFromWeb(obj, obj.foodOrder(ii));
    if ~isAnimal
        continue
    end
    
    
    myCurrAnimals = obj.myAnimals{idxAnimal};
    idxDeaths = [];
    bornAnimals = {};
    
    for jj = 1:numel(myCurrAnimals)
        % Move
        myCurrAnimals(jj) = ...
            myCurrAnimals(jj).move(obj.edgeLength);
        
        % Eat
        obj = eats(obj, idxAnimal, jj);
        
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
    
    obj.myAnimals{idxAnimal} = myCurrAnimals;
end
end


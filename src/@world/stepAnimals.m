function obj = stepAnimals(obj)

% Do the animals in reverse food chain order, that is process the prey
% before the predator.

for ii = numel(obj.foodOrder):-1:1
    [isAnimal, idxAnimal]= isAnimalFromWeb(obj, obj.foodOrder(ii));
    if ~isAnimal
        continue
    end
    
    myCurrAnimals = obj.myAnimals{idxAnimal};
    bornAnimals = {};
    
    for jj = 1:numel(myCurrAnimals)
        % Carve off a conveniance variable and remember as this is a handle
        % class then the changes will automatically propagate back
        currAnimal = myCurrAnimals(jj);
        
        % Sanity check for dead animal 
        if ~currAnimal.IsAlive
            continue
        end
        % Move
        currAnimal.move(obj.edgeLength);
        
        % Eat
        currAnimal.eats(obj);
        
        % Expend energy
        currAnimal.expendEnergy()
        if ~currAnimal.IsAlive
            continue
        end
        
        % Do we breed?
        breedDiceRoll = randi([0, 100], 1) / 100;
        if breedDiceRoll < currAnimal.ProbReproduce
            currAnimal.Energy = currAnimal.Energy / 2;
            %TODO: has to be better to this:
            newAnimal = animal(...
                'Name', currAnimal.Species, ...
                'FeedsOn', currAnimal.FeedsOn, ...
                'Colour', currAnimal.Colour, ...
                'LineColour', currAnimal.LineColour, ...
                'ProbReproduce', currAnimal.ProbReproduce, ...
                'GainFromFood', currAnimal.GainFromFood, ...
                'Energy', currAnimal.Energy, ...
                'Marker', currAnimal.Marker, ...
                'Coordinate', currAnimal.Coordinate);
            if isempty(bornAnimals)
                bornAnimals = newAnimal;
            else
                bornAnimals(end+1, 1) = newAnimal; %#ok<AGROW>
            end
        end
    end
    
    % Kill hungry animals and birth new ones
    %TODO: this is hack, probably should be a handle class
    idxToDrop = ~[myCurrAnimals.IsAlive];
    myCurrAnimals(idxToDrop) = [];
    
    if ~isempty(bornAnimals)
        myCurrAnimals = vertcat(myCurrAnimals, bornAnimals); %#ok<AGROW>
    end
    
    obj.myAnimals{idxAnimal} = myCurrAnimals;
end
end


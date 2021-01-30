function obj = stepAnimals(obj)

% Do the animals in reverse food chain order, that is process the prey
% before the predator.

for ii = numel(obj.foodOrder):-1:1
    [isAnimal, idxAnimal]= isAnimalFromWeb(obj, obj.foodOrder(ii));
    if ~isAnimal
        continue
    end
    
    myCurrAnimals = obj.myAnimals{idxAnimal};
    bornAnimals = animal.empty;
    
    for jj = 1:numel(myCurrAnimals)
        % Carve off a conveniance variable and remember as this is a handle
        % class then the changes will automatically propagate back
        currAnimal = myCurrAnimals(jj);
        
        % Sanity check for dead animal 
        if ~currAnimal.IsAlive
            continue
        end
        
        % Move
        currAnimal.nextStep(obj);
        
        % Eat
        currAnimal.eats(obj);
        
        % Expend energy
        currAnimal.expendEnergy()
        if ~currAnimal.IsAlive
            continue
        end
        
        % Do we breed?
        newAnimal = currAnimal.breed();
        if ~isempty(newAnimal)
            bornAnimals = vertcat(bornAnimals, newAnimal); %#ok<AGROW>
        end
    end
    
    % Remove dead animals and add the new borns
    idxToDrop = ~[myCurrAnimals.IsAlive];
    myCurrAnimals(idxToDrop) = [];
    myCurrAnimals = vertcat(myCurrAnimals, bornAnimals); %#ok<AGROW>
    
    obj.myAnimals{idxAnimal} = myCurrAnimals;
end
end


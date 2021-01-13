function obj = eats(obj, idxSpecies, idxAnimal)

persistent foodLocs idxOfPrey

localX = round(obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(1));
localY = round(obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(2));

if obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Grass"
    if obj.worldGrid(localX, localY).Energy > 1
        obj.worldGrid(localX, localY).Energy = obj.worldGrid(localX, localY).Energy - 1;
    end
else
    if idxAnimal == 1 || isempty(idxOfPrey)
        idxOfPrey = getAnimalIdxByName(obj, obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn);
        foodLocs = [obj.myAnimals{idxOfPrey}.Coordinate];
    end
    
    foodNearMe = find(...
        abs(foodLocs(1, :) - localX) <= 1.25 & ...
        abs(foodLocs(2, :) - localY) <= 1.25);
    if isempty(foodNearMe)
        % Hungry predator
        return
    end
    
    % Drop dead animals
    for ii = numel(foodNearMe):-1:1
        if ~obj.myAnimals{1}(foodNearMe(ii)).IsAlive
            foodNearMe(ii) = [];
        end
    end
    % Check if there is still some food
    if isempty(foodNearMe)
        return
    end
    if numel(foodNearMe) > 1
        % Lots of food, grab one at random
        idxFood = randi(numel(foodNearMe), 1);
        foodNearMe = foodNearMe(idxFood);
    end
    % Food dies
    obj.myAnimals{idxOfPrey}(foodNearMe).IsAlive = false;
end

% Common code
increaseEnergy(obj.myAnimals{idxSpecies}(idxAnimal));
end


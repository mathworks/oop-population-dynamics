function obj = eats(obj, idxSpecies, idxAnimal)

localX = round(obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(1));
localY = round(obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(2));

if obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Grass"
    if obj.worldGrid(localX, localY).Energy > 1
        obj.worldGrid(localX, localY).Energy = obj.worldGrid(localX, localY).Energy - 1;
    end
elseif obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Sheep"
    foodLocs = [obj.myAnimals{1}.Coordinate];
    foodNearMe = find(...
        abs(foodLocs(1, :) - localX) <= 1.25 & ...
        abs(foodLocs(2, :) - localY) <= 1.25);
    if isempty(foodNearMe)
        % Hungry predator
        return
    end
    if numel(foodNearMe) > 1
        % Lots of food, grab one at random
        idxFood = randi(numel(foodNearMe), 1);
        foodNearMe = foodNearMe(idxFood);
    end
    % Food dies
    obj.myAnimals{1}(foodNearMe) = [];
end

% Common code
obj.myAnimals{idxSpecies}(idxAnimal).Energy = ...
    obj.myAnimals{idxSpecies}(idxAnimal).Energy + ...
    (1 * obj.myAnimals{idxSpecies}(idxAnimal).GainFromFood);
end


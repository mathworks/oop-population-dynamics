function obj = eats(obj, idxSpecies, idxAnimal)

localX = obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(1);
localY = obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(2);

if obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Grass"
    if obj.worldGrid(localX, localY).Energy > 1
        obj.worldGrid(localX, localY).Energy = obj.worldGrid(localX, localY).Energy - 1;
    end
elseif obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Sheep"
    foodLocs = [obj.myAnimals{1}.Coordinate];
    foodNearMe = find(...
        abs(foodLocs(1, :) - localX) <= 1 & ...
        abs(foodLocs(2, :) - localY) <= 1);
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
    delete(obj.myAnimals{1}(foodNearMe).FigObj);
    obj.myAnimals{1}(foodNearMe) = [];
end

% Common code
obj.myAnimals{idxSpecies}(idxAnimal).Energy = ...
    obj.myAnimals{idxSpecies}(idxAnimal).Energy + ...
    (1 * obj.myAnimals{idxSpecies}(idxAnimal).GainFromFood);
end


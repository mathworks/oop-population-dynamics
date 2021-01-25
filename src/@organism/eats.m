function eats(obj, world)

persistent foodLocs idxOfPrey

localX = round(obj.Coordinate(1));
localY = round(obj.Coordinate(2));

if obj.FeedsOn == "Grass"
    %TODO: change this to automatically die the plant with a method
    if world.worldGrid(localX, localY).Energy > 1
        world.worldGrid(localX, localY).Energy = world.worldGrid(localX, localY).Energy - 1;
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
increaseEnergy(obj);
end


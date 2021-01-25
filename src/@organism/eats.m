function eats(obj, world, currTimeStep)

persistent foodLocs idxOfPrey previousPrey

if isempty(previousPrey) || obj.FeedsOn ~= previousPrey
    previousPrey = obj.FeedsOn;
    idxOfPrey = getAnimalIdxByName(world, previousPrey);
    if idxOfPrey >= 1
        foodLocs = [world.myAnimals{idxOfPrey}.Coordinate];
    end
end

localX = round(obj.Coordinate(1));
localY = round(obj.Coordinate(2));

if obj.FeedsOn == "Grass"
    %TODO: change this to automatically die the plant with a method
    if world.worldGrid(localX, localY).Energy > 1
        world.worldGrid(localX, localY).isEaten(currTimeStep);
    end
else
    foodNearMe = find(...
        abs(foodLocs(1, :) - localX) <= 1.25 & ...
        abs(foodLocs(2, :) - localY) <= 1.25);
    if isempty(foodNearMe)
        % Hungry predator
        return
    end
    
    % Drop dead animals
    for ii = numel(foodNearMe):-1:1
        if ~world.myAnimals{1}(foodNearMe(ii)).IsAlive
            foodNearMe(ii) = [];
        end
    end
    % Check if there is still some food
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
    world.myAnimals{idxOfPrey}(foodNearMe).IsAlive = false;
end

% Common code
increaseEnergy(obj);
end


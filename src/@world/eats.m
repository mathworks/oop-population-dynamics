function obj = eats(obj, idxSpecies, idxAnimal)

localX = obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(1);
localY = obj.myAnimals{idxSpecies}(idxAnimal).Coordinate(2);

if obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Grass"
    if obj.worldGrid(localX, localY).Energy > 1
        obj.worldGrid(localX, localY).Energy = obj.worldGrid(localX, localY).Energy - 1;
        obj.myAnimals{idxSpecies}(idxAnimal).Energy = ...
            obj.myAnimals{idxSpecies}(idxAnimal).Energy + ...
            (1 * obj.myAnimals{idxSpecies}(idxAnimal).GainFromFood);
    end
elseif obj.myAnimals{idxSpecies}(idxAnimal).FeedsOn == "Sheep"
%     display('Dingo feeding...')
end
end


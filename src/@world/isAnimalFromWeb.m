function [myOrganism, idxAnimals] = isAnimalFromWeb(obj, idxSpecies)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

myOrganism = false;
idxAnimals = -1;
mySpecies = obj.foodWeb.Nodes.Name{idxSpecies};

for ii = 1:numel(obj.myAnimals)
    if obj.myAnimals{ii}(1).Species == mySpecies
        myOrganism = true;
        idxAnimals = ii;
        break
    end
end

end


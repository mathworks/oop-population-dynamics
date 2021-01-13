function obj = getFoodWeb(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
obj.foodWeb = digraph();

for ii = 1:numel(obj.myAnimals)
    myOrganism = obj.myAnimals{ii}(1);
    if ii == 1
        obj.foodWeb = addnode(obj.foodWeb, myOrganism.Species);
        speciesExists = findnode(obj.foodWeb, myOrganism.Species);
    else
        speciesExists = findnode(obj.foodWeb, myOrganism.Species);
        if speciesExists == 0
            obj.foodWeb = addnode(obj.foodWeb, myOrganism.Species);
            speciesExists = findnode(obj.foodWeb, myOrganism.Species);
        end
    end
    
    % Always add food
    foodExists = findnode(obj.foodWeb, myOrganism.FeedsOn);
    if foodExists == 0
        obj.foodWeb = addnode(obj.foodWeb, myOrganism.FeedsOn);
        foodExists = findnode(obj.foodWeb, myOrganism.FeedsOn);
    end
    
    obj.foodWeb = addedge(obj.foodWeb, speciesExists, foodExists);
end

end


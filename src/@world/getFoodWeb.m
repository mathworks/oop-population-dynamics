function obj = getFoodWeb(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
obj.foodWeb = digraph();

for ii = 1:numel(obj.myAnimals)
    myOrganism = obj.myAnimals{ii}(1);
    if ii == 1
        obj.foodWeb = addnode(obj.foodWeb, myOrganism.Name);
        speciesExists = findnode(obj.foodWeb, myOrganism.Name);
    else
        speciesExists = findnode(obj.foodWeb, myOrganism.Name);
        if speciesExists == 0
            obj.foodWeb = addnode(obj.foodWeb, myOrganism.Name);
            speciesExists = findnode(obj.foodWeb, myOrganism.Name);
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

obj.foodOrder = toposort(obj.foodWeb);

end


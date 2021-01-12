function plotFoodWeb(organisms)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

myGraph = digraph();

for ii = 1:numel(organisms)
    myOrganism = organisms{ii}(1);
    if ii == 1
        myGraph = addnode(myGraph, myOrganism.Species);
        speciesExists = findnode(myGraph, myOrganism.Species);
    else
        speciesExists = findnode(myGraph, myOrganism.Species);
        if speciesExists == 0
            myGraph = addnode(myGraph, myOrganism.Species);
            speciesExists = findnode(myGraph, myOrganism.Species);
        end
    end
    
    % Always add food
    foodExists = findnode(myGraph, myOrganism.FeedsOn);
    if foodExists == 0
        myGraph = addnode(myGraph, myOrganism.FeedsOn);
        foodExists = findnode(myGraph, myOrganism.FeedsOn);
    end
    
    myGraph = addedge(myGraph, speciesExists, foodExists);
end

figure
plot(myGraph)

end

function plotFoodWeb(organisms)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

myGraph = digraph();

for ii = 1:numel(organisms)
    myOrganism = organisms{ii}(1);
    if ii == 1
        myGraph = addnode(myGraph, myOrganism.Species);
    else
        myGraph = addSpeciesNode(myGraph, myOrganism);
    end
end

figure
plot(myGraph)

end

function myGraph = addSpeciesNode(myGraph, myOrganism)
speciesExists = findnode(myGraph, myOrganism.Species);

if speciesExists == 0
    myGraph = addnode(myGraph, myOrganism.Species);
    speciesExists = findnode(myGraph, myOrganism.Species);
end

foodExists = findnode(myGraph, myOrganism.FeedsOn);
if foodExists == 0
    myGraph = addnode(myGraph, myOrganism.Species);
    foodExists = findnode(myGraph, myOrganism.FeedsOn);
end

myGraph = addedge(myGraph, speciesExists, foodExists);
end


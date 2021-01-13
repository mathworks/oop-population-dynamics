function obj = stepPlants(obj)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

plantGrid = obj.worldGrid;
for ii = 1:numel(plantGrid)
    plantGrid(ii).Energy = plantGrid(ii).Energy + 1;
end

obj.worldGrid = plantGrid;

end


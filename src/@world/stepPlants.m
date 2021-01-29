function obj = stepPlants(obj)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for ii = 1:obj.edgeLength
    for jj = 1:obj.edgeLength
        obj.worldGrid(ii, jj).grow(obj.currTimeStep);
    end
end

end


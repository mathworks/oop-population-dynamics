function obj = plotWorld(obj)
%PLOTWORLD Function to plot the world figure

if isempty(obj.axWorld)
    figWorld = figure;
    obj.axWorld = axes(figWorld);
else
    delete(obj.axWorld.Children);
end

persistent locX myZ colourGrid
if isempty(locX) || isempty(myZ) || isempty(colourGrid)
    locX = 0.5:1:double(obj.edgeLength)+0.5;
    myZ = zeros(obj.edgeLength+1, obj.edgeLength+1);
    colourGrid = obj.worldColour;
    colourGrid(end+1, :, :) = colourGrid(end, :, :);
    colourGrid(:, end+1, :) = colourGrid(:, end, :);
end

colourGrid(1:obj.edgeLength, 1:obj.edgeLength, :) = obj.worldColour;

surf(obj.axWorld, ...
    locX, locX, myZ, ...
    colourGrid, ...
    'LineStyle', 'none');
view(obj.axWorld, 2)
obj.axWorld.XLim = [0.5, obj.edgeLength + 0.5];
obj.axWorld.YLim = [0.5, obj.edgeLength + 0.5];

% Add in the animals
animalLocs = obj.animalLocations;
for ii = 1:numel(animalLocs)
    line(obj.axWorld, ...
        animalLocs(ii).coord(:, 1), ...
        animalLocs(ii).coord(:, 2), ...
        100 * ones(size(animalLocs(ii).coord, 1)), ...
        'LineStyle', 'none', ...
        'Marker', animalLocs(ii).Marker, ...
        'Color', animalLocs(ii).Colour, ...
        'LineWidth', 1);
end

drawnow()

end

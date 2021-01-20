function obj = plotWorld(obj)
%PLOTWORLD Function to plot the world figure

if isempty(obj.axWorld)
    figWorld = figure;
    obj.axWorld = axes(figWorld);
else
%     delete(obj.axWorld.Children);
end

persistent locX myZ colourGrid
if isempty(locX) || isempty(myZ) || isempty(colourGrid)
    locX = 0.5:1:double(obj.edgeLength)+0.5;
    myZ = zeros(obj.edgeLength+1, obj.edgeLength+1);
    colourGrid = obj.worldColour;
    colourGrid(end+1, :, :) = colourGrid(end, :, :);
    colourGrid(:, end+1, :) = colourGrid(:, end, :);
end

% Do animals first as I can use an isempty from later
animalLocs = obj.animalLocations;
for ii = 1:numel(animalLocs)
    tmpX = animalLocs(ii).coord(:, 1);
    tmpY = animalLocs(ii).coord(:, 2);
    tmpZ = 100 * ones(size(animalLocs(ii).coord, 1), 1);
    if isempty(obj.handleSurface)
        obj.handleAnimals{ii} = line(obj.axWorld, ...
            tmpX, tmpY, tmpZ, ...
            'LineStyle', 'none', ...
            'Marker', animalLocs(ii).Marker, ...
            'Color', animalLocs(ii).Colour, ...
            'LineWidth', 1);
    else
        set(obj.handleAnimals{ii}, ...
            'XData', tmpX, ...
            'YData', tmpY, ...
            'Zdata', tmpZ)
    end
end


colourGrid(1:obj.edgeLength, 1:obj.edgeLength, :) = obj.worldColour;

if isempty(obj.handleSurface)
    hold on
    obj.handleSurface = surf(obj.axWorld, ...
        locX, locX, myZ, ...
        colourGrid, ...
        'LineStyle', 'none');
    hold off
    view(obj.axWorld, 2)
    obj.axWorld.XLim = [0.5, obj.edgeLength + 0.5];
    obj.axWorld.YLim = [0.5, obj.edgeLength + 0.5];
else
    set(obj.handleSurface, ...
        'CData', colourGrid)
end



drawnow()

end

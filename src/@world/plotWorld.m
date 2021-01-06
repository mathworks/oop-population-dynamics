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
for ii = 1:numel(obj.myAnimals)
    for jj = 1:numel(obj.myAnimals{ii})
        localX = obj.myAnimals{ii}(jj).Coordinate(1);
        localY = obj.myAnimals{ii}(jj).Coordinate(2);
        obj.myAnimals{ii}(jj).FigObj = line(obj.axWorld, ...
            localX, localY, 100, ...
            'LineStyle', 'none', ...
            'Marker', obj.myAnimals{ii}(jj).Marker, ...
            'Color', obj.myAnimals{ii}(jj).Colour, ...
            'LineWidth', 1);
    end
end

drawnow()

end

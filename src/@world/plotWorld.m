function obj = plotWorld(obj)
%PLOTWORLD Function to plot the world figure

if isempty(obj.axWorld)
    % Change the figure size and move to the centre of the monitor
    obj.figToPlot = figure;
    obj.figToPlot.Units = 'normalized';
    obj.figToPlot.Position(3) = obj.figToPlot.Position(3) * 2;
    obj.figToPlot.Position(1:2) = 0.5 - (obj.figToPlot.Position(3:4) ./ 2);
    
    worldTile = tiledlayout(obj.figToPlot, 1, 2, ...
        'TileSpacing', 'compact', ...
        'Padding', 'compact');
    obj.axWorld = axes(worldTile);
    obj.axPops = nexttile(worldTile);
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
myLegendItems = cell(numel(obj.myAnimals), 1);
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
    
    myLegendItems{ii} = obj.myAnimals{ii}(1).Species;
end


colourGrid(1:obj.edgeLength, 1:obj.edgeLength, :) = obj.worldColour;

if isempty(obj.handleSurface)
    hold(obj.axWorld, 'on')
    obj.handleSurface = surf(obj.axWorld, ...
        locX, locX, myZ, ...
        colourGrid, ...
        'LineStyle', 'none');
    hold(obj.axWorld, 'off')
    view(obj.axWorld, 2)
    obj.axWorld.XLim = [0.5, obj.edgeLength + 0.5];
    obj.axWorld.YLim = [0.5, obj.edgeLength + 0.5];
    obj.axWorld.XTick = [];
    obj.axWorld.YTick = [];
else
    set(obj.handleSurface, ...
        'CData', colourGrid)
end


persistent handleTitle
titleText = ['Simulation at Step: ', num2str(obj.currTimeStep)];
if isempty(handleTitle)
    handleTitle = title(obj.axWorld, titleText);
else
    handleTitle.String = titleText;
end

legend(obj.axWorld, [obj.handleAnimals{:}], myLegendItems, ...
    'Location', 'BestOutside')

end

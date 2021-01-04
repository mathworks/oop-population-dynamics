function obj = plotWorld(obj)
%PLOTWORLD Function to plot the world figure
%   This is only called once at start up to create the image, after that
%   the objects update themselves.

figWorld = figure;
axWorld = axes(figWorld);

for ii = 1:obj.edgeLength
    for jj = 1:obj.edgeLength
        obj.worldGrid(ii, jj).FigObj = patch(axWorld, ...
            'XData', patchX(ii), ...
            'YData', patchY(jj), ...
            'FaceColor', obj.worldGrid(ii, jj).Colour, ...
            'LineStyle', 'none');
    end
end
axWorld.XLim = [0.5, obj.edgeLength + 0.5];
axWorld.YLim = [0.5, obj.edgeLength + 0.5];

% Add in the animals
for ii = 1:numel(obj.myAnimals)
    for jj = 1:numel(obj.myAnimals{ii})
        localX = obj.myAnimals{ii}(jj).Coordinate(1);
        localY = obj.myAnimals{ii}(jj).Coordinate(2);
        obj.myAnimals{ii}(jj).FigObj = line(axWorld, ...
            localX, localY, 100, ...
            'LineStyle', 'none', ...
            'Marker', obj.myAnimals{ii}(jj).Marker, ...
            'Color', obj.myAnimals{ii}(jj).Colour, ...
            'LineWidth', 1);
    end
end

drawnow
pause(1)
end

function xIdxs = patchX(xIdx)
xIdxs = zeros(4, 1);

xIdxs(1) = xIdx - 0.5;
xIdxs(2) = xIdx + 0.5;
xIdxs(3) = xIdx + 0.5;
xIdxs(4) = xIdx - 0.5;
end

function yIdxs = patchY(yIdx)
yIdxs = zeros(4, 1);

yIdxs(1) = yIdx - 0.5;
yIdxs(2) = yIdx - 0.5;
yIdxs(3) = yIdx + 0.5;
yIdxs(4) = yIdx + 0.5;

end
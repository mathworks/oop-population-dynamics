function obj = plotWorld(obj)
%PLOTWORLD Function to plot the world figure

if isempty(obj.figWorld)
    obj.figWorld = figure;
    obj.myAxes = axes(obj.figWorld);
end

rgbMatrix = obj.plantRGBMatrix;

% Add in the animals
for ii = 1:numel(obj.myAnimals)
    for jj = 1:numel(obj.myAnimals{ii})
        localX = obj.myAnimals{ii}(jj).Coordinate(1);
        localY = obj.myAnimals{ii}(jj).Coordinate(2);
        rgbMatrix(localX, localY, :) = ...
            obj.myAnimals{ii}(jj).Colour;
    end
end

imshow(rgbMatrix, ...
    'Parent', obj.myAxes, ...
    'Border', 'tight')
drawnow;
end
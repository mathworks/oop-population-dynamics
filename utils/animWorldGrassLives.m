clearvars
close all

nCells = 40;
(nCells ^ 2) / 25

myFig = figure;
myAx = axes(myFig);
myAx.XLim = [0.5, nCells + 0.5];
myAx.YLim = [0.5, nCells + 0.5];
myAx.XTick = [];
myAx.YTick = [];
box on

figCounter = 0;

for ii = 1:nCells
    for jj = 1:nCells
        figCounter = figCounter + 1;
        locX = [...
            ii - 0.5, ...
            ii + 0.5, ...
            ii + 0.5, ...
            ii - 0.5];
        locY = [...
            jj - 0.5, ...
            jj - 0.5, ...
            jj + 0.5, ...
            jj + 0.5];
        patch(locX, locY, [70, 242, 128] / 255)
            
        fName = sprintf('worldGrassLives_%04d.png', ...
            figCounter);
        exportgraphics(myFig, ...
            fName, ...
            'Resolution', 300)
    end
end

%%
close all
myFig = figure;
myAx = axes(myFig);
myAx.XLim = [0.5, nCells + 0.5];
myAx.YLim = [0.5, nCells + 0.5];
myAx.XTick = [];
myAx.YTick = [];
box on

figCounter = 0;

for ii = 1:nCells
    for jj = 1:nCells
        figCounter = figCounter + 1;
        locX = [...
            ii - 0.5, ...
            ii + 0.5, ...
            ii + 0.5, ...
            ii - 0.5];
        locY = [...
            jj - 0.5, ...
            jj - 0.5, ...
            jj + 0.5, ...
            jj + 0.5];
        
        if rand() > 0.5
            myColour = [70, 242, 128] / 255;
        else
            myColour = [240, 197, 149] / 255;
        end
        
        patch(locX, locY, myColour)
            
        fName = sprintf('worldGrassDies_%04d.png', ...
            figCounter);
        exportgraphics(myFig, ...
            fName, ...
            'Resolution', 300)
    end
end
    


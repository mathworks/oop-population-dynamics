clearvars
close all

%% Set Up the Biology
% Grass
% propertiesGrass = struct('Class', 'plant');
% propertiesGrass.Name = 'Grass';
% propertiesGrass.percentOfWorld = 100;

% Sheep
mySheep = animal('Name', 'Sheep', ...
    'FeedsOn', 'Grass', ...
    'Colour', [200, 200, 200] / 255, ...
    'ProbReproduce', 0.04, ...
    'GainFromFood', 4, ...
    'Energy', 1, ...
    'Marker', 'o',...
    'Coordinate', [0, 0]);
nSheep = 100;

% Dingos
myDingos = animal('Name', 'Dingo', ...
    'FeedsOn', 'Sheep', ...
    'Colour', [0, 0, 0] / 255, ...
    'ProbReproduce', 0.05, ...
    'GainFromFood', 20, ...
    'Energy', 1, ...
    'Marker', 'x',...
    'Coordinate', [0, 0]);
nDingos = 50;


%% Set Up The World
mySim = world({mySheep, myDingos}, ...
    [nSheep, nDingos]);

%% Run
run(mySim)
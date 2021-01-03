clearvars
close all

%% Set Up the Biology
% Grass
% propertiesGrass = struct('Class', 'plant');
% propertiesGrass.Name = 'Grass';
% propertiesGrass.LivesForEver = true;
% propertiesGrass.percentOfWorld = 100;

% Sheep
propertiesSheep = struct('Class','animal');
propertiesSheep.Name = 'Sheep';
propertiesSheep.FeedsOn = 'Grass';
propertiesSheep.InitialCount = 100;
propertiesSheep.GainFromFood = 4;
propertiesSheep.Reproduce = 0.04;
propertiesSheep.Colour = [200, 200, 200] / 255;

% Dingos
propertiesDingo = struct('Class','animal');
propertiesDingo.Name = 'Dingo';
propertiesDingo.FeedsOn = 'Sheep';
propertiesDingo.InitialCount = 50;
propertiesDingo.GainFromFood = 20;
propertiesDingo.Reproduce = 0.05;
propertiesDingo.Colour = [0, 0, 0] / 255;




%% Set Up The World
mySim = world({propertiesSheep, propertiesDingo})

% Runs
run(mySim)
clear all
clear classes
clear all
close all

mySheep = animal('Name', 'Sheep', ...
    'FeedsOn', 'Grass', ...
    'Colour', [255, 255, 255] / 255, ...
    'LineColour', [200, 200, 200] / 255, ...
    'ProbReproduce', 0.04, ...
    'GainFromFood', 4, ...
    'Energy', 1, ...
    'Marker', 'o',...
    'Coordinate', [0, 0]);
% 
% mySheepTwo = copy(mySheep)
% mySheep == mySheepTwo
% mySheepTwo.Marker = '.';
% mySheep.Marker

% mySheepThree = repmat(mySheep, [3,1])
% mySheepThree(3).Marker = '.';
% mySheepThree(1).Marker
% mySheepThree(3).Marker

mySheepFour(2, 2) = mySheep;
disp('here')
disp(mySheepFour(1,1).Energy)
mySheepFour(2,2).Marker = 'x';
disp(mySheepFour(1,1).Marker)
disp(mySheepFour(end,end).Marker)
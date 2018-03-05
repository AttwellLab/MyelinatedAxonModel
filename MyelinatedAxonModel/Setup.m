function Setup()
% Prepares the MATLAB path for use of the Myelinated Axon model.

% We will add the current directory to the MATLAB path
pathToModel = fileparts(mfilename('fullpath'));

fprintf('Adding the following directory, and its subdirectories, to the MATLAB path:\n%s\n', pathToModel);
userAnswer = input('Agree (y/n)?', 's');

if strcmp(userAnswer, 'y')
    path(path, genpath(pathToModel));
else
    return
end

% Start up the GUI to show it's working.
StartAxonGUI();

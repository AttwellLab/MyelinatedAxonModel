function SaveActiveChannel(filename, activeChannel)
%SAVEACTIVECHANNEL - save an active channel to .mat file
%   SAVEACTIVECHANNEL(filename, channel)
%       Inputs:
%           filename -  string containing a valid filename
%           channel -   structure containing parameters of an active
%                       channel

% Since this will be "axon" independent, we set the vector of conductance
% values to empty, this will be filled upon loading into a new axon.
activeChannel.cond.value.vec = [];

% Save the active channel.
save(filename, 'activeChannel')





function par = RemoveActiveChannel(par, channelNo)
%REMOVEACTIVECHANNEL - Removes an active channel from the nodes of a myelinated axon
%   par - REMOVEACTIVECHANNEL(par, channel#)
%       Outputs:
%           par -           modified parameter structure
%       Inputs:
%           par -           existing parameter structure
%           channel# -      index of the channel to remove.


if ~isfield(par.node, 'elec')
    error('Nodes don''t have any active channels')
end

if ~isfield(par.node.elec, 'act')
    error('Nodes don''t have any active channels')
end

if isempty(par.node.elec.act)
    error('Nodes don''t have any active channels')
end

if CheckValue(channelNo, 'integer', [1, length(par.node.elec.act)])
    error('Channel number is outside acceptable range')
end

par.node.elec.act(channelNo) = [];
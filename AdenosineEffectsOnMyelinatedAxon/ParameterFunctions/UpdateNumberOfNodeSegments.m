function par = UpdateNumberOfNodeSegments(par, nNodeSeg)
%UPDATENUMBEROFNODESEGMENTS
%   par = UPDATENUMBEROFNODESEGMENTS(par, nNodeSeg)
%       Outputs:
%           par -               modified parameter structure
%       Inputs:
%           par -               existing parameter structure
%           nNodeSeg -          number of node segments: positive integer
%                               must be greater than or equal to 1.
%
%   This function doesn't call 'CalculateLeakConductance.m', so if you want
%   to update the leak channels you must do this yourself.
%
%   The GUI doesn't have this option.
%

if CheckValue(nNodeSeg, 'integer', [1, inf])
    error('Number of node segments is not acceptable')
end

par.geo.nnodeseg =                      nNodeSeg;

par.node.seg.geo.diam.value.vec =       repmat(par.node.geo.diam.value.vec, 1, par.geo.nnodeseg);

par.node.seg.geo.length.value.vec =     repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

par.node.elec.pas.leak.erev.value.vec = par.node.elec.pas.leak.erev.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);

if isfield(par.node.elec, 'act')
    for i = 1 : length(par.node.elec.act)
        par.node.elec.act(i).cond.value.vec = par.node.elec.act(i).cond.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
    end
end

par =                                   CalculateLeakConductance(par);
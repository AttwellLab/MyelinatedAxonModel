function par = UpdateNumberOfInternodeSegments(par, nIntSeg, myelinUpdate)
%UPDATENUMBEROFINTERNODESEGMENTS
%   par = UPDATENUMBEROFINTERNODESEGMENTS(par, nIntSeg, [myelinUpdate])
%       Outputs:
%           par -               modified parameter structure
%       Inputs:
%           par -               existing parameter structure
%           nIntSeg -           number of internode segments: positive integer
%                               must be greater than or equal to 1.
%           [myelinUpdate] -    'max' (default) or 'min'.  After updating the
%                               diameter, the function runs
%                               CalculateNumberOfMyelinLamellae. SEE UPDATE
%                               METHOD OF THAT FUNCTION FOR DETAILS.
%
%   The GUI only has one option: reset the internode.

if CheckValue(nIntSeg, 'integer', [1, inf])
    error('Number of internode segments is not acceptable')
end

VariableDefault('myelinUpdate', 'max');

par.geo.nintseg =                       nIntSeg;

par.intn.seg.geo.length.value.vec =     repmat(par.intn.geo.length.value.vec / par.geo.nintseg, 1, par.geo.nintseg);

par.intn.seg.geo.diam.value.vec =       repmat(par.intn.geo.diam.value.vec, 1, par.geo.nintseg);

par.myel.geo.peri.value.vec =           par.myel.geo.peri.value.ref * ones(par.geo.nintn, par.geo.nintseg);

par.myel.geo.gratio.value.vec_ref =     par.myel.geo.gratio.value.ref * ones(par.geo.nintn, par.geo.nintseg);

par =                                   CalculateNumberOfMyelinLamellae(par, myelinUpdate);
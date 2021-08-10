function par = UpdateMyelinLamellaPeriodicity(par, value, myelinUpdate)
%UPDATEMYELINLAMELLAPERIODICITY
%   UPDATEMYELINLAMELLAPERIODICITY(par, value, [myelinUpdate])
%       Outputs:
%               par -       modified parameter structure
%       Inputs:
%               par -       existing parameter structure
%               value -     the diameters to insert into the internode segments
%               [myelinUpdate] - 'max' (default) or 'min'.  After updating the
%                               diameter, the function runs
%                               CalculateNumberOfMyelinLamellae. SEE UPDATE
%                               METHOD OF THAT FUNCTION FOR DETAILS.

VariableDefault('myelinUpdate', 'max');

if CheckValue(value, 'real', [0, inf])
    error('Value outside possible range');
end

par.myel.geo.period.value = value;

% Must update the myelin parameters.
par = CalculateNumberOfMyelinLamellae(par, myelinUpdate);
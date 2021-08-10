function par = CalculateNumberOfMyelinLamellae(par, updateType)
%CALCULATENUMBEROFMYELINLAMELLAE
%   par = CALCULATENUMBEROFMYELINLAMELLAE(par, [update method])
%       Outputs:
%           par -   modified parameter structure
%       Inputs:
%           par -            parameter structure
%          [update method] - either 'max' or 'min' (default = 'max')
%                   when the number of myelin lamellae is updated,
%                   sometimes inhomogeneities in the internode
%                   (e.g. axon diameter, periaxonal space width), mean
%                   there are a different number of wraps along a single
%                   internode. Since this makes no sense, we set the number
%                   equal along a single internode. 'max' will set that
%                   number to the maximum value found along the internode,
%                   'min' will set it to the minimum.

% Check the inputs
VariableDefault('updateType', 'max');
if CheckValue(updateType, 'string', {'max', 'min'})
    fprintf('`update method must be either ''max'' or ''min''\n'); beep;
    return
end

% Calculate the number of myelin wraps from this information.
r_ref =                                 fromsimunits(par.myel.geo.width.units) * simunits(par.intn.seg.geo.diam.units) * par.intn.seg.geo.diam.value.vec / 2;
R_ref =                                 r_ref ./ par.myel.geo.gratio.value.vec_ref;

% Width of myelin sheath (minus periaxonal space width).
par.myel.geo.width.value.vec =          (R_ref - r_ref) - simunits(par.myel.geo.peri.units) * fromsimunits(par.myel.geo.width.units) * par.myel.geo.peri.value.vec;

% Number of myelin lamellae.
par.myel.geo.numlamellae.value.vec =    ceil(par.myel.geo.width.value.vec / (simunits(par.myel.geo.period.units) * fromsimunits(par.myel.geo.width.units) * par.myel.geo.period.value));

% Ensure that along a single internode, all the values are the same - we
% can do this in several ways.
for i = 1 : par.geo.nintn
    if length(unique(par.myel.geo.numlamellae.value.vec(i, :))) > 1
        if strcmp(updateType, 'max')
            par.myel.geo.numlamellae.value.vec(i, :) = ...
                max(par.myel.geo.numlamellae.value.vec(i, :));
        elseif strcmp(updateType, 'min')
            par.myel.geo.numlamellae.value.vec(i, :) = ...
                min(par.myel.geo.numlamellae.value.vec(i, :));
        end
    end
end

% Set reference value to mode of this matrix - this is not directly
% updatable or used by the model, but for display purposes.
par.myel.geo.numlamellae.value.ref =    mode(par.myel.geo.numlamellae.value.vec(:));

% Recalculate width and g-ratio
par.myel.geo.width.value.vec =          (par.myel.geo.numlamellae.value.vec - 0.5) * fromsimunits(par.myel.geo.width.units) * simunits(par.myel.geo.period.units) * par.myel.geo.period.value;
par.myel.geo.width.value.ref =          mode(par.myel.geo.width.value.vec(:));

par.myel.geo.gratio.value.vec =         simunits(par.intn.seg.geo.diam.units) * par.intn.seg.geo.diam.value.vec ./ ...
    (2 * simunits(par.myel.geo.width.units) * par.myel.geo.width.value.vec + 2 * simunits(par.myel.geo.peri.units) * par.myel.geo.peri.value.vec + simunits(par.intn.seg.geo.diam.units) * par.intn.seg.geo.diam.value.vec);
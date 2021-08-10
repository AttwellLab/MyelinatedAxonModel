function par = UpdateInternodeGRatio(par, value, internodeIdx, segmentIdx, myelinUpdate)
%%UPDATEINTERNODEGRATIO
%   par = UPDATEINTERNODEGRATIO(par, value, [internodeIdx], [segmentIdx], [myelinUpdate])
%       Outputs:
%               par -       modified parameter structure
%       Inputs:
%               par -       existing parameter structure
%               value -     the g-ratios to insert into the internode segments
%
%                           the structure of `value' depends on the input to `internodeIdx' and `segmentIdx'
%                           In the following, the number is the possible input to `internodeIdx' and `segmentIdx' and
%                           the letters list the possible size for `value'.
%                           1.) `internodeIdx' and `segmentIdx' not defined or left empty:
%                               a.) scalar value
%                               b.) 1 x #internodes vector
%                               c.) 1 x (#internodes)*(#segments) vector
%                           2.) `internodeIdx' defined, `segmentIdx' not defined or left empty:
%                               a.) scalar value
%                               b.) 1 x length(internodeIdx) vector
%                               c.) 1 x (length(internodeIdx))*(#segments) vector
%                           3.) `internodeIdx' not defined or left empty, `segmentIdx' defined:
%                               a.) scalar value
%                               b.) 1 x length(segmentIdx) vector
%                               c.) 1 x (#internodes)*(length(segmentIdx)) vector
%                           4.) `internodeIdx' and `segmentIdx' defined:
%                               a.) scalar value
%                               b.) 1 x (length(internodeIdx)) vector
%
%               [internodeIdx] -  indices of the internodes in which to put `value'
%
%                               if empty or left out, `internodeIdx' will expand to *all* internodes.
%                               otherwise, 1xN vector of internode numbers in which to put `value'
%                                   if `segmentIdx' is empty or not defined `internodeIdx' may simply list internode numbers.
%                                   if `segmentIdx' is defined,
%                                   `internodeIdx' must be of the same size as `segmentIdx' and there may have to
%                                   be multiple repeats of the internode number.
%
%               [segmentIdx] -  indices of the internode segments in which to put `value'
%
%                               if empty or left out, `segmentIdx' will expand to *all* segments.
%                               otherwise, 1xN vector of segment numbers in which to put `value'
%
%               [myelinUpdate] - 'max' (default) or 'min'.  After updating the
%                               g-ratio, the function runs CalculateNumberOfMyelinLamellae. SEE UPDATE
%                               METHOD OF THAT FUNCTION FOR DETAILS.
%   Examples:
%
%       UpdateInternodeGRatio(par, 0.1)
%           set all segments in all internodes to have g-ratio 0.1.
%
%       UpdateInternodeGRatio(par, 0.1, 3)
%           set all segments in the 3rd internode to have g-ratio 0.1.
%
%       UpdateInternodeGRatio(par, 0.1, [], 3)
%           set the 3rd segment of all internodes to have g-ratio 0.1.
%
%       UpdateInternodeGRatio(par, [0.1, 0.2], [3, 4])
%           set all segments in the 3rd internode to g-ratio 0.1, and all
%           segments in the 4th internode to g-ratio 0.2.
%
%       UpdateInternodeGRatio(par, [0.1, 0.2], [], [3, 4])
%           set 3rd segment in the all internodes to g-ratio 0.1, and 4th
%           segment in all internodes to g-ratio 0.2.
%
%       UpdateInternodeGRatio(par, [0.1, 0.2, 0.3, 0.4, 0.5, 0.6], [1, 1, 1, 5, 5, 5], [1, 3, 5, 2, 4, 6])
%           set the 1st, 3rd and 5th segment of the 1st internode to 0.1, 0.2, and 0.3, respectively,
%           and the 2nd, 4th and 6th segment of the 5th internode to 0.4, 0.5, and 0.6, respectively.
%

%%%%% CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial checks on inputs.
VariableDefault('internodeIdx', []);
VariableDefault('segmentIdx', []);
VariableDefault('myelinUpdate', 'max');

if CheckValue(internodeIdx, 'integer', [1, par.geo.nintn], 'emptyOK') || ...
        CheckValue(segmentIdx, 'integer', [1, par.geo.nintseg], 'emptyOK')
    error('Internode or segment indices out of acceptable range')
end

% Convert these indices into indices which we can use to update the
% internode matrix.
[value, internodeIdx2, segmentIdx2] = UpdateInternodeIndices(par, value, internodeIdx, segmentIdx);
%%%%% END CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx = sub2ind(size(par.myel.geo.gratio.value.vec_ref), internodeIdx2, segmentIdx2);
par.myel.geo.gratio.value.vec_ref(idx) = value;

% Must update the myelin parameters.
par = CalculateNumberOfMyelinLamellae(par, myelinUpdate);
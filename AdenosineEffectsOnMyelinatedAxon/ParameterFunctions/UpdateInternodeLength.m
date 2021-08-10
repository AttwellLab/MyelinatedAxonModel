function par = UpdateInternodeLength(par, value, internodeIdx, segmentIdx)
%%UPDATEINTERNODELENGTH
%   par = UPDATEINTERNODELENGTH(par, value, [internodeIdx], [segmentIdx])
%       Outputs:
%               par -   modified parameter structure
%       Inputs:
%               par -   existing parameter structure
%               value -     the lengths to insert into the internode or internode segments
%
%                           the structure of `value' depends on the input to `internodeIdx' and `segmentIdx'
%                           In the following, the number is the possible input to `internodeIdx' and `segmentIdx' and
%                           the letters list the possible size for `value'.
%                           In brackets, whether the entries in `value'
%                           should refer to the total internode length or
%                           internode segment length, for each case.
%                           1.) `internodeIdx' and `segmentIdx' not defined or left empty:
%                               a.) scalar value                            [total internode length]
%                               b.) 1 x #internodes vector                  [total internode length]
%                               c.) 1 x (#internodes)*(#segments) vector    [internode segment length]
%                           2.) `internodeIdx' defined, `segmentIdx' not defined or left empty:
%                               a.) scalar value                            [total internode length]
%                               b.) 1 x length(internodeIdx) vector         [total internode length]
%                               c.) 1 x (length(internodeIdx))*(#segments) vector [internode segment length]
%                           3.) `internodeIdx' not defined or left empty, `segmentIdx' defined:
%                               a.) scalar value                            [internode segment length]
%                               b.) 1 x length(segmentIdx) vector           [internode segment length]
%                               c.) 1 x (#internodes)*(length(segmentIdx)) vector [internode segment length]
%                           4.) `internodeIdx' and `segmentIdx' defined:
%                               a.) scalar value                            [internode segment length]
%                               b.) 1 x (length(internodeIdx)) vector       [internode segment length]
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
%   Examples:
%
%       UpdateInternodeLength(par, 1)
%           set the total length of all internodes to 1.
%
%       UpdateInternodeLength(par, 1, 3)
%           set 3rd internode to have length 1.
%
%       UpdateInternodeLength(par, 1, [], 3)
%           set the 3rd segment of all internodes to have length 1.
%           (total length will be the sum of the segment lengths)
%
%       UpdateInternodeLength(par, [1, 2], [3, 4])
%           set the 3rd internode to have total length 1, and the 4th internode to have total length 2.
%
%       UpdateInternodeLength(par, [1, 2], [], [3, 4])
%           set 3rd segment in the all internodes to length 1, and 4th
%           segment in all internodes to length 2.
%
%       UpdateInternodeLength(par, [1, 2, 3, 4, 5, 6], [1, 1, 1, 5, 5, 5], [1, 3, 5, 2, 4, 6])
%           set the 1st, 3rd and 5th segment of the 1st internode to lengths 1, 2, and 3, respectively,
%           and the 2nd, 4th and 6th segment of the 5th internode to lengths 4, 5, and 6, respectively.
%

%%%%% CHECK INPUT VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial checks on inputs.
VariableDefault('internodeIdx', []);
VariableDefault('segmentIdx', []);
VariableDefault('myelinUpdate', 'max');

if CheckValue(internodeIdx, 'integer', [1, par.geo.nintn], 'emptyOK') || ...
        CheckValue(segmentIdx, 'integer', [1, par.geo.nintseg], 'emptyOK')
    error('Internode or segment indices out of acceptable range')
end

% If no internodes or segments have been passed to the function we assume
% the value is a total internode length, except if it is of length equal to
% the total number of internode segments along the axon.
if isempty(internodeIdx) && isempty(segmentIdx)
    if length(value) ~= par.geo.nintn * par.geo.nintseg
        value = value / par.geo.nintseg;
    end
end

% If internodes, but not segments, have been passed to the function, we
% assume the value is a total internode length, except if it is of length equal to
% the total number of segments in the specified internodes.
if ~isempty(internodeIdx) && isempty(segmentIdx)
    if length(value) ~= length(internodeIdx) * par.geo.nintseg
        value = value / par.geo.nintseg;
    end
end

% Otherwise we are assuming that because segments have been passed to the
% function, `value' refers to the length of a segment.

% Convert these indices into indices which we can use to update the
% internode matrix.
[value, internodeIdx2, segmentIdx2] = UpdateInternodeIndices(par, value, internodeIdx, segmentIdx);
%%%%% END CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx = sub2ind(size(par.intn.seg.geo.length.value.vec), internodeIdx2, segmentIdx2);
par.intn.seg.geo.length.value.vec(idx) = value;

% Reference and vector of internode length itself.
par.intn.geo.length.value.vec = sum(par.intn.seg.geo.length.value.vec, 2);
par.intn.geo.length.value.ref = mode(par.intn.geo.length.value.vec(:));

% Vector of internode segment lengths.
par.intn.seg.geo.length.value.ref           = mode(par.intn.seg.geo.length.value.vec(:));
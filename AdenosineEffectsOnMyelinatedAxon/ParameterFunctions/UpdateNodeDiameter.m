function par = UpdateNodeDiameter(par, value, nodeIdx, segmentIdx, myelinUpdate)
%%UPDATENODEDIAMETER
%   par = UPDATENODEDIAMETER(par, value, [nodeIdx], [segmentIdx], [myelinUpdate])
%       Outputs:
%               par -       modified parameter structure
%       Inputs:
%               par -       existing parameter structure
%               value -     the diameters to insert into the node segments
%
%                           the structure of `value' depends on the input to `nodeIdx' and `segmentIdx'
%                           In the following, the number is the possible input to `nodeIdx' and `segmentIdx' and
%                           the letters list the possible size for `value'.
%                           1.) `nodeIdx' and `segmentIdx' not defined or left empty:
%                               a.) scalar value
%                               b.) 1 x #nodes vector
%                               c.) 1 x (#nodes)*(#segments) vector
%                           2.) `nodeIdx' defined, `segmentIdx' not defined or left empty:
%                               a.) scalar value
%                               b.) 1 x length(nodeIdx) vector
%                               c.) 1 x (length(nodeIdx))*(#segments) vector
%                           3.) `nodeIdx' not defined or left empty, `segmentIdx' defined:
%                               a.) scalar value
%                               b.) 1 x length(segmentIdx) vector
%                               c.) 1 x (#nodes)*(length(segmentIdx)) vector
%                           4.) `nodeIdx' and `segmentIdx' defined:
%                               a.) scalar value
%                               b.) 1 x (length(nodeIdx)) vector
%
%               [nodeIdx] -  indices of the nodes in which to put `value'
%
%                               if empty or left out, `nodeIdx' will expand to *all* nodes.
%                               otherwise, 1xN vector of node numbers in which to put `value'
%                                   if `segmentIdx' is empty or not defined `nodeIdx' may simply list node numbers.
%                                   if `segmentIdx' is defined,
%                                   `nodeIdx' must be of the same size as `segmentIdx' and there may have to
%                                   be multiple repeats of the node number.
%
%               [segmentIdx] -  indices of the node segments in which to put `value'
%
%                               if empty or left out, `segmentIdx' will expand to *all* segments.
%                               otherwise, 1xN vector of segment numbers in which to put `value'
%
%               [myelinUpdate] - 'max' (default) or 'min'.  After updating the
%                               diameter, the function runs
%                               CalculateNumberOfMyelinLamellae. SEE UPDATE
%                               METHOD OF THAT FUNCTION FOR DETAILS.
%   Examples:
%
%       UpdateNodeDiameter(par, 1)
%           set all segments in all nodes to have diameter 1.
%
%       UpdateNodeDiameter(par, 1, 3)
%           set all segments in the 3rd node to have diameter 1.
%
%       UpdateNodeDiameter(par, 1, [], 3)
%           set the 3rd segment of all nodes to have diameter 1.
%
%       UpdateNodeDiameter(par, [1, 2], [3, 4])
%           set all segments in the 3rd node to diameter 1, and all
%           segments in the 4th node to diameter 2.
%
%       UpdateNodeDiameter(par, [1, 2], [], [3, 4])
%           set 3rd segment in the all nodes to diameter 1, and 4th
%           segment in all nodes to diameter 2.
%
%       UpdateNodeDiameter(par, [1, 2, 3, 4, 5, 6], [1, 1, 1, 5, 5, 5], [1, 3, 5, 2, 4, 6])
%           set the 1st, 3rd and 5th segment of the 1st node to 1, 2, and 3, respectively,
%           and the 2nd, 4th and 6th segment of the 5th node to 4, 5, and 6, respectively.
%

%%%%% CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial checks on inputs.
VariableDefault('nodeIdx', []);
VariableDefault('segmentIdx', []);
VariableDefault('myelinUpdate', 'max');

if CheckValue(nodeIdx, 'integer', [1, par.geo.nnode], 'emptyOK') || ...
        CheckValue(segmentIdx, 'integer', [1, par.geo.nnodeseg], 'emptyOK')
    error('Node or segment indices out of acceptable range')
end

% Convert these indices into indices which we can use to update the
% node matrix.
[value, nodeIdx2, segmentIdx2] = UpdateNodeIndices(par, value, nodeIdx, segmentIdx);
%%%%% END CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx = sub2ind(size(par.node.seg.geo.diam.value.vec), nodeIdx2, segmentIdx2);
par.node.seg.geo.diam.value.vec(idx) = value;

% Derive reference values from this.
par.node.seg.geo.diam.value.ref = mode(par.node.seg.geo.diam.value.vec(:));
par.node.geo.diam.value.vec = mode(par.node.seg.geo.diam.value.vec, 2);
par.node.geo.diam.value.ref = mode(par.node.geo.diam.value.vec);
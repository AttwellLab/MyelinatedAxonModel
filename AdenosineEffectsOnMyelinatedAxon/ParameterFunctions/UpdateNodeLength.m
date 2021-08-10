function par = UpdateNodeLength(par, value, nodeIdx, segmentIdx)
%%UPDATENODELENGTH
%   par = UPDATENODELENGTH(par, value, [nodeIdx], [segmentIdx])
%       Outputs:
%               par -   modified parameter structure
%       Inputs:
%               par -   existing parameter structure
%               value -     the lengths to insert into the node or node segments
%
%                           the structure of `value' depends on the input to `nodeIdx' and `segmentIdx'
%                           In the following, the number is the possible input to `nodeIdx' and `segmentIdx' and
%                           the letters list the possible size for `value'.
%                           In brackets, whether the entries in `value'
%                           should refer to the total node length or
%                           node segment length, for each case.
%                           1.) `nodeIdx' and `segmentIdx' not defined or left empty:
%                               a.) scalar value                            [total node length]
%                               b.) 1 x #nodes vector                  [total node length]
%                               c.) 1 x (#nodes)*(#segments) vector    [node segment length]
%                           2.) `nodeIdx' defined, `segmentIdx' not defined or left empty:
%                               a.) scalar value                            [total node length]
%                               b.) 1 x length(nodeIdx) vector         [total node length]
%                               c.) 1 x (length(nodeIdx))*(#segments) vector [node segment length]
%                           3.) `nodeIdx' not defined or left empty, `segmentIdx' defined:
%                               a.) scalar value                            [node segment length]
%                               b.) 1 x length(segmentIdx) vector           [node segment length]
%                               c.) 1 x (#nodes)*(length(segmentIdx)) vector [node segment length]
%                           4.) `nodeIdx' and `segmentIdx' defined:
%                               a.) scalar value                            [node segment length]
%                               b.) 1 x (length(nodeIdx)) vector       [node segment length]
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
%   Examples:
%
%       UpdateNodeLength(par, 1)
%           set the total length of all nodes to 1.
%
%       UpdateNodeLength(par, 1, 3)
%           set 3rd node to have length 1.
%
%       UpdateNodeLength(par, 1, [], 3)
%           set the 3rd segment of all nodes to have length 1.
%           (total length will be the sum of the segment lengths)
%
%       UpdateNodeLength(par, [1, 2], [3, 4])
%           set the 3rd node to have total length 1, and the 4th node to have total length 2.
%
%       UpdateNodeLength(par, [1, 2], [], [3, 4])
%           set 3rd segment in the all nodes to length 1, and 4th
%           segment in all nodes to length 2.
%
%       UpdateNodeLength(par, [1, 2, 3, 4, 5, 6], [1, 1, 1, 5, 5, 5], [1, 3, 5, 2, 4, 6])
%           set the 1st, 3rd and 5th segment of the 1st node to lengths 1, 2, and 3, respectively,
%           and the 2nd, 4th and 6th segment of the 5th node to lengths 4, 5, and 6, respectively.
%

%%%%% CHECK INPUT VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial checks on inputs.
VariableDefault('nodeIdx', []);
VariableDefault('segmentIdx', []);
VariableDefault('myelinUpdate', 'max');

if CheckValue(nodeIdx, 'integer', [1, par.geo.nnode], 'emptyOK') || ...
        CheckValue(segmentIdx, 'integer', [1, par.geo.nnodeseg], 'emptyOK')
    error('Node or segment indices out of acceptable range')
end

% If no nodes or segments have been passed to the function we assume
% the value is a total node length, except if it is of length equal to
% the total number of node segments along the axon.
if isempty(nodeIdx) && isempty(segmentIdx)
    if length(value) ~= par.geo.nnode * par.geo.nnodeseg
        value = value / par.geo.nnodeseg;
    end
end

% If nodes, but not segments, have been passed to the function, we
% assume the value is a total node length, except if it is of length equal to
% the total number of segments in the specified nodes.
if ~isempty(nodeIdx) && isempty(segmentIdx)
    if length(value) ~= length(nodeIdx) * par.geo.nnodeseg
        value = value / par.geo.nnodeseg;
    end
end

% Otherwise we are assuming that because segments have been passed to the
% function, `value' refers to the length of a segment.

% Convert these indices into indices which we can use to update the
% node matrix.
[value, nodeIdx2, segmentIdx2] = UpdateNodeIndices(par, value, nodeIdx, segmentIdx);
%%%%% END CHECK VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx = sub2ind(size(par.node.seg.geo.length.value.vec), nodeIdx2, segmentIdx2);
par.node.seg.geo.length.value.vec(idx) = value;

% Reference and vector of node length itself.
par.node.geo.length.value.vec = sum(par.node.seg.geo.length.value.vec, 2);
par.node.geo.length.value.ref = mode(par.node.geo.length.value.vec(:));

% Vector of node segment lengths.
par.node.seg.geo.length.value.ref           = mode(par.node.seg.geo.length.value.vec(:));
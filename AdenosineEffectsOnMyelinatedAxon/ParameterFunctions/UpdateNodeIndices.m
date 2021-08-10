function [value, nodeIdx2, segmentIdx2] = UpdateNodeIndices(par, value, nodeIdx, segmentIdx)
%UPDATENODEINDICES
%   UPDATENODEINDICES(par, value, nodeIdx, segmentIdx)
%   Helper function, not for direct use.
%       Aids in locating values to update to the correct location in the
%       nodes.

% When updating the values within node segments there are several
% options:

% 1. Update all segments, all nodes
% (par, val)    == (par, val, [], []) == (par, val, [])
% 	val - scalar
% 	val - par.nnode
% 	val - par.nnode * par.nnodeseg
% 
% 2. Update some nodes, all segments
% (par, val, nodes)  == (par, val, nodes, [])
% 	val - scalar
% 	val - length(nodes)
% 	val - length(nodes)*par.nnodeseg
% 
% 3. Update all nodes, some segments
% (par, val, [], segments)
% 	val - scalar
% 	val - length(segments)
% 	val - par.nnode * length(segments)
% 
% 4. Some nodes, some segments
% (par, val, nodes, segments)
% 	val - scalar
% 	val - length(nodes)

% Here we account for these possibilities.

% Case 1:   No user input into nodeIdx or segmentIdx
if isempty(nodeIdx) && isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, par.geo.nnode * par.geo.nnodeseg);
    elseif length(value) == par.geo.nnode
        value = reshape(repmat(value(:), 1, par.geo.nnodeseg), [], 1);
    elseif length(value) == par.geo.nnode * par.geo.nnodeseg
    else
        error('Value vector is incorrect length')
    end
    
    nodeIdx2 = reshape(repmat((1:par.geo.nnode)', 1, par.geo.nnodeseg), [], 1);
    segmentIdx2 = reshape(repmat((1:par.geo.nnodeseg), par.geo.nnode, 1), [], 1);
end


% Case 2:   input into nodeIdx, nothing to segmentIdx
if ~isempty(nodeIdx) && isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, length(nodeIdx) * par.geo.nnodeseg);
    elseif length(value) == length(nodeIdx)
        value = reshape(repmat(value(:), 1, par.geo.nnodeseg), [], 1);
    elseif length(value) == length(nodeIdx) * par.geo.nnodeseg
    else
        error('Value vector is incorrect length')
    end
    
    nodeIdx2 = reshape(repmat(nodeIdx(:), 1, par.geo.nnodeseg), [], 1);
    segmentIdx2 = reshape(repmat((1:par.geo.nnodeseg), length(nodeIdx), 1), [], 1);
end


% Case 3:   empty input to nodeIdx, input into segmentIdx
if isempty(nodeIdx) && ~isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, length(segmentIdx) * par.geo.nnode);
    elseif length(value) == length(segmentIdx)
        value = reshape(repmat(value(:)', par.geo.nnode, 1), [], 1);
    elseif length(value) == length(segmentIdx) * par.geo.nnode
    else
        error('Value vector is incorrect length')
    end
    
    nodeIdx2 = reshape(repmat((1:par.geo.nnode)', 1, length(segmentIdx)), [], 1);
    segmentIdx2 = reshape(repmat(segmentIdx(:)', par.geo.nnode, 1), [], 1);
end



% Case 4:   input to nodeIdx and segmentIdx
if ~isempty(nodeIdx) && ~isempty(segmentIdx)
    
    assert(length(nodeIdx) == length(segmentIdx), ...
        'Node and segment indices must match')
    
    if length(value) == 1
        value = value * ones(1, length(nodeIdx));
    elseif length(value) == length(nodeIdx)
    else
        error('Value vector is incorrect length')
    end
    
    nodeIdx2 = nodeIdx;
    segmentIdx2 = segmentIdx;
end
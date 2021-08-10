function [value, internodeIdx2, segmentIdx2] = UpdateInternodeIndices(par, value, internodeIdx, segmentIdx)
%UPDATEINTERNODEINDICES
%   UPDATEINTERNODEINDICES(par, value, internodeIdx, segmentIdx)
%   Helper function, not for direct use.
%       Aids in locating values to update to the correct location in the
%       internodes.

% When updating the values within internode segments there are several
% options:

% 1. Update all segments, all internodes
% (par, val)    == (par, val, [], []) == (par, val, [])
% 	val - scalar
% 	val - par.nintn
% 	val - par.nintn * par.nintseg
% 
% 2. Update some internodes, all segments
% (par, val, internodes)  == (par, val, internodes, [])
% 	val - scalar
% 	val - length(internodes)
% 	val - length(internodes)*par.nintseg
% 
% 3. Update all internodes, some segments
% (par, val, [], segments)
% 	val - scalar
% 	val - length(segments)
% 	val - par.nintn * length(segments)
% 
% 4. Some internodes, some segments
% (par, val, internodes, segments)
% 	val - scalar
% 	val - length(internodes)

% Here we account for these possibilities.

% Case 1:   No user input into internodeIdx or segmentIdx
if isempty(internodeIdx) && isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, par.geo.nintn * par.geo.nintseg);
    elseif length(value) == par.geo.nintn
        value = reshape(repmat(value(:), 1, par.geo.nintseg), [], 1);
    elseif length(value) == par.geo.nintn * par.geo.nintseg
    else
        error('Value vector is incorrect length')
    end
    
    internodeIdx2 = reshape(repmat((1:par.geo.nintn)', 1, par.geo.nintseg), [], 1);
    segmentIdx2 = reshape(repmat((1:par.geo.nintseg), par.geo.nintn, 1), [], 1);
end


% Case 2:   input into internodeIdx, nothing to segmentIdx
if ~isempty(internodeIdx) && isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, length(internodeIdx) * par.geo.nintseg);
    elseif length(value) == length(internodeIdx)
        value = reshape(repmat(value(:), 1, par.geo.nintseg), [], 1);
    elseif length(value) == length(internodeIdx) * par.geo.nintseg
    else
        error('Value vector is incorrect length')
    end
    
    internodeIdx2 = reshape(repmat(internodeIdx(:), 1, par.geo.nintseg), [], 1);
    segmentIdx2 = reshape(repmat((1:par.geo.nintseg), length(internodeIdx), 1), [], 1);
end


% Case 3:   empty input to internodeIdx, input into segmentIdx
if isempty(internodeIdx) && ~isempty(segmentIdx)
    if length(value) == 1
        value = value * ones(1, length(segmentIdx) * par.geo.nintn);
    elseif length(value) == length(segmentIdx)
        value = reshape(repmat(value(:)', par.geo.nintn, 1), [], 1);
    elseif length(value) == length(segmentIdx) * par.geo.nintn
    else
        error('Value vector is incorrect length')
    end
    
    internodeIdx2 = reshape(repmat((1:par.geo.nintn)', 1, length(segmentIdx)), [], 1);
    segmentIdx2 = reshape(repmat(segmentIdx(:)', par.geo.nintn, 1), [], 1);
end



% Case 4:   input to internodeIdx and segmentIdx
if ~isempty(internodeIdx) && ~isempty(segmentIdx)
    
    assert(length(internodeIdx) == length(segmentIdx), ...
        'Internode and segment indices must match')
    
    if length(value) == 1
        value = value * ones(1, length(internodeIdx));
    elseif length(value) == length(internodeIdx)
    else
        error('Value vector is incorrect length')
    end
    
    internodeIdx2 = internodeIdx;
    segmentIdx2 = segmentIdx;
end
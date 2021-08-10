function exitValue = CheckValue(value, condition, bounds, emptyInput)
%CHECKVALUE - checks whether a value, or vector of values, satisfies constraints.
%   status = CHECKVALUE(value, condition, [constraints], [emptyInput])
%       Outputs:
%           status - returns 1 upon failure - that is, variable doesn't
%                    satisfy constaints.
%                    returns 0 upon success (variable satisfies
%                    constraints).
%       Inputs:
%           value -         value, or vector of values, to be tested
%           condition -     'integer', 'real', or 'string'
%           [constraints] - if `condition' is 'integer' or 'real' then sets acceptable lower and upper
%                           limits of value. Must be of form [lower, upper] where lower <= upper.
%                           (default = [-inf, inf])
%                           if `condition' is 'string', then `constraints' should be a cell array
%                           containing acceptable strings (or just a single
%                           string). If `constraints' is empty, no constraints are placed on
%                           the string in `value' (default = empty array)
%           [emptyInput] -  'emptyOK' or 'emptyNOTOK'
%                           if set to 'emptyOK' empty arrays return success (0).
%                           otherwise an empty array returns a failure (1).
%                           (default = 'emptyNOTOK')

% Prepare the exit value.
exitValue = false;

% Check that `condition' is either 'integer' or 'string'.
if CheckCondition(condition);
    exitValue = true;
    fprintf('`condition'' must be either ''integer'' or ''string''\n'); beep;
    return
end



% Check bounds is correct for input type.
switch condition
    case {'integer', 'real'}
        VariableDefault('bounds', [-inf, inf]);
    case 'string'
        VariableDefault('bounds', {});
end
if CheckBounds(bounds, condition)
    exitValue = true;
    fprintf('`bounds'' is not specified correctly.\n'); beep;
    return
end



% Specify what to do with empty input
VariableDefault('emptyInput', 'emptyNOTOK');
if CheckEmptyInput(emptyInput)
    exitValue = true;
    fprintf('`emptyInput'' must be either ''emptyOK'' or ''emptyNOTOK''\n'); beep;
    return
end



% Deal with cell arrays here - they are never OK.
if iscell(value);
    exitValue = true;
    return;
end



% Deal with empty input here.
if isempty(value)
    if strcmp(emptyInput, 'emptyNOTOK')
        exitValue = true;
        return;
    else
        exitValue = false;
        return;
    end
end


% Finally check the value itself.
switch condition
    
    case 'integer'
        
        % Check the value is of type 'double', 'single' or 'integer'.
        % The other conditions don't remove strings.
        if any(~(isa(value, 'double') | isa(value, 'single') | isa(value, 'integer')))
            exitValue = true;
            return;
        end
        
        % Check vector of values are all integers, if not, return 1.
        % `rem' also removes inf and nans.
        if any(~(isreal(value) & rem(value, 1) == 0))
            exitValue = true;
            return;
        end
        
        % Check vector is within bounds.
        if any(value < bounds(1) | value > bounds(2))
            exitValue = true;
            return;
        end
        
    case 'real'
        
        % Check the value is of type 'double', 'single' or 'integer'.
        % The below doesn't remove strings!
        if any(~(isa(value, 'double') | isa(value, 'single') | isa(value, 'integer')))
            exitValue = true;
            return;
        end
        
        % Check vector of values are all reals, if not, return 1.
        if any(~(isreal(value)))
            exitValue = true;
            return;
        end
        
        % Check that there are no infs or nans :(
        if any(isinf(value) | isnan(value))
            exitValue = true;
            return;
        end
        
        % Check vector is within bounds (removes nan and inf's in value).
        if any(value < bounds(1) | value > bounds(2))
            exitValue = true;
            return;
        end
        
    case 'string'
        
        % If value is not a string, return 1.
        if ~ischar(value);
            exitValue = true;
            return;
        end
        
        % If no constraints, exit with return 0.
        if isempty(bounds)
            return;
        end
        
        % If constraints not satisfied, return 1.
        if ~any(strcmp(value, bounds));
            exitValue = true;
            return;
        end
end
end



function exitValue = CheckCondition(condition)

exitValue = true;

if iscell(condition); return; end
if ~any(strcmp(condition, {'integer', 'real', 'string'})); return; end

exitValue = false;
end



function exitValue = CheckBounds(bounds, condition)
% Checks the bounds input.

% Prepare the exit value.
exitValue = false;

switch condition
    
    case {'integer', 'real'}
        
        if length(bounds) ~= 2
            exitValue = true;
            return
        end
        
        if any(isnan(bounds) | ~isreal(bounds))
            exitValue = true;
            return
        end
        
        if bounds(2) < bounds(1)
            exitValue = true;
            return
        end
        
    case 'string'
        
        % If bounds is a cell array of strings, check each one is actually
        % a string, else check it is a string.
        if iscell(bounds)
            for bIdx = 1 : length(bounds)
                if ~ischar(bounds{bIdx})
                    exitValue = true;
                    return
                end
            end
        else
            if ~ischar(bounds)
                exitValue = true;
                return
            end
        end
end
end



function exitValue = CheckEmptyInput(emptyInput)

exitValue = true;

if iscell(emptyInput); return; end
if ~any(strcmp(emptyInput, {'emptyOK', 'emptyNOTOK'})); return; end

exitValue = false;
end
function vel=velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, dt, nodes, calcMethod, vcross)
%%
%VELOCITIES     Calculate velocity of AP propagation along myelinated axon.
% VELOCITIES(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR, nodes)
% 
%   MEMBRANE_POTENTIAL -    (TxN) matrix of voltage values (in mV), where T is number of sample points,
%                           and N is the number of nodes.
%   INTERNODE_LENGTH -      (1x(N-1)) vector indicating the length (in mm) of each
%                           of the N-1 internodes (measured centre of node to centre of node)
%   dt -                    time step (in ms) between each sample point.
%   nodes -                 (1x2) vector indicating between which of the N nodes to
%                           measure the conduction velocity
%
% NOTE: Uses the time between peaks of the APs.
%       Assumes the T sample points are evenly spaced.

VariableDefault('calcMethod', 'max');
VariableDefault('vcross', -40);

switch calcMethod
    case 'max'
        [~, idx] = max(MEMBRANE_POTENTIAL(:, nodes), [], 1);
    case 'dVdt'
        Vdiff = diff(MEMBRANE_POTENTIAL(:, nodes), 1, 1);
        [~, idx] = max([-inf, -inf; Vdiff], [], 1);
    case 'voltagecross'
        [~, idx] = max(MEMBRANE_POTENTIAL(:, nodes) > vcross, [], 1);
end
vel=sum(INTERNODE_LENGTH(nodes(1):(nodes(2)-1)))/(dt*(idx(2)-idx(1)));

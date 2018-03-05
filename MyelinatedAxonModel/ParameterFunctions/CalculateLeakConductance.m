function par = CalculateLeakConductance(par)
%CALCULATELEAKCONDUCTANCE - Calculate leak conductance of nodes.
%   par = CALCULATELEAKCONDUCTANCE(par)
%       Outputs:
%           par -           modified parameter structure
%       Inputs:
%           par -           parameter structure
%   
%   Calculates the leak conductance required to set the resting membrane
%   potential, given a collection of active conductances in the nodes.
%   
%   The `par' structure is updated within this function so all necessary
%   parameters must be set before it is called (including the desired leak
%   conductance units).

% Resting membrane potential
vrest = simunits(par.elec.pas.vrest.units) * par.elec.pas.vrest.value;

% Active conductances
actcond = cell(1, length(par.node.elec.act));
for i = 1 : length(par.node.elec.act)
    actcond{i} = simunits(par.node.elec.act(i).cond.units) * par.node.elec.act(i).cond.value.vec;
end

% Gating variable values at resting membrane potential.
gates = cell(1, length(par.node.elec.act));
for i = 1 : length(par.node.elec.act)
    gates{i} = cell(1, par.node.elec.act(i).gates.number);
    for j = 1 : par.node.elec.act(i).gates.number
        a = rateequation(vrest, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.alpha.q10(j), par.node.elec.act(i).gates.alpha.equ{j});
        b = rateequation(vrest, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.beta.q10(j), par.node.elec.act(i).gates.beta.equ{j});
        gates{i}{j}(1:par.geo.nnode, 1:par.geo.nnodeseg) = a/(a+b);
    end
end

% Sum of active channel currents at resting membrane potential.
activesum = zeros(par.geo.nnode, par.geo.nnodeseg);
for j = 1 : length(par.node.elec.act)
    tempprod = ones(par.geo.nnode, par.geo.nnodeseg);
    for k = 1 : par.node.elec.act(j).gates.number
        tempprod = tempprod.*(gates{j}{k}.^par.node.elec.act(j).gates.numbereach(k));
    end
    activesum = activesum + actcond{j} .* tempprod * (vrest - simunits(par.node.elec.act(j).erev.units) * par.node.elec.act(j).erev.value);
end

% Leak conductances to balance the active channel currents.
par.node.elec.pas.leak.cond.value.vec = ...
    -activesum * fromsimunits(par.node.elec.pas.leak.cond.units) ./ (vrest - simunits(par.node.elec.pas.leak.erev.units)*par.node.elec.pas.leak.erev.value.vec);
par.node.elec.pas.leak.cond.value.ref = mode(par.node.elec.pas.leak.cond.value.vec(:));
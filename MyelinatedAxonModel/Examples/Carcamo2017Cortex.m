% Replicate the cortex axon conduction velocity values from:
%   Arancibia-Carcamo I.L., Ford M.C., Cossell L., Ishida K., Tohyama K.,
%   Attwell D. (2017)
%   'Node of Ranvier length as a potential regulator of myelinated axon
%   conduction speed.' eLife
%
% This code takes about 20 minutes to run on 2015 MacBookPro
%   Results will be saved to `saveDirectory', using up about 75MB.
%   Results are then loaded to print out the changes in conduction velocity.


%%%%%%  CORTEX MYELINATED AXON SIMULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%

% Directory of this file
thisDirectory                               = fileparts(mfilename('fullpath'));

saveDirectory                               = fullfile(thisDirectory, 'Carcamo2017Results');
if ~isdir(saveDirectory)
    mkdir(saveDirectory)
end

defaultNodeLength                           = 1.50;
longNodeLength                              = 3.70;
peakNodeLength                              = 1.70;
shortNodeLength                             = 0.43;
matchCVNodeLength                           = 0.635;
gAct                                        = [30, 0.05, 0.8];
paranodePeriaxonalSpace                     = 0.012255632;
naDensityReductionPC                        = 34;
inodeLengthIncreasePC                       = 74;
PnodeLength                                 = 1.9;

% Produce parameters for default cortex model.
par                                         = Carcamo2017CortexAxon();

% Set the default node length. (This is already set in the
% Carcamo2017CortexAxon.m file, but reset here for clarity).
par.node.geo.length.value.vec(:)            = defaultNodeLength;

% Run the model.
fprintf('RUNNING MODEL 1 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017Cortex.mat'));




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% CHANGE NODE LENGTHS, KEEP CHANNEL DENSITY CONSTANT %%%%%%%%%%%%%%%%%

% Set the lengths of the nodes to a length close to the length giving a
% peak in CV (with channel density constant).
par.node.geo.length.value.vec(:)            = peakNodeLength;
par.node.seg.geo.length.value.vec           = repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 2 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexPeakNodeChanDensityConst.mat'));

% Set the lengths of the nodes to a length close to the shortest experimentally observed value.
par.node.geo.length.value.vec(:)            = shortNodeLength;
par.node.seg.geo.length.value.vec           = repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 3 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexShortNodeChanDensityConst.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% CHANGE NODE LENGTHS, KEEP CHANNEL NUMBER CONSTANT %%%%%%%%%%%%%%%%%%

% Set the lengths of the nodes to a length close to the longest experimentally observed value.
par.node.geo.length.value.vec(:)            = longNodeLength;
par.node.seg.geo.length.value.vec           = repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Keep channels constant in those nodes, requires updating the conductance
% density in each node for each active channel and the leak conductance.
for i = 1 : length(par.node.elec.act)
    par.node.elec.act(i).cond.value.ref = gAct(i) * (defaultNodeLength / longNodeLength);
    par.node.elec.act(i).cond.value.vec = par.node.elec.act(i).cond.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
end
par = CalculateLeakConductance(par);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 4 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexLongNodeChanConst.mat'));



% Set the lengths of the nodes to a length close to the longest experimentally observed value.
par.node.geo.length.value.vec(:)            = shortNodeLength;
par.node.seg.geo.length.value.vec           = repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Keep channels constant in those nodes, requires updating the conductance
% density in each node for each active channel and the leak conductance.
for i = 1 : length(par.node.elec.act)
    par.node.elec.act(i).cond.value.ref = gAct(i) * (defaultNodeLength / shortNodeLength);
    par.node.elec.act(i).cond.value.vec = par.node.elec.act(i).cond.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
end
par = CalculateLeakConductance(par);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 5 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexShortNodeChanConst.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% CHANGE NUMBER OF MYELIN WRAPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regenerate parameters for default cortex model.
par                                         = Carcamo2017CortexAxon();

% Change the resistance in the paranode periaxonal space, by modifying the width.
par.myel.geo.peri.value.vec(:, [1:2, end-1:end]) = paranodePeriaxonalSpace * par.myel.geo.numlamellae.value.ref / (par.myel.geo.numlamellae.value.ref - 1);

% Update the number of myelin wraps.
par.myel.geo.numlamellae.value.vec(:)       = par.myel.geo.numlamellae.value.ref - 1;

% Run the model with updated parameters.
fprintf('RUNNING MODEL 6 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexNWrapsReduced.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MATCH THIS CV CHANGE BY REDUCING NA CHANNEL DENSITY %%%%%%%%%%%%%%%%
% Regenerate parameters for default cortex model.
par                                         = Carcamo2017CortexAxon();

% Reduce the Na channel density by 34%
par.node.elec.act(1).cond.value.ref         = gAct(1) * (1-naDensityReductionPC/100);
par.node.elec.act(1).cond.value.vec         = par.node.elec.act(1).cond.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
% Update leak conductance to maintain resting membrane potential.
par                                         = CalculateLeakConductance(par);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 7 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexNaDensityReduced.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MATCH THIS CV CHANGE BY INCREASING THE INTERNODE LENGTH %%%%%%%%%%%%
% Regenerate parameters for default optic nerve model.
par                                         = Carcamo2017CortexAxon();

% Increase internode length by 74% 
% Need to be careful about the number of segments and paranode length- keep segment number approx. equal.
% Don't change the paranode length
% We want internode length to be as close to following value. 
desiredInternodeLength                      = par.intn.geo.length.value.ref * (1+inodeLengthIncreasePC/100);

% Number of segments occupying the paranode becomes
nPnodeSeg                                   = round(PnodeLength * par.geo.nintseg / desiredInternodeLength);

% Number of internode segments will become
nInternodeSeg                               = round(desiredInternodeLength * nPnodeSeg / PnodeLength);

% Internode Segment length will become
IntSegLength                                = PnodeLength / nPnodeSeg;

% Actual new internode length.
newInternodeLength                          = nInternodeSeg * IntSegLength;
par                                         = UpdateNumberOfInternodeSegments(par, nInternodeSeg);
par                                         = UpdateInternodeLength(par, newInternodeLength);

% Reset the paranode periaxonal space to their original value (gets changed in
% UpdateInternodeLength.m).
par = UpdateInternodePeriaxonalSpaceWidth(par, paranodePeriaxonalSpace, [], [1:nPnodeSeg, nInternodeSeg-(nPnodeSeg-1): nInternodeSeg], 'min');

% Run the model with updated parameters.
fprintf('RUNNING MODEL 8 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexInternodeLengthIncreased.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MATCH THIS CV CHANGE BY DECREASING THE THE NODE LENGTH %%%%%%%%%%%%%
% Regenerate parameters for default cortex model.
par                                         = Carcamo2017CortexAxon;

% Set the lengths of the nodes to a length close to the length giving a
% peak in CV (with channel density constant).
par.node.geo.length.value.vec(:)            = matchCVNodeLength;
par.node.seg.geo.length.value.vec           = repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Run the model with updated parameters.
fprintf('RUNNING MODEL 9 OF 9\n')
Model(par, fullfile(saveDirectory, 'Carcamo2017CortexCVMatchNodeLength.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PRINT OUT RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n\n\n\n\n\n')

load(fullfile(saveDirectory, 'Carcamo2017Cortex.mat'))
vel1 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex CV:  %.2f m/s\n', vel1);

load(fullfile(saveDirectory, 'Carcamo2017CortexLongNodeChanConst.mat'))
vel2 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex (node length 3.7um) CV:  %.2f m/s\n', vel2);
fprintf('       %.1f %% decrease\n', 100*(vel1-vel2)/vel1);

load(fullfile(saveDirectory, 'Carcamo2017CortexShortNodeChanConst.mat'))
vel3 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex (node length 0.43um) CV:  %.2f m/s\n', vel3);
fprintf('       %.1f %% increase\n', 100*(vel3-vel1)/vel1);
fprintf('       %.1f %% increase on long node\n', 100*(vel3-vel2)/vel2);

load(fullfile(saveDirectory, 'Carcamo2017CortexShortNodeChanDensityConst.mat'))
vel4 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex (node length 0.43um, channel density constant) CV:  %.2f m/s\n', vel4);
fprintf('       %.1f %% decrease\n', 100*(vel1-vel4)/vel1);

load(fullfile(saveDirectory, 'Carcamo2017CortexPeakNodeChanDensityConst.mat'))
vel5 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex (node length 1.7um, channel density constant) CV:  %.2f m/s\n', vel5);
fprintf('       %.1f %% increase\n', 100*(vel5-vel1)/vel1);
fprintf('       %.1f %% increase on short node\n', 100*(vel5-vel4)/vel4);

load(fullfile(saveDirectory, 'Carcamo2017CortexNWrapsReduced.mat'))
vel6 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);
fprintf('Cortex (4 myelin wraps) CV:  %.2f m/s\n', vel6);
fprintf('       %.1f %% decrease\n', 100*(vel1-vel6)/vel1);

load(fullfile(saveDirectory, 'Carcamo2017CortexNaDensityReduced.mat'))
vel7 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);

load(fullfile(saveDirectory, 'Carcamo2017CortexInternodeLengthIncreased.mat'))
vel8 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);

load(fullfile(saveDirectory, 'Carcamo2017CortexCVMatchNodeLength.mat'))
vel9 = velocities(MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR(2)-TIME_VECTOR(1), [20, 30]);

fprintf('\n\n\n')
fprintf('Cortex (4 myelin wraps) CV:                  %.2f m/s\n', vel6);
fprintf('Cortex (Na density reduced 34%%) CV:         %.2f m/s\n', vel7);
fprintf('Cortex (internode length increase 74%%) CV:  %.2f m/s\n', vel8);
fprintf('Cortex (node length 0.635um) CV:             %.2f m/s\n', vel9);
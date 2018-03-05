function par = Carcamo2017OpticNerveAxon()

% Initialize all parameters.
par =                                                                   GenerateEmptyParameterStructure();

% Simulation parameters
par.sim.temp =                                                          37;
par.sim.dt.value =                                                      0.1;
par.sim.dt.units =                                                      {1, 'us', 1};
par.sim.tmax.value =                                                    3;
par.sim.tmax.units =                                                    {1, 'ms', 1};

% Current stimulation
% Stimulation amplitude.
par.stim.amp.value =                                                    3;
par.stim.amp.units =                                                    {1, 'nA', 1};
% Stimulation duration.
par.stim.dur.value =                                                    10;
par.stim.dur.units =                                                    {1, 'us', 1};

% Number of nodes.
par.geo.nnode =                                                         51;
% Number of internodes.
par.geo.nintn =                                                         par.geo.nnode - 1;
% Number of segments per node.
par.geo.nnodeseg =                                                      1;
% Number of segments per internode.
par.geo.nintseg =                                                       66;

% Node geometry
% Node diameter.
par.node.geo.diam.value.ref =                                           0.7274;
par.node.geo.diam.value.vec =                                           par.node.geo.diam.value.ref * ones(par.geo.nnode, 1);
par.node.geo.diam.units =                                               {1, 'um', 1};

% Node length.
par.node.geo.length.value.ref =                                         1.02;
par.node.geo.length.value.vec =                                         par.node.geo.length.value.ref * ones(par.geo.nnode, 1);
par.node.geo.length.units =                                             {1, 'um', 1};

% Node segment diameter.
par.node.seg.geo.diam.value.ref =                                       par.node.geo.diam.value.ref;
par.node.seg.geo.diam.value.vec =                                       repmat(par.node.geo.diam.value.vec, 1, par.geo.nnodeseg);

% Node segment length.
par.node.seg.geo.length.value.ref =                                     par.node.geo.length.value.ref;
par.node.seg.geo.length.value.vec =                                     repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);

% Internode geometry
% Internode axon diameter.
par.intn.geo.diam.value.ref =                                           0.8201;
par.intn.geo.diam.value.vec =                                           par.intn.geo.diam.value.ref * ones(par.geo.nintn, 1);
par.intn.geo.diam.units =                                               {1, 'um', 1};
% Internode length.
par.intn.geo.length.value.ref =                                         139.26;
par.intn.geo.length.value.vec =                                         par.intn.geo.length.value.ref * ones(par.geo.nintn, 1);
par.intn.geo.length.units=                                              {1, 'um', 1};
% Internode segment length.
par.intn.seg.geo.length.value.ref =                                     par.intn.geo.length.value.ref / par.geo.nintseg;
par.intn.seg.geo.length.value.vec =                                     repmat(par.intn.geo.length.value.vec / par.geo.nintseg, 1, par.geo.nintseg);
par.intn.seg.geo.length.units =                                         {1, 'um', 1};
% Internode segment diameter (=internode diameter).
par.intn.seg.geo.diam.value.ref =                                       par.intn.geo.diam.value.ref;
par.intn.seg.geo.diam.value.vec =                                       repmat(par.intn.geo.diam.value.vec, 1, par.geo.nintseg);
par.intn.seg.geo.diam.units =                                           {1, 'um', 1};

% General electrical
% Resting membrane potential.
par.elec.pas.vrest.value =                                              -82;
par.elec.pas.vrest.units =                                              {1, 'mV', 1};


% Node leak reversal potential.
par.node.elec.pas.leak.erev.value.ref =                                 -83.381371999999999;
par.node.elec.pas.leak.erev.value.vec =                                 par.node.elec.pas.leak.erev.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
par.node.elec.pas.leak.erev.units =                                     {1, 'mV', 1};

% Node leak conductance - adjusted to set resting membrane potential.
par.node.elec.pas.leak.cond.units =                                     {2, 'mS', 'mm', [1, -2]};

fileStr = {'Richardson2000FastNa.mat', 'Richardson2000PersistentNa.mat', 'Richardson2000SlowK.mat'};
for fileIdx = 1 : length(fileStr)
    par =                                                               AddActiveChannel(par, fileStr{fileIdx});
end
par =                                                                   CalculateLeakConductance(par);

% Node axial resistivity.
par.node.elec.pas.axres.value =                                         0.7;
par.node.elec.pas.axres.units =                                         {2, ' O', ' m', [1, 1]};

% Node membrane capacitance.
par.node.elec.pas.cap.value =                                           0.9;
par.node.elec.pas.cap.units =                                           {2, 'uF', 'cm', [1, -2]};

% Myelin membrane capacitance.
par.myel.elec.pas.cap.value =                                           0.9;
par.myel.elec.pas.cap.units =                                           {2, 'uF', 'cm', [1, -2]};

% Myelin membrane conductance.
par.myel.elec.pas.cond.value =                                          1;
par.myel.elec.pas.cond.units =                                          {2, 'mS', 'cm', [1, -2]};

% Internode axon membrane capacitance.
par.intn.elec.pas.cap.value =                                           0.9;
par.intn.elec.pas.cap.units =                                           {2, 'uF', 'cm', [1, -2]};

% Internode axon membrane conductance.
par.intn.elec.pas.cond.value =                                          0.1;
par.intn.elec.pas.cond.units =                                          {2, 'mS', 'cm', [1, -2]}; 

% Periaxonal space resistivity.
par.myel.elec.pas.peri.axres.value =                                    0.7;
par.myel.elec.pas.peri.axres.units =                                    {2, ' O', ' m', [1, 1]};

% Periaxonal space width.
par.myel.geo.peri.value.ref =                                           15;
par.myel.geo.peri.value.vec =                                           par.myel.geo.peri.value.ref * ones(par.geo.nintn,par.geo.nintseg);
par.myel.geo.peri.units =                                               {1, 'nm', 1};

% Myelin wrap periodicity.
par.myel.geo.period.value =                                             15.6;
par.myel.geo.period.units =                                             {1, 'nm', 1};

% g-ratio (internode axon diameter to internode outer diameter ratio)
par.myel.geo.gratio.value.ref =                                         0.79;
par.myel.geo.gratio.value.vec_ref =                                     par.myel.geo.gratio.value.ref * ones(par.geo.nintn, par.geo.nintseg);

% Set units of myelin width.
par.myel.geo.width.units =                                              {1, 'um', 1};

% Update number of myelin lamellae in separate function
par =                                                                   CalculateNumberOfMyelinLamellae(par, 'max');

% Restrict periaxonal space around the paranodes.
% We need to use 'min' to update the number of myelin lamellae, as reducing
% the periaxonal space increases the number of layers in the paranodes.
% See CALCULATENUMBEROFMYELINLAMELLAE.m for details.
par =                                                                   UpdateInternodePeriaxonalSpaceWidth(par, 0.007719692, [], [1, 66], 'min');
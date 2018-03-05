function par = GenerateEmptyParameterStructure()

% Simulation parameters
par.sim.temp =                           	[];
par.sim.dt.value =                          [];
par.sim.dt.units =                          [];
par.sim.tmax.value =                        [];
par.sim.tmax.units =                       	[];

% Current stimulation
% Stimulation amplitude.
par.stim.amp.value =                        [];
par.stim.amp.units =                        [];
% Stimulation duration.
par.stim.dur.value =                        [];
par.stim.dur.units =                        [];

% Number of nodes.
par.geo.nnode =                             [];
% Number of internodes.
par.geo.nintn =                             [];
% Number of segments per node.
par.geo.nnodeseg =                          [];
% Number of segments per internode.
par.geo.nintseg =                           [];

% Node geometry
% Node diameter.
par.node.geo.diam.value.ref =               [];
par.node.geo.diam.value.vec =               [];
par.node.geo.diam.units =                   [];

% Node length.
par.node.geo.length.value.ref =             [];
par.node.geo.length.value.vec =             [];
par.node.geo.length.units =                 [];

% Node segment diameter.
par.node.seg.geo.diam.value.ref =           [];
par.node.seg.geo.diam.value.vec =           [];

% Node segment length.
par.node.seg.geo.length.value.ref =         [];
par.node.seg.geo.length.value.vec =         [];

% Internode geometry
% Internode axon diameter.
par.intn.geo.diam.value.ref =               [];
par.intn.geo.diam.value.vec =               [];
par.intn.geo.diam.units =                   [];
% Internode length.
par.intn.geo.length.value.ref =             [];
par.intn.geo.length.value.vec =             [];
par.intn.geo.length.units=                  [];
% Internode segment length.
par.intn.seg.geo.length.value.ref =         [];
par.intn.seg.geo.length.value.vec =         [];
par.intn.seg.geo.length.units =             [];
% Internode segment diameter (=internode diameter).
par.intn.seg.geo.diam.value.ref =           [];
par.intn.seg.geo.diam.value.vec =           [];
par.intn.seg.geo.diam.units =               [];

% General electrical
% Resting membrane potential.
par.elec.pas.vrest.value =                  [];
par.elec.pas.vrest.units =                  [];


% Node leak reversal potential.
par.node.elec.pas.leak.erev.value.ref =     [];
par.node.elec.pas.leak.erev.value.vec =     [];
par.node.elec.pas.leak.erev.units =         [];

% Node leak conductance - adjusted to set resting membrane potential.
par.node.elec.pas.leak.cond.value.ref =     [];
par.node.elec.pas.leak.cond.value.vec =     [];
par.node.elec.pas.leak.cond.units =         [];

% Active conductances in nodes.
par.node.elec.act.channames =               [];
par.node.elec.act.cond.value.ref =          [];
par.node.elec.act.cond.value.vec =          [];
par.node.elec.act.cond.units =              [];
par.node.elec.act.erev.value =              [];
par.node.elec.act.erev.units =              [];
par.node.elec.act.gates.temp =              [];
par.node.elec.act.gates.number =            [];
par.node.elec.act.gates.label =             [];
par.node.elec.act.gates.numbereach =        [];
par.node.elec.act.gates.alpha.q10 =         [];
par.node.elec.act.gates.beta.q10 =          [];
par.node.elec.act.gates.alpha.equ =         [];
par.node.elec.act.gates.beta.equ =          [];
par.node.elec.act(1) =                      [];

% Node axial resistivity.
par.node.elec.pas.axres.value =             [];
par.node.elec.pas.axres.units =             [];

% Node membrane capacitance.
par.node.elec.pas.cap.value =               [];
par.node.elec.pas.cap.units =               [];

% Myelin membrane capacitance.
par.myel.elec.pas.cap.value =               [];
par.myel.elec.pas.cap.units =               [];

% Myelin membrane conductance.
par.myel.elec.pas.cond.value =              [];
par.myel.elec.pas.cond.units =              [];

% Internode axon membrane capacitance.
par.intn.elec.pas.cap.value =               [];
par.intn.elec.pas.cap.units =               [];

% Internode axon membrane conductance.
par.intn.elec.pas.cond.value =              [];
par.intn.elec.pas.cond.units =              []; 

% Periaxonal space resistivity.
par.myel.elec.pas.peri.axres.value =        [];
par.myel.elec.pas.peri.axres.units =        [];

% Periaxonal space width.
par.myel.geo.peri.value.ref =               [];
par.myel.geo.peri.value.vec =               [];
par.myel.geo.peri.units =                   [];

% Myelin wrap periodicity.
par.myel.geo.period.value =                 [];
par.myel.geo.period.units =                 [];

% g-ratio (internode axon diameter to internode outer diameter ratio)
par.myel.geo.gratio.value.ref =             [];
par.myel.geo.gratio.value.vec_ref =         [];
par.myel.geo.gratio.value.vec =             [];

% Set units of myelin width.
par.myel.geo.width.value.ref =              [];
par.myel.geo.width.value.vec =              [];
par.myel.geo.width.units =                  [];

% Number of myelin lamellae
par.myel.geo.numlamellae.value.ref =        [];
par.myel.geo.numlamellae.value.vec =        [];
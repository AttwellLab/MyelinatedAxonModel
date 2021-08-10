function [MEMBRANE_POTENTIAL, INTERNODE_LENGTH, TIME_VECTOR] = Model_DELAY(par, fileName, isVerbose)
%%MODEL - run myelinated axon model
%   [membrane potential, internode length, time] = MODEL(par, filename, verbose)
%       Outputs:
%           membrane potential -        (TxN)-array, where T is the number of time points simulated and N is
%                                       the number of node segments in the simulation, giving membrane potential 
%                                       (in mV) of each node segment.
%           internode length -          (1x(N-1))-array giving the length (in mm) of each of the (N-1) internodes.
%           time -                      (1xT)-array, where T is the number of time points simulated giving the 
%                                       the simulation time (in ms) of each sample point.
%
%       Inputs:
%           par -                       structure containing the parameters of the myelinated axon.
%           filename -                  a string containing an absolute path indicating a filename in
%                                       which to save the membrane potential, internode length and
%                                       time vector. If left empty (default), nothing will be saved.
%           verbose -                   if 1 (default) will print progress of simulation. Otherwise, if 0
%                                       (false) there will be no output.


% Check argument input.
VariableDefault('fileName', [])
if CheckValue(fileName, 'string', [], 'emptyOK')
    error('`fileName'' must be a string');
end

VariableDefault('isVerbose', true)

% Simulation parameters:
% Time step, total amount of time, number of time points.
dt = simunits(par.sim.dt.units) * par.sim.dt.value;
tmax = simunits(par.sim.tmax.units) * par.sim.tmax.value;
T = round(tmax / dt);

% Current stimulation.
Is = simunits(par.stim.amp.units) * par.stim.amp.value;
dur = simunits(par.stim.dur.units) * par.stim.dur.value;
DUR = ceil(dur / dt);
del = simunits(par.stim.delay.units) * par.stim.delay.value;
DELAY = (ceil(del / dt))+1;


% Number of nodes, internodes, internode segments.
nis = par.geo.nintseg;
nns = par.geo.nnodeseg; %%
nintn = par.geo.nintn;
nnodes = par.geo.nnode;
tns = (nis * nintn) + (nns * nnodes);
tnf = tns - 1;


% Indices along axon of nodes and internodes.
% Indices of connections node-to-internode, internode-to-node and
% internode-to-internode.
nodes = reshape(bsxfun(@plus, (1:nns)', (0:nnodes-1)*(nns+nis)), 1, []);
intn = 1 : tns;
intn(nodes) = [];
node2node = reshape(bsxfun(@plus, (1:(nns-1))', (0:nnodes-1)*(nns+nis)), 1, []);
node2intn = nns:(nns+nis):tnf;
intn2node = (nns+nis):(nns+nis):tnf;
intn2intn = 1 : tnf;
intn2intn([node2node, node2intn, intn2node]) = [];

% Inject current into first node for now.
Istim = zeros(tns, 2, T);
Istim(1:nns, 1, DELAY:DELAY+DUR) = Is/nns;


%%%%%%%%%%% GEOMETRY OF THE AXON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Periaxonal space width.
PERIAXONAL_SPACE = simunits(par.myel.geo.peri.units) * par.myel.geo.peri.value.vec;

% Node and internode radius.
RADIUS_NODE = simunits(par.node.geo.diam.units)*par.node.seg.geo.diam.value.vec/2;
RADIUS_INODE = simunits(par.intn.seg.geo.diam.units)*par.intn.seg.geo.diam.value.vec/2;

% Myelin radius (and number of lamellae/myelin wrap periodicity)
NUMBER_LAMELLAE = par.myel.geo.numlamellae.value.vec;
PERIODICITY = simunits(par.myel.geo.period.units)*par.myel.geo.period.value;
RADIUS_MYELIN = cell(1,nintn);
for i=1:nintn
    RADIUS_MYELIN{i} = repmat(RADIUS_INODE(i,:),2*NUMBER_LAMELLAE(i,1),1)...
                        +repmat(PERIAXONAL_SPACE(i,:),2*NUMBER_LAMELLAE(i,1),1)...
                        +repmat(((1:2*NUMBER_LAMELLAE(i))'-1)*(PERIODICITY/2),1,nis);
end

% Node and internode length
LENGTH_NODE = simunits(par.node.geo.length.units)*par.node.seg.geo.length.value.vec;                        % nnodex1 vec
LENGTH_INODE = simunits(par.intn.seg.geo.length.units)*par.intn.seg.geo.length.value.vec;               % nintnxnintseg mat
INTERNODE_LENGTH = simunits(par.intn.geo.length.units)*par.intn.geo.length.value.vec + ...     
                    (1/2)*simunits(par.node.geo.length.units)*par.node.geo.length.value.vec(1:end-1) + ...
                    (1/2)*simunits(par.node.geo.length.units)*par.node.geo.length.value.vec(2:end);                              % nintnx1 vec

% Node, internode and myelin membrane surface areas.
SURFACEAREA_NODE = 2*pi*RADIUS_NODE.*LENGTH_NODE;                                                       % nnodex1 vec
SURFACEAREA_INODE = 2*pi*RADIUS_INODE.*LENGTH_INODE;                                                    % nintnxnintseg mat
SURFACEAREA_MYELIN=cell(1,nintn);
for i=1:nintn
    SURFACEAREA_MYELIN{i} = 2*pi*RADIUS_MYELIN{i}.*repmat(LENGTH_INODE(i,:),2*NUMBER_LAMELLAE(i,1),1);  % nlamxnintseg mat
end

% Cross-sectional area of node and internode axon and periaxonal space.
AREA_NODE = pi*RADIUS_NODE.^2;                                                                          % nnodex1 vec
AREA_INODE = pi*RADIUS_INODE.^2;                                                                        % nintnxnintseg mat
AREA_PERI = pi*((RADIUS_INODE+PERIAXONAL_SPACE).^2-RADIUS_INODE.^2); % nintnxnintseg mat



%%%%%%%%%%% ELECTRICAL PROPERTIES OF THE AXON %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Capacitance of each segment of node, internode and myelin membrane.
C_NODE = simunits(par.node.elec.pas.cap.units)*par.node.elec.pas.cap.value*SURFACEAREA_NODE;            % nnodex1 vec
CI_INODE = simunits(par.intn.elec.pas.cap.units)*par.intn.elec.pas.cap.value*SURFACEAREA_INODE;         % nintnxnintseg mat
Cmy_INODE=cell(1,nintn);
CMY_INODE=zeros(nintn,nis);
for i=1:nintn
    Cmy_INODE{i} = simunits(par.myel.elec.pas.cap.units)*par.myel.elec.pas.cap.value*SURFACEAREA_MYELIN{i}; % nlamxnintseg mat
    CMY_INODE(i,:) = 1./(sum(1./Cmy_INODE{i},1));                                                       % nintnxnintseg mat
end   

% Leak conductance of each segment of node, internode and myelin membrane.
LEAK_NODE = simunits(par.node.elec.pas.leak.cond.units)*par.node.elec.pas.leak.cond.value.vec.*SURFACEAREA_NODE;    % nnodex1 vec
LEAKI_INODE = simunits(par.intn.elec.pas.cond.units)*par.intn.elec.pas.cond.value*SURFACEAREA_INODE;                % nintnxnintseg mat
LEAKmy_INODE=cell(1,nintn);
LEAKMY_INODE=zeros(nintn,nis);
for i=1:nintn
    LEAKmy_INODE{i} = simunits(par.myel.elec.pas.cond.units)*par.myel.elec.pas.cond.value*SURFACEAREA_MYELIN{i};    % nlamxnintn mat
    LEAKMY_INODE(i,:) = 1./(sum(1./LEAKmy_INODE{i},1));                                                             % nintnxnintseg mat
end


% Active conductances for each segment of the node.
actcond=cell(1,length(par.node.elec.act));
for i=1:length(par.node.elec.act)
    actcond{i}=simunits(par.node.elec.act(i).cond.units)*par.node.elec.act(i).cond.value.vec.*SURFACEAREA_NODE;
    actcond{i} = reshape(actcond{i}', [], 1);
end

% Longitidunal resistance of each segment of the axon for main axon
% and periaxonal space.
RaxNODE = simunits(par.node.elec.pas.axres.units)*par.node.elec.pas.axres.value*LENGTH_NODE./AREA_NODE;
RaxINODE = simunits(par.node.elec.pas.axres.units)*par.node.elec.pas.axres.value*LENGTH_INODE./AREA_INODE;   % vec
RpINODE = simunits(par.myel.elec.pas.peri.axres.units)*par.myel.elec.pas.peri.axres.value*LENGTH_INODE./AREA_PERI;   % vec


cap=zeros(tns,2);
cap(nodes,1)=reshape(C_NODE', nns*nnodes, 1);
cap(intn,:)=[reshape(CI_INODE',nis*nintn,1),reshape(CMY_INODE',nis*nintn,1)];

leak=zeros(tns,2);
leak(nodes,1)=reshape(LEAK_NODE', nns*nnodes, 1);
leak(intn,:)=[reshape(LEAKI_INODE',nis*nintn,1),reshape(LEAKMY_INODE',nis*nintn,1)];


vrest = simunits(par.elec.pas.vrest.units)*par.elec.pas.vrest.value;

ELN = simunits(par.node.elec.pas.leak.erev.units)*par.node.elec.pas.leak.erev.value.vec;
ELI = vrest;

erev=zeros(tns,1);
erev(nodes)=reshape(ELN', nns*nnodes, 1);
erev(intn)=ELI;

Raxial=zeros(tnf,2);
Raxial(node2intn,2)=RpINODE(:,1)/2;
Raxial(intn2node,2)=RpINODE(:,nis)/2;
Raxial(intn2intn,2)=reshape(((RpINODE(:,2:end)+RpINODE(:,1:end-1))/2)',nintn*(nis-1),1);
Raxial(intn2intn,1)=reshape(((RaxINODE(:,2:end)+RaxINODE(:,1:end-1))/2)',nintn*(nis-1),1);

Raxial(node2intn,1)=RaxNODE(1:end-1,end)/2+RaxINODE(:,1)/2;
Raxial(intn2node,1)=RaxNODE(2:end,1)/2+RaxINODE(:,end)/2;
Raxial(node2node,1)=reshape((RaxNODE(:, 1:end-1)/2+RaxNODE(:, 2:end)/2)', nnodes*(nns-1), 1);


%%%%%%%%%%% ACTIVE COMPONENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the gating variables.
gates=cell(1,length(par.node.elec.act));
for i=1:length(par.node.elec.act)
    gates{i}=cell(1,par.node.elec.act(i).gates.number);
    for j=1:par.node.elec.act(i).gates.number
        a = rateequation(vrest, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.alpha.q10(j), par.node.elec.act(i).gates.alpha.equ{j});
        b = rateequation(vrest, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.beta.q10(j), par.node.elec.act(i).gates.beta.equ{j});
        gates{i}{j}(1:nns*nnodes, 1) = a/(a+b);
    end
end


% Update the gating variables on each iteration of the main loop using the
% method of Hines (1984) Int J Biomed Comput. We create a lookup table of 'gamma' and 'delta'
% values for each voltage value, then can quickly update the gating
% variables using these lookup tables using:
%       g(t+1) = gamma(V) + delta(V)*g(t).

Vlowerlimit     = -200;
Vupperlimit     = 200;
Vstep           = 0.01;
V               = (Vlowerlimit:Vstep:Vupperlimit)';
gridsize        = length(V);


gamma=cell(1,length(par.node.elec.act));
delta=cell(1,length(par.node.elec.act));
for i=1:length(par.node.elec.act)
    gamma{i}=cell(1,par.node.elec.act(i).gates.number);
    delta{i}=cell(1,par.node.elec.act(i).gates.number);
    for j=1:par.node.elec.act(i).gates.number
        a = rateequation(V, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.alpha.q10(j), par.node.elec.act(i).gates.alpha.equ{j});
        b = rateequation(V, par.sim.temp, par.node.elec.act(i).gates.temp, par.node.elec.act(i).gates.beta.q10(j), par.node.elec.act(i).gates.beta.equ{j});
        gamma{i}{j}=a./(1/dt+(1/2)*(a+b));
        delta{i}{j}=(1/dt-(1/2)*(a+b))./(1/dt+(1/2)*(a+b));
    end
end

if isempty(par.node.elec.act)
    gamma{1}{1}=zeros(1,gridsize);
    delta{1}{1}=zeros(1,gridsize);
end


% Just simplify notation for the active channel reversal potentials and
% power with which to raise the gate.
erevval = nan(length(par.node.elec.act), 1);
for j=1:length(par.node.elec.act)
    for k=1:par.node.elec.act(j).gates.number
        numgates(j, k)=par.node.elec.act(j).gates.numbereach(k); %#ok<AGROW>
    end
    erevval(j)=par.node.elec.act(j).erev.value;
end



% -------------------------- CREATE "A" MATRIX ------------------------- %
% Form of equations for voltage update at each time-step is:
%   A*V(t+1) = B*V(t)                       (*)
% Thus, solution to (*) is V(t+1) = A\(B*V(t))
% Here, we calculate the coefficients of the matrix A (the coefficients
% derived from the passive components of the axon - the active components
% need to be updated on each time step).
leakpad                                     = [zeros(tns, 1), leak];
cappad                                      = [zeros(tns, 1), cap];

Radial                                      = sum(cat(3,cappad,cappad(:,[2 3 1])),3)/dt + sum(cat(3,leakpad,leakpad(:,[2 3 1])),3)/2;
Radial                                      = Radial(:,1:end-1);

Gaxialpad                                   = [[0, 0]; 1./(2*Raxial); [0, 0]];
Longitudinal                                = Gaxialpad(1:end-1,:)+Gaxialpad(2:end,:);

Total                                       = Radial + Longitudinal;
Total(nodes, 2)                             = ones(length(nodes), 1);
Total(Total == Inf)                         = 1;

Longitudinal2                               = -1./(2*Raxial);
Longitudinal2([node2node, node2intn, intn2node],2) = 0;

Radial2                                     = -(cap(:,1)/dt+leak(:,1)/2);
Radial2(nodes)                              = 0;

d                                           = [-tns -1 0 1 tns];
B                                           = [[Radial2;zeros(tns,1)],...
                                                reshape([Longitudinal2;[0,0]],2*tns,1),...
                                                reshape(Total,2*tns,1),...
                                                reshape([[0,0];Longitudinal2],2*tns,1),...
                                                [zeros(tns,1);Radial2]];

A                                           = spdiags(B, d, 2*tns, 2*tns);

% Indices of the active segments (nodes), which need to be updated on each
% time-step.
L                                           = sub2ind(size(A), nodes, nodes);
offset                                      = A(L);

% -------------------------- End A Matrix ----------------------------- %


Radialpre                                   = (cappad/dt - leakpad/2);
Radialpre(isnan(Radialpre))                 = 0;
Leakpre                                     = [leak(:, 1).*erev, -leak(:, 1).*erev];


activesum                                   = zeros(nns*nnodes, 1);
activesum2                                  = zeros(nns*nnodes, 1);
tempprod                                    = ones(nns*nnodes, 1);

V1                                          = vrest * repmat([1, 0], tns, 1);
V2                                          = [zeros(tns+2, 1), [[0, 0]; reshape(V1, tns, 2); [0, 0]], zeros(tns+2, 1)];
Vsave                                       = nan(T+1, nns*nnodes);
Vsave(1, :)                                 = V1(nodes);


if isVerbose
    updatemessage = (0:0.05:1);
    printmessage = round(T * updatemessage);
    fprintf('Running...  0%% complete'); tic;
end


% ---------------------------- MAIN ----------------------------------- %

for i = 1 : T
    
    if isVerbose
        if any(i==printmessage)
            fprintf(repmat('\b', 1, length('100% complete')));
            fprintf('%3.0f%% complete', 100*(i/T))
        end
    end
    
    % Find indices of the gamma and delta tables.
    % Check that we are not outside the allowable range.
    tableIdx = round((V2(nodes+1, 2) - Vlowerlimit) * (1 / Vstep)) + 1;
    if any(tableIdx > gridsize)
        disp('Too much stimulation: reduce stimulation')
        break
    end
    
    % Update the gating variables.
    for j = 1 : length(par.node.elec.act)
        for k = 1 : par.node.elec.act(j).gates.number
            gates{j}{k} = gamma{j}{k}(tableIdx) + delta{j}{k}(tableIdx) .* gates{j}{k};
        end
    end
    
    % Components to add to the A matrix and RHS of equation (*)
    activesum(:) = 0;
    activesum2(:) = 0;
    for j = 1 : length(par.node.elec.act)
        tempprod(:) = 1;
        for k = 1 : par.node.elec.act(j).gates.number
            tempprod = tempprod .* (gates{j}{k} .^ numgates(j,k));
        end
        activesum = activesum + actcond{j} .* tempprod / 2;
        activesum2 = activesum2 + actcond{j} .* tempprod * erevval(j);
    end
    
    % Update active entries of the A matrix.
    A(L) = offset + activesum';
    
    % Calculate passive part of the RHS of equation (*)
    V1 = Istim(:,:,i)...
          +(V2(1:end-2,2:3)-V2(2:end-1,2:3)).*Gaxialpad(1:end-1,:)...
          -(V2(2:end-1,2:3)-V2(3:end,2:3)).*Gaxialpad(2:end,:)...
          +Radialpre(:,1:2).*(diff(V2(2:end-1,1:3),1,2))...
          -Radialpre(:,2:3).*(diff(V2(2:end-1,2:4),1,2))...
          +Leakpre;
    
    % Update active segments of RHS.
    V1(nodes,1)=V1(nodes,1)-activesum.*V2(nodes+1,2)+activesum2;
    V1(nodes,2)=0;
    
    V1=reshape(V1,2*tns,1);
    
    % Calculate voltage at next time-step.
    V2=[zeros(tns+2,1),[[0,0];reshape(A\V1,tns,2);[0,0]],zeros(tns+2,1)];
    
    % Save voltage at the nodes.
    Vsave(i+1, :) = V2(nodes+1,2);
    
end

if isVerbose
    fprintf('...finished, took %.4fs\n', toc)
end

MEMBRANE_POTENTIAL  = Vsave;
TIME_VECTOR         = 0:dt:tmax;

% Save the output.
if ~isempty(fileName)
    save(fileName, 'TIME_VECTOR', 'MEMBRANE_POTENTIAL', 'INTERNODE_LENGTH', 'par')
end


% ------------------------- END OF MAIN ------------------------------- %
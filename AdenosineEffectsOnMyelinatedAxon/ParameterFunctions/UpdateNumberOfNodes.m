function par = UpdateNumberOfNodes(par, nNodes, updateType, myelinUpdate, warnUser)
%UPDATENUMBEROFNODES
%   par = UPDATENUMBEROFNODES(par, nNodes, [updateType], [myelinUpdate], [warnUser])
%       Outputs:
%           par -               modified parameter structure
%       Inputs:
%           par -               existing parameter structure
%           nNodes -            number of nodes: positive integer
%                               if `updateType' is 'reset', then must be
%                               strictly greater than 1, otherwise must be
%                               greater than or equal to 1.
%           [updateType] -      'reset' or 'add'
%                               'reset' will update the axon so that it has
%                               nNodes nodes and nNodes-1 internodes.
%                               However, all inhomogeneities in the axon,
%                               introduced by the user, will be lost and
%                               the reference values used instead.
%                               'add' will add nNodes nodes and nNodes interndoes 
%                               to the end of the axon. All parameters will
%                               have the reference values.
%           [myelinUpdate] -    'max' (default) or 'min'.  After updating the
%                               diameter, the function runs
%                               CalculateNumberOfMyelinLamellae. SEE UPDATE
%                               METHOD OF THAT FUNCTION FOR DETAILS.
%           [warnUser] -        true (default) or false
%                               true will display a prompt for the user
%                               that they really want to reset the entire
%                               axon. false will reset the axon and display a
%                               message that it has reset, without asking.
%
%
%   When the number of nodes is updated there is a choice to make. We can:
%       1. Reset the entire axon, so any inhomogeneities are lost, and only
%       reference values for each parameter are used.
%       2. Add node/internode pairs to the end of the axon.
%
%   The GUI only has one option: reset the axon.

if CheckValue(nNodes, 'integer', [1, inf])
    error('Number of nodes is not acceptable')
end

VariableDefault('updateType', 'reset');
if CheckValue(updateType, 'string', {'reset', 'add'})
    error('Update type must be ''reset'' or ''add''')
end

VariableDefault('myelinUpdate', 'max');

VariableDefault('warnUser', true);

switch updateType
    
    case 'reset'
        
        if warnUser
            userAnswer = input('This will reset entire axon with reference values. Continue (y/n)?', 's');
            if ~any(strcmp(userAnswer, {'y', 'Y', 'yes'}))
                fprintf('Aborting\n'); return
            end
        else
            fprintf('Resetting the entire axon with reference values.\n')
        end
        
        if nNodes == 1
            error('Total number of nodes must be greater than 1.');
        end
        
        % Number of nodes and internodes.
        par.geo.nnode =                         nNodes;
        par.geo.nintn =                         par.geo.nnode - 1;
        
        % Node diameter and length.
        par.node.geo.diam.value.vec =           par.node.geo.diam.value.ref * ones(par.geo.nnode, 1);
        par.node.geo.length.value.vec =         par.node.geo.length.value.ref * ones(par.geo.nnode, 1);
        
        % Node segments.
        par.node.seg.geo.diam.value.vec =       repmat(par.node.geo.diam.value.vec, 1, par.geo.nnodeseg);
        par.node.seg.geo.length.value.vec =     repmat(par.node.geo.length.value.vec / par.geo.nnodeseg, 1, par.geo.nnodeseg);
        
        % Internode diameter and length.
        par.intn.geo.diam.value.vec =           par.intn.geo.diam.value.ref * ones(par.geo.nintn, 1);
        par.intn.geo.length.value.vec=          par.intn.geo.length.value.ref * ones(par.geo.nintn, 1);
        
        % Internode segments.
        par.intn.seg.geo.diam.value.vec =       repmat(par.intn.geo.diam.value.vec, 1, par.geo.nintseg);
        par.intn.seg.geo.length.value.vec =     repmat(par.intn.geo.length.value.vec / par.geo.nintseg, 1, par.geo.nintseg);
        
        % Active conductances in nodes.
        for i = 1 : length(par.node.elec.act)
            par.node.elec.act(i).cond.value.vec =  par.node.elec.act(i).cond.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
        end
        
        par.node.elec.pas.leak.erev.value.vec = par.node.elec.pas.leak.erev.value.ref * ones(par.geo.nnode, par.geo.nnodeseg);
        par =                                 	CalculateLeakConductanceNoIh(par);
        par.myel.geo.peri.value.vec =           par.myel.geo.peri.value.ref * ones(par.geo.nintn, par.geo.nintseg);
        par.myel.geo.gratio.value.vec_ref =     par.myel.geo.gratio.value.ref * ones(par.geo.nintn, par.geo.nintseg);
        par =                                   CalculateNumberOfMyelinLamellae(par, myelinUpdate);
        
    case 'add'
        
        % Number of nodes and internodes.
        par.geo.nnode =                         par.geo.nnode + nNodes;
        par.geo.nintn =                         par.geo.nnode - 1;
        
        % Node diameter.
        append =                                par.node.geo.diam.value.ref * ones(nNodes, 1);
        par.node.geo.diam.value.vec =           cat(1, par.node.geo.diam.value.vec, append);
        append =                                repmat(append, 1, par.geo.nnodeseg);
        par.node.seg.geo.diam.value.vec =       cat(1, par.node.seg.geo.diam.value.vec, append);
        
        % Node length.
        append =                                par.node.geo.length.value.ref * ones(nNodes, 1);
        par.node.geo.length.value.vec =         cat(1, par.node.geo.length.value.vec, append);
        append =                                repmat(append / par.geo.nnodeseg, 1, par.geo.nnodeseg);
        par.node.seg.geo.length.value.vec =     cat(1, par.node.seg.geo.length.value.vec, append);
        
        % Internode diameter.
        append =                                par.intn.geo.diam.value.ref * ones(nNodes, 1);
        par.intn.geo.diam.value.vec =           cat(1, par.intn.geo.diam.value.vec, append);
        append =                                repmat(append, 1, par.geo.nintseg);
        par.intn.seg.geo.diam.value.vec =       cat(1, par.intn.seg.geo.diam.value.vec, append);
        
        % Internode length.
        append =                                par.intn.geo.length.value.ref * ones(nNodes, 1);
        par.intn.geo.length.value.vec =         cat(1, par.intn.geo.length.value.vec, append);
        append =                                repmat(append / par.geo.nintseg, 1, par.geo.nintseg);
        par.intn.seg.geo.length.value.vec =     cat(1, par.intn.seg.geo.length.value.vec, append);
        
        % Active conductances in nodes.
        for i = 1 : length(par.node.elec.act)
            append =                            par.node.elec.act(i).cond.value.ref * ones(nNodes, par.geo.nnodeseg);
            par.node.elec.act(i).cond.value.vec =  cat(1, par.node.elec.act(i).cond.value.vec, append);
        end
        
        append =                                par.node.elec.pas.leak.erev.value.ref * ones(nNodes, par.geo.nnodeseg);
        par.node.elec.pas.leak.erev.value.vec = cat(1, par.node.elec.pas.leak.erev.value.vec, append);
        par =                                 	CalculateLeakConductanceNoIh(par);
        append =                                par.myel.geo.peri.value.ref * ones(nNodes, par.geo.nintseg);
        par.myel.geo.peri.value.vec =           cat(1, par.myel.geo.peri.value.vec, append);
        append =                                par.myel.geo.gratio.value.ref * ones(nNodes, par.geo.nintseg);
        par.myel.geo.gratio.value.vec_ref =     cat(1, par.myel.geo.gratio.value.vec_ref, append);
        par =                                   CalculateNumberOfMyelinLamellae(par, myelinUpdate);
end
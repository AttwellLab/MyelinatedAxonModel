classdef ParameterselecterController < handle
    
    properties
        
        view
        model
        workingDirectory
        
        options
        kinetics
        
        gratioDisplay
        myelinUpdateMethod = 'max'
    end
    
    
    
    methods
        
        function obj = ParameterselecterController()
            
            obj.model = Richardson2000FullAxon();
            obj.gratioDisplay = obj.model.myel.geo.gratio.value.ref;
            
            obj.view = ParameterselecterView(obj);
            obj.workingDirectory = fileparts(fileparts(mfilename('fullpath')));
            obj.options = OptionsController(obj);
            
            disp([[datestr(now,'HH:MM:SS') ' '] 'Parameter Selector GUI opened'])
        end
        
        
        
        function delete(obj)
            
            delete(obj.view);
            delete(obj.options);
            for i = 1 : length(obj.kinetics)
                if ~isempty(obj.kinetics{i})
                    if isvalid(obj.kinetics{i})
                        delete(obj.kinetics{i});
                    end
                end
            end
            disp([[datestr(now,'HH:MM:SS') ' '] 'Parameter Selector GUI closed'])
        end
        
        
        
        function TimeStepUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [eps, inf])
                set(hObj, 'String', num2str(obj.model.sim.dt.value))
                error('Time step invalid')
            end
            obj.model.sim.dt.value = value;
        end
        
        
        
        function TMaxUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [eps, inf])
                set(hObj, 'String', num2str(obj.model.sim.tmax.value))
                error('Total time invalid')
            end
            obj.model.sim.tmax.value = value;
        end
        
        
        
        function TemperatureUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-273, inf])
                set(hObj, 'String', num2str(obj.model.sim.temp))
            	error('Temperature invalid')
            end
            obj.model.sim.temp = value;
        end
        
        
        
        function StimulationAmplitudeUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.model.stim.amp.value))
                error('Amplitude invalid')
            end
            obj.model.stim.amp.value = value;
        end
        
        
        
        function StimulationDurationUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [eps, inf])
                set(hObj, 'String', num2str(obj.model.stim.dur.value))
                error('Duration invalid')
            end
            obj.model.stim.dur.value = value;
        end
        
        
        
        function NumberNodesUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'integer', [2, inf])
                set(hObj, 'String', num2str(obj.model.geo.nnode))
                error('Number of nodes invalid')
            end
            obj.model = UpdateNumberOfNodes(obj.model, value);
        end
        
        
        
        function NumberInternodeSegmentsUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'integer', [1, inf])
                set(hObj, 'String', num2str(obj.model.geo.nintseg))
                error('Number of internodes invalid')
            end
            obj.model = UpdateNumberOfInternodeSegments(obj.model, value);
        end
        
        
        
        function NodeDiameterUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.node.geo.diam.value.ref))
                error('Node diameter invalid')
            end
            obj.model.node.geo.diam.value.ref = value;
            obj.model.node.geo.diam.value.vec = ...
                obj.model.node.geo.diam.value.ref * ones(obj.model.geo.nnode, 1);
            obj.model.node.seg.geo.diam.value.ref = obj.model.node.geo.diam.value.ref;
            obj.model.node.seg.geo.diam.value.vec = repmat(obj.model.node.geo.diam.value.vec, 1, obj.model.geo.nnodeseg);
        end
        
        
        
        function InternodeDiameterUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.intn.geo.diam.value.ref))
                error('Internode diameter invalid')
            end
            
            obj.model.intn.geo.diam.value.ref = value;
            obj.model.intn.geo.diam.value.vec = obj.model.intn.geo.diam.value.ref * ones(obj.model.geo.nintn, 1);
            obj.model.intn.seg.geo.diam.value.ref = value;
            obj.model = UpdateInternodeSegmentDiameter(obj.model, value, [], [], obj.myelinUpdateMethod);
            obj.gratioDisplay = mode(obj.model.myel.geo.gratio.value.vec(:));
            obj.view.InitializeGUI();
        end
        
        
        
        function NodeLengthUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.node.geo.length.value.ref))
                error('Node length invalid')
            end
            obj.model.node.geo.length.value.ref = value;
            obj.model.node.geo.length.value.vec = ...
                obj.model.node.geo.length.value.ref * ones(obj.model.geo.nnode,1);
            % Node segment length.
            obj.model.node.seg.geo.length.value.ref = obj.model.node.geo.length.value.ref;
            obj.model.node.seg.geo.length.value.vec = repmat(obj.model.node.geo.length.value.vec / obj.model.geo.nnodeseg, 1, obj.model.geo.nnodeseg);
            
        end
        
        
        
        function InternodeLengthUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.intn.geo.length.value.ref))
                error('Internode length invalid')
            end
            obj.model = UpdateInternodeLength(obj.model, value);
            obj.view.InitializeGUI();
        end
        
        
        
        function RestingPotentialUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.model.elec.pas.vrest.value))
                error('Resting potential invalid')
            end
            obj.model.elec.pas.vrest.value = value;
            obj.model = CalculateLeakConductance(obj.model);
            set(obj.view.handles.nodeGLeakEdit, 'String', num2str(obj.model.node.elec.pas.leak.cond.value.ref));
        end
        
        
        
        function NodeCapacitanceUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.node.elec.pas.cap.value))
                error('Node capacitance invalid')
            end
            obj.model.node.elec.pas.cap.value = value;
        end
        
        
        
        function InternodeCapacitanceUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.intn.elec.pas.cap.value))
                error('Internode capacitance invalid')
            end
            obj.model.intn.elec.pas.cap.value = value;
        end
        
        
        
        function InternodeGLeakUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.intn.elec.pas.cond.value))
                error('Internode leak conductance invalid')
            end
            obj.model.intn.elec.pas.cond.value = value;
        end
        
        
        
        function NodeELeakUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.model.node.elec.pas.leak.erev.value.ref))
                error('Node leak reversal potential invalid')
            end
            obj.model.node.elec.pas.leak.erev.value.ref = value;
            obj.model.node.elec.pas.leak.erev.value.vec = obj.model.node.elec.pas.leak.erev.value.ref * ones(obj.model.geo.nnode, obj.model.geo.nnodeseg);
            obj.model = CalculateLeakConductance(obj.model);
            set(obj.view.handles.nodeGLeakEdit, 'String', num2str(obj.model.node.elec.pas.leak.cond.value.ref));
        end
        
        
        
        function AxoplasmicResistivityUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.node.elec.pas.axres.value))
                error('Axoplasmic resistivity invalid')
            end
            obj.model.node.elec.pas.axres.value = value;
        end
        
        
        
        function PeriaxonalResistivityUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.myel.elec.pas.peri.axres.value))
                error('Periaxonal resistivity invalid')
            end
            obj.model.myel.elec.pas.peri.axres.value = value;
        end
        
        
        
        function PeriaxonalSpaceUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.myel.geo.peri.value.ref))
                error('Periaxonal space width invalid')
            end
            obj.model = UpdateInternodePeriaxonalSpaceWidth(obj.model, value, [], [], obj.myelinUpdateMethod);
            obj.model.myel.geo.peri.value.ref = mode(obj.model.myel.geo.peri.value.vec(:));
            obj.gratioDisplay = mode(obj.model.myel.geo.gratio.value.vec(:));
            obj.view.InitializeGUI();
        end
        
        
        
        function GRatioUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, 1])
                set(hObj, 'String', num2str(obj.gratioDisplay))
                error('g-ratio invalid')
            end
            
            obj.model.myel.geo.gratio.value.ref = value;
            obj.model = UpdateInternodeGRatio(obj.model, value, [], [], obj.myelinUpdateMethod);
            obj.gratioDisplay = mode(obj.model.myel.geo.gratio.value.vec(:));
            obj.view.InitializeGUI();
        end
        
        
        
        function MyelinPeriodicityUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.myel.geo.period.value))
                error('Myelin periodicity invalid')
            end
            obj.model = UpdateMyelinLamellaPeriodicity(obj.model, value, obj.myelinUpdateMethod);
            obj.gratioDisplay = mode(obj.model.myel.geo.gratio.value.vec(:));
            obj.view.InitializeGUI();
        end
        
        
        
        function MyelinUpdateMethod(obj, hObj)
            
            str = get(hObj, 'String'); val = get(hObj, 'Value');
            obj.myelinUpdateMethod = str{val};
        end
        
        function MyelinCapacitanceUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.myel.elec.pas.cap.value))
                error('Myelin capacitance invalid')
            end
            obj.model.myel.elec.pas.cap.value = value;
        end
        
        
        
        function MyelinConductanceUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.myel.elec.pas.cond.value))
                error('Myelin conductance invalid')
            end
            obj.model.myel.elec.pas.cond.value = value;
        end
        
        
        
        function ActiveConductancePopup(obj, hObj)
            
            channelN = get(hObj, 'Value');
            obj.view.ActiveConductancePopup(channelN);
        end
        
        
        
        function RemoveActiveConductance(obj)
            
            channelN = get(obj.view.handles.actPop, 'Value');
            
            obj.model = RemoveActiveChannel(obj.model, channelN);
            obj.model = CalculateLeakConductance(obj.model);
            obj.view.activeChannelIdx = 1;
            
            obj.view.InitializeGUI();
        end
        
        
        
        function LoadActiveConductance(obj)
            
            [filename, pathname] = uigetfile(fullfile(obj.workingDirectory, 'SavedParameters', '*.mat'));
            if filename == 0; return; end;
            
            load(fullfile(pathname, filename), 'activeChannel');
            
            if ~exist('activeChannel', 'var')
                error('No variable called `activeChannel'' in this file.')
            end
            
            obj.model = AddActiveChannel(obj.model, activeChannel);
            obj.model = CalculateLeakConductance(obj.model);
            obj.view.activeChannelIdx = length(obj.model.node.elec.act);
            obj.view.InitializeGUI();
        end
        
        
        
        function SaveActiveConductance(obj)
            
            channelN = get(obj.view.handles.actPop, 'Value');
            
            [filename, pathname] = uiputfile(fullfile(obj.workingDirectory, 'SavedParameters', '*.mat'));
            if filename == 0; return; end;
            
            SaveActiveChannel(fullfile(pathname, filename), obj.model.node.elec.act(channelN));
        end
        
        
        
        function MaximumConductanceUpdate(obj, hObj)
            
            channelN = get(obj.view.handles.actPop, 'Value');
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [0, inf])
                set(hObj, 'String', num2str(obj.model.node.elec.act(channelN).cond.value.ref))
                error('Conductance value invalid')
            end
            
            obj.model.node.elec.act(channelN).cond.value.ref = value;
            obj.model.node.elec.act(channelN).cond.value.vec(:) = value;
            obj.model = CalculateLeakConductance(obj.model);
            set(obj.view.handles.nodeGLeakEdit, 'String', num2str(obj.model.node.elec.pas.leak.cond.value.ref));
        end
        
        
        
        function ActiveReversalPotentialUpdate(obj, hObj)
            
            channelN = get(obj.view.handles.actPop, 'Value');
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.model.node.elec.act(channelN).erev.value))
                error('Conductance value invalid')
            end
            
            obj.model.node.elec.act(channelN).erev.value = value;
            obj.model = CalculateLeakConductance(obj.model);
            set(obj.view.handles.nodeGLeakEdit, 'String', num2str(obj.model.node.elec.pas.leak.cond.value.ref));
        end
        
        
        
        function ViewKinetics(obj)
            
            value = get(obj.view.handles.actPop, 'Value');
            obj.kinetics{value} = KineticsController(obj, value);
        end
        
        
        
        function KineticsModuleUpdated(obj)
            
            obj.model = CalculateLeakConductance(obj.model);
            obj.view.InitializeGUI();
        end
        
        
        
        function RunModel(obj)
            
            if get(obj.view.handles.saveCheck, 'Value')
                [filename, pathname] = uiputfile(fullfile(obj.workingDirectory, 'SavedResults', '*.mat'));
                if filename == 0; return; end;
                fullfilename = fullfile(pathname, filename);
            else
                fullfilename = [];
            end
            
            [mp, il, t] = Model(obj.model, fullfilename);
            
            
            if get(obj.view.handles.printCVCheck, 'Value')
                
                vel = velocities(mp, il, t(2)-t(1), obj.options.cvNodes, obj.options.cvMethod, obj.options.voltageCross);
                fprintf('Conduction velocity: %.8f m/s\n', vel);
                
                if get(obj.options.view.handles.lastTwoCheck, 'Value')
                    vel = velocities(mp, il, t(2)-t(1), obj.model.geo.nnode+[-1, 0]);
                    fprintf('Conduction velocity over last 2 nodes: %.4f m/s\n', vel);
                end
            end
            
            
            if get(obj.view.handles.plotCheck, 'Value')
                
                figure
                plot(t, mp(:, obj.options.nodesToPlot));
                xlabel('Time, ms')
                ylabel('Membrane potential, mV')
                if get(obj.options.view.handles.legendCheck, 'Value')
                    str = arrayfun(@(x)(sprintf('Node %i', x)), obj.options.nodesToPlot, 'UniformOutput', false);
                    legend(str{:})
                end
            end
        end
        
        
        
        function SaveModel(obj)
            
            [filename, pathname] = uiputfile(fullfile(obj.workingDirectory, 'SavedParameters', '*.mat'));
            if filename == 0; return; end;
            
            axon = obj.model; %#ok<NASGU>
            
            gui.nodesToPlot = obj.options.nodesToPlot;
            gui.cvNodes = obj.options.cvNodes;
            gui.cvMethod = obj.options.cvMethod;
            gui.voltageCross = obj.options.voltageCross; %#ok<STRNU>
            
            save(fullfile(pathname, filename), 'axon', 'gui');
            
            fprintf('%s Parameters saved (%s)\n', datestr(now, 'HH:MM:SS'), filename);
        end
        
        
        
        function LoadModel(obj)
            
            [filename, pathname] = uigetfile(fullfile(obj.workingDirectory, 'SavedParameters', '*.mat'));
            if filename == 0; return; end;
            
            load(fullfile(pathname, filename), 'axon');
            
            if ~exist('axon', 'var')
                error('No variable called `axon'' in this file.')
            end
            
            % Check that number of node segments is valid.
            if axon.geo.nnodeseg > 1
                error('This axon has more than 1 segment per node... not allowed with the GUI.')
            end
            
            obj.model = axon;
            obj.gratioDisplay = mode(obj.model.myel.geo.gratio.value.vec(:));
            
            obj.view.InitializeGUI();
            
            set(obj.view.handles.fileText, 'String', sprintf('Last Loaded: %s', filename))
            fprintf('%s Parameters loaded (%s)\n', datestr(now, 'HH:MM:SS'), filename);
            
            % Attempt to load gui information
            warning('off', 'MATLAB:load:variableNotFound')
            load(fullfile(pathname, filename), 'gui');
            warning('on', 'MATLAB:load:variableNotFound')
            
            % Exit without warning it it doesn't exist.
            if ~exist('gui', 'var')
                return
            end
            
            try
                obj.options.nodesToPlot = gui.nodesToPlot;
                obj.options.cvNodes = gui.cvNodes;
                obj.options.cvMethod = gui.cvMethod;
                obj.options.voltageCross = gui.voltageCross;
            catch
                fprintf('Failed to load gui options.\n')
                return
            end
            
            obj.options.view.InitializeGUI();
        end
        
        
        
        function ChooseOptions(obj)
            
            obj.options.view.MakeVisible();
        end
        
    end
end
classdef ParameterselecterView < handle
    
    properties
        
        model
        controller
        gui
        handles
        
        activeChannelIdx = 1;
    end
    
    
    
    methods
        
        function obj = ParameterselecterView(controller)
            
            obj.controller = controller;
            obj.gui = ParameterselecterGUI(obj.controller);
            obj.handles = guidata(obj.gui);
            
            % Set listeners for parameters.
            obj.InitializeGUI();
        end
        
        
        
        function delete(obj)
            
            delete(obj.handles.output);
        end
        
        
        
        function InitializeGUI(obj)
            
            % Fill UI controls
            set(obj.handles.dtEdit, 'String', num2str(obj.controller.model.sim.dt.value));
            set(obj.handles.tmaxEdit, 'String', num2str(obj.controller.model.sim.tmax.value));
            set(obj.handles.temperatureEdit, 'String', num2str(obj.controller.model.sim.temp));
            set(obj.handles.stimAmpEdit, 'String', num2str(obj.controller.model.stim.amp.value));
            set(obj.handles.stimDurEdit, 'String', num2str(obj.controller.model.stim.dur.value));
            set(obj.handles.numNodesEdit, 'String', num2str(obj.controller.model.geo.nnode));
            set(obj.handles.numInternodeSegEdit, 'String', num2str(obj.controller.model.geo.nintseg));
            set(obj.handles.nodeDiameterEdit, 'String', num2str(obj.controller.model.node.geo.diam.value.ref));
            set(obj.handles.internodeDiameterEdit, 'String', num2str(obj.controller.model.intn.geo.diam.value.ref));
            set(obj.handles.nodeLengthEdit, 'String', num2str(obj.controller.model.node.geo.length.value.ref));
            set(obj.handles.nodeNodeLengthEdit, 'String', num2str(obj.controller.model.intn.geo.length.value.ref));
            set(obj.handles.internodeLengthEdit, 'String', num2str(obj.controller.model.intn.seg.geo.length.value.ref));
            set(obj.handles.vrestEdit, 'String', num2str(obj.controller.model.elec.pas.vrest.value));
            set(obj.handles.nodeCapacitanceEdit, 'String', num2str(obj.controller.model.node.elec.pas.cap.value));
            set(obj.handles.internodeCapacitanceEdit, 'String', num2str(obj.controller.model.intn.elec.pas.cap.value));
            set(obj.handles.nodeGLeakEdit, 'String', num2str(obj.controller.model.node.elec.pas.leak.cond.value.vec(1)));
            set(obj.handles.internodeGLeakEdit, 'String', num2str(obj.controller.model.intn.elec.pas.cond.value));
            set(obj.handles.nodeELeakEdit, 'String', num2str(obj.controller.model.node.elec.pas.leak.erev.value.ref));
            set(obj.handles.nodeAxoplasmicResistivityEdit, 'String', num2str(obj.controller.model.node.elec.pas.axres.value));
            set(obj.handles.periaxonalResistivityEdit, 'String', num2str(obj.controller.model.myel.elec.pas.peri.axres.value));
            
            set(obj.handles.periaxonalSpaceEdit, 'String', num2str(obj.controller.model.myel.geo.peri.value.ref));
            set(obj.handles.gRatioEdit, 'String', num2str(obj.controller.gratioDisplay));
            set(obj.handles.myelinPeriodicityEdit, 'String', num2str(obj.controller.model.myel.geo.period.value));
            set(obj.handles.myelinThicknessEdit, 'String', num2str(obj.controller.model.myel.geo.width.value.ref));
            set(obj.handles.numLamellaeEdit, 'String', num2str(obj.controller.model.myel.geo.numlamellae.value.ref));
            
            set(obj.handles.myelinCapacitanceEdit, 'String', num2str(obj.controller.model.myel.elec.pas.cap.value));
            set(obj.handles.myelinConductanceEdit, 'String', num2str(obj.controller.model.myel.elec.pas.cond.value));
            
            obj.InitializeActiveChannels()
            
            % Fill units text
            set(obj.handles.dtUnits, 'String', obj.UnitsToString(obj.controller.model.sim.dt.units));
            set(obj.handles.tmaxUnits, 'String', obj.UnitsToString(obj.controller.model.sim.tmax.units));
            set(obj.handles.stimAmpUnits, 'String', obj.UnitsToString(obj.controller.model.stim.amp.units));
            set(obj.handles.stimDurUnits, 'String', obj.UnitsToString(obj.controller.model.stim.dur.units));
            set(obj.handles.nodeDiameterUnits, 'String', obj.UnitsToString(obj.controller.model.node.geo.diam.units));
            set(obj.handles.internodeDiameterUnits, 'String', obj.UnitsToString(obj.controller.model.intn.geo.diam.units));
            set(obj.handles.nodeLengthUnits, 'String', obj.UnitsToString(obj.controller.model.node.geo.length.units));
            set(obj.handles.nodeNodeLengthUnits, 'String', obj.UnitsToString(obj.controller.model.intn.geo.length.units));
            set(obj.handles.internodeLengthUnits, 'String', obj.UnitsToString(obj.controller.model.intn.seg.geo.length.units));
            set(obj.handles.vrestUnits, 'String', obj.UnitsToString(obj.controller.model.elec.pas.vrest.units));
            set(obj.handles.nodeCapacitanceUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.pas.cap.units));
            set(obj.handles.internodeCapacitanceUnits, 'String', obj.UnitsToString(obj.controller.model.intn.elec.pas.cap.units));
            set(obj.handles.nodeGLeakUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.pas.leak.cond.units));
            set(obj.handles.internodeGLeakUnits, 'String', obj.UnitsToString(obj.controller.model.intn.elec.pas.cond.units));
            set(obj.handles.nodeELeakUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.pas.leak.erev.units));
            set(obj.handles.nodeAxoplasmicResistivityUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.pas.axres.units));
            set(obj.handles.periaxonalResistivityUnits, 'String', obj.UnitsToString(obj.controller.model.myel.elec.pas.peri.axres.units));
            
            set(obj.handles.periaxonalSpaceUnits, 'String', obj.UnitsToString(obj.controller.model.myel.geo.peri.units));
            set(obj.handles.myelinPeriodicityUnits, 'String', obj.UnitsToString(obj.controller.model.myel.geo.period.units));
            set(obj.handles.myelinThicknessUnits, 'String', obj.UnitsToString(obj.controller.model.myel.geo.width.units));
            
            set(obj.handles.myelinCapacitanceUnits, 'String', obj.UnitsToString(obj.controller.model.myel.elec.pas.cap.units));
            set(obj.handles.myelinConductanceUnits, 'String', obj.UnitsToString(obj.controller.model.myel.elec.pas.cond.units));
        end
        
        
        
        function ActiveConductancePopup(obj, channelN)
            
            obj.activeChannelIdx = channelN;
            
            set(obj.handles.maxCondEdit, 'String', num2str(obj.controller.model.node.elec.act(obj.activeChannelIdx).cond.value.ref));
            set(obj.handles.revPotEdit, 'String', num2str(obj.controller.model.node.elec.act(obj.activeChannelIdx).erev.value));
            set(obj.handles.maxCondUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.act(obj.activeChannelIdx).cond.units));
            set(obj.handles.revPotUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.act(obj.activeChannelIdx).erev.units));
            
            if length(unique(obj.controller.model.node.elec.act(obj.activeChannelIdx).cond.value.vec(:))) > 1
                set(obj.handles.maxCondEdit, 'BackgroundColor', [0.8, 0.8, 0.8]);
            end
        end
        
        
        
        function SimParameterUpdated(obj, src, ~)
            switch src.Name
                case 'dt'
                    set(obj.handles.dtEdit, 'String', num2str(obj.controller.model.sim.dt));
                case 'totalTime'
                    set(obj.handles.tmaxEdit, 'String', num2str(obj.controller.model.sim.totalTime));
            end
        end
        
        
        
        function AxonParameterUpdate(obj, src, ~)
            switch src.Name
                case 'temperature'
                    set(obj.handles.temperatureEdit, 'String', num2str(obj.controller.model.axon.temperature));
                case 'restingMembranePotential'
                    set(obj.handles.vrestEdit, 'String', num2str(obj.controller.model.axon.restingMembranePotential(1)));
            end
        end
        
        
        
        function StimParameterUpdated(obj, src, ~)
            switch src.Name
                case 'amplitude'
                    set(obj.handles.stimAmpEdit, 'String', num2str(obj.controller.model.stim.amplitude));
                case 'duration'
                    set(obj.handles.stimDurEdit, 'String', num2str(obj.controller.model.stim.duration));
            end
        end
        
        
        
        function InitializeActiveChannels(obj)
            
            if isempty(obj.controller.model.node.elec.act)
                set(obj.handles.actPop, 'String', {''}, 'Value', 1);
                set(obj.handles.maxCondEdit, 'String', '');
                set(obj.handles.revPotEdit, 'String', '');
                isEnabled = 'off';
            else
                set(obj.handles.actPop, 'String', {obj.controller.model.node.elec.act(:).channames}, 'Value', obj.activeChannelIdx);
                set(obj.handles.maxCondEdit, 'String', num2str(obj.controller.model.node.elec.act(obj.activeChannelIdx).cond.value.ref));
                set(obj.handles.revPotEdit, 'String', num2str(obj.controller.model.node.elec.act(obj.activeChannelIdx).erev.value));
                set(obj.handles.maxCondUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.act(obj.activeChannelIdx).cond.units));
                set(obj.handles.revPotUnits, 'String', obj.UnitsToString(obj.controller.model.node.elec.act(obj.activeChannelIdx).erev.units));
                isEnabled = 'on';
            end
            
            set(obj.handles.actPop, 'Enable', isEnabled);
            set(obj.handles.maxCondEdit, 'Enable', isEnabled);
            set(obj.handles.revPotEdit, 'Enable', isEnabled);
            set(obj.handles.removeActButt, 'Enable', isEnabled);
            set(obj.handles.saveKineticsButt, 'Enable', isEnabled);
            set(obj.handles.kineticsButt, 'Enable', isEnabled);
            set(obj.handles.activeCondButt, 'Enable', isEnabled);
        end
        
        
        
        function ActiveChannelsUpdated(obj)
            
            set(obj.handles.actPop, 'String', {obj.controller.model.node.elec.act(:).channames}, 'Value', 1);
            set(obj.handles.maxCondEdit, 'String', num2str(obj.controller.model.node.elec.act(1).cond.value.ref));
            set(obj.handles.revPotEdit, 'String', num2str(obj.controller.model.node.elec.act(1).erev.value));
        end
        
        
        
        
        function NodeParameterUpdated(obj, src, ~)
            switch src.Name
                case 'nSections'
                    set(obj.handles.numNodesEdit, 'String', num2str(obj.controller.model.axon.components{1}.nSections));
                case 'diameterDefault'
                    set(obj.handles.nodeDiameterEdit, 'String', num2str(obj.controller.model.axon.components{1}.diameterDefault));
                case 'lengthDefault'
                    set(obj.handles.nodeLengthEdit, 'String', num2str(obj.controller.model.axon.components{1}.lengthDefault));
                case 'capacitanceDefault'
                    set(obj.handles.nodeCapacitanceEdit, 'String', num2str(obj.controller.model.axon.components{1}.capacitanceDefault));
                case 'leakConductanceDefault'
                    set(obj.handles.nodeGLeakEdit, 'String', num2str(obj.controller.model.axon.components{1}.leakConductanceDefault));
                case 'leakReversalPotentialDefault'
                    set(obj.handles.nodeELeakEdit, 'String', num2str(obj.controller.model.axon.components{1}.leakReversalPotentialDefault));
                case 'axialResistivityDefault'
                    set(obj.handles.nodeAxoplasmicResistivityEdit, 'String', num2str(obj.controller.model.axon.components{1}.axialResistivityDefault));
            end
        end
        
        
        
        function InternodeParameterUpdated(obj, src, ~)
            switch src.Name
                case 'nSectionSegments'
                    set(obj.handles.numInternodeSegEdit, 'String', num2str(obj.controller.model.axon.components{2}.nSectionSegments));
                case 'diameterDefault'
                    set(obj.handles.internodeDiameterEdit, 'String', num2str(obj.controller.model.axon.components{2}.diameterDefault));
                case 'lengthDefault'
                    set(obj.handles.nodeNodeLengthEdit, 'String', num2str(obj.controller.model.axon.components{2}.lengthDefault));
                case 'lengthArray'
                    set(obj.handles.internodeLengthEdit, 'String', num2str(obj.controller.model.axon.components{2}.lengthArray(1)));
                case 'capacitanceDefault'
                    set(obj.handles.internodeCapacitanceEdit, 'String', num2str(obj.controller.model.axon.components{2}.capacitanceDefault));
                case 'leakConductanceDefault'
                    set(obj.handles.internodeGLeakEdit, 'String', num2str(obj.controller.model.axon.components{2}.leakConductanceDefault));
                case 'periaxonalResistivityDefault'
                    set(obj.handles.periaxonalResistivityEdit, 'String', num2str(obj.controller.model.axon.components{2}.periaxonalResistivityDefault));
                case 'periaxonalSpaceDefault'
                    set(obj.handles.periaxonalSpaceEdit, 'String', num2str(obj.controller.model.axon.components{2}.periaxonalSpaceDefault));
                case 'gratioSpecifiedDefault'
                    set(obj.handles.gRatioEdit, 'String', num2str(obj.controller.model.axon.components{2}.gratioSpecifiedDefault));
                case 'myelinPeriodicity'
                    set(obj.handles.myelinPeriodicity, 'String', num2str(obj.controller.model.axon.components{2}.myelinPeriodicity));
                case 'myelinThicknessExcludingPeriaxonalSpaceArray'
                    set(obj.handles.myelinThicknessEdit, 'String', num2str(obj.controller.model.axon.components{2}.myelinThicknessExcludingPeriaxonalSpaceArray(1)));
                case 'numberMyelinWrapsArray'
                    set(obj.handles.numLamellaeEdit, 'String', num2str(obj.controller.model.axon.components{2}.numberMyelinWrapsArray(1)));
                case 'myelinMembraneCapacitanceDefault'
                    set(obj.handles.myelinCapacitanceEdit, 'String', num2str(obj.controller.model.axon.components{2}.myelinMembraneCapacitanceDefault));
                case 'myelinMembraneConductanceDefault'
                    set(obj.handles.myelinConductanceEdit, 'String', num2str(obj.controller.model.axon.components{2}.myelinMembraneConductanceDefault));
            end
        end
        
        
        
        function NodeArraysChanged(obj, src, ~)
            switch src.Name
                case 'diameterArray'
                    if length(unique(obj.controller.model.axon.components{1}.diameterArray(:))) > 1
                        set(obj.handles.nodeDiameterEdit, 'BackgroundColor', [0.8, 0.8, 0.8])
                    else
                        set(obj.handles.nodeDiameterEdit, 'BackgroundColor', [1, 1, 1])
                    end
                case 'lengthArray'
                    if length(unique(obj.controller.model.axon.components{1}.lengthArray(:))) > 1
                        set(obj.handles.nodeLengthEdit, 'BackgroundColor', [0.8, 0.8, 0.8])
                    else
                        set(obj.handles.nodeLengthEdit, 'BackgroundColor', [1, 1, 1]);
                    end
                case 'activeChannelConductanceArray'
                    channelIdx = get(obj.handles.actPop, 'Value');
                    if length(unique(obj.controller.model.axon.components{1}.activeChannelConductanceArray{channelIdx}(:))) > 1
                        set(obj.handles.maxCondEdit, 'BackgroundColor', [0.8, 0.8, 0.8]);
                        set(obj.handles.nodeGLeakEdit, 'BackgroundColor', [0.8, 0.8, 0.8]);
                    else
                        set(obj.handles.maxCondEdit, 'BackgroundColor', [1, 1, 1]);
                        set(obj.handles.nodeGLeakEdit, 'BackgroundColor', [1, 1, 1]);
                    end
            end
        end
        
        
        
        function InternodeArraysChanged(obj, src, ~)
            switch src.Name
                case 'diameterArray'
                    if length(unique(obj.controller.model.axon.components{2}.diameterArray(:))) > 1
                        set(obj.handles.internodeDiameterEdit, 'BackgroundColor', [0.8, 0.8, 0.8])
                    else
                        set(obj.handles.internodeDiameterEdit, 'BackgroundColor', [1, 1, 1])
                    end
                case 'lengthArray'
                    if length(unique(obj.controller.model.axon.components{2}.lengthArray(:))) > 1
                        set(obj.handles.nodeNodeLengthEdit, 'BackgroundColor', [0.8, 0.8, 0.8])
                        set(obj.handles.internodeLengthEdit, 'BackgroundColor', [0.8, 0.8, 0.8])
                    else
                        set(obj.handles.nodeNodeLengthEdit, 'BackgroundColor', [1, 1, 1]);
                        set(obj.handles.internodeLengthEdit, 'BackgroundColor', [1, 1, 1]);
                    end
                case 'periaxonalSpaceArray'
                    if length(unique(obj.controller.model.axon.components{2}.periaxonalSpaceArray(:))) > 1
                        set(obj.handles.periaxonalSpaceEdit, 'BackgroundColor', [0.8, 0.8, 0.8]);
                    else
                        set(obj.handles.periaxonalSpaceEdit, 'BackgroundColor', [1, 1, 1]);
                    end
            end
        end
    end
    
    
    methods (Static = true)
        
        function str = UnitsToString(unitsCell)
            % Convert the cell array denoting units into a string to
            % display in the GUI.
            str = [];
            nUnits = unitsCell{1};
            unitsCell = unitsCell(2:end);
            
            [~, resortIdx] = sort(unitsCell{end}, 'descend');
            unitsCell(1:end-1) = unitsCell(resortIdx);
            unitsCell{end} = unitsCell{end}(resortIdx);
            
            isNegative = find(unitsCell{end}<0, 1);
            
            for idx = 1 : nUnits
                
                str = [str, unitsCell{idx}];
                if abs(unitsCell{end}(idx))>1
                    str = [str, num2str(abs(unitsCell{end}(idx)))];
                end
                if idx >= isNegative-1
                    str = [str, '/'];
                else
                    str = [str, '*'];
                end
            end
            str = str(1:end-1);
        end
    end
end
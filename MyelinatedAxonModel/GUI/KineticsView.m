classdef KineticsView < hgsetget
    
    properties
        
        controller
        gui
        handles
        
        gateIdx = 1
    end
    
    methods
        
        function obj = KineticsView(controller)
            
            obj.controller = controller;
            obj.gui = KineticsGUI(obj.controller);
            obj.handles = guidata(obj.gui);
            
            idx = obj.controller.channelIdx;
            chanStr = obj.controller.parent.model.node.elec.act(idx).channames;
            set(obj.handles.output, 'Name', sprintf('%s kinetics', chanStr));
            
            obj.InitializeGUI();
        end
        
        
        
        function delete(obj)
            
            delete(obj.handles.output);
        end
        
        
        
        function InitializeGUI(obj)
            
            idx = obj.controller.channelIdx;
            nGates = obj.controller.parent.model.node.elec.act(idx).gates.number;
            set(obj.handles.editNGates, 'String', num2str(nGates));
            
            if nGates > 0
                
                str = cellfun(@num2str, num2cell(1:nGates), 'UniformOutput', false);
                set(obj.handles.popGateNo, 'String', str, 'Value', obj.gateIdx);
            else
                
                set(obj.handles.popGateNo, 'String', {''}, 'Value', 1);
            end
            
            obj.UpdateGateUIs(obj.gateIdx);
        end
        
        
        
        function UpdateGateUIs(obj, gateIdx)
            
            idx = obj.controller.channelIdx;
            
            if obj.controller.parent.model.node.elec.act(idx).gates.number == 0
                state = 'off';
            else
                state = 'on';
            end
            
            set(obj.handles.editTemperature, 'Visible', state);
            set(obj.handles.editGateLabel, 'Visible', state);
            set(obj.handles.editGatePower, 'Visible', state);
            set(obj.handles.editAlphaEquation, 'Visible', state);
            set(obj.handles.editBetaEquation, 'Visible', state);
            set(obj.handles.editQ10, 'Visible', state);
            
            if strcmp(state, 'off'); return; end
            
            temp = obj.controller.parent.model.node.elec.act(idx).gates.temp;
            set(obj.handles.editTemperature, 'String', num2str(temp));
            
            label = obj.controller.parent.model.node.elec.act(idx).gates.label{gateIdx};
            set(obj.handles.editGateLabel, 'String', label);
            
            gatePower = obj.controller.parent.model.node.elec.act(idx).gates.numbereach(gateIdx);
            set(obj.handles.editGatePower, 'String', num2str(gatePower));
            
            str = obj.controller.parent.model.node.elec.act(idx).gates.alpha.equ{gateIdx};
            set(obj.handles.editAlphaEquation, 'String', str);
            
            str = obj.controller.parent.model.node.elec.act(idx).gates.beta.equ{gateIdx};
            set(obj.handles.editBetaEquation, 'String', str);
            
            q10 = obj.controller.parent.model.node.elec.act(idx).gates.alpha.q10(gateIdx);
            set(obj.handles.editQ10, 'String', num2str(q10));
        end       
    end
end
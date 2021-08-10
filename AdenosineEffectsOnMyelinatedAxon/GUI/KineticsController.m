classdef KineticsController < hgsetget
    
    properties
        
        parent
        channelIdx
        
        view
    end
    
    
    methods
        
        
        function obj = KineticsController(parent, channelN)
            
            obj.parent = parent;
            obj.channelIdx = channelN;
            
            obj.view = KineticsView(obj);
        end
        
        
        
        function delete(obj)
            
            delete(obj.view);
        end
        
        
        
        function ChooseGate(obj, hObj)
            
            value = get(hObj, 'Value');
            obj.view.UpdateGateUIs(value);
        end
        
        
        
        function AddGate(obj)
            
            nGates = obj.parent.model.node.elec.act(obj.channelIdx).gates.number;
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.label{nGates+1} = 'a';
            obj.parent.model.node.elec.act(obj.channelIdx).gates.numbereach(nGates+1) = 0;
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.q10(nGates+1) = 3;
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.equ{nGates+1} = 'V';
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.q10(nGates+1) = 3;
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.equ{nGates+1} = 'V';
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.number = nGates + 1;
            
            obj.parent.KineticsModuleUpdated();
            
            obj.view.gateIdx = obj.parent.model.node.elec.act(obj.channelIdx).gates.number;
            obj.view.InitializeGUI();
        end
        
        
        
        function RemoveGate(obj)
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            
            if obj.parent.model.node.elec.act(obj.channelIdx).gates.number == 1
                error('Active channel must have at least one gate... modify this one if you need to.')
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.label(gateIdx) = [];
            obj.parent.model.node.elec.act(obj.channelIdx).gates.numbereach(gateIdx) = [];
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.q10(gateIdx) = [];
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.equ(gateIdx) = [];
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.q10(gateIdx) = [];
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.equ(gateIdx) = [];
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.number = ...
                obj.parent.model.node.elec.act(obj.channelIdx).gates.number - 1;
            
            obj.parent.KineticsModuleUpdated();
            
            obj.view.gateIdx = 1;
            obj.view.InitializeGUI();
        end
        
        
        
        function TemperatureUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.parent.model.node.elec.act(obj.channelIdx).gates.temp))
                error('Temperature must be real');
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.temp = value;
            
            obj.parent.KineticsModuleUpdated();
        end
        
        
        
        function GateLabelUpdate(obj, hObj)
            
            value = get(hObj, 'String');
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.label{gateIdx} = value;
        end
        
        
        
        function GatePowerUpdated(obj, hObj)
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.parent.model.node.elec.act(obj.channelIdx).gates.numbereach(gateIdx)))
                error('Gate power must be real');
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.numbereach(gateIdx) = value;
            obj.parent.KineticsModuleUpdated();
        end
        
        
        
        function AlphaEquationUpdate(obj, hObj)
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            oldStr = obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.equ{gateIdx};
            
            str = get(hObj, 'String');
            if isempty(strfind(str, 'V'))
                set(hObj, 'String', oldStr)
                error('Equation string must contain a ''V'' for voltage');
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.equ{gateIdx} = str;
            try
                obj.parent.KineticsModuleUpdated();
            catch
                obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.equ{gateIdx} = oldStr;
                set(hObj, 'String', oldStr)
                error('Something went wrong. Reset equation');
            end
        end
        
        
        
        
        function BetaEquationUpdate(obj, hObj)
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            oldStr = obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.equ{gateIdx};
            
            str = get(hObj, 'String');
            if isempty(strfind(str, 'V'))
                set(hObj, 'String', oldStr)
                error('Equation string must contain a ''V'' for voltage');
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.equ{gateIdx} = str;
            try
                obj.parent.KineticsModuleUpdated();
            catch
                obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.equ{gateIdx} = oldStr;
                set(hObj, 'String', oldStr)
                error('Something went wrong. Reset equation');
            end
        end
        
        
        
        function Q10Update(obj, hObj)
            
            gateIdx = get(obj.view.handles.popGateNo, 'Value');
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'real', [-inf, inf])
                set(hObj, 'String', num2str(obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.q10(gateIdx)))
                error('q10 must be real');
            end
            
            obj.parent.model.node.elec.act(obj.channelIdx).gates.alpha.q10(gateIdx) = value;
            obj.parent.model.node.elec.act(obj.channelIdx).gates.beta.q10(gateIdx) = value;
            obj.parent.KineticsModuleUpdated();
        end
    end
end
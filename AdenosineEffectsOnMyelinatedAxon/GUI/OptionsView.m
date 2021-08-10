classdef OptionsView < handle
    
    properties
        
        controller
        gui
        handles
    end
    
    methods
        
        function obj = OptionsView(controller)
            
            obj.controller = controller;
            obj.gui = OptionsGUI(obj.controller);
            obj.handles = guidata(obj.gui);
            
            obj.InitializeGUI();
        end
        
        
        
        function delete(obj)
            
            delete(obj.handles.output);
        end
        
        
        
        function InitializeGUI(obj)
            
            str = obj.NodesToPlotString();
            set(obj.handles.plotNodesEdit, 'String', str);
            
            set(obj.handles.startCVEdit, 'String', num2str(obj.controller.cvNodes(1)));
            set(obj.handles.finishCVEdit, 'String', num2str(obj.controller.cvNodes(2)));
            
            set(obj.handles.voltageCrossEdit, 'String', num2str(obj.controller.voltageCross));
            
            obj.MakeInvisible();
        end
        
        
        
        function MakeVisible(obj)
            
            set(obj.handles.output, 'Visible', 'on');
            figure(obj.handles.output)
        end
        
        
        
        function MakeInvisible(obj)
            
            set(obj.handles.output, 'Visible', 'off');
        end
        
        
        
        function str = NodesToPlotString(obj)
            
            n = obj.controller.nodesToPlot;
            if max(diff(n))==1
                str = sprintf('%i:%i', min(n), max(n));
            else
                str = num2str(n);
            end
        end
        
        
        
        function VoltageCrossText(obj, isEnabled)
            
            state = {'off', 'on'};
            
            set(obj.handles.voltageCrossTxt1, 'Enable', state{isEnabled+1});
            set(obj.handles.voltageCrossTxt2, 'Enable', state{isEnabled+1});
            set(obj.handles.voltageCrossEdit, 'Enable', state{isEnabled+1});
        end
    end
end
classdef OptionsController < handle
    
    properties
        
        parent
        
        view
        
        nodesToPlot
        cvNodes
        cvMethod = 'max'
        voltageCross = -40;
    end
    
    methods
        
        function obj = OptionsController(parent)
            
            obj.parent = parent;
            
            obj.nodesToPlot = 1:obj.parent.model.geo.nnode;
            
            if obj.parent.model.geo.nnode > 6
                firstNode = 6;
            else
                firstNode = 1;
            end
            if obj.parent.model.geo.nnode > 13
                lastNode = 13;
            else
                lastNode = obj.parent.model.nnode;
            end
            
            if lastNode == firstNode; firstNode = firstNode-1; end
            
            obj.cvNodes = [firstNode, lastNode];
            
            obj.view = OptionsView(obj);
        end
        
        
        
        function delete(obj)
            
            delete(obj.view);
        end
        
        
        
        function NodesToPlot(obj, hObj)
            
            str = get(hObj, 'String');
            
            try
                I = eval(sprintf('[%s]', str));
            catch
                str = obj.view.NodesToPlotString();
                set(hObj, 'String', str);
                return
            end
            
            if CheckValue(I, 'integer', [1, obj.parent.model.geo.nnode])
                str = obj.view.NodesToPlotString();
                set(hObj, 'String', str);
                return
            end
            
            obj.nodesToPlot = unique(I);
        end
        
        
        
        function CVFirstNode(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'integer', [1, obj.cvNodes(2)-1])
                set(hObj, 'String', num2str(obj.cvNodes(1)))
                return
            end
            
            obj.cvNodes(1) = value;
        end
        
        
        
        function CVSecondNode(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            if CheckValue(value, 'integer', [obj.cvNodes(1)+1, obj.parent.model.geo.nnode])
                set(hObj, 'String', num2str(obj.cvNodes(2)))
                return
            end
            obj.cvNodes(2) = value;
        end
        
        
        
        function CVMethodUpdate(obj, hObj)
            
            methods = {'max', 'dVdt', 'voltagecross'};
            val = get(hObj, 'Value');
            obj.cvMethod = methods{val};
            
            obj.view.VoltageCrossText(strcmp(obj.cvMethod, 'voltagecross'));
        end
        
        
        
        function VoltageCrossUpdate(obj, hObj)
            
            value = str2double(get(hObj, 'String'));
            obj.voltageCross = value;
        end
    end
end
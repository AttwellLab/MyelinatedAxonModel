classdef ArrayController < handle
    
    properties
        
        parent
        fullDescription
        
        % UI elements
        figure
        table
        
        channelIdx
        
        segmentCheckbox
        showSegments = false;
    end
    
    methods
        
        function obj = ArrayController(parent, fullDescription)
            
            VariableDefault('fullDescription', []);
            
            obj.fullDescription = fullDescription;
            obj.parent = parent;
            
            % Figure size.
            screenInfo = get(0); % Does this ever fail?
            ss = screenInfo.ScreenSize;
            obj.figure = figure;
            set(obj.figure, 'OuterPosition', [0.1, 0.1, 0.8, 0.8].*ss([3, 4, 3, 4]));
            
            % Figure name.
            set(obj.figure, 'NumberTitle', 'off', 'Name', obj.fullDescription);
            
            % Table position
            obj.table = uitable();
            fs = get(obj.figure, 'Position');
            set(obj.table, 'Units', 'pixels', 'Position', [20, 20, fs(3)-40, fs(4)-120]);
            
            % Checkbox
            obj.segmentCheckbox = uicontrol('Style', 'checkbox', 'String', 'Show segments', ...
                'Value', obj.showSegments, 'Units', 'pixels', 'Position', [20, fs(4)-80, 150, 20], ...
                'Callback', @(src, evt)obj.ShowSegmentCallback(src, evt), 'FontSize', 10);
            
            if any(strcmp(obj.fullDescription, {'Node Diameter', 'Node Length', 'Active Conductance', 'Number of Lamellae'}))
                set(obj.segmentCheckbox, 'Enable', 'off')
            end
            
            obj.DisplayTable();
        end
        
        
        
        function DisplayTable(obj)
            % Layout
            [nRows, nCols] = size(obj.ReturnData);
            
            if any(strcmp(obj.fullDescription, {'Internode Diameter', 'Internode Length'}))
                if obj.showSegments
                    colStr = cellfun(@(x)sprintf('Segment %i', x), num2cell(1:nCols), 'UniformOutput', false);
                else
                    colStr = cellfun(@(x)sprintf('%i', x), num2cell(1:nCols), 'UniformOutput', false);
                end
                rowStr = cellfun(@(x)sprintf('Internode %i', x), num2cell(1:nRows), 'UniformOutput', false);
            elseif strcmp(obj.fullDescription, 'Periaxonal Space')
                colStr = cellfun(@(x)sprintf('Segment %i', x), num2cell(1:nCols), 'UniformOutput', false);
                if obj.showSegments
                    rowStr = cellfun(@(x)sprintf('Internode %i', x), num2cell(1:nRows), 'UniformOutput', false);
                else
                    rowStr = cellfun(@(x)sprintf('%i', x), num2cell(1:nRows), 'UniformOutput', false);
                end
            elseif any(strcmp(obj.fullDescription, {'Node Diameter', 'Node Length', 'Active Conductance'}))
                colStr = cellfun(@(x)sprintf('%i', x), num2cell(1:nCols), 'UniformOutput', false);
                rowStr = cellfun(@(x)sprintf('Node %i', x), num2cell(1:nRows), 'UniformOutput', false);
            else
                colStr = cellfun(@(x)sprintf('Segment %i', x), num2cell(1:nCols), 'UniformOutput', false);
                rowStr = cellfun(@(x)sprintf('Internode %i', x), num2cell(1:nRows), 'UniformOutput', false);
            end
            
            set(obj.table, 'RowName', rowStr, 'ColumnName', colStr);
            
            % Data
            set(obj.table, 'Data', obj.ReturnData);
            
            % Editing.
            set(obj.table, 'ColumnEditable', true(1, nCols), ...
                'CellEditCallback', @(src, evt)obj.DataUpdate(src, evt));
            
            if strcmp(obj.fullDescription, 'Number of Lamellae')
                set(obj.table, 'ColumnEditable', false(1, nCols));
            end
        end
        
        
        
        function DataUpdate(obj, src, evt)
            
            if CheckValue(evt.NewData, 'real', [0, inf])
                data = src.Data;
                data(evt.Indices(1), evt.Indices(2)) = evt.PreviousData;
                set(obj.table, 'Data', data);
                error('Value not valid')
            end
            
            % if fail use evt.PreviousData;
            idx = sub2ind(size(src.Data), evt.Indices(1), evt.Indices(2));
            
            switch obj.fullDescription
                case 'Node Diameter'
                    obj.parent.model.node.geo.diam.value.vec(idx) = evt.NewData;
                    obj.parent.model.node.seg.geo.diam.value.vec = ...
                        repmat(obj.parent.model.node.geo.diam.value.vec, 1, obj.parent.model.geo.nnodeseg);
                case 'Internode Diameter'
                    if obj.showSegments
                        obj.parent.model = UpdateInternodeSegmentDiameter(obj.parent.model, evt.NewData, evt.Indices(1), evt.Indices(2), obj.parent.myelinUpdateMethod);
                    else
                        obj.parent.model = UpdateInternodeSegmentDiameter(obj.parent.model, evt.NewData, idx, [], obj.parent.myelinUpdateMethod);
                    end
                case 'Node Length'
                    obj.parent.model.node.geo.length.value.vec(idx) = evt.NewData;
                    obj.parent.model.node.seg.geo.length.value.vec = ...
                        repmat(obj.parent.model.node.geo.length.value.vec / obj.parent.model.geo.nnodeseg, ...
                            1, obj.parent.model.geo.nnodeseg);
                case 'Internode Length'
                    if obj.showSegments
                        obj.parent.model = UpdateInternodeLength(obj.parent.model, evt.NewData, evt.Indices(1), evt.Indices(2));
                    else
                        obj.parent.model = UpdateInternodeLength(obj.parent.model, evt.NewData, idx);
                    end
                case 'Periaxonal Space'
                    if obj.showSegments
                    	obj.parent.model = UpdateInternodePeriaxonalSpaceWidth(obj.parent.model, evt.NewData, evt.Indices(1), evt.Indices(2), obj.parent.myelinUpdateMethod);
                    else
                        obj.parent.model = UpdateInternodePeriaxonalSpaceWidth(obj.parent.model, evt.NewData, [], idx, obj.parent.myelinUpdateMethod);
                    end
                case 'Active Conductance'
                    obj.parent.model.node.elec.act(obj.channelIdx).cond.value.vec(idx) = evt.NewData;
                    obj.parent.KineticsModuleUpdated();
            end
            
        end
        
        
        
        function data = ReturnData(obj)
            
            switch obj.fullDescription
                case 'Node Diameter'
                    data = obj.parent.model.node.geo.diam.value.vec;
                case 'Internode Diameter'
                    if obj.showSegments
                        data = obj.parent.model.intn.seg.geo.diam.value.vec;
                    else
                        data = obj.parent.model.intn.geo.diam.value.vec;
                    end
                case 'Node Length'
                    data = obj.parent.model.node.geo.length.value.vec;
                case 'Internode Length'
                    if obj.showSegments
                        data = obj.parent.model.intn.seg.geo.length.value.vec;
                    else
                        data = obj.parent.model.intn.geo.length.value.vec;
                    end
                case 'Periaxonal Space'
                    if obj.showSegments
                        data = obj.parent.model.myel.geo.peri.value.vec;
                    else
                        data = obj.parent.model.myel.geo.peri.value.vec(1, :);
                    end
                case 'Number of Lamellae'
                    data = obj.parent.model.myel.geo.numlamellae.value.vec;
                case 'Active Conductance'
                    obj.channelIdx = get(obj.parent.view.handles.actPop, 'Value');
                    data = obj.parent.model.node.elec.act(obj.channelIdx).cond.value.vec;
            end
        end
        
        
        function ShowSegmentCallback(obj, src, ~)
            obj.showSegments = src.Value;
            obj.DisplayTable();
        end
    end
end
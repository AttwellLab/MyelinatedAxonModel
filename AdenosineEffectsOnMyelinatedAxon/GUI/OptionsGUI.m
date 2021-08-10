function varargout = OptionsGUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OptionsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OptionsGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



function OptionsGUI_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;
set(handles.output, 'CloseRequestFcn', @(hObject, eventdata)OptionsGUI('figure1_CloseRequestFcn',hObject,eventdata,guidata(hObject)))
set(handles.output, 'Name', 'Parameter Selecter GUI');
handles.controller = varargin{1};
guidata(hObject, handles);



function varargout = OptionsGUI_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;



function plotNodesEdit_Callback(hObject, ~, handles) %#ok<*DEFNU>
handles.controller.NodesToPlot(hObject);



function legendCheck_Callback(~, ~, ~)



function startCVEdit_Callback(hObject, ~, handles)
handles.controller.CVFirstNode(hObject);



function finishCVEdit_Callback(hObject, ~, handles)
handles.controller.CVSecondNode(hObject);



function lastTwoCheck_Callback(~, ~, ~)



function CVMethodPop_Callback(hObject, ~, handles)
handles.controller.CVMethodUpdate(hObject);



function voltageCrossEdit_Callback(hObject, ~, handles)
handles.controller.VoltageCrossUpdate(hObject);



function figure1_CloseRequestFcn(~, ~, handles)
handles.controller.view.MakeInvisible();



function figure1_DeleteFcn(~, ~, handles)
delete(handles.output);



%%%%%%%%%%%%%% Create Fcn %%%%%%%%%%%%%%%%%%%%
function startCVEdit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function finishCVEdit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function CVMethodPop_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotNodesEdit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function voltageCrossEdit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

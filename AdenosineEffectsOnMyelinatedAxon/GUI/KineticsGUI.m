function varargout = KineticsGUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KineticsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @KineticsGUI_OutputFcn, ...
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


function KineticsGUI_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
set(handles.output, 'CloseRequestFcn', @(hObject, eventdata)KineticsGUI('figure1_CloseRequestFcn',hObject,eventdata,guidata(hObject)))
set(handles.output, 'Name', 'KineticsGUI');
handles.controller = varargin{1};
guidata(hObject, handles);


function varargout = KineticsGUI_OutputFcn(~, ~, handles)
varargout{1} = handles.output;


function figure1_CloseRequestFcn(~, ~, handles) %#ok<*DEFNU>
delete(handles.controller);



function popGateNo_Callback(hObject, ~, handles)
handles.controller.ChooseGate(hObject);



function pushbuttonAddGate_Callback(~, ~, handles)
handles.controller.AddGate();



function pushbuttonRemoveGate_Callback(~, ~, handles)
handles.controller.RemoveGate();



function editTemperature_Callback(hObject, ~, handles)
handles.controller.TemperatureUpdate(hObject);



function editGatePower_Callback(hObject, ~, handles)
handles.controller.GatePowerUpdated(hObject);



function editAlphaEquation_Callback(hObject, ~, handles)
handles.controller.AlphaEquationUpdate(hObject);



function editBetaEquation_Callback(hObject, ~, handles)
handles.controller.BetaEquationUpdate(hObject);



function editQ10_Callback(hObject, ~, handles)
handles.controller.Q10Update(hObject);


function editGateLabel_Callback(hObject, ~, handles)
handles.controller.GateLabelUpdate(hObject);


function editNGates_Callback(~, ~, ~)

function editNGates_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popGateNo_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editTemperature_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editGateLabel_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editGatePower_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editAlphaEquation_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editBetaEquation_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editQ10_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

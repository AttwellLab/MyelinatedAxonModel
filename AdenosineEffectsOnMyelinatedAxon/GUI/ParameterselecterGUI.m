function varargout = ParameterselecterGUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParameterselecterGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ParameterselecterGUI_OutputFcn, ...
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



function ParameterselecterGUI_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
set(handles.output, 'CloseRequestFcn', @(hObject, eventdata)ParameterselecterGUI('figure1_CloseRequestFcn',hObject,eventdata,guidata(hObject)))
set(handles.output, 'Name', 'Parameter Selecter GUI');
handles.controller = varargin{1};
guidata(hObject, handles);



function varargout = ParameterselecterGUI_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;



function figure1_CloseRequestFcn(~, ~, handles)
delete(handles.controller);



% ------------------------------------------------------------------------
% SIMULATION PARAMETERS
function dtEdit_Callback(hObject, ~, handles) %#ok<*INUSD,*DEFNU>
handles.controller.TimeStepUpdate(hObject);



function tmaxEdit_Callback(hObject, ~, handles)
handles.controller.TMaxUpdate(hObject);



function temperatureEdit_Callback(hObject, ~, handles)
handles.controller.TemperatureUpdate(hObject);
% SIMULATION PARAMETERS
% ------------------------------------------------------------------------




% ------------------------------------------------------------------------
% STIMULATION PARAMETERS
function stimAmpEdit_Callback(hObject, ~, handles)
handles.controller.StimulationAmplitudeUpdate(hObject)



function stimDurEdit_Callback(hObject, ~, handles)
handles.controller.StimulationDurationUpdate(hObject)


function stimAmpEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function stimDurEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% STIMULATION PARAMETERS
% ------------------------------------------------------------------------




% ------------------------------------------------------------------------
% ANATOMY PARAMETERS
function numNodesEdit_Callback(hObject, ~, handles)
handles.controller.NumberNodesUpdate(hObject);

function numInternodeSegEdit_Callback(hObject, ~, handles)
handles.controller.NumberInternodeSegmentsUpdate(hObject);

function nodeDiameterEdit_Callback(hObject, ~, handles)
handles.controller.NodeDiameterUpdate(hObject);

function internodeDiameterEdit_Callback(hObject, ~, handles)
handles.controller.InternodeDiameterUpdate(hObject);

function nodeLengthEdit_Callback(hObject, ~, handles)
handles.controller.NodeLengthUpdate(hObject);

function nodeNodeLengthEdit_Callback(hObject, ~, handles)
handles.controller.InternodeLengthUpdate(hObject);


function internodeLengthEdit_Callback(~, ~, ~)


function nodeDiameterButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Node Diameter');

function internodeDiameterButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Internode Diameter');

function nodeLength_Callback(~, ~, handles)
ArrayController(handles.controller, 'Node Length');

function nodeNodeLengthButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Internode Length');
%ERevButt added 2021-02-02 by Lorena Arancibia
function ERevButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'ERev');

function periaxonalSpaceButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Periaxonal Space');

function nLamellaeButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Number of Lamellae');

function activeCondButt_Callback(~, ~, handles)
ArrayController(handles.controller, 'Active Conductance');
% ANATOMY PARAMETERS
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% MYELIN ANATOMY PARAMETERS

function periaxonalSpaceEdit_Callback(hObject, ~, handles)
handles.controller.PeriaxonalSpaceUpdate(hObject);

function gRatioEdit_Callback(hObject, ~, handles)
handles.controller.GRatioUpdate(hObject);

function myelinPeriodicityEdit_Callback(hObject, ~, handles)
handles.controller.MyelinPeriodicityUpdate(hObject);

function popupmenuMyelinUpdateMethod_Callback(hObject, ~, handles)
handles.controller.MyelinUpdateMethod(hObject);
% MYELIN ANATOMY PARAMETERS
% ------------------------------------------------------------------------





% ------------------------------------------------------------------------
% PASSIVE ELECTRICAL PARAMETERS
function vrestEdit_Callback(hObject, ~, handles)
handles.controller.RestingPotentialUpdate(hObject);

function nodeCapacitanceEdit_Callback(hObject, ~, handles)
handles.controller.NodeCapacitanceUpdate(hObject);

function internodeCapacitanceEdit_Callback(hObject, ~, handles)
handles.controller.InternodeCapacitanceUpdate(hObject);

function nodeGLeakEdit_Callback(~, ~, ~)

function internodeGLeakEdit_Callback(hObject, ~, handles)
handles.controller.InternodeGLeakUpdate(hObject);

function nodeELeakEdit_Callback(hObject, ~, handles)
handles.controller.NodeELeakUpdate(hObject);

function nodeAxoplasmicResistivityEdit_Callback(hObject, ~, handles)
handles.controller.AxoplasmicResistivityUpdate(hObject);

function periaxonalResistivityEdit_Callback(hObject, ~, handles)
handles.controller.PeriaxonalResistivityUpdate(hObject);
% PASSIVE ELECTRICAL PARAMETERS
% ------------------------------------------------------------------------






% ------------------------------------------------------------------------
% ACTIVE ELECTRICAL PARAMETERS
function actPop_Callback(hObject, ~, handles)
handles.controller.ActiveConductancePopup(hObject);

function removeActButt_Callback(~, ~, handles)
handles.controller.RemoveActiveConductance();

function kineticsButt_Callback(~, ~, handles)
handles.controller.ViewKinetics();

function maxCondEdit_Callback(hObject, ~, handles)
handles.controller.MaximumConductanceUpdate(hObject);

function revPotEdit_Callback(hObject, ~, handles)
handles.controller.ActiveReversalPotentialUpdate(hObject);

function saveKineticsButt_Callback(~, ~, handles)
handles.controller.SaveActiveConductance();

function loadKineticsButt_Callback(~, ~, handles)
handles.controller.LoadActiveConductance();
% ACTIVE ELECTRICAL PARAMETERS
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% MYELIN ELECTRICAL PARAMETERS
function myelinCapacitanceEdit_Callback(hObject, ~, handles)
handles.controller.MyelinCapacitanceUpdate(hObject);

function myelinConductanceEdit_Callback(hObject, ~, handles)
handles.controller.MyelinConductanceUpdate(hObject);
% MYELIN ELECTRICAL PARAMETERS
% ------------------------------------------------------------------------



function plotCheck_Callback(~, ~, ~)

function printCVCheck_Callback(~, ~, ~)

function saveCheck_Callback(~, ~, ~)



function optionsButt_Callback(~, ~, handles)
handles.controller.ChooseOptions();



function runModelButt_Callback(~, ~, handles)
handles.controller.RunModel();



function saveParamsButt_Callback(~, ~, handles)
handles.controller.SaveModel();



function loadParamsButt_Callback(~, ~, handles)
handles.controller.LoadModel();
























function nodeGLeakPop_CreateFcn(~, ~, ~)
function internodeGLeakPop_CreateFcn(~, ~, ~)
function actSchemePop_CreateFcn(~, ~, ~)
function numNodesEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function numInternodeSegEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeDiameterEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function internodeDiameterEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeLengthEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeNodeLengthEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function internodeLengthEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function myelinCapacitanceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function myelinConductanceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function periaxonalSpaceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function gRatioEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function myelinPeriodicityEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dtEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tmaxEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function temperatureEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function vrestEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeCapacitanceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function internodeCapacitanceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeGLeakEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function internodeGLeakEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeELeakEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nodeAxoplasmicResistivityEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function periaxonalResistivityEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function actPop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function maxCondEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function revPotEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function myelinThicknessEdit_Callback(hObject, eventdata, handles)
function myelinThicknessEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function numLamellaeEdit_Callback(hObject, eventdata, handles)
function numLamellaeEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function myelinThicknessPop_Callback(hObject, eventdata, handles)
function myelinThicknessPop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenuMyelinUpdateMethod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function stimDelayEdit_Callback(hObject, ~, handles)
handles.controller.StimulationDelayUpdate(hObject);
% hObject    handle to stimDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimDelayEdit as text
%        str2double(get(hObject,'String')) returns contents of stimDelayEdit as a double


% --- Executes during object creation, after setting all properties.
function stimDelayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




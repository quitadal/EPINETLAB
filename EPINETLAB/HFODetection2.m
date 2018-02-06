%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function opens the GUI for settingparameters for the detection of 
% HFO either with standard Staba's detector method (Staba et al., 2010) 
% or with the CUSTOM wavelet-based method
% Authors: Lucia Quitadamo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = HFODetection2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HFODetection2_OpeningFcn, ...
                   'gui_OutputFcn',  @HFODetection2_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before HFODetection2 is made visible.
function HFODetection2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


set(handles.edit1, 'String','3')
set(handles.edit2, 'String','5')
set(handles.edit3, 'String','6')
set(handles.edit4, 'String','6')
set(handles.edit5, 'String','5')
set(handles.edit8, 'String','3')
set(handles.edit9, 'String','5')
set(handles.edit10, 'String','20')
set(handles.edit13, 'String', '3')

W = evalin('base','whos');
if isempty(W)
    set(handles.listbox1, 'String', 'Run Time-Frequency Analysis before HFO Detection', 'Value', [], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', 'red')
    set(handles.pushbutton1, 'Enable', 'off')   
    set(handles.pushbutton2, 'Enable', 'off')    
    set(handles.pushbutton4, 'Enable', 'off')    
    set(handles.pushbutton5, 'Enable', 'off') 
end


gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    set(handles.slider1, 'Min', 1, 'Max', 100, 'Value', 3, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider3, 'Min', 1, 'Max', 100, 'Value', 5, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider4, 'Min', 1, 'Max', 100, 'Value', 6, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider5, 'Min', 1, 'Max', 100, 'Value', 6, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider6, 'Min', 1, 'Max', 100, 'Value', 5, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider9, 'Min', 1, 'Max', 100, 'Value', 3, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider10, 'Min', 1, 'Max', 100, 'Value', 5, 'SliderStep', [1/(100-1) , 1/(100-1)] );
    set(handles.slider11, 'Min', 1, 'Max', 100, 'Value', 20, 'SliderStep', [1/(100-1) , 1/(100-1)] );
        
    set(handles.listbox1, 'String', 'Run Time-Frequency Analysis before HFO Detection', 'Value', [], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', 'red')
    set(handles.pushbutton1,  'Enable', 'off')
    set(handles.pushbutton2,  'Enable', 'off')
    set(handles.pushbutton4, 'Enable', 'off')
    set(handles.pushbutton5, 'Enable', 'off')

    assignin('base', 'WindowsIdx', 1)
else
    g1data = guidata(gui1);
    windLenMS= str2double(get(g1data.edit2, 'String'));
    mSec= windLenMS*1000;
    set(handles.slider1, 'Min', 1, 'Max', mSec, 'Value', 3, 'SliderStep', [1/(mSec-1) , 1/(mSec-1)]);
    set(handles.slider3, 'Min', 1, 'Max', 20, 'Value', 5, 'SliderStep', [1/(20-1) , 1/(20-1)]);
    set(handles.slider4, 'Min', 1, 'Max', mSec, 'Value', 6, 'SliderStep', [1/(mSec-1) , 1/(mSec-1)]);
    set(handles.slider5, 'Min', 1, 'Max', 20, 'Value', 6, 'SliderStep', [1/(20-1) , 1/(20-1)]);
    set(handles.slider6, 'Min', 1, 'Max', 20, 'Value', 5, 'SliderStep', [1/(20-1) , 1/(20-1)]);
    set(handles.slider9, 'Min', 1, 'Max', mSec, 'Value', 3, 'SliderStep', [1/(mSec-1) , 1/(mSec-1)]);
    set(handles.slider10, 'Min', 1, 'Max', 20, 'Value', 5, 'SliderStep', [1/(20-1) , 1/(20-1)]);
    set(handles.slider11, 'Min', 1, 'Max', mSec, 'Value', 20, 'SliderStep', [1/(mSec-1) , 1/(mSec-1)]);
      
    chIdx= get(g1data.listbox1,'Value');
    chList= get(g1data.listbox1, 'String');
    
    for i= 1:length(chIdx)
        chSel{1,i}= chList{chIdx(i),1};
    end
    set(handles.listbox1, 'String', chSel, 'Value', [])

    nWind= evalin('base', 'nWind');
    assignin('base', 'WindowsIdx', 1:nWind)
end


set(handles.checkbox1, 'Value', 1)
set(handles.checkbox2, 'Value', 1)


function varargout = HFODetection2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox1_Callback(hObject, eventdata, handles)


function pushbutton4_Callback(hObject, eventdata, handles)
chSel2= get(handles. listbox1, 'String');
nCh= length(chSel2);
set(handles.listbox1, 'Value', 1:nCh)


function pushbutton5_Callback(hObject, eventdata, handles)
chSel= get(handles.listbox1, 'String');
[filename, filepath]= uigetfile('*.txt','Select the channels after kurtosis');
if filename == 0
    return
end

fid= fopen([filepath filename], 'r');
tmp = textscan(fid,'%s','Delimiter','\t');
nR= size(tmp{1,1},1);
nChKurt= str2num(tmp{1,1}{nR,1});

idx= [4:2:(nR-10)];
nChFile= length(idx);

if nChFile~= length(chSel)
    warndlg('Number of channels in the imported channels is different from channels in the original file', 'Wrong file selected')
    return
end


for i=1:length(idx)
   idxCh(i)= str2num(tmp{1,1}{idx(i),1}); 
end

finalCh= idxCh(1:nChKurt);
finalChOrd= sort(finalCh);
set(handles.listbox1, 'Value', finalChOrd)
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RMS Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider1_Callback(hObject, eventdata, handles)
RMSWind= get(hObject, 'Value');
set(handles.edit1, 'String', num2str(RMSWind))
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider3_Callback(hObject, eventdata, handles)
SDThresh= get(hObject, 'Value');
set(handles.edit2, 'String', num2str(SDThresh))
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider4_Callback(hObject, eventdata, handles)
RMSDuration= get(hObject,'Value');
set(handles.edit3, 'String', num2str(RMSDuration))
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectified EEG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider5_Callback(hObject, eventdata, handles)
nPeaks= get(hObject, 'Value');
set(handles.edit4,'String', num2str(nPeaks))
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider6_Callback(hObject, eventdata, handles)
RectThresh= get(hObject, 'Value');
set(handles.edit5, 'String', num2str(RectThresh))
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set parameter of the CUSTOM Wavelet-based Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider9_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider9_Callback(hObject, eventdata, handles)
KWind= get(hObject, 'Value');
set(handles.edit8, 'String', num2str(KWind))
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider10_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider10_Callback(hObject, eventdata, handles)
KSDThresh= get(hObject, 'Value');
set(handles.edit9, 'String', num2str(KSDThresh))
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider11_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider11_Callback(hObject, eventdata, handles)
KDuration= get(hObject,'Value');
set(handles.edit10, 'String', num2str(KDuration))
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checkboxes for artifact detection. If checkbox 1 is selected, all the HFO
% detected at least on half the available channles are detected as
% artifacts and removed (can be due to noise spread on different channels
% due to common reference). Il checkbox2 is selected, al the HFOs spreading
% over all the avilable frequencies are detected as artefacts and removed (
% can be due to sharp transient or DC-shift). If both checkboxes are selected, 
% both the removal activites are performed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function checkbox1_Callback(hObject, eventdata, handles)
function checkbox2_Callback(hObject, eventdata, handles)

function edit13_Callback(hObject, eventdata, handles)
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON 1 starts the computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)

EEG= evalin('base', 'dataNew');
SR= evalin('base', 'EEG.srate');
nWind= evalin('base', 'nWind');

chDet= get(handles.listbox1, 'Value');
if isempty(chDet)
    warndlg('Please select channels', 'Channel Selection')
    return
end
chList= get(handles.listbox1, 'String');
chListDet= chList(chDet,1);
RMSWind= str2double(get(handles.edit1, 'String'));
SDThresh= str2double(get(handles.edit2, 'String'));
RMSDuration= str2double(get(handles.edit3, 'String'));

nPeaks= str2double(get(handles.edit4, 'String'));
RectThresh= str2double(get(handles.edit5, 'String'));
gui1 = findobj('Tag','GUI1');
if isempty(gui1)
        warndlg('You have errouneously closed TimeFrequency GUI, please re-run it', 'HFO Detection')
        return
end
g1data = guidata(gui1);
windLenMS= str2double(get(g1data.edit2, 'String'));
windLen= ceil(windLenMS*SR);
windOverMS= str2double(get(g1data.edit3, 'String'));
windOver= ceil(windOverMS*SR);

inspInterv1= get(g1data.edit4, 'String');
intDur= evalin('base', 'EEG.pnts');

if strcmp(inspInterv1,'all')
    inspIntervLim1= 1;
    inspIntervLim2= intDur;
else
    intInter= str2num(inspInterv1);
    inspIntervLim1 = ceil(SR* intInter(1)) +1;
    inspIntervLim2 = ceil(SR* intInter(2));
end

inspInterv= [inspIntervLim1 inspIntervLim2];

StabaHFODetection(EEG, chDet, chListDet,  RMSDuration, RMSWind, SDThresh, nPeaks, RectThresh, windLen, windOver, nWind, SR, inspInterv)

ArtRem1 = get(handles.checkbox1,'Value');
ArtRem2 = get(handles.checkbox2,'Value');

scalMx= evalin('base', 'scalMx');
    
KWind= str2double(get(handles.edit8, 'String'));
KSDThresh= str2double(get(handles.edit9, 'String'));
KDuration= str2double(get(handles.edit10, 'String'));

WindowsIdx= evalin('base', 'WindowsIdx');
nChArt= str2num(get(handles.edit13, 'String'));
MyHFODetection(ArtRem1,nChArt, ArtRem2, scalMx, chDet, chListDet,windLen, windOver, nWind, SR, inspInterv, KWind, KSDThresh, KDuration, WindowsIdx)


function pushbutton2_Callback(hObject, eventdata, handles)
HFODetectionDisplay

function pushbutton3_Callback(hObject, eventdata, handles)
close(gcf)
disp= findobj('Name', 'HFODetectionDisplay');
if ~ isempty(disp)
    close(disp)
end

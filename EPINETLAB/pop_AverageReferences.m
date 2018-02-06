function varargout = pop_AverageReferences(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_AverageReferences_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_AverageReferences_OutputFcn, ...
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


% --- Executes just before pop_AverageReferences is made visible.
function pop_AverageReferences_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

W = evalin('base','whos');

if isempty(W)
    set(handles.listbox1, 'String', [], 'Value', [])
    set(handles.edit3, 'String', [], 'Enable', 'inactive')
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if inBase==0
    chLocs= [];
    set(handles.listbox1, 'String', [],' Value', []);
    set(handles.edit3, 'String', [], 'Enable', 'inactive')
else
    chLocs= evalin('base','EEG.chanlocs');
    data= evalin('base','EEG.data');
    if isempty(chLocs)
        if isempty(data)
            varargout{1}=[];
            varargout{2} ='';
            guiav= findobj('Tag', 'AVREF');
            delete(guiav)
            warndlg('Please, load data before!', 'Average Reference warning')
            return
        else
            nCh= evalin('base', 'EEG.nbchan');
            for i=1:nCh
                if i < 10
                    chList{i}= ['Ch0' num2str(i)];
                else
                    chList{i}= ['Ch' num2str(i)];
                end
            end
        end
    else
        nCh= length(chLocs);
        for i=1: nCh
            chList{i}= chLocs(i).labels;
        end
    end
    
    if nCh <= 2
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', 3,'Value', []);
    else
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nCh,'Value', []);
    end
    set(handles.edit3, 'String', num2str(nCh), 'Enable', 'inactive')
end

set(handles.edit1,  'String', [], 'Enable', 'on')
set(handles.edit14, 'String', [], 'Enable', 'inactive')
set(handles.listbox2,'String', []);

uiwait();

% --- Outputs from this function are returned to the command line.
function varargout = pop_AverageReferences_OutputFcn(hObject, eventdata, handles) 
if isempty(handles)
    varargout{1}= [];
    varargout{2}= '';
    guiav= findobj('Tag', 'AVREF');
    delete(guiav)
    return
else
    varargout{1} = handles.EEG;
    varargout{2} = handles.command;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function listbox1_Callback(hObject, eventdata, handles)

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton1_Callback(hObject, eventdata, handles)
LB1= get(handles.listbox1, 'String');
nCh= length(LB1);
set(handles.listbox1, 'Value', 1:nCh)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create AR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit14_Callback(hObject, eventdata, handles)
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton14_Callback(hObject, eventdata, handles)
nLB1= get(handles.listbox1, 'Value');
nSel= length(nLB1);
set(handles.edit14, 'String', num2str(nSel))
set(handles.edit1, 'String', [])

function pushbutton2_Callback(hObject, eventdata, handles)
LB1= get(handles.listbox1, 'String');
nCh= length(LB1);
ED1= get(handles.edit1, 'String');
LB1new= [LB1; ED1];
set(handles.listbox1, 'String', LB1new)
set(handles.edit3, 'String', num2str(nCh+1))

LB1Val= get(handles.listbox1, 'Value');
if length(LB1Val) == 1
     warndlg('You need at least two channels/contacts to create an average reference channel', 'Average reference warning!')
    return
end

EEG= evalin('base', 'EEG');
data= EEG.data;
chLocs= EEG.chanlocs;

AR= mean(data(LB1Val,:));
ARLabel= get(handles.edit1, 'String');

if isempty(ARLabel)
    warndlg('Please insert a label for the average reference channel', 'Average reference warning!')
    return
end

dataNew= [data; AR];
chLocs(nCh+1).labels= ARLabel;

EEG.data= dataNew;
EEG.nbchan= nCh+1;
EEG.chanlocs= chLocs;

assignin('base', 'EEG', EEG)

LB2Str= [ARLabel ' was created from channels/contacts ' strjoin(LB1(LB1Val))];
LB2= get(handles.listbox2, 'String');

if isempty(LB2)
    nRowsStr= 0;
    LB2= {[]};
else
    nRowsStr= size(LB2,1);
end
LB2{nRowsStr+1,:} = LB2Str;
set(handles.listbox2, 'String', LB2, 'Value', [], 'Min',1, 'Max', 20)

function listbox2_Callback(hObject, eventdata, handles)
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton8_Callback(hObject, eventdata, handles)
EEG= evalin('base', 'EEG');
EEG.setname= [EEG.setname '_AR'];
EEG.filename= [EEG.filename(1:end-4)  '_AR.set'];

[EEG] = eeg_checkset(EEG);

handles.EEG= EEG;
handles.command= '';
guidata(hObject,handles);
uiresume();

function pushbutton9_Callback(hObject, eventdata, handles)
uiresume();
guiav= findobj('Tag', 'AVREF');
delete(guiav)
return

function AVREF_CloseRequestFcn(hObject, eventdata, handles)
EEG= [];
command= '';
handles.EEG= EEG;
handles.command= command;
guidata(hObject,handles);
uiresume();
guiav= findobj('Tag', 'AVREF');
delete(guiav)




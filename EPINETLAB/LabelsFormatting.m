function varargout = LabelsFormatting(varargin)
% LABELSFORMATTING MATLAB code for LabelsFormatting.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LabelsFormatting_OpeningFcn, ...
                   'gui_OutputFcn',  @LabelsFormatting_OutputFcn, ...
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


% --- Executes just before LabelsFormatting is made visible.
function LabelsFormatting_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

W = evalin('base','whos');

if isempty(W)
    set(handles.listbox1, 'String', [], 'Value', [])
    set(handles.edit10, 'String', '10', 'Enable', 'inactive')
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if inBase==0
    chLocs= [];
   % assignin('base', 'ALLEEG', [])
    set(handles.listbox1, 'String', [],' Value', []);
    set(handles.edit10, 'String', '10', 'Enable', 'inactive')
else
    chLocs= evalin('base','EEG.chanlocs');
    data= evalin('base','EEG.data');
    if isempty(chLocs)
        if isempty(data)
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
    
   % assignin('base', 'ALLEEG', [])
    if nCh <= 2
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', 3,'Value', []);
    else
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nCh,'Value', []);
    end
    set(handles.edit10, 'String', num2str(nCh), 'Enable', 'inactive')
end

set(handles.edit2, 'String', [])
set(handles.edit4, 'String', [])
set(handles.edit6, 'String', [])
set(handles.edit7, 'String', [])

function varargout = LabelsFormatting_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton9_Callback(hObject, eventdata, handles)
LB1= get(handles.listbox1, 'String');
nCh= length(LB1);
set(handles.listbox1, 'Value', 1:nCh)

function listbox1_Callback(hObject, eventdata, handles)

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton4_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end

ED2= str2num(get(handles.edit2, 'String'));
if isempty(ED2)
    warndlg('Wrong number of characters', 'Select characters to remove from the end of labels')
    return
end

nCh= length(LB1String);
EEG= evalin('base', 'EEG');
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end

for i=1:length(LB1Value)
    lb= EEG.chanlocs(LB1Value(i)).labels;
    lbNew= lb(1:end-ED2);
    EEG.chanlocs(LB1Value(i)).labels= lbNew;
    Labels{LB1Value(i)}= lbNew;    
end

[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])


function pushbutton5_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end

ED4= str2num(get(handles.edit4, 'String'));
if isempty(ED4)
    warndlg('Wrong number of characters', 'Select characters to remove from the end of labels')
    return
end

nCh= length(LB1String);
EEG= evalin('base', 'EEG');
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end

for i=1:length(LB1Value)
    lb= EEG.chanlocs(LB1Value(i)).labels;
    lbNew= lb;
    lbNew(1:ED4)= '';
    EEG.chanlocs(LB1Value(i)).labels= lbNew;
    Labels{LB1Value(i)}= lbNew;    
end
[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])


function pushbutton6_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end


nCh= length(LB1String);
EEG= evalin('base', 'EEG');
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end

for i=1:length(LB1Value)
    lb= EEG.chanlocs(LB1Value(i)).labels;
    spaceChar= strfind(lb, ' ');
    lbNew= lb;
    if ~isempty(spaceChar)
        lbNew(spaceChar)= '';
    end
   
    EEG.chanlocs(LB1Value(i)).labels= lbNew;
    Labels{LB1Value(i)}= lbNew;    
end
[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])




function pushbutton7_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end

ED6= get(handles.edit6, 'String');
if isempty(ED6)
    warndlg('Insert the character to remove', 'Select channels')
    return
end
    

nCh= length(LB1String);
EEG= evalin('base', 'EEG');
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end

for i=1:length(LB1Value)
    lb= EEG.chanlocs(LB1Value(i)).labels;
    lbNew= lb;
    for c= 1:length(ED6)
        spaceChar= strfind(lbNew, ED6(c));
        
        if ~isempty(spaceChar)
            lbNew(spaceChar)= '';
        end
        
    end
    EEG.chanlocs(LB1Value(i)).labels= lbNew;
    Labels{LB1Value(i)}= lbNew;    
end

[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])



function pushbutton10_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end

ED8= get(handles.edit8, 'String');
if isempty(ED8)
    warndlg('Insert the character to remove', 'Select channels')
    return
end
ED9= get(handles.edit9, 'String');
if isempty(ED9)
    warndlg('Insert the character to remove', 'Select channels')
    return
end
  
if length(ED8)>1 || length(ED9)>1
    warndlg('Please replace one charcter per time', 'Select channels')
    return
end

nCh= length(LB1String);
EEG= evalin('base', 'EEG');
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end

for i=1:length(LB1Value)
    lb= EEG.chanlocs(LB1Value(i)).labels;
    lbNew= lb;
    spaceChar= strfind(lbNew, ED8);
        
    if ~isempty(spaceChar)
        lbNew(spaceChar)= ED9;
    end

    EEG.chanlocs(LB1Value(i)).labels= lbNew;
    Labels{LB1Value(i)}= lbNew;    
end
[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])


function pushbutton3_Callback(hObject, eventdata, handles)

[filename, filepath]= uigetfile('*.txt','Select the Labels file');
if filename==0
    return
end

set(handles.edit7, 'String', [filepath filename])


function pushbutton8_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
ED7= get(handles.edit7, 'String');
if isempty(ED7)
    warndlg('Please select labels file', 'Select labels')
    return
end

fid= fopen(ED7, 'r');
M= textscan(fid, '%s');

nChExt= size(M{1,1},1);
nCh= length(LB1String);

if nChExt ~= nCh
    warndlg({'Number of channels in text file different from number of channels in the file'; '(NB. Please note that labels in .txt file should be listed in column format)'}, 'Select labels')
    return
end

EEG= evalin('base', 'EEG');

for i=1:nCh
   EEG.chanlocs(i).labels= M{1,1}{i,1}; 
end

[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', M{1,1})
  

function edit8_Callback(hObject, eventdata, handles)
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)
function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton11_Callback(hObject, eventdata, handles)
LB1String= get(handles.listbox1, 'String');
LB1Value= get(handles.listbox1, 'Value');
ED11= get(handles.edit11, 'String');

if isempty(LB1String) || isempty(LB1Value)
    warndlg('Either channel list is empty or you need to select the channels to modify', 'Select channels')
    return
end

if length(LB1Value) > 1
    warndlg('This command can be applied just to one channel per time, otherwise you will have more than one channel with the same name', 'Select channels')
    return
end   
    
if isempty(ED11)
    warndlg('Channel label cannot be empty', 'Select channels')
    return
end
    
EEG= evalin('base', 'EEG');
EEG.chanlocs(LB1Value).labels= ED11;
nCh= EEG.nbchan;
for i=1:nCh
    Labels{i}= EEG.chanlocs(i).labels;
end


[EEG]= eeg_checkset(EEG, 'chanconsist'); 
assignin('base','EEG', EEG)
set(handles.listbox1, 'String', Labels, 'Value', [])


function pushbutton2_Callback(hObject, eventdata, handles)
close(gcf)

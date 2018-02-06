function varargout = SeizureFrequencyContent(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SeizureFrequencyContent_OpeningFcn, ...
    'gui_OutputFcn',  @SeizureFrequencyContent_OutputFcn, ...
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before SeizureFrequencyContent is made visible.
function SeizureFrequencyContent_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

set(handles.radiobutton2, 'Value', 0)
set(handles.radiobutton3, 'Value', 0)
set(handles.radiobutton4, 'Value', 0)

set(handles.edit8, 'String', [])
set(handles.edit9, 'String', [])
set(handles.edit10, 'String', [])
set(handles.edit11, 'String', [])

set(handles.popupmenu1, 'String', {[]})
set(handles.popupmenu2, 'String', {[]})

set(handles.slider1, 'Enable', 'off')
set(handles.slider2, 'Enable', 'off')

W = evalin('base','whos');
if isempty(W)
    inBase= 0;
    set(handles.listbox1, 'String', [],' Value', []);
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if inBase==0
    chLocs= [];
    assignin('base', 'ALLEEG', [])
    set(handles.listbox1, 'String', [],'Value', []);
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
    filename= evalin('base', 'EEG.filename');
    filepath= evalin('base', 'EEG.filepath');
    
    if isempty (filename) || isempty(filepath)
        strDisp= [];
    else
        if strcmp(filepath(end), filesep)
            strDisp= [filepath filename];
        else
            strDisp= [filepath filesep filename];
        end
    end
    assignin('base', 'ALLEEG', [])
    set(handles.edit1, 'String', strDisp)
    if nCh <= 2
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', 3, 'Value', [])
    else
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nCh,'Value', [])
    end
    
    
    eventStruct= evalin('base', 'EEG.event');
    if isempty(eventStruct)
        set(handles.popupmenu1, 'Enable', 'inactive', 'String', {[]})
        set(handles.popupmenu2, 'Enable', 'inactive', 'String', {[]})
    else
        for i=1:size(eventStruct,2)
            events{i}= eventStruct(i).type;
        end
        set(handles.popupmenu1, 'String', events)
        set(handles.popupmenu2, 'String', events)
    end
    
    
    slMin= 1;
    slMax= round(evalin('base', 'EEG.srate')/2);
    set(handles.slider1, 'Min', slMin, 'Max', slMax, 'SliderStep', [1/(slMax-slMin) , 1/(slMax-slMin)], 'Value', 1, 'Enable', 'on')
    set(handles.slider2, 'Min', slMin, 'Max', slMax, 'SliderStep', [1/(slMax-slMin) , 1/(slMax-slMin)], 'Value', slMax, 'Enable', 'on')
    set(handles.edit10, 'String', 1)
    set(handles.edit11, 'String', slMax)
end



function varargout = SeizureFrequencyContent_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton1_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.set', 'Select .set file');

if ischar(filename) == 0 && ischar(filepath) == 0
    return
else
    strDispl= [filepath filename];
    set(handles.edit1, 'String', strDispl);
end
if exist('pop_loadset.m', 'file') == 0
    eeglab
end
EEG = pop_loadset(strDispl);
ALLEEG= evalin('base', 'ALLEEG');
CURRENTSET= size(ALLEEG, 2);
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);

assignin('base', 'EEG', EEG)
assignin('base', 'ALLEEG', ALLEEG)
assignin('base', 'CURRENTSET', CURRENTSET)

eeglab redraw
chLocs= EEG.chanlocs;

if isempty(chLocs)
    nCh= evalin('base', 'EEG.nbchan');
    for i=1:nCh
        if i < 10
            chList{i}= ['Ch0' num2str(i)];
        else
            chList{i}= ['Ch' num2str(i)];
        end
    end
else
    nCh= length(chLocs);
    for i=1: nCh
        chList{i,1}= chLocs(i).labels;
    end
end
if nCh == 1
    set(handles.listbox1, 'String', chList, 'Value', [])
else
    set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nCh,'Value', [])
end
eventStruct= EEG.event;
if isempty(eventStruct)
    set(handles.popupmenu1, 'Enable', 'inactive', 'String', {[]})
    set(handles.popupmenu2, 'Enable', 'inactive', 'String', {[]})
else
    for i=1:size(EEG.event,2)
        events{i}= EEG.event(i).type;
    end
    set(handles.popupmenu1, 'String', events)
    set(handles.popupmenu2, 'String', events)
end
srate= EEG.srate;

set(handles.slider1, 'Enable', 'on')
set(handles.slider2, 'Enable', 'on')
set(handles.edit10, 'String', num2str(1))
set(handles.edit11, 'String', num2str(fix(srate/2)))


function edit1_Callback(hObject, eventdata, handles)
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton2_Callback(hObject, eventdata, handles)
chList= get(handles.listbox1, 'String');
if isempty(chList)
    warndlg('Please select EEG file','!! Warning !!')
else
    set(handles.listbox1, 'Value', 1:length(chList))
end


function radiobutton2_Callback(hObject, eventdata, handles)
RB2= get(hObject, 'Value');
if RB2 == 1
    set(handles.radiobutton3, 'Value', 0);
    set(handles.edit8, 'Enable', 'off', 'String', [])
    set(handles.edit9, 'Enable', 'off', 'String', [])
    
    set(handles.radiobutton4, 'Value', 0);
    set(handles.popupmenu1, 'Enable', 'off')
    set(handles.popupmenu2, 'Enable', 'off')
end

function radiobutton3_Callback(hObject, eventdata, handles)
RB3= get(hObject, 'Value');
if RB3 == 1
    set(handles.radiobutton2, 'Value', 0);
    set(handles.edit8, 'Enable', 'on')
    set(handles.edit9, 'Enable', 'on')
    
    set(handles.radiobutton4, 'Value', 0);
    set(handles.popupmenu1, 'Enable', 'off')
    set(handles.popupmenu2, 'Enable', 'off')
else
    set(handles.edit8, 'Enable', 'off')
    set(handles.edit9, 'Enable', 'off')
    
end

function radiobutton4_Callback(hObject, eventdata, handles)
RB4= get(hObject, 'Value');
if RB4 == 1
    set(handles.radiobutton2, 'Value', 0);
    set(handles.popupmenu1, 'Enable', 'on')
    set(handles.popupmenu2, 'Enable', 'on')
    
    set(handles.radiobutton3, 'Value', 0);
    set(handles.edit8, 'Enable', 'off', 'String', [])
    set(handles.edit9, 'Enable', 'off', 'String', [])
else
    set(handles.popupmenu1, 'Enable', 'off')
    set(handles.popupmenu2, 'Enable', 'off')
    
end


function popupmenu1_Callback(hObject, eventdata, handles)
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu2_Callback(hObject, eventdata, handles)
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit8_Callback(hObject, eventdata, handles)
ED8= str2num(get(hObject, 'String'));
if isempty(ED8)
    return
end

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_Callback(hObject, eventdata, handles)
ED9= str2num(get(hObject, 'String'));
if isempty(ED9)
    return
end


function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider1_Callback(hObject, eventdata, handles)
SL1= get(hObject, 'Value');

set(hObject, 'Value', SL1)
set(handles.edit10, 'String', num2str(SL1))

function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider2_Callback(hObject, eventdata, handles)
SL2= get(hObject, 'Value');
set(hObject, 'Value', SL2)
set(handles.edit11, 'String', num2str(SL2))

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit10_Callback(hObject, eventdata, handles)
ED10= str2num(get(hObject, 'String'));
if isempty(ED10)
    return
end
SL1Max= get(handles.slider1, 'Max');
if ~isempty(ED10) &&  ED10 <= SL1Max
    set(handles.slider1, 'Value', ED10);
else
    set(hObject, 'String', num2str(SL1Max))
    set(handles.slider1, 'Value', SL1Max);
end


function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit11_Callback(hObject, eventdata, handles)
ED11= str2num(get(hObject, 'String'));
if isempty(ED11)
    return
end
SL2Max= get(handles.slider2, 'Max');
if ~isempty(ED11)&&  ED11 <= SL2Max
    set(handles.slider2, 'Value', ED11);
else
    set(hObject, 'String', num2str(SL2Max))
    set(handles.slider2, 'Value', SL2Max);
end

function pushbutton3_Callback(hObject, eventdata, handles)
fileToOpen= get(handles.edit1, 'String');
if isempty(fileToOpen) && isempty(get(handles.listbox1, 'String'))
    warndlg('Please select EEG file','!! Warning !!')
    return
end
if isempty(fileToOpen)
    EEG= evalin('base', 'EEG')
else
    EEG = pop_loadset(fileToOpen);
end
[nCh, nPnt]= size(EEG.data);
SR= EEG.srate;

chIdx= get(handles.listbox1,'Value');
if isempty(chIdx)
    warndlg('Please select channels','!! Warning !!')
    return
end
chList= get(handles.listbox1, 'String');
for i= 1:length(chIdx)
    chSel{i}= chList{chIdx(i),1};
end

%DATACH= EEG.data(chIdx,:);

RB2= get(handles.radiobutton2, 'Value');
RB3= get(handles.radiobutton3, 'Value');
RB4= get(handles.radiobutton4, 'Value');


if RB2== 0 && RB3==0 && RB4==0
    warndlg ('Select segmentation modality', 'Select segmentation')
    return
elseif RB2== 1 && RB3==0 && RB4==0
    tstart= 1;
    tend= nPnt;
    
elseif RB2== 0 && RB3==1 && RB4==0
    t1= str2num(get(handles.edit8, 'String'));
    t2= str2num(get(handles.edit9, 'String'));
    
    if isempty(t1) || (t1 < 0) || [t1 > (nPnt/SR)] || (t1 >= t2)
        warndlg ('Bad selection of t1, please change it', 'Select t1')
        return
    elseif isempty(t2)|| (t2 < 0) || [t2 > (nPnt/SR)] || (t2 <= t1)
        warndlg ('Bad selection of t2, please change it', 'Select t2')
        return
    end
    
    tstart= fix(t1 *SR);
    if tstart==0
        tstart=1;
    end
    tend= fix(t2 *SR);
    
elseif RB2== 0 && RB3==0 && RB4==1
    events= get(handles.popupmenu1, 'String');
    PU1= get(handles.popupmenu1, 'Value');
    PU2= get(handles.popupmenu2, 'Value');
    
    if PU1 == PU2
        warndlg('Event 1 cannot be the same as Event 2', 'Select Events')
        return
    end
    
    e1= events{PU1};
    e2= events{PU2};
    
    eventMx= EEG.event;
    for i=1:size(eventMx,2)
        ise1= strcmp(eventMx(i).type, e1);
        
        if ise1
            tstart= eventMx(i).latency;
            if length(tstart)> 1
                warndlg('Multiple events with the same name!', 'Select event')
                return
            end
        end
        ise2= strcmp(eventMx(i).type, e2);
        if ise2
            tend= eventMx(i).latency;
            if length(tend)> 1
                warndlg('Multiple events with the same name!', 'Select event')
                return
            end
        end
    end
    
    if tstart>=tend
        warndlg('Please select correct events', 'Select event')
        return
    end
end
f1= str2num(get(handles.edit10, 'String'));
f2= str2num(get(handles.edit11, 'String'));

if f1>=f2
    warndlg('Please select correct frequencies', 'Select frequency')
    return
end

if f2 == round(evalin('base', 'EEG.srate')/2);
    warndlg('Higher passband edge (f2) should be lower than Nyquist frequency', 'Select frequency')
    return
end

[EEGfilt, ~, ~] = pop_eegfiltnew(EEG, f1, f2);

myWavComput(EEGfilt.data, SR, chIdx, chSel, [tstart tend], (tend-tstart), 0, [f1 f2], 'cmor1-1.5') ;


function pushbutton5_Callback(hObject, eventdata, handles)
SeizureFrequencyContentDisplay


function pushbutton4_Callback(hObject, eventdata, handles)
close(gcf)
disp= findobj('Name', 'SeizureFrequencyContentDisplay');
if ~isempty(disp)
    close(disp)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function allows to create a Bipolar Montage either from an external
% file or from a .set file already loaded in EEGLab. Also an external .txt
% file can be loaded.
% Author: Lucia Rita Quitadamo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = pop_BipolarMontage(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_BipolarMontage_OpeningFcn, ...
    'gui_OutputFcn',  @pop_BipolarMontage_OutputFcn, ...
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

% --- Executes just before BipolarMontage is made visible.
function pop_BipolarMontage_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

set(handles.listbox1, 'String', [], 'Value', 1);
set(handles.listbox2, 'String', [], 'Value', 1);
set(handles.listbox3, 'String', [], 'Value', 1);
set(handles.pushbutton9, 'Enable', 'Off')

W = evalin('base','whos');

if isempty(W)
    set(handles.edit3, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit4, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit5, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit6, 'String', [])
    return
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if any(inBase)
    EEG= evalin('base', 'EEG');
    [~, isEEG]= eeg_checkset(EEG, 'data');
    
    if strcmp(isEEG,'no')
        set(handles.pushbutton5, 'Enable', 'On')
        set(handles.pushbutton6, 'Enable', 'On')
        set(handles.pushbutton2, 'Enable', 'Off')
        set(handles.pushbutton3, 'Enable', 'Off')
        set(handles.edit3, 'String', 0, 'Enable', 'Inactive')
        set(handles.edit4, 'String', 0, 'Enable', 'Inactive')
        set(handles.edit5, 'String', 0, 'Enable', 'Inactive')
        return
    else
        chLocs= evalin('base', 'EEG.chanlocs');
        if isempty(chLocs)
            if isempty(EEG.data)
                varargout{1}=[];
                varargout{2} ='';
                guibip= findobj('Tag', 'BipolarMontage');
                delete(guibip)
                warndlg('Please, load data before!', 'Bipolar Montage warning')
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
        
        set(handles.listbox1, 'String', chList,  'Min', 1, 'Max', 1, 'Value', 1)
        set(handles.listbox2, 'String', chList,  'Min', 1, 'Max', 1, 'Value', 1)
        set(handles.edit3, 'String', num2str(size(EEG.data,1)), 'Enable', 'Inactive')
        set(handles.edit4, 'String', num2str(size(EEG.data,1)), 'Enable', 'Inactive')
        
        fp= evalin('base', 'EEG.filepath');
        if ~isempty (fp)
            if strcmp(evalin('base', 'EEG.filepath(end)'), filesep)
                set(handles.edit6, 'String', [evalin('base', 'EEG.filepath') evalin('base', 'EEG.filename')])
            else
                set(handles.edit6, 'String', [evalin('base', 'EEG.filepath') filesep evalin('base', 'EEG.filename')])
            end
        else
            set(handles.edit6, 'String', '')
            warning('It is recommended to save loaded file as .set before any operation', 'Save file')
        end
        
        set(handles.pushbutton5, 'Enable', 'Off')
        set(handles.pushbutton6, 'Enable', 'On')
        set(handles.pushbutton9, 'Enable', 'On')
        
        set(handles.edit5, 'String', 0, 'Enable', 'Inactive')
        
    end
else
    set(handles.pushbutton2, 'Enable', 'Off')
    set(handles.pushbutton3, 'Enable', 'Off')
    set(handles.pushbutton4, 'Enable', 'Off')
    set(handles.pushbutton5, 'Enable', 'Off')
    set(handles.pushbutton6, 'Enable', 'On')
    set(handles.edit3, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit4, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit5, 'String', 0, 'Enable', 'Inactive')
    set(handles.edit6, 'String', [])
end

uiwait();


function varargout = pop_BipolarMontage_OutputFcn(hObject, eventdata, handles)
if isempty(handles)
    varargout{1}=[];
else
    varargout{1} = handles.EEG;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EDIT BOX FOR VIEWING THE NAME OF THE LOADED FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LISTBOX FOR SELECTING THE FIRST CHANNEL OF THE BIPOLAR MONTAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox1_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EDITBOX FOR VIEWING THE NUMBER OF CHANNELS IN THE LOADED FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LISTBOX FOR SELECTING THE SECOND CHANNEL OF THE BIPOLAR MONTAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox2_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EDITBOX FOR VIEWING THE NUMBER OF CHANNELS IN THE LOADED FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LISTBOX FOR DISPLAYING THE ACTUAL CHANNELS IN THE BIPOLAR MONTAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listbox3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox3_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EDITBOX FOR VIEWING THE NUMBER OF CHANNELS IN THE BIPOLAR MONTAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO LOAD FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton6_Callback(hObject, eventdata, handles)
if exist('pop_loadset.m') == 0
    eeglab
end

EEG = pop_loadset;
if isempty(EEG)
    return
else
    assignin('base', 'EEG', EEG)
    assignin('base', 'ALLEEG', EEG)
end

chLocs= evalin('base', 'EEG.chanlocs');
if isempty(chLocs)
    nchs= evalin('base', 'EEG.nbchan');
    for i=1:nchs
        if i < 10
            chList{i}= ['Ch0' num2str(i)];
        else
            chList{i}= ['Ch' num2str(i)];
        end
    end
else
    nchs= length(chLocs);
    for i=1: nchs
        chList{i}= chLocs(i).labels;
    end
end

set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', 1, 'Value', 1)
set(handles.listbox2, 'String', chList, 'Min', 1, 'Max', 1, 'Value', 1)
set(handles.pushbutton9, 'Enable', 'On')
set(handles.pushbutton2, 'Enable', 'On')
set(handles.pushbutton4, 'Enable', 'On')
set(handles.pushbutton6, 'Enable', 'On')
set(handles.edit3, 'String', num2str(nchs), 'Enable', 'Inactive')
set(handles.edit4, 'String', num2str(nchs), 'Enable', 'Inactive')
set(handles.edit5, 'String', 0, 'Enable', 'Inactive')
set(handles.edit6, 'String', [EEG.filepath EEG.filename])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO ADD THE NEW BIPOLAR CHANNEL TO THE LIST OF BIPOLAR
%  CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton4_Callback(hObject, eventdata, handles)
chList= get(handles.listbox1, 'String');
tempCh1Idx= get(handles.listbox1, 'Value');
tempCh2Idx= get(handles.listbox2, 'Value');
chStr= get(handles.listbox3, 'String');

if tempCh2Idx == tempCh1Idx
    warndlg('Channel 2 should be different from Channel 1', '!! Warning !!')
    return
end

chStrNew= string([deblank(chList{tempCh1Idx}) '-' deblank(chList{tempCh2Idx})]);

if isempty(chStr)
    chStrAll = chStrNew;
    set(handles.listbox3, 'String', chStrAll, 'Value',1);
else
    chStrAll= [chStr; chStrNew];
    set(handles.listbox3, 'String', chStrAll, 'Value', size(chStrAll,1));
end

set(handles.edit5, 'String', num2str(size(chStrAll,1)))
set(handles.pushbutton3, 'Enable', 'On');
set(handles.pushbutton5, 'Enable', 'On');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO REMOVE A BIPOLAR CHANNEL FROM THE LIST OF BIPOLAR
%  CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton5_Callback(hObject, eventdata, handles)
chStrAll= get(handles.listbox3, 'String');
chToRem= get(handles.listbox3, 'Value');

chStrAllNew= chStrAll;
chStrAllNew(chToRem,:)= [];

set(handles.listbox3, 'String', chStrAllNew);

if isempty(chStrAllNew)
    set(handles.edit5, 'String', '0');
    set(handles.listbox3, 'Value', []);
    set(handles.pushbutton3, 'Enable', 'Off');
else
    set(handles.edit5, 'String', num2str(size(chStrAllNew,1)));
    set(handles.listbox3, 'Value', size(chStrAllNew,1));
    set(handles.pushbutton3, 'Enable', 'On')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  POPUP MENU FOR SELECTING THE DATA TYPOLOGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
dataType= {'iEEG', 'EEG','MEG'};
set(hObject, 'String',dataType, 'Value', 1);

function popupmenu1_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO LOAD THE BIPOLAR MONTAGE FROM AN EXTERNAL .TXT FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton9_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.txt','Select the Montage file');
if filename==0
    return
end

fid= fopen([filepath filename], 'r');
M= textscan(fid, '%s');
set(handles.listbox3, 'String', M{1,1})
set(handles.edit5, 'String', num2str(length(M{1,1})))

set(handles.pushbutton4, 'Enable', 'On')
set(handles.pushbutton5, 'Enable', 'On')
set(handles.pushbutton3, 'Enable', 'On')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO SAVE THE BIPOLAR MONTAGE AS A .TXT FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton2_Callback(hObject, eventdata, handles)
SaveMontage= get(handles.listbox3, 'String');

if isempty(SaveMontage)
    warndlg('Bipolar Montage is empty', 'Save Bipolar Montage');
    return
end

UniqueMontage= unique(SaveMontage);
if size(UniqueMontage,1)~=size(SaveMontage,1)
    warndlg('Some bipolar channels are duplicated. Plase correct', 'Save Bipolar Montage');
    return
end

fileN= get(handles.edit6, 'String');
if isempty(fileN)
    [fileName, filePath] = uiputfile('*.txt', 'Save Montage As:');
    if fileName == 0
        return
    end
else
    [pathstr,~,~] = fileparts(fileN);
    [fileName, filePath] = uiputfile([pathstr filesep 'BipolarMontage.txt'], 'Save Montage As:');
    if fileName == 0
        return
    end
end

fullName = fullfile(filePath,fileName);
fileID = fopen(fullName,'w');

for i=1:size(SaveMontage,1)
    chPrint= [SaveMontage{i,:}];
    fprintf(fileID, '%s\n', chPrint);
end
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO CREATE A NEW FILE .SET WITH THE NEW BIPOLAR MONTAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton3_Callback(hObject, eventdata, handles)
chListMontage= get(handles.listbox1, 'String');
SaveMontage= get(handles.listbox3, 'String');
nchBip= size(SaveMontage, 1);

fileN= get(handles.edit6, 'String');
if isempty(fileN)
    warndlg('Filename and filepath in the EEG struct are empty', 'Check EEG struct')
    return
end
DataType= get(handles.popupmenu1, 'String');
DataTypeidx= get(handles.popupmenu1, 'Value');
selDataType= DataType{DataTypeidx};
unipEEG= pop_loadset(fileN);
if length(size(unipEEG.data))== 3
    warndlg('Bipolar Montage creation does not support epoched data. Do bipolar montage befor epoching',...
        'Bipolar Montage warning');
    return
end
SR= unipEEG.srate;
EEG= eeg_emptyset;
EEGnew= zeros(nchBip, size(unipEEG.data,2));
unipEEG.chanlocs=[];

nBipCh= size(SaveMontage,1);
bipIndex= zeros(nBipCh,2);

for i= 1: nBipCh
    l= SaveMontage{i,:} ;
    k= strfind(l, '-');
    
    if isempty(k)
        warndlg('Bipolar montage format is not correct', '!! Warning !!')
        return
        
    elseif length(k)==1
        l1Cont= l(1:k-1);
        l2Cont= l(k+1:end);
        
        bipIndex1= find(strcmp(deblank(chListMontage), l1Cont)==1);
        if isempty (bipIndex1)
            warndlg('Some channels in the montage are missing in the data!! Please check .txt file',  '!! Warning !!')
            return
        else
            bipIndex(i,1)=  bipIndex1;
        end
        
        bipIndex2= find(strcmp(deblank(chListMontage), l2Cont)==1);
        if isempty (bipIndex2)
            warndlg('Some channels in the montage are missing in the data!! Please check .txt file',  '!! Warning !!')
            return
        else
            bipIndex(i,2)=  bipIndex2;
        end
        
    else
        kk= median(k);
        
        l1Cont{i}= l(1:kk-1);
        l2Cont{i}= l(kk+1:end);
        
        bipIndex(i,1)= find(strcmp(deblank(chListMontage), l1Cont{i})==1);
        bipIndex(i,2)= find(strcmp(deblank(chListMontage), l2Cont{i})==1);
        
        if isempty(bipIndex(i,1))|| isempty(bipIndex(i,2))
            warndlg('Some channels in the montage are missing in the data!! Please check .txt file',  '!! Warning !!')
            return
        end
    end
end

% Check if some channels are duplicate
CK= unique(bipIndex, 'rows');
if size(CK,1)~= size(bipIndex,1)
    warndlg('Some bipolar channels are duplicated. Please correct', 'Bipolar Montage create');
    return
end

for i=1:nchBip
    EEGnew(i,:)= unipEEG.data(bipIndex(i,1),:)- unipEEG.data(bipIndex(i,2),:);
    EEG.chanlocs(1,i).labels= SaveMontage{i,:};
    EEG.chanlocs(1,i).type= selDataType;
end

EEG.data= EEGnew;
EEG.nbchan= nchBip;
EEG.srate= SR;
EEG.setname= [unipEEG.setname '_Bipolar'];
EEG.filename= [unipEEG.filename(1:end-4)  '_bip.set'];
EEG.filepath= unipEEG.filepath;

EEG.subject= unipEEG.subject;
EEG.group= unipEEG.group;
EEG.condition= unipEEG.condition;
EEG.session= unipEEG.session;
EEG.comments= unipEEG.comments;

EEG.event= unipEEG.event;
EEG.urevent= unipEEG.urevent;
EEG.eventdescription= unipEEG.eventdescription;

[EEG] = eeg_checkset(EEG);
disp('Done')

handles.EEG= EEG;
guidata(hObject,handles);
uiresume();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON TO CLOSE THE WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
uiresume();
guibip= findobj('Tag', 'BipolarMontage');
delete(guibip)
return

function BipolarMontage_CloseRequestFcn(hObject, eventdata, handles)
EEG= [];
command= '';
handles.EEG= EEG;
handles.command= command;
guidata(hObject,handles);
uiresume();
guibip= findobj('Tag', 'BipolarMontage');
delete(guibip)

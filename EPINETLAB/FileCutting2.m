function varargout = FileCutting2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FileCutting2_OpeningFcn, ...
    'gui_OutputFcn',  @FileCutting2_OutputFcn, ...
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


% --- Executes just before FileCutting2 is made visible.
function FileCutting2_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(handles.edit2, 'String', '0');
set(handles.radiobutton3, 'Value', 1);
set(handles.radiobutton4, 'Value', 0);
set(handles.listbox1, 'String', [], 'Value', [], 'Min', 1, 'Max', 100, 'Enable', 'inactive');


% Update handles structure
guidata(hObject, handles);

W = evalin('base','whos');
inBase= zeros(length(W),1);
if isempty(W)
    set(handles.edit1, 'String', []);
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
    if any(inBase)
        EEG= evalin('base', 'EEG');
        
        [EEG, isEEG]= eeg_checkset(EEG, 'data');
        
        if strcmp(isEEG, 'no')
            disp('Warning: Variable EEG present in the workspace is not in the correct EEGLAB format and will not be loaded')
            return
        else
            if isempty(EEG.filename)
                str2disp= [];
            else
                if strcmp(EEG.filepath(end), filesep)
                    str2disp= [EEG.filepath EEG.filename];
                else
                    str2disp= [EEG.filepath filesep EEG.filename];
                end
            end
            set(handles.edit1, 'String', str2disp);
        end
    else
        set(handles.edit1, 'String', []);
    end
end


function varargout = FileCutting2_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT EEGLAB FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton1_Callback(hObject, eventdata, handles)
[filenameSET, filepathSET]= uigetfile('*set', 'Select EEGLAB file to cut');

if ischar(filenameSET) == 0 && ischar(filepathSET) == 0
    return
else
    strDispl= [filepathSET filenameSET];
    set(handles.edit1, 'String', strDispl);
end
set(handles.listbox1, 'String', [], 'Value', [])

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT NUMBER OF EPOCHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '0')

function edit2_Callback(hObject, eventdata, handles)

function radiobutton3_Callback(hObject, eventdata, handles)
set(handles.radiobutton4, 'Value', 0)

function radiobutton4_Callback(hObject, eventdata, handles)
set(handles.radiobutton3, 'Value', 0)


function pushbutton2_Callback(hObject, eventdata, handles)
close(gcf)
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUT FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton3_Callback(hObject, eventdata, handles)

FILENAME= get(handles.edit1, 'String');
if isempty(FILENAME)
    return
end
EEG= pop_loadset(FILENAME);
totLen= EEG.pnts;
SR= EEG.srate;

EPOCHLENGTH= str2double(get(handles.edit2, 'String'));

if EPOCHLENGTH == 0
    warndlg('Select a proper time interval', 'Epoch Length!!')
    return
end

epochSampl= fix(EPOCHLENGTH* SR);
nEpochs= fix(totLen/epochSampl);
if nEpochs == 0
   warndlg('File duration is shorter than epoch lenght', 'Warning')
   return    
end

remSampl= rem(totLen, epochSampl);

setOutput= get(handles.radiobutton3, 'Value');
npxOutput= get(handles.radiobutton4, 'Value');

for i=1: nEpochs
    EEGNew= EEG;
    DATAInt= EEG.data;
    
    DATA= DATAInt(:, (i-1)* epochSampl +1 :  i* epochSampl);
    
    EEGNew.data= DATA;
    EEGNew.pnts= epochSampl;
    
    %   EEGNew.xmax=  [(i-1)* epochSampl +1]/SR;
    %   EEGNew.xmax=  (i* epochSampl)/SR;
    outputFileSET= [EEG.filename(1:end-4) '_Split' num2str(i) '.set'];
    outputFileNPX= [EEG.filename(1:end-4) '_Split' num2str(i)];
    
    if setOutput==1 && npxOutput==0
        pop_saveset(EEGNew, 'filename', outputFileSET, 'filepath', EEG.filepath);
        LBnew{i}= [EEG.filepath filesep outputFileSET];
        set(handles.listbox1, 'String', LBnew);
        
    elseif setOutput==0 && npxOutput==1
        write_npx_fromset(EEG, outputFileNPX);
        LBnew{i}= [EEG.filepath filesep outputFileNPX ];
        set(handles.listbox1, 'String', LBnew);
    end
end

if remSampl >= epochSampl/2
    EEGNew= EEG;
    DATAInt= EEG.data;
    DATA= DATAInt(:, nEpochs* epochSampl +1 :  nEpochs* epochSampl +  remSampl);
    
    EEGNew.data= DATA;
    EEGNew.pnts= remSampl;
    
    %   EEGNew.xmax=  [nEpochs* epochSampl +1]/SR;
    %   EEGNew.xmax=  (nEpochs* epochSampl +  remSampl)/SR;
    outputFile= [EEG.filename(1:end-4) '_Split' num2str((nEpochs+1))];
    LBnew= get(handles.listbox1, 'String');
        
    if setOutput==1 && npxOutput==0
        pop_saveset( EEGNew, 'filename', outputFile, 'filepath', EEG.filepath);
        LB= [EEG.filepath filesep outputFile '.set'];
    elseif setOutput==0 && npxOutput==1
        write_npx_fromset(EEG, outputFile)
        LB= [EEG.filepath filesep outputFile '.npx'];
      %  set(handles.listbox1, 'String', LBnew);
    end
    
     LBnew{nEpochs+1}=  LB;
     set(handles.listbox1, 'String', LBnew);
end

disp('Done')

function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

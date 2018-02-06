function varargout = pop_loadnpx(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_loadnpx_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_loadnpx_OutputFcn, ...
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


function pop_loadnpx_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

set(handles.checkbox1, 'Value', 0)
set(handles.pushbutton5, 'Enable', 'off')
set(handles.uitable1,'Data', [], 'Enable', 'off')

uiwait();

function varargout = pop_loadnpx_OutputFcn(hObject, eventdata, handles)
if isempty(handles)
    varargout{1}= [];
    varargout{2}= '';
    guinpx= findobj('Tag', 'LOADNPX');
    delete(guinpx)
    return
else
    varargout{1} = handles.EEG;
    varargout{2} = handles.command;
end


function pushbutton1_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.npx', 'Select an NPX file');
fullFileName= [filepath filename];

if fullFileName == 0
    return
else
    set(handles.edit1, 'String', fullFileName);
end

XX= struct;
XX= xml2struct(fullFileName);
XX= XX.DOC;

field_ex= isfield(XX.Events, 'Type');

if field_ex == 1
    n_events = length(XX.Events.Type);
    for i=1:n_events
        
        if n_events == 1
            EVENT_LIST= XX.Events.Type.Attributes.Name;
            num= 1;
            EVENT_CLASS= XX.Events.Type.Attributes.Class;
        else
            EVENT_LIST= XX.Events.Type{1,i}.Attributes.Name;
            EVENT_CLASS= XX.Events.Type{1,i}.Attributes.Class;
            if isfield(XX.Events.Type{1,i}, 'Event')
                num= length(XX.Events.Type{1,i}.Event);
            else
                num= 1;
            end
        end
        if strcmp(EVENT_CLASS,'0')==1 || strcmp(EVENT_CLASS,'3')==1
            EVENT_CLASS_label='external';
        elseif strcmp(EVENT_CLASS,'1')==1
            EVENT_CLASS_label='spot';
        elseif strcmp(EVENT_CLASS,'2')==1
            EVENT_CLASS_label='state';
        else
            EVENT_CLASS_label=EVENT_CLASS;
        end
        
        Table{i,1}= EVENT_LIST;
        Table{i,2}= num;
        Table{i,3}= EVENT_CLASS_label;
        Table{i,4}= false;
        RowNames{i}= num2str(i); 
    end
    
else
    return    
end

set(handles.uitable1, 'Data', Table, 'RowName', RowNames, 'Enable', 'off')

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_Callback(hObject, eventdata, handles)


function checkbox1_Callback(hObject, eventdata, handles)
CB1= get(handles.checkbox1, 'Value');
Table= get(handles.uitable1, 'Data');
if CB1 == 1
    set(handles.uitable1, 'Enable', 'on')
    set(handles.uitable1, 'Data', Table)
    set(handles.uitable1,'ColumnEditable',[false false false true]);
    set(handles.uitable1,'CellSelectionCallback',@uitable1_CellSelectionCallback)
    set(handles.pushbutton5, 'Enable', 'on')
else
    set(handles.uitable1, 'Enable', 'off')
    set(handles.pushbutton5, 'Enable', 'off')
end

function SelectedCells= uitable1_CellSelectionCallback(hObject, eventdata, handles)
SelectedCells = eventdata.Indices;


function pushbutton3_Callback(hObject, eventdata, handles)
ED1= get(handles.edit1, 'String');
Table= get(handles.uitable1, 'Data');
eventIdx= cell2mat(Table(:,4));
selEvent= Table(eventIdx,1);

[filepath, filename]= fileparts(ED1);

[progr_ver, dim, fs, n_chs, CH_LABS, DATA, EVENT_STRUCT, ICA]= read_npx(filename, filepath,selEvent);

EEG= eeg_emptyset;
EEG.setname= [filename '.set'];
EEG.filename= [filename '.npx'];
EEG.subject= '';
EEG.group= '';
EEG.condition= '';
EEG.session= [];
EEG.comments= ['Original File: ' filepath filesep filename '.npx'];
EEG.nbchan= n_chs;

if ndims(DATA) == 3
    EEG.trials= size(DATA,3);
else
    EEG.trials= 1;
end

EEG.pnts= size(DATA,2);
EEG.srate=fs;
EEG.xmin= 0;
EEG.xmax= EEG.pnts/EEG.srate;
EEG.times= [];
EEG.data= DATA;

if ~isempty(ICA)
    EEG.icawinv= ICA.InvW;
    EEG.icasphere= ICA.Sp;
    EEG.icaweights= ICA.W;
    EEG.icachansind= 1:1:n_ICAcomps;
end

EEG.chanlocs =[];

for i= 1:size(CH_LABS, 1)
    EEG.chanlocs(1,i).labels= CH_LABS(i,:);
end

offset= 0;

for i=1: length(EVENT_STRUCT)
       
    Event_name= EVENT_STRUCT(i,1).name;
    Event_class= EVENT_STRUCT(i,1).Class;
        
    isF= isfield(EVENT_STRUCT(1,1), 'VSB');
    if isF ==1
        Event_occ= length(EVENT_STRUCT(i,1).VSB);
        
        for j= 1:Event_occ
            
            k= offset+ j;
            EEG.event(k).type= Event_name;
            EEG.event(k).position= [];
            EEG.event(k).latency= EVENT_STRUCT(i,1).VSB(j);
            
            if  Event_class== 1
                EEG.event(k).duration= 0;
            elseif Event_class== 2
                EEG.event(k).duration= (EVENT_STRUCT(i,1).VSE(j)- EVENT_STRUCT(i,1).VSB(j)) ;
            end
        end
         offset= length(EEG.event);  
    else
        Event_occ=0;
    end
     
end

[EEG] = eeg_checkset(EEG);
disp('Done')

handles.EEG= EEG;
handles.command= '';
guidata(hObject,handles);
uiresume();


function pushbutton4_Callback(hObject, eventdata, handles)
uiresume();
guinpx= findobj('Tag', 'LOADNPX');
delete(guinpx)
return

function pushbutton5_Callback(hObject, eventdata, handles)
Table= get(handles.uitable1, 'Data');
[r,c]= size(Table);
for i=1:r
    Table{i,4}= true;
end
set(handles.uitable1, 'Data', Table)

function LOADNPX_CloseRequestFcn(hObject, eventdata, handles)
EEG= [];
command= '';
handles.EEG= EEG;
handles.command= command;
guidata(hObject,handles);
uiresume();
guinpx= findobj('Tag', 'LOADNPX');
delete(guinpx)





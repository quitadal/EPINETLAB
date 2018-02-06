%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function allows to write an .XML file containing all the HFO events
% (ripple/fast ripples) identified by the EPINETLAB program and to be imported
% into the Micromed software (BrainQuick).
% Authors: Lucia Rita Quitadamo, Secondment at Micromed s.p.a, June 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = exportHFOtoMicromed(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @exportHFOtoMicromed_OpeningFcn, ...
    'gui_OutputFcn',  @exportHFOtoMicromed_OutputFcn, ...
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

function exportHFOtoMicromed_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

set(handles.edit1, 'String', [])
set(handles.edit2, 'String', [])
set(handles.edit4, 'String', [])
set(handles.edit5, 'String', '0', 'Enable', 'inactive')

set(handles.slider1, 'Min', 0, 'Max', 6000, 'SliderStep', [1/(6000*4) 1/(6000*4)], 'Value', 0)


function varargout = exportHFOtoMicromed_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.txt', 'Select HFO file');
if filename == 0
    return
end

fullFileName= [filepath filename];
set(handles.edit1, 'String', fullFileName)

function edit1_Callback(hObject, eventdata, handles)
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.mat', 'Select Micromed setting file');
if filename == 0
    return
end

fullFileName= [filepath filename];
set(handles.edit2, 'String', fullFileName)

function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_Callback(hObject, eventdata, handles)

function pushbutton4_Callback(hObject, eventdata, handles)
%----------read HFO file
ED1= get(handles.edit1, 'String');
if isempty(ED1)
    warndlg('Please select EPINETLAB HFO file', 'Select HFO file')
    return
end

fidHFO= fopen(ED1, 'r');
formatSpec = '%13s%13s%13s%13s%13s%13s%s%[^\n\r]';
dataArray = textscan(fidHFO, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false);

if strcmp(strtrim(dataArray{1,1}{1,1}), 'Channel')==0 || strcmp(strtrim(dataArray{1,2}{1,1}), 'TotHFO')== 0 || strcmp(strtrim(dataArray{1,3}{1,1}), 'HFOIdx')== 0 ||    strcmp(strtrim(dataArray{1,4}{1,1}), 'tstart[s]')==0 ||    strcmp(strtrim(dataArray{1,5}{1,1}), 'tend[s]')==0 ||    strcmp(strtrim(dataArray{1,6}{1,1}), 'Dur[s]')==0 ||    strcmp(strtrim(dataArray{1,7}{1,1}), 'Dur[sampl]')==0
    warndlg('Wrong .txt file format', 'Select HFO file')
    fclose(fidHFO);
    return
end

dataArray{1,1}(1)= []; dataArray{1,2}(1)= []; dataArray{1,3}(1)= [];
dataArray{1,4}(1)= []; dataArray{1,5}(1)= []; dataArray{1,6}(1)= [];
dataArray{1,7}(1)= [];

Channel= dataArray{:, 1};
TotHFO = dataArray{:, 2};
HFOIdx = dataArray{:, 3};
tstart = dataArray{:, 4};
tend =   dataArray{:, 5};

if ~isempty(Channel)
    if size(Channel,1)> size(TotHFO,1)
        Channel(end)= [];
    end
end

deblankHFO= strtrim(TotHFO);
empHFO= cellfun('isempty', deblankHFO);
deblankHFO(empHFO)={'0'};
deblankHFONum= cellfun(@str2num, deblankHFO);

deblankHFONumIdx= find(deblankHFONum~=0);

ChanneldeBlank= strtrim(Channel(deblankHFONumIdx));
nCh= length(ChanneldeBlank);
TOTHFO= deblankHFONum(deblankHFONumIdx);


ED2= get(handles.edit2, 'String');
if isempty(ED2)
    warndlg('Please select MICROMED setting file', 'Select MICROMED file')
    return
end

S = load(ED2);

if ~isfield(S, 'MicromedData')
    warndlg('Wrong .MAT file', 'Select MICROMED file')
    return
end

StartTimeUTC= S.MicromedData.StartTimeUTC;
LabelElectrode= deblank(cellstr(S.MicromedData.LabelElectrode));
IDElectrode= S.MicromedData.IDElectrode;
StartTimeFraction= S.MicromedData.StartTimeFraction;

RB1= get(handles.radiobutton1, 'Value');
RB2= get(handles.radiobutton2, 'Value');

if RB1 == 1 && RB2 == 0
    eventClassGuid= 'C42D7220-FBD0-45C5-AA2D-D5B0D1F51BAF';
elseif RB1 == 0 && RB2 == 1
    eventClassGuid= '06884706-153F-4D53-9D4A-1CEBFF7945D6';
elseif RB1 == 0 && RB2 == 0
    warndlg('Please select event type', 'Select event type')
    return
end

SL1= get(handles.slider1, 'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE THE .XML OUTPUT FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
docNode = com.mathworks.xml.XMLUtils.createDocument('EventFile');
EventFile = docNode.getDocumentElement;
EventFile.setAttribute('Guid','991611e0-698a-4214-8c2a-e66b6dc78cb0');
EventFile.setAttribute('Version','1.00');
t = datetime('now','TimeZone','local','Format','yyyy-MM-dd''T''HH:mm:ss.SSSSSSS');
EventFile.setAttribute('CreationDate', [char(t) 'Z']);

EventTypes = docNode.createElement('EventTypes');
EventFile.appendChild(EventTypes);

Category= docNode.createElement('Category');
Category.setAttribute('Name', 'Hfo');
EventTypes.appendChild(Category);

Description= docNode.createElement('Description');
Description.appendChild(docNode.createTextNode('HFO'));
Category.appendChild(Description);

IsPredefined= docNode.createElement('IsPredefined');
IsPredefined.appendChild(docNode.createTextNode('true'));
Category.appendChild(IsPredefined);

Guid= docNode.createElement('Guid');
Guid.appendChild(docNode.createTextNode('27e2727f-e49d-4113-aa8c-4944ef8f2588'));
Category.appendChild(Guid);

SubCategory= docNode.createElement('SubCategory');
SubCategory.setAttribute('Name', 'EPINETLAB HFO');
Category.appendChild(SubCategory);

Description= docNode.createElement('Description');
Description.appendChild(docNode.createTextNode('HFO'));
SubCategory.appendChild(Description);

IsPredefined= docNode.createElement('IsPredefined');
IsPredefined.appendChild(docNode.createTextNode('true'));
SubCategory.appendChild(IsPredefined);

Guid= docNode.createElement('Guid');
Guid.appendChild(docNode.createTextNode('9EC63714-85CC-4996-A078-51FB538B2CD2'));
SubCategory.appendChild(Guid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EPINETLAB Ripple Definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Definition= docNode.createElement('Definition');
Definition.setAttribute('Name', 'HfoRipple EPINETLAB');
SubCategory.appendChild(Definition);

Guid= docNode.createElement('Guid');
Guid.appendChild(docNode.createTextNode('C42D7220-FBD0-45C5-AA2D-D5B0D1F51BAF'));
Definition.appendChild(Guid);

Description= docNode.createElement('Description');
Description.appendChild(docNode.createTextNode('HFORippleEPINETLAB'));
Definition.appendChild(Description);

IsPredefined= docNode.createElement('IsPredefined');
IsPredefined.appendChild(docNode.createTextNode('true'));
Definition.appendChild(IsPredefined);

IsDefinitionAdjustable= docNode.createElement('IsDefinitionAdjustable');
IsDefinitionAdjustable.appendChild(docNode.createTextNode('false'));
Definition.appendChild(IsDefinitionAdjustable);

CanInsert= docNode.createElement('CanInsert');
CanInsert.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanInsert);

CanDelete= docNode.createElement('CanDelete');
CanDelete.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanDelete);

CanUpdateText= docNode.createElement('CanUpdateText');
CanUpdateText.appendChild(docNode.createTextNode('false'));
Definition.appendChild(CanUpdateText);

CanUpdatePosition= docNode.createElement('CanUpdatePosition');
CanUpdatePosition.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanUpdatePosition);

CanReassign= docNode.createElement('CanReassign');
CanReassign.appendChild(docNode.createTextNode('false'));
Definition.appendChild(CanReassign);

InsertionType= docNode.createElement('InsertionType');
InsertionType.appendChild(docNode.createTextNode('ClickAndDrag'));
Definition.appendChild(InsertionType);

FixedInsertionDuration= docNode.createElement('FixedInsertionDuration');
FixedInsertionDuration.appendChild(docNode.createTextNode('PT1S'));
Definition.appendChild(FixedInsertionDuration);

TextType= docNode.createElement('TextType');
TextType.appendChild(docNode.createTextNode('FromDefinitionDescription'));
Definition.appendChild(TextType);

ReferenceType= docNode.createElement('ReferenceType');
ReferenceType.appendChild(docNode.createTextNode('SingleLine'));
Definition.appendChild(ReferenceType);

DurationType= docNode.createElement('DurationType');
DurationType.appendChild(docNode.createTextNode('Interval'));
Definition.appendChild(DurationType);

textColor= 256*(2^24);
rippleColor= 128*(2^24)+ 255*(2^16) + 0*(2^8)+ 255; % magenta with 0.5 of transparency

TextArgbColor= docNode.createElement('TextArgbColor');
TextArgbColor.appendChild(docNode.createTextNode(num2str(textColor)));
Definition.appendChild(TextArgbColor);

GraphicArgbColor= docNode.createElement('GraphicArgbColor');
GraphicArgbColor.appendChild(docNode.createTextNode(num2str(rippleColor)));
Definition.appendChild(GraphicArgbColor);

GraphicType= docNode.createElement('GraphicType');
GraphicType.appendChild(docNode.createTextNode('FillRectangle'));
Definition.appendChild(GraphicType);

TextPositionType= docNode.createElement('TextPositionType');
TextPositionType.appendChild(docNode.createTextNode('Top'));
Definition.appendChild(TextPositionType);

VisualizationType= docNode.createElement('VisualizationType');
VisualizationType.appendChild(docNode.createTextNode('TextAndGraphic'));
Definition.appendChild(VisualizationType);

FontFamily= docNode.createElement('FontFamily');
FontFamily.appendChild(docNode.createTextNode('Segoe UI'));
Definition.appendChild(FontFamily);

FontSize= docNode.createElement('FontSize');
FontSize.appendChild(docNode.createTextNode(num2str(11)));
Definition.appendChild(FontSize);

FontItalic= docNode.createElement('FontItalic');
FontItalic.appendChild(docNode.createTextNode('false'));
Definition.appendChild(FontItalic);

FontBold= docNode.createElement('FontBold');
FontBold.appendChild(docNode.createTextNode('false'));
Definition.appendChild(FontBold);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EPINETLAB Fast Ripple Definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Definition= docNode.createElement('Definition');
Definition.setAttribute('Name', 'Hfo Fast Ripple EPINETLAB');
SubCategory.appendChild(Definition);

Guid= docNode.createElement('Guid');
Guid.appendChild(docNode.createTextNode('06884706-153F-4D53-9D4A-1CEBFF7945D6'));
Definition.appendChild(Guid);

Description= docNode.createElement('Description');
Description.appendChild(docNode.createTextNode('HFO fRipple EPINETLAB'));
Definition.appendChild(Description);

IsPredefined= docNode.createElement('IsPredefined');
IsPredefined.appendChild(docNode.createTextNode('true'));
Definition.appendChild(IsPredefined);

IsDefinitionAdjustable= docNode.createElement('IsDefinitionAdjustable');
IsDefinitionAdjustable.appendChild(docNode.createTextNode('false'));
Definition.appendChild(IsDefinitionAdjustable);

CanInsert= docNode.createElement('CanInsert');
CanInsert.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanInsert);

CanDelete= docNode.createElement('CanDelete');
CanDelete.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanDelete);

CanUpdateText= docNode.createElement('CanUpdateText');
CanUpdateText.appendChild(docNode.createTextNode('false'));
Definition.appendChild(CanUpdateText);

CanUpdatePosition= docNode.createElement('CanUpdatePosition');
CanUpdatePosition.appendChild(docNode.createTextNode('true'));
Definition.appendChild(CanUpdatePosition);

CanReassign= docNode.createElement('CanReassign');
CanReassign.appendChild(docNode.createTextNode('false'));
Definition.appendChild(CanReassign);

InsertionType= docNode.createElement('InsertionType');
InsertionType.appendChild(docNode.createTextNode('ClickAndDrag'));
Definition.appendChild(InsertionType);

FixedInsertionDuration= docNode.createElement('FixedInsertionDuration');
FixedInsertionDuration.appendChild(docNode.createTextNode('PT1S'));
Definition.appendChild(FixedInsertionDuration);

TextType= docNode.createElement('TextType');
TextType.appendChild(docNode.createTextNode('FromDefinitionDescription'));
Definition.appendChild(TextType);

ReferenceType= docNode.createElement('ReferenceType');
ReferenceType.appendChild(docNode.createTextNode('SingleLine'));
Definition.appendChild(ReferenceType);

DurationType= docNode.createElement('DurationType');
DurationType.appendChild(docNode.createTextNode('Interval'));
Definition.appendChild(DurationType);

TextArgbColor= docNode.createElement('TextArgbColor');
TextArgbColor.appendChild(docNode.createTextNode(num2str(textColor)));
Definition.appendChild(TextArgbColor);

fastrippleColor= 128*(2^24)+ 0*(2^16) + 255*(2^8)+ 0; % lime [0, 255, 0] with 0.5 of transparency
GraphicArgbColor= docNode.createElement('GraphicArgbColor');
GraphicArgbColor.appendChild(docNode.createTextNode(num2str(fastrippleColor)));
Definition.appendChild(GraphicArgbColor);

GraphicType= docNode.createElement('GraphicType');
GraphicType.appendChild(docNode.createTextNode('FillRectangle'));
Definition.appendChild(GraphicType);

TextPositionType= docNode.createElement('TextPositionType');
TextPositionType.appendChild(docNode.createTextNode('Top'));
Definition.appendChild(TextPositionType);

VisualizationType= docNode.createElement('VisualizationType');
VisualizationType.appendChild(docNode.createTextNode('TextAndGraphic'));
Definition.appendChild(VisualizationType);

FontFamily= docNode.createElement('FontFamily');
FontFamily.appendChild(docNode.createTextNode('Segoe UI'));
Definition.appendChild(FontFamily);

FontSize= docNode.createElement('FontSize');
FontSize.appendChild(docNode.createTextNode(num2str(11)));
Definition.appendChild(FontSize);

FontItalic= docNode.createElement('FontItalic');
FontItalic.appendChild(docNode.createTextNode('false'));
Definition.appendChild(FontItalic);

FontBold= docNode.createElement('FontBold');
FontBold.appendChild(docNode.createTextNode('false'));
Definition.appendChild(FontBold);

Events = docNode.createElement('Events');
EventFile.appendChild(Events);

for i= 1:nCh
    ch= ChanneldeBlank{i};
    sepChar= strfind(ch, '-');
    derivationNotInv= ch(sepChar+1:end);
    derivationInv= ch(1:sepChar-1);
    
    derivationInvIdx= find(strcmp(deblank(LabelElectrode), derivationInv));
    derivationNotInvIdx= find(strcmp(deblank(LabelElectrode), derivationNotInv));
    IDElectrodeInv= IDElectrode(derivationInvIdx);
    IDElectrodeNotInv= IDElectrode(derivationNotInvIdx);
    
    bidx= sum(TOTHFO(1:i-1))+ 1: sum(TOTHFO(1:i-1))+ TOTHFO(i);
    
    for j= 1: TOTHFO(i)
        eventGuid= generate_guid;
        Event = docNode.createElement('Event');
        Event.setAttribute('Guid', char(eventGuid));
        Events.appendChild(Event);
        
        EventDefinitionGuid = docNode.createElement('EventDefinitionGuid');
        EventDefinitionGuid.appendChild(docNode.createTextNode(char(eventClassGuid)));
        Event.appendChild(EventDefinitionGuid);
        
        DerivationInvID= docNode.createElement('DerivationInvID');
        DerivationInvID.appendChild(docNode.createTextNode(num2str(IDElectrodeInv)));
        Event.appendChild(DerivationInvID);
        
        DerivationNotInvID= docNode.createElement('DerivationNotInvID');
        DerivationNotInvID.appendChild(docNode.createTextNode(num2str(IDElectrodeNotInv)));
        Event.appendChild(DerivationNotInvID);
                
        formatOut= 'yyyy-mm-ddTHH:MM:SS';
        tstartStr= strtrim(tstart{bidx(j)});
        inttStart= tstartStr(1:end-5);
        fractStart= tstartStr(end-3:end);
        totFractStart= str2num(['0.' fractStart])+ StartTimeFraction;
        totFractStartS= num2str(totFractStart);
        
        tendStr= strtrim(tend{bidx(j)});
        inttEnd= tendStr(1:end-5);
        fractEnd= tendStr(end-3:end);
        totFractEnd= str2num(['0.' fractEnd]) + StartTimeFraction;
        totFractEndS= num2str(totFractEnd);
        
        if totFractStart < 1
            eventBegin= SL1+ StartTimeUTC + str2num(inttStart)/(60*60*24);
        else
            eventBegin= SL1+ StartTimeUTC + 1/(60*60*24) + str2num(inttStart)/(60*60*24);
        end
            eventBeginStr= datestr(eventBegin, formatOut);
            eventBeginStrFin= [eventBeginStr '.' totFractStartS(3:end) '000Z'];
            
        if  totFractEnd < 1   
            eventEnd=  SL1+ StartTimeUTC + str2num(inttEnd)/(60*60*24);
        else
            eventEnd=  SL1+ StartTimeUTC + 1/(60*60*24) + str2num(inttEnd)/(60*60*24);
        end
        
        eventEndStr= datestr(eventEnd,formatOut);
        eventEndStrFin= [eventEndStr '.' totFractEndS(3:end) '000Z'];
        
        Begin = docNode.createElement('Begin');
        Begin.appendChild(docNode.createTextNode(char(eventBeginStrFin)));
        Event.appendChild(Begin);
        
        End = docNode.createElement('End');
        End.appendChild(docNode.createTextNode(char(eventEndStrFin)));
        Event.appendChild(End);
        
        val= strtrim(HFOIdx{bidx(j)});
        
        Value = docNode.createElement('Value');
        Value.appendChild(docNode.createTextNode(val));
        Event.appendChild(Value);
        
        ExtraValue = docNode.createElement('ExtraValue');
        ExtraValue.appendChild(docNode.createTextNode('0'));
        Event.appendChild(ExtraValue);
        
        CreatedBy = docNode.createElement('CreatedBy');
        CreatedBy.appendChild(docNode.createTextNode('QuitadamoLR'));
        Event.appendChild(CreatedBy);
        
        CreatedDate = docNode.createElement('CreatedDate');
        CreatedDate.appendChild(docNode.createTextNode([char(t) 'Z']));
        Event.appendChild(CreatedDate);
        
        UpdatedBy = docNode.createElement('UpdatedBy');
        UpdatedBy.appendChild(docNode.createTextNode('QuitadamoLR'));
        Event.appendChild(UpdatedBy);
        
        UpdatedDate = docNode.createElement('UpdatedDate');
        UpdatedDate.appendChild(docNode.createTextNode([char(t) 'Z']));
        Event.appendChild(UpdatedDate);
    end
end

[pathstr,~,~]= fileparts(ED2);
outputFile= [pathstr filesep 'EpinetlabHFOtoMicromed.evt'];
set(handles.edit4, 'String', outputFile)

xmlwrite(outputFile,docNode);
disp(['....' outputFile ' written....'])

function radiobutton1_Callback(hObject, eventdata, handles)
RB1= get(hObject, 'Value');
if RB1 == 1
    set(handles.radiobutton2, 'Value', 0)
end

function radiobutton2_Callback(hObject, eventdata, handles)
RB2= get(hObject, 'Value');
if RB2 == 1
    set(handles.radiobutton1, 'Value', 0)
end

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider1_Callback(hObject, eventdata, handles)
SL1= get(hObject, 'Value');
set(handles.edit5, 'String', num2str(SL1))

function edit5_Callback(hObject, eventdata, handles)
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton5_Callback(hObject, eventdata, handles)
close(gcf)

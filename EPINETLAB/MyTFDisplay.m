function varargout = MyTFDisplay(varargin)
% MYTFDISPLAY MATLAB code for MyTFDisplay.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MyTFDisplay_OpeningFcn, ...
    'gui_OutputFcn',  @MyTFDisplay_OutputFcn, ...
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


% --- Executes just before MyTFDisplay is made visible.
function MyTFDisplay_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for MyTFDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyTFDisplay wait for user response (see UIRESUME)
% uiwait(handles.GUI2);
% nWind= evalin('base', 'nWind');

% if exist('nWind', 'var')
%     nWind= evalin('base', 'nWind');
% else
%     nWind= 1;
% end

W = evalin('base','whos'); %or 'base'
if ~isempty(W)
    for i=1:length(W)
       existVar(i)= strcmp('nWind', W(i).name);
    end
end
if any(existVar)
    nWind= evalin('base', 'nWind');
else
    nWind= 1;
end
   

gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    return
end
g1data = guidata(gui1);

selWav= get(g1data.edit8, 'String');
freqBand= str2num(get(g1data.edit5, 'String'));    
chIdx= get(g1data.listbox1,'Value');
nCh= length(chIdx);

RB2= get(g1data.radiobutton2, 'Value');
RB3= get(g1data.radiobutton3, 'Value');
RB4= get(g1data.radiobutton4, 'Value');
diplayDecimation= str2num(get(g1data.edit9, 'String'));

h1= handles.panel1;
h2= handles.panel2;

if RB2 == 1
    set(h1, 'Title', 'iEEG')
elseif RB3 == 1
    set(h1, 'Title', 'Raw MEG')
elseif RB4 == 1
    set(h1, 'Title', 'MEG Virtual Sensors')
end
    
timeFreqPanelUpdate(1,nCh,nCh, h1, h2, 100, 100,'jet');

if nWind==1
    set(handles.slider1, 'Min', 0, 'Max', nWind, 'Value', 1, 'Enable', 'Off');
else
    set(handles.slider1, 'Min', 1, 'Max', nWind, 'Value', 1, 'SliderStep', [1/(nWind-1) , 1/(nWind-1)]);
end
colormaplist= {'jet', 'hot', 'parula','hsv', 'cool', 'spring', 'summer', 'autumn',...
    'winter', 'gray', 'bone','copper','pink','lines','colorcube','prism','flag'};
set(handles.popupmenu1, 'String', colormaplist);
set(handles.slider3, 'Min', 1, 'Max', 199, 'Value', 100, 'SliderStep', [1/198 , 1/198 ]);
set(handles.slider4, 'Min', 1, 'Max', 199, 'Value', 100, 'SliderStep', [1/198 , 1/198 ]);
set(handles.slider5, 'Min', 1, 'Max', 1, 'Value', 1);
set(handles.edit2, 'String', 1, 'FontWeight', 'bold')
set(handles.edit3, 'String', 1,  'FontWeight', 'bold')
set(handles.edit6, 'Enable', 'Off', 'String', nCh)
set(handles.edit7, 'String', ' ', 'Enable', 'Off', 'Max', 3)
set(handles.edit8, 'String', 1, 'Enable', 'Off');
set(handles.edit10, 'String', ['1 of ' num2str(nWind)])
set(handles.slider5, 'Enable', 'Off')
set(handles.axes3, 'Visible', 'Off')
%set(handles.text12, 'String', {['Wavelet= '  selWav ' ' 'Freq. Band= [' num2str(freqBand(1)) '-' num2str(freqBand(2)) 'Hz]'] })


function varargout = MyTFDisplay_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDER FOR WINDOWS SCROLLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider1_Callback(hObject, eventdata, handles)
currentWindow= round(get(hObject, 'Value'));
W = evalin('base','whos'); %or 'base'
if ~isempty(W)
    for i=1:length(W)
       existVar(i)= strcmp('nWind', W(i).name);
    end
end
if any(existVar)
    nWind= evalin('base', 'nWind');
else
    nWind= 1;
end
chGroup= str2double(get(handles.edit6, 'String'));
currentGroup= get(handles.slider5, 'Value');
possValGroup= 1:1:get(handles.slider5, 'Max');
if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
currentSens= get(handles.slider3, 'Value');
currentSens2= get(handles.slider4, 'Value');
colormaplist= get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};

h1= handles.panel1;
h2= handles.panel2;

possVal= 1:1:nWind;
if ismember(currentWindow, possVal)
    timeFreqPanelUpdate(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
else
    tmp= abs(possVal-currentWindow);
    [~, idx]= min(tmp);
    currentWindow= possVal(idx);
    timeFreqPanelUpdate(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
end

set(handles.edit7, 'String', ' ');
set(handles.edit10, 'String', [num2str(currentWindow) ' of ' num2str(nWind)])

kk= get(handles.axes3, 'Children');
if ishandle(kk)
    edit8_Callback(handles.edit8, 0, handles )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POP-UP MENU FOR ORIGINAL SIGNAL VIEWING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton24_Callback(hObject, eventdata, handles)
gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);
windLenMS= str2double(get(g1data.edit2, 'String'));

chIdx= get(g1data.listbox1,'Value');
chList= get(g1data.listbox1, 'String');

for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

EEGOUT = pop_loadset;

if isempty(EEGOUT)
    return
end

A= EEGOUT.chanlocs;
LABELS= {A(:).labels};

fid= fopen('eloc_file.loc', 'w');
for i=1:length(chSel)
    idx(i)= find(strcmp(chSel{i}, LABELS));
    fprintf(fid, '%i %i %i %s\r\n', i, 0, 0, chSel{i});
end
fclose(fid);

EEGOUT.data= EEGOUT.data(idx,:);
eegplot(EEGOUT.data, 'eloc_file', 'eloc_file.loc', 'title', 'Original iEEG signal', 'winlength', windLenMS);
delete 'eloc_file.loc'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POP-UP MENU FOR COLORMAP SETTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu1_Callback(hObject, ~, handles)
currentMap= get(hObject, 'Value');
colormaplist= get(handles.popupmenu1, 'String');
currentWindow= round(get(handles.slider1, 'Value'));
currentSens= get(handles.slider3, 'Value');
currentSens2= get(handles.slider4, 'Value');
possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end

chGroup= str2double(get(handles.edit6, 'String'));

h1= handles.panel1;
h2= handles.panel2;
timeFreqPanelUpdate(currentWindow, chGroup,currentGroup, h1, h2, currentSens, currentSens2, colormaplist{currentMap});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDER FOR CHANNELS SENSITIVITY SCROLLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider3_Callback(hObject, ~, handles)
currentSens= get(hObject, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentSens2= get(handles.slider4, 'Value');
chGroup= str2double(get(handles.edit6, 'String'));
possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
colormaplist= get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};

h1= handles.panel1;
h2= handles.panel2;
[sensFact,~ ]= timeFreqPanelUpdate(currentWindow, chGroup, currentGroup, h1, h2,currentSens,currentSens2, currentCol);
set(handles.edit2, 'String', num2str(sensFact), 'FontWeight', 'bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR CHANNELS SENSITIVITY VIEWING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDER FOR WAVELETS SENSITIVITY SCROLLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider4_Callback(hObject, eventdata, handles)
currentSens2= get(hObject, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentSens= get(handles.slider3, 'Value');
colormaplist= get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};
chGroup= str2double(get(handles.edit6, 'String'));
possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end

h1= handles.panel1;
h2= handles.panel2;

[~, sensFact2 ]= timeFreqPanelUpdate(currentWindow, chGroup, currentGroup, h1, h2,currentSens,currentSens2, currentCol);

set(handles.edit3, 'String', num2str(sensFact2), 'FontWeight', 'bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR CHANNELS SENSITIVITY VIEWING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR CHANNELS VALUE VIEWING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton7_Callback(hObject, eventdata, handles)
myhandles= guidata(gcbo);
AX1= findobj(myhandles.panel1, 'Type', 'axes');
AX2= findobj(myhandles.panel2, 'Type', 'axes');
AX2(end)= [];
AX1= AX1';
AX2= AX2';

possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
chGroup= str2double(get(handles.edit6, 'String'));
currentChannels= currentGroup:1:currentGroup+chGroup-1;
nCh= length(currentChannels);

for i=1:nCh
    set(AX1(1,i),'buttondownfcn',@clicklineCallback,'xlimmode','manual');
    set(AX2(1,i),'buttondownfcn',@clicklineCallback,'xlimmode','manual');

    line([AX1(1,i).XLim(1)+ (AX1(1,i).XLim(2)-AX1(1,i).XLim(1))/2 AX1(1,i).XLim(1)+(AX1(1,i).XLim(2)-AX1(1,i).XLim(1))/2],[AX1(1,i).YLim(1) AX1(1,i).YLim(2)],...
        'parent',AX1(1,i),'tag',['line' num2str(i)],'hittest','off', 'Color', 'green', 'LineStyle', '--', 'LineWidth', 2);

    line([AX2(1,i).XLim(1)+ (AX2(1,i).XLim(2)-AX2(1,i).XLim(1))/2 AX2(1,i).XLim(1)+(AX2(1,i).XLim(2)-AX2(1,i).XLim(1))/2],[AX2(1,i).YLim(1) AX2(1,i).YLim(2)],...
        'parent',AX2(1,i),'tag',['line2' num2str(i)],'hittest','off', 'Color', 'green', 'LineStyle', '--', 'LineWidth', 2);
end
    

function clicklineCallback(~,~)
set(gcf,'windowbuttonmotionfcn',@dragline)
set(gcf,'windowbuttonupfcn',@dragdone)

function dragline(~,~)
myhandles= guidata(gcbo);
possValGroup= 1:1:get(myhandles.slider5, 'Max');
currentGroup= get(myhandles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(myhandles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(myhandles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
chGroup= str2double(get(myhandles.edit6, 'String'));
currentChannels= currentGroup:1:currentGroup+chGroup-1;

nCh= length(currentChannels);
SR= evalin('base', 'EEG.srate');
currentWindow= round(get(myhandles.slider1, 'Value'));
timeMx= evalin('base', 'timeMx');

gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);

g1data = guidata(gui1);
RB2= get(g1data.radiobutton2, 'Value');
RB3= get(g1data.radiobutton3, 'Value');
RB4= get(g1data.radiobutton4, 'Value');

if RB2 == 1
    measUnit= '\muV';
elseif RB3 == 1
    measUnit= 'fT';
else
    measUnit= 'nAm';
end

inspInterv= get(g1data.edit4, 'String');
intDur= evalin('base', 'EEG.pnts');
if strcmp(inspInterv,'all')
    inspIntervLim1= 1;
    inspIntervLim2= intDur;
else
    intInter= str2num(inspInterv);
    inspIntervLim1 = ceil(SR* intInter(1)) +1;
    inspIntervLim2 = ceil(SR* intInter(2));
end


inspInterv= [inspIntervLim1 inspIntervLim2];

timelim1= timeMx(currentWindow,1);
timelim2= timeMx(currentWindow,2);

timeVect= timelim1: 1/SR: timelim2;
timeVectSR= timelim1*SR - inspInterv(1) - 1 : 1: timelim2*SR - inspInterv(1)- 1;

dataNew= evalin('base', 'dataNew');
DATA= dataNew(currentChannels, :);

AX1= findobj(myhandles.panel1, 'Type', 'axes');
AX1= AX1';

textObj= findobj(myhandles.panel1, 'Type', 'text', 'FontWeight', 'normal');
if isempty(textObj)~=1
    delete(textObj)
end

clicked=get(gca,'currentpoint');
xcoord=clicked(1,1,1);
[~, xind]= min(abs(timeVect-xcoord));
xcoord= timeVect(xind);
xcoordSampl=  round(timeVectSR(xind));


for i= 1:nCh
    Lin=findobj(gcf,'tag',['line' num2str(i)]);
    Lin2=findobj(gcf,'tag',['line2' num2str(i)]);
    
    set([Lin Lin2] ,'xdata',[xcoord xcoord]);
    
    
    if nCh == 1
         Xtext= double(AX1(1,i).XLim(2)+ 0.01);
         Ytext= double(AX1(1,i).YLim(1));
    else
        Xtext= double(AX1(1,i).XLim(2)+ 0.01);
        Ytext= double(AX1(1,i).YLim(1)- 2);
    end

    YVAL= round(DATA(i,xcoordSampl),2);
    
    if xcoord >= AX1(1,i).XLim(1) && xcoord <= AX1(1,i).XLim(2)
        text(Xtext, Ytext , {['t= ' num2str(round(xcoord,4)) ' ms'] ;  ['A= ' num2str(YVAL) measUnit]}, 'parent', AX1(1,i), 'backgroundcolor','w');
    else
        text(Xtext, Ytext , {'t= -' ;  'A= -' }, 'parent', AX1(1,i), 'backgroundcolor','w');
    end
end

function dragdone(~,~)
set(gcf,'windowbuttonmotionfcn','');
set(gcf,'windowbuttonupfcn','');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR CHANNELS VALUES DELETING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton8_Callback(hObject, eventdata, handles)
myhandles= guidata(gcbo);
LINE1= findobj(myhandles.panel1, 'Type', 'line', 'Color', 'green');
LINE2= findobj(myhandles.panel2, 'Type', 'line', 'Color', 'green');
COORDTEXT= findobj(myhandles.panel1, 'Type', 'text', 'FontWeight', 'normal');

if ishandle(LINE1)
    delete(LINE1)
    delete(LINE2)
end

if ishandle(COORDTEXT)
    delete(COORDTEXT)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR CHANNEL GROUP VIEW ENABLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton14_Callback(hObject, eventdata, handles)
set(handles.edit6, 'Enable', 'On')
set(handles.slider5, 'Enable', 'On')
set(handles.slider5, 'Value', 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR CHANNEL GROUP VIEW VALUE SETTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
chGroup= str2double(get(hObject, 'String'));
gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);
chIdx= get(g1data.listbox1,'Value');

nCh= length(chIdx);

if chGroup >= nCh
    set(handles.slider5, 'Enable', 'Off')
    return
else
    set(handles.slider5, 'Enable', 'On')
end

currentWindow= round(get(handles.slider1, 'Value'));
currentSens= get(handles.slider3, 'Value');
currentSens2= get(handles.slider4, 'Value');
colormaplist= get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};
h1= handles.panel1;
h2= handles.panel2;
AX1= findobj(h1, 'Type', 'axes');
AX2= findobj(h2, 'Type', 'axes');
AX2(end)= [];

delete(AX1)
delete(AX2)
timeFreqPanelUpdate(currentWindow,chGroup, 1, h1, h2, currentSens,currentSens2, currentCol);

nStep= nCh-chGroup+1;

set(handles.slider5, 'Min',1 , 'Max', nStep , 'Value', nStep, 'SliderStep', [1/(nStep-1) , 1/(nStep-1) ]);

kk= get(handles.axes3, 'Children');
if ishandle(kk)
    edit8_Callback(handles.edit8,0, handles )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDER FOR CHANNEL GROUP VIEW SCROLLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider5_Callback(hObject, ~, handles)
currentGroup= get(hObject, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentSens= get(handles.slider3, 'Value');
currentSens2= get(handles.slider4, 'Value');
chGroup= str2double(get(handles.edit6, 'String'));
colormaplist= get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};
gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);
chIdx= get(g1data.listbox1,'Value');
nCh= length(chIdx);

h1= handles.panel1;
h2= handles.panel2;
nStep= nCh-chGroup+1;

possValGroup= 1:1:nStep;

if ismember(currentGroup, possValGroup)
    currentGroup= nStep-currentGroup+1; % to make the slider scroll from top to bottom
    timeFreqPanelUpdate(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= nStep-currentGroup+1;% to make the slider scroll from top to bottom
    timeFreqPanelUpdate(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
end

kk= get(handles.axes3, 'Children');
if ishandle(kk)
    edit8_Callback(handles.edit8, 0, handles )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR CHANNEL GROUP VIEW DISABLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton18_Callback(hObject, eventdata, handles)
set(handles.edit6, 'Enable', 'Off')
set(handles.slider5, 'Enable', 'Off')
currentWindow= round(get(handles.slider1, 'Value'));
currentSens= get(handles.slider3, 'Value');
currentSens2= get(handles.slider4, 'Value');

colormaplist=get(handles.popupmenu1, 'String');
currentCol= colormaplist{get(handles.popupmenu1, 'Value')};
gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);
chIdx= get(g1data.listbox1,'Value');
nCh= length(chIdx);

h1= handles.panel1;
h2= handles.panel2;

timeFreqPanelUpdate(currentWindow,nCh, nCh, h1, h2, currentSens,currentSens2, currentCol);

set(handles.edit6, 'String', nCh)
set(handles.slider5, 'Value', 1, 'Max', 1)

kk= get(handles.axes3, 'Children');
if ishandle(kk)
    edit8_Callback(handles.edit8, 0, handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR WAVELETS VALUE VIEW ENABLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton16_Callback(hObject, eventdata, handles)
set(handles.edit7, 'Enable', 'On')
set(gcf, 'WindowButtonDownFcn', {@getMousePositionOnImage, handles});

function getMousePositionOnImage(hObject, eventdata, handles)
currentWindow= round(get(handles.slider1, 'Value'));
SR= evalin('base', 'EEG.srate');
scalMx= evalin('base', 'scalMx');
fvect= flip(evalin('base', 'fvect'));
timeMx= evalin('base', 'timeMx');

h2= handles.panel2;
AX2= findobj(h2, 'Type', 'axes');
AX2(end)=[];

possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
chGroup= str2double(get(handles.edit6, 'String'));
currentChannels= currentGroup:1:currentGroup+chGroup-1;
nCh= length(currentChannels);

cursorPoint = get(AX2, 'CurrentPoint');
XLIM= AX2(1,1).XLim;
YLIM= AX2(1,1).YLim;

if nCh==1
    xScal= cursorPoint(1,1);
    if xScal < XLIM(1) || xScal > XLIM(2)
        set(handles.edit7, 'String', ' ')
        return
    end
    if  cursorPoint(1,2)>= YLIM(1) && cursorPoint(1,2)<= YLIM(2)
        yScal= cursorPoint(1,2);
        selScal= 1;
    else
        set(handles.edit7, 'String', ' ')
        return
    end
else
    xScal= cursorPoint{1}(1,1);
    if xScal < XLIM(1) || xScal > XLIM(2)
        set(handles.edit7, 'String', ' ')
        return
    end
    for i= 1:nCh
        if  cursorPoint{i}(1,2)>= YLIM(1) && cursorPoint{i}(1,2)<= YLIM(2)
            yScal= cursorPoint{i}(1,2);
            selScal= i;
        end
    end
end

if exist('yScal', 'var')==0
    set(handles.edit7, 'String', ' ')
    return
end

[~, idxf]= min(abs(fvect- yScal));
f= fvect(idxf);
tvect= timeMx(currentWindow,1):1/SR: timeMx(currentWindow,2);
[~, idxt]= min(abs(tvect- xScal));
t= tvect(idxt);
POW= scalMx{currentChannels(selScal),currentWindow};
selPow= POW(idxf, idxt);


gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);

g1data = guidata(gui1);
RB2= get(g1data.radiobutton2, 'Value');
RB3= get(g1data.radiobutton3, 'Value');
RB4= get(g1data.radiobutton4, 'Value');

if RB2 == 1
    measUnit= '\muV';
elseif RB3 == 1
    measUnit= 'fT';
else
    measUnit= 'nAm';
end
set(handles.edit7, 'String', {['t= ' num2str(round(t,2)) 'ms'] ;  ['f= ' num2str(round(f,2)) ['Hz'] ];['% Pow= ' num2str(selPow, '%10.2e') '(' measUnit ')^2' ]}, ...
    'FontWeight', 'bold', 'FontSize',10);


function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON FOR WAVELETS VALUE VIEW DISABLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton17_Callback(hObject, eventdata, handles)
set(handles.edit7, 'String', ' ', 'Enable', 'Off')
set(gcf, 'WindowButtonDownFcn', '');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR ENABLING THE EDIT BOX TO INSERT FREQUANCY VALUE FOR THE
% KURTOSIS PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton20_Callback(hObject, eventdata, handles)
set(handles.edit8, 'Enable', 'On')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSHBUTTON FOR PLOTTING ALL THE KURTOSIS VALUES FOR ALL THE FREQUENCIES
% VALUES IN THE CURRENT WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton23_Callback(hObject, eventdata, handles)
fvect= evalin('base', 'fvect');
kurtMx=  evalin('base', 'kurtMx');
currentWindow= round(get(handles.slider1, 'Value'));
possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
chGroup= str2double(get(handles.edit6, 'String'));
currentChannels= currentGroup:1:currentGroup+chGroup-1;
timeMx= evalin('base', 'timeMx');

gui1 = findobj('Tag','GUI1');
g1data = guidata(gui1);
chIdx= get(g1data.listbox1,'Value');
if isempty(chIdx)
    warndlg('Please select channels','!! Warning !!')
    return
end
chList= get(g1data.listbox1, 'String');

for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

nCh= length(currentChannels);

if nCh==1
     kurtInt= kurtMx{currentChannels, currentWindow};
     figure()
     set(gcf, 'Color', 'white')
     plot(fvect, kurtInt')
     title({['Kurtosis in '  chSel{1,currentChannels} ' from '  num2str(round(timeMx(currentWindow,1))) ' to '  num2str(round(timeMx(currentWindow,2))) 'sec'];...
            ['mean Kurt= ' num2str(mean(kurtInt))] })
     xlabel('Freq. [Hz]', 'FontWeight','bold', 'FontSize', 12)
     ylabel('Kurtosis', 'FontWeight','bold', 'FontSize', 12)
        
else
    figure()
    set(gcf, 'Position', [250 250 900 500])
    strLeg= cell(nCh,1);
    cmap= hsv(nCh);
    for i=1:nCh
        kurt= kurtMx{currentChannels(i), currentWindow};
        kurtSort= sort(kurt);
        nk= round(length(kurtSort)*0.05); %Trimmed kurtosis
        kurtInt= kurt;
        kurtInt(1:nk)=[];
        kurtInt(end-nk:end)=[];
                
        meanK(i)= mean(kurtInt) ; % mean value of all the frequencies
        
        kk(i)=subplot(nCh,1,i);
        plot(flip(fvect), flip(kurt),'Color',cmap(i,:), 'LineWidth', 2)
        hold on
        kurt2= kurt;
        kurt2(end-5:end)= [];
        kurt2(1:5)= [];
        [mK, iK]= max(kurt2);
        plot(fvect(iK+5), mK, '*', 'LineWidth', 2)
            
        strLeg{i}= chSel{1,currentChannels(i)};
        box off
        set(gcf, 'Color', 'white')
        
        ylabel(chSel{1,currentChannels(i)}, 'FontWeight','bold', 'FontSize', 8)
        xlim([min(fvect) max(fvect)])
        set(gca, 'XTick', round(min(fvect),0):10: round(max(fvect),0))
        ymax(i)= max(kurt);
        ymin(i)= min(kurt);
        tt(i)= text(max(fvect),ymin(i)+ (ymax(i)-ymin(i))/2, ['Trimm. Kurt= ' num2str(round(meanK(i),2))], 'FontSize', 10, 'FontWeight', 'bold');

        if i==1
             title(['Kurtosis in current channels from '  num2str(round(timeMx(currentWindow,1))) ' to '  num2str(round(timeMx(currentWindow,2))) 'sec'], 'FontSize', 12)
        end
    end
    set(kk, 'YLim', [min(ymin) max(ymax)])
    xlabel('Freq. [Hz]')
    
    sortMeanK= sort(meanK);
    maxK1= sortMeanK(end);
    maxK2= sortMeanK(end-1);
    
    ik1= find(meanK==maxK1);
    ik2= find(meanK==maxK2);
    
    set(tt(ik1), 'Color', 'green')
    set(tt(ik2), 'Color', 'green')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDITBOX FOR CHOOSING FREQUENCY FOR THE KURTOSIS PLOT 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
freqKurt= get(hObject, 'String');
fvect= evalin('base', 'fvect');
kurtMx=  evalin('base', 'kurtMx');

currentWindow= round(get(handles.slider1, 'Value'));
possValGroup= 1:1:get(handles.slider5, 'Max');
currentGroup= get(handles.slider5, 'Value');

if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider5, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end
chGroup= str2double(get(handles.edit6, 'String'));
currentChannels= currentGroup:1:currentGroup+chGroup-1;
    
freqKurt= str2double(freqKurt);

if freqKurt < min(fvect) || freqKurt > max(fvect) || isempty(freqKurt) || isnan(freqKurt)
    warndlg('Frequency out of limits', '!! Warning !!')
    return
else
    set(handles.axes3, 'Visible', 'On')
    nCh= length(currentChannels);
    [~, idxFreqKurt]= min(abs(fvect-freqKurt));
    kurtVect= zeros(nCh,1);
    
    for i= 1:nCh
        kurtInt= kurtMx{currentChannels(i), currentWindow};
        kurtVect(i)= kurtInt(idxFreqKurt);
    end
    
    if nCh==1
        plot(handles.axes3,  1, kurtVect,'diamond', 'LineWidth', 2, 'Color', 'red');
        set(handles.axes3,'YLim',[0 100], 'YTickLabel', [])
    else
        plot(handles.axes3,  1:nCh, kurtVect, 'LineWidth', 2, 'Color', 'red');
        set(handles.axes3,'YLim',[0 100])
    end
    xlabel(handles.axes3, 'Channels', 'rot', 90, 'FontWeight', 'bold', 'FontSize', 8)
    ylabel(handles.axes3, 'Kurtosis', 'FontWeight', 'bold', 'FontSize', 8)
    set(handles.axes3,'Xtick',1:nCh)
        
    view(handles.axes3, 90, 90)
    uistack(handles.axes3, 'top')
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON FOR CURRENT KURTOSIS PLOT DELETING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton22_Callback(hObject, eventdata, handles)
kk= get(handles.axes3, 'Children');
if isempty(kk)
    return
else
    set(handles.axes3, 'Visible', 'off')
    set(handles.edit8, 'Enable', 'off')
    delete(kk)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON FOR CURRENT FIGURE SAVING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton4_Callback(~, ~, ~)
[fileName, filePath] = uiputfile('*.png', 'Save Image As:');
fullName = fullfile(filePath,fileName);
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r0', fullName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR CURRENT WINDOW NUMBER DISPLAYING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PUSHBUTTON FOR CURRENT GUI CLOSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(~, ~, ~)
close (gcf)
return

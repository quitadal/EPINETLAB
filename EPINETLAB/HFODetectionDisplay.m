function varargout = HFODetectionDisplay(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HFODetectionDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @HFODetectionDisplay_OutputFcn, ...
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


% --- Executes just before HFODetectionDisplay is made visible.
function HFODetectionDisplay_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for HFODetectionDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.slider4, 'Enable', 'Off')

gui3 = findobj('Tag','GUI3');
if isempty(gui3)
    return
end
g3data = guidata(gui3);

RMSWind= str2double(get(g3data.edit1, 'String'));
SDThresh= str2double(get(g3data.edit2, 'String'));
RMSDuration= str2double(get(g3data.edit3, 'String'));
nPeaks= str2double(get(g3data.edit4, 'String'));
RectThresh= str2double(get(g3data.edit5, 'String'));
KWind= str2double(get(g3data.edit8, 'String'));
KSDThresh= str2double(get(g3data.edit9, 'String'));
KDuration= str2double(get(g3data.edit10, 'String'));

set(handles.text4, 'String', ['RMS Wind= ' num2str(RMSWind) 'ms; SD Thresh= ' num2str(SDThresh) '; RMS Duration= ' num2str(RMSDuration) 'ms' ...
                              '; No. Peaks rect EEG= ' num2str(nPeaks) '; SD Thresh rect EEG= ' num2str(RectThresh)])
set(handles.text5, 'String', ['Coeff Wind= ' num2str(KWind) 'ms; SD Thresh= ' num2str(KSDThresh) '; Coeff Duration= ' num2str(KDuration) 'ms'])

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

set(handles.edit2, 'String', ['1 of ' num2str(nWind)])

h1= handles.panel1;
h2= handles.panel2;
chIdx= get(g3data.listbox1, 'Value');
nCh= length(chIdx);

timeFreqPanelUpdateHFO(1,nCh,nCh, h1, h2, 100, 100,'jet');
set(handles.slider4, 'Min', 1, 'Max', 1, 'Value', 1);
set(handles.slider2, 'Min', 1, 'Max', 199, 'Value', 100, 'SliderStep', [1/198 , 1/198 ]);
set(handles.slider3, 'Min', 1, 'Max', 199, 'Value', 100, 'SliderStep', [1/198 , 1/198 ]);
set(handles.edit1, 'Enable', 'Off', 'String', nCh )


function varargout = HFODetectionDisplay_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
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

if nWind==1
    set(hObject, 'Min', 0, 'Max', nWind, 'Value', 1, 'Enable', 'Off');
else
    set(hObject, 'Min', 1, 'Max', nWind, 'Value', 1, 'SliderStep', [1/(nWind-1) , 1/(nWind-1) ]);
end

function slider1_Callback(hObject, eventdata, handles)
currentWindow= get(hObject, 'Value');
nWind= evalin('base', 'nWind');
chGroup= str2double(get(handles.edit1, 'String'));
currentGroup= get(handles.slider4, 'Value');
possValGroup= 1:1:get(handles.slider4, 'Max');
if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end

currentSens= get(handles.slider2, 'Value');
currentSens2= get(handles.slider3, 'Value');

currentCol= 'jet';

h1= handles.panel1;
h2= handles.panel2;

possVal= 1:1:nWind;

if ismember(currentWindow, possVal)
    timeFreqPanelUpdateHFO(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
else
    tmp= abs(possVal-currentWindow);
    [~, idx]= min(tmp);
    currentWindow= possVal(idx);
    timeFreqPanelUpdateHFO(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
end

set(handles.edit2, 'String', [num2str(currentWindow) ' of ' num2str(nWind)])


function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider4_Callback(hObject, eventdata, handles)
currentGroup= get(hObject, 'Value');
chGroup= str2double(get(handles.edit1, 'String'));
currentSens2= get(handles.slider3, 'Value');
currentSens= get(handles.slider2, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentCol= 'jet';

gui3 = findobj('Tag','GUI3');
g3data = guidata(gui3);
chIdx= get(g3data.listbox1, 'Value');
nCh= length(chIdx);

h1= handles.panel1;
h2= handles.panel2;
nStep= nCh-chGroup+1;

possValGroup= 1:1:nStep;

if ismember(currentGroup, possValGroup)
    currentGroup= nStep-currentGroup+1; % to make the slider scroll from top to bottom
    timeFreqPanelUpdateHFO(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= nStep-currentGroup+1;% to make the slider scroll from top to bottom
    timeFreqPanelUpdateHFO(currentWindow,chGroup, currentGroup, h1, h2, currentSens,currentSens2, currentCol);
end

function pushbutton8_Callback(hObject, eventdata, handles)


function pushbutton1_Callback(hObject, eventdata, handles)
set(handles.edit1, 'Enable', 'On')
set(handles.slider4, 'Enable', 'On')

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)
chGroup= str2double(get(hObject, 'String'));
if isempty(chGroup) || isnan(chGroup)
    warndlg('Please select the correct number of channels', 'Wrong number of channel');
    return
end
gui3 = findobj('Tag','GUI3');
g3data = guidata(gui3);
chIdx= get(g3data.listbox1,'Value');
nCh= length(chIdx);

if chGroup >= nCh
    set(handles.slider4, 'Enable', 'Off')
    return
else
    set(handles.slider4, 'Enable', 'On')
end

currentSens= get(handles.slider2, 'Value');
currentSens2= get(handles.slider3, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentCol= 'jet';
h1= handles.panel1;
h2= handles.panel2;

AX1= findobj(h1, 'Type', 'axes');
AX2= findobj(h2, 'Type', 'axes');
AX2(end)= [];

delete(AX1)
delete(AX2)

timeFreqPanelUpdateHFO(currentWindow,chGroup, 1, h1, h2, currentSens,currentSens2, currentCol);

nStep= nCh-chGroup+1;
set(handles.slider4, 'Min',1 , 'Max',nStep , 'Value',nStep, 'SliderStep', [1/(nStep-1) , 1/(nStep-1) ]);


function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.edit1, 'Enable', 'Off')
set(handles.slider4, 'Enable', 'Off')
currentWindow= round(get(handles.slider1, 'Value'));
currentSens2= get(handles.slider3, 'Value');
currentSens= get(handles.slider2, 'Value');

currentCol= 'jet';

gui3 = findobj('Tag','GUI3');
g3data = guidata(gui3);
chIdx= get(g3data.listbox1,'Value');
nCh= length(chIdx);

h1= handles.panel1;
h2= handles.panel2;

timeFreqPanelUpdateHFO(currentWindow,nCh, nCh, h1, h2, currentSens,currentSens2, currentCol);
set(handles.edit1, 'String', nCh)
set(handles.slider4, 'Value', 1, 'Max', 1)


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider3_Callback(hObject, eventdata, handles)
currentSens2= get(hObject, 'Value');
currentSens= get(handles.slider2, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentCol= 'jet';
chGroup= str2double(get(handles.edit1, 'String'));
possValGroup= 1:1:get(handles.slider4, 'Max');
currentGroup= get(handles.slider4, 'Value');
if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end

h1= handles.panel1;
h2= handles.panel2;

[~, sensFact2 ]= timeFreqPanelUpdateHFO(currentWindow, chGroup, currentGroup, h1, h2,currentSens,currentSens2, currentCol);

set(handles.edit5, 'String', num2str(sensFact2), 'FontWeight', 'bold')

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDER FOR CHANNELS SENSITIVITY SCROLLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider2_Callback(hObject, eventdata, handles)
currentSens= get(hObject, 'Value');
currentWindow= round(get(handles.slider1, 'Value'));
currentSens2= get(handles.slider3, 'Value');
chGroup= str2double(get(handles.edit1, 'String'));
possValGroup= 1:1:get(handles.slider4, 'Max');
currentGroup= get(handles.slider4, 'Value');
if ismember(currentGroup, possValGroup)
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1; % to make the slider scroll from top to bottom
  else
    tmp= abs(possValGroup-currentGroup);
    [~, idx]= min(tmp);
    currentGroup= possValGroup(idx);
    currentGroup= get(handles.slider4, 'Max')-currentGroup+1;% to make the slider scroll from top to bottom
end

currentCol= 'jet';
h1= handles.panel1;
h2= handles.panel2;

[sensFact,~ ]= timeFreqPanelUpdateHFO(currentWindow, chGroup, currentGroup, h1, h2,currentSens,currentSens2, currentCol);
set(handles.edit3, 'String', num2str(sensFact), 'FontWeight', 'bold')

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Export detected HFO into a .txt file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton9_Callback(hObject, eventdata, handles)
HFOMX= evalin('base', 'HFOMX');
SR= evalin('base', 'EEG.srate');
timeMx= evalin('base','timeMx');
nWind= evalin('base', 'nWind');

gui3 = findobj('Tag','GUI3');
g3data = guidata(gui3);
chIdx=  get(g3data.listbox1, 'Value');
chList= get(g3data.listbox1, 'String');
chListDet= chList(chIdx);
nCh= length(chListDet);

[fileName, filePath] = uiputfile('StabaBased_HFO.txt', 'Save Staba HFO');

if ischar(fileName)== 0 && ischar(filePath)==0
   return    
end

fullName = fullfile(filePath,fileName);

fid= fopen(fullName, 'wt');
fprintf(fid, '%12s\t%12s\t%12s\t%12s\t%12s\t%12s\t%12s\r\n', '     Channel', '      TotHFO', '      HFOIdx', '   tstart[s]', '     tend[s]', '      Dur[s]', '  Dur[sampl]' );


for c= 1:nCh
   idx= 1;
   totEvents=cellfun(@(x) size(x,1), HFOMX(c,:), 'UniformOutput',0);
   totEventMX= cell2mat(totEvents);
   nTotHFO= sum(totEventMX);
   
   for w= 1: nWind
        hfoEvent= HFOMX{c,w};
        if isempty(hfoEvent)== 0
           ws= timeMx(w,1);
                    
           nHFOpw= size(hfoEvent,1);
           
           for n=1:nHFOpw
               ts= ws+ hfoEvent(n,1)/SR;
               te= ws+ hfoEvent(n,2)/SR;
               durTime= te-ts;
               durSampl= hfoEvent(n,2)- hfoEvent(n,1);
                    if idx == 1
                        fprintf(fid, '%12s\t%12d\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', deblank(chListDet{c}),  nTotHFO, idx, ts, te, durTime, durSampl);
                    else
                        fprintf(fid, '%12s\t%12s\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', [], [],  idx, ts, te, durTime, durSampl);
                    end
               idx= idx + 1;
           end
            
        end
    
   end
end

fclose(fid);


function pushbutton10_Callback(hObject, eventdata, handles)
HFOMX= evalin('base', 'HFOCOEFFnoArt');
timeMx= evalin('base','timeMx');
SR= evalin('base', 'EEG.srate');
nWind= evalin('base', 'nWind');

gui3 = findobj('Tag','GUI3');
g3data = guidata(gui3);
chIdx=  get(g3data.listbox1, 'Value');
chList= get(g3data.listbox1, 'String');
chListDet= chList(chIdx);
nCh= length(chListDet);
[fileName, filePath] = uiputfile('WaveletBased_HFO.txt', 'Save Wavelet-based HFO');

if ischar(fileName)== 0 && ischar(filePath)==0
   return    
end
fullName = fullfile(filePath,fileName);

fid= fopen(fullName, 'wt');
fprintf(fid, '%12s\t%12s\t%12s\t%12s\t%12s\t%12s\t%12s\r\n', '     Channel', '      TotHFO', '      HFOIdx', '   tstart[s]', '     tend[s]', '      Dur[s]', '  Dur[sampl]' );


for c= 1:nCh
   idx= 1;
   totEvents=cellfun(@(x) size(x,1), HFOMX(c,:), 'UniformOutput',0);
   totEventMX= cell2mat(totEvents);
   nTotHFO= sum(totEventMX);
   
   for w= 1: nWind
        hfoEvent= HFOMX{c,w};
        if isempty(hfoEvent)== 0
           ws= timeMx(w,1);
           nHFOpw= size(hfoEvent,1);
           
           for n=1:nHFOpw
               ts= ws+ hfoEvent(n,1)/SR;
               te= ws+ hfoEvent(n,2)/SR;
               durTime= te-ts;
               durSampl= hfoEvent(n,2)- hfoEvent(n,1);
                    if idx == 1
                        fprintf(fid, '%12s\t%12d\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', deblank(chListDet{c}) ,  nTotHFO, idx, ts, te, durTime, durSampl);
                    else
                        fprintf(fid, '%12s\t%12s\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', [] , [],  idx, ts, te, durTime, durSampl);
                    end
               idx= idx + 1;
           end
        end
   end
end

fclose(fid);


function pushbutton3_Callback(hObject, eventdata, handles)
[fileName, filePath] = uiputfile('*.png', 'Save Image As:');

if fileName == 0 && filePath == 0
   return    
end
fullName = fullfile(filePath,fileName);
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r0', fullName)

function pushbutton4_Callback(hObject, eventdata, handles)
close (gcf)
return

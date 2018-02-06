%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MyTimeFrequency- This function opens the GUI for the setting of
% parameters for the WAVELET analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = MyTimeFrequency(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MyTimeFrequency_OpeningFcn, ...
    'gui_OutputFcn',  @MyTimeFrequency_OutputFcn, ...
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


% --- Executes just before MyTimeFrequency is made visible.
function MyTimeFrequency_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.pushbutton1, 'Visible', 'On');
set(handles.pushbutton4, 'Enable', 'Off');
set(handles.pushbutton5, 'Enable', 'Off');
set(handles.pushbutton8, 'Visible', 'On', 'Enable', 'Off');
set(handles.pushbutton9, 'Visible', 'On', 'Enable', 'Off');
set(handles.edit2, 'String', '1');
set(handles.edit3, 'String', '0');
set(handles.edit4, 'String', 'all');
set(handles.edit5, 'String', '80 250');
set(handles.edit7, 'String', []);
set(handles.edit8, 'String', 'haar');
set(handles.edit9, 'String', '1');
set(handles.radiobutton2, 'Value', 1)
set(handles.radiobutton3, 'Value', 0)
set(handles.radiobutton4, 'Value', 0)
set(handles.slider1, 'Min', 1, 'Max', 10, 'Value', 1, 'SliderStep', [1/9 1/9])

wavlist= {'haar','db','sym','coif','bior','rbio','meyr','dmey','gaus', 'mexh', 'morl','cgau','shan','fbsp','cmor' };
set(handles.popupmenu1, 'String', wavlist);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot deafault HAAR wavelet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[PSI, XVAL, TITLE]= plotMotherWavelet('haar');
subplot(1,1,1, 'Parent', handles.uipanel5);
plot(XVAL, PSI, 'blue', 'LineWidth', 1.5)
xlim([min(XVAL) max(XVAL)])
set(gca, 'XTickLabel', [], 'YTickLabel', [])
xlabel('Time')
ylabel([char(966) '(t)'])
set(handles.uipanel5, 'Title', TITLE, 'FontSize', 10, 'FontWeight', 'bold')
set(handles.edit8, 'String', 'haar')


W = evalin('base','whos');
if isempty(W)
    inBase= 0;
    set(handles.listbox1, 'String', []);
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if inBase==0
    chLocs= [];
    assignin('base', 'ALLEEG', [])
    set(handles.listbox1, 'String', []);
else
    chLocs= evalin('base','EEG.chanlocs');
    data= evalin('base','EEG.data');
    if isempty(chLocs)
        if isempty(data)
           chList= [];
        else
        nchs= evalin('base', 'EEG.nbchan');
        for i=1:nchs
            if i < 10
                chList{i}= ['Ch0' num2str(i)];
            else
                chList{i}= ['Ch' num2str(i)];
            end
        end
        end
    else
        nchs= length(chLocs);
        for i=1: nchs
            chList{i}= chLocs(i).labels;
        end
    end
    
    set(handles.listbox1, 'String', chList);
    filename= evalin('base', 'EEG.filename');
    filepath= evalin('base', 'EEG.filepath');
    
    if isempty( filename) || isempty(filepath)
        strDisp= [];
    else
        if strcmp(filepath(end), filesep)
            strDisp= [filepath filename];
        else
            strDisp= [filepath filesep filename];
        end
    end
    assignin('base', 'ALLEEG', [])
    set(handles.edit7, 'String', strDisp)
    set(handles.pushbutton1, 'Enable', 'on')
end



% --- Outputs from this function are returned to the command line.
function varargout = MyTimeFrequency_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PUSHBUTTON AND EDIT TEXT FOR SELECTING FILE TO BE ANALYSED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton7_Callback(hObject, eventdata, handles)
[filename, filepath]= uigetfile('*.set', 'Select .set file');

if ischar(filename) == 0 && ischar(filepath) == 0
    return
else
    strDispl= [filepath filename];
    set(handles.edit7, 'String', strDispl);
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

set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nchs)

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SLIDER FOR SELECTING CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox1_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSH BUTTON FOR SELECTING ALL CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton6_Callback(hObject, eventdata, handles)
chList= get(handles.listbox1, 'String');
if isempty(chList)
    warndlg('Please select EEG file','!! Warning !!')
else
    set(handles.listbox1, 'Value', 1:length(chList))
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE SIGNAL TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton3, 'Value',0)
set(handles.radiobutton4, 'Value',0)

function radiobutton3_Callback(hObject, eventdata, handles)
set(handles.radiobutton2, 'Value',0)
set(handles.radiobutton4, 'Value',0)

function radiobutton4_Callback(hObject, eventdata, handles)
set(handles.radiobutton2, 'Value',0)
set(handles.radiobutton3, 'Value',0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR SELECTING WINDOW LENGHT [SEC]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR SELECTING WINDOW OVERLAP [SEC]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR SELECTING INTERVAL LENGHT SEC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR SELECTING FREQUENCY BAND [Hz]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POPUP MENU FOR SELECTING MOTHER WAVELET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu1_Callback(hObject, eventdata, handles)
wavIdx= get(hObject,'Value');
wavlist= get(hObject,'String');
defWav= 'haar';
selWavInt= wavlist{wavIdx};

switch selWavInt
    case 'db'
        str = {'db1', 'db2', 'db3', 'db4', 'db5', 'db6', 'db7', 'db8', 'db9', 'db10', 'db20'};
        [s,v] = listdlg('PromptString','Select a Daubechies wavalet:',...
            'SelectionMode','single', 'ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'sym'
        str = {'sym2', 'sym3', 'sym4', 'sym5', 'sym6', 'sym7', 'sym8'};
        [s,v] = listdlg('PromptString','Select a Symlets wavalet:',...
            'SelectionMode','single','ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'coif'
        str = {'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
        [s,v] = listdlg('PromptString','Select a Coiflets wavalet:',...
            'SelectionMode','single', 'ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'bior'
        str = {'bior1.1', 'bior1.3','bior1.5','bior2.2', 'bior2.4', 'bior2.6', 'bior2.8', 'bior3.1',...
            'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'};
        [s,v] = listdlg('PromptString','Select a BiorSplines wavalet:',...
            'SelectionMode','single','ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'rbio'
        str = {'rbio1.1', 'rbio1.3','rbio1.5','rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8', 'rbio3.1',...
            'rbio3.3', 'rbio3.5', 'rbio3.7', 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'};
        [s,v] = listdlg('PromptString','Select a ReverseBior wavalet:',...
            'SelectionMode','single','ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'gaus'
        str = {'gaus1', 'gaus2','gaus3', 'gaus4', 'gaus5', 'gaus6', 'gaus7','gaus8' };
        [s,v] = listdlg('PromptString','Select a Gaussian wavalet:',...
            'SelectionMode','single', 'ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'cgau'
        str = {'cgau1', 'cgau2','cgau3', 'cgau4', 'cgau5'};
        [s,v] = listdlg('PromptString','Select a Complex Gaussian wavalet:',...
            'SelectionMode','single','ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'shan'
        str = {'shan1-1.5','shan1-1','shan1-0.5','shan1-0.1','shan2-3'};
        [s,v] = listdlg('PromptString','Select a Shannon wavalet:',...
            'SelectionMode','single','ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'fbsp'
        str = {'fbsp1-1-1.5', 'fbsp1-1-1', 'fbsp1-1-0.5','fbsp2-1-1','fbsp2-1-0.5','fbsp2-1-0.1'};
        [s,v] = listdlg('PromptString','Select a Frequency B-Spline wavalet:',...
            'SelectionMode','single', 'ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    case 'cmor'
        str = {'cmor1-1.5','cmor1-1', 'cmor1-0.5','cmor1-0.1', 'cmor2-1.5', 'cmor2-1', 'cmor2-0.5', 'cmor2-0.1','cmor3-1.5'};
        [s,v] = listdlg('PromptString','Select a Complex Morlet wavalet:',...
            'SelectionMode','single', 'ListString', str);
        if v~=0
            selWav= str{s};
        else
            selWav= defWav;
            selWavInt= selWav;
        end
        
    otherwise
        selWav= selWavInt;
end

[PSI, XVAL, TITLE]= plotMotherWavelet(selWav);
myhandles= guidata(gcbo);
wavPlot= findobj(myhandles.uipanel5, 'Type', 'axes');

if size(wavPlot, 1)==2
    delete(wavPlot(1,1))
    delete(wavPlot(2,1))
else
    delete(wavPlot)
end

p5=  handles.uipanel5;
set(p5, 'Title', TITLE, 'FontSize', 10, 'FontWeight', 'bold')


if strcmp(selWavInt, 'shan') || strcmp(selWavInt, 'fbsp') || strcmp(selWavInt, 'cmor')|| strcmp(selWavInt, 'cgau')
    ax1(1)=subplot(1,2,1,  'Parent', p5);
    plot(XVAL, real(PSI), 'blue', 'LineWidth', 1.5)
    xlim([min(XVAL) max(XVAL)])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    xlabel('Time')
    ylabel([' Real ' char(966) '(t)'])
    
    ax1(2)= subplot(1,2,2,  'Parent', p5);
    plot(XVAL, imag(PSI), 'red', 'LineWidth', 1.5)
    
    xlim([min(XVAL) max(XVAL)])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    xlabel('Time')
    ylabel(['Imaginary ' char(966) '(t)'])
    
elseif strcmp(selWavInt, 'bior') || strcmp(selWavInt, 'rbio')
    ax1(1)=subplot(1,2,1, 'Parent', p5);
    plot(XVAL, PSI(1,:), 'blue', 'LineWidth', 1.5)
    xlim([min(XVAL) max(XVAL)])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    xlabel('Time')
    ylabel(['First ' char(966) '(t)'])
    
    ax1(2)=subplot(1,2,2,  'Parent', p5);
    plot(XVAL, PSI(2,:), 'red', 'LineWidth', 1.5)
    xlim([min(XVAL) max(XVAL)])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    xlabel('Time')
    ylabel(['Second ' char(966) '(t)'])
else
    ax1= subplot(1,1,1, 'Parent', p5);
    plot(XVAL, PSI, 'blue', 'LineWidth', 1.5)
    xlim([min(XVAL) max(XVAL)])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    xlabel('Time')
    ylabel([char(966) '(t)'])
    
end

set(handles.edit8, 'String', selWav)
set(handles.pushbutton5, 'Enable', 'Off');
set(handles.pushbutton4, 'Enable', 'Off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT BOX FOR DISPLAYING MOTHER WAVELET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit8_Callback(hObject, eventdata, handles)
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSH BUTTON FOR STARTING ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
fileToOpen= get(handles.edit7, 'String');
if isempty(fileToOpen) && isempty(get(handles.listbox1, 'String'))
      warndlg('Please select EEG file','!! Warning !!')
     return
end
if isempty(fileToOpen)
    EEG= evalin('base', 'EEG');
else
    EEG = pop_loadset(fileToOpen);
end

%%%%%%%%%%%%%%%%%%%%%
% Query EDIT2 value
%%%%%%%%%%%%%%%%%%%%%
windLen= str2double(get(handles.edit2, 'String'));
SR= evalin('base','EEG.srate');
windLenSampl= ceil(windLen*SR);
WINDOWLEN= windLenSampl;
if  isnan(WINDOWLEN)
    warndlg('Please select correct window length','!! Warning !!')
    return
end
if WINDOWLEN <=0
    warndlg('Please select correct window length','!! Warning !!')
    return
end

%%%%%%%%%%%%%%%%%%%%%
% Query EDIT3 value
%%%%%%%%%%%%%%%%%%%%%
windOver= str2double(get(handles.edit3, 'String'));
windOverSampl= ceil(SR*windOver);
WINDOWOVER= windOverSampl;

if  isnan(WINDOWOVER)
    warndlg('Please select correct window overlap','!! Warning !!')
    return
end
if  WINDOWOVER <0
    warndlg('Please select correct window overlap','!! Warning !!')
    return
end

%%%%%%%%%%%%%%%%%%%%%
% Query EDIT4 value
%%%%%%%%%%%%%%%%%%%%%
inspInterv= get(handles.edit4, 'String');
intDur= evalin('base', 'EEG.pnts');

if strcmp(inspInterv,'all')
    inspIntervLim1= 1;
    inspIntervLim2= intDur;
else
    intIntervNum= str2num(inspInterv);
    if isempty(intIntervNum)
        warndlg('Please select correct time interval','!! Warning !!')
        return
    elseif length(intIntervNum)~= 2
        warndlg('Please select correct time interval','!! Warning !!')
        return
    else        
        inspIntervLim1 = ceil(SR* intIntervNum(1)) +1;
        inspIntervLim2 = ceil(SR* intIntervNum(2));
    end
end

INSPINTERVAL= [inspIntervLim1 inspIntervLim2];

if isnan(INSPINTERVAL)
    warndlg('Please select correct interval','!! Warning !!')
    return
end
if length(INSPINTERVAL)~= 2
    warndlg('Please select correct interval','!! Warning !!')
    return
end
if INSPINTERVAL(1)>= INSPINTERVAL(2) || INSPINTERVAL(2)==0
    warndlg('Please select correct interval','!! Warning !!')
    return
end
if INSPINTERVAL(2) > intDur
    warndlg('Selected interval longer than signal','!! Warning !!')
    return
end

%%%%%%%%%%%%%%%%%%%%%
% Query EDIT5 value
%%%%%%%%%%%%%%%%%%%%%
freqBand= str2num(get(handles.edit5, 'String'));
if isempty(freqBand)
    warndlg('Please select correct frequency band','!! Warning !!')
    return
end

BAND= freqBand;

if length(BAND)== 1
    warndlg('Please select correct frequency band','!! Warning !!')
    return
end
if BAND(1)>= BAND(2) || BAND(2)==0 || BAND(1)==0
    warndlg('Please select correct frequency band','!! Warning !!')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%
% Query LISTBOX1 value
%%%%%%%%%%%%%%%%%%%%%%%
chIdx= get(handles.listbox1,'Value');

if isempty(chIdx)
    warndlg('Please select channels','!! Warning !!')
    return
end

chList= get(handles.listbox1, 'String');
for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

%%%%%%%%%%%%%%%%%%%%%%%
% Query POPUPMENU1 value
%%%%%%%%%%%%%%%%%%%%%%%
selWavInt= get(handles.edit8, 'String');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call to the Analysis function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataMx=  EEG.data;
myWavComput(dataMx, SR, chIdx, chSel, INSPINTERVAL, WINDOWLEN, WINDOWOVER, BAND, selWavInt) ;
set(handles.pushbutton4, 'Enable', 'On');
set(handles.pushbutton5, 'Enable', 'On');

set(handles.pushbutton8, 'Enable', 'On');
set(handles.pushbutton9, 'Enable', 'On');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSH BUTTON FOR OPENING GRAPH WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton4_Callback(hObject, eventdata, handles)
MyTFDisplay;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSH BUTTON FOR SAVING ANALYSIS RESULTS INTO A MATLAB STRUCTURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton5_Callback(hObject, eventdata, handles)
% Save results in  Matlab structure
resStruct = [];
resStruct.NAMESTR= evalin('base', 'EEG.setname');

chIdx= get(handles.listbox1,'Value');
if isempty(chIdx)
    warndlg('Please select channels','!! Warning !!')
    return
end
chList= get(handles.listbox1, 'String');

for i= 1:length(chIdx)
    chSel{1,i}= chList{1,chIdx(i)};
end

resStruct.CHSEL= chSel;
windLenMS= str2double(get(handles.edit2, 'String'));
SR= evalin('base','EEG.srate');
windLen= ceil(windLenMS*SR);
resStruct.WINDOWLEN= windLen;

windOverMS= str2double(get(handles.edit3, 'String'));
windOver= ceil(windOverMS*SR);
resStruct.WINDOWOVER= windOver;

intDur= evalin('base', 'EEG.pnts');
inspInterv= get(handles.edit4, 'String');
if strcmp(inspInterv,'all')
    inspIntervLim1= 1;
    inspIntervLim2= intDur;
else
    intInter= str2num(inspInterv);
    inspIntervLim1 = ceil(SR* intInter(1)) +1;
    inspIntervLim2 = ceil(SR* intInter(2));
end
inspInterv2= [inspIntervLim1 inspIntervLim2];
resStruct.INSPINTERVAL= inspInterv2;

resStruct.BAND= str2num(get(handles.edit5, 'String'));
resStruct.SELWAV=  get(handles.edit8, 'String');
resStruct.SCALOGRAM= evalin('base', 'scalMx');
resStruct.FVECT= evalin('base', 'fvect');
resStruct.TIMEMX= evalin('base', 'timeMx');

OutputfileName= [resStruct.NAMESTR '.mat'];

[fileSave,pathSave] = uiputfile(OutputfileName,'Save configuration and results');

save([pathSave fileSave], 'resStruct')
disp('Analysis saved')


function pushbutton8_Callback(hObject, eventdata, handles)
HFOStatistics

function pushbutton9_Callback(hObject, eventdata, handles)
HFODetection2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET DIPLAY RESOLUTION DECIMATION FACTOR IN CASE OF HIGH SAMPLING RATE OR
% NUMBER OF CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider1_Callback(hObject, eventdata, handles)
SL1= get(hObject, 'Value');
set(handles.edit9, 'String', num2str(SL1))

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_Callback(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUSH BUTTON FOR CLOSING FIGURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton2_Callback(hObject, eventdata, handles)
close(gcf)
disp= findobj('Name', 'MyTFDisplay');
if ~ isempty(disp)
    close(disp)
end

dispStat= findobj('Name', 'HFOStatistics');
if ~ isempty(dispStat)
    close(dispStat)
end

HFODetection= findobj('Name', 'HFODetection2');
if ~ isempty(HFODetection)
    close(HFODetection)
end


HFODetectionDisplay= findobj('Name', 'HFODetectionDisplay');
if ~ isempty(HFODetectionDisplay)
    close(HFODetectionDisplay)
end



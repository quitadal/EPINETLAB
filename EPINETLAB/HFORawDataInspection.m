function varargout = HFORawDataInspection(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HFORawDataInspection_OpeningFcn, ...
    'gui_OutputFcn',  @HFORawDataInspection_OutputFcn, ...
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



function HFORawDataInspection_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.pushbutton3,'Enable', 'off')
set(handles.pushbutton6,'Enable', 'off')


function varargout = HFORawDataInspection_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select Raw Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
ED2= get(handles.edit2, 'String');
if isempty(ED2)
    [filenameRaw, filepathRaw]= uigetfile('*.set', 'Select Raw Data');
else
    [pathstr,~,~] = fileparts(ED2);
    [filenameRaw, filepathRaw]= uigetfile([pathstr '\*.set'], 'Select Raw Data');
end
    

if ischar(filenameRaw) == 0 && ischar(filepathRaw) == 0
    return
else
    strDispl= [filepathRaw filenameRaw];
    set(handles.edit1, 'String', strDispl);
    if isempty(get(handles.edit2, 'String')) == 0
        set(handles.pushbutton3,'Enable', 'on')
        set(handles.pushbutton6,'Enable', 'on')
    end
end

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select HFO results file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton2_Callback(hObject, eventdata, handles)
ED1= get(handles.edit1, 'String');
if isempty(ED1)
    [filenameHFO, filepathHFO]= uigetfile('*.txt', 'Select Raw Data');
else
    [pathstr,~,~] = fileparts(ED1);
    [filenameHFO, filepathHFO]= uigetfile([pathstr '\*.txt'], 'Select Raw Data');
end

if ischar(filenameHFO)== 0 && ischar(filepathHFO)==0
    return
end

fidHFO= fopen([filepathHFO  filenameHFO], 'r');
formatSpec = '%13s%13s%13s%13s%13s%13s%s%[^\n\r]';

dataArray = textscan(fidHFO, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false);

if strcmp(strtrim(dataArray{1,1}{1,1}), 'Channel')==0 || strcmp(strtrim(dataArray{1,2}{1,1}), 'TotHFO')== 0 || strcmp(strtrim(dataArray{1,3}{1,1}), 'HFOIdx')== 0 ||    strcmp(strtrim(dataArray{1,4}{1,1}), 'tstart[s]')==0 ||    strcmp(strtrim(dataArray{1,5}{1,1}), 'tend[s]')==0 ||    strcmp(strtrim(dataArray{1,6}{1,1}), 'Dur[s]')==0 ||    strcmp(strtrim(dataArray{1,7}{1,1}), 'Dur[sampl]')==0
    warndlg('Wrong .txt file format')
    fclose(fidHFO);
    return
else
    fclose(fidHFO);
    strDispl= [filepathHFO filenameHFO];
    set(handles.edit2, 'String', strDispl);
    if isempty(get(handles.edit1, 'String')) == 0
        set(handles.pushbutton3,'Enable', 'on')
        set(handles.pushbutton6,'Enable', 'on')
    end
end


dataArray{1,1}(1)= []; dataArray{1,2}(1)= []; dataArray{1,3}(1)= [];
dataArray{1,4}(1)= []; dataArray{1,5}(1)= [];dataArray{1,6}(1)= [];dataArray{1,7}(1)= [];


Channel = dataArray{:, 1};
TotHFO = dataArray{:, 2};

if size(Channel,1)> size(TotHFO,1)
    Channel(end)= [];
end

deblankHFO= strtrim(TotHFO);
empHFO= cellfun('isempty', deblankHFO);
deblankHFO(empHFO)={'0'};
deblankHFONum= cellfun(@str2num, deblankHFO);
[deblankHFONumOrd, idxOrd]= sort(deblankHFONum, 'descend');

ChannelOrd= Channel(idxOrd);

for i=1:size(ChannelOrd,1)
    allSpace= isspace(ChannelOrd{i});
    if all(allSpace)
        ChannelOrd{i}=[];
    end
end

emptyChannels= cellfun('isempty',ChannelOrd);
ChannelOrd(emptyChannels)= [];


deblankHFONumOrd(deblankHFONumOrd==0)= [];

for i= 1:size(ChannelOrd)
    Table{i,1}= strtrim(ChannelOrd{i,1});
    Table{i,2}= deblankHFONumOrd(i);
    Table{i,3}= false;
end

set(handles.uitable1, 'Data', Table)
set(handles.uitable1,'ColumnFormat',{'char', 'numeric', 'logical'});
set(handles.uitable1,'ColumnEditable',[false false true]);
set(handles.uitable1,'CellSelectionCallback',@uitable1_CellSelectionCallback)


function SelectedCells= uitable1_CellSelectionCallback(hObject, eventdata, handles)
SelectedCells = eventdata.Indices;




function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform the analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton3_Callback(hObject, eventdata, handles)

fileSET= get(handles.edit1, 'String');
fileHFO= get(handles.edit2, 'String');

EEG= pop_loadset(fileSET);
SR= EEG.srate;

Table= get(handles.uitable1, 'Data');
chToAnalyzeIdx= cell2mat(Table(:,3));
chNames= Table(chToAnalyzeIdx,1);
TotHFO= cell2mat(Table(chToAnalyzeIdx,2));
nCh= length(chNames);
origChan= {EEG.chanlocs.labels};
origChan= deblank(origChan);


fidHFO= fopen(fileHFO, 'r');
formatSpec = '%13s%13s%13s%13s%13s%13s%s%[^\n\r]';
dataArray = textscan(fidHFO, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', 1, 'ReturnOnError', false);
fclose(fidHFO);

Channel = strtrim(dataArray{:, 1});
HFOIdx=   str2double(strtrim(dataArray{:, 3}));
tstart=   str2double(strtrim(dataArray{:, 4}));
tend=     str2double(strtrim(dataArray{:, 5}));
Durs=     str2double(strtrim(dataArray{:, 6}));
Dursampl= str2double(strtrim(dataArray{:, 7}));



for i=1:nCh
    
    chIdxRaw= find(strcmp(chNames{i}, origChan));
    rawEEG= EEG.data(chIdxRaw, :);
    YLim1= min(rawEEG);
    YLim2= max(rawEEG);
    YLim=[YLim1 YLim2];
    
    chIdxHFO= find(strcmp(chNames{i}, Channel));
    totHFO= TotHFO(i);
    
    h =  findobj('type','figure');
    n = length(h);
    
    figure(n+1)
    
    set(gcf, 'Color', 'white')
    
    if totHFO >= 4
        nCols= 4;
        nRows= fix(totHFO/4);
        R= rem(totHFO,4);
        
        if R == 0
            nRows= fix(totHFO/4);
        else
            nRows= fix(totHFO/4) + 1;
        end
    else
        nCols= totHFO;
        nRows= 1;
    end
    
    for j= 1: totHFO
        tstartHFO= fix(tstart(chIdxHFO + j -1)*SR);
        tendHFO= fix(tend(chIdxHFO + j -1)*SR);
        
        tstartPlot= fix((tstart(chIdxHFO + j -1)- 0.5)*SR);
        if tstartPlot<0
            tstartPlot=1;
        end
        
        tendPlot= fix((tstart(chIdxHFO + j -1)+ 0.5)*SR);
        
        if tendPlot > length(rawEEG)
            tendPlot= length(rawEEG);
        end
        
        plotEEG= rawEEG(tstartPlot:tendPlot);
         
        subplot(nRows, nCols, j)
        plot((tstartPlot: tendPlot)./SR, plotEEG)
        
        hold on
        plot([tstartHFO*ones(length(YLim(1):0.01:YLim(2)),1)]./SR,  YLim(1):0.01:YLim(2),'--r')
        hold on
        plot([tendHFO*ones(length(YLim(1):0.01:YLim(2)),1)]./SR,  YLim(1):0.01:YLim(2), '--r')
        
        set(gca, 'XLim', [tstartPlot/SR tendPlot/SR], 'YLim', YLim)
        xlabel('Time [s]');
        ylabel('Ampl. [\muV]');
        box off
        title(['HFO' num2str(j) ', Dur= ' num2str(Durs(chIdxHFO + j -1)*1000) 'ms'])
        
    end
    
    suptitle(['HFOs detected on channel ' chNames{i}]);
end


function pushbutton6_Callback(hObject, eventdata, handles)

fileSET= get(handles.edit1, 'String');
fileHFO= get(handles.edit2, 'String');

if exist('pop_loadset') == 0
    eeglab
end

EEG= pop_loadset(fileSET);
SR= EEG.srate;

Table= get(handles.uitable1, 'Data');
chToAnalyzeIdx= cell2mat(Table(:,3));
chNames= Table(chToAnalyzeIdx,1);
TotHFO= cell2mat(Table(chToAnalyzeIdx,2));
nCh= length(chNames);
origChan= {EEG.chanlocs.labels};
origChan= deblank(origChan);

fidHFO= fopen(fileHFO, 'r');
formatSpec = '%13s%13s%13s%13s%13s%13s%s%[^\n\r]';
dataArray = textscan(fidHFO, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', 1, 'ReturnOnError', false);
fclose(fidHFO);

Channel = strtrim(dataArray{:, 1});
HFOIdx=   str2double(strtrim(dataArray{:, 3}));
tstart=   str2double(strtrim(dataArray{:, 4}));
tend=     str2double(strtrim(dataArray{:, 5}));
Durs=     str2double(strtrim(dataArray{:, 6}));
Dursampl= str2double(strtrim(dataArray{:, 7}));


for i=1:nCh
    
    chIdxRaw= find(strcmp(chNames{i}, origChan));
    rawEEG= EEG.data(chIdxRaw, :);
    YLim1= min(rawEEG);
    YLim2= max(rawEEG);
    YLim=[YLim1 YLim2];
    
    
    chIdxHFO= find(strcmp(chNames{i}, Channel));
    totHFO= TotHFO(i);
    
    h =  findobj('type','figure');
    n = length(h);
    
    hFig=figure(n+1);
    scrsz = get(groot,'ScreenSize');
    set(hFig, 'Color', 'white', 'Position', [1 scrsz(4)/3 scrsz(3)/2 scrsz(4)/2])
    
    axFig= axes;
    
    j=1;
    plotHFOoverEEG(axFig, chNames{i}, j, SR, chIdxHFO,tstart,tend, rawEEG, Durs, YLim)
    
    if totHFO > 1
         uicontrol('Parent',hFig,'Style','slider','Units','normalized','Position', [0.95 0.05 0.05 0.05], ...
        'Min', 1, 'Max' , totHFO, 'Value', 1, 'SliderStep', [1/(totHFO-1) , 1/(totHFO-1)],...
        'CallBack', {@ScrollWindow, axFig,chNames{i}, SR, chIdxHFO,tstart,tend, rawEEG, Durs, YLim});
    end
    
end

function plotHFOoverEEG(FIGHANDLE, CHNAME, j, SRATE, CHIDXHFO,TSTART,TEND, RAWEEG, DURS, YLIM)
cla
tstartHFO= fix(TSTART(CHIDXHFO + j -1)*SRATE);
tendHFO= fix(TEND(CHIDXHFO + j -1)*SRATE);

tstartPlot= fix((TSTART(CHIDXHFO + j -1)- 0.5)*SRATE);

%tstartPlot= fix(fix(TSTART(CHIDXHFO + j -1))*SRATE);

if tstartPlot<=0
    tstartPlot=1;
end

tendPlot= fix((TSTART(CHIDXHFO + j -1)+ 0.5)*SRATE);
%tendPlot= fix(ceil(TSTART(CHIDXHFO + j -1))*SRATE);
if tendPlot > length(RAWEEG)
    tendPlot= length(RAWEEG);
end
plotEEG= RAWEEG(tstartPlot:tendPlot);

YLim= YLIM;
XLim= [tstartPlot/SRATE tendPlot/SRATE];
plot(FIGHANDLE, (tstartPlot: tendPlot)./SRATE, plotEEG)
%set(FIGHANDLE, 'YLim', YLim)

hold on
plot(FIGHANDLE,[tstartHFO*ones(length(YLim(1):0.1: YLim(2)),1)]./SRATE,  YLim(1):0.1:YLim(2),'--r')
hold on
plot(FIGHANDLE,[tendHFO*ones(length(YLim(1):0.1:YLim(2)),1)]./SRATE,    YLim(1):0.1:YLim(2), '--r')

set(gca, 'XLim', XLim)
xlabel('Time [s]');
ylabel('Ampl. [\muV]');
box off
title([ CHNAME ': HFO' num2str(j) ', Dur= ' num2str(DURS(CHIDXHFO + j -1)*1000) 'ms'], 'FontSize', 11, 'FontWeight', 'bold')


function ScrollWindow(hObject, ~, FIGHANDLE, CHNAME, SRATE, CHIDXHFO,TSTART,TEND, RAWEEG, DURS, YLIM)
VAL =  get(hObject, 'Value');
plotHFOoverEEG(FIGHANDLE, CHNAME, VAL, SRATE, CHIDXHFO,TSTART,TEND, RAWEEG, DURS, YLIM)



function pushbutton4_Callback(hObject, eventdata, handles)
close(gcf)
return

function varargout = SeizureFrequencyContentDisplay(varargin)
% SEIZUREFREQUENCYCONTENTDISPLAY MATLAB code for SeizureFrequencyContentDisplay.fig
%      SEIZUREFREQUENCYCONTENTDISPLAY, by itself, creates a new SEIZUREFREQUENCYCONTENTDISPLAY or raises the existing
%      singleton*.
%
%      H = SEIZUREFREQUENCYCONTENTDISPLAY returns the handle to a new SEIZUREFREQUENCYCONTENTDISPLAY or the handle to
%      the existing singleton*.
%
%      SEIZUREFREQUENCYCONTENTDISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEIZUREFREQUENCYCONTENTDISPLAY.M with the given input arguments.
%
%      SEIZUREFREQUENCYCONTENTDISPLAY('Property','Value',...) creates a new SEIZUREFREQUENCYCONTENTDISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SeizureFrequencyContentDisplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SeizureFrequencyContentDisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SeizureFrequencyContentDisplay

% Last Modified by GUIDE v2.5 23-May-2017 15:53:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SeizureFrequencyContentDisplay_OpeningFcn, ...
    'gui_OutputFcn',  @SeizureFrequencyContentDisplay_OutputFcn, ...
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



function SeizureFrequencyContentDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

dataNew= evalin('base','dataNew');
SR= evalin('base', 'EEG.srate');
CHANLOCS= evalin('base', 'EEG.chanlocs');
fvect= evalin('base', 'fvect');
[nCh, nPnt]= size(dataNew);
windAll= ceil(nPnt/SR);

gui1 = findobj('Name','SeizureFrequencyContent');
g1data = guidata(gui1);
if isempty(gui1)
    warndlg('You closed Time-Frequency GUI', 'Time-Frequency Display');
    return
end
chVal= get(g1data.listbox1, 'Value');
chLabels= {CHANLOCS(chVal).labels};
if nCh<=2
    set(handles.listbox1, 'String', chLabels, 'FontSize', 8, 'Value',[], 'Min', 1, 'Max', 3)
else
    set(handles.listbox1, 'String', chLabels, 'FontSize', 8, 'Value',[], 'Min', 1, 'Max', nCh)
end

set(handles.edit3, 'Enable', 'on','String', windAll);
set(handles.edit8, 'Enable', 'inactive','String', 1);
set(handles.slider6, 'Min', 1, 'Max', 10, 'Value', 1, 'SliderStep', [1/9 , 1/9]);
set(handles.slider3, 'Min', round(fvect(end)), 'Max', round(fvect(1)), 'SliderStep', [1/(round(fvect(1))-round(fvect(end))), 1/(round(fvect(1))-round(fvect(end)))] , 'Value', round(fvect(end)))
set(handles.slider7, 'Min', 1 , 'Max', 1000 , 'SliderStep', [1/(999), 1/999], 'Value', [floor(fvect(1))- floor(fvect(end))])
set(handles.slider4, 'Min', 1, 'Max', 1, 'SliderStep', [1 1], 'Value',1, 'Enable', 'off')
set(handles.edit1,  'String', round(fvect(end)));
set(handles.edit4,  'String', [floor(fvect(1))- floor(fvect(end))]);
set(handles.edit5,  'String', []);
colormaplist= {'custom','jet', 'hot', 'parula','gray', 'bone','copper'};
set(handles.popupmenu2, 'String', colormaplist, 'Value', 1);

set(handles.slider9, 'Min', 1, 'Max', 199, 'Value', 100, 'SliderStep', [1/198 , 1/198]);
set(handles.slider11, 'Min', 1, 'Max', 50, 'Value', 50, 'SliderStep', [1/49 , 1/49]);
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;

SeizureFreqContentUpdate(h1, h5, h4, 'custom', 100, floor(fvect(end)), floor(fvect(1))- floor(fvect(end)), nPnt, 1, [], 1, 50)


function varargout = SeizureFrequencyContentDisplay_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider3_Callback(hObject, eventdata, handles)
fCentr= get(hObject, 'Value');
fWide= get(handles.slider7, 'Value');
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;

currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);

chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');
SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide, windLen, currWind, chanToAmpl,AmplVal, timeRes)
set(handles.edit1, 'String', fCentr);



function edit1_Callback(hObject, eventdata, handles)
E1= str2num(get(hObject, 'String'));
fvect= evalin('base', 'fvect');

if E1 > fvect(1) || E1 < fvect(end)
    warndlg('Center frequency out of band. Please, select a different frequency', 'Warning Message')
    return
end


if E1 == fvect(1)
    warndlg('Center frequency cannot be the upper band limit. Please, select a different frequency', 'Warning Message')
    return
end
set(handles.slider3, 'Value', E1)

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fWide= get(handles.slider7, 'Value');
currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, E1, fWide, windLen, currWind, chanToAmpl, AmplVal, timeRes)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu2_Callback(hObject, eventdata, handles)
CMList= get(hObject, 'String');
CMIdx= get(hObject, 'Value');
CM= CMList{CMIdx};
fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;

currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide, windLen, currWind, chanToAmpl, AmplVal, timeRes)

function pushbutton5_Callback(hObject, eventdata, handles)
dataNew= evalin('base','dataNew');
SR= evalin('base', 'EEG.srate');
[nCh, nPnt]= size(dataNew);
windAll= ceil(nPnt/SR);

set(handles.edit3, 'Enable', 'on','String', windAll);
set(handles.slider4, 'Min', 1, 'Max', 1, 'SliderStep', [1 1], 'Value',1, 'Enable', 'off')

currWind= get(hObject, 'Value');
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');

SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide, nPnt, currWind, chanToAmpl, AmplVal, timeRes)


function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)
dataNew= evalin('base','dataNew');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(hObject, 'String'));
windLen= floor(ED3*SR);
[nCh, nPnt]= size(dataNew);
nWind= ceil(nPnt/windLen);
currWind= 1;
if nWind==1
    set(handles.slider4, 'Min', 1, 'Max', nWind, 'SliderStep', [1 1], 'Value', currWind, 'Enable', 'off')
else
    set(handles.slider4, 'Min', 1, 'Max', nWind, 'SliderStep', [1/(nWind-1) 1/(nWind-1)], 'Value', currWind, 'Enable', 'on')
end
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');

SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide, windLen, currWind,chanToAmpl, AmplVal, timeRes)


function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider4_Callback(hObject, eventdata, handles)
currWind= get(hObject, 'Value');
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');

SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide,  windLen, currWind, chanToAmpl, AmplVal, timeRes)


function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox1_Callback(hObject, eventdata, handles)

function pushbutton4_Callback(hObject, eventdata, handles)

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
currWind= get(handles.slider4, 'Value');

set(handles.listbox1, 'Value', []);
set(handles.slider6, 'Value',1)
set(handles.edit8, 'String',1)

SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide,  windLen, currWind, [], 1, timeRes)

function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider6_Callback(hObject, eventdata, handles)
AmplVal= get(hObject, 'Value');
set(handles.edit8, 'String', AmplVal);
currWind= get(handles.slider4, 'Value');
h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
ED3SR= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide,  ED3SR, currWind, chanToAmpl, AmplVal, timeRes)


function pushbutton1_Callback(hObject, eventdata, handles)
myhandles= guidata(gcbo);
Line1= findobj(myhandles.panel1, 'Type', 'line', 'Color', 'green');
Line2= findobj(myhandles.axes5, 'Type', 'line', 'Color', 'green');
Line3= findobj(myhandles.axes5, 'Type', 'line', 'Color', 'yellow');

if isempty(Line1)== 0
    delete(Line1)
    delete(Line2)
    delete(Line3)
end
AX1N= findobj(myhandles.panel1, 'Type', 'axes');
AX1= AX1N(1,1);
h4= myhandles.axes4;
AX2= myhandles.axes5;

dataNew= evalin('base', 'dataNew');
CHANLOCS= evalin('base', 'EEG.chanlocs');
nCh= size(dataNew,1);

gui1 = findobj('Name','SeizureFrequencyContent');
g1data = guidata(gui1);
if isempty(gui1)
    warndlg('You closed Time-Frequency GUI', 'Time-Frequancy Display');
    return
end
chVal=get(g1data.listbox1, 'Value');
chLabels= {CHANLOCS(chVal).labels};


plot(h4, dataNew(ceil(nCh/2),:), '-y')

set(h4, 'Color', 'black', 'XLim', [1 size(dataNew,2)], 'XTick', [], 'XTickLabels', [], 'YLim', [min(min(dataNew)) max(max(dataNew))])
set(myhandles.text8, 'String', chLabels{ceil(nCh/2)}, 'ForegroundColor', 'yellow')

set(AX1,'buttondownfcn',@clicklineCallback1,'xlimmode','manual');

set(AX2,'buttondownfcn',@clicklineCallback,'ylimmode','manual');
set(AX2,'buttondownfcn',@clicklineCallback,'xlimmode','manual');

line([AX2.XLim(1) AX2.XLim(2)], [AX2.YLim(1)+ (AX2.YLim(2)-AX2.YLim(1))/2 AX2.YLim(1)+(AX2.YLim(2)-AX2.YLim(1))/2],...
    'parent',AX2,'tag','line1', 'hittest','off', 'Color', 'yellow', 'LineStyle', '-', 'LineWidth', 1.5);

line([AX2.XLim(1)+ (AX2.XLim(2)-AX2.XLim(1))/2 AX2.XLim(1)+(AX2.XLim(2)-AX2.XLim(1))/2], [AX2.YLim(1) AX2.YLim(2)],...
    'parent',AX2,'tag','line2', 'hittest','off', 'Color', 'green', 'LineStyle', '-', 'LineWidth', 1.5);

line([AX1.XLim(1)+ (AX1.XLim(2)-AX1.XLim(1))/2 AX1.XLim(1)+(AX1.XLim(2)-AX1.XLim(1))/2], [AX1.YLim(1) AX1.YLim(2)],...
    'parent',AX1,'tag','line3', 'hittest','off', 'Color', 'green', 'LineStyle', '-', 'LineWidth', 1.5);

function clicklineCallback1(~,~)
set(gcf,'windowbuttonmotionfcn',@dragline1)
set(gcf,'windowbuttonupfcn',@dragdone)

function clicklineCallback(~,~)
clicked=get(gca,'currentpoint');
myhandles= guidata(gcbo);

Lin1= findobj(gcf,'tag','line1');
Lin2= findobj(gcf,'tag','line2');

d1= abs(clicked(1,2,1)-Lin1.YData(1));
d2= abs(clicked(1,1,1)-Lin2.XData(1));

if d1 <= d2
    set(gcf,'windowbuttonmotionfcn',@dragline)
    set(gcf,'windowbuttonupfcn',@dragdone)
else
    set(gcf,'windowbuttonmotionfcn',@draglineTIME)
    set(gcf,'windowbuttonupfcn',@dragdoneTIME)
end

function dragline(~,~)
myhandles= guidata(gcbo);
dataNew= evalin('base', 'dataNew');
CHANLOCS= evalin('base', 'EEG.chanlocs');
AX2= myhandles.axes5;
clicked=get(gca,'currentpoint');
ycoord=clicked(1,2,1);
Lin=findobj(gcf,'tag','line1');
set(Lin ,'ydata',[ycoord ycoord]);
YTick= get(AX2, 'YTick');

[closCh, idx]= min(abs(YTick-ycoord));

gui1 = findobj('Name','SeizureFrequencyContent');
g1data = guidata(gui1);
if isempty(gui1)
    warndlg('You closed Time-Frequency GUI', 'Time-Frequancy Display');
    return
end
chVal=get(g1data.listbox1, 'Value');
chLabels= {CHANLOCS(chVal).labels};

plot(myhandles.axes4, dataNew(idx,:), '-y')
set(myhandles.axes4, 'Color', 'black', 'XLim', [1 size(dataNew,2)], 'XTick', [], 'XTickLabels', [], 'YLim', [min(min(dataNew)) max(max(dataNew))])
set(myhandles.text8, 'String', chLabels{idx}, 'ForegroundColor', 'yellow')

function dragline1(~,~)
myhandles= guidata(gcbo);
timeMx= evalin('base', 'timeMx');
SR= evalin('base', 'EEG.srate');
dataNew= evalin('base', 'dataNew');
[~, nTot]= size(dataNew);

w= get(myhandles.slider4, 'Value');
windLen= str2num(get(myhandles.edit3, 'String'));

clicked=get(gca,'currentpoint');

xcoord=clicked(1,1,1);
Lin= findobj(gcf,'tag','line3');
set(Lin ,'xdata',[xcoord xcoord]);

timeVect= timeMx(1) + (w-1)*windLen : 1/SR: timeMx(1)+  w* windLen;
timeVectSR= 1:1:windLen*SR;

[~, xind]= min(abs(timeVectSR-xcoord));

set(myhandles.edit6, 'String', num2str(round(timeVect(xind),2)))


function dragdone(~,~)
set(gcf,'windowbuttonmotionfcn','');
set(gcf,'windowbuttonupfcn','');

function draglineTIME(~,~)
myhandles= guidata(gcbo);
timeMx= evalin('base', 'timeMx');
SR= evalin('base', 'EEG.srate');
dataNew= evalin('base', 'dataNew');
[~, nTot]= size(dataNew);

w= get(myhandles.slider4, 'Value');
windLenT= str2num(get(myhandles.edit3, 'String'));
windLen= windLenT*SR;

timelim1= timeMx(1)+ (w-1)*windLenT;
timelim2= timeMx(1)+  w* windLenT;

clicked= get(gca,'currentpoint');

xcoord=clicked(1,1,1);
Lin= findobj(gcf,'tag','line2');
set(Lin ,'xdata',[xcoord xcoord]);

timeRes= get(myhandles.slider11, 'Value');
if timeRes == 50
    Res= SR;
else
    Res= timeRes;
end
    
nCS= fix(SR/Res);
nTot= floor(size(dataNew,2)/nCS);
newStep= floor(windLen/nCS);

xsNew= (w-1)*newStep +1 : w*newStep;


timeVect= timelim1: windLenT/newStep :timelim2;
timeVectSR= 1:1:newStep;


[~, xind]= min(abs(timeVectSR-xcoord));
xcoord= timeVect(xind);

set(myhandles.edit5, 'String',num2str(round(xcoord,2)))


function dragdoneTIME(~,~)
set(gcf,'windowbuttonmotionfcn','');
set(gcf,'windowbuttonupfcn','');

function pushbutton2_Callback(hObject, eventdata, handles)
myhandles= guidata(gcbo);
LINE1= findobj(myhandles.axes5, 'Type', 'line', 'Color', 'yellow');
LINE2= findobj(myhandles.axes5, 'Type', 'line', 'Color', 'green');
LINE3= findobj(myhandles.panel1,'Type', 'line', 'Color', 'green');

if ishandle(LINE1)
    delete(LINE1)
    delete(LINE2)
    delete(LINE3)
    cla(myhandles.axes4)
    set(myhandles.edit5, 'String', [])
    set(myhandles.edit6, 'String', [])
    set(myhandles.text8, 'String', [])
end


function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider7_Callback(hObject, eventdata, handles)
fWide= get(hObject, 'Value');
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
fCentr= get(handles.slider3, 'Value');
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;

currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide, windLen,currWind, chanToAmpl, AmplVal, timeRes)
set(handles.edit4, 'String', fWide);


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_Callback(hObject, eventdata, handles)
E4= str2num(get(hObject, 'String'));

if E4 <=0
    warndlg('Frequency Window cannot be negative or zero. Please, select a different range', 'Warning Message')
    return
end
set(handles.slider7, 'Value', E4)

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;

CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

fCentr= get(handles.slider3, 'Value');

currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, E4, windLen, currWind, chanToAmpl, AmplVal, timeRes)

function slider9_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider9_Callback(hObject, eventdata, handles)
sensFact2= get(hObject, 'Value');
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
timeRes= get(handles.slider11, 'Value');

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide,windLen,currWind, chanToAmpl, AmplVal, timeRes)


function edit5_Callback(hObject, eventdata, handles)
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit6_Callback(hObject, eventdata, handles)



function slider11_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider11_Callback(hObject, eventdata, handles)
timeRes= get(hObject, 'Value');
CMList= get(handles.popupmenu2, 'String');
CMIdx= get(handles.popupmenu2, 'Value');
CM= CMList{CMIdx};
fCentr= get(handles.slider3, 'Value');
fWide= get(handles.slider7, 'Value');
sensFact2= get(handles.slider9, 'Value');
timeRes= get(handles.slider11, 'Value');

h1= handles.panel1;
h4= handles.axes4;
h5= handles.axes5;
currWind= get(handles.slider4, 'Value');
SR= evalin('base', 'EEG.srate');
ED3= str2num(get(handles.edit3, 'String'));
windLen= ceil(ED3*SR);
chanToAmpl= get(handles.listbox1, 'Value');
AmplVal= get(handles.slider6, 'Value');


SeizureFreqContentUpdate(h1, h5, h4, CM, sensFact2, fCentr, fWide,windLen,currWind, chanToAmpl, AmplVal, timeRes)


function edit8_Callback(hObject, eventdata, handles)
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton3_Callback(hObject, eventdata, handles)
close(gcf)

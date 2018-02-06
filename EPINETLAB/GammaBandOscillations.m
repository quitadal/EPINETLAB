function varargout = GammaBandOscillations(varargin)
% GAMMABANDOSCILLATIONS MATLAB code for GammaBandOscillations.fig
%      GAMMABANDOSCILLATIONS, by itself, creates a new GAMMABANDOSCILLATIONS or raises the existing
%      singleton*.
%
%      H = GAMMABANDOSCILLATIONS returns the handle to a new GAMMABANDOSCILLATIONS or the handle to
%      the existing singleton*.
%
%      GAMMABANDOSCILLATIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAMMABANDOSCILLATIONS.M with the given input arguments.
%
%      GAMMABANDOSCILLATIONS('Property','Value',...) creates a new GAMMABANDOSCILLATIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GammaBandOscillations_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GammaBandOscillations_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GammaBandOscillations

% Last Modified by GUIDE v2.5 25-May-2017 16:31:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GammaBandOscillations_OpeningFcn, ...
    'gui_OutputFcn',  @GammaBandOscillations_OutputFcn, ...
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


% --- Executes just before GammaBandOscillations is made visible.
function GammaBandOscillations_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

W = evalin('base','whos');
if isempty(W)
    inBase= 0;
    set(handles.listbox1, 'String', []);
    ED1=0;
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
end

if inBase==0
    chLocs= [];
    %assignin('base', 'ALLEEG', [])
    set(handles.listbox1, 'String', []);
    ED1=0;
else
    xmin= evalin('base', 'EEG.xmin');
    xmax= evalin('base', 'EEG.xmax');
    ED1= [xmin*1000 xmax*1000]; %ms
    
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
    
    %assignin('base', 'ALLEEG', [])
    
    if nCh <= 2
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', 3,'Value', []);
    else
        set(handles.listbox1, 'String', chList, 'Min', 1, 'Max', nCh,'Value', []);
    end
end

set(handles.edit1, 'String', num2str(floor(ED1)));
set(handles.edit2, 'String', '0 50');
set(handles.edit3, 'String', '0');
set(handles.edit4, 'String', '3 0.5');
set(handles.edit7, 'String', '0.05');
PU1= {'Use 50 time points', 'Use 100 time points', 'Use 150 time points', 'Use 200 time points', 'Use 300 time points', 'Use 400 time points' };
set(handles.popupmenu1, 'String', PU1, 'Value', 4);

PU2= {'Use limits, padding 1', 'Use limits, padding 2', 'Use limits, padding 4', 'Use actual freqs.'};
set(handles.popupmenu2, 'String', PU2, 'Value', 1);

PU3= {'Use divisive baseline (DIV)', 'Use standard deviation', 'Use single trial DIV baseline', 'Use single trial STV baseline'};
set(handles.popupmenu3, 'String', PU3, 'Value', 1);


% --- Outputs from this function are returned to the command line.
function varargout = GammaBandOscillations_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox1_Callback(hObject, eventdata, handles)


function pushbutton1_Callback(hObject, eventdata, handles)
chLabels= get(handles.listbox1, 'String');
nCh= size(chLabels,1);
set(handles.listbox1, 'Value', 1:nCh)

function edit1_Callback(hObject, eventdata, handles)
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit8_Callback(hObject, eventdata, handles)
function edit8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton2_Callback(hObject, eventdata, handles)
chLabels= get(handles.listbox1, 'String');
chIdx= get(handles.listbox1, 'Value');
nCh= length(chIdx);

if nCh == 0
    warndlg('Plase, select the channel(s) to be analyzed')
    return
end

EEG= evalin('base', 'EEG');

epochlim= str2num(get(handles.edit1, 'String'));
if isempty(epochlim)
    warndlg('Please, select correct epoch limits')
    return
end
if epochlim(2)-epochlim(1) < 30
    disp('newtimef(): WARNING: Specified time range is very small (< 30 ms)???\n');
    disp('                     Epoch time limits should be in msec, not seconds!\n');
end

frames= EEG.pnts;
srate= EEG.srate;
cycles= str2num(get(handles.edit4, 'String'));
if isempty(cycles)
    warndlg('Please, select correct cycles value')
    return
end

freqs= str2num(get(handles.edit2, 'String'));
if isempty(freqs)
    warndlg('Please, select correct frequency band')
    return
end
if freqs(2)> srate/2
    disp(['Warning: value of maxfreq reduced to Nyquist rate' ...
        ' (%3.2f)\n\n'], srate/2);
    freqs(2) = srate/2;
end
alpha= str2num(get(handles.edit7, 'String'));

if isempty(alpha)
    alpha= NaN;
end


PU1= get(handles.popupmenu1, 'Value');
if PU1 == 1
    nPnt=50;
elseif PU1 == 2
    nPnt=100;
elseif PU1 == 3
    nPnt=150;
elseif PU1 == 4
    nPnt=200;
elseif PU1 == 5
    nPnt=300;
elseif PU1 == 6
    nPnt=400;
end

nfreqs= [];
PU2= get(handles.popupmenu2, 'Value');
if PU2 == 1
    padratio = 1;
elseif PU2 == 2
    padratio = 2;
elseif PU2 == 3
    padratio = 4;
elseif PU2 == 4
    nfreqs= length(freqs);
end

PU3= get(handles.popupmenu3, 'Value');
if PU3 == 1 || PU3 == 3
    basenorm= 'off';
elseif PU3 == 2 || PU3 == 4
    basenorm= 'on';
end

trialbase= 'off';

if PU3 >= 3
    trialbase= 'full';
end

baseline= str2num(get(handles.edit3, 'String'));
if isempty(baseline)
    warndlg('Please, select correct baseline')
    return
end

if get(handles.checkbox9, 'Value') == 1
    baseline= NaN;
end

CB6= get(handles.checkbox6, 'Value');
if CB6 == 1
    plotersp= 'on';
else
    plotersp= 'off';
end

CB7= get(handles.checkbox7, 'Value');
if CB7 == 1
    plotitc= 'on';
else
    plotitc= 'off';
end

CB2= get(handles.checkbox2, 'Value');
if CB2 == 1
    mcorrect= 'fdr';
else
    mcorrect= 'none';
end


CB3= get(handles.checkbox3, 'Value');
if CB3 == 1
    plotphase= 'on';
else
    plotphase= 'off';
end

CB4= get(handles.checkbox4, 'Value');
if CB4 == 1
    scale= 'log';
else
    scale= 'abs';
end

ED5= str2num(get(handles.edit5, 'String'));
if ~isempty(ED5)
    erspmax= ED5;
else
    erspmax= [];
end
ED6= str2num(get(handles.edit6, 'String'));
if ~isempty(ED6)
    itcmax= ED5;
else
    itcmax= [];
end

ERP= [];
ITC= [];
baseval=0;
maskersp= [];
maskitc= [];
for i=1:nCh
    data= EEG.data(chIdx(i),:,:);
    [ersp,itc,powbase,times,freqs,erspboot,itcboot, ~, ~, maskersp, maskitc] =  newtimefGamma(data, frames, epochlim, srate, cycles,'freqs',freqs,...
        'baseline', baseline, 'ntimesout', nPnt, 'padratio', padratio, 'basenorm', basenorm, 'trialbase', trialbase, 'nfreqs', nfreqs,...
        'scale', scale, 'plotphase', plotphase, 'alpha', alpha, 'mcorrect', mcorrect, 'plotersp','off', 'plotitc','off') ;
    PP= ersp;
    Pboot= erspboot;
    
    if ~isnan(alpha)
        if  ~isempty(maskersp) % zero out nonsignif. power differences
            PP(~maskersp) = baseval;
            %PP = PP .* maskersp;
        elseif isempty(maskersp)
            if size(PP,1) == size(Pboot,1) && size(PP,2) == size(Pboot,2)
                PP(find(PP > Pboot(:,:,1) & (PP < Pboot(:,:,2)))) = baseval;
                Pboot = squeeze(mean(Pboot,2));
                if size(Pboot,2) == 1, Pboot = Pboot'; end;
            else
                PP(find((PP > repmat(Pboot(:,1),[1 length(times)])) ...
                    & (PP < repmat(Pboot(:,2),[1 length(times)])))) = baseval;
            end
        end
    end
    
    if nCh == 1
        ERSP= PP;
        ERSP= flipud(ERSP);
    else
        ERSP(i,:)= sum(PP,1);
    end
    
    RR= itc;
    if ~isreal(RR)
        Rangle = angle(RR);
        Rsign = sign(imag(RR));
        RR = abs(RR); % convert coherence vector to magnitude
        setylim = 1;
    else
        Rangle = zeros(size(RR)); % Ramon: if isreal(R) then we get an error because Rangle does not exist
        Rsign = ones(size(RR));
        setylim = 0;
    end
    Rboot= itcboot;
    
    if ~isnan(alpha)
        if ~isempty(maskitc)
            RR = RR .* maskitc;
        elseif isempty(maskitc)
            if size(RR,1) == size(Rboot,1) && size(RR,2) == size(Rboot,2)
                if size(Rboot,3) == 2
                    RR(find(RR > Rboot(:,:,1) & RR < Rboot(:,:,2))) = 0;
                else
                    RR(find(RR < Rboot)) = 0;
                end
                Rboot = mean(Rboot(:,:,end),2);
            else
                RR(find(RR < repmat(Rboot(:),[1 length(times)]))) = 0;
            end;
        end;
    end
    
    if nCh~=1
        ITC(i,:)= sum(RR,1);
    else
        ITC= RR;
        ITC= flipud(RR);
    end
end

if isempty(erspmax)
    l1 = [-1 1]*max(max(abs(ERSP(:,:))));
else
    l1= [-1 1]* erspmax;
end
if max(l1)== 0
    l1= [-1 1];
end
if isempty(itcmax)
    l2=  min(max(max(ITC(:,:))),1)*[-1 1];
else
    l2= [-1 1]*itcmax;
end
if max(l2)== 0
    l2= [-1 1];
end

if strcmp(plotitc, 'off') && strcmp(plotersp,'on')
    h= figure;
    set(h, 'Color', 'white')
    if nCh~=1
        set(h, 'WindowButtonDownFcn',@ImageClickCallback)
    end
    if nCh ~=1
        imagesc(times, 1:nCh, ERSP(:,:), l1);
        set(gca, 'YTick', 1:nCh,  'YTickLabels', chLabels(chIdx), 'FontWeight', 'bold')
        title(gca, ['Event-related (log) spectral perturbation (ERSP) in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
    else
        imagesc(times, flipud(freqs),  ERSP(:,:), l1);
        ylabel(gca, 'Hz');
        yticks(freqs)
        yticklabels(flip(round(freqs)))
        title(gca, ['ERSP for channel ' chLabels{chIdx} ' in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
    end
    
    xlabel(gca, 'Time [ms]')
    colormap( jet(256))
    cbar
    
elseif strcmp(plotitc, 'on') && strcmp(plotersp,'on')
    h= figure;
    set(h, 'Color', 'white')
    if nCh ~=1
        set(h, 'WindowButtonDownFcn',@ImageClickCallback)
    end
    if nCh~=1
        subplot(2,1,1)
        imagesc(times, 1:nCh, ERSP(:,:), l1);
        set(gca, 'YTick', 1:nCh, 'YTickLabels', chLabels(chIdx), 'FontWeight', 'bold')
        title(gca, ['Event-related (log) spectral perturbation (ERSP) in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
        
        xlabel(gca, 'Time [ms]')
        colormap( jet(256))
        cbar
        
        subplot(2,1,2)
        imagesc(times, 1:nCh, ITC(:,:), l2);
        set(gca, 'YTick', 1:nCh, 'YTickLabels', chLabels(chIdx), 'FontWeight', 'bold')
        title(['Inter-trial Coherence (ITC) in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
        xlabel(gca, 'Time [ms]')
        colormap(jet(256))
        cbar
        set(gca, 'YLim', [0, max(l2)])
    
    else
        subplot(2,1,1)
        imagesc(times, freqs, ERSP(:,:), l1);
        ylabel(gca,  'Hz')
        yticks(freqs)
        yticklabels(flip(round(freqs)))
        title(gca, ['ERSP for channel ' chLabels{chIdx} ' in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
        
        xlabel(gca, 'Time [ms]')
        colormap(jet(256))
        cbar
        
        subplot(2,1,2)
        imagesc(times, freqs, ITC(:,:), l2);
        ylabel(gca,  'Hz')
        yticks(freqs)
        yticklabels(flip(round(freqs)))
        title(gca, ['ITC for channel ' chLabels{chIdx} ' in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
        xlabel(gca, 'Time [ms]')
        colormap(jet(256))
        cbar
        set(gca, 'YLim', [0, max(l2)])
    end
    
elseif strcmp(plotitc, 'on') && strcmp(plotersp,'off')
    h= figure;
    set(h, 'Color', 'white')
    if nCh~=1
        set(h, 'WindowButtonDownFcn',@ImageClickCallback)
    end
    if nCh~=1
        imagesc(times, 1:nCh, ITC(:,:), l2);
        set(gca, 'YTick', 1:nCh, 'YTickLabels', chLabels(chIdx), 'FontWeight', 'bold')
        title(gca, ['Inter-trial Coherence (ITC)in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
    else
        imagesc(times, freqs, ITC(:,:), l2);
        ylabel(gca,  'Hz')
        yticks(freqs)
        yticklabels(flip(round(freqs)))
        title(gca, ['ITC for channel ' chLabels{chIdx} ' in the band ' num2str(freqs(1)) '-'  num2str(freqs(end)) ' Hz'])
    end
        xlabel(gca, 'Time [ms]')
        colormap(jet(256))
        cbar
        set(gca, 'YLim', [0, max(l2)])
else
    warndlg('You selected no plot', 'Plot');
    return
end

assignin('base', 'ERSP', ERSP)
assignin('base', 'ITC', ITC)


function ImageClickCallback(hObject, ~)
Text= findobj(gca, 'Type', 'text');
delete(Text);
YLabels= get(gca, 'YTickLabel');
nLabels= length(YLabels);

xaxisLim= get(gca, 'XLim');
coord = get(gca,'CurrentPoint');
idx= ceil(coord(1,2)-0.5);

if idx<=0 || idx>nLabels || coord(1,1)< xaxisLim(1)  || coord(1,1)> xaxisLim(2)
    return
else
    text(coord(1,1), coord(1,2), YLabels(idx), 'FontWeight', 'bold');
end



function checkbox2_Callback(hObject, eventdata, handles)
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

function popupmenu3_Callback(hObject, eventdata, handles)
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox3_Callback(hObject, eventdata, handles)
function checkbox4_Callback(hObject, eventdata, handles)
function checkbox5_Callback(hObject, eventdata, handles)
function checkbox6_Callback(hObject, eventdata, handles)
function checkbox7_Callback(hObject, eventdata, handles)
function checkbox9_Callback(hObject, eventdata, handles)


function pushbutton3_Callback(hObject, eventdata, handles)
close(gcf)


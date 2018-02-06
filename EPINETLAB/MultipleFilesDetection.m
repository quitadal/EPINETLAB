function varargout = MultipleFilesDetection(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MultipleFilesDetection_OpeningFcn, ...
    'gui_OutputFcn',  @MultipleFilesDetection_OutputFcn, ...
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

% --- Executes just before MultipleFilesDetection is made visible.
function MultipleFilesDetection_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.listbox1, 'String', [], 'Enable', 'on',  'Min', 1, 'Max', 1, 'Value', [])
set(handles.radiobutton1, 'Value', 1)
set(handles.edit17, 'Enable', 'on')
set(handles.radiobutton2, 'Value', 1)
set(handles.popupmenu1, 'Value',1, 'Enable', 'off')

set(handles.edit9,  'Enable', 'off')
set(handles.edit10, 'Enable', 'off')
set(handles.edit11, 'Enable', 'off')
set(handles.edit12, 'Enable', 'off')
set(handles.edit13, 'Enable', 'off')

set(handles.edit14, 'Enable', 'off')
set(handles.edit15, 'Enable', 'off')
set(handles.edit16, 'Enable', 'off')
set(handles.edit17, 'Enable', 'off')

function varargout = MultipleFilesDetection_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
fileAlreadyloaded= get(handles.listbox1, 'String');

[fileToAnalyse, filepath]= uigetfile('*.set', 'Select files for the automatic analysis',  'MultiSelect', 'on' );

if length(fileToAnalyse)==1
    if fileToAnalyse == 0
        return
    end
end
if iscell(fileToAnalyse)
    nFiles= length(fileToAnalyse);
else
    nFiles= 1;
end

for i=1:nFiles
    if nFiles == 1
        LB1Str{i,:}= [filepath fileToAnalyse];
    else
        LB1Str{i,:}= [filepath fileToAnalyse{i}];
    end
end
set(handles.listbox1, 'String', [fileAlreadyloaded ; LB1Str], 'Value', [], 'Min', 1, 'Max', 100, 'FontSize', 12)

function listbox1_Callback(hObject, eventdata, handles)

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Pushbutton to clear ALL files
function pushbutton6_Callback(hObject, eventdata, handles)
LBVal= get(handles.listbox1, 'Value');
LBStr= get(handles.listbox1, 'String');

if isempty(LBStr) || isempty(LBVal)
    return
end

LBStNew= LBStr;
LBStNew(LBVal)= [];

set(handles.listbox1, 'String', LBStNew);
set(handles.listbox1, 'Value', []);

%Pushbutton to clear ALL files
function pushbutton5_Callback(hObject, eventdata, handles)
set(handles.listbox1, 'String', [])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETER SETTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


function radiobutton3_Callback(hObject, eventdata, handles)
RB3= get(hObject, 'Value');

if RB3 == 1
    set(handles.edit9,  'Enable', 'on')
    set(handles.edit10, 'Enable', 'on')
    set(handles.edit11, 'Enable', 'on')
    set(handles.edit12, 'Enable', 'on')
    set(handles.edit13, 'Enable', 'on')
else
    set(handles.edit9,  'Enable', 'off')
    set(handles.edit10, 'Enable', 'off')
    set(handles.edit11, 'Enable', 'off')
    set(handles.edit12, 'Enable', 'off')
    set(handles.edit13, 'Enable', 'off')
end


function radiobutton4_Callback(hObject, eventdata, handles)
RB4= get(hObject, 'Value');

if RB4 == 1
    set(handles.edit14, 'Enable', 'on')
    set(handles.edit15, 'Enable', 'on')
    set(handles.edit16, 'Enable', 'on')
    set(handles.edit17, 'Enable', 'on')
    set(handles.popupmenu1, 'Value',1, 'Enable', 'on')
else
    set(handles.edit14, 'Enable', 'off')
    set(handles.edit15, 'Enable', 'off')
    set(handles.edit16, 'Enable', 'off')
    set(handles.edit17, 'Enable', 'off')
    set(handles.popupmenu1, 'Value',1, 'Enable', 'off')
end


function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
wavList = {'cmor1-1.5','cmor1-1', 'cmor1-0.5','cmor1-0.1', 'cmor2-1.5', 'cmor2-1', 'cmor2-0.5', 'cmor2-0.1','cmor3-1.5'};
set(hObject, 'String', wavList)

function popupmenu1_Callback(hObject, eventdata, handles)


function radiobutton1_Callback(hObject, eventdata, handles)
RB1= get(hObject, 'Value');
if RB1 ==1
    set(handles.edit17, 'Enable', 'on')
else
    set(handles.edit17, 'Enable', 'off')
end

function edit17_Callback(hObject, eventdata, handles)

function edit17_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radiobutton2_Callback(hObject, eventdata, handles)

function edit14_Callback(hObject, eventdata, handles)
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit15_Callback(hObject, eventdata, handles)
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit12_Callback(hObject, eventdata, handles)
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(hObject, eventdata, handles)
fileToAnalyse= get(handles.listbox1, 'String');
RB3= get(handles.radiobutton3, 'Value');
RB4= get(handles.radiobutton4, 'Value');
if isempty(fileToAnalyse)
    return
elseif RB3 == 0 &&  RB4==0
    return
end

nFiles= size(fileToAnalyse,1);

for ff = 1:nFiles
    
    clear  EEG  nWind  timeMx  scalMx  fvect  kurtMx HFOMX HFOCOEFFnoArt
   
    %--------------------------------------
    % Time-Frequency Parameters
    %--------------------------------------
    if nFiles > 1
        [filepath, filename, ext]= fileparts(fileToAnalyse{ff,1});
    else
        [filepath, filename, ext]= fileparts(fileToAnalyse{1,1});
    end

    mkdir(filepath, 'Kurtosis')
    mkdir(filepath, 'ChansAfterKurtosis')
    if RB3 == 1
        mkdir(filepath, 'StabaHFO')
    end
    
    if RB4 == 1
        mkdir(filepath, 'WaveletHFO')
    end
    
    fileSet= [filepath filesep filename ext];
    fullFileNameDistr= [filepath filesep 'Kurtosis' filesep filename '_Kurtosis.txt'];
    fullNameHFO=[filepath filesep 'StabaHFO' filesep filename '_StabaHFO.txt'];
    fullNameHFOCust=[filepath filesep 'WaveletHFO' filesep filename '_WaveletHFO.txt'];
    fullFileNameChans= [filepath filesep 'ChansAfterKurtosis' filesep filename '_ChansAfterKurtosis.txt'];

    if ~exist('pop_loadset.m')
        eeglab
    end
    
    EEG= pop_loadset(fileSet);
    srate= ceil(EEG.srate);
    nCh= EEG.nbchan;
    chIdx= 1:nCh;
    chSel1= {EEG.chanlocs.labels};
    chSel= deblank(chSel1);
    inspInterv= [1  EEG.pnts]; % all the interval
    windLen= fix(str2double(get(handles.edit1, 'String'))* srate);         % 1 sec/ 0.5 sec
    if isnan(windLen)
        warndlg('Please insert a correct window length', 'Select window length')
        return
    end
    
    windOver= fix(str2double(get(handles.edit2, 'String'))* srate);               % 0 sec
    if isnan(windOver)
        warndlg('Please insert a correct window overlap', 'Select window overlap')
        return
    end
    
    freqBandStr= get(handles.edit3, 'String');
    space= strfind(freqBandStr, ' ');
    f1= str2double(freqBandStr(1:space-1));
    f2= str2double(freqBandStr(space+1:end));
    freqBand= [f1 f2];
    
    if f1 >= f2
        warndlg('f1 must be lower than f2', 'Select frequency band')
        return
    end
    
    if f1==0 || f2 ==0
        warndlg('f1 or F2 cannot be zero', 'Select frequency band')
        return
    end
    
    wavList = {'cmor1-1.5','cmor1-1', 'cmor1-0.5','cmor1-0.1', 'cmor2-1.5', 'cmor2-1', 'cmor2-0.5', 'cmor2-0.1','cmor3-1.5'};
    selWav= wavList(get(handles.popupmenu1, 'Value'));       % Complex Morlet
    
    
    [~, nWind, timeMx, scalMx, fvect, ~, kurtMx] = myWavComput(EEG.data, srate, chIdx, chSel,...
        inspInterv, windLen, windOver, freqBand, selWav{:});
    
    %--------------------------------------
    % Kurtosis-based Analysis Parameters
    %--------------------------------------
    meanK= zeros(nCh, nWind);
    stdK= zeros(nCh, nWind);
    kMax= zeros(nCh, nWind);
    idxMax= zeros(nCh, nWind);
    
    maxK= zeros(nCh,1);
    trimPerc=0;
    
    for i= 1:nCh
        for w= 1:nWind
            kurt= kurtMx{i,w};
            
            if trimPerc ~= 0
                kurtSort= sort(kurt);
                nk= round(length(kurtSort)*(trimPerc/100)); %Trimmred kurtosis
                kurtInt= kurt;
                kurtInt(1:nk)=[];
                kurtInt(end-nk:end)=[];
            else
                kurtInt= kurt;
            end
            
            meanK(i,w)= mean(kurtInt); % mean value over all the frequencies
        end
    end
    
    meanKVect= reshape(meanK,1,[]);
    
    F= fitmethis(double(meanKVect), 'figure', 'off', 'output', 'off');
    
    if strcmp(F(1).name, 'gev')
        k= F(1).par(1);
        sigma= F(1).par(2);
        mu= F(1).par(3);
        
        [m,v]= gevstat(k, sigma, mu);
        
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
        
    elseif strcmp(F(1).name, 'inversegaussian')
        mu= F(1).par(1);
        lambda= F(1).par(2);
        m= mu;
        v= (mu^3)/lambda;
        
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
        
        
        
    elseif strcmp(F(1).name, 'birnbaumsaunders')
        beta= F(1).par(1);
        gamma= F(1).par(2);
        m= beta*(1+(gamma^2)/2);
        v= (gamma*beta)^2 * (1+(5*gamma^2)/4);
        
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
        
    elseif strcmp(F(1).name, 'weibull')
        a= F(1).par(1);
        b= F(1).par(2);
        [m, v]= wblstat(a,b);
        
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
        
    elseif strcmp(F(1).name, 'loglogistic')
        pd = makedist('Loglogistic','mu',F(1).par(1),'sigma',F(1).par(2));
        m= mean(pd);
        v= var(pd);
        
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
    elseif strcmp(F(1).name, 'lognormal')
        mu= F(1).par(1);
        sigma= F(1).par(2);
        [m,v] = lognstat(mu,sigma);
        if isinf(v)
            kurtThresh= 2*m;
        else
            kurtThresh= round(m + 3*sqrt(v));
        end
        
    else
        kurtThresh= 15;
        m= 0;
        v= 0;
        warning('Kurtosis threshold fixed to 15')
    end
    
    fidkDistr= fopen(fullFileNameDistr, 'wt');
    fprintf(fidkDistr, '%s\t%20s\t%s\t%s\t%s\r\n', 'Distribution', 'Parameters          ', 'Mean', 'Variance', 'K threshold' );
    fprintf(fidkDistr, '%s\t%s\t%f\t%f\t%d\r\n', F(1).name, num2str(F(1).par), m, v, kurtThresh );
    
    freqInt= 20;              % 20 frequancies should have a kurtosis > of the threshold
    nChKurt= fix(nCh/3);      % take 1/3 of the channels satisfying the requirement
    
    CRITWIND= zeros(nCh,1);
    
    for i=1:nCh
        critWind= 0;
        critWindIdx= [];
        
        for w=1 :nWind
            kFreq=  kurtMx{i,w};
            intInt= (kFreq >= kurtThresh);
            
            if any(intInt)~=0
                fMx{i,w}= fvect(intInt);
            else
                fMx{i,w}= 0;
            end
            
            vectLen= 0;
            vectLen2= [];
            
            for k= 1:length(intInt)
                a= intInt(k);
                if a==0
                    if vectLen==0
                        continue
                    else
                        vectLen2= [vectLen2  vectLen];
                        vectLen= 0;
                    end
                elseif a~=0 && k~= length(intInt)
                    vectLen= vectLen+1;
                elseif a~=0 && k== length(intInt)
                    vectLen= vectLen+1;
                    vectLen2 = [vectLen2 vectLen];
                end
            end
            
            if any(vectLen2 >= freqInt)
                critWind = critWind+1;
                critWindIdx= [critWindIdx w];
            end
            
        end
        CRITWIND(i)= critWind;
    end
    
    [critWindOrd, idxORD]= sort(CRITWIND, 'descend');
    
    Q1= median(critWindOrd(find(critWindOrd < median(critWindOrd))));
    Q2= median(critWindOrd);
    Q3= median(critWindOrd(find(critWindOrd > median(critWindOrd))));
    IQR= Q3-Q1;
       
    if ~isnan(IQR)
        threshNew= Q2+(Q3-Q2)/2; %TO TAKE INTO ACCOUNT POSITIVE SKEWNESS
        overThresh= find(critWindOrd > threshNew);
        IDX= idxORD(overThresh);
    else
        nChKurt= fix(nCh/3);      % take 1/3 of the channels satisfying the requirement
        IDX= idxORD(1:nChKurt);
    end
    
    newCh= {chSel{1,IDX}};
    newnCh= length(newCh);
    saveMX= [critWindOrd'; idxORD'];

    fidkChans= fopen(fullFileNameChans,'wt');
    fprintf(fidkChans, '%s\t %s\r\n', 'CritWindOrd', 'idxORD');
    fprintf(fidkChans, '%d\t %d\r\n', saveMX );
    fprintf(fidkChans, '%s\t %s\t %s\t %s\t %s\r\n', 'Q1', 'Q2', 'Q3', 'IQR', 'nCHKurt' );
    fprintf(fidkChans, '%f\t %f\t %f\t %f\t  %f\r\n', Q1, Q2, Q3, IQR, nChKurt );
    fclose(fidkChans);
    
    if RB3 == 1
    %--------------------------------------
    % Staba-based HFO Detection Parameters
    %--------------------------------------
    
    RMSWind= str2double(get(handles.edit9, 'String'));                     % 3 msec
    if isnan(RMSWind)
        warndlg('Please insert a correct RMS window', 'Select RMS window')
        return
    end
    SDThresh= str2double(get(handles.edit10, 'String'));                   % 5 Standard deviations
    if isnan(SDThresh)
        warndlg('Please insert a correct threshold on SD', 'Select SD Threshold')
        return
    end
    RMSDuration= str2double(get(handles.edit11, 'String'));                % 6 msec
    if isnan(RMSDuration)
        warndlg('Please insert a correct RMS duration', 'Select RMS Duration')
        return
    end
    nPeaks = str2double(get(handles.edit12, 'String'));                    % 6 peaks
    if isnan(nPeaks)
        warndlg('Please insert a correct number of peaks', 'Select number of peaks in HFO')
        return
    end
    RectThresh= str2double(get(handles.edit13, 'String'));                 % 3 Standard deviations for the rectified EEG signal
    if isnan(RectThresh)
        warndlg('Please insert a correct Threshold over rectified signal ', 'Select rectifyng threshold')
        return
    end
    
    HFOMX= StabaHFODetection(EEG,IDX, newCh, RMSDuration, RMSWind, SDThresh, nPeaks, RectThresh, windLen, windOver, nWind, srate, inspInterv);
    
    fid1= fopen(fullNameHFO, 'wt');
    fprintf(fid1, '%12s\t%12s\t%12s\t%12s\t%12s\t%12s\t%12s\r\n', '     Channel', '      TotHFO', '      HFOIdx', '   tstart[s]', '     tend[s]', '      Dur[s]', '  Dur[sampl]' );
    
    
    for c= 1:newnCh
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
                    ts= ws+ hfoEvent(n,1)/srate;
                    te= ws+ hfoEvent(n,2)/srate;
                    durTime= te-ts;
                    durSampl= hfoEvent(n,2)- hfoEvent(n,1);
                    if idx == 1
                        fprintf(fid1, '%12s\t%12d\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', deblank(newCh{c}),  nTotHFO, idx, ts, te, durTime, durSampl);
                    else
                        fprintf(fid1, '%12s\t%12s\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', [], [],  idx, ts, te, durTime, durSampl);
                    end
                    idx= idx + 1;
                end
                
            end
            
        end
    end
    
    fclose(fid1);
    disp('Staba-based detection concluded')
    
    end
    
    if RB4 == 1
    %--------------------------------------
    % Custom-Based HFO Detection Parameters
    %--------------------------------------
    
    ARTREM1= get(handles.radiobutton1, 'Value');                 % Artefact removal based on channels criteria
    if ARTREM1 == 1
        NCHANSART=  str2double(get(handles.edit17, 'String'));
        if isnan(NCHANSART)
            warndlg('Please, select a correct number of channels for artefact removal', 'Select channels for artefact removal');
            return
        end
    else
        NCHANSART =0;
    end
    ARTREM2= get(handles.radiobutton2, 'Value');                 % Artefact removal based on power distribution criteria
    KWind=   str2double(get(handles.edit14, 'String'));                   % 3 msec
    if isnan(KWind)
        warndlg('Please insert a correct window length', 'Select window length')
        return
    end
    KSDThresh= str2double(get(handles.edit15, 'String'));               % 5 Standard deviations
    if isnan(KSDThresh)
        warndlg('Please insert a correct threshold over SD', 'Select SD threshold')
        return
    end
    KDuration= str2double(get(handles.edit16, 'String'));              % 20 msec for ripple and 10ms for fast ripples
    if isnan(KDuration)
        warndlg('Please insert a correct duration for ripples', 'Select min. duration for ripples')
        return
    end
    WindowsIdx= 1:nWind;        % all the windows
    
    
    
    HFOCOEFFnoArt= MyHFODetection(ARTREM1, NCHANSART, ARTREM2, scalMx, IDX,newCh, windLen, windOver, nWind,srate,inspInterv, KWind, KSDThresh, KDuration, WindowsIdx);
    
    fid2= fopen(fullNameHFOCust, 'wt');
    fprintf(fid2, '%12s\t%12s\t%12s\t%12s\t%12s\t%12s\t%12s\r\n', '     Channel', '      TotHFO', '      HFOIdx', '   tstart[s]', '     tend[s]', '      Dur[s]', '  Dur[sampl]' );
    
    
    for c= 1:newnCh
        idx= 1;
        totEvents=cellfun(@(x) size(x,1), HFOCOEFFnoArt(c,:), 'UniformOutput',0);
        totEventMX= cell2mat(totEvents);
        nTotHFO= sum(totEventMX);
        
        for w= 1: nWind
            hfoEvent= HFOCOEFFnoArt{c,w};
            if isempty(hfoEvent)== 0
                ws= timeMx(w,1);
                
                nHFOpw= size(hfoEvent,1);
                
                for n=1:nHFOpw
                    ts= ws+ hfoEvent(n,1)/srate;
                    te= ws+ hfoEvent(n,2)/srate;
                    durTime= te-ts;
                    durSampl= hfoEvent(n,2)- hfoEvent(n,1);
                    if idx == 1
                        fprintf(fid2, '%12s\t%12d\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', deblank(newCh{c}),  nTotHFO, idx, ts, te, durTime, durSampl);
                    else
                        fprintf(fid2, '%12s\t%12s\t%12d\t%12.4f\t%12.4f\t%12.4f\t%12d\r\n', [], [],  idx, ts, te, durTime, durSampl);
                    end
                    idx= idx + 1;
                end
                
            end
            
        end
    end
    
    fclose(fid2);
    disp('Wavelet-based detection concluded')
    end
end

function pushbutton4_Callback(hObject, eventdata, handles)
fileToAnalyse= get(handles.listbox1, 'String');
if isempty(fileToAnalyse)
    return
end

nFiles= size(fileToAnalyse,1);

windLen= fix(str2double(get(handles.edit1, 'String')));         % 1 sec/ 0.5 sec
if isnan(windLen)
    warndlg('Please insert a correct window length', 'Select window length')
    return
end

windOver= fix(str2double(get(handles.edit2, 'String')));               % 0 sec
if isnan(windOver)
    warndlg('Please insert a correct window overlap', 'Select window overlap')
    return
end

freqBandStr= get(handles.edit3, 'String');
space= strfind(freqBandStr, ' ');
f1= str2double(freqBandStr(1:space-1));
f2= str2double(freqBandStr(space+1:end));
freqBand= [f1 f2];

if f1 >= f2
    warndlg('f1 must be lower than f2', 'Select frequency band')
    return
end

if f1==0 || f2 ==0
    warndlg('f1 or F2 cannot be zero', 'Select frequency band')
    return
end

wavList = {'cmor1-1.5','cmor1-1', 'cmor1-0.5','cmor1-0.1', 'cmor2-1.5', 'cmor2-1', 'cmor2-0.5', 'cmor2-0.1','cmor3-1.5'};
selWav= wavList(get(handles.popupmenu1, 'Value'));       % Complex Morlet


%--------------------------------------
% Staba-based HFO Detection Parameters
%--------------------------------------

RMSWind= str2double(get(handles.edit9, 'String'));                     % 3 msec
if isnan(RMSWind)
    warndlg('Please insert a correct RMS window', 'Select RMS window')
    return
end
SDThresh= str2double(get(handles.edit10, 'String'));                   % 5 Standard deviations
if isnan(SDThresh)
    warndlg('Please insert a correct threshold on SD', 'Select SD Threshold')
    return
end
RMSDuration= str2double(get(handles.edit11, 'String'));                % 6 msec
if isnan(RMSDuration)
    warndlg('Please insert a correct RMS duration', 'Select RMS Duration')
    return
end
nPeaks = str2double(get(handles.edit12, 'String'));                    % 6 peaks
if isnan(nPeaks)
    warndlg('Please insert a correct number of peaks', 'Select number of peaks in HFO')
    return
end
RectThresh= str2double(get(handles.edit13, 'String'));                 % 3 Standard deviations for the rectified EEG signal
if isnan(RectThresh)
    warndlg('Please insert a correct Threshold over rectified signal ', 'Select rectifyng threshold')
    return
end


%--------------------------------------
% Custom-Based HFO Detection Parameters
%--------------------------------------

ARTREM1= get(handles.radiobutton1, 'Value');                 % Artefact removal based on channels criteria
ARTREM2= get(handles.radiobutton2, 'Value');                 % Artefact removal based on power distribution criteria
KWind=   str2double(get(handles.edit14, 'String'));                   % 3 msec
if isnan(KWind)
    warndlg('Please insert a correct window length', 'Select window length')
    return
end
KSDThresh= str2double(get(handles.edit15, 'String'));               % 5 Standard deviations
if isnan(KSDThresh)
    warndlg('Please insert a correct threshold over SD', 'Select SD threshold')
    return
end
KDuration= str2double(get(handles.edit16, 'String'));              % 20 msec for ripple and 10ms for fast ripples
if isnan(KDuration)
    warndlg('Please insert a correct duration for ripples', 'Select min. duration for ripples')
    return
end

[pathstr,~,~] = fileparts(fileToAnalyse{1});


[filename, filepath]= uiputfile([pathstr '\' 'MultipleFile DetectionConfiguration.txt'], 'Save configuration file');

fid= fopen([filepath filename], 'wt');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\r\n', 'Files');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

for i=1:nFiles
    fprintf(fid, '%s\r\n', fileToAnalyse{i});
end
fprintf(fid, '%s\r\n', ' ');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\r\n', 'Parameters for Wavelet analysis');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\t%s\r\n', 'Window Lenght [s]', num2str(windLen));
fprintf(fid, '%s\t%s\r\n', 'Window Overlap [s]', num2str(windOver));
fprintf(fid, '%s\t%s\r\n', 'Frequency band [Hz]', num2str(freqBand));
fprintf(fid, '%s\t%s\r\n', 'Wavelet', selWav{:});

fprintf(fid, '%s\r\n', ' ');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\r\n', 'Parameters for Staba-based HFO Detection');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\t%s\r\n', 'RMS Window length [ms]', num2str(RMSWind));
fprintf(fid, '%s\t%s\r\n', 'SD', num2str(SDThresh));
fprintf(fid, '%s\t%s\r\n', 'RMS Duration [ms]', num2str(RMSDuration));
fprintf(fid, '%s\t%s\r\n', 'Number of peaks', num2str(nPeaks));
fprintf(fid, '%s\t%s\r\n', 'SD threshold on rectified signal', num2str(RectThresh));

fprintf(fid, '%s\r\n', ' ');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\r\n', 'Parameters for Kurtosis-based Detection');
fprintf(fid, '%s\r\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(fid, '%s\t%s\r\n', 'Artefact removal based on channels criteria', num2str(ARTREM1));
fprintf(fid, '%s\t%s\r\n', 'Artefact removal based on power distribution criteria', num2str(ARTREM2));
fprintf(fid, '%s\t%s\r\n', 'Subwindow length [ms]', num2str(KWind ));
fprintf(fid, '%s\t%s\r\n', 'SD', num2str(KSDThresh));
fprintf(fid, '%s\t%s\r\n', 'Minimum duration of HFO', num2str(KDuration));

disp('Done');
fclose(fid);


function pushbutton3_Callback(hObject, eventdata, handles)
close(gcf)

function varargout = SOZIdentification(varargin)
% SOZIDENTIFICATION MATLAB code for SOZIdentification.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SOZIdentification_OpeningFcn, ...
    'gui_OutputFcn',  @SOZIdentification_OutputFcn, ...
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


% --- Executes just before SOZIdentification is made visible.
function SOZIdentification_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);

set(handles.listbox1, 'String', [])
set(handles.listbox4, 'String', [])
set(handles.edit5, 'Enable', 'off')
set(handles.pushbutton6, 'Enable', 'off')
set(handles.pushbutton12, 'Enable', 'off')


% --- Outputs from this function are returned to the command line.
function varargout = SOZIdentification_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel Seizure 1: load results from first seizure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
[filenameS1, filepathS1]= uigetfile('*.txt', 'Select HFO rate of first seizure');
if ischar(filenameS1)== 0 && ischar(filepathS1)==0
    return
end

set(handles.edit1, 'String', [filepathS1 filenameS1]);


fidS1= fopen([filepathS1  filenameS1], 'r');
formatSpec = '%s%f';
dataArray = textscan(fidS1, formatSpec);

percArray= dataArray{1,2};
[percArrayOrd, idx1]= sort(percArray, 'descend');


for i=1:size(dataArray{1,1},1)
    Table{i,1}= dataArray{1,1}{idx1(i),1};
    Table{i,2}= percArrayOrd(i);
end

set(handles.uitable1, 'Data', Table, 'RowName', 'numbered')

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel Seizure 2: load results from second seizure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton3_Callback(hObject, eventdata, handles)
[filenameS2, filepathS2]= uigetfile('*.txt', 'Select HFO rate of second seizure');
if ischar(filenameS2)== 0 && ischar(filepathS2)==0
    return
end

set(handles.edit3, 'String', [filepathS2 filenameS2]);


fidS2= fopen([filepathS2  filenameS2], 'r');
formatSpec = '%s%f';
dataArray = textscan(fidS2, formatSpec);

percArray= dataArray{1,2};
[percArrayOrd, idx2]= sort(percArray, 'descend');


for i=1:size(dataArray{1,1},1)
    Table{i,1}= dataArray{1,1}{idx2(i),1};
    Table{i,2}= percArrayOrd(i);
end

set(handles.uitable3, 'Data', Table, 'RowName', 'numbered')


function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel Clinical SOZ: Load SOZ sensors as identified by clinicians. If no
% SOZ is loaded, the evaluation of the performances of the detection is not
% possible.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pushbutton4_Callback(hObject, eventdata, handles)
[filenameSOZ, filepathSOZ]= uigetfile('*.txt', 'Select Clinical SOZ file');
if ischar(filenameSOZ)== 0 && ischar(filepathSOZ)==0
    return
end

set(handles.edit4, 'String', [filepathSOZ filenameSOZ]);

fidSOZ= fopen([filepathSOZ  filenameSOZ], 'r');
formatSpec = '%s';
dataArray = textscan(fidSOZ, formatSpec);
set(handles.listbox1, 'String', dataArray{1,1}, 'Value', [], 'Min',1, 'Max', 100)


function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel HFO Area identification: Select the method for HFO area Identification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function checkbox1_Callback(hObject, eventdata, handles)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox5, 'Value', 0)
set(handles.checkbox6, 'Value', 0)
set(handles.edit5, 'Enable', 'on')


if get(hObject, 'Value')==0
    set(handles.edit5, 'Enable', 'off')
end

function edit5_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 1)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox6, 'Value', 0)

function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox2_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox5, 'Value', 0)
set(handles.checkbox6, 'Value', 0)
set(handles.edit5, 'String', [])
set(handles.edit5, 'Enable', 'off')

function checkbox3_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox5, 'Value', 0)
set(handles.checkbox6, 'Value', 0)
set(handles.edit5, 'String', [])
set(handles.edit5, 'Enable', 'off')

function checkbox4_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox5, 'Value', 0)
set(handles.checkbox6, 'Value', 0)
set(handles.edit5, 'String', [])
set(handles.edit5, 'Enable', 'off')


function checkbox6_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox5, 'Value', 0)
set(handles.edit5, 'String', [])
set(handles.edit5, 'Enable', 'off')


function checkbox5_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0)
set(handles.checkbox2, 'Value', 0)
set(handles.checkbox3, 'Value', 0)
set(handles.checkbox4, 'Value', 0)
set(handles.checkbox6, 'Value', 0)
set(handles.edit5, 'String', [])
set(handles.edit5, 'Enable', 'off')



function pushbutton5_Callback(hObject, eventdata, handles)

Table1= get(handles.uitable1, 'Data');
Table2= get(handles.uitable3, 'Data');
SOZ= get(handles.listbox1, 'String');

if isempty(Table1{1,1})
    warndlg('Load Seizure 1 data', 'Warning Message')
    return
end

perc1=  cell2mat(Table1(:,2));
perc2=  cell2mat(Table2(:,2));

cb1= get(handles.checkbox1, 'Value');
cb2= get(handles.checkbox2, 'Value');
cb3= get(handles.checkbox3, 'Value');
cb4= get(handles.checkbox4, 'Value');
cb5= get(handles.checkbox5, 'Value');
cb6= get(handles.checkbox6, 'Value');

if cb1 == 0 && cb2 == 0 && cb3 == 0 && cb4 == 0 && cb5 == 0  && cb6 == 0
    warndlg('Please select the sensors selection strategy', 'Warning Message')
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum value method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cb1 == 1 && cb2 == 0 && cb3 == 0 && cb4 == 0 && cb6 == 0
    
    if cb5 ~= 1
        set(handles.listbox4, 'String', [])
        set(handles.pushbutton6, 'Enable', 'off')
    end
    
    
    if isempty(get(handles.edit5, 'String'))
        warndlg('Please indicate the maximum number of channels', 'Warning Message')
        return
    else
        nMax= str2num(get(handles.edit5, 'String'));
    end
    
    perc1U= sort(unique(perc1), 'descend');
    perc1Sel= perc1U(1:nMax);
    
    idx1= [];
    for i= 1:nMax
        idx= find(perc1== perc1Sel(i));
        idx1= [idx1; idx];
    end
        
    if isempty(perc2)
        idx2= [];
    else
        
        perc2U= sort(unique(perc2), 'descend');
        perc2Sel= perc2U(1:nMax);
        
        idx2= [];
        for i= 1:nMax
            idx= find(perc2== perc2Sel(i));
            idx2= [idx2; idx];
        end
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tukey's Fence method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif cb1 == 0 && cb2 == 1 && cb3 == 0 && cb4 == 0 && cb6 == 0
    
    if cb5 ~= 1
        set(handles.listbox4, 'String', [])
        set(handles.pushbutton6, 'Enable', 'off')
    end
    perc1full= perc1(perc1~=0);
    perc1Sort= sort(perc1full);
    
    Q11= median(perc1Sort(find(perc1Sort < median(perc1Sort))));
    Q21= median(perc1Sort);
    Q31= median(perc1Sort(find(perc1Sort > median(perc1Sort))));
    
    IQR1= Q31-Q11;
    
    upFence1= Q31+1.5*IQR1;
    
    idx1= find(perc1 >= upFence1);
    
    if isempty(idx1)
        upFence1_large= Q31;
        idx1= find(perc1 >= upFence1_large);
    end
   
    
    if isempty(perc2)
        idx2= [];
    else
        perc2full= perc2(perc2~=0);
        perc2Sort= sort(perc2full);
        
        Q12= median(perc2Sort(find(perc2Sort < median(perc2Sort))));
        Q22= median(perc2Sort);
        Q32= median(perc2Sort(find(perc2Sort > median(perc2Sort))));
        
        IQR2= Q32-Q12;
        
        upFence2= Q32+1.5*IQR2;
        
        idx2= find(perc2 >= upFence2);
        if isempty(idx2)
            upFence2_large= Q32;
            idx2= find(perc2 >= upFence2_large);
        end
    end
    
    
elseif cb1 == 0 && cb2 == 0 && cb3 == 1 && cb4 == 0 && cb6 == 0
    if cb5 ~= 1
        set(handles.listbox4, 'String', [])
        set(handles.pushbutton6, 'Enable', 'off')
    end
    perc1full= perc1(perc1~=0);
    
    if isempty(perc2)
        
        [~,U1,~] = fcm(perc1full,2);
        
        g11= find(U1(1,:)> 0.4);
        g21= find(U1(2,:)> 0.4);
        
        if length(g11) < length(g21)
            sS= fix(20*length(g21)/100);
            idx1= g11(1):g11(end)+sS;
        else
            sS= fix(20*length(g11)/100);
            idx1= g21(1):g21(end)+sS;
        end
        
        idx2= [];
        
    else
        m= 0.7;
        [~,U1,~] = fcm(perc1full,2);
        
        g11= find(U1(1,:)> m);
        g21= find(U1(2,:)> m);
        
        if length(g11) < length(g21)
            idx1= g11;
        else
            idx1= g21;
        end
        
        perc2full= perc2(perc2~=0);
        [~,U2,~] = fcm(perc2full,2);
        
        g21= find(U2(1,:)> m);
        g22= find(U2(2,:)> m);
        
        if length(g21) < length(g22)
            idx2= g21;
        else
            idx2= g22;
        end
    end
    
    
    
elseif cb1 == 0 && cb2 == 0 && cb3 == 0 && cb4 == 1 && cb6 == 0
    if cb5 ~= 1
        set(handles.listbox4, 'String', [])
        set(handles.pushbutton6, 'Enable', 'off')
    end
    
    [f1,x1]= ksdensity(perc1(perc1~=0));
    f1= smooth(f1);
    [pks1, ~]= findpeaks(f1);
    [valley1, vlocs1] = findpeaks(-f1);
    valley1= -valley1;
    
    if length(pks1)> 1
        p1= max(pks1);
        xp1= find(f1==p1);
        
        [~,  mloc1]= min(abs(vlocs1-xp1)) ; % find the closest valley to the maximum peak
        
        if p1 > 1.8* valley1(mloc1)
            [~, iV1]= min(valley1);
            thresh1=  x1(vlocs1(iV1));
            idx1= find(perc1 > thresh1);
        else
            idx1= [];
        end
        
    else
        idx1= [];
    end
    
    if isempty(perc2)
        idx2= [];
    else
        [f2,x2]= ksdensity(perc2(perc2~=0));
        f2= smooth(f2);
        [pks2, ~]= findpeaks(f2);
        [valley2, vlocs2] = findpeaks(-f2);
        valley2= -valley2;
        
        
        if length(pks2)> 1
            
            p2= max(pks2);
            xp2= find(f2==p2);
            
            [~,  mloc2]= min(abs(vlocs2-xp2)) ; % find the closest valley to the maximum peak
            
            if p2 > 1.8* valley2(mloc2)
                [~, iV2] = min(valley2);
                thresh2=  x2(vlocs2(iV2));
                idx2= find(perc2 > thresh2);
            else
                idx2= [];
            end
        else
            idx2= [];
        end
    end
    
elseif cb1 == 0 && cb2 == 0 && cb3 == 0 && cb4 == 0 && cb6 == 1
    if cb5 ~= 1
        set(handles.listbox4, 'String', [])
        set(handles.pushbutton6, 'Enable', 'off')
    end
    
    perc1full= perc1(perc1~=0);
    idx1= [];
    idx2= [];
    
    if isempty(perc2)
        idx11= kmeans(perc1full,3);
        idxU1= unique(idx11, 'Stable');
        
        idx1= [find(idx11==idxU1(1)); find(idx11==idxU1(2))];
        idx2= [];
    else
        idx11= kmeans(perc1full,2);
        idxU1= unique(idx11, 'Stable');
        idx1= find(idx11==idxU1(1));
        
        perc2full= perc2(perc2~=0);
        idx22= kmeans(perc2full,2);
        idxU2= unique(idx22, 'Stable');
        
        idx2= find(idx22==idxU2(1));
    end
    
    
elseif cb1 == 0 && cb2 == 0 && cb3 == 0 && cb4 == 0 && cb5 == 1 && cb6 == 0
    set(handles.listbox4, 'String', [], 'Value', 1)
    set(handles.uitable5, 'Data', cell(5,8));
    set(handles.pushbutton6, 'Enable', 'on')
    
    idxCB= [1 2 3 6 4];
    
    for i=1:5
        ii= idxCB(i);
        set(handles.(sprintf('checkbox%d', ii)), 'Value', 1)
        if ii==1
            set(handles.edit5, 'String', num2str(5))
        end
        idxArray= setdiff([1 2 3 6 4 ],ii);
        
        for j= 1:4
            set(handles.(sprintf('checkbox%d', idxArray(j))),  'Value', 0)
        end
        
        pushbutton5_Callback(hObject, eventdata, handles)
        
    end
    set(handles.checkbox4, 'Value', 0)
    set(handles.checkbox5, 'Value', 1)
    return
    
end

idxRow= find([cb1 cb2 cb3 cb6 cb4]~=0);
Methods= {'Max Value', 'Tukey', 'FuzzyClustering', 'k-means Clustering', 'KDE Distribution'};

if isempty(idx1) && isempty(idx2) 
    Str2print= [Methods{idxRow} ': HFO area could not be detected'];
    LB4= get(handles.listbox4, 'String');
    if isempty(LB4)
        nRowsStr= 0;
        LB4= {[]};
    else
        nRowsStr= size(LB4,1);
    end
    LB4{nRowsStr+1,:} = Str2print;
    set(handles.listbox4, 'String', LB4, 'Value', [], 'Min',1, 'Max', 20)
    
    if cb5==1
        Data= get(handles.uitable5, 'Data');
    end
    Data(idxRow, :) = {'-' '-' '-' '-' '-' '-' '-' '-'};
    set(handles.uitable5, 'Data', Data)
    
else
    selCh1= Table1(idx1,1);
    
    if isempty(Table2)
        HFOAreaInt= selCh1;
    else
        selCh2= Table2(idx2,1);
        HFOAreaInt= [selCh1 ; selCh2];
    end
    
    HFOArea = unique(HFOAreaInt);
    HFOAreaSort= sort(HFOArea);
    
    
    if isempty(SOZ)~=1
        
        TP_Sample= intersect(HFOAreaSort, SOZ);
        
        if isempty(TP_Sample)
            TP= 0;
        else
            TP= length(TP_Sample);
        end
        
        FP_Sample= setdiff(HFOAreaSort, SOZ);
        if isempty(FP_Sample)
            FP= 0;
        else
            FP= length(FP_Sample);
        end
        
        
        FN_Sample= setdiff(SOZ,HFOAreaSort);
        if isempty(FN_Sample)
            FN= 0;
        else
            FN= length(FN_Sample);
        end
        
        
        perc1full= find(perc1~=0);
        percFull2= find(perc2~=0);
        
        if isempty(percFull2)
            fullChan= Table1(perc1full,1);
        else
            fullChan= [Table1(perc1full,1); Table2(percFull2,1)];
        end
        
        FullChanU= unique(fullChan);
        
        TN_Sample= setdiff(FullChanU, HFOAreaSort);
        
        if isempty(TN_Sample)
            TN= 0;
        else
            TN= length(TN_Sample);
        end
        
        Sens= round(TP/(TP+FN)*100,2);
        [~,pciSens] = binofit(TP, (TP+FN), 0.05);
        pciSensperc= round(pciSens*100, 2);
        ciSens= [num2str(pciSensperc(1)) '-' num2str(pciSensperc(2))];
        
        Spec= round(TN/(FP+TN)*100, 2);
        [~,pciSpec] = binofit(TN, (FP+TN), 0.05);
        pciSpecperc= round(pciSpec*100, 2);
        ciSpec= [num2str(pciSpecperc(1)) '-' num2str(pciSpecperc(2))];
        
        Str2print= HFOAreaSort{1,1};
        
        for i= 2:length(HFOAreaSort)
            Str2print= [Str2print ', ' HFOAreaSort{i,1}];
        end
        Str2print= [Methods{idxRow} ': ' Str2print];
        LB4= get(handles.listbox4, 'String');
        if isempty(LB4)
            nRowsStr= 0;
            LB4= {[]};
        else
            nRowsStr= size(LB4,1);
        end
        LB4{nRowsStr+1,:} = Str2print;
        set(handles.listbox4, 'String', LB4, 'Value', [], 'Min',1, 'Max', 20)
        
        if cb5==1
            Data= get(handles.uitable5, 'Data');
        end
        Data(idxRow, :) = {TP TN FP FN Sens ciSens Spec ciSpec};
        set(handles.uitable5, 'Data', Data)
        set(handles.pushbutton6, 'Enable', 'on')
        set(handles.pushbutton12, 'Enable', 'on')
    else
        
        Str2print= HFOAreaSort{1,1};
        
        for i= 2:length(HFOAreaSort)
            Str2print= [Str2print ', ' HFOAreaSort{i,1}];
        end
        
        Str2print= [Methods{idxRow} ': ' Str2print];
        LB4= get(handles.listbox4, 'String');
        if isempty(LB4)
            nRowsStr= 0;
            LB4= {[]};
        else
            nRowsStr= size(LB4,1);
        end
        LB4{nRowsStr+1,:} = Str2print;
        set(handles.listbox4, 'String', LB4, 'Value', [], 'Min',1, 'Max', 20)
        set(handles.uitable5, 'Data', cell(5,8))
        set(handles.pushbutton12, 'Enable', 'on')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel  Results: List channels identified in the HFO area and results of
% identification in terms of True Positive (TP), False Positive (FP), True
% Negative (TN), False Negative (FN), Sensitivity and Specificity.
% Confidence Intervals (C.I.) are also associated to metrics.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function listbox4_Callback(hObject, eventdata, handles)
function listbox4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear Gui, save Identification results and close gui
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton8_Callback(hObject, eventdata, handles)
set(handles.edit1, 'String', []);
set(handles.edit3, 'String', []);
set(handles.edit4, 'String', []);
set(handles.edit5, 'String', []);
set(handles.uitable1, 'Data', cell(20,2));
set(handles.uitable3, 'Data', cell(20,2));
set(handles.uitable5, 'Data', cell(5,8));
set(handles.listbox1, 'String', []);
set(handles.listbox4, 'String', []);
set(handles.checkbox1, 'Value', 0);
set(handles.checkbox2, 'Value', 0);
set(handles.checkbox3, 'Value', 0);
set(handles.checkbox4, 'Value', 0);
set(handles.checkbox5, 'Value', 0);
set(handles.checkbox6, 'Value', 0);
set(handles.pushbutton6, 'Enable', 'off')
set(handles.pushbutton12, 'Enable', 'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE HFOs AREA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton12_Callback(hObject, eventdata, handles)
HFOArea= get(handles.listbox4, 'String');
if isempty(HFOArea)
    return
end

mainFold= get(handles.edit1,'String');
[pathstr,~,~] = fileparts(mainFold);
[filename, filepath]= uiputfile([pathstr filesep 'HFOArea.txt'], 'Save HFO Area');
if isempty(filename)
    return
end

fid= fopen([filepath filename], 'wt');
for i=1: length(HFOArea)
    fprintf(fid, '%s\t %s\r\n', 'HFO Area',  HFOArea{i,:});
end
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE PERFORMANCE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton6_Callback(hObject, eventdata, handles)
ClinicalSOZ= get(handles.listbox1, 'String');
if isempty(ClinicalSOZ)
    return
end
mainFold= get(handles.edit4,'String');
HFOArea= get(handles.listbox4, 'String');
Res= get(handles.uitable5, 'Data');

[pathstr,~,~] = fileparts(mainFold);
[filename, filepath]= uiputfile([pathstr filesep 'HFOIdentificationResults.txt'], 'Save HFO Identification results');

if isempty(filename)
    return
end

fid= fopen([filepath filename], 'wt');

ClinicalSOZprint= ClinicalSOZ{1,1};

for i= 2:size(ClinicalSOZ,1)
    ClinicalSOZprint= [ClinicalSOZprint ', ' ClinicalSOZ{i,1}];
end

fprintf(fid, '%s\t %s\r\n', 'Clinical SOZ: ',  ClinicalSOZprint);
fprintf(fid, '\n');

for i=1: length(HFOArea)
    fprintf(fid, '%s\t %s\r\n', 'HFO Area',  HFOArea{i,:});
    fprintf(fid, '%s\t %u\r\n', 'TP', cell2mat(Res(i,1)));
    fprintf(fid, '%s\t %u\r\n', 'TN', cell2mat(Res(i,2)));
    fprintf(fid, '%s\t %u\r\n', 'FP', cell2mat(Res(i,3)));
    fprintf(fid, '%s\t %u\r\n', 'FN', cell2mat(Res(i,4)));
    fprintf(fid, '%s\t %d\r\n', 'Sens [%]', cell2mat(Res(i,5)));
    fprintf(fid, '%s\t %s\r\n', 'C.I. [%]', cell2mat(Res(i,6)));
    fprintf(fid, '%s\t %d\r\n', 'Spec [%]', cell2mat(Res(i,7)));
    fprintf(fid, '%s\t %s\r\n', 'C.I. [%}', cell2mat(Res(i,8)));
    fprintf(fid, '\n');
    fprintf(fid, '\n');
end

fclose(fid);


function uitable5_DeleteFcn(hObject, eventdata, handles)
function uitable5_CreateFcn(hObject, eventdata, handles)

function pushbutton10_Callback(hObject, eventdata, handles)
close(gcf)

function varargout = HFOStatistics(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HFOStatistics_OpeningFcn, ...
    'gui_OutputFcn',  @HFOStatistics_OutputFcn, ...
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


% --- Executes just before HFOStatistics is made visible.
function HFOStatistics_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

W = evalin('base','whos');

if isempty(W)
    inBase= 0;
    set(handles.pushbutton1, 'Enable', 'Off')
    set(handles.pushbutton6, 'Enable', 'Off')
    set(handles.pushbutton7, 'Enable', 'Off')
    set(handles.slider1, 'Enable', 'Off')
    set(handles.slider2, 'Enable', 'Off')
    set(handles.checkbox1, 'Value', 0, 'Enable', 'off');
    set(handles.checkbox2, 'Value', 0, 'Enable', 'off');
    set(handles.edit3, 'Enable', 'Off')
    set(handles.edit5, 'Enable', 'Off')
    
    set(handles.listbox4, 'String', {'Statistics can be run only after wavelet analysis.'; 'Please close the application'}, 'FontWeight', 'bold', 'ForegroundColor', 'red', 'FontSize', 12, 'Value', [])
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'kurtMx');
    end
end

if any(inBase) && W(inBase==1).bytes~=0
    set(handles.slider1, 'Enable', 'Off')
    set(handles.slider2, 'Enable', 'Off')
    set(handles.slider2, 'Value', 0)
    set(handles.checkbox1, 'Value', 0);
    set(handles.checkbox2, 'Value', 0);
    set(handles.pushbutton1, 'Enable', 'Off')
    set(handles.listbox4, 'String', [])
else
    set(handles.pushbutton1, 'Enable', 'Off')
    set(handles.pushbutton6, 'Enable', 'Off')
    set(handles.pushbutton7, 'Enable', 'Off')
    set(handles.slider1, 'Enable', 'Off')
    set(handles.slider2, 'Enable', 'Off')
    set(handles.checkbox1, 'Value', 0, 'Enable', 'off');
    set(handles.checkbox2, 'Value', 0, 'Enable', 'off');
    set(handles.edit3, 'Enable', 'Off')
    set(handles.edit5, 'Enable', 'Off')
    set(handles.listbox4, 'String', {'Statistics can be run only after wavelet analysis.'; 'Please close the application'}, 'FontWeight', 'bold', 'ForegroundColor', 'red', 'FontSize', 12 , 'Value', [])
end


function varargout = HFOStatistics_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function checkbox1_Callback(hObject, eventdata, handles)
set(handles.checkbox2, 'Value', 0);
set(handles.edit3, 'String', [], 'Enable', 'Off')
set(handles.pushbutton1, 'Enable', 'On')


function checkbox2_Callback(hObject, eventdata, handles)
set(handles.checkbox1, 'Value', 0);
set(handles.edit3, 'String', [], 'Enable', 'Inactive')
set(handles.slider1, 'Enable', 'On', 'Value', 1)
set(handles.pushbutton1, 'Enable', 'On')


function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 0, 'Max', 45, 'Value', 0, 'SliderStep', [1/45 , 1/45]);

function slider1_Callback(hObject, eventdata, handles)
trimPerc= get(hObject, 'Value');
set(handles.edit3, 'String', num2str(trimPerc))
set(handles.pushbutton1, 'Enable', 'On')

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)

function pushbutton1_Callback(hObject, eventdata, handles)
gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    warndlg('!!You must run wavelet analysis before kurtosis statistic!!')
    return
else
    g1data = guidata(gui1);
end
chIdx= get(g1data.listbox1,'Value');
chList= get(g1data.listbox1, 'String');
for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

kurtMx= evalin('base', 'kurtMx');
nWind=  evalin('base', 'nWind');
timeMx= evalin('base', 'timeMx');
nCh= length(chSel);

set(handles.listbox4, 'String', [])
set(handles.edit5, 'String', [])
set(handles.uitable2, 'Data', [])

CB1= get(handles.checkbox1, 'Value');
CB2= get(handles.checkbox2, 'Value');

if CB1 == 1 && CB2 == 0
    trimPerc= 0;
elseif CB1 == 0 && CB2 == 1
    trimPerc= str2double(get(handles.edit3, 'String'));
    
    if isnan(trimPerc)
        warndlg('Select correct % of kurtosis', 'Select Kurtosis')
        return
    end
end

meanK= zeros(nCh, nWind);
stdK= zeros(nCh, nWind);

maxK= zeros(nCh,1);

for i= 1:nCh
    currentLine= size(get(handles.listbox4, 'String'),1);
    startStr{currentLine+1}= deblank(chSel{1,i});
    set(handles.listbox4, 'String', startStr, 'FontSize', 10);
    
    for w= 1:nWind
        kurt= kurtMx{i,w};
        if trimPerc ~= 0
            kurtSort= sort(kurt);
            nk= round(length(kurtSort)*(trimPerc/100)); %Trimmered kurtosis
            kurtInt= kurt;
            kurtInt(1:nk)=[];
            kurtInt(end-nk+1:end)=[];
        else
            kurtInt= kurt;
        end
        
        meanK(i,w)= mean(kurtInt); % mean value over all the frequencies
        stdK(i,w)= std(kurtInt) ;   % std value over all the frequencies
        startStr2= sprintf('%s%s%s%s%s%s%s%s%s%s%s', '......',  'Window from ', num2str(round(timeMx(w,1))), ' to ', num2str(round(timeMx(w,2))), 'sec: ' , num2str(round(meanK(i,w),2)), char(177), num2str(round(stdK(i,w),2)), '......');
        disp(startStr2);
        currentLine= size(get(handles.listbox4, 'String'),1);
        startStr{currentLine+1}= startStr2;
        
        set(handles.listbox4, 'String',  startStr);
    end
    maxK(i)= max(meanK(i,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIT KURTOSIS DISTRIBUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanKVect= reshape(meanK,1,[]);
F= fitmethis(double(meanKVect), 'figure', 'off', 'output', 'off');

if strcmp(F(1).name, 'gev')
    k= F(1).par(1);
    sigma= F(1).par(2);
    mu= F(1).par(3);
    [m,v]= gevstat(k, sigma, mu);
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
elseif strcmp(F(1).name, 'inversegaussian')
    mu= F(1).par(1);
    lambda= F(1).par(2);
    m= mu;
    v= (mu^3)/lambda;
    
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
elseif strcmp(F(1).name, 'birnbaumsaunders')
    beta= F(1).par(1);
    gamma= F(1).par(2);
    m= beta*(1+(gamma^2)/2);
    v= (gamma*beta)^2 * (1+(5*gamma^2)/4);
    
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
elseif strcmp(F(1).name, 'weibull')
    a= F(1).par(1);
    b= F(1).par(2);
    [m, v]= wblstat(a,b);
    
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
elseif strcmp(F(1).name, 'loglogistic')
    pd = makedist('Loglogistic','mu',F(1).par(1),'sigma',F(1).par(2));
    m= mean(pd);
    v= var(pd);
    
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
elseif strcmp(F(1).name, 'lognormal')
    mu= F(1).par(1);
    sigma= F(1).par(2);
    [m,v] = lognstat(mu,sigma);
    if isinf(v)
        kurtThreshInt= 2*m;
    else
        kurtThreshInt= round(m + 3*sqrt(v));
    end
    
else
    F(1).name= 'N.A.';
    F(1).par= 0;
    kurtThreshInt= 15;
    m= 0;
    v= 0; 
end

distrStruct= struct('DistrName', F(1).name, 'DistrParam', F(1).par, 'm', m, 'v', v, 'KurtThresh', kurtThreshInt);
assignin('base', 'distrStruct', distrStruct)

%%%%%%%%%%%%%%%%
%Plot histogram
%%%%%%%%%%%%%%%%
h2= handles.axes2;
ntrials= [];
dtype= 'cont';

x = min(meanKVect):range(meanKVect)/100:max(meanKVect);
[bincount,binpos] = hist(meanKVect, min(100,numel(meanKVect)/5));

switch numel(F(1).par)
    case 1
        if strcmp('binomial',F(1).name)
            y = pdf('bino',meanKVect,ntrials(1),F(1).par(1));
        else
            y = pdf(F(1).name,meanKVect,F(1).par(1));
        end
    case 2
        y = pdf(F(1).name,x,F(1).par(1),F(1).par(2));
    case 3
        y = pdf(F(1).name,x,F(1).par(1),F(1).par(2),F(1).par(3));
end

bincount= bincount/trapz(binpos,bincount); % scaled frequencies
bar(h2, binpos,bincount,'FaceColor',[.8 .8 .8],'EdgeColor',[1 1 1],'BarWidth',1);
hold on
if strcmp('cont',dtype)
    plot(h2, x,y,'r','LineWidth',2);
else
    bar(h2, x,y,'FaceColor',[1 0 0],'EdgeColor','none','BarWidth',0.5);
end

hold on
yLim2= h2.YLim(2);
yLen= 0:0.01: yLim2/2;

plot(h2, kurtThreshInt*ones(length(yLen),1), yLen, 'g--', 'LineWidth', 2 )
xlabel('Data'); ylabel('PDF')

legend(h2, {['Kurtosis in ' num2str(nCh) ' channels and '  num2str(nWind) ' windows']; ['Fit distr.= ' F(1).name '; Thresh= ' num2str(kurtThreshInt)]}, 'Location', 'northeast');
legend('boxoff');

if h2.XLim(2)+30 > 100
    set(h2, 'XLim', [0 100])
else
    set(h2, 'XLim', [0 h2.XLim(2)+30])
end

meanKEl= mean(meanK,2);
stdKEl= std(meanK,0, 2);

[sortmeanKEl, idx] = sort(meanKEl,'descend');
stdKsort= stdKEl(idx,:);

for i=1: nCh
    Table{i,1}= deblank(chSel{idx(i)});
    Table{i,2}= [num2str(round(sortmeanKEl(i),2)) char(177) num2str(round(stdKsort(i),2))];
    Table{i,3}= round(maxK(idx(i)),2);
    Table{i,4}= [];
    Table{i,5}= [];
    RowNames{i}= num2str(i); 
end

disp('End of Kurtosis distribution fitting')

set(handles.uitable2, 'Data', Table, 'RowName', RowNames)
set(handles.slider2, 'Enable', 'On')
set(handles.slider2, 'Value', 0)
assignin('base', 'TableChanSort', idx)


function listbox4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox4_Callback(hObject, eventdata, handles)


function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 0, 'Max', 100, 'Value', 0, 'SliderStep', [1/100 , 1/100]);

function slider2_Callback(hObject, eventdata, handles)
kurtThresh= get(hObject, 'Value');
gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    warndlg('!!You must run wavelet analysis before kurtosis statistic!!')
    return
else
    g1data = guidata(gui1);
end
chIdx= get(g1data.listbox1,'Value');
chList= get(g1data.listbox1, 'String');
for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end
Table= get(handles.uitable2, 'Data');
kurtMx= evalin('base', 'kurtMx');
chSort= evalin('base','TableChanSort');
fvect= evalin('base', 'fvect');
nWind= evalin('base', 'nWind');

nCh= length(chSel);

set(handles.edit5, 'String', num2str(kurtThresh))

fMx= [];
freqInt= 20;
for i=1:nCh
    critWind= 0;
    critWindIdx= [];
    
    for w=1 :nWind
        kFreq=  kurtMx{chSort(i),w};
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
    Table{i,4}= critWind;
    Table{i,5}= num2str(critWindIdx);
end

set(handles.uitable2, 'Data', Table)

h2= handles.axes2;
yLim2= h2.YLim(2);
yLen= 0:0.01: yLim2/2;

myhandles= guidata(gcbo);
LINE= findobj(myhandles.axes2, 'Type', 'line', 'Color', 'blue');
if isempty(LINE)
    hold on
    plot(kurtThresh*ones(length(yLen),1), yLen, 'b--', 'LineWidth', 2 );
else
    delete(LINE)
    hold on
    plot(kurtThresh*ones(length(yLen),1), yLen, 'b--', 'LineWidth', 2 );
 end

h3= handles.axes3;
set(h3, 'XLim', [min(fvect) max(fvect)])
fMx2vect= reshape(fMx, 1, []);
fMx2vect2= cell2mat(fMx2vect);
fMx2vect2(fMx2vect2==0)=[];
histFreq= histogram(h3, fMx2vect2, 50);
set(histFreq,'FaceColor','r','EdgeColor','r');


function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton6_Callback(hObject, eventdata, handles)
fullTable= get(handles.uitable2, 'Data');
kurtThresh= get(handles.slider2, 'Value');

[fileName, filePath] = uiputfile(['WindowsKurtosis' num2str(kurtThresh) '.txt'], 'Save Table As:');

if fileName == 0
    return
end
fullName = fullfile(filePath,fileName);
fid= fopen(fullName, 'w');
formatSpec= '%s\t%s\t%g\t%u\t%s\n';
[nrows,~] = size(fullTable);

fprintf(fid, '%s\t%s\t%s\t%s\t%s\n', 'Electrode', 'MeanKurt', 'MaxKurt', 'Windows', 'WindowsInd' );

for i=1: nrows
    fprintf(fid, formatSpec, fullTable{i, 1},fullTable{i, 2}, fullTable{i, 3}, fullTable{i, 4}, fullTable{i, 5});
end

fclose(fid);

function pushbutton7_Callback(hObject, eventdata, handles)
h2= handles.axes2;
%axesLeg= getappdata(gcf,'LegendPeerHandle');
axesLeg = findall(gcf,'Type','legend') ;
hfig = figure('Visible','on', 'Color', 'w', 'units','normalized','outerposition',[0 0 1 1]);
hax_new = copyobj([axesLeg h2], hfig);

%PosH= get(hax_new, 'Position');
% set(hax_new(1), 'Position', [PosH{1,1}(1)*1.5, PosH{1,1}(2)*2, PosH{1,1}(3)*2, PosH{1,1}(4)*2], 'FontSize', 12, 'FontWeight', 'bold')  %legend
% set(hax_new(2), 'Position', [PosH{2,1}(1)*1.5, PosH{2,1}(2)*2, PosH{2,1}(3)*2, PosH{2,1}(4)*2], 'FontSize', 12, 'FontWeight', 'bold')  %figure


function pushbutton10_Callback(hObject, eventdata, handles)

distrStruct= evalin('base', 'distrStruct');
[FileName,PathName,FilterIndex] = uiputfile('Kurtosis.txt','Save kurtosis distribution info');

fidkDistr= fopen([PathName FileName], 'wt');
fprintf(fidkDistr, '%s\t%20s\t%s\t%s\t%s\r\n', 'Distribution', 'Parameters          ', 'Mean', 'Variance', 'K threshold' );
fprintf(fidkDistr, '%s\t%s\t%f\t%f\t%d\r\n', distrStruct.DistrName, num2str(distrStruct.DistrParam), distrStruct.m, distrStruct.v, distrStruct.KurtThresh );
fclose(fidkDistr);


function pushbutton11_Callback(hObject, eventdata, handles)

gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    warndlg('!!You must run wavelet analysis before kurtosis statistic!!')
    return
else
    g1data = guidata(gui1);
end

chIdx= get(g1data.listbox1,'Value');
chList= get(g1data.listbox1, 'String');

for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

Table= get(handles.uitable2, 'Data');
currKurt= get(handles.edit5, 'String');
nCh= size(Table,1);
CRITWIND= cell2mat(Table(:,4));
[critWindOrd, idxORD]= sort(CRITWIND, 'descend');
    
Q1= median(critWindOrd(find(critWindOrd < median(critWindOrd))));
Q2= median(critWindOrd);
Q3= median(critWindOrd(find(critWindOrd > median(critWindOrd))));
IQR= Q3-Q1;

nChKurt= fix(nCh/3); 
if ~isnan(IQR)
    threshNew= Q2+(Q3-Q2)/2; %TO TAKE INTO ACCOUNT POSITIVE SKEWNESS
    overThresh= find(critWindOrd > threshNew);
    IDX= idxORD(overThresh);
else
    IDX= idxORD(1:nChKurt);% take 1/3 of the channels satisfying the requirement
end

chSelOrd= Table(:,1);
newCh= chSelOrd(idxORD);
newnCh= length(newCh);

for i=1:newnCh
    index(i)= find(strcmp(newCh{i}, chSel));
end

saveMX= [critWindOrd'; index];

[FileName,PathName,FilterIndex] = uiputfile(['ChansAfterKurtosis' currKurt '.txt'],'Save kurtosis distribution info');

fidkChans= fopen([PathName FileName],'wt');
fprintf(fidkChans, '%s\t %s\r\n', 'CritWindOrd', 'idxORD');
fprintf(fidkChans, '%d\t %d\r\n', saveMX );
fprintf(fidkChans, '%s\t %s\t %s\t %s\t %s\r\n', 'Q1', 'Q2', 'Q3', 'IQR',  'nCHKurt' );
fprintf(fidkChans, '%f\t %f\t %f\t %f\t  %f\r\n', Q1, Q2, Q3, IQR, length(IDX));
fclose(fidkChans);



function pushbutton8_Callback(hObject, eventdata, handles)
    close(gcf)


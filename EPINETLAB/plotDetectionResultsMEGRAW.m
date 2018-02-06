%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DETECTION RESULTS WITH MEG RAW CHANNELS
% AUTHOR: Lucia Rita Quitadamo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RAWGRID={'0'	'0'	'0'	'0'	'0'	'0521'	'0811'	'0911'	'0'	'0'	'0'	'0'	'0'	'0'; ...
        '0'	'0'	'0'	'0'	'0511'	'0531'	'0821'	'0941'	'0921'	'0'	'0'	'0'	'0'	'0'; ...
        '0'	'0'	'0'	'0311'	'0541'	'0611'	'1011'	'1021'	'0931'	'1211'	'0'	'0'	'0'	'0';...
        '0111'	'0121'	'0341'	'0321'	'0331'	'0641'	'0621'	'1031'	'1241'	'1231'	'1221'	'1411'	'1421'	'0'; ...
        
        '0141'	'0131'	'0211'	'0221'	'0411'	'0421'	'0631'	'1041'	'1111'	'1121'	'1311'	'1321'	'1441'	'1431'; ...
        '0'	'1511'	'0241'	'0231'	'0441'	'0431'	'0711'	'0721'	'1141'	'1131'	'1341'	'1331'	'2611'	'0'; ...
        '1541'	'1521'	'1611'	'1621'	'1911'	'1921'	'0741'	'0731'	'2211'	'2221'	'2411'	'2421'	'2641'	'2621'; ...
        '0'	'1531'	'1721'	'1641'	'1631'	'1941'	'1931'	'2241'	'2231'	'2441'	'2431'	'2521'	'2631'	'0'; ...
        '0'	'0'	'1711'	'1731'	'1941'	'1911'	'2011'	'2021'	'2311'	'2321'	'2511'	'2531'	'0'	'0'; ...
        '0'	'0'	'0'	'1741'	'1931'	'1921'	'2041'	'2031'	'2341'	'2331'	'2541'	'0'	'0'	'0'; ...
         
        '0'	'0'	'0'	'0'	'0'	'0'	'2111'	'0'	'0'	'0'	'0'	'0'	'0'	'0'; ...
        '0'	'0'	'0'	'0'	'0'	'0'	'2121'	'0'	'0'	'0'	'0'	'0'	'0'	'0'; ...
        '0'	'0'	'0'	'0'	'0'	'2141'	'0'	'2131'	'0'	'0'	'0'	'0'	'0'	'0'};
MEGRAWGRID= strcat('MEG',  RAWGRID);

% Read HFO detection files
[fileToAnalyse, filepath]= uigetfile('*.txt', 'Select HFO detection results files',  'MultiSelect', 'on' );

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

%Read MEG channels Location
MEGRawFID= fopen('MEGMontageRAW.loc', 'r');
MEGMontage = textscan(MEGRawFID, '%s', 'Delimiter', '');

intRes= cell(nFiles,2);

finalCHAN= [];
finalTOTHFO= [];
for n =1:nFiles
    if nFiles==1
        fidHFO= fopen([filepath fileToAnalyse], 'r');
    else
        fidHFO= fopen([filepath fileToAnalyse{1,n}], 'r');
    end
    formatSpec = '%13s%13s%13s%13s%13s%13s%s%[^\n\r]';
    
    dataArray = textscan(fidHFO, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false);
    
    if strcmp(strtrim(dataArray{1,1}{1,1}), 'Channel')==0 || strcmp(strtrim(dataArray{1,2}{1,1}), 'TotHFO')== 0 || strcmp(strtrim(dataArray{1,3}{1,1}), 'HFOIdx')== 0 ||    strcmp(strtrim(dataArray{1,4}{1,1}), 'tstart[s]')==0 ||    strcmp(strtrim(dataArray{1,5}{1,1}), 'tend[s]')==0 ||    strcmp(strtrim(dataArray{1,6}{1,1}), 'Dur[s]')==0 ||    strcmp(strtrim(dataArray{1,7}{1,1}), 'Dur[sampl]')==0
        warndlg('Wrong .txt file format')
        fclose(fidHFO);
        return
    end
    
    dataArray{1,1}(1)= []; dataArray{1,2}(1)= []; dataArray{1,3}(1)= [];
    dataArray{1,4}(1)= []; dataArray{1,5}(1)= []; dataArray{1,6}(1)= [];
    dataArray{1,7}(1)= [];
    
    Channel = dataArray{:, 1};
    TotHFO = dataArray{:, 2};
    
    if size(Channel,1)> size(TotHFO,1)
        Channel(end)= [];
    end
    
    deblankHFO= strtrim(TotHFO);
    empHFO= cellfun('isempty', deblankHFO);
    deblankHFO(empHFO)={'0'};
    deblankHFONum= cellfun(@str2num, deblankHFO);
    
    deblankHFONumIdx= find(deblankHFONum~=0);
    
    ChanneldeBlank= strtrim(Channel(deblankHFONumIdx));
    TOTHFO= deblankHFONum(deblankHFONumIdx);
    
    N= sum(TOTHFO);
    chanPerc= (TOTHFO./N).*100;
    
    intRES{n,1}= ChanneldeBlank;
    intRES{n,2}= chanPerc;
    
    finalCHAN= [finalCHAN; ChanneldeBlank];
    finalTOTHFO= [finalTOTHFO; TOTHFO];
    
    [ordChanPerc, idx]= sort(chanPerc, 'descend');
    ordChan= {ChanneldeBlank{idx}};
    
    if length(ordChan)>=15
        nChToPlot= 15;
    else
        nChToPlot= length(ordChan);
    end
    
end

fid= fopen([filepath 'PercRes.txt'], 'w');
C= unique(finalCHAN);
NALL= sum(finalTOTHFO);
TotCh= zeros(length(C),1);

for c=1:length(C)
    chOcc=  cellfun(@strcmp,   {finalCHAN}, C(c,1), 'UniformOutput', 0);
    chOccIdx= find(cell2mat(chOcc)==1);
    TotCh(c)= sum(finalTOTHFO(chOccIdx))/NALL*100;
end

nRAWChan= size(MEGMontage{1,1},1);
TotChMon= zeros(nRAWChan,1);
for m=1:length(MEGMontage{1,1})
    chMon=  cellfun(@strcmp,  {C}, {MEGMontage{1,1}{m,1}}, 'UniformOutput', 0);
    chMonIdx= find(cell2mat(chMon)==1);
    if isempty(chMonIdx)
        TotChMon(m)= 0;
    else
        TotChMon(m)= TotCh(chMonIdx);
    end
end

normTotChMon= (TotChMon - min(TotChMon)) / ( max(TotChMon) - min(TotChMon));

hh= MEGRawSensorsDisplay;
cm= colormap(hh, 'hot');

fullColor= zeros(length(normTotChMon),3);
for c=1:length(normTotChMon)
    colorID= max(1, sum(normTotChMon(c) > [0:1/length(cm(:,1)):1]));
    fullColor(c,:) = cm(colorID, :);
end

nCols14= 14;
nCols23= 7;
nRowAX1= 4;
nRowAX2= 6;
nRowAX3= 6;
nRowAX4= 3;

hhChild= get(hh.Children, 'Children');
hhUP8= hhChild(1);
hhUP7= hhChild(2);
hhUP5= hhChild(3);
hhUP3= hhChild(4);
hhText3= hhChild(5);
hhText2= hhChild(6);
hhUP2= hhChild(7);

for s= 1: (nCols14*nRowAX1)
    ax= subplot(nRowAX1, nCols14, s, 'Parent', hhUP3);
    if s<= 14
        r=1; c=s;
    elseif s>14 && s<=28
        r=2; c= s-nCols14;
    elseif s>28 && s<=42
        r=3; c= s-nCols14*2;
    elseif s>42 && s<=56
        r=4; c= s-nCols14*3;
    end
    
    cc= MEGRAWGRID{r, c};
    if strcmp (cc, 'MEG0')
        rectangle(ax, 'FaceColor', 'w', 'EdgeColor', 'w');
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
    else
        idxCh= find(cell2mat(cellfun(@strcmp, MEGMontage, {cc}, 'UniformOutput', 0)));
        
        rectangle(ax, 'FaceColor', fullColor(idxCh,:), 'EdgeColor', 'k');
        if TotChMon(idxCh)~=0
            title(ax, [MEGMontage{1,1}{idxCh,1}(4:end) '[' sprintf('%4.2f', TotChMon(idxCh)) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
        else
            title(ax, MEGMontage{1,1}{idxCh,1}(4:end), 'FontWeight', 'bold', 'FontSize', 9);
        end
        
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
        fprintf(fid, '%s\t %f\n', MEGMontage{1,1}{idxCh,1}, TotChMon(idxCh));
    end
    
end

for s= 1: (nCols23*nRowAX2)
    ax= subplot(nRowAX2,nCols23, s, 'Parent', hhUP5);
    if s<= 7
        r=5; c=s;
    elseif s>7 && s<=14
        r=6; c= s-nCols23;
    elseif s>14 && s<=21
        r=7; c= s-nCols23*2;
    elseif s>21 && s<=28
        r=8; c= s-nCols23*3;
    elseif s>28 && s<=35
        r=9; c= s-nCols23*4;
    elseif s>35 && s<= 42
        r=10; c= s-nCols23*5;
    end
    
    cc= MEGRAWGRID{r, c};
    if strcmp (cc, 'MEG0')
        rectangle(ax, 'FaceColor', 'w', 'EdgeColor', 'w');
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
    else
        idxCh= find(cell2mat(cellfun(@strcmp, MEGMontage, {cc}, 'UniformOutput', 0)));
        
        rectangle(ax, 'FaceColor', fullColor(idxCh,:), 'EdgeColor', 'k');
        if TotChMon(idxCh)~=0
            title(ax, [MEGMontage{1,1}{idxCh,1}(4:end) '[' sprintf('%4.2f', TotChMon(idxCh)) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
        else
            title(ax, MEGMontage{1,1}{idxCh,1}(4:end), 'FontWeight', 'bold', 'FontSize', 9);
        end
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
        fprintf(fid, '%s\t %f\n', MEGMontage{1,1}{idxCh,1}, TotChMon(idxCh));
    end
    
end
            
 for s= 1: (nCols23*nRowAX3)
    ax= subplot(nRowAX2,nCols23, s, 'Parent', hhUP8);
    if s<= 7
        r=5; c=s+7;
    elseif s>7 && s<=14
        r=6; c= s-nCols23+7;
    elseif s>14 && s<=21
        r=7; c= s-nCols23*2+7;
    elseif s>21 && s<=28
        r=8; c= s-nCols23*3+7;
    elseif s>28 && s<=35
        r=9; c= s-nCols23*4+7;
    elseif s>35 && s<= 42
        r=10; c= s-nCols23*5+7;
    end
    
    cc= MEGRAWGRID{r, c};
    if strcmp (cc, 'MEG0')
        rectangle(ax, 'FaceColor', 'w', 'EdgeColor', 'w');
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
    else
        idxCh= find(cell2mat(cellfun(@strcmp, MEGMontage, {cc}, 'UniformOutput', 0)));
        
        rectangle(ax, 'FaceColor', fullColor(idxCh,:), 'EdgeColor', 'k');
        if TotChMon(idxCh)~=0
            title(ax, [MEGMontage{1,1}{idxCh,1}(4:end) '[' sprintf('%4.2f', TotChMon(idxCh)) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
        else
            title(ax, MEGMontage{1,1}{idxCh,1}(4:end), 'FontWeight', 'bold', 'FontSize', 9);
        end
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
        fprintf(fid, '%s\t %f\n', MEGMontage{1,1}{idxCh,1}, TotChMon(idxCh));
    end
    
end
  
for s= 1: (nCols14*nRowAX4)
    ax= subplot(nRowAX1, nCols14, s, 'Parent', hhUP7);
    if s<= 14
        r=11; c=s;
    elseif s>14 && s<=28
        r=12; c= s-nCols14;
    elseif s>28 && s<=42
        r=13; c= s-nCols14*2;
    end
    
    cc= MEGRAWGRID{r, c};
    if strcmp (cc, 'MEG0')
        rectangle(ax, 'FaceColor', 'w', 'EdgeColor', 'w');
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
    else
        idxCh= find(cell2mat(cellfun(@strcmp, MEGMontage, {cc}, 'UniformOutput', 0)));
        rectangle(ax, 'FaceColor', fullColor(idxCh,:), 'EdgeColor', 'k');
        if TotChMon(idxCh)~=0
            title(ax, [MEGMontage{1,1}{idxCh,1}(4:end) '[' sprintf('%4.2f', TotChMon(idxCh)) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
        else
            title(ax, MEGMontage{1,1}{idxCh,1}(4:end), 'FontWeight', 'bold', 'FontSize', 9);
        end
        set(ax, 'XTick', [], 'YTickLabel', [])
        box(ax, 'off')
        axis(ax, 'off')
        fprintf(fid, '%s\t %f\n', MEGMontage{1,1}{idxCh,1}, TotChMon(idxCh));
    end
    
end        
       
 cBar= colorbar('Parent', hhUP2);
 set(cBar, 'Ticks', [], 'TickLabels', [])
 AXES= findall(hhUP2,'type','axes');
 set(AXES, 'visible', 'off')



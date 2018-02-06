%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT HFO DETECTION RESULTS FROM 90 VIRTUAL CHANNELS ANALYZED. MONTAGE IS
% REPORTED IN THE ALLEGATED TEXT FILE.
% Author: Lucia Rita Quitadamo.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
MEGLocationsFID= fopen('MEGChannels.loc', 'r');
MEGLocation = textscan(MEGLocationsFID, '%s', 'Delimiter', '');

MEGLocLeft= cellfun(@(x) strcmp('L', x(end)), MEGLocation{1,1});
idxL= find(MEGLocLeft);
nL= length(idxL);
MEGLocRight= cellfun(@(x) strcmp('R', x(end)), MEGLocation{1,1});
idxR= find(MEGLocRight);
nR= length(idxR);

for i=1:size(MEGLocation{1,1},1)
   if i<10 
        MEGMontage{i,1}= ['VIRT00' num2str(i)];
   elseif i>=10 && i<100
        MEGMontage{i,1}= ['VIRT0' num2str(i)];
   elseif i>=100
        MEGMontage{i,1}= ['VIRT' num2str(i)];
   end
end

intRes= cell(nFiles,2);

% figSeach=  findobj('type','figure');
% nFig = length(figSeach);

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

nVirtChan= size(MEGMontage,1);
TotChMon= zeros(nVirtChan,1);
for m=1:length(MEGMontage)
    chMon=  cellfun(@strcmp,  {C}, {MEGMontage{m,1}}, 'UniformOutput', 0);
    chMonIdx= find(cell2mat(chMon)==1);
    if isempty(chMonIdx)
        TotChMon(m)= 0;
    else
        TotChMon(m)= TotCh(chMonIdx);
    end
end

normTotChMon= (TotChMon - min(TotChMon)) / ( max(TotChMon) - min(TotChMon));

hh= MEGVirtualSensorsDisplay;
hhChild= get(hh.Children, 'Children');

hh1= hhChild(7);
hh2= hhChild(6);
hh3= hhChild(5);

cm= colormap(hh, 'hot');

fullColor= zeros(length(normTotChMon),3);
for c=1:length(normTotChMon)
    colorID= max(1, sum(normTotChMon(c) > [0:1/length(cm(:,1)):1]));
    fullColor(c,:) = cm(colorID, :);
end

nRows= 9;
nCols= 5;

for s= 1:nVirtChan/2
    ax= subplot(nRows,nCols, s, 'Parent', hh1);
    rectangle(ax, 'FaceColor', fullColor(idxL(s),:), 'EdgeColor', 'k');
    if TotChMon(idxL(s))~=0
        title(ax, [MEGMontage{idxL(s),1} '[' sprintf('%4.2f', TotChMon(idxL(s))) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
    else
        title(ax, MEGMontage{idxL(s),1}, 'FontWeight', 'bold', 'FontSize', 9);
    end
    set(ax, 'XTick', [], 'YTickLabel', [])
    box(ax, 'off')
    axis(ax, 'off')
    fprintf(fid, '%s\t %f\n', MEGMontage{idxL(s),1}, TotChMon(idxL(s)));
end

for s= 1:nVirtChan/2
    bx= subplot(nRows,nCols, s, 'Parent', hh2);
    rectangle(bx, 'FaceColor', fullColor(idxR(s),:), 'EdgeColor', 'k');
    if TotChMon(idxR(s))~=0
        title(bx, [MEGMontage{idxR(s),1} '[' sprintf('%4.2f', TotChMon(idxR(s))) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
    else
        title(bx, MEGMontage{idxR(s),1}, 'FontWeight', 'bold', 'FontSize', 9);
    end
    set(bx, 'XTick', [], 'YTickLabel', [])
    box(bx, 'off')
    axis(bx, 'off')
    fprintf(fid, '%s\t %f\n', MEGMontage{idxR(s),1}, TotChMon(idxR(s)));
end

 cBar= colorbar('Parent', hh3);
 set(cBar, 'Ticks', [], 'TickLabels', [])
 AXES= findall(hh3,'type','axes');
 set(AXES, 'visible', 'off')



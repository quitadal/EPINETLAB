%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DETECTION RESULTS WITH MEG CHANNELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

finalCHAN= [];
finalTOTHFO= [];

[filenameMEG, filepathMEG]= uigetfile([filepath '*.txt'],  'Select MEG Virtual channels file');

if filenameMEG == 0
    return
end

OriginalMontageFID= fopen([filepathMEG filenameMEG], 'r');
MEGMontage = textscan(OriginalMontageFID, '%s', 'Delimiter', '');

intRes= cell(nFiles,2);

figSeach=  findobj('type','figure');
nFig = length(figSeach);

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

TotChMon= zeros(length(MEGMontage{1,1}),1);
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

hh= figure(nFig+1);
set(hh, 'Color', 'w', 'units','normalized','outerposition',[0 0 1 1]);
suptitle('Percent detection of HFO in MEG sensors');
colormap('hot')
cm= colormap;

fullColor= zeros(length(normTotChMon),3);
for c=1:length(normTotChMon)
    colorID= max(1, sum(normTotChMon(c) > [0:1/length(cm(:,1)):1]));
    fullColor(c,:) = cm(colorID, :);
end

nVirtChan= length(MEGMontage{1,1});
nRows= 10;
nCols= fix(nVirtChan/nRows) + rem(nVirtChan, nRows );

for s= 1:nVirtChan
    ax= subplot(nRows,nCols, s);
    rectangle('FaceColor', fullColor(s,:), 'EdgeColor', 'k');
    if  TotChMon(s)~=0
        title([MEGMontage{1,1}{s,1} '[' sprintf('%4.2f', TotChMon(s)) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
    else
        title(MEGMontage{1,1}{s,1}, 'FontWeight', 'bold', 'FontSize', 9);
    end
        
    set(ax, 'XTick', [], 'YTickLabel', [])
    box off
    axis off
    fprintf(fid, '%s\t %f\n', MEGMontage{1,1}{s,1}, TotChMon(s));
end

cBar= colorbar;
figPos= get(hh, 'Position');

set(cBar, 'Position', [0.95 0.1 0.015 0.8])




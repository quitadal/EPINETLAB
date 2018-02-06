%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DETECTION RESULTS WITH ONLY BIPOLAR CHANNELS
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

[filenameMON, filepathMON]= uigetfile([filepath '*.txt'],  'Select BIPOLAR/GRID montage file');

if filenameMON == 0
    return
end

OriginalMontageFID= fopen([filepathMON filenameMON], 'r');
BipMontage = textscan(OriginalMontageFID, '%s', 'Delimiter', '');

[filenameSING, filepathSING]= uigetfile([filepath '*.txt'],  'Select MONOPOLAR montage file');

if filenameSING == 0
    return
end
SingMontageFID= fopen([filepathSING filenameSING], 'r');
SingleMontage = textscan(SingMontageFID, '%s', 'Delimiter', '');

intRes= cell(nFiles,2);

figSeach=  findobj('type','figure');
nFig = length(figSeach);


ff= figure(nFig+1);
set(ff, 'Color', 'w', 'units','normalized','outerposition',[0 0 1 1])

nSubplotCol= 2;
r= rem(nFiles, nSubplotCol);

if r==0
    nSubplotRow= fix(nFiles/nSubplotCol);
else
    nSubplotRow= fix(nFiles/nSubplotCol)+1;
end


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
    
    if ~isempty(Channel)
        
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
        
        bx(n)= subplot(nSubplotRow, nSubplotCol, n);
        bar(ordChanPerc(1:nChToPlot))
        set(bx(n), 'XTickLabel',ordChan(1:nChToPlot), 'FontWeight', 'bold', 'FontSize', 9, 'XTickLabelRotation', 20)
        if isempty(ordChanPerc(1:nChToPlot))
            maxB(n)=0;
        else
            maxB(n)= max(ordChanPerc(1:nChToPlot));
        end
        xlabel('Channels')
        ylabel('HFO [%]')
        
        tt= title (['Epoch' num2str(n)]);
        ttPos= get(tt,'Position');
        set(tt,'FontWeight', 'bold', 'FontSize', 11, 'Color', 'r', 'Position', ttPos + [0 -ttPos(2)/5 0] )
        box off
        
    else
        bx(n)= subplot(nSubplotRow, nSubplotCol, n);
        tt= title ({['Epoch' num2str(n)]; 'No HFOs detected'});
        ttPos= get(tt,'Position');
        set(tt,'FontWeight', 'bold', 'FontSize', 11, 'Color', 'r', 'Position', ttPos + [0 -ttPos(2)/5 0] )
        box off
        maxB(n)=0;
        
    end
    
end
maxBAbs= max(maxB);

for n=1:nFiles
    set(bx(n), 'YLim', [0 maxBAbs])
end



if nFiles==1
    titleFig1= strfind([filepath fileToAnalyse], 'Split');
    if isempty(titleFig1)
        intTitle= fileToAnalyse;
        TITLE1= intTitle(1:end-4);
    else
        intTitle= [filepath fileToAnalyse];
        TITLE1= intTitle(1:titleFig1-2);
    end
else
    titleFig1= strfind([filepath fileToAnalyse{1,1}], 'Split');
    if isempty(titleFig1)
        intTitle= [filepath fileToAnalyse{1,1}];
        TITLE1= intTitle(1:end-4);
    else
        intTitle= [filepath fileToAnalyse{1,1}];
        TITLE1= intTitle(1:titleFig1-2);
    end
end

suptitle(TITLE1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid= fopen([filepath 'PercRes.txt'], 'w');
C= unique(finalCHAN);
NALL= sum(finalTOTHFO);
TotCh= zeros(length(C),1);

for c=1:length(C)
    chOcc=  cellfun(@strcmp,   {finalCHAN}, C(c,1), 'UniformOutput', 0);
    chOccIdx= find(cell2mat(chOcc)==1);
    TotCh(c)= sum(finalTOTHFO(chOccIdx))/NALL*100;
end

TotChMon= zeros(length(BipMontage{1,1}),1);
for m=1:length(BipMontage{1,1})
    
    chMon=  cellfun(@strcmp,  {C}, {BipMontage{1,1}{m,1}}, 'UniformOutput', 0);
    chMonIdx= find(cell2mat(chMon)==1);
    if isempty(chMonIdx)
        TotChMon(m)= 0;
    else
        TotChMon(m)= TotCh(chMonIdx);
    end
end


normTotChMon= (TotChMon - min(TotChMon)) / ( max(TotChMon) - min(TotChMon));

hh= figure(nFig+2);
set(hh, 'Color', 'w', 'units','normalized','outerposition',[0 0 1 1]);
suptitle(TITLE1)
colormap('hot')
cm= colormap;

fullColor= zeros(length(normTotChMon),3);
for c=1:length(normTotChMon)
    colorID= max(1, sum(normTotChMon(c) > [0:1/length(cm(:,1)):1]));
    fullColor(c,:) = cm(colorID, :);
end


for s= 1:length(SingleMontage{1,1})
    monCh= SingleMontage{1,1}{s,1};
    strLen= length(monCh);
    
    chsetIdxfull= zeros(length(BipMontage{1,1}),1);
    for b =1:length(BipMontage{1,1})
        chsetIdxfull(b)= strncmpi(monCh,BipMontage{1,1}{b,1}, strLen);
        if length(BipMontage{1,1}{b,1}) > strLen
            if strcmp(BipMontage{1,1}{b,1}(strLen+1), char(39))
                chsetIdxfull(b)= 0;
            end
        end
        
    end
    chsetIdx= find(chsetIdxfull==1);
    colorIdx= fullColor(chsetIdx,:);
    
    ax(s)= subplot(length(SingleMontage{1,1}),1, s);
    
    for l= 1: length(chsetIdx)
        if  colorIdx(l,1)==1 && colorIdx(l,2)==1 && colorIdx(l,3)==1
            rectangle('Position',[l-1 0 1 0.5], 'FaceColor', colorIdx(l,:), 'EdgeColor', 'k');
        else
            rectangle('Position',[l-1 0 1 0.5], 'FaceColor', colorIdx(l,:), 'EdgeColor', 'w');
        end
        
        if TotChMon(chsetIdx(l))~=0
            text(l-1+0.3, 0.7, [BipMontage{1,1}{chsetIdx(l),1} '[' sprintf('%4.2f', TotChMon(chsetIdx(l))) '%]'], 'FontWeight', 'bold', 'FontSize', 9);
        else
            text(l-1+0.3, 0.7, BipMontage{1,1}{chsetIdx(l),1}, 'FontWeight', 'bold', 'FontSize', 9);
        end
            
        %text(l-1+0.3, 0.7, BipMontage{1,1}{chsetIdx(l),1} , 'FontWeight', 'bold', 'FontSize', 12);
        hold on
        fprintf(fid, '%s\t %f\r\n', BipMontage{1,1}{chsetIdx(l),1}, TotChMon(chsetIdx(l)));
    end
    ylim([0 1])
    xlim([0 length(chsetIdx)]);
    text(ax(s).XLim(1)-(ax(s).XLim(2)-ax(s).XLim(1))/50, 0.3 , SingleMontage{1,1}{s,1}, 'FontWeight', 'bold', 'FontSize', 12);
    set(ax(s), 'XTick', [], 'YTickLabel', [])
    box off
    axis off
end

cBar= colorbar;
figPos= get(hh, 'Position');

set(cBar, 'Position', [0.95 0.1 0.015 0.8])




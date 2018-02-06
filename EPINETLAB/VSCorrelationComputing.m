%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the correlation between all the MEG virtual
% sensors and estimates the maximum number of channels which could be correlated
% in order to set a threshold for HFOs artefact rejection.

% Author: Lucia Rita Quitadamo, 12/05/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fileToAnalyse, filepath]= uigetfile('*.mat', 'Select VS correlation files',  'MultiSelect', 'on' );

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

CorrMxStore= [];
for i=1:nFiles
    if nFiles==1
       dataFile= [filepath fileToAnalyse];
       filename= fileToAnalyse(1:end-4);
    else
       dataFile= [filepath fileToAnalyse{i}];
       filename= fileToAnalyse{i}(1:end-4);
    end
       dataStruct= load(dataFile);
       CorrMx=  dataStruct.(filename);
       CorrMxStore(:,:,i)= CorrMx;
end

corrThresh= 0.7;
nVS= size(CorrMx,1);
MeanCorrMx= mean(CorrMxStore,3);
MeanCorrMxThresh= MeanCorrMx;
for i=1:nVS
    for j= 1:nVS
        if MeanCorrMx(i,j)< corrThresh
            MeanCorrMxThresh(i,j)= 0;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sslect the longest interval of consecutive channels having correlation
% after thresholding different from zero.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res=0;
seqMx= [];

for i=1:nVS
   vectSearch=  MeanCorrMxThresh(i,:);
   vectSearchOT= find(vectSearch~=0);
   diffVect= diff(vectSearchOT);
   x= [0 cumsum(diffVect~=1)];
   longestSeq= vectSearchOT(x==mode(x));
   res(i)= numel(longestSeq);
   seqMx{i}= longestSeq;
end

[longestInterv, idx]= max(res);
VSidx= [min(seqMx{idx}) max(seqMx{idx})];


Labels= [];
for i=1:size(MeanCorrMx,1)
    if i<10
        Labels{i}= ['VIRT00' num2str(i)];
    elseif i>=10 && i<100
        Labels{i}= ['VIRT0' num2str(i)];
    elseif i>=100
        Labels{i}= ['VIRT' num2str(i)];
    end
end

hh= figure;
set(hh, 'Color', 'w')
imagesc(MeanCorrMxThresh)
title({['Average correlation matrix with threshold on correlation of ' num2str(corrThresh)]; ...
       ['Longest interval of consecutive channels is ' num2str(longestInterv) ': ' Labels{VSidx(1)} '-' Labels{VSidx(2)} ]}, 'FontWeight', 'bold', 'FontSize', 12)
colormap('jet')
set(gca,'XTick', 1:1:size(MeanCorrMxThresh,1), 'XTickLabel',Labels, 'FontWeight', 'bold');   
set(gca,'YTick', 1:1:size(MeanCorrMxThresh,1), 'YTickLabel',Labels, 'FontWeight', 'bold');
xtickangle(45)
colorbar






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unsupervised clustering of CHANNELS. Hopefully two clusters will be
% identifird, channels belonging to Seizure Onset Zone (SOZ) and channels
% channels not belonging to that.
% Unsupervised clustering methods are used as no information is known a
% priori about SOZ.
% Author: Lucia Rita Quitadamo
% Date: 24?01?2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters Setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

fid= fopen([filepath 'ClusteringSOZ.txt'], 'wt');

for ff =1:nFiles
    
    clear  EEG  nWind  timeMx  scalMx  fvect  kurtMx HFOMX HFOCOEFFnoArt
    
    %--------------------------------------
    % Time-Frequency Parameters
    %--------------------------------------
    if nFiles > 1
        fileSet= [filepath fileToAnalyse{1,ff}];
    else
        fileSet= [filepath fileToAnalyse];
    end
    
    EEG= pop_loadset(fileSet);
    SR= ceil(EEG.srate);
    nCh= EEG.nbchan;
    chIdx= 1:nCh;
    chSel1= {EEG.chanlocs.labels};
    chSel= deblank(chSel1);
    inspInterv= [1  EEG.pnts]; % all the interval
    windLen= fix(1* SR);         % 1 sec/ 0.5 sec
    windOver= 0;               % 0 sec
    subWind= 20;
    freqBand= [80 250];        % frequency band
    selWav= 'cmor1-1.5';       % Complex Morlet
    
    fullFeatMx= [];
    KMX= [];
    
    [~, nWind, timeMx, scalMx, fvect, ~, ~] = myWavComput(EEG.data, SR, chIdx, chSel,...
        inspInterv, windLen, windOver, freqBand, selWav);
    
    for c= 1:nCh
        for w= 1:nWind
            coeffMx= scalMx{c,w};
            nWindK= fix((windLen/SR)/(subWind*0.001));
            wK=0;
            
            for r= 1:nWindK
                l= (r-1)* subWind + 1 :  r* subWind;
                wK(r)= mean(mean(coeffMx(:,l)));
            end
            KMX{c,w}= wK;
        end
    end
    
    
    fullFeatMx= cell2mat(KMX) ;
    
    net= selforgmap([1 2]);
    [net,tr]= train(net, fullFeatMx');
    y = net(fullFeatMx');
    classes = vec2ind(y);
    
    class1= length(find(classes == 1));
    class2= length(find(classes == 2));
    
    [~, idxmin] = min([class1 class2]);
    
    SOZidx= find(classes == idxmin);
    
    for i= 1:length(SOZidx)
        SOZ{ff,i}= EEG.chanlocs(SOZidx(i)).labels;
    end
    
    
end

for i= 1:nFiles
    fprintf(fid, '%s %s %s\t %s\r\n', 'Clinical SOZ file', num2str(i), ': ',  SOZ{i,:});
    fprintf(fid, '\n');
end



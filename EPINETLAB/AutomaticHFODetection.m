%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic HFO detection
% Author: Lucia Rita Quitadamo
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


for ff =1:nFiles
    
    clear  EEG  nWind  timeMx  scalMx  fvect  kurtMx HFOMX HFOCOEFFnoArt
    
    %--------------------------------------
    % Time-Frequency Parameters
    %--------------------------------------
    if nFiles > 1
        fileSet= [filepath fileToAnalyse{1,ff}];
        fullFileNameDistr= [filepath  fileToAnalyse{1,ff}(1:end-4) '_Kurtosis.txt'];
        Sfilename=[filepath  fileToAnalyse{1,ff}(1:end-4) '_SCAL.mat'];
        fullNameHFO=[filepath  fileToAnalyse{1,ff}(1:end-4) '_StabaHFO.txt'];
        fullNameHFOCust=[filepath  fileToAnalyse{1,ff}(1:end-4) '_WaveletHFO.txt'];
        fullFileNameChans= [filepath  fileToAnalyse{1,ff}(1:end-4) '_ChansAfterKurtosis.txt'];
    else
        fileSet= [filepath fileToAnalyse];
        fullFileNameDistr= [filepath  fileToAnalyse(1:end-4) '_Kurtosis.txt'];
        Sfilename=[filepath  fileToAnalyse(1:end-4) '_SCAL.mat'];
        fullNameHFO=[filepath  fileToAnalyse(1:end-4) '_StabaHFO.txt'];
        fullNameHFOCust=[filepath  fileToAnalyse(1:end-4) '_WaveletHFO.txt'];
        fullFileNameChans= [filepath  fileToAnalyse(1:end-4) '_ChansAfterKurtosis.txt'];
    end
    
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
    windLen= fix(1* srate);         % 1 sec/ 0.5 sec
    windOver= 0;               % 0 sec
    freqBand= [80 250];        % frequency band
    selWav= 'cmor1-1.5';       % Complex Morlet

    
    [~, nWind, timeMx, scalMx, fvect, ~, kurtMx] = myWavComput(EEG.data, srate, chIdx, chSel,...
        inspInterv, windLen, windOver, freqBand, selWav);
    
    
    %save(Sfilename, 'scalMx', '-v7.3');
    
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
            %stdK(i,w)= std(kurtInt) ;   % std value over all the frequencies
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
        F(1).name= 'N.A.';
        F(1).par= 0;
        kurtThresh= 15;
        m= 0;
        v= 0; 
        warning('Kurtosis threshold fixed to 15')
     end
    
    fidkDistr= fopen(fullFileNameDistr, 'wt');
    fprintf(fidkDistr, '%s\t%20s\t%s\t%s\t%s\r\n', 'Distribution', 'Parameters          ', 'Mean', 'Variance', 'K threshold' );
    fprintf(fidkDistr, '%s\t%s\t%f\t%f\t%d\r\n', F(1).name, num2str(F(1).par), m, v, kurtThresh );
    
    freqInt= 20;              % 20 frequancies should have a kurtosis > of the threshold
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
    
    nChKurt= fix(nCh/3); 
    if ~isnan(IQR)
        threshNew= Q2+(Q3-Q2)/2; %TO TAKE INTO ACCOUNT POSITIVE SKEWNESS
        overThresh= find(critWindOrd > threshNew);
        IDX= idxORD(overThresh);
    else
             % take 1/3 of the channels satisfying the requirement
        IDX= idxORD(1:nChKurt);
    end
    
    newCh= {chSel{1,IDX}};
    newnCh= length(newCh);
    saveMX= [critWindOrd'; idxORD'];

    fidkChans= fopen(fullFileNameChans,'wt');
    fprintf(fidkChans, '%s\t %s\r\n', 'CritWindOrd', 'idxORD');
    fprintf(fidkChans, '%d\t %d\r\n', saveMX );
    fprintf(fidkChans, '%s\t %s\t %s\t %s\t %s\r\n', 'Q1', 'Q2', 'Q3', 'IQR', 'nCHKurt' );
    fprintf(fidkChans, '%f\t %f\t %f\t %f\t  %f\r\n', Q1, Q2, Q3, IQR,  newnCh );
    fclose(fidkChans);
    
%     %--------------------------------------
%     % Staba-based HFO Detection Parameters
%     %--------------------------------------
%     
    RMSWind= 3;                     % 3 sec
    SDThresh= 5;                    % 5 Standard deviations
    RMSDuration= 6;                 % 6 sec
    nPeaks = 6;                     % 6 peaks
    RectThresh= 3;                  % 3 Standard deviations for the rectified EEG signal
    
    
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
    
    
    %--------------------------------------
    % Custom-Based HFO Detection Parameters
    %--------------------------------------
    
    ARTREM1= 1;                 % Artefact removal based on channels criteria
    ARTREM2= 1;                 % Artefact removal based on power distribution criteria
    KWind= 3;                   % 3 msec
    KSDThresh= 5;               % 5 Standard deviations
    KDuration= 20;              % 20 msec for ripple and 10ms for fast ripples
    WindowsIdx= 1:nWind;        % all the windows
    nChArt= 3;
    
    HFOCOEFFnoArt= MyHFODetection(ARTREM1, nChArt, ARTREM2, scalMx, IDX,newCh, windLen, windOver, nWind,srate,inspInterv, KWind, KSDThresh, KDuration, WindowsIdx);
    
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
    
end






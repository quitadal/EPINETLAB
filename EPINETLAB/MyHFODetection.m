function HFOCOEFFnoArt= MyHFODetection(ARTREM1,nChArt, ARTREM2, scalMx, chDet, chListDet,windLen, windOver, nWind, SR, inspInterv, KWind, KSDThresh, KDuration, WindowsIdx)

if nargin==2
    scalMx= evalin('base', 'scalMx');
    chDet= evalin('base', 'chDet');
    chListDet= evalin('base', 'chListDet');
    
    KWind= evalin('base', 'KWind');
    KSDThresh= evalin('base', 'KSDThresh');
    KDuration= evalin('base','KDuration');
    
    windLen= evalin('base', 'windLen');
    windOver=  evalin('base', 'windOver');
    nWind= evalin('base', 'nWind');
    SR= evalin('base', 'EEG.srate');
    inspInterv= evalin('base', 'inspInterv');
    WindowsIdx= evalin('base', 'WindowsIdx');
end

disp('Processing candidate HFOs...')

timeInterval= [inspInterv(1)/SR:1/SR:inspInterv(2)/SR];
nCh= length(chDet);
scalMxNew= scalMx(chDet,:);


if windOver ==0
    windOver = windLen;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KWindLen= fix(KWind*0.001*SR);

for c = 1:nCh
    for w = 1:nWind
        coeffMx= scalMxNew{c,w};
        nWindK= fix((windLen/SR)/(KWind*0.001));
        wK=0;
        for r= 1:nWindK
            l= (r-1)* KWindLen + 1 :  r* KWindLen;
            wK(r)= mean(mean(coeffMx(:,l)));
        end
        KMX{c,w}= wK;
    end
end

KMX2= horzcat(KMX{:});
meanK= mean(KMX2);
SDK= std(KMX2);

allThreshK= meanK + KSDThresh*SDK;
KOvThreshK= ones(1, length(KMX2));

KOvThreshIdx= find(KMX2 > allThreshK);

KOvThreshK(KOvThreshIdx)= 0;
KOvThresh2= reshape(KOvThreshK, nWindK*nCh, []);


nKcons= round(KDuration/KWind);
for w=1:nWind
    for c=1:nCh
        THMXintK= [KOvThresh2((c-1)*nWindK + 1: c*nWindK, w)]';
        
        tK = diff([false;THMXintK'==0;false]);
        pK = find(tK==1);
        qK = find(tK==-1);
        candHFOK = qK-pK;
        
        if isempty(candHFOK)~=1
            satHFOK= find(candHFOK >= nKcons);
            firstK= pK(satHFOK);
            secondK= qK(satHFOK)-1;
            candSamplMXK{c,w}= [firstK secondK];
        else
            candSamplMXK{c,w}=[];
        end
        
        THMXK{c,w}= THMXintK;
    end
end


HFOCOEFF=cell(nCh,nWind);


for c=1:nCh
    
    if iscell(WindowsIdx)
        W=str2num(WindowsIdx{c});
    else
        W= WindowsIdx;
    end
    
    for w=1:nWind
        
        if ismember(w,W)
            
            if isempty(candSamplMXK{c,w})~=1
                nCand2= size(candSamplMXK{c,w},1);
                candMX2=  candSamplMXK{c,w};
                
                % collapse events closer than 10sec
                lenForCollapse2= fix(10*0.001*SR);
                
                startSampl2= fix((candMX2(:,1)-1)*KWindLen);
                endSampl2=  fix(candMX2(:,2)*KWindLen);
                
                if any(startSampl2==0)
                    startSampl2(find(startSampl2==0))=1;
                end
                
                if nCand2 > 1
                    
                    for n= 1:nCand2-1
                        
                        if (startSampl2(n+1)-endSampl2(n))<= lenForCollapse2
                            startSampl2(n+1)=startSampl2(n);
                            endSampl2(n+1)= endSampl2(n+1);
                            startSampl2(n)=0;
                            endSampl2(n)=0;
                        end
                    end
                end
                
                if length(startSampl2)~= length(endSampl2)
                    warning('Different dimensions for samples vectors!!')
                end
                
                startSampl2(find(startSampl2==0))=[];
                endSampl2(find(endSampl2==0))=[];
                nCand2= length(startSampl2);
                
                for nn= 1:nCand2
                    HFOCOEFF{c,w}= [HFOCOEFF{c,w}; [startSampl2(nn) endSampl2(nn)]];
                end
            else
                HFOCOEFF{c,w}= [];
            end
            
            
        end
        str2displ = sprintf('%s%s%s%s%s%s%s%s',    '.........Custom Method: Computing candidate HFOs for channel ' , chListDet{c},...
            '  for window  ', num2str(timeInterval(1)+ ((w-1)* windOver +1)/SR), 's to ',...
            num2str(timeInterval(1)+ ((w-1)* windOver + windLen)/SR), 's .........')  ;
        disp(str2displ)
    end
end

%assignin('base', 'HFOCOEFF', HFOCOEFF)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Apply Artefact removal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%nChArt= 3;

if ARTREM1 == 1  && ARTREM2 == 0
    HFOCOEFFnoArt1= HFOCOEFF;
    disp('Applying Artifact removal 1...')
    
    for i=1:nWind
        candArtCOEFF= find(~cellfun(@isempty,HFOCOEFFnoArt1(:,i)));
        nCandArtCOEFF= length(candArtCOEFF);
        stSmplCOEFF= [];
        if nCandArtCOEFF >= nChArt
            
            for j= 1: nCandArtCOEFF
                intMxCOEFF= HFOCOEFFnoArt1{candArtCOEFF(j),i};
                
                [nn,~]= size(intMxCOEFF);
                for n=1:nn
                    stSmplCOEFF{j,n}= intMxCOEFF(n,1);
                end
            end
            stSmpl2COEFF= stSmplCOEFF(~cellfun('isempty',stSmplCOEFF)) ;
            stSmplMxCOEFF= cell2mat(stSmpl2COEFF);
            stSmplVCOEFF= reshape(stSmplMxCOEFF, 1, []);
            stSmplVCOEFF= sort(stSmplVCOEFF);
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Collapse all the events starting samples differing for
            % 10ms (ritardo di propagazione)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            del= round(SR*0.010);
            
            for c= 1:length(stSmplVCOEFF)-1
                if stSmplVCOEFF(c+1)<= (stSmplVCOEFF(c) + del)
                    stSmplVCOEFF(c+1)= stSmplVCOEFF(c);
                end
            end
            
            occVectCOEFF= unique(stSmplVCOEFF);
            
            
            ll=0;
            for uu=1:length(occVectCOEFF)
                ll(uu)= length(find(stSmplVCOEFF==occVectCOEFF(uu)));
            end
            
            
            ArtStSampCOEFF= find(ll > 2);
            
            for a= 1:length(ArtStSampCOEFF)
                for j= 1: nCandArtCOEFF
                    
                    intMxCOEFF= [];
                    intMxCOEFF= HFOCOEFFnoArt1{candArtCOEFF(j),i};
                    [nn,~]= size(intMxCOEFF);
                    
                    for n= 1:nn
                        if intMxCOEFF(n,1) <= (occVectCOEFF(ArtStSampCOEFF(a))+ del)
                            HFOCOEFFnoArt1{candArtCOEFF(j),i}(n,:)= [0 0];
                        end
                    end
                    
                    HFOCOEFFnoArt1{candArtCOEFF(j),i}(all(HFOCOEFFnoArt1{candArtCOEFF(j),i}== 0,2),:)=[];
                end
                
            end
            
        end
    end
    
    if nargout == 0
        assignin('base', 'HFOCOEFFnoArt', HFOCOEFFnoArt1 )
        displ('Done')
    else
        HFOCOEFFnoArt= HFOCOEFFnoArt1;
    end
    
    
elseif  ARTREM1 == 0  && ARTREM2 == 1
    HFOCOEFFnoArt2= HFOCOEFF;
    disp('Applying Artifact removal 2...')
    
    for i=1:nWind
        for j=1:nCh
            candArtCOEFF= HFOCOEFFnoArt2{j,i};
            
            if isempty(candArtCOEFF) == 0
                [nCandArtCOEFF, ~]= size(candArtCOEFF);
                candScal= scalMx{j,i};
                
                
                for n= 1:nCandArtCOEFF
                    t= candArtCOEFF(n,:);
                    coeffF= mean(candScal(:, t(1):t(2)),2);
                    if isnan(coeffF)
                           HFOCOEFFnoArt2{j,i}(all(HFOCOEFFnoArt2{j,i}== 0,2),:)=[];
                    else
                        F= fitmethisRED(double(coeffF), 'figure', 'off', 'output', 'off');
                        
                        % gp= generalized Pareto
                        % gev= generalized extreme value
                        % usually powers in an HFO are distributed as
                        % 'nakagami' or 'birnbaumsaunders'
                        
                        
                        if strcmp(F(1).name, 'normal') || strcmp(F(1).name, 'gp')|| strcmp(F(1).name, 'gev')
                            HFOCOEFFnoArtGEN2{j,i}(n,:)= [0 0];
                        end
                    end
                end
                HFOCOEFFnoArt2{j,i}(all(HFOCOEFFnoArt2{j,i}== 0,2),:)=[];
            end
            
        end
    end
    
    if nargout == 0
        assignin('base', 'HFOCOEFFnoArt', HFOCOEFFnoArt2 )
        disp('Done')
    else
        HFOCOEFFnoArt= HFOCOEFFnoArt2;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % ART1 ART2
    %%%%%%%%%%%%%%%%%%%%%%
    
    
elseif   ARTREM1 == 1  && ARTREM2 == 1
    disp('Applying both Artifact removal procedures...')
    
    HFOCOEFFnoArtGEN= HFOCOEFF;
    
    for i=1:nWind
        candArtCOEFF= find(~cellfun(@isempty,HFOCOEFFnoArtGEN(:,i)));
        nCandArtCOEFF= length(candArtCOEFF);
        stSmplCOEFF= [];
        if nCandArtCOEFF >= nChArt
            
            for j= 1: nCandArtCOEFF
                intMxCOEFF= HFOCOEFFnoArtGEN{candArtCOEFF(j),i};
                
                [nn,~]= size(intMxCOEFF);
                for n=1:nn
                    stSmplCOEFF{j,n}= intMxCOEFF(n,1);
                end
            end
            stSmpl2COEFF= stSmplCOEFF(~cellfun('isempty',stSmplCOEFF)) ;
            stSmplMxCOEFF= cell2mat(stSmpl2COEFF);
            stSmplVCOEFF= reshape(stSmplMxCOEFF, 1, []);
            stSmplVCOEFF= sort(stSmplVCOEFF);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Collapse all the events starting samples differing for
            % 10ms (ritardo di propagazione)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            del= round(SR*0.010);
            
            for c= 1:length(stSmplVCOEFF)-1
                if stSmplVCOEFF(c+1)<= (stSmplVCOEFF(c) + del)
                    stSmplVCOEFF(c+1)= stSmplVCOEFF(c);
                end
            end
            
            occVectCOEFF= unique(stSmplVCOEFF);
            
            
            ll=0;
            for uu=1:length(occVectCOEFF)
                ll(uu)= length(find(stSmplVCOEFF==occVectCOEFF(uu)));
            end
            
            
            ArtStSampCOEFF= find(ll > 2);
            
            for a= 1:length(ArtStSampCOEFF)
                for j= 1: nCandArtCOEFF
                    
                    intMxCOEFF= [];
                    intMxCOEFF= HFOCOEFFnoArtGEN{candArtCOEFF(j),i};
                    [nn,~]= size(intMxCOEFF);
                    
                    for n= 1:nn
                        if intMxCOEFF(n,1) <= (occVectCOEFF(ArtStSampCOEFF(a))+ del)
                            HFOCOEFFnoArtGEN{candArtCOEFF(j),i}(n,:)= [0 0];
                        end
                    end
                    
                    HFOCOEFFnoArtGEN{candArtCOEFF(j),i}(all(HFOCOEFFnoArtGEN{candArtCOEFF(j),i}== 0,2),:)=[];
                end
                
            end
            
        end
    end
    
    HFOCOEFFnoArtGEN2= HFOCOEFFnoArtGEN;
    
    for i=1:nWind
        for j=1:nCh
           
            candArtCOEFF= HFOCOEFFnoArtGEN2{j,i};
            
            if isempty(candArtCOEFF) == 0
                [nCandArtCOEFF, ~]= size(candArtCOEFF);
                candScal= scalMx{j,i};
                
                
                for n= 1:nCandArtCOEFF
                    t= candArtCOEFF(n,:);
                    coeffF= mean(candScal(:, t(1):t(2)),2);
                    if isnan(coeffF)
                        HFOCOEFFnoArtGEN2{j,i}(n,:)= [0 0];
                    else
                        F= fitmethisRED(double(coeffF), 'figure', 'off', 'output', 'off');
                    
                        if strcmp(F(1).name, 'normal') || strcmp(F(1).name, 'gp')|| strcmp(F(1).name, 'gev') % if the power is normally distributed over frequencies, probably it is not an HFO
                            HFOCOEFFnoArtGEN2{j,i}(n,:)= [0 0];
                        end
                    
                    end
                end
                HFOCOEFFnoArtGEN2{j,i}(all(HFOCOEFFnoArtGEN2{j,i}== 0,2),:)=[];
            end
            
        end
    end
    
    if nargout == 0
        assignin('base', 'HFOCOEFFnoArt', HFOCOEFFnoArtGEN2 )
        disp('Done')
    else
        HFOCOEFFnoArt= HFOCOEFFnoArtGEN2;
    end
    
    
elseif  ARTREM1 == 0  && ARTREM2 == 0
    
    warning('No artefact removal option selected!!')
    
    if nargout == 0
        assignin('base', 'HFOCOEFFnoArt', HFOCOEFF )
        disp('Done')
    else
        HFOCOEFFnoArt=  HFOCOEFF;
    end
    
end




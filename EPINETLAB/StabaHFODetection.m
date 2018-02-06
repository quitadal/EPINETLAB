function HFOMX= StabaHFODetection(EEG, chDet, chListDet,  RMSDuration, RMSWind, SDThresh, nPeaks, RectThresh, windLen, windOver, nWind, SR, inspInterv)

% if nargin == 0
%     EEG= evalin('base', 'dataNew');
%     chDet= evalin('base', 'chDet');
%     chListDet= evalin('base', 'chListDet');
%     RMSDuration= evalin('base','RMSDuration');
%     RMSWind= evalin('base', 'RMSWind');
%     SDThresh= evalin('base', 'SDThresh');
%     nPeaks= evalin('base', 'nPeaks');
%     RectThresh= evalin('base', 'RectThresh');
% 
%     windLen= evalin('base', 'windLen');
%     windOver=  evalin('base', 'windOver');
%     nWind= evalin('base', 'nWind');
%     SR= evalin('base', 'EEG.srate');
%     inspInterv= evalin('base', 'inspInterv');
% end

disp('Processing candidate HFOs...')
timeInterval= inspInterv(1)/SR:1/SR:inspInterv(2)/SR;
nCh= length(chDet);

if ~isstruct(EEG)
    EEGNew= EEG(chDet,:);
else
    EEGNew= EEG.data(chDet,:);
end
    

RMSWindLen= fix(RMSWind*0.001*SR);


if windOver ==0
    windOver = windLen;
end

for c = 1:nCh
    x=0;
    t=0;
    for w = 1:nWind
        t= windOver*(w-1)+1 :  windOver*(w-1)+ windLen;
        x= EEGNew(c, t);
        
        nWindRMS= fix((length(t)/SR)/(RMSWind*0.001));
        wRMS=0;
        
        for r= 1:nWindRMS
            l= (r-1)* RMSWindLen + 1 :  r* RMSWindLen;
            wRMS(r)= rms(x(l));
        end
        RMSMX{c,w}= wRMS;
        
        
    end
end

RMSMX2= horzcat(RMSMX{:});
meanRMS= mean(RMSMX2);
SDRMS= std(RMSMX2);

allThresh= meanRMS + SDThresh*SDRMS;
rmsOvThresh= ones(1, length(RMSMX2));

rmsOvThreshIdx= find(RMSMX2 > allThresh);

rmsOvThresh(rmsOvThreshIdx)= 0;
rmsOvThresh2= reshape(rmsOvThresh, nWindRMS*nCh, []);


nRMScons= round(RMSDuration/RMSWind);
for w=1:nWind
    for c=1:nCh
        THMXint= [rmsOvThresh2((c-1)*nWindRMS + 1: c*nWindRMS, w)]';
        
        t = diff([false;THMXint'==0;false]);
        p = find(t==1);
        q = find(t==-1);
        candHFO = q-p;
        
        if isempty(candHFO)~=1
            satHFO= find(candHFO >= nRMScons);
            first= p(satHFO);
            second= q(satHFO)-1;
            candSamplMX{c,w}= [first second];
        else
            candSamplMX{c,w}=[];
        end
        
        THMX{c,w}= THMXint;
        
    end
end


EEGrect= abs(EEGNew);
meanEEG= mean(EEGrect,2);
stdEEG= std(EEGrect,0, 2);

EEGThresh= meanEEG + RectThresh*stdEEG;
HFO=cell(nCh,nWind);
for c=1:nCh
    for w=1:nWind
        
        if isempty(candSamplMX{c,w})~=1
            t= windOver*(w-1)+1 :  windOver*(w-1)+ windLen;
            xrect= EEGrect(c, t);
            nCand= size(candSamplMX{c,w},1);
            candMX=  candSamplMX{c,w};
            
            % collapse events closer than 10sec
            lenForCollapse= fix(10*0.001*SR);
            
            startSampl= fix((candMX(:,1)-1)*RMSWindLen);
            endSampl=  fix(candMX(:,2)*RMSWindLen);
            
            if any(startSampl==0)
                startSampl(find(startSampl==0))=1;
            end
            
            if nCand > 1
                
                for n= 1:nCand-1
                    
                    if (startSampl(n+1)-endSampl(n))<= lenForCollapse
                        startSampl(n+1)=startSampl(n);
                        endSampl(n+1)= endSampl(n+1);
                        startSampl(n)=0;
                        endSampl(n)=0;
                    end
                end
            end
            
            if length(startSampl)~= length(endSampl)
                warning('Different dimensions for samples vectors!!')
            end
            
            startSampl(find(startSampl==0))=[];
            endSampl(find(endSampl==0))=[];
            nCand= length(startSampl);
            
            for nn= 1:nCand
                signCand= xrect(startSampl(nn):endSampl(nn));
                
                if length(signCand)<3
                    continue
                else
                    [pks,locs] = findpeaks(double(signCand)) ;
                
                    candPeakes= find(pks>=EEGThresh(c));
                
                    if length(candPeakes)>=nPeaks
                     HFO{c,w}= [HFO{c,w}; [startSampl(nn) endSampl(nn)]];
                    end
                end
            end
        end
        
        str2displ = sprintf('%s%s%s%s%s%s%s%s',    '.........Staba Method: Computing candidate HFOs for channel ' , chListDet{c},...
            '  for window  ', num2str(timeInterval(1)+ ((w-1)* windOver +1)/SR), 's to ',...
            num2str(timeInterval(1)+ ((w-1)* windOver + windLen)/SR), 's .........')  ;
        disp(str2displ)
        
    end
end

if nargout == 0
    assignin('base', 'HFOMX', HFO)
else
    HFOMX= HFO;
end
















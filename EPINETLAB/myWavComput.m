function [dataNew, nWind, timeMx, scalMx, fvect, Scales, kurtMx] = myWavComput(dataMx, SR, chIdx, chSel, inspInterv, windLen, windOver, freqBand, selWav)

% if nargin == 0
%     dataMx=     evalin('base', 'EEG.data');
%     SR=         evalin('base', 'EEG.srate');
%     intDur=     evalin('base', 'EEG.pnts');
%     
%     gui1 = findobj('Tag','GUI1');
%     g1data = guidata(gui1);
%     windLenMS= str2double(get(g1data.edit2, 'String'));
%     windLen= ceil(windLenMS*SR);
%     windOverMS= str2double(get(g1data.edit3, 'String'));
%     windOver= ceil(windOverMS*SR);
%     inspInterv1= get(g1data.edit4, 'String');
%     
%     if strcmp(inspInterv1,'all')
%         inspIntervLim1= 1;
%         inspIntervLim2= intDur;
%     else
%         intInter= str2num(inspInterv1);
%         inspIntervLim1 = ceil(SR* intInter(1)) +1;
%         inspIntervLim2 = ceil(SR* intInter(2));
%     end
% 
%     inspInterv= [inspIntervLim1 inspIntervLim2 ];
%     chIdx= get(g1data.listbox1,'Value');
%     chList= get(g1data.listbox1, 'String');
% 
%     for i= 1:length(chIdx)
%         chSel{1,i}= chList{chIdx(i),1};
%     end
%     freqBand= str2num(get(g1data.edit5, 'String'));  
%     selWav=     evalin('base', 'selWav');
%     
% else
if nargin < 9
    error('Wrong number of input to myWavComput');
end

timeInterval= inspInterv(1)/SR:1/SR:inspInterv(2)/SR;
dataMx2= dataMx(chIdx, inspInterv(1):inspInterv(2)); %select proper channels and proper interval
nCh= length(chIdx);

intSmpl= length(inspInterv(1):inspInterv(2));

if windOver ==0
    nWind= fix(intSmpl/windLen);
    windOver = windLen;
else
    nWind= floor(intSmpl/windOver-windLen/windOver +1) ;
end 

maxS= 0;
minS= 0;

timeMx= zeros(nWind,2);
resMx=  cell(nCh, nWind);
kurtMx= cell(nCh, nWind);

for c = 1:nCh
   for w = 1:nWind
       t= windOver*(w-1)+1 :  windOver*(w-1)+ windLen;
       x= dataMx2(c, t);
       [coefMx, S, fvect, Scales] = simple_cwt(x, SR, selWav, freqBand);
       kurtMx{c,w}= kurtosis(S');
       
       maxSNew= max(max(S));
       minSNew= min(min(S));
       if maxSNew > maxS
           maxS= maxSNew ;
       end
       
       if minSNew < minS
           minS= minSNew ;
       end
              
       if nCh == 1
           displCh= cellstr(deblank(chSel));
       else
           displCh{c}= deblank(chSel{1,c});
       end
       
        str2displ = sprintf('%s%s%s%s%s%s%s%s%s',    '.............Computing wavelet ',  selWav , ' for channel ' , displCh{c},...
                     '  for window  ', num2str(timeInterval(1)+ ((w-1)* windOver +1)/SR), 's to ',...
                     num2str(timeInterval(1)+ ((w-1)* windOver + windLen)/SR), 's .............')  ;
        disp(str2displ)
        
        timeMx(w,:)= [timeInterval(1)+ ((w-1)* windOver +1)/SR  timeInterval(1)+ ((w-1)* windOver + windLen)/SR]; 
        resMx{c,w,:}= single(S);
        
   end
end

disp('Wavelet Transforms computed')

if nargout == 0
    assignin('base', 'dataNew', dataMx2)
    assignin ('base', 'nWind', nWind)
    assignin ('base', 'timeMx', timeMx)
    assignin('base', 'scalMx', resMx)
    %assignin('base','coeffMx',coefMx)
    assignin('base', 'fvect', fvect)
    assignin('base', 'Scales', Scales)
    assignin('base', 'kurtMx', kurtMx)
    assignin('base', 'colorRangeMax', maxS)
    assignin('base', 'colorRangeMin', minS)
else
    dataNew=  dataMx2;
    scalMx=  resMx;
end
    


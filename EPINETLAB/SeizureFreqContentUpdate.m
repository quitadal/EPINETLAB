function  SeizureFreqContentUpdate(h1, h5, h4, colorMap, sensFact2,  fCentr, fWide, windLen, w, chanToAmpl, AmplVal, timeRes)

SR= evalin('base', 'EEG.srate');
scalMx= evalin('base', 'scalMx');
fvect= evalin('base', 'fvect');
eegMx= evalin('base', 'dataNew');
timeMx= evalin('base', 'timeMx');
CHANLOCS= evalin('base', 'EEG.chanlocs');
colorRangeMax= evalin('base', 'colorRangeMax');
colorRangeMin= evalin('base', 'colorRangeMin');

[nCh, nPnt]= size(eegMx);
minScale= floor(min(min(eegMx)));
maxScale= ceil(max(max(eegMx)));
rangeLim= max(abs(minScale), abs(maxScale));

possVal= 1:1:199;
if ismember(sensFact2, possVal)
    if sensFact2 < 100
        sensFact2 = -(100- sensFact2)-1;
    else
        sensFact2 =  (sensFact2-100) + 1;
    end
else
    tmp= abs(possVal-sensFact2);
    [~, idx]= min(tmp);
    sensFact2= possVal(idx);
    if sensFact2 < 100
        sensFact2 = -(100- sensFact2)-1;
    else
        sensFact2 =  (sensFact2-100) + 1;
    end
end

if sensFact2 < 0
    sensFact2= 1/abs(sensFact2);
end

gui1 = findobj('Name','SeizureFrequencyContent');
g1data = guidata(gui1);
if isempty(gui1)
    warndlg('You closed Time-Frequency GUI', 'Time-Frequancy Display');
    return
end
chVal=get(g1data.listbox1, 'Value');
chLabels= {CHANLOCS(chVal).labels};

ax1= findobj(h1, 'Type', 'Axes');
if isempty(ax1)~=1
    delete(ax1)
end

ax1= axes('Parent', h1);

XTickLabels= [];
set(ax1, 'XTick', [], 'XTickLabels',XTickLabels,'YTick', [], 'YTickLabels', [])
tint= [];
if windLen ~= nPnt
    nPnt= windLen;
    tstart= timeMx(1)+ [(w-1)*windLen/SR] ;
    tend= timeMx(1)+ [w* windLen/SR];
    
    if floor((tend-tstart)/2) < 1
        nSec= 1;
    else
        nSec= 2;
    end
    for i=1:floor((tend-tstart)/2) 
        tint(i)=  tstart+ nSec*i;
    end
    
    XTickLabels= [tstart tint tend];
    
else
    if floor((timeMx(2)-timeMx(1))/2) < 1
        nSec=1;
    else
        nSec=2;
    end
    
    for i=1:floor((timeMx(2)-timeMx(1))/2)
        tint(i)= timeMx(1) + nSec*i;
    end
    XTickLabels= [timeMx(1) tint timeMx(2)];
end

XTick= [0: nSec*SR  : nPnt];

XLim= [0, nPnt];
YLim= [0 rangeLim*nCh];
YTick= rangeLim/2:rangeLim:rangeLim*(nCh-1)+rangeLim/2;
set(ax1, 'XLim', XLim, 'YLim', YLim)

eegToplot= flip(eegMx);
xs= (w-1)*windLen + 1 : w* windLen;
for i=1:nCh
    if (w* windLen)<= size(eegToplot, 2)
        plot(ax1, 1:nPnt, [eegToplot(i,xs)+ YTick(i)], 'b')
        hold on
    else
        nZer= (w* windLen)- size(eegToplot, 2);
        eegToplotNew= [eegToplot(i,:)  zeros(1, nZer)]; 
        plot(ax1, [1:nPnt], [eegToplotNew(xs)+ YTick(i)], 'b')
        hold on
    end
end
set(ax1, 'XLim', XLim, 'YLim', YLim)
set(ax1, 'XTick', [], 'XTickLabels',[],'YTick', [], 'YTickLabels', [])
set(ax1,  'XTick', XTick, 'XTickLabels', round(XTickLabels,1), 'YTick',YTick, 'YTickLabels', flip(chLabels), 'FontSize', 8, 'FontWeight', 'bold')
box off

fLimL= floor(fvect(end));
fLimH= floor(fvect(1));
lowInt= fCentr-fWide;
if lowInt <fLimL
    lowInt= fLimL;
end
highInt= fCentr+fWide;
if highInt>fLimH
    highInt= fLimH;
end

 [~,idx1]= min(abs(fvect'-ones(length(fvect),1)*lowInt));
 [~,idx2]= min(abs(fvect'-ones(length(fvect),1)*highInt));

if size(eegMx,2) == size(scalMx{1,1},2)
    nZerAdd = [];
else
    nZer= size(eegMx,2)-size(scalMx{1,1},2);
    nZerAdd= zeros(nZer,1); % this is done if wavelet window is smaller than the original one
end   
for c= 1:nCh
    currScalTime= scalMx{c};
    currentScalF= currScalTime(idx2:idx1,:);
    currScalInt= sum(currentScalF,1);
    scalMx2(c,:)=  [nZerAdd currScalInt]; % check
end

if timeRes == 50
    Res= SR;
else
    Res= timeRes;
end

nCS= fix(SR/Res);
nTot= floor(size(eegMx,2)/nCS);
newMx= zeros(nCh, nTot);

for i= 1:nTot
    finSmp= nCS*i;
    if finSmp <= size(scalMx2,2)
        newMx(:,i) = mean(scalMx2(:, nCS*(i-1)+ 1 : finSmp),2);
    else
        newMx(:,i) = mean(scalMx2(:, nCS*(i-1)+ 1 : nPnt),2);
    end
end

newStep= floor(windLen/nCS);
xsNew= (w-1)*newStep +1 : w*newStep;

if xsNew(end) > size(newMx,2)
    nZer= xsNew(end)  - size(newMx,2);
    lastCol= newMx(:,end);
    AddMx= repmat(lastCol, 1, nZer);    
    %zeroAdd= zeros(nCh, nZer);
    %newMxPlot= [newMx  zeroAdd];
    newMxPlot= [newMx  AddMx];
else
    newMxPlot= newMx;
end

if ~isempty(chanToAmpl)
    newMxPlot(chanToAmpl,:)= newMxPlot(chanToAmpl,:).* AmplVal;    
    for i=1:length(chanToAmpl)
       chLabels{chanToAmpl(i)}= ['^*^*' chLabels{chanToAmpl(i)}] ;
    end
end

imagesc(h5, 0:newStep, 1:nCh, newMxPlot(:,xsNew));

if strcmp(colorMap, 'custom')
   cc = makeColorMap([0 0 1], [1 1 1], 1000);
else
   cc= colorMap;
end
colormap(h5, cc);


XTick2= [0: nSec* Res  : newStep];
XLim2= [0, newStep];

set(h5, 'XLim', XLim2, 'XTick', XTick2, 'XTickLabels', round(XTickLabels,1), 'YTick', 1:nCh,'YTickLabels', chLabels, 'FontSize', 8, 'FontWeight', 'bold' )
caxis(h5, [colorRangeMin/sensFact2  colorRangeMax/sensFact2])


cb= colorbar;
cbP= get(cb, 'Position');
set(cb, 'Position', [cbP(1)+0.04 cbP(2) cbP(3) cbP(4)/3])










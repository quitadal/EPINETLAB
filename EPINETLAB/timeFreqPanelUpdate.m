function [sensFact, sensFact2] = timeFreqPanelUpdate(w,chGroup, group, h1, h2, sensFact,sensFact2, colorMAP)

SR= evalin('base', 'EEG.srate');
scalMx= evalin('base', 'scalMx');
fvect= evalin('base', 'fvect');
eegMx= evalin('base', 'dataNew');
timeMx= evalin('base', 'timeMx');

gui1 = findobj('Tag','GUI1');
if isempty(gui1)
    warndlg('You closed Time-Frequency GUI', 'Time-Frequancy Display');
    return
end
g1data = guidata(gui1);
RB2= get(g1data.radiobutton2, 'Value');
RB3= get(g1data.radiobutton3, 'Value');
RB4= get(g1data.radiobutton4, 'Value');

if RB2 == 1
    measUnit= '\muV';
elseif RB3 == 1
    measUnit= 'fT';
elseif RB4 == 1
    measUnit= 'nAm';
end

diplayDecimation= str2num(get(g1data.edit9, 'String'));

windLenMS= str2double(get(g1data.edit2, 'String'));
windLen= ceil(windLenMS*SR);
windOverMS= str2double(get(g1data.edit3, 'String'));
windOver= ceil(windOverMS*SR);

chIdx= get(g1data.listbox1,'Value');
if isempty(chIdx)
    warndlg('Please select channels','!! Warning !!')
    return
end
chList= get(g1data.listbox1, 'String');

for i= 1:length(chIdx)
    chSel{1,i}= chList{chIdx(i),1};
end

eegChans= chSel;
nCh= length(eegChans);

colorRangeMax= evalin('base', 'colorRangeMax');
colorRangeMin= evalin('base', 'colorRangeMin');

if windOver==0
    windOver= windLen;
end

eegValMax= max(max(eegMx));
eegValMin= min(min(eegMx));

possVal= 1:1:199;
if ismember(sensFact, possVal)
    if sensFact < 100
        sensFact = -(100- sensFact)-1;
    else
        sensFact =  (sensFact-100) + 1;
    end
    
else
    tmp= abs(possVal-sensFact);
    [~, idx]= min(tmp);
    sensFact= possVal(idx);
    if sensFact < 100
        sensFact = -(100- sensFact)-1;
    else
        sensFact =  (sensFact-100) + 1;
    end
end

if sensFact < 0
    sensFact= 1/abs(sensFact);
end


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

if chGroup == nCh
    group = 1;
else
    nCh= chGroup;
end

w= round(w);

AX1= findobj(h1, 'Type', 'axes');
delete(AX1)
for i= 1:nCh
    ax1(i)= subplot(nCh,1,i,'Parent',h1);
    xt= timeMx(w,1):1/SR:timeMx(w,2);
    xs= windOver*(w-1)+1 :  windOver*(w-1)+ windLen;
    y= eegMx(i+group-1,xs);
    
    if diplayDecimation ~= 1
        xt= xt(1:diplayDecimation:end);
        y=  y(1:diplayDecimation:end);
    end
    plot(xt, y)
    xlim([xt(1) xt(end)])
    ylim([eegValMin/sensFact eegValMax/sensFact])
    yy= ylabel(['Ampl. [ ' measUnit ' ]']);
    yyCoord= get(yy, 'Position');
    
    chanLabel= eegChans{i+group-1};
    if length(chanLabel) > 4
        ytext= text(xt(1)-(xt(end)-xt(1))/7, yyCoord(2), chanLabel, 'FontWeight', 'bold', 'FontSize', 8);
        set(ytext, 'Rotation', 20)
    else
        text(xt(1)-(xt(end)-xt(1))/7, yyCoord(2), chanLabel, 'FontWeight', 'bold', 'FontSize', 8);
    end
    
    box off
    
    if  i~= nCh && nCh~= 1
        set(gca,'xticklabel',[]);
    end
    
    if i== nCh
        xlabel('Time [sec]');
    end
end

%Customize figure to avoid white spaces
origh1= get(h1, 'Units');
origax1= get(ax1, 'Units');
set(h1, 'Units', 'centimeters');
set(ax1, 'Units', 'centimeters');

h1Pos= get(h1, 'Position');
ax1Pos = get(ax1, 'Position');
spHeight1= (h1Pos(4)-2)/nCh;

for cc=1:nCh
    if nCh==1
        set(ax1, 'Position', [ax1Pos(1), 1+spHeight1*(nCh-cc), ax1Pos(3), spHeight1])
    else
        set(ax1(cc), 'Position', [ax1Pos{cc,1}(1), 1+spHeight1*(nCh-cc), ax1Pos{cc,1}(3), spHeight1])
    end
end

set(h1, 'Units', origh1);
for cc= 1:nCh
    if nCh == 1
        set(ax1, 'Units', origax1);
    else
        set(ax1(cc), 'Units', origax1{cc});
    end
end


AX2= findobj(h2, 'Type', 'axes');

for i=1:size(AX2,2)
    AX3= get(AX2(i), 'Tag');
    if ~strcmp(AX3, 'axes3') && ~isempty(AX3)
        delete(AX3)
    end
end
            

for i= 1:nCh
    ax2(i)= subplot(nCh,1,i,'Parent',h2);
    xt= timeMx(w,1):1/SR:timeMx(w,2);
    
    if diplayDecimation ~= 1
        xtdec= xt(1:diplayDecimation:end);
        xt= xtdec;
        MX= scalMx{i+group-1,w,:};
        MXNew= MX(1:diplayDecimation:end,:);
        imagesc(xt, fvect, MXNew);
    else
        imagesc(xt, fvect, scalMx{i+group-1,w,:});
    end
    xlim([xt(1) xt(end)])
    ylabel('Freq. [Hz]')
    axis xy
    colormap(colorMAP)
    
    if i~= nCh && nCh~= 1
        set(gca,'xticklabel',[]);
    end
    
    caxis([colorRangeMin/sensFact2  colorRangeMax/sensFact2])
    
    if i== nCh
        xlabel('Time [sec]');
    end
end
c =colorbar(gca);

%Customize figure to avoid white spaces
origh2= get(h2, 'Units');
origax2= get(ax2, 'Units');
set(h2, 'Units', 'centimeters');
set(ax2, 'Units', 'centimeters');

h2Pos= get(h2, 'Position');
ax2Pos = get(ax2, 'Position');
spHeight2= (h2Pos(4)-2)/nCh;

for cc=1:nCh
    if nCh == 1
        set(ax2, 'Position', [ax2Pos(1), 1+spHeight2*(nCh-cc), ax2Pos(3), spHeight2])
    else
        set(ax2(cc), 'Position', [ax2Pos{cc,1}(1), 1+spHeight2*(nCh-cc), ax2Pos{cc,1}(3), spHeight2])
    end
end

set(h2, 'Units', origh2);
for cc= 1:nCh
    if nCh == 1
        set(ax2, 'Units', origax2);
    else
        set(ax2(cc), 'Units', origax2{cc});
    end
        
end

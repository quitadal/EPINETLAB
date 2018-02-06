%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function allows to reorder channels in an EEGLAB *.SET file on the
% label basis. Useful for the creation of bipolar montages.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = evalin('base','whos');
inBase= zeros(length(W),1);
if isempty(W)
    EEGOUT = pop_loadset;
    ALLEEG= [];
    if isempty(EEGOUT)
        return
    end
else
    for i= 1:length(W)
        nm1=W(i).name;
        inBase(i)= strcmp(nm1, 'EEG');
    end
    if any(inBase)
        EEG= evalin('base', 'EEG');
        if isempty(EEG.data)~= 1
            EEGOUT= EEG;
        else
            EEGOUT = pop_loadset;
            ALLEEG= [];
            if isempty(EEGOUT)
                return
            end
        end
        
    else
        EEGOUT = pop_loadset;
        ALLEEG= [];
        if isempty(EEGOUT)
            return
        end
    end
end

chanStruct= EEGOUT.chanlocs;
Labels= {chanStruct(:).labels};
nLab= length(Labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for equal labels and assign a different number to them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[uniqLab, idxUniq, idxRep]= unique(Labels);
idxSort= sort(idxRep);
t = find(diff(idxSort)==0);

if isempty(t) %channels are already ordered
    disp('........Channels already ordered, nothing will be changed..........')
else
    
    for i= 1:length(t)
        duplCh= find(idxRep==idxSort(t(i)));
        for j= 1:length(duplCh)
            Labels{duplCh(j)}= deblank([Labels{duplCh(j)} '00' num2str(j)]);
        end
    end
    
    
    R = cell2mat(regexp(Labels ,'(?<Name>\D+)(?<Nums>\d+)','names')); %regexp= match regular expression (case sensitive)
    nR= length(R);
    [tmp, idx] = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
    SortedText = strcat(tmp(:,1) , cellfun(@(x) x(1:end), {R(idx).Nums}', 'UniformOutput',0));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Some channels can have the same label and other channels can be non-digit
    % labels (e.g. Cz, Pz, etc.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if nR ~= nLab
        SortedTextNew= SortedText;
        
        %     missLL= abs(nR-nLab);
        %     missIdx= [];
        %     nonMissIdx= [];
        
        for i= 1:nLab
            ll= strcmp(SortedText, Labels{i});
            if all(ll== 0)
                SortedTextNew{length(SortedTextNew)+1}= Labels{i};
            end
        end
        
        idxNew= [];
        
        for i=1:nLab
            idxNewInt= find(strcmp(Labels, SortedTextNew{i})== 1);
            idxNew= [idxNew idxNewInt];
        end
        
    else
        idxNew= idx;
    end
    
    idxNew= unique(idxNew, 'stable');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Reorder channels
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    EEGOUT.data= EEGOUT.data(idxNew,:);
    
    [r,c]= size(EEGOUT.chanlocs);
    
    if r > c
        EEGOUT.chanlocs= EEGOUT.chanlocs(idxNew,1);
    else
        EEGOUT.chanlocs= EEGOUT.chanlocs(1, idxNew);
    end
    
    EEGOUT.setname= [EEGOUT.setname '_ordCh'];
    EEGOUT.saved= 'yes';
end



CURRENTSET= size(ALLEEG, 2);
[ALLEEG, EEG, CURRENTSET] = pop_newset( ALLEEG, EEGOUT, CURRENTSET);

% Assign new variables to workspace
assignin('base', 'ALLEEG', ALLEEG)
assignin('base', 'EEG', EEGOUT)
assignin('base', 'CURRENTSET', CURRENTSET)
eeglab redraw % Update the EEGLAB window to view changes
disp('Done')




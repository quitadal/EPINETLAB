%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function pops out the gui to set wavelet parameters in a time-frequency
%analysis of EEG traces.

% INPUT:
% EEG is the eeglab structure
% typeproc determines if the analysis is run on EEG components (1) or on the
% ICA ones (1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = pop_eegcwt


%open the  guide for setting parameters
MyTimeFrequency;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EPINETLAB is a multi-Graphic User Interface (GUI) set of Matlab functions
% developed in the context of the EPIleptic NETworks project (EPINET,
% http://cordis.europa.eu/project/rcn/195032_en.html), an EU-funded
% initiative focussed to developing tools for the detection of
% high-frequency oscillations (HFOs) in intracranial EEG (iEEG) and
% source-space MEG data and to their application to the improvement of the
% delineation of the seizure-onset zone (SOZ). EPINETLAB was developed as a
% plugin toolbox for EEGLAB, under the GNU Public License version 3.0.
% EPINETLAB was designed to provide an easy-to-use tool to investigate the
% spatial and time-frequency properties of HFOs, to identify the channels
% with the highest HFO-rate and to allow the evaluation of the spatial
% distribution of the HFO area with that of the SOZ identified in the
% presurgical workup. The toolbox was documented for each step of the
% analysis pipeline and parameters for the analyses can be set in
% user-friendly GUIs. Moreover, the platform allows analysis of multiple
% files in a single process and the implementation of a robust channel
% reduction methodology was designed to reduce computational load and
% subject-dependent errors. An addition not available in other tools
% released in the literature is the possibility to load, process and
% analyse MEG data, either raw or source-space domain, thus providing the
% possibility to evaluate the concordance between the source locations of
% HFOs recorded from pre-operative MEG studies and those identified in iEEG
% recordings. Each function in EPINETLAB underwent a rigorous beta-testing
% phase with neurophysiology clinical scientists (EEG Technologists) and
% clinical neurophysiologists, to simulate real-life operator-dependent
% situations and minimize programming errors caused by unforeseen list of
% operations.
%
% EPINETLAB is being developed since 2015 at the Aston University, Aston
% Brain Centre, Birmingham, UK, by Dr. Lucia Rita Quitadamo, senior
% researcher at the School of Life and Health Sciences department. The
% project was funded by EC, under the Marie Sklodowska-Curie
% actions-International fellowships (IF). For any enquiry about the
% software please contact l.quitadamo@aston.ac.uk
%
% References: [1]Quitadamo LR, Mai R, Gozzo F, Pelliccia V, Cardinale F,
% Seri S. Kurtosis-based detection of intracranial high-frequency
% oscillations for the identification of the seizure onset zone Int J
% Neural Syst 2018, Accepted for publication.
%
% [2]Quitadamo LR, Mai R, Seri S. Identification of high-frequency
% oscillations (HFOs) in paediatric intracranial EEG by means of
% kurtosis-based time-frequency analysis. Epilepsia 2017, 58:S97-S98.
%
% [3]Foley E, Quitadamo L, Hillebrand A, Bill P, Seri S. High Frequency
% Oscillations detected by automatic Kurtosis-based Time-Frequency Analysis
% in MEG And Intracranial EEG in Paediatric Epilepsy. Epilepsia 2017,
% 58:S152-S152.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  eegplugin_epinetlab_import(fig,try_strings,catch_strings)

 W_MAIN = findobj('tag', 'EEGLAB');

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Accessory functions
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 HFO_m   = uimenu(W_MAIN,   'Label', 'EPINETLAB (HFO)');
 Prepr_m = uimenu(HFO_m,    'Label', 'Preprocessing Functions');
 LabFrmt_m = uimenu(Prepr_m,   'Label', 'Labels Formatting', 'callback', 'LabelsFormatting');
 BipString = [try_strings.no_check '[EEG]= pop_BipolarMontage;' catch_strings.new_and_hist ];
 Bip_m   = uimenu(Prepr_m,  'Label', 'Bipolar Montage Creation', 'callback', BipString);
 ARString = [try_strings.no_check 'EEG= pop_AverageReferences;' catch_strings.new_and_hist ];
 AR_m   = uimenu(Prepr_m,  'Label', 'Average References Creation', 'callback', ARString);
 OrdCh_m = uimenu(Prepr_m,  'Label', 'Label-based channels Ordering', 'callback', 'OrderChannels');
 Cut_m   = uimenu(Prepr_m,  'Label', 'File Cutting', 'callback', 'FileCutting2');

 
 CorrComp_m   = uimenu(Prepr_m,'Label', 'Compute MEG virtual sensors correlation', 'callback', 'VSCorrelationComputing', 'separator', 'on');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Seizure Frequency Content Inspection
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 SeizureInspection= uimenu(HFO_m,  'Label', 'Seizure Inspection', 'callback', 'SeizureFrequencyContent', 'separator', 'on');


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Time-Frequency analysis and statisitics 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 TF_m=   uimenu(HFO_m,     'Label', 'Wavelet-based Time-Frequency Analysis', 'callback', 'MyTimeFrequency', 'separator', 'on');
 Stat_m= uimenu(HFO_m,     'Label', 'Kurtosis-based Statistics', 'callback', 'HFOStatistics');
 HFODet_m=  uimenu(HFO_m,     'Label', 'HFOs Detection', 'callback', 'HFODetection2');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % HFO detection evaluation
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 HFOInsp_m= uimenu(HFO_m,     'Label', 'HFOs Visualization (in time)', 'callback', 'HFORawDataInspection',  'separator', 'on');
 HFOPlot_m= uimenu(HFO_m,     'Label', 'HFOs rates plot');
 SOZIdent_m= uimenu(HFO_m,    'Label', 'SOZ Identification', 'callback', 'SOZIdentification');
 
 
 plotStereo_m = uimenu(HFOPlot_m, 'Label', 'Plot HFO rate on sEEG channels', 'callback', 'plotDetectionResults');
 plotBoth_m=    uimenu(HFOPlot_m, 'Label', 'Plot HFO rate on sEEG AND grids', 'callback', 'plotDetectionResultsGrid');
 plotMEG_m=     uimenu(HFOPlot_m, 'Label', 'Plot HFO rate on MEG channels');
 plotMEGVS_m=  uimenu(plotMEG_m,  'Label', 'Plot HFO rate on MEG virtual sensors (90)', 'callback', 'plotDetectionResultsMEGVS');
 plotMEGRAW_m=  uimenu(plotMEG_m, 'Label', 'Plot HFO rate on MEG raw channels (120 magnetometers)', 'callback','plotDetectionResultsMEGRAW');
 plotMEGGEN_m=  uimenu(plotMEG_m, 'Label', 'Plot HFO rate on generic MEG channels (1...N)', 'callback','plotDetectionResultsMEGGEN');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % HFO Multiple file detection
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 HFOAut_m= uimenu(HFO_m, 'Label', 'HFOs detection on multiple files', 'callback', 'MultipleFilesDetection;', 'separator', 'on');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Export HFO to Micromed
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 uimenu(HFO_m, 'Label', 'Export HFOs to Micromed','callback',  'exportHFOtoMicromed','separator', 'on');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Sinle Pulse Electrical Stimulation (SPES)analysis: Gamma Band Oscilaltions
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 Spes_m=   uimenu(HFO_m,  'Label', 'Single Pulse Electrical Stimulation (SPES) analysis');
 uimenu(Spes_m, 'Label', 'Iterative Epoching', 'callback', 'IterativeEpoching')
 uimenu(Spes_m, 'Label', 'Gamma Band Augmentation', 'callback', 'GammaBandOscillations');

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %EPINETLAB Help
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 EpinetlabHelp_m= uimenu(HFO_m, 'Label', 'EPINETLAB Help', 'separator', 'on');
 AboutEpinetlab= uimenu(EpinetlabHelp_m, 'Label', 'About EPINETLAB', 'CallBack', 'pophelp(''eegplugin_epinetlab_import'');');
 EpinetlabTutorial= uimenu(EpinetlabHelp_m, 'Label', 'Licence Info', 'CallBack', 'open(''Licence.txt'')');
 EmailEpinetlab= uimenu(EpinetlabHelp_m, 'Label', 'Email EPINETLAB Team', 'CallBack', 'web(''mailto:l.quitadamo@aston.ac.uk'');');

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Add functionality for importing MEG data from .MAT files
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 importmenu= findobj(fig,'tag','import data');
 cmdMEG = [ try_strings.no_check '[EEG]= pop_loadFiff;' catch_strings.new_and_hist ];
 uimenu(importmenu,'label','From  Elekta Neuromag MEG .fif file', 'callback', cmdMEG ,'separator','on');

 
 
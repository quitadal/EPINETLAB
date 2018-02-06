% Read in the 78 Virtual electrode time series as a single continuous segment
cfg = [];
[filename, filepath]= uigetfile();
cfg.dataset     = 'D:\For_Lucia\JC_spon1_tsss_headpos_80-250Hz_AAL_VE.fif';
JC_spon1_tsss_headpos_80_250Hz_AAL_VE   = ft_preprocessing(cfg);
save  JC_spon1_tsss_headpos_80_250Hz_AAL_VE JC_spon1_tsss_headpos_80_250Hz_AAL_VE
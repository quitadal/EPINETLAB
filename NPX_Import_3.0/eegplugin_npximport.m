% eegplugin_npximport() -   EEGLAB plugin for importing NPXLAB .NPX file.
%                           With this menu it is possible to import NPXLab file (.npx and .bin files) into EEGLAB.
% Usage:
%   >> eegplugin_npximport(fig, try_strings, catch_strings);
%
% Inputs:
%   fig            - [integer]  handle to EEGLAB figure
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks. 
%

function vers = eegplugin_npximport(fig,try_strings,catch_strings)

vers='npximport3.0';

if nargin < 3
    error('eegplugin_npximport requires 3 arguments');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import .NPX files (www.brainterface.com) and export EEGLAB .set to .NPX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
importmenu=findobj(fig,'tag','import data');
cmdIMP = [ try_strings.no_check 'EEG= pop_loadnpx;' catch_strings.new_and_hist ];
uimenu(importmenu,'label','From NPXLab .NPX file',...
    'callback',cmdIMP,'separator','on');

exportmenu = findobj(fig,'tag','export');
cmdEXP = [ try_strings.no_check 'write_npx_fromset;' catch_strings.new_and_hist ];
uimenu(exportmenu,'label','Data to .NPX',...
    'callback',cmdEXP,'separator','on');
 

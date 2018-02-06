%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates coefficients (coefs) for a continuous wavelet 
% transform (CWT)

% INPUT:
% x is the time series data
% SR in the data sampling frequency
% win_len is the lenght of the window of interest in time samples e.g. 1
% [sec]
% mother_wavelet is the chosen wavelet function.
% freq is the vector of frequancy band extremities of interest [e.g. 80
% 250] [Hz]


% OUTPUT:
% wavelet coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [coefs, S, fvect, Scales] = simple_cwt(x, SR, mother_wavelet, freq)

dt= 1/SR;
minfreq= freq(1);
maxfreq= freq(2);

if strcmp(mother_wavelet(1:4), 'mors')
    f0=1;
    dot= strfind(mother_wavelet, '.');
    ga= str2double(mother_wavelet(5:dot-1));
    be= str2double(mother_wavelet(dot+1:end));
else
    f0 = centfrq(mother_wavelet);
end

smin= f0/(maxfreq*dt);
smax= f0/(minfreq*dt);

% smin= floor(20*log2(smin));%
% smax= ceil(20*log2(smax));%

Scales= smin:0.05:smax; % we use a linear scale
%Scales= a0.^(smin:smax).*dt;%

if strcmp(mother_wavelet(1:4), 'mors')
    fvect= 2*pi*f0./(Scales*dt);
else
    fvect= scal2frq(Scales,mother_wavelet,dt);
end

coefs= zeros(length(fvect), size(x,1));
S= zeros(length(fvect), size(x,1));


if strcmp(mother_wavelet(1:4), 'mors')
    coefs= wavetrans(x, {ga, be, Scales});
else
    coefs= cwt(x, Scales, mother_wavelet);
end

S = abs(coefs.*coefs); 
S = 100*S./sum(S(:)); % the percentage of energy for each coefficient.






    

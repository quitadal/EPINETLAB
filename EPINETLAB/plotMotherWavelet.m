function [PSI, XVAL, TITLE]= plotMotherWavelet(mother)

selWav= mother;

switch selWav
    case 'haar'
         [~,PSI,XVAL]= wavefun(selWav,10);
         TITLE= 'Haar';
         waveinfo('haar')            
        
    case  {'db1', 'db2', 'db3', 'db4', 'db5', 'db6', 'db7', 'db8', 'db9', 'db10', 'db20'}
         [~,PSI,XVAL]= wavefun(selWav,10);
         if length(selWav)==3
            TITLE= ['Daubechies ' selWav(end)];
         else
            TITLE= ['Daubechies ' selWav(end-1:end)];
         end
         
         waveinfo('db')
         
    case {'sym2', 'sym3', 'sym4', 'sym5', 'sym6', 'sym7', 'sym8'}
        [~,PSI,XVAL] = wavefun(selWav,10);   
        TITLE= ['Symlets ' selWav(end)];
        waveinfo('sym')   
    
        
    case  {'coif1', 'coif2', 'coif3', 'coif4', 'coif5'}
        [~,PSI,XVAL] = wavefun(selWav,10);   
        TITLE= ['Coiflet ' selWav(end)];
        waveinfo('coif') 
        
    case {'bior1.1', 'bior1.3','bior1.5','bior2.2', 'bior2.4', 'bior2.6', 'bior2.8', 'bior3.1',...             
               'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'}
           
          [~,psi1,~,psi2,XVAL] = wavefun(selWav,10);
          
          PSI= [psi1; psi2];
          TITLE= ['BiorSplines ' selWav(end-3:end)];    
          waveinfo('bior') 
        
    case  {'rbio1.1', 'rbio1.3','rbio1.5','rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8', 'rbio3.1',...             
               'rbio3.3', 'rbio3.5', 'rbio3.7', 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'}
        
          [~,psi1,~,psi2,XVAL] = wavefun(selWav,10);
          PSI= [psi1; psi2];
          TITLE= ['ReverseBior ' selWav(end-3:end)];    
          waveinfo('rbio') 
           
    case 'meyr'
         [~,PSI,XVAL]= wavefun(selWav,10);
         TITLE= 'Meyer';
         waveinfo('meyr') 
         
    case 'dmey'
         [~,PSI,XVAL]= wavefun(selWav,10);
         TITLE= 'DMeyer';
         waveinfo('dmey')  
       
    case  {'gaus1', 'gaus2','gaus3', 'gaus4', 'gaus5', 'gaus6', 'gaus7','gaus8' }
        
         [PSI,XVAL]= wavefun(selWav,10);
         TITLE= ['Gaussian' selWav(end)];
         waveinfo('gaus')          
        
    case  {'cgau1', 'cgau2','cgau3', 'cgau4', 'cgau5'};
         [PSI,XVAL]= wavefun(selWav,10);
         TITLE= ['Complex Gaussian' selWav(end)];
         waveinfo('cgau') 
         
    case 'mexh'
         [PSI,XVAL]= wavefun(selWav,10);
         TITLE= 'Mexican Hat';
         waveinfo('mexh')
         
    case 'morl'
         [PSI,XVAL]= wavefun(selWav,10);
         TITLE= 'Morlet';
         waveinfo('morl')
       
        
    case  {'shan1-1.5','shan1-1','shan1-0.5','shan1-0.1','shan2-3'}
         [PSI,XVAL]= wavefun(selWav,10);
          TITLE= ['Shannon ' selWav(5:end)];
          waveinfo('shan')
        
    case {'fbsp1-1-1.5', 'fbsp1-1-1', 'fbsp1-1-0.5','fbsp2-1-1','fbsp2-1-0.5','fbsp2-1-0.1'}
         [PSI,XVAL]= wavefun(selWav,10);
         TITLE= ['Frequency B-Spline ' selWav(5:end)];
         waveinfo('fbsp')
    
    case {'cmor1-1.5','cmor1-1', 'cmor1-0.5','cmor1-0.1', 'cmor2-1.5', 'cmor2-1', 'cmor2-0.5', 'cmor2-0.1', 'cmor3-1.5' };
        [PSI,XVAL]= wavefun(selWav,10);
        TITLE= ['Complex Morlet ' selWav(5:end)];
        waveinfo('cmor')
end

        
        
        
        

Tw = 20;           % analysis frame duration (ms)
Ts = 5;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 300 3700 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
N = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

[S, Fs] = wavread('3_833_1_2_002-ch6-speaker16.wav');
%[S, Fs] = wavread('sp10.wav');

hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
WINDOW = hamming;
[ MFCCs, FBEs, frames ] = mfcc(S,FS,Tw,Ts,alpha,WINDOW,R,M,N,L);

% Plot cepstrum over time
figure('Position', [30 100 800 200], 'PaperPositionMode', 'auto', ... 
   'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 

imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs ); 
axis( 'xy' );
xlabel( 'Frame index' ); 
ylabel( 'Cepstrum index' );
title( 'Mel frequency cepstrum' );
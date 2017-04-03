function [MFCCs39] = ta_mfcc(S)
% FS: sample rate
FS = 16000; 

% @ta 25 ms frames
TW = 25; % 256 / FS * 1000; % TW: analysis frame window

% @ta 10 ms overlap
TS = 10; % TS: window shifts

% some parameters
ALPHA = 0.97; % preemphasis coefficient
R = [ 300 5700 ];  % frequency range to consider

% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
WINDOW = hamming;

% number of filterbank channels 
M = 24;            

% @ta if we use just 13 is it the same as calculating 24 and dropping to 13?
N = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% FBEs is a matrix of filterbank energies
% Frames is a matrix of windowed frames with one frame per column
% [MFCCs]=mfcc(S,FS,TW,TS,ALPHA,WINDOW,R,M,N,L);

[MFCCs39]=ta_mfcc39(S,FS,TW,TS,ALPHA,WINDOW,R,M,N,L);
end
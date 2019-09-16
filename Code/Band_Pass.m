%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo Codes For: 
%      “Supervised Heart Rate Tracking using Wrist-Type Photoplethysmographic (PPG)
%       Signals during Physical Exercise without Simultaneous Acceleration Signals”
%
% References:
%
%  [1] M. Essalat, M. Boloursaz, and F. Marvasti, “Supervised Heart Rate 
%      Tracking using Wrist-Type Photoplethysmographic (PPG) Signals during
%      Physical Exercise without Simultaneous Acceleration Signals” 
%      submitted to the 4th IEEE Global Conference on Signal and 
%      Information Processing (GlobalSIP), Washington, DC, USA, December 2016.
%
% Written By: 
%       Mahmoud Essalat
%       Mahdi Boloursaz Mashhadi     
%             
% Affiliation: 
%          Advanced Communications Research Institute (ACRI)
% Electrical Engineering Department, Sharif University of Technology
%                              Tehran, Iran
%
% For any problem, contact me at esalat_mahmoud@ee.sharif.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ final ] = Band_Pass( sig, fs, M, Np)
Np = floor(Np);%previous signal frame frequency location index estimation
N = 2^15; % number of fft points
f1 = fft(sig,N);
out = zeros(1,N);

min_Hz = 0.8;%lower cutoff frequency
max_Hz = 13;%upper cutoff frequency

deposite0 = floor(0.5/fs*N); % main band
deposite1 = floor(0.2/fs*N); % first harmonic band 
deposite2 = floor(0.15/fs*N); % second harmonic band
deposite3 = floor(0.1/fs*N); % third harmonic band
if Np == 0 % first window

    i = floor(min_Hz*N/fs):floor(max_Hz*N/fs);      
    out(i)=f1(i);
    out(N+2-i)=f1(N+2-i);  
else 
    i = [Np - deposite0 : Np + deposite0,  2 * (Np - deposite1 - 1) + 1:2 * (Np + deposite1 - 1) + 1, ...    
        3 * (Np - deposite2 - 1) + 1:3 * (Np + deposite2 - 1) + 1, 4 * (Np - deposite3 - 1) + 1:4 * (Np + deposite3 - 1) + 1];    
    out(i)=f1(i);            
    out(N+2-i)=f1(N+2-i);   
end

zero_padd = ifft(out,N);
final = zero_padd(1:M);

end

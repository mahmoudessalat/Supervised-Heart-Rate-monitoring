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

function [ BP_ECG, BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ ] = signal_BandPassing( ECG, PPG1, PPG2, ACCX, ACCY, ACCZ, fs, M, Np )
    BP_ECG  = Band_Pass(ECG,  fs, M, Np);
    BP_PPG1 = Band_Pass(PPG1, fs, M, Np);
    BP_PPG2 = Band_Pass(PPG2, fs, M, Np);
    BP_ACCX = Band_Pass(ACCX, fs, M, Np);
    BP_ACCY = Band_Pass(ACCY, fs, M, Np);
    BP_ACCZ = Band_Pass(ACCZ, fs, M, Np);
end


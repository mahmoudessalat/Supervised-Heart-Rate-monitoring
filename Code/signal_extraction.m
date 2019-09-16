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

function [ ECG, PPG1, PPG2, ACCX, ACCY, ACCZ ] = signal_extraction( sig, Nw, step_length, M, model )

ECG  = sig(1,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));
if model == 2
    model = model-2;
end
PPG1 = sig(model+1,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));               
PPG2 = sig(model+2,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));       
ACCX = sig(model+3,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));       
ACCY = sig(model+4,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));           
ACCZ = sig(model+5,((Nw-1) * step_length + 1 : (Nw-1) * step_length + M));


end


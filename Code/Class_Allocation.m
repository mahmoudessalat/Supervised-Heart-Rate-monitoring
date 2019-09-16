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
function [ OUTPUT ] = Class_Allocation( Suspicious_Freq , True_Freq )
OUTPUT = zeros(length(Suspicious_Freq), 5);
for i = 1:length(Suspicious_Freq)
if abs( Suspicious_Freq(i) - True_Freq ) < 16
    OUTPUT(i,:) = 1;%[1 0 0 0 0];
else    
    OUTPUT(i,:) = 0;%[0 0 0 0 1];
end
end

end


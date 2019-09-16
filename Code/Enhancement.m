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
function [ Exit, Freq_Index, State, BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ ] = ...
    Enhancement( Y, FRS, Suspicious_Freq, State, ...
             BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ, Freq_Index, Nw, N, fs, M )

Exit = 0;      
Band_Pass_Point = mean([Freq_Index(Nw-1), Freq_Index(Nw-2)]);

[max_point, ~] = sort(Y(:,1), 'descend');
Best_Estimation = Y(:,1) >= 0.7 * max_point(1);   
Best_Suspicious = Suspicious_Freq(Best_Estimation);
if max_point(1) >= 0.4
    [~, Best_Freq] = min(abs(Best_Suspicious - Freq_Index(Nw-1)));  
        Freq_Index(Nw) = Best_Suspicious(Best_Freq); 
    Exit = 1;
elseif State(Nw) == 0
    BP_PPG1(Nw,:) = Band_Pass(BP_PPG1(Nw,:), fs, M, Band_Pass_Point);      
    BP_PPG2(Nw,:) = Band_Pass(BP_PPG2(Nw,:), fs, M, Band_Pass_Point);    
    State(Nw) = 1;
elseif State(Nw) == 1            
    BP_PPG1(Nw,:) = BP_PPG1 (Nw,:) + BP_PPG1 (Nw-1,:) + BP_PPG1 (Nw-2,:);        
    BP_PPG2(Nw,:) = BP_PPG2 (Nw,:) + BP_PPG2 (Nw-1,:) + BP_PPG2 (Nw-2,:);    
    State(Nw) = 2;
end
    
end

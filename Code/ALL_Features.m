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
function [ DELTA, FRS, ACCX_Index, ACCY_Index, ACCZ_Index ] = ...
    ALL_Features( BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ, ACCX_Index, ACCY_Index, ACCZ_Index, Freq_Ind, Nw, fs, N, NO_FRS)
T = 0.3;
delta = 18;

[PPG1_Spec, ~] = pyulear(BP_PPG1, 500, N, fs); Normalized_Spec1 = PPG1_Spec / max(PPG1_Spec);
[PPG2_Spec, ~] = pyulear(BP_PPG2, 500, N, fs); Normalized_Spec2 = PPG2_Spec / max(PPG2_Spec);


[ M1 , CP1, W1, P1] = findpeaks(Normalized_Spec1, 'MinPeakHeight', T);
[ M2 , CP2, W2, P2] = findpeaks(Normalized_Spec2, 'MinPeakHeight', T);

DELTA = [CP1; CP2];
M = [M1; M2];
W = [W1; W2];
P = [P1; P2];
HR_gamma = DELTA/N*fs*8;
FRS = zeros(NO_FRS, length(DELTA));


Freq_Ind_Prev = floor(Freq_Ind(Nw-1));

for i = 1:length(CP1)
    for j = 1:length(CP2)
        if abs(CP1(i) - CP2(j)) < 24
            FRS(1,i) = FRS(1,i) + 1;
        end
    end
end

for i = 1:length(CP2)
    for j = 1:length(CP1)
        if abs(CP1(j) - CP2(i)) < 24
            FRS(1,i+length(CP1)) = FRS(1,i+length(CP1)) + 1;
        end
    end
end

for i = 1:length( DELTA )
FRS(2, i) = abs ( DELTA(i) - Freq_Ind_Prev );
FRS(3, i) = abs ( DELTA(i) - Freq_Ind(Nw-2) );
FRS(4, i) = abs ( DELTA(i) - Freq_Ind(Nw-3) );

FRS(5, i) = length(DELTA);

FRS(6, i) = W(i);
FRS(7, i) = P(i); 

if i <= length(CP1)
    M_Star = findpeaks( Normalized_Spec1 (Normalized_Spec1 < M(i)-0.01) , 'sortstr', 'descend' );
else    
    M_Star = findpeaks( Normalized_Spec2 (Normalized_Spec2 < M(i)-0.01) , 'sortstr', 'descend' );
end

FRS(8, i) = M(i) - M_Star(1);

[FRS(9, i), index1] = max(Normalized_Spec1 ( DELTA(i)-delta : DELTA(i)+delta ));
FRS(10, i) = abs(DELTA(i) - (index1+DELTA(i)-delta-1));
[FRS(11, i), index2] = max(Normalized_Spec1 ( 2*DELTA(i)-2*delta : 2*DELTA(i)+2*delta ));
FRS(12, i) = abs(DELTA(i) - (index2+2*DELTA(i)-2*delta-1)/2);

[FRS(13, i), index3] = max(Normalized_Spec1 ( 3*DELTA(i)-3*delta : 3*DELTA(i)+3*delta ));
FRS(14, i) = abs(DELTA(i) - (index3+3*DELTA(i)-2*delta-1)/3);
[FRS(15, i), index4] = max(Normalized_Spec1 ( 4*DELTA(i)-4*delta : 4*DELTA(i)+4*delta ));
FRS(16, i) = abs(DELTA(i) - (index4+4*DELTA(i)-4*delta-1)/4);

[FRS(17, i), index1] = max(Normalized_Spec2 ( DELTA(i)-delta : DELTA(i)+delta ));
FRS(18, i) = abs(DELTA(i) - (index1+DELTA(i)-delta-1));
[FRS(19, i), index2] = max(Normalized_Spec2 ( 2*DELTA(i)-2*delta : 2*DELTA(i)+2*delta ));
FRS(20, i) = abs(DELTA(i) - (index2+2*DELTA(i)-2*delta-1)/2);

[FRS(21, i), index3] = max(Normalized_Spec2 ( 3*DELTA(i)-3*delta : 3*DELTA(i)+3*delta ));
FRS(22, i) = abs(DELTA(i) - (index3+3*DELTA(i)-3*delta-1)/3);
[FRS(23, i), index4] = max(Normalized_Spec2 ( 4*DELTA(i)-4*delta : 4*DELTA(i)+4*delta ));
FRS(24, i) = abs(DELTA(i) - (index4+4*DELTA(i)-4*delta-1)/4);

Scaled_PPG1 = BP_PPG1 / max(BP_PPG1);
Scaled_PPG2 = BP_PPG2 / max(BP_PPG2);
FRS(25, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG1, 'MinPeakHeight', 0, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));
FRS(26, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG2, 'MinPeakHeight', 0, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));
FRS(27, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG1, 'MinPeakHeight', 0.2, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));
FRS(28, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG2, 'MinPeakHeight', 0.2, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));
FRS(29, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG1, 'MinPeakHeight', 0.4, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));
FRS(30, i) = abs(HR_gamma(i) - length(findpeaks(Scaled_PPG2, 'MinPeakHeight', 0.4, 'MinPeakDistance', 1000/((Freq_Ind_Prev+30)*fs/N*8))));

end

end
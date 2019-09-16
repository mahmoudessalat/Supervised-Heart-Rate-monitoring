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

%% CLEARANCE
clear; clc; close all;
 
%% ADDING FUNCTIONS 
addpath(genpath('.\DATASET'));
%% LOADING DATA
load( 'NET_init' );%trainde network before initialization
load( 'NET_1' );% after initialization

Signal_NAMES = [{'TEST_S01_T01'}, {'TEST_S02_T01'}, {'TEST_S02_T02'}, {'TEST_S03_T02'}, {'TEST_S04_T02'}, ...
    {'TEST_S05_T02'}, {'TEST_S06_T01'}, {'TEST_S06_T02'}, {'TEST_S07_T02'}, {'TEST_S08_T01'}, {'DATA_S04_T01'}];
BPM_NAMES = [{'True_S01_T01'}, {'True_S02_T01'}, {'True_S02_T02'}, {'True_S03_T02'}, {'True_S04_T02'}, ...
    {'True_S05_T02'}, {'True_S06_T01'}, {'True_S06_T02'}, {'True_S07_T02'}, {'True_S08_T01'}, {'BPM_S04_T01'}];
MAE = zeros(length(Signal_NAMES)+12,1);
RunTime = zeros(length(Signal_NAMES)+12,1);
file_name_1 = cell(length(Signal_NAMES)+12,1);
file_name_2 = cell(length(Signal_NAMES)+12,1);
for k = 1:23
    tic
    if k < 13
        model = 1;
        if k == 1        
            mode = sprintf('%d', 1);    
        else            
            mode = sprintf('%d', 2);    
        end        
        if k < 10        
            prefix = sprintf('%d', 0);    
        else            
            prefix = '';    
        end        
    number = sprintf('%d', k);
    file_name_1{k} = strcat('DATA_', prefix, number, '_TYPE0', mode);
    load(file_name_1{k});
    file_name_2{k} = strcat(file_name_1{k}, '_BPMtrace');    
    load(file_name_2{k});
    else
        model = 2;
        file_name_1{k} = Signal_NAMES{k-12};
        load(file_name_1{k});
        file_name_2{k} = BPM_NAMES{k-12};
        load(file_name_2{k});       
    end
%% PARAMETERS
NO_FRS = 17;%# of features
N = 2^15; %# of fft points
fs = 125; % sampling frequency

step_second = 2; %slide of signal window in second
overlap_second = 6; % window's overlap in second

step_length = step_second * fs;
overlap_length = overlap_second * fs;

M = overlap_length + step_length;
%% CONSTANTS
windows_NO = floor((size(sig, 2) - overlap_length) / step_length);
State = zeros(1, windows_NO); % state of MA cancellation method
ACCX_Index = zeros(1, windows_NO);
ACCY_Index = zeros(1, windows_NO);
ACCZ_Index = zeros(1, windows_NO);

min_window = 1;
%% Defining
ECG = zeros(windows_NO, M);BP_ECG = zeros(windows_NO, M);
PPG1 = zeros(windows_NO, M);PPG2 = zeros(windows_NO, M);BP_PPG1 = zeros(windows_NO, M);BP_PPG2 = zeros(windows_NO, M);
ACCX = zeros(windows_NO, M);ACCY = zeros(windows_NO, M);ACCZ = zeros(windows_NO, M);
BP_ACCX = zeros(windows_NO, M);BP_ACCY = zeros(windows_NO, M);BP_ACCZ = zeros(windows_NO, M);
Freq_Index = zeros(1, windows_NO);% Estimated frequency location index

%% MAIN PROGRAM
for Nw = min_window : windows_NO  
    [ECG(Nw,:), PPG1(Nw,:), PPG2(Nw,:), ACCX(Nw,:), ACCY(Nw,:), ACCZ(Nw,:)] = ... 
        signal_extraction(sig, Nw, step_length, M, model);
              
    %% Band Passing                  
    [BP_ECG(Nw, :), BP_PPG1(Nw, :), BP_PPG2(Nw, :), BP_ACCX(Nw, :), BP_ACCY(Nw, :), BP_ACCZ(Nw, :)] = ...    
        signal_BandPassing( ECG(Nw,:), PPG1(Nw, :), PPG2(Nw, :),...
            ACCX(Nw, :), ACCY(Nw, :), ACCZ(Nw, :), fs, M, 0);
                 
     if Nw == min_window || Nw == min_window+1 || Nw == min_window+2 || Nw == min_window+3
         [Suspicious_Freq, FRS, ACCX_Index, ACCY_Index, ACCZ_Index] = FEATURES_init( BP_PPG1(Nw,:), BP_PPG2(Nw,:), BP_ACCX(Nw,:), ...            
                BP_ACCY(Nw,:), BP_ACCZ(Nw,:), ACCX_Index, ACCY_Index, ACCZ_Index, Freq_Index, Nw, fs, N, NO_FRS);
         Y = net_init( FRS );
         Y = Y' - 0.7*(Suspicious_Freq > 600 | Suspicious_Freq < 250); 
         [~, max_indice] = sort(Y(:,1), 'descend');
         Freq_Index(Nw) = Suspicious_Freq(max_indice(1));                           
     else  
     while 1  
         [Suspicious_Freq, FRS, ACCX_Index, ACCY_Index, ACCZ_Index] = FEATURES( BP_PPG1(Nw,:), BP_PPG2(Nw,:), BP_ACCX(Nw,:), ...            
                BP_ACCY(Nw,:), BP_ACCZ(Nw,:), ACCX_Index, ACCY_Index, ACCZ_Index, Freq_Index, Nw, fs, N, NO_FRS);  
         Y = net_1( FRS );
         Y = Y';
                    
         [ Exit, Freq_Index, State, BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ ] = ...
             Enhancement( Y, FRS, Suspicious_Freq, State, ...
             BP_PPG1, BP_PPG2, BP_ACCX, BP_ACCY, BP_ACCZ, Freq_Index, Nw, N, fs, M );            
         
         if ((State(Nw) == 0 && abs(Freq_Index(Nw) - Freq_Index(Nw-1)) <= 60) || ...
                 (State(Nw) == 1 && abs(Freq_Index(Nw) - Freq_Index(Nw-1)) <= 75) || ... %75 baraye data 10 , 2
                 (State(Nw) == 2 && abs(Freq_Index(Nw) - Freq_Index(Nw-1)) <= 60)) && Exit == 1
             break;
         elseif Freq_Index(Nw) ~= 0 && abs(Freq_Index(Nw-1) - Freq_Index(Nw)) > 60 && Exit == 1 && State(Nw) == 0
             BP_PPG1(Nw,:) = Band_Pass(BP_PPG1(Nw,:), fs, M, mean([Freq_Index(Nw-1), Freq_Index(Nw-2)]));                
             BP_PPG2(Nw,:) = Band_Pass(BP_PPG2(Nw,:), fs, M, mean([Freq_Index(Nw-1), Freq_Index(Nw-2)]));
             State(Nw) = 1;
         elseif  Freq_Index(Nw) ~= 0 && (abs(Freq_Index(Nw-1) - Freq_Index(Nw)) > 75 && State(Nw) == 1) && Exit == 1
                 BP_PPG1(Nw,:) = BP_PPG1 (Nw,:) + BP_PPG1 (Nw-1,:) + BP_PPG1 (Nw-2,:);             
                 BP_PPG2(Nw,:) = BP_PPG2 (Nw,:) + BP_PPG2 (Nw-1,:) + BP_PPG1 (Nw-2,:);
                 State(Nw) = 2;
         elseif  State(Nw) == 2 
                Freq_Index(Nw) = mean([Freq_Index(Nw-1),Freq_Index(Nw-2)]);             
                break;             
         end
     end
     Freq_Index(Nw) = max(min(Freq_Index(Nw), ...             
                Freq_Index(Nw-1)+7/60/fs*N),Freq_Index(Nw-1)-7/60/fs*N);                         
     end
%      Freq_Index(Nw)     
end
RunTime(k) = toc/windows_NO*1000;
MAE(k) = mean(abs((Freq_Index(min_window:windows_NO)-1)/N*fs*60 - BPM0(min_window:windows_NO)'));
end
RunTime_ALL = sum(RunTime)/length(RunTime);
MAE_ALL = sum(MAE)/length(MAE);
RunTime(14:24) = RunTime(13:23);
RunTime(13) = sum(RunTime(1:12))/12;
MAE(14:24) = MAE(13:23);
MAE(13) = sum(MAE(1:12))/12;
MAE(end+1) = MAE_ALL;
RunTime(end+1) = RunTime_ALL;
file_name_1(14:24) = file_name_1(13:23);
file_name_1(13) = {'BenchmarkDataset'};
file_name_1(end+1) = {'AllDatasets'};
T = table(RunTime,MAE,'RowNames',file_name_1);
T.Properties.VariableUnits = {'ms' 'BPM'};
T.Properties.VariableNames{'RunTime'} = 'PerFrameRunTime';
T



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

%% PARAMETERS
Start = 1;
NO_FRS = 30;%# of features
N = 2^15; %# of fft points
fs = 125; % sampling frequency

step_second = 2; %slide of signal window in second
overlap_second = 6; % window's overlap in second

step_length = step_second * fs;
overlap_length = overlap_second * fs;

M = overlap_length + step_length;

File_NAMES = cell(1,20);

%% LOADING DATA
Signal_NAMES = [{'DATA_S04_T01'}, {'TEST_S01_T01'}, {'TEST_S02_T01'}, {'TEST_S02_T02'}, {'TEST_S03_T02'}, {'TEST_S04_T02'}, ...
    {'TEST_S05_T02'}, {'TEST_S06_T01'}, {'TEST_S06_T02'}, {'TEST_S07_T02'}, {'TEST_S08_T01'}];
BPM_NAMES = [{'BPM_S04_T01'}, {'True_S01_T01'}, {'True_S02_T01'}, {'True_S02_T02'}, {'True_S03_T02'}, {'True_S04_T02'}, ...
    {'True_S05_T02'}, {'True_S06_T01'}, {'True_S06_T02'}, {'True_S07_T02'}, {'True_S08_T01'}];
for k = 1:23
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
    file_name_1 = strcat('DATA_', prefix, number, '_TYPE0', mode);
    load(file_name_1);
    file_name_2 = strcat(file_name_1, '_BPMtrace');    
    load(file_name_2);
    else
        model = 2;
        file_name_1 = Signal_NAMES{k-12};
        load(file_name_1);
        file_name_2 = BPM_NAMES{k-12};
        load(file_name_2);       
    end
    
%% CONSTANTS
windows_NO = floor((size(sig, 2) - overlap_length) / step_length);
ACCX_Index = zeros(1, windows_NO);
ACCY_Index = zeros(1, windows_NO);
ACCZ_Index = zeros(1, windows_NO);

min_window = 4;

%% Defining
ECG = zeros(windows_NO, M);BP_ECG = zeros(windows_NO, M);
PPG1 = zeros(windows_NO, M);PPG2 = zeros(windows_NO, M);BP_PPG1 = zeros(windows_NO, M);BP_PPG2 = zeros(windows_NO, M);
ACCX = zeros(windows_NO, M);ACCY = zeros(windows_NO, M);ACCZ = zeros(windows_NO, M);
BP_ACCX = zeros(windows_NO, M);BP_ACCY = zeros(windows_NO, M);BP_ACCZ = zeros(windows_NO, M);

%% MAIN PROGRAM
%% TIME-WINDOW SIGNALS
for Nw = min_window : windows_NO  
    [ECG(Nw,:), PPG1(Nw,:), PPG2(Nw,:), ACCX(Nw,:), ACCY(Nw,:), ACCZ(Nw,:)] = ... 
        signal_extraction(sig, Nw, step_length, M, model);
              
    %% Band Passing            
    [BP_ECG(Nw, :), BP_PPG1(Nw, :), BP_PPG2(Nw, :), BP_ACCX(Nw, :), BP_ACCY(Nw, :), BP_ACCZ(Nw, :)] = ...    
        signal_BandPassing( ECG(Nw,:), PPG1(Nw, :), PPG2(Nw, :),...
            ACCX(Nw, :), ACCY(Nw, :), ACCZ(Nw, :), fs, M, 0);    
     %% Feature Extraction
     [DELTA, FRS(:, Start:Start+length(DELTA)-1), ACCX_Index, ACCY_Index, ACCZ_Index] = ALL_Features( BP_PPG1(Nw,:), BP_PPG2(Nw,:), BP_ACCX(Nw,:), ...         
            BP_ACCY(Nw,:), BP_ACCZ(Nw,:), ACCX_Index, ACCY_Index, ACCZ_Index, BPM0/60/fs*N, Nw, fs, N, NO_FRS);         
                         
        Y(Start:Start+length(DELTA)-1, :) = Class_Allocation( DELTA, BPM0(Nw)/60/fs*N );
        Window_Number(Start:Start+length(DELTA)-1) = Nw:Nw+length(DELTA)-1;
        for j = 1:length(DELTA)
            File_NAMES {Start+j-1} = file_name_1 ;
        end        
        Start = Start+length(DELTA);
end

end

save('DATA_Neural');
save ('Features and Class' , 'FRS', 'Y')

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
clear; clc; close all;
load( 'Features and Class' )
Y = (Y(:,1) == 1); 
J = zeros(1,size(FRS,1));
%% Feature Selection
Y_new = Y';
for i = 1:size(FRS,1)
    mu0 = mean(FRS(i,:));
    mu1 = mean(FRS(i,Y_new(1,:) == 1));
    mu2 = mean(FRS(i,Y_new(1,:) ~= 1));
    variance1 = var(FRS(i,Y_new(1,:) == 1));
    variance2 = var(FRS(i,Y_new(1,:) ~= 1));
    J(i) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (variance1+variance2);
end

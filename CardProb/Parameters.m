function [ Params ] = Parameters(Params)
% % Setup.m *****************************************************
%
%   Description:
%       Creates Parameters 
%
%   Output: Params
%   
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/09/15
%
%******************************************************************
%
% Dependencies:
%    NONE
%
% Used By:
%   StaglinPTB
%
%******************************************************************


%%%%%%%%%%%%%%%%
% Description %
%%%%%%%%%%%%%%%
Params.LabGroup = 'SBOOK';
Params.ExperimentName = 'fMRI_CardProb';
Params.ExperimentPurpose = 'Cue ITI Guess Outcome Feedback ITI';


%%%%%%%%%%%%
% Hardware %
%%%%%%%%%%%%
%Params.MonitorType = 'Projector'; % 'Goggles';
%     if strcmpi(Params.Design, 'Projector') == 1
%         MonitorType = 0;
%     elseif strcmpi(Params.Design, 'Goggles') == 1
%         MonitorType = 1;
%     end

%% Constants
Params.Constants.SSE = 0; % Location in deg of left screen center wrt the
                   % test subject's fixation
Params.Constants.ESE = 0; % Location in deg of Right screen center wrt the
                   % Experimenter's fixation
Params.Constants.XOffset = 0; % horizontal stimulus position 
                       % (-)left, (+)right
Params.Constants.YOffset = 0; % vertical stimulus position
                       % (-)up, (+)down
Params.Constants.Computer = Screen('Computer'); % Get The Computer ID
Params.Constants.PTBVersion = Screen('Version'); % Get The PTB Version

Params.DrawFixationPt = 1; % 1 = On, 0 = Off
Params.RTA = 0; %Real Time Analysis 1 = On, 0 = Off
Params.UseOneMonitor = 1; % Only use 1 monitor otherwise 
                          % use 2 if available and not in TestMode


%%%%%%%%%%
% TIMING %
%%%%%%%%%%
% Design Choice
%% BLOCK OR JITTER
Params.DesignType = 'Block'; 
%Params.DesignType = 'Jitter';

switch Params.DesignType
    % Block
    case 'Block'
        Params.Time.BlockLength = 10; % Block Durrantion in sec 
        Params.Time.BlockLengthMax = 'N/A';
        Params.Time.BlockLengthMin = 'N/A';
        Params.Time.ISILength   = 5; % Inter-Stimulus interval in sec
    % Jitter
    case 'Jitter'
        Params.BlockLength = 'N/A';
        Params.BlockLengthMax = 30; % Max Block Durrantion (sec)
        Params.BlockLengthMin =  5; % Min Block Durrantion (sec)
        Params.ISILength = 10; % Inter-Jitter Block interval in sec
        Params.ISIMax = 5; % Max Inter-Stimulus interval (sec)
        Params.ISIMin = 1; % Min Inter-Stimulus interval (sec)
end

% Information
Params.NumberofRuns = 10;
Params.NumberofTrial = 12;
Params.MoneyReward = '1.00';
Params.MoneyPunish = '0.50';
Params.StartingMoney = '10';

% Timing
Params.Timing.Cue = 1.5;
Params.Timing.ITI1 = 10.5;
Params.Timing.Guess = 2.5;
Params.Timing.Outcome = 0.5;
Params.Timing.Feedback = 0.5;
Params.Timing.ITI2 = 11.5;
                          
% Cue Data
Params.TotalCue1 = 24;
Params.TotalCue2 = 24;
Params.TotalCue3 = 24;
Params.TotalCue4 = 24;
Params.TotalCue5 = 24;
Params.TotalTrials = 120;

Params.Cue1 = '@';
Params.Cue1Weight = 100;
Params.Cue2 = '#';
Params.Cue2Weight = 0;
Params.Cue3 = '%';
Params.Cue3Weight = 66;
Params.Cue4 = '&';
Params.Cue4Weight = 33;
Params.Cue5 = '^';
Params.Cue5Weight = 50;

Params.CueQuestion = '?';


% Card Data
Params.CardRatio = 4;
Params.CardSize = 1/24;
Params.CardBackground = [ 0 0 0 ]; 

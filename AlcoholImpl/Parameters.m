function Params = Parameters(TestMode, TestSubject)
%******************************************************************
%
% Description:
%   [ Parameters ] loads parameters!
%
% Inputs:
%   [TestMode] {Integer}
%       1 = Test Trial
%       0 = Real Trial
%   [TestSubject] {String}
%       Test Subject Name/ID for filename save.
%
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/06/05
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

%%%%%%%%%
% Setup %
%%%%%%%%%
Params.ExperimentName = 'fMRI_AlcoholImpTask';
Params.TestSubject = TestSubject;

% Design Choice
Params.Design = 'Block'; 
if strcmpi(Params.Design, 'Block') == 1
    Params.DesignType = 0;
elseif strcmpi(Params.Design, 'Jitter') == 1
    Params.DesignType = 1;
end

switch Params.DesignType
    % Block
    case 0
        Params.BlockLenght = 10; % Block Durrantion in sec 
        Params.BlockLenghtMax = 'N/A';
        Params.BlockLenghtMin = 'N/A';
        Params.ISILenght   = 5; % Inter-Stimulus interval in sec
        Params.ISIMax = 'N/A';
        Params.ISIMin = 'N/A';
    % Jitter
    case 1
        Params.BlockLenght = 'N/A';
        Params.BlockLenghtMax = 30; % Max Block Durrantion (sec)
        Params.BlockLenghtMin =  5; % Min Block Durrantion (sec)
        Params.ISILenght = 10; % Inter-Jitter Block interval in sec
        Params.ISIMax = 5; % Max Inter-Stimulus interval (sec)
        Params.ISIMin = 1; % Min Inter-Stimulus interval (sec)
end


%%%%%%%%%%%%
% Hardware %
%%%%%%%%%%%%
Params.MonitorType = 'Projector'; % 'Goggles';
%     if strcmpi(Params.Design, 'Projector') == 1
%         MonitorType = 0;
%     elseif strcmpi(Params.Design, 'Goggles') == 1
%         MonitorType = 1;
%     end
Params.DrawFixationPt = 1; % 1 = On, 0 = Off
Params.RTA = 0; %Real Time Analysis 1 = On, 0 = Off
Params.UseOneMonitor = 1; % Only use 1 monitor otherwise 

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



%%%%%%%%%%
% OUTPUT %
%%%%%%%%%%
% Establish Output Files
Params.Data_DIR = 'LOG/';
Params.Backup_Data_DIR = ''; 
Params.Filename  = [ Params.ExperimentName, '_', ...
             datestr(now,'yyyymmdd_HHMMSS'), '_Subject_', TestSubject];
%%%%%%%%%%
% TIMING %
%%%%%%%%%%
Params.Timing.Intro = 10;
Params.Timing.Intro = 2;
Params.Timing.ResponseTime = 5;
Params.Timing.ResponseTime = 2;
Params.Timing.CorrectionTime = 5;
Params.Timing.CorrectionTime = 2;

%%%%%%%%%%%%%
% TASK DATA %
%%%%%%%%%%%%%
Params.Task = {}

% Task 1
Params.Task{1}.Intro = 'If the center word belongs to a category on the left, press the Leftmost Button. If the center word belongs to a category on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key.'
Params.Task{1}.LeftWord = 'Soda';
Params.Task{1}.RightWord = 'Alcohol';
Params.Task{1}.LeftLeaningWord = {  'Coke'; 
                                    'Cassis'; 
                                    'Sinas';
                                    'Spa';
                                    'Tonic';
                                    'Juice' };

Params.Task{1}.RightLeaningWord = { 'Beer';
                                    'Wine';
                                    'Port';
                                    'Whisky';
                                    'Vodka';
                                    'Rum' };
                                    
% Task 2
Params.Task{2}.Intro = 'If the center word belongs to a category on the left, press the Leftmost Button. If the center word belongs to a category on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key.'
Params.Task{2}.LeftWord = 'Positive';
Params.Task{2}.RightWord = 'Negative';
Params.Task{2}.LeftLeaningWord = {  'Sociable'; 
                                    'Good'; 
                                    'Pleasant';
                                    'Nice';
                                    'Enjoyable';
                                    'Sympathetic' };

Params.Task{2}.RightLeaningWord = { 'Antisocial';
                                    'Bad';
                                    'Unpleasant';
                                    'Stupid';
                                    'Obnoxious';
                                    'Tedious' };
% Task 3 
Params.Task{3}.Intro = 'If the center word belongs to a categories on the left, press the Leftmost Button. If the center word belongs to a categories on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key'
Params.Task{3}.LeftWord = 'Soda/Positive';
Params.Task{3}.RightWord = 'Alcohol/Negative';
Params.Task{3}.LeftLeaningWord = ...
    [ Params.Task{1}.LeftLeaningWord; Params.Task{2}.LeftLeaningWord ];
Params.Task{3}.RightLeaningWord = ...
    [ Params.Task{1}.RightLeaningWord; Params.Task{2}.RightLeaningWord ];

% Task 4 
Params.Task{4}.Intro = 'Sort the same categories again.'
Params.Task{4}.LeftWord = 'Soda/Positive';
Params.Task{4}.RightWord = 'Alcohol/Negative';
Params.Task{4}.LeftLeaningWord = ...
    [ Params.Task{1}.LeftLeaningWord; Params.Task{2}.LeftLeaningWord ];
Params.Task{4}.RightLeaningWord = ...
    [ Params.Task{1}.RightLeaningWord; Params.Task{2}.RightLeaningWord ];

% Task 5
Params.Task{5}.Intro = 'If the center word belongs to a category on the left, press the Leftmost Button. If the center word belongs to a category on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key.'
Params.Task{5}.LeftWord = 'Alcohol';
Params.Task{5}.RightWord = 'Soda';
Params.Task{5}.LeftLeaningWord = Params.Task{1}.RightLeaningWord;
Params.Task{5}.RightLeaningWord = Params.Task{1}.LeftLeaningWord;

% Task 6
Params.Task{6}.Intro = 'If the center word belongs to a category on the left, press the Leftmost Button. If the center word belongs to a category on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key.'
Params.Task{6}.LeftWord = 'Negative';
Params.Task{6}.RightWord = 'Postive';
Params.Task{6}.LeftLeaningWord = Params.Task{2}.RightLeaningWord;
Params.Task{6}.RightLeaningWord = Params.Task{2}.LeftLeaningWord;

% Task 7 
Params.Task{7}.Intro = 'The Categoies have new configuration. \nIf the center word belongs to a categories on the left, press the Leftmost Button. If the center word belongs to a categories on the right, press the Rightmost Button. If you make an error, an X will appear - fix it by pressing the other key'
Params.Task{7}.LeftWord = 'Alcohol/Positive';
Params.Task{7}.RightWord = 'Soda/Negative';
Params.Task{7}.LeftLeaningWord = ...
    [ Params.Task{1}.RightLeaningWord; Params.Task{2}.LeftLeaningWord ];
Params.Task{7}.RightLeaningWord = ...
    [ Params.Task{1}.LeftLeaningWord; Params.Task{2}.RightLeaningWord ];

% Task 8 
Params.Task{8}.Intro = 'Sort the same categories again.'
Params.Task{8}.LeftWord = 'Alcohol/Positive';
Params.Task{8}.RightWord = 'Soda/Negative';
Params.Task{8}.LeftLeaningWord = ...
    [ Params.Task{1}.RightLeaningWord; Params.Task{2}.LeftLeaningWord ];
Params.Task{8}.RightLeaningWord = ...
    [ Params.Task{1}.LeftLeaningWord; Params.Task{2}.RightLeaningWord ];


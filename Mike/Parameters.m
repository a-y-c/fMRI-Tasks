function Params = Parameters
%
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/09/15
%
%******************************************************************
%
% Description:
%   [ Parameters ] loads parameters!
%
% Dependencies:
%    NONE
%
% Used By:
%   StaglinPTB
%******************************************************************


%%%%%%%%%%%%%%%%
% Description %
%%%%%%%%%%%%%%%
Params.LabGroup = 'SBOOK';
Params.ExperimentName = 'fMRI_3Picture';
Params.ExperimentPurpose = 'Picture Picture Picture Rest';
Params.TestSubject = TestSubject;

% Design Choice
Params.Design = 'Jitter'; 

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
Params.DrawFixationPt = 1; % 1 = On, 0 = Off
Params.RTA = 0; %Real Time Analysis 1 = On, 0 = Off
Params.UseOneMonitor = 1; % Only use 1 monitor otherwise 
                          % use 2 if available and not in TestMode
                          


%%%%%%%%%%%%
% Hardware %
%%%%%%%%%%%%
Params.MonitorType = 'Projector'; % 'Goggles';
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



%%%%%%%%%%
% OUTPUT %
%%%%%%%%%%
%% Establish Output Files
Params.Filename  = [ Params.ExperimentName, '_', ...
             datestr(now,'yyyymmdd_HHMMSS'), '_Subject_', TestSubject];
Params.Data_DIR = '';
Params.Backup_Data_DIR = ''; 



%%%%%%%%%%%%%
% TASK DATA %
%%%%%%%%%%%%%
% Trials (Percentage)
Params.TotalTrials = 20;
Params.VerticalTrials = 10;
Params.HorizontalTrials = 10;
Params.VerticalGo = .80;
Params.VerticalNoGo = .20;
Params.HorizontalGo = .20;
Params.HorizontalNoGo = .80;

% Timing (Seconds)
Params.Time.FixToCueMin = .1;
Params.Time.FixToCueMax = .5;
Params.Time.CueToStimMin = .1;
Params.Time.CueToStimMax = .5;
Params.Time.StimToFixMin = .1;
Params.Time.StimtoFixMax = .3;
Params.Time.ResponseMax = 1; 

% Rectangle Information
Params.Rectangle.Color.blue = [ 0 0 255 ];
Params.Rectangle.Color.green = [ 0 128 0 ];
Params.Rectangle.Color.white = [ 255 255 255 ];
Params.Rectangle.Color.black = [ 0 0 0 ];
Params.Rectangle.ScreenMultiplier = 1/12;
Params.Rectangle.RatioLength = 5;

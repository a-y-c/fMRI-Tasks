function Params = Parameters(TestMode, TestSubject, TaskNumber, Params )
%
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/06/05
%
%******************************************************************
%
% Description:
%   [ Parameters ] loads parameters!
%   Mainly used for fMRI Language Task.
%
% Inputs:
%   [TestMode] {Integer}
%       1 = Test Trial
%       0 = Real Trial
%   [TestSubject] {String}
%       Test Subject Name/ID for filename save.
%
%
% Dependencies:
%    NONE
%
% Used By:
%   StaglinPTB
%******************************************************************
%

%%%%%%%%%%%%%%%%
% Description %
%%%%%%%%%%%%%%%
Params.LabGroup = 'SBOOK';
Params.ExperimentName = 'fMRI-Lang_V.2';
Params.ExperimentPurpose = 'Language Comprehension and Production';
Params.ExperimentTask = '4 Blocks at 195 Seconds';
Params.TestSubject = TestSubject;

% Design
Params.Design = 'Block'; % 'Jitter'; % 
if strcmpi(Params.Design, 'Block') == 1
    Params.DesignType = 0;
elseif strcmpi(Params.Design, 'Jitter') == 1
    Params.DesignType = 1;
end

switch Params.DesignType
    case 0
        Params.BlockLenght = 10; % Block Durrantion in sec 
                                 % (May not be used)
        Params.BlockLenghtMax = 'N/A';
        Params.BlockLenghtMin = 'N/A';
        Params.ISILenght   = 5; % Inter-Stimulus interval in sec
        Params.ISIMax = 'N/A';
        Params.ISIMin = 'N/A';
    case 1
        Params.BlockLenght = 'N/A';
        Params.BlockLenghtMax = 30; % Max Block Durrantion (sec)
        Params.BlockLenghtMin =  5; % Min Block Durrantion (sec)
        Params.ISILenght = 10; % Inter-Jitter Block interval in sec
        Params.ISIMax = 5; % Max Inter-Stimulus interval (sec)
        Params.ISIMin = 1; % Min Inter-Stimulus interval (sec)
end
Params.DrawFixationPt = 1; % 1 = On, 0 = Off
Params.RTA = 1; %Real Time Analysis 1 = On, 0 = Off
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
Constants.SSE = 0; % Location in deg of left screen center wrt the
                   % test subject's fixation
Constants.ESE = 0; % Location in deg of Right screen center wrt the
                   % Experimenter's fixation
Constants.XOffset = 0; % horizontal stimulus position 
                       % (-)left, (+)right
Constants.YOffset = 0; % vertical stimulus position
                       % (-)up, (+)down
Constants.Computer = Screen('Computer'); % Get The Computer ID
Constants.PTBVersion = Screen('Version'); % Get The PTB Version
Params.Constants = Constants;



%%%%%%%%%%%%%%%%
% EEG SETTINGS %
%%%%%%%%%%%%%%%%
% Ignore.
Params.EEG = 0; % using the EGI EEG system Simultainiouly? 
                % No = 0 or Yes = 1
Params.DAQ = 0; % using the Arduino DAQ? No = 0 or Yes = 1
Params.NetStationPort = 55513; % Net Station Port ID
Params.NetStationIP = '169.254.223.206'; % Net Station IP

% TScode | Event
Params.TScodeIDTable = {...
  ['   0 | EEG Recording Start'];...
  ['  -2 | EEG Recording End'];...
  ['   1 | Scan Begins (First TR recorded)'];...
  ['  -1 | Matlab Stops Recording Events'];...
  ['   2 | Subject Press Button For Experiment to Begin'];...
  ['   3 | Block Starts'];...
  ['   4 | Block Ends'];...
  ['   5 | Trial Text Displayed'];...
  ['   6 | Trial Image Displayed'];...
  ['   7 | Trial Fixation Point Displayed'];...
  ['   8 | Subject Responce'];...
  ['  10 | Movie Frame Displayed']};


%%%%%%%%%%
% OUTPUT %
%%%%%%%%%%

%% Establish Output Files
Params.Data_DIR = 'LOG/';
Params.Backup_Data_DIR = '';

% Check if Log Directory Exist
dircheck = exist(Params.Data_DIR);
if dircheck ~= 7
    Params.Data_DIR = '';
end

Params.Filename  = [ Params.ExperimentName, '_', ...
            datestr(now,'yyyymmdd_HHMMSS'), 'Task', ...
            num2str(TaskNumber), ...
            '_Subject_', TestSubject];


switch Params.LabGroup
    case 'MSCOHEN'
        if IsWin
            data_folder = ' ';
            backup_data_folder = ' ';
        else
            data_folder = ' ';
            backup_data_folder = ' ';
        end
    case 'SBOOK'
        if IsWin
            data_folder = ' ';
            backup_data_folder = ' ';
        else
            data_folder = ' ';
            backup_data_folder = ' ';
        end    
end         

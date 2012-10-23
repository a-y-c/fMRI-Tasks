function [ Params ] = Setup
% % Setup.m *****************************************************
%
%   Description:
%       Setup Creates Parameters 
%       Ask:
%           Name/File Output
%           Input Device for Subject
%           Input Device for Researcher
%           
%
%   Output: Params
%   
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/10/08
%
%******************************************************************
%
% Dependencies:
%    NONE
%
% Used By:
%   StaglinPTB.m
%   
%******************************************************************


%% Display Warning Message
WarningMessages

%% Who is the Subject ?
if nargin < 1 
    Params.Subject.Name = input('Who is the Test Subject? Ex: JD ==> ', 's');
else
    Params.Subject.Name = '';
end

%% Test Mode?
if isempty(Params.Subject.Name)
    Params.TestMode = 1;
    disp('***** Test mode enabled. No data saving. *****')   
else
    Params.TestMode = 0;
end


% Input device for subject
[Params.Subject.HID PARAMS.Subject.HID_Descrip] = hid_probe('subject');

% Input device for researcher
[Params.Researcher.HID PARAMS.Researcher.HID_Descrip] = hid_probe('researcher');


%% Display Warning Message
%%%% (NAR)
function WarningMessages
    fprintf('\n\n');
    fprintf('****************\n');
    fprintf('** WARNING!!! **\n');
    fprintf('****************\n');
    fprintf('Make sure that you have set the subject response box to read inputs properly.\n');
    fprintf('It must be on the mode for button presses resulting in 12345. (USB NAR 12345)\n\n');
    fprintf('Press ESACPE to acknowledge this message.\n\n');

    [junk keyCode] = KbPressWait();
    while( ~strcmp('ESCAPE', KbName(keyCode)) )
        [junk keyCode] = KbPressWait();
    end  
end

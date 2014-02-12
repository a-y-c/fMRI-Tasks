function [ Keys ] = InitiateKeys
% % Keys.m *********************************************************
%
%   Description:
%       InitiatecKeys Creates Keys 
%
%   Output: Keys 
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
%   Paradigm.m
%   
%******************************************************************


Keys.space=KbName('SPACE');
Keys.esc=KbName('ESCAPE');
Keys.right=KbName('RightArrow');
Keys.left=KbName('LeftArrow');
Keys.up=KbName('UpArrow');
Keys.down=KbName('DownArrow');
Keys.shift=KbName('RightShift');

Keys.OKKey = KbName('p');
Keys.KillKey = KbName('k');
Keys.TRKey1 = KbName('t'); % TR signal key
Keys.TRKey2 = KbName('5'); % TR signal key
Keys.TRKB = KbName('5%');  % Keyboard TR

Keys.KB1 = KbName('1!');   % Keyboard 1
Keys.KB2 = KbName('2@');   % Keyboard 1
Keys.KB3 = KbName('3#');   % Keyboard 1
Keys.KB4 = KbName('4$');   % Keyboard 1

Keys.BB1 = KbName('1');    % Button Box 1
Keys.BB2 = KbName('2');    % Button Box 2
Keys.BB3 = KbName('3');    % Button Box 3
Keys.BB4 = KbName('4');    % Button Box 4




% Code to be used to later on diable the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([KbName('T'), KbName('5')])

% Code to be used to later on restore the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([])
end

function [ Task ] = LoadData 

% % LoadData *****************************************************
%
%	Description:
%   	Loads Data (sentences, pictures) to be used for each Task
%       SOUND WILL LOAD/DISPLAY IN ALPHABETICAL ORDER
%           So please rename them accordingly
%       WAV FILES ONLY!!!!
%
%	Output: Task
%       SongList
%       SougFreq
%       Channel
%       TotalBlock
% 	
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/05/08
%
%******************************************************************
%
% Used By:
%	StaglinPTB.m
% 	
%******************************************************************

% Warning
disp( '**** WARNING. ONLY WAVE FILES WILL BE LOADED ****')
% Location of Directory that contains the Sound
SoundPath = 'Sound/'; 

% Listing Picture Files
SoundFiles = dir(SoundPath);

% Loop/Loading Pictures
counter = 0;
for i=1:size(SoundFiles,1)

    % load only if the file is a supported image format
    [pathstr, name, ext] = fileparts(SoundFiles(i).name);

    if ((strcmpi(ext, '.wav') == 1) || ...
        (strcmpi(ext, '.WAV') == 1) || ...
        (regexpi(name, '._') ~= 1 ))

         disp ( SoundFiles(i).name )
         counter = counter+1;

        [ Task.SongList{counter}, Task.SongFreq{counter}, ...
            Task.SongBits ] = ...
            wavread([folder, '/', Files(i).name]); 
        Task.Channel{counter} = size(Task.SongList{counter}',1);

    end
end

Task.TotalBlocks = counter/3;

% To Be Save as .mat (data) files for Faster 
save( 'Task_Data', 'Task' )



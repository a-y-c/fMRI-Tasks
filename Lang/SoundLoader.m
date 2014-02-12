function [ SongList, SongFreq, Channel ] = SoundLoader( folder, TaskNumber, Block )
% Images = SoundLoader(folder, WB) ********************************
%
%	Description:
%		Loads Sound into Memory
%
%	Inputs:
% 		folder = Directory where images to be loaded are located
% 		TaskNumber = Task Number
% 		Block = Block Number
%
%	Outputs:
% 		SongList:  is a cell of all the images in the directory.
% 		SongFreq: is a cell of all the corresponding image file names
%             in the directory.
%		Channel: is cell corresponding to how many channels (usually one)
%
% 	Note: 
%		Only image formates supported by imread will be loaded (WAV) 
%
%******************************************************************
%
% This program was written by Andrew Cho
% Last Modified 2012/05/09
%
%******************************************************************
%
%	Dependencies:
%		NONE
%	Used By:
%		LoadData.m
%
%******************************************************************


%% Figure out all the files in the folder
if ( Block == 0 )
    Files = dir ([folder, '/*']); 
else    
    Files = dir ([folder, '/', num2str(TaskNumber), num2str(Block),  '*' ]);
end

counter = 0;
for i=1:size(Files,1)
    
    % load only if the file is a supported wav format
    [pathstr, name, ext] = fileparts(Files(i).name);
   
    if (strcmpi(ext, '.wav') == 1)

		disp ( Files(i).name )
        counter = counter+1; 
        [ SongList{counter}, SongFreq{counter}, SongBits ] = ...
            wavread([folder, '/', Files(i).name]); 
        Channel{counter} = size(SongList{counter}',1);
    end    
end


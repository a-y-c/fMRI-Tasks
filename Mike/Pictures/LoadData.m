function [ Task ] = LoadData 

% % LoadData *****************************************************
%
%	Description:
%   	Loads Data (sentences, pictures) to be used for each Task
%       PICTURES WILL LOAD/DISPLAY IN ALPHABETICAL ORDER
%           So please rename them accordingly
%
%	Output: Task
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

% Location of Directory that contains the picture
PicturesPath = 'Pictures/'; 

% Listing Picture Files
PictureFiles = dir(PicturePath);

% Loop/Loading Pictures
counter = 0;
for i=1:size(PictureFiles,1)

    % load only if the file is a supported image format
    [pathstr, name, ext] = fileparts(PictureFiles(i).name);

    if ((strcmpi(ext, '.bmp') == 1) || ...
        (strcmpi(ext, '.cur') == 1) || ...
        (strcmpi(ext, '.gif') == 1) || ...
        (strcmpi(ext, '.hdf4')== 1) || ...
        (strcmpi(ext, '.ico') == 1) || ...
        (strcmpi(ext, '.jpg') == 1) || ...
        (strcmpi(ext, '.jpeg') == 1) || ...
        (strcmpi(ext, '.pbm') == 1) || ...
        (strcmpi(ext, '.pcx') == 1) || ...
        (strcmpi(ext, '.pgm') == 1) || ...
        (strcmpi(ext, '.png') == 1) || ...
        (strcmpi(ext, '.ppm') == 1) || ...
        (strcmpi(ext, '.ras') == 1) || ...
        (strcmpi(ext, '.tiff')== 1) || ...
        (strcmpi(ext, '.xwd') == 1) && ...
        (regexpi(name, '._') ~= 1 ))

         disp ( PictureFiles(i).name )
         counter = counter+1;
         Task.Images{counter} = imread([folder, '/', PictureFiles(i).name]);
         Task.ImageNames{counter} = PictureFiles(i).name;
         Task.ImageSize{counter} = size(Images{counter});
    end
end

Task.TotalBlocks = counter/3;

% To Be Save as .mat (data) files for Faster 
save( 'Task_Data', 'Task' )


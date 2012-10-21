function [Images, ImageNames, ImageSize] = ImageLoader(folder,  TaskNumber, Block)
% Images = ImageLoader(folder, WB) ********************************
%
%	Description:
%		Loads Images into Memory
%
%	Output:
% 		folder = Directory where images to be loaded are located
% 		WB = Disply Wait Bar Yes == 1, No == 0 (Default)
%
% 		Images:  is a cell of all the images in the directory.
% 		ImageNames: is a cell of all the coresonding image file names
%             in the directory.
%
% 	Note: 
%		only image formates supported by imread will be loaded 
%
%******************************************************************
%
% This program was written by Andrew Cho
% Last Modified 2012/05/09
% This program was written by Cameron Rodriguez
% Last Modified 2012/02/07
%
%******************************************************************
%
%	Dependencies:
%		NONE
%	Used By:
%		LoadData.m
%
% 	see also: DicomIndexer, DicomLoader, imread
%
%******************************************************************

WB = 0;
Images = {};
ImageNames = {};
ImageSize = {};

%% Figure out all the files in the folder
if ( Block == 0 ) 
    Files = dir ([folder, '/*']); 
else 
    Files = dir ([folder, '/', num2str(TaskNumber), num2str(Block),  '*' ]);
end
%% Load the images

if WB == 1
    h = waitbar(0,{['Loading Images in Directory:']; [folder]});
end

counter = 0;
for i=1:size(Files,1)
    
    % load only if the file is a supported image format
    [pathstr, name, ext, versn] = fileparts(Files(i).name);
   
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
		
         disp ( Files(i).name )  
         counter = counter+1;        
         Images{counter} = imread([folder,'/',Files(i).name]);
         ImageNames{counter} = Files(i).name;
         ImageSize{counter} = size(Images{counter});
         %save(ImageNames)
    end
    
    if WB == 1
        % Change the Waitbar
        if mod(i,5) == 0
            waitbar((i)/size(Files,1), h)
        end
    end
    
end

if WB == 1
    close(h)
end

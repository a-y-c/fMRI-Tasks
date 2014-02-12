function Boolian = isEven(number)
%**************************************************************************
%
% Boolian = isEven(number)
%
%**************************************************************************
%
% isEven returns a boolian value for the imput being an even number of not
%
%**************************************************************************
%
% The Variables are as follows:
%
% Number: The number to be determined if is an Odd number
%         Number can be a scalar, 1D or 2D vector
%
% Boolian = 1 if the number is an Even Number,  = 0 otherwise
%
%**************************************************************************
%
% This program was written by Cameron Rodriguez
%
% Last Modified 10/29/2010
%
%**************************************************************************
%
% See also isOdd
%
%**************************************************************************

Size = size(number);

for i=1:Size(1)
    for j=1:Size(2)
        if (floor(number(i,j)/2) == (number(i,j)/2)) %isEven(number)
            Boolian(i,j) = 1;
        else
            Boolian(i,j) = 0;
        end
    end
end
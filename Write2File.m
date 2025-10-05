function Write2File(title, filePath, data)
%WRITE2FILE Summary of this function goes here
%   Detailed explanation goes here
% Open a file for writing
file = fopen(filePath, 'a+'); 

% Check if file opened successfully
if file == -1
    error('File could not be opened.');
end

% Write data to file
fprintf(file, title); % Header
fprintf(file, '%f\n', data); % Data (transposed for row-wise printing) %f\t

% Close the file
fclose(file);
end


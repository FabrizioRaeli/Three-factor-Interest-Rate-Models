function [dates, MID_rates] = readExcel(filename)
% function that imports our Excel Data in a Matlab matrix for the swap
% rates and a vector for the dates in a numerical form

dates = table2array(readtable(filename,'Range','A3:A185'));
dates = datenum(dates);
MID_rates = readmatrix(filename,'Range','B3:K185');

end
%function to absorb the external temperature
%They are located in the file called 'temp_extern.txt'
%they start from the 10-11 am of 1/1 and conclude at 9-10 am of 1/1 the
%following year

fprintf('Reading file...\n');
a = importdata('temp_extern.txt');
hours = 365*24;

for i = 1 : hours
    Textern(i) = a(i);
end
clear a;
save('Textern','Textern');

fprintf('All is finished\n');
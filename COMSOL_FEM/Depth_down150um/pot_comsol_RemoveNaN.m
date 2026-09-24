clear all
close all

filename1 = 'pot_G1_S1_5um';
a=load(filename1+".txt");

a(isnan(a)) = 0;

filename2 = strcat('fem_',filename1,'.dat');
save(filename2, 'a', '-ascii');



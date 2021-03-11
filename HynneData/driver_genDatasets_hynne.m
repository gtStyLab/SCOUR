clc; clear; close all;

dataDir = 'odeData';

nTotal = 15;

for k = 1:nTotal
    k
    datasetNames{k} = wrapper_genOdeData_hynne(k,dataDir);
    
end


    

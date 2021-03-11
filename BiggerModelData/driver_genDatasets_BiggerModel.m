clc; clear; close all;

dataDir = 'odeData';

% 1) generate my hi-res datasets: see getParamsVecNum_BiggerModel.m for param vals
nTotal = 15;

for k = 1:nTotal
    k
    datasetNames{k} = wrapper_genOdeData_BiggerModel(k,dataDir);
    
end


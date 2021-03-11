clc; clear; close all;

dataDir = 'odeData';

% 1) generate my hi-res datasets: see getParamsVecNum_SmallerModel.m for param vals
nTotal = 15;

for k = 1:nTotal
    k
    datasetNames{k} = wrapper_genOdeData_SmallerModel(k,dataDir);
    
end


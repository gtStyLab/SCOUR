function wrapper_genNoisyData_autogen_3samples_multiDatasets(hiResDataFileName,nT,cov,rep)
% Generate noisy data for autogenerated training data

    % 1) Load in hiResDataFileName
    hiResData = load(hiResDataFileName);
    
    % Second '_' char should be the one at 'k-%02d_hiRes'
    idxEnd = strfind(hiResDataFileName,'_');
    loResDataFileNameStem = sprintf('%s_nT-%03d_cov-%02d',hiResDataFileName(1:idxEnd(end)-1),nT,cov);
    
    
    % 2) Interpolate to lo-res nT sampling
    timeVec = linspace(hiResData.tStart,hiResData.tEnd,nT+1);
    fluxTimeVec = timeVec(1:end-1)+0.5*diff(timeVec(1:2));
    % fluxTimeVec = timeVec;

    loResConcMatrix = interp1(hiResData.timeVec,hiResData.concMatrix,timeVec,'linear','extrap');
    loResFluxMatrix = interp1(hiResData.fluxTimeVec,hiResData.fluxMatrix,fluxTimeVec,'linear','extrap');
        
    
    loResData.tStart = hiResData.tStart;
    loResData.tEnd = hiResData.tEnd;
    loResData.nT = nT;
    if exist('hiResData.paramsVec')
        loResData.paramsVec = hiResData.paramsVec;
    end
    loResData.x0 = hiResData.x0;
    loResData.timeVec = timeVec;
    loResData.fluxTimeVec = fluxTimeVec;
    
    if contains(hiResDataFileName,'1contMet') && contains(hiResDataFileName,'Train')
        loResData.train_params_1contMet = hiResData.train_params_1contMet;
        loResData.train_true_regs_1contMet = hiResData.train_true_regs_1contMet;
    elseif contains(hiResDataFileName,'2contMet') && contains(hiResDataFileName,'Train')
        loResData.train_params_2contMet = hiResData.train_params_2contMet;
        loResData.train_true_regs_2contMet = hiResData.train_true_regs_2contMet;
        loResData.train_interaction_mets_2contMet = hiResData.train_interaction_mets_2contMet;
    elseif contains(hiResDataFileName,'3contMet') && contains(hiResDataFileName,'Train')
        loResData.train_params_3contMet = hiResData.train_params_3contMet;
        loResData.train_true_regs_3contMet = hiResData.train_true_regs_3contMet;
        loResData.train_interaction_mets_3contMet = hiResData.train_interaction_mets_3contMet;
    elseif contains(hiResDataFileName,'1contMet') && contains(hiResDataFileName,'Test')
        loResData.test_params_1contMet = hiResData.test_params_1contMet;
        loResData.test_true_regs_1contMet = hiResData.test_true_regs_1contMet;
    elseif contains(hiResDataFileName,'2contMet') && contains(hiResDataFileName,'Test')
        loResData.test_params_2contMet = hiResData.test_params_2contMet;
        loResData.test_true_regs_2contMet = hiResData.test_true_regs_2contMet;
        loResData.test_interaction_mets_2contMet = hiResData.test_interaction_mets_2contMet;
    elseif contains(hiResDataFileName,'3contMet') && contains(hiResDataFileName,'Test')
        loResData.test_params_3contMet = hiResData.test_params_3contMet;
        loResData.test_true_regs_3contMet = hiResData.test_true_regs_3contMet;
        loResData.test_interaction_mets_3contMet = hiResData.test_interaction_mets_3contMet;
    end
    
    % 3) Loop through for numSets noisy datasets
    for samp = 1:3

        % 3a) Add in noise: use noiseless data + random * cov 
        loResData.concMatrix = loResConcMatrix + loResConcMatrix .* (cov/100*randn(size(loResConcMatrix)));
        loResData.fluxMatrix = loResFluxMatrix + loResFluxMatrix .* (cov/101*randn(size(loResFluxMatrix)));

        % Guarantee we have no *negative* concentation values
        loResData.concMatrix(loResData.concMatrix<0) = 0;

        % First data point is always 'correct' and noiseless
        loResData.concMatrix(1,:) = loResData.x0;

        % v1 is fixed value, no noise added
        loResData.fluxMatrix(:,1) = loResFluxMatrix(:,1);

        % 3b) Save out this noisy dataset
        save(sprintf('%s_s%01d_rep-%03d.mat',loResDataFileNameStem,samp,rep),'-struct','loResData')
    end
        
end
% Autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_2contMet)

    tarFlux = regListIndex;
    met1 = train_interaction_mets_2contMet{regListIndex}(2)+3*(regListIndex-1);
    met2 = 1+3*(regListIndex-1);
    
    % Functionality feature
    [featureMatrix_AutoGenerateTrain_2contMet(1,regListIndex)] = feature_functionality_2contMet_noisy(autogen_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_2contMet(2,regListIndex)] = feature_surfaceFit_multiContMet_noisy(autogen_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Predict flux with machine learning
    featureMatrix_AutoGenerateTrain_2contMet(3,regListIndex) = feature_predictFlux_multiContMet_noisy(autogen_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
    
    % Hold 1 metabolite constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_2contMet(4,regListIndex)] = feature_hold1MetConstant_correlation_2contMet_noisy(autogen_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Hold 1 metabolite constant and fit curve
    [~, featureMatrix_AutoGenerateTrain_2contMet(5,regListIndex)] = feature_hold1MetConstant_curveFit_2contMet_noisy(autogen_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
end
featureMatrix_AutoGenerateTrain_2contMet_n = normalize(featureMatrix_AutoGenerateTrain_2contMet,2,'range');

% Second autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_meta_2contMet)

    tarFlux = regListIndex;
    met1 = train_interaction_mets_meta_2contMet{regListIndex}(2)+3*(regListIndex-1);
    met2 = 1+3*(regListIndex-1);
    
    % Functionality feature
    [featureMatrix_AutoGenerateTrain_meta_2contMet(1,regListIndex)] = feature_functionality_2contMet_noisy(autogen_meta_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_meta_2contMet(2,regListIndex)] = feature_surfaceFit_multiContMet_noisy(autogen_meta_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Predict flux with machine learning
    featureMatrix_AutoGenerateTrain_meta_2contMet(3,regListIndex) = feature_predictFlux_multiContMet_noisy(autogen_meta_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
    
    % Hold 1 metabolite constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_meta_2contMet(4,regListIndex)] = feature_hold1MetConstant_correlation_2contMet_noisy(autogen_meta_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

    % Hold 1 metabolite constant and fit curve
    [~, featureMatrix_AutoGenerateTrain_meta_2contMet(5,regListIndex)] = feature_hold1MetConstant_curveFit_2contMet_noisy(autogen_meta_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
end
featureMatrix_AutoGenerateTrain_meta_2contMet_n = normalize(featureMatrix_AutoGenerateTrain_meta_2contMet,2,'range');

if exist('BiggerModel_regScheme_2contMet','var')
    % BiggerModel feature matrix
    for regListIndex = 1:length(BiggerModel_regScheme_2contMet)

        tarFlux = BiggerModel_regScheme_2contMet(regListIndex,end);
        met2 = BiggerModel_regScheme_2contMet(regListIndex,1);
        met1 = BiggerModel_regScheme_2contMet(regListIndex,2);
        
        % Functionality feature
        [featureMatrix_2contMet_BiggerModel(1,regListIndex)] = feature_functionality_2contMet_noisy(BiggerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Surface fit RMSE
        [~, featureMatrix_2contMet_BiggerModel(2,regListIndex)] = feature_surfaceFit_multiContMet_noisy(BiggerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Predict flux with machine learning
        featureMatrix_2contMet_BiggerModel(3,regListIndex) = feature_predictFlux_multiContMet_noisy(BiggerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Hold 1 metabolite constant and calculate correlation
        [featureMatrix_2contMet_BiggerModel(4,regListIndex)] = feature_hold1MetConstant_correlation_2contMet_noisy(BiggerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Hold 1 metabolite constant and fit curve
        [~, featureMatrix_2contMet_BiggerModel(5,regListIndex)] = feature_hold1MetConstant_curveFit_2contMet_noisy(BiggerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
    end
    featureMatrix_2contMet_BiggerModel_n = normalize(featureMatrix_2contMet_BiggerModel,2,'range');
end

if exist('SmallerModel_regScheme_2contMet','var')
    % SmallerModel feature matrix
    for regListIndex = 1:length(SmallerModel_regScheme_2contMet)

        tarFlux = SmallerModel_regScheme_2contMet(regListIndex,end);
        met2 = SmallerModel_regScheme_2contMet(regListIndex,1);
        met1 = SmallerModel_regScheme_2contMet(regListIndex,2);
        
        % Functionality feature
        [featureMatrix_2contMet_SmallerModel(1,regListIndex)] = feature_functionality_2contMet_noisy(SmallerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Surface fit RMSE
        [~, featureMatrix_2contMet_SmallerModel(2,regListIndex)] = feature_surfaceFit_multiContMet_noisy(SmallerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Predict flux with machine learning
        featureMatrix_2contMet_SmallerModel(3,regListIndex) = feature_predictFlux_multiContMet_noisy(SmallerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Hold 1 metabolite constant and calculate correlation
        [featureMatrix_2contMet_SmallerModel(4,regListIndex)] = feature_hold1MetConstant_correlation_2contMet_noisy(SmallerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);

        % Hold 1 metabolite constant and fit curve
        [~, featureMatrix_2contMet_SmallerModel(5,regListIndex)] = feature_hold1MetConstant_curveFit_2contMet_noisy(SmallerModel_prefix,met1,met2,tarFlux,num_IC,nT,cov,rep);
    end
    featureMatrix_2contMet_SmallerModel_n = normalize(featureMatrix_2contMet_SmallerModel,2,'range');
end
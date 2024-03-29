% Autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_3contMet)

    tarFlux = regListIndex;
    met1 = 1+5*(regListIndex-1);
    remaining_mets = [train_interaction_mets_3contMet{regListIndex}(2)+5*(regListIndex-1) train_interaction_mets_3contMet{regListIndex}(3)+5*(regListIndex-1)];
    
    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_3contMet(1,regListIndex)] = feature_surfaceFit_multiContMet_noisy(autogen_prefix,remaining_mets,met1,tarFlux,num_IC,nT,cov,rep);

   % Percentage method functionality
    featureMatrix_AutoGenerateTrain_3contMet(2,regListIndex) = feature_functionalityPercentage_3contMet_noisy(autogen_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
    % Predict flux from metabolites
    featureMatrix_AutoGenerateTrain_3contMet(3,regListIndex) = feature_predictFlux_multiContMet_noisy(autogen_prefix,met1,remaining_mets,tarFlux,num_IC,nT,cov,rep);
    
    % Rounding method functionality
    featureMatrix_AutoGenerateTrain_3contMet(4,regListIndex) = feature_functionalityRounding_3contMet_noisy(autogen_prefix,[met1,remaining_mets],tarFlux,num_IC,nT,cov,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_3contMet(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet_noisy(autogen_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
end
featureMatrix_AutoGenerateTrain_3contMet_n = normalize(featureMatrix_AutoGenerateTrain_3contMet,2,'range');

% Second autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_meta_3contMet)

    tarFlux = regListIndex;
    met1 = 1+5*(regListIndex-1);
    remaining_mets = [train_interaction_mets_meta_3contMet{regListIndex}(2)+5*(regListIndex-1) train_interaction_mets_meta_3contMet{regListIndex}(3)+5*(regListIndex-1)];
    
    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_meta_3contMet(1,regListIndex)] = feature_surfaceFit_multiContMet_noisy(autogen_meta_prefix,remaining_mets,met1,tarFlux,num_IC,nT,cov,rep);

   % Percentage method functionality
    featureMatrix_AutoGenerateTrain_meta_3contMet(2,regListIndex) = feature_functionalityPercentage_3contMet_noisy(autogen_meta_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
    % Predict flux from metabolites
    featureMatrix_AutoGenerateTrain_meta_3contMet(3,regListIndex) = feature_predictFlux_multiContMet_noisy(autogen_meta_prefix,met1,remaining_mets,tarFlux,num_IC,nT,cov,rep);
    
    % Rounding method functionality
    featureMatrix_AutoGenerateTrain_meta_3contMet(4,regListIndex) = feature_functionalityRounding_3contMet_noisy(autogen_meta_prefix,[met1,remaining_mets],tarFlux,num_IC,nT,cov,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_meta_3contMet(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet_noisy(autogen_meta_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
end
featureMatrix_AutoGenerateTrain_meta_3contMet_n = normalize(featureMatrix_AutoGenerateTrain_meta_3contMet,2,'range');

% Chass feature matrix
for regListIndex = 1:length(Chass_regScheme_3contMet)

    tarFlux = Chass_regScheme_3contMet(regListIndex,end);
    met1 = ChassMA(find(ChassMA(:,2) == tarFlux),1);
    met1 = met1(1);
    remaining_mets = setdiff(Chass_regScheme_3contMet(regListIndex,1:3),met1);
    
    % Surface fit RMSE
    [~, featureMatrix_3contMet_Chass(1,regListIndex)] = feature_surfaceFit_multiContMet_noisy(Chass_prefix,remaining_mets,met1,tarFlux,num_IC,nT,cov,rep);

   % Percentage method functionality
    featureMatrix_3contMet_Chass(2,regListIndex) = feature_functionalityPercentage_3contMet_noisy(Chass_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
    % Predict flux from metabolites
    featureMatrix_3contMet_Chass(3,regListIndex) = feature_predictFlux_multiContMet_noisy(Chass_prefix,met1,remaining_mets,tarFlux,num_IC,nT,cov,rep);
    
    % Rounding method functionality
    featureMatrix_3contMet_Chass(4,regListIndex) = feature_functionalityRounding_3contMet_noisy(Chass_prefix,[met1,remaining_mets],tarFlux,num_IC,nT,cov,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_3contMet_Chass(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet_noisy(Chass_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,nT,cov,rep);
    
end
featureMatrix_3contMet_Chass_n = normalize(featureMatrix_3contMet_Chass,2,'range');


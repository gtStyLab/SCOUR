% Autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_3contMet)

    tarFlux = regListIndex;
    met1 = 1+5*(regListIndex-1);
    remaining_mets = [train_interaction_mets_3contMet{regListIndex}(2)+5*(regListIndex-1) train_interaction_mets_3contMet{regListIndex}(3)+5*(regListIndex-1)];
    
    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_3contMet(1,regListIndex)] = feature_surfaceFit_multiContMet(autogen_prefix,remaining_mets,met1,tarFlux,num_IC,rep);

   % Percentage method functionality
    featureMatrix_AutoGenerateTrain_3contMet(2,regListIndex) = feature_functionalityPercentage_3contMet(autogen_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);
    
    % Predict flux from metabolites
    featureMatrix_AutoGenerateTrain_3contMet(3,regListIndex) = feature_predictFlux_multiContMet(autogen_prefix,met1,remaining_mets,tarFlux,num_IC,rep);
    
    % Rounding method functionality
    featureMatrix_AutoGenerateTrain_3contMet(4,regListIndex) = feature_functionalityRounding_3contMet(autogen_prefix,[met1,remaining_mets],tarFlux,num_IC,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_3contMet(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet(autogen_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);

end
featureMatrix_AutoGenerateTrain_3contMet_n = normalize(featureMatrix_AutoGenerateTrain_3contMet,2,'range');

% Second autogenerated data feature matrix
for regListIndex = 1:length(train_true_regs_meta_3contMet)

    tarFlux = regListIndex;
    met1 = 1+5*(regListIndex-1);
    remaining_mets = [train_interaction_mets_meta_3contMet{regListIndex}(2)+5*(regListIndex-1) train_interaction_mets_meta_3contMet{regListIndex}(3)+5*(regListIndex-1)];
    
    % Surface fit RMSE
    [~, featureMatrix_AutoGenerateTrain_meta_3contMet(1,regListIndex)] = feature_surfaceFit_multiContMet(autogen_meta_prefix,remaining_mets,met1,tarFlux,num_IC,rep);

   % Percentage method functionality
    featureMatrix_AutoGenerateTrain_meta_3contMet(2,regListIndex) = feature_functionalityPercentage_3contMet(autogen_meta_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);
    
    % Predict flux from metabolites
    featureMatrix_AutoGenerateTrain_meta_3contMet(3,regListIndex) = feature_predictFlux_multiContMet(autogen_meta_prefix,met1,remaining_mets,tarFlux,num_IC,rep);
    
    % Rounding method functionality
    featureMatrix_AutoGenerateTrain_meta_3contMet(4,regListIndex) = feature_functionalityRounding_3contMet(autogen_meta_prefix,[met1,remaining_mets],tarFlux,num_IC,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_AutoGenerateTrain_meta_3contMet(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet(autogen_meta_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);

end
featureMatrix_AutoGenerateTrain_meta_3contMet_n = normalize(featureMatrix_AutoGenerateTrain_meta_3contMet,2,'range');

% Hynne feature matrix
for regListIndex = 1:length(Hynne_regScheme_3contMet)

    tarFlux = Hynne_regScheme_3contMet(regListIndex,end);
    met1 = HynneMA(find(HynneMA(:,2) == tarFlux),1);
    met1 = met1(1);
    remaining_mets = setdiff(Hynne_regScheme_3contMet(regListIndex,1:3),met1);
    
    % Surface fit RMSE
    [~, featureMatrix_3contMet_Hynne(1,regListIndex)] = feature_surfaceFit_multiContMet(Hynne_prefix,remaining_mets,met1,tarFlux,num_IC,rep);

   % Percentage method functionality
    featureMatrix_3contMet_Hynne(2,regListIndex) = feature_functionalityPercentage_3contMet(Hynne_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);
    
    % Predict flux from metabolites
    featureMatrix_3contMet_Hynne(3,regListIndex) = feature_predictFlux_multiContMet(Hynne_prefix,met1,remaining_mets,tarFlux,num_IC,rep);
    
    % Rounding method functionality
    featureMatrix_3contMet_Hynne(4,regListIndex) = feature_functionalityRounding_3contMet(Hynne_prefix,[met1,remaining_mets],tarFlux,num_IC,rep);
    
    % Hold 2 metabolites constant and calculate correlation
    [featureMatrix_3contMet_Hynne(5,regListIndex)] = feature_hold2MetConstant_correlation_3contMet(Hynne_prefix,met1,remaining_mets(1),remaining_mets(2),tarFlux,num_IC,rep);

end
featureMatrix_3contMet_Hynne_n = normalize(featureMatrix_3contMet_Hynne,2,'range');


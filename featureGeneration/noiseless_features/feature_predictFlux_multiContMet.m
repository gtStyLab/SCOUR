function mean_flux_prediction_error = feature_predictFlux_multiContMet(prefix,metgroup1,metgroup2,tarFlux,num_IC,rep)

concData = [];
fluxData = [];
for IC = 1:num_IC

    if contains(prefix,'AutoGen')
        data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
    else
        data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
    end
    
    concData = [concData; data.concMatrix(2:end-1,[metgroup1 metgroup2])];
    fluxData = [fluxData; data.fluxMatrix(2:end,tarFlux)];
    
end

num_crossV = 3;
cvIndices = crossvalind('Kfold',fluxData,num_crossV);
for k = 1:num_crossV
    trainIdx = find(cvIndices ~= k);
    testIdx = find(cvIndices == k);
    
    concData_train = concData(trainIdx,:);
    fluxData_train = fluxData(trainIdx,:);
    concData_test = concData(testIdx,:);
    fluxData_test = fluxData(testIdx,:);
    
    knn_model = fitcknn(concData_train,fluxData_train);

    fluxData_predict = predict(knn_model,concData_test);

    flux_prediction_error(k) = sqrt(sum((fluxData_predict - fluxData_test).^2)/length(fluxData_predict))/mean(fluxData);
end
mean_flux_prediction_error = mean(flux_prediction_error);
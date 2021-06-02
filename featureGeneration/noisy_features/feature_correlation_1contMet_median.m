function correlation = feature_correlation_1contMet_median(prefix,met1,tarFlux,num_IC,nT,cov,rep)

allConc = [];
allFlux = [];
for IC = 1:num_IC

    data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_median.mat',prefix,IC,nT,cov,rep));
    allConc = [allConc; data.concMatrix(2:end-1,met1)];
    allFlux = [allFlux; data.fluxMatrix(2:end,tarFlux)];
    
end

correlation = corr(allConc,allFlux,'Type','Spearman');
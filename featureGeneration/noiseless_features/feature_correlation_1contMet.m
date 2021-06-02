function correlation = feature_correlation_1contMet(prefix,met1,tarFlux,num_IC,rep)

allConc = [];
allFlux = [];
for IC = 1:num_IC
    
    if contains(prefix,'AutoGen')
        data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
    else
        data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
    end
    allConc = [allConc; data.concMatrix(2:end-1,met1)];
    allFlux = [allFlux; data.fluxMatrix(2:end,tarFlux)];
    
end

correlation = corr(allConc,allFlux,'Type','Spearman');
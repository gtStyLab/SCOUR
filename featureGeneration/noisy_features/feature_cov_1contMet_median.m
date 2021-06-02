function mean_cov = feature_cov_1contMet_median(prefix,met1,tarFlux,num_IC,nT,cov,rep)

concData = [];
fluxData = [];
minConc = [];
maxConc = [];
for IC = 1:num_IC

    data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_median.mat',prefix,IC,nT,cov,rep));
    
    minConc = [minConc; min(data.concMatrix(2:end-1,met1))];
    maxConc = [maxConc; max(data.concMatrix(2:end-1,met1))];
    
    concData = [concData; data.concMatrix(2:end-1,met1)];
    fluxData = [fluxData; data.fluxMatrix(2:end,tarFlux)];
    
end
MA_concentration_indexing = linspace(min(minConc),max(maxConc),12);

all_flux_prediction = [];
for IC = 1:num_IC
    flux_prediction = [];
    for index = 2:11
        data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_median.mat',prefix,IC,nT,cov,rep));
        flux_prediction = [flux_prediction interp1(data.concMatrix(2:end-1,met1),data.fluxMatrix(2:end,tarFlux),MA_concentration_indexing(index))];
    end
    all_flux_prediction = [all_flux_prediction; flux_prediction];
end
mean_cov = nanmean(nanstd(all_flux_prediction)./mean(fluxData));
function mean_cov = fcn_cov_1contMet(prefix,met1,tarFlux,num_IC,rep)

concData = [];
fluxData = [];
minConc = [];
maxConc = [];
for IC = 1:num_IC

    if contains(prefix,'AutoGen')
        data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
    else
        data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
    end
    
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
        if contains(prefix,'AutoGen')
            data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
        else
            data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
        end
        flux_prediction = [flux_prediction interp1(data.concMatrix(2:end-1,met1),data.fluxMatrix(2:end,tarFlux),MA_concentration_indexing(index))];
    end
    all_flux_prediction = [all_flux_prediction; flux_prediction];
end
mean_cov = nanmean(nanstd(all_flux_prediction)./mean(fluxData));
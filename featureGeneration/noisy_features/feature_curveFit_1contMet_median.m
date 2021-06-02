function adjrsquare = feature_curveFit_1contMet_median(prefix,met1,tarFlux,num_IC,nT,cov,rep)
    
    concData = [];
    fluxData = [];
    for IC = 1:num_IC
        data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_median.mat',prefix,IC,nT,cov,rep));
        concData = [concData; data.concMatrix(2:end-1,:)];
        fluxData = [fluxData; data.fluxMatrix(2:end,:)];
    end
    [f gof] = fit(concData(:,met1),fluxData(:,tarFlux),'poly2');
    
    adjrsquare = gof.adjrsquare;
end
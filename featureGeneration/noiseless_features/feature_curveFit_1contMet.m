function adjrsquare = feature_curveFit_1contMet(prefix,met1,tarFlux,num_IC,rep)
    
    concData = [];
    fluxData = [];
    for IC = 1:num_IC
        if contains(prefix,'AutoGen')
            data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
        else
            data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
        end
        concData = [concData; data.concMatrix(2:end-1,:)];
        fluxData = [fluxData; data.fluxMatrix(2:end,:)];
    end
    [f gof] = fit(concData(:,met1),fluxData(:,tarFlux),'poly2');
    
    adjrsquare = gof.adjrsquare;
end
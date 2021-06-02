function mean_flux_diff = fcn_functionality_3d_v7_noisy(prefix,regMet,MA_Met,tarFlux,num_IC,nT,cov,rep)

flux_diff = [];
for IC1 = 1:num_IC
    for IC2 = 1:num_IC
        if IC2 > IC1
            data_IC1 = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC1,nT,cov,rep));
            data_IC2 = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC2,nT,cov,rep));
            
            mean_flux = mean([data_IC1.fluxMatrix(2:end,tarFlux); data_IC2.fluxMatrix(2:end,tarFlux)]);
            
            intersectionPt = InterX([data_IC1.concMatrix(2:end-1,regMet)';data_IC1.concMatrix(2:end-1,MA_Met)'],[data_IC2.concMatrix(2:end-1,regMet)';data_IC2.concMatrix(2:end-1,MA_Met)']);
            F1 = scatteredInterpolant(data_IC1.concMatrix(2:end-1,regMet),data_IC1.concMatrix(2:end-1,MA_Met),data_IC1.fluxMatrix(2:end,tarFlux));
            F2 = scatteredInterpolant(data_IC2.concMatrix(2:end-1,regMet),data_IC2.concMatrix(2:end-1,MA_Met),data_IC2.fluxMatrix(2:end,tarFlux));
            intersectionPt_regMet = InterX([data_IC1.concMatrix(2:end-1,regMet)';data_IC1.fluxMatrix(2:end,tarFlux)'],[data_IC2.concMatrix(2:end-1,regMet)';data_IC2.fluxMatrix(2:end,tarFlux)']);
            intersectionPt_MA_Met = InterX([data_IC1.concMatrix(2:end-1,MA_Met)';data_IC1.fluxMatrix(2:end,tarFlux)'],[data_IC2.concMatrix(2:end-1,MA_Met)';data_IC2.fluxMatrix(2:end,tarFlux)']);

            for numIntersect = 1:size(intersectionPt,2)
                flux_IC1 = F1(intersectionPt(1,numIntersect),intersectionPt(2,numIntersect));
                flux_IC2 = F2(intersectionPt(1,numIntersect),intersectionPt(2,numIntersect));
                
                flux_diff = [flux_diff abs((flux_IC1-flux_IC2)/mean_flux)];
            end
        end
    end
end
mean_flux_diff = nanmean(flux_diff);

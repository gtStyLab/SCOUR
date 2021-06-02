function mean_flux_diff = feature_functionality_2contMet(prefix,met1,met2,tarFlux,num_IC,rep)

flux_diff = [];
for IC1 = 1:num_IC
    for IC2 = 1:num_IC
        if IC2 > IC1
            if contains(prefix,'AutoGen')
                data_IC1 = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC1,rep));
                data_IC2 = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC2,rep));
            else
                data_IC1 = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC1));
                data_IC2 = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC2));
            end
            
            mean_flux = mean([data_IC1.fluxMatrix(2:end,tarFlux); data_IC2.fluxMatrix(2:end,tarFlux)]);
            
            intersectionPt = InterX([data_IC1.concMatrix(2:end-1,met1)';data_IC1.concMatrix(2:end-1,met2)'],[data_IC2.concMatrix(2:end-1,met1)';data_IC2.concMatrix(2:end-1,met2)']);
            F1 = scatteredInterpolant(data_IC1.concMatrix(2:end-1,met1),data_IC1.concMatrix(2:end-1,met2),data_IC1.fluxMatrix(2:end,tarFlux));
            F2 = scatteredInterpolant(data_IC2.concMatrix(2:end-1,met1),data_IC2.concMatrix(2:end-1,met2),data_IC2.fluxMatrix(2:end,tarFlux));
            intersectionPt_regMet = InterX([data_IC1.concMatrix(2:end-1,met1)';data_IC1.fluxMatrix(2:end,tarFlux)'],[data_IC2.concMatrix(2:end-1,met1)';data_IC2.fluxMatrix(2:end,tarFlux)']);
            intersectionPt_MA_Met = InterX([data_IC1.concMatrix(2:end-1,met2)';data_IC1.fluxMatrix(2:end,tarFlux)'],[data_IC2.concMatrix(2:end-1,met2)';data_IC2.fluxMatrix(2:end,tarFlux)']);

            for numIntersect = 1:size(intersectionPt,2)
                flux_IC1 = F1(intersectionPt(1,numIntersect),intersectionPt(2,numIntersect));
                flux_IC2 = F2(intersectionPt(1,numIntersect),intersectionPt(2,numIntersect));
                
                flux_diff = [flux_diff abs((flux_IC1-flux_IC2)/mean_flux)];
            end
        end
    end
end
mean_flux_diff = nanmean(flux_diff);

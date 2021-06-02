function [avg_all] = feature_hold2MetConstant_correlation_3contMet_noisy(prefix,met1,met2,met3,tarFlux,num_IC,nT,cov,rep)

% met1 vs. met2
correlation_met2 = [];
correlation_met3 = [];
for IC1 = 1:num_IC
    for IC2 = 1:num_IC
        if IC2 > IC1
            data_IC1 = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC1,nT,cov,rep));
            data_IC2 = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC2,nT,cov,rep));

            % Intersection points of met1 vs. met2 for different ICs
            intersectionPt_met1_met3 = InterX([data_IC1.concMatrix(2:end-1,met1)';data_IC1.concMatrix(2:end-1,met3)'],[data_IC2.concMatrix(2:end-1,met1)';data_IC2.concMatrix(2:end-1,met3)']);
            % Create interpolation models for met3 and flux 
            F1_met2 = scatteredInterpolant(data_IC1.concMatrix(2:end-1,met1),data_IC1.concMatrix(2:end-1,met3),data_IC1.concMatrix(2:end-1,met2));
            F2_met2 = scatteredInterpolant(data_IC2.concMatrix(2:end-1,met1),data_IC2.concMatrix(2:end-1,met3),data_IC2.concMatrix(2:end-1,met2));
            F1_flux = scatteredInterpolant(data_IC1.concMatrix(2:end-1,met1),data_IC1.concMatrix(2:end-1,met3),data_IC1.fluxMatrix(2:end,tarFlux));
            F2_flux = scatteredInterpolant(data_IC2.concMatrix(2:end-1,met1),data_IC2.concMatrix(2:end-1,met3),data_IC2.fluxMatrix(2:end,tarFlux));
            
            % Intersection points of met1 vs. met2 for different ICs
            intersectionPt_met1_met2 = InterX([data_IC1.concMatrix(2:end-1,met1)';data_IC1.concMatrix(2:end-1,met2)'],[data_IC2.concMatrix(2:end-1,met1)';data_IC2.concMatrix(2:end-1,met2)']);
            % Create interpolation models for met3 and flux 
            F3_met3 = scatteredInterpolant(data_IC1.concMatrix(2:end-1,met1),data_IC1.concMatrix(2:end-1,met2),data_IC1.concMatrix(2:end-1,met3));
            F4_met3 = scatteredInterpolant(data_IC2.concMatrix(2:end-1,met1),data_IC2.concMatrix(2:end-1,met2),data_IC2.concMatrix(2:end-1,met3));
            F3_flux = scatteredInterpolant(data_IC1.concMatrix(2:end-1,met1),data_IC1.concMatrix(2:end-1,met2),data_IC1.fluxMatrix(2:end,tarFlux));
            F4_flux = scatteredInterpolant(data_IC2.concMatrix(2:end-1,met1),data_IC2.concMatrix(2:end-1,met2),data_IC2.fluxMatrix(2:end,tarFlux));
            
            for numIntersect = 1:size(intersectionPt_met1_met3,2)
                met2_IC1 = F1_met2(intersectionPt_met1_met3(1,numIntersect),intersectionPt_met1_met3(2,numIntersect));
                met2_IC2 = F2_met2(intersectionPt_met1_met3(1,numIntersect),intersectionPt_met1_met3(2,numIntersect));
                
                flux_IC1 = F1_flux(intersectionPt_met1_met3(1,numIntersect),intersectionPt_met1_met3(2,numIntersect));
                flux_IC2 = F2_flux(intersectionPt_met1_met3(1,numIntersect),intersectionPt_met1_met3(2,numIntersect));
                
                if met2_IC1 < 0.9*met2_IC2 || met2_IC1 > 1.1*met2_IC2 % Make sure concentrations are different enough when using noisy data
                    correlation_met2 = [correlation_met2 corr([met2_IC1; met2_IC2],[flux_IC1; flux_IC2])];
                end
            end
            
            for numIntersect = 1:size(intersectionPt_met1_met2,2)
                met3_IC1 = F3_met3(intersectionPt_met1_met2(1,numIntersect),intersectionPt_met1_met2(2,numIntersect));
                met3_IC2 = F4_met3(intersectionPt_met1_met2(1,numIntersect),intersectionPt_met1_met2(2,numIntersect));
                
                flux_IC1 = F3_flux(intersectionPt_met1_met2(1,numIntersect),intersectionPt_met1_met2(2,numIntersect));
                flux_IC2 = F4_flux(intersectionPt_met1_met2(1,numIntersect),intersectionPt_met1_met2(2,numIntersect));
                
                if met3_IC1 < 0.9*met3_IC2 || met3_IC1 > 1.1*met3_IC2 % Make sure concentrations are different enough when using noisy data
                    correlation_met3 = [correlation_met3 corr([met3_IC1; met3_IC2],[flux_IC1; flux_IC2])];
                end
            end
        end
    end
end
%correlation_met2(isnan(correlation_met2)) = 0;
%correlation_met3(isnan(correlation_met3)) = 0;
avg_corr_met2 = abs(nanmean(correlation_met2));
avg_corr_met3 = abs(nanmean(correlation_met3));

if isnan(avg_corr_met2)
    avg_corr_met2 = 0.5;
end
if isnan(avg_corr_met3)
    avg_corr_met3 = 0.5;
end

avg_all = mean([avg_corr_met2 avg_corr_met3]);
% Plot Fig. S4
%% E. coli

clear;clc;

plotcount = 1;
names = categorical({'1 cont. met','2 cont. met','3 cont. met'});
names = reordercats(names,{'1 cont. met','2 cont. met','3 cont. met'});
repetitions = 30;
figure;
for nT = [50 15]
    for cov = [5 15]
        leftover_count = zeros(1,48);
        for rep = 1:repetitions
            filename = sprintf('results/ecoli_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            if exist(filename)
                
                load(filename,'predicted_Chass_1contMet','predicted_Chass_2contMet','predicted_Chass_3contMet');
                
                IDed_fluxes = unique([1 10 14 26 predicted_Chass_1contMet(:,2)'  predicted_Chass_2contMet(:,3)'  predicted_Chass_3contMet(:,4)']);
                leftover_fluxes = setdiff(1:48,IDed_fluxes);
                leftover_count(leftover_fluxes) = leftover_count(leftover_fluxes) + 1;
            end
        end
        subplot(2,2,plotcount)
        y = 100*[leftover_count/30];
        hb = bar(y);
        hb.FaceColor = 'flat';
        hb.CData(2,:) = [1 0 0];
        hb.CData(7,:) = [1 0 0];
        hb.CData(8,:) = [1 0 0];
        hb.CData(9,:) = [1 0 0];
        ylim([0 100])
        hold on
        
        ylabel('% of runs flux is leftover');
        xlabel('Flux #');
        title(sprintf('nT = %02d, CoV = %.2f',nT,cov/100));
        plotcount = plotcount + 1;
        set(gca,'FontSize',14)
    end
end
suptitle('E. coli')

%% S. cerevisiae

clear;clc;

plotcount = 1;
names = categorical({'1 cont. met','2 cont. met','3 cont. met'});
names = reordercats(names,{'1 cont. met','2 cont. met','3 cont. met'});
repetitions = 30;
figure;
for nT = [50 15]
    for cov = [5 15]
        leftover_count = zeros(1,24);
        for rep = 1:repetitions
            filename = sprintf('results/yeast_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            if exist(filename)
                
                load(filename,'predicted_Hynne_1contMet','predicted_Hynne_2contMet','predicted_Hynne_3contMet');
                
                IDed_fluxes = unique([1 predicted_Hynne_1contMet(:,2)'  predicted_Hynne_2contMet(:,3)'  predicted_Hynne_3contMet(:,4)']);
                leftover_fluxes = setdiff(1:24,IDed_fluxes);
                leftover_count(leftover_fluxes) = leftover_count(leftover_fluxes) + 1;
            end
        end
        subplot(2,2,plotcount)
        y = 100*[leftover_count/30];
        hb = bar(y);
        hb.FaceColor = 'flat';
        hb.CData(8,:) = [1 0 0];
        hb.CData(9,:) = [1 0 0];
        ylim([0 100])
        hold on
        
        ylabel('% of runs flux is leftover');
        xlabel('Flux #');
        title(sprintf('nT = %02d, CoV = %.2f',nT,cov/100));
        plotcount = plotcount + 1;
        set(gca,'FontSize',14)
    end
end
suptitle('S. cerevisiae')
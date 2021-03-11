% Plot Fig. S2
clear;clc;

plot_count = 1;
figure;
for nT = [50 15]
    for cov = [5 15]
        ppv_3contMet = [];
        predictionAccuracy_3contMet = [];
        sensitivity_3contMet = [];
        specificity_3contMet = [];
        for rep = 1:30
            filename = sprintf('results/yeast_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep); %***
            load(filename);
            
            randomname = sprintf('results/randomclassifier/yeast_random_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            randomdata = load(randomname,'ppv_Hynne_3contMet');
            ppv_Hynne_3contMet_analysis(rep,plot_count) = randomdata.ppv_Hynne_3contMet; % ppv of random values
            
            if exist('Hynne_regScheme_3contMet','var')
                ppv_3contMet = [ppv_3contMet; ppv_Hynne_3contMet]; % ppv from framework
                predictionAccuracy_3contMet = [predictionAccuracy_3contMet; predictionAccuracy_Hynne_3contMet];
                sensitivity_3contMet = [sensitivity_3contMet; sensitivity_Hynne_3contMet];
                specificity_3contMet = [specificity_3contMet; specificity_Hynne_3contMet];
                
                % Identify random 3 controller metabolite reactions
                % List of Hynne interactions with three controller metabolites
                true_3contMet_Hynne = [1 2 4,2;
                                       3 6 22,5;
                                       7 8 9,6;
                                       9 10 12,15;
                                       3 5 22,24];
                count = 1;
                for regIdx = 1:length(Hynne_regScheme_3contMet)
                    for trueIdx = 1:size(true_3contMet_Hynne,1)
                        if isequal(Hynne_regScheme_3contMet(regIdx,:),true_3contMet_Hynne(trueIdx,:))
                            Hynne_3contMet_trueInRegIdx(count,1) = regIdx;
                            count = count + 1;
                        end
                    end
                end
            end
        end
        
        % Check normality
        kstest_framework = kstest(zscore(ppv_3contMet(~isnan(ppv_3contMet))))
        ppv_Hynne_3contMet_analysis_nonan = ~isnan(ppv_Hynne_3contMet_analysis(:,plot_count));
        kstest_random = kstest(zscore(ppv_Hynne_3contMet_analysis(ppv_Hynne_3contMet_analysis_nonan,plot_count)))
        
        % Check significance
        ppv_ranksum = ranksum(ppv_3contMet,ppv_Hynne_3contMet_analysis(:,plot_count))
        
        subplot(2,2,plot_count)
        x = [1:2];
        y = 100*[nanmean(ppv_Hynne_3contMet_analysis(:,plot_count)) nanmean(ppv_3contMet)];
        b = bar(y);
        hold on
        set(gca, 'XTickLabel',{'Random Classification','Framework Classification'});
        fix_xticklabels();
        
        % Error bars
        errhigh = 100*[nanstd(ppv_Hynne_3contMet_analysis(:,plot_count))/sqrt(length(ppv_Hynne_3contMet_analysis(:,plot_count))) nanstd(ppv_3contMet)/sqrt(length(ppv_3contMet))];
        errlow = errhigh;
        er = errorbar(x,y,errlow,errhigh);    
        er.Color = [0 0 0];   
        er.LineStyle = 'none';
        ylim([0 100])
        
        groups={[1,2]};
        if ppv_ranksum < 0.05
            sigstar(groups,0.05);
        end
        
        ylabel('PPV %');
        title(sprintf('nT = %02d, CoV = %.2f',nT,cov/100));
        set(gca,'FontSize',12)
        
        plot_count = plot_count + 1;
        
    end
end
suptitle('S. cerevisiae')

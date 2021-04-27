% Plot Fig. 4
clear;clc;

names = categorical({'One-Cont. met','Two-Cont. met','Three-Cont. met'});
names = reordercats(names,{'One-Cont. met','Two-Cont. met','Three-Cont. met'});
repetitions = 30;
figure;
set(gcf, 'Position',  [100, 100, 1500, 1000])

% Smaller Synthetic Model
condition_count = 1;
for cov = [5 15]
    for nT = [50 15]
        accuracy_1contMet = [];
        accuracy_2contMet = [];
        accuracy_3contMet = [];
        
        sensitivity_1contMet = [];
        sensitivity_2contMet = [];
        sensitivity_3contMet = [];
        
        specificity_1contMet = [];
        specificity_2contMet = [];
        specificity_3contMet = [];
        
        ppv_1contMet = [];
        ppv_2contMet = [];
        ppv_3contMet = [];
        
        F1_1contMet = [];
        F1_2contMet = [];
        F1_3contMet = [];
        
        ppv_1contMet_random = [];
        ppv_2contMet_random = [];
        ppv_3contMet_random = [];
        
        F1_1contMet_random = [];
        F1_2contMet_random = [];
        F1_3contMet_random = [];
        
        for rep = 1:repetitions
            filename = sprintf('results/synthetic_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            load(filename,'predictionAccuracy_SmallerModel_1contMet','predictionAccuracy_SmallerModel_2contMet','predictionAccuracy_SmallerModel_3contMet',...
                'sensitivity_SmallerModel_1contMet','sensitivity_SmallerModel_2contMet','sensitivity_SmallerModel_3contMet',...
                'specificity_SmallerModel_1contMet','specificity_SmallerModel_2contMet','specificity_SmallerModel_3contMet',...
                'ppv_SmallerModel_1contMet','ppv_SmallerModel_2contMet','ppv_SmallerModel_3contMet');
            
            randomdata = load(sprintf('results/randomclassifier/synthetic_random_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep),...
                'sensitivity_SmallerModel_1contMet','sensitivity_SmallerModel_2contMet','sensitivity_SmallerModel_3contMet',...
                'ppv_SmallerModel_1contMet','ppv_SmallerModel_2contMet','ppv_SmallerModel_3contMet');
            
            accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_SmallerModel_1contMet];
            accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_SmallerModel_2contMet];
            if exist('predictionAccuracy_SmallerModel_3contMet')
                accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_SmallerModel_3contMet];
            end
            
            sensitivity_1contMet = [sensitivity_1contMet; sensitivity_SmallerModel_1contMet];
            sensitivity_2contMet = [sensitivity_2contMet; sensitivity_SmallerModel_2contMet];
            if exist('sensitivity_SmallerModel_3contMet')
                sensitivity_3contMet = [sensitivity_3contMet; sensitivity_SmallerModel_3contMet];
            end
            
            specificity_1contMet = [specificity_1contMet; specificity_SmallerModel_1contMet];
            specificity_2contMet = [specificity_2contMet; specificity_SmallerModel_2contMet];
            if exist('specificity_SmallerModel_3contMet')
                specificity_3contMet = [specificity_3contMet; specificity_SmallerModel_3contMet];
            end
            
            if exist('ppv_SmallerModel_1contMet','var')
                ppv_1contMet = [ppv_1contMet; ppv_SmallerModel_1contMet];
                ppv_2contMet = [ppv_2contMet; ppv_SmallerModel_2contMet];
                if exist('ppv_SmallerModel_3contMet','var')
                    ppv_3contMet = [ppv_3contMet; ppv_SmallerModel_3contMet];
                end
                
                F1_1contMet = [F1_1contMet (ppv_SmallerModel_1contMet*sensitivity_SmallerModel_1contMet)/(ppv_SmallerModel_1contMet + sensitivity_SmallerModel_1contMet)];
                F1_2contMet = [F1_1contMet (ppv_SmallerModel_2contMet*sensitivity_SmallerModel_2contMet)/(ppv_SmallerModel_2contMet + sensitivity_SmallerModel_2contMet)];
                if exist('ppv_SmallerModel_3contMet','var')
                    F1_3contMet = [F1_3contMet (ppv_SmallerModel_3contMet*sensitivity_SmallerModel_3contMet)/(ppv_SmallerModel_3contMet + sensitivity_SmallerModel_3contMet)];
                end
            end
            
            
            ppv_1contMet_random = [ppv_1contMet_random; randomdata.ppv_SmallerModel_1contMet];
            ppv_2contMet_random = [ppv_2contMet_random; randomdata.ppv_SmallerModel_2contMet];
            ppv_3contMet_random = [ppv_3contMet_random; randomdata.ppv_SmallerModel_3contMet];
            
            F1_1contMet_random = [F1_1contMet_random; (randomdata.ppv_SmallerModel_1contMet*randomdata.sensitivity_SmallerModel_1contMet)/(randomdata.ppv_SmallerModel_1contMet + sensitivity_SmallerModel_1contMet)];
            F1_2contMet_random = [F1_2contMet_random; (randomdata.ppv_SmallerModel_1contMet*randomdata.sensitivity_SmallerModel_1contMet)/(randomdata.ppv_SmallerModel_1contMet + sensitivity_SmallerModel_1contMet)];
            F1_3contMet_random = [F1_3contMet_random; (randomdata.ppv_SmallerModel_1contMet*randomdata.sensitivity_SmallerModel_1contMet)/(randomdata.ppv_SmallerModel_1contMet + sensitivity_SmallerModel_1contMet)];
        end
        mean_accuracy_1contMet(condition_count) = nanmean(accuracy_1contMet);
        mean_accuracy_2contMet(condition_count) = nanmean(accuracy_2contMet);
        mean_accuracy_3contMet(condition_count) = nanmean(accuracy_3contMet);
        
        mean_sensitivity_1contMet(condition_count) = nanmean(sensitivity_1contMet);
        mean_sensitivity_2contMet(condition_count) = nanmean(sensitivity_2contMet);
        mean_sensitivity_3contMet(condition_count) = nanmean(sensitivity_3contMet);
        
        mean_specificity_1contMet(condition_count) = nanmean(specificity_1contMet);
        mean_specificity_2contMet(condition_count) = nanmean(specificity_2contMet);
        mean_specificity_3contMet(condition_count) = nanmean(specificity_3contMet);
        
        mean_ppv_1contMet(condition_count) = nanmean(ppv_1contMet);
        mean_ppv_2contMet(condition_count) = nanmean(ppv_2contMet);
        mean_ppv_3contMet(condition_count) = nanmean(ppv_3contMet);
        
        mean_F1_1contMet(condition_count) = nanmean(F1_1contMet);
        mean_F1_2contMet(condition_count) = nanmean(F1_2contMet);
        mean_F1_3contMet(condition_count) = nanmean(F1_3contMet);
        
        sem_accuracy_1contMet(condition_count) = nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet)));
        sem_accuracy_2contMet(condition_count) = nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet)));
        sem_accuracy_3contMet(condition_count) = nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet)));
        
        sem_sensitivity_1contMet(condition_count) = nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet)));
        sem_sensitivity_2contMet(condition_count) = nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet)));
        sem_sensitivity_3contMet(condition_count) = nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet)));
        
        sem_specificity_1contMet(condition_count) = nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet)));
        sem_specificity_2contMet(condition_count) = nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet)));
        sem_specificity_3contMet(condition_count) = nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet)));
        
        sem_ppv_1contMet(condition_count) = nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));
        sem_ppv_2contMet(condition_count) = nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));
        sem_ppv_3contMet(condition_count) = nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)));
        
        sem_F1_1contMet(condition_count) = nanstd(F1_1contMet)/sqrt(sum(~isnan(F1_1contMet)));
        sem_F1_2contMet(condition_count) = nanstd(F1_2contMet)/sqrt(sum(~isnan(F1_2contMet)));
        sem_F1_3contMet(condition_count) = nanstd(F1_3contMet)/sqrt(sum(~isnan(F1_3contMet)));
        
        
        mean_ppv_1contMet_random(condition_count) = nanmean(ppv_1contMet_random);
        mean_ppv_2contMet_random(condition_count) = nanmean(ppv_2contMet_random);
        mean_ppv_3contMet_random(condition_count) = nanmean(ppv_3contMet_random);
        
        mean_F1_1contMet_random(condition_count) = nanmean(F1_1contMet_random);
        mean_F1_2contMet_random(condition_count) = nanmean(F1_2contMet_random);
        mean_F1_3contMet_random(condition_count) = nanmean(F1_3contMet_random);
        
        sem_ppv_1contMet_random(condition_count) = nanstd(ppv_1contMet_random)/sqrt(sum(~isnan(ppv_1contMet_random)));
        sem_ppv_2contMet_random(condition_count) = nanstd(ppv_2contMet_random)/sqrt(sum(~isnan(ppv_2contMet_random)));
        sem_ppv_3contMet_random(condition_count) = nanstd(ppv_3contMet_random)/sqrt(sum(~isnan(ppv_3contMet_random)));
        
        sem_F1_1contMet_random(condition_count) = nanstd(F1_1contMet_random)/sqrt(sum(~isnan(F1_1contMet_random)));
        sem_F1_2contMet_random(condition_count) = nanstd(F1_2contMet_random)/sqrt(sum(~isnan(F1_2contMet_random)));
        sem_F1_3contMet_random(condition_count) = nanstd(F1_3contMet_random)/sqrt(sum(~isnan(F1_3contMet_random)));
        
        condition_count = condition_count + 1;
    end
end

a = annotation('textbox', [0.11 0.95 0 0],'String','A.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.39 0.95 0 0],'String','B.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.67 0.95 0 0],'String','C.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(4,3,1)
hold on
errorbar(1:4,100*mean_F1_1contMet,100*sem_F1_1contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_1contMet_random,100*sem_F1_1contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels;
legend('F1 Score','F1 Score Random','FontSize',11,'location','northwest')
set(gca,'FontSize',11)
title({'Small Synthetic Model','One-Controller Metabolite'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,2)
hold on
errorbar(1:4,100*mean_F1_2contMet,100*sem_F1_2contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_2contMet_random,100*sem_F1_2contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'Small Synthetic Model','Two-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,3)
hold on
errorbar(1:4,100*mean_F1_3contMet,100*sem_F1_3contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_3contMet_random,100*sem_F1_3contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'Small Synthetic Model','Three-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);


% Bigger Synthetic Model
condition_count = 1;
for cov = [5 15]
    for nT = [50 15]
        accuracy_1contMet = [];
        accuracy_2contMet = [];
        accuracy_3contMet = [];
        
        sensitivity_1contMet = [];
        sensitivity_2contMet = [];
        sensitivity_3contMet = [];
        
        specificity_1contMet = [];
        specificity_2contMet = [];
        specificity_3contMet = [];
        
        ppv_1contMet = [];
        ppv_2contMet = [];
        ppv_3contMet = [];
        
        F1_1contMet = [];
        F1_2contMet = [];
        F1_3contMet = [];
        
        ppv_1contMet_random = [];
        ppv_2contMet_random = [];
        ppv_3contMet_random = [];
        
        F1_1contMet_random = [];
        F1_2contMet_random = [];
        F1_3contMet_random = [];
        
        for rep = 1:repetitions
            filename = sprintf('results/synthetic_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            load(filename,'predictionAccuracy_BiggerModel_1contMet','predictionAccuracy_BiggerModel_2contMet','predictionAccuracy_BiggerModel_3contMet',...
                'sensitivity_BiggerModel_1contMet','sensitivity_BiggerModel_2contMet','sensitivity_BiggerModel_3contMet',...
                'specificity_BiggerModel_1contMet','specificity_BiggerModel_2contMet','specificity_BiggerModel_3contMet',...
                'ppv_BiggerModel_1contMet','ppv_BiggerModel_2contMet','ppv_BiggerModel_3contMet');
            
            randomdata = load(sprintf('results/randomclassifier/synthetic_random_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep),...
                'sensitivity_BiggerModel_1contMet','sensitivity_BiggerModel_2contMet','sensitivity_BiggerModel_3contMet',...
                'ppv_BiggerModel_1contMet','ppv_BiggerModel_2contMet','ppv_BiggerModel_3contMet');
            
            
            accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_BiggerModel_1contMet];
            accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_BiggerModel_2contMet];
            if exist('predictionAccuracy_BiggerModel_3contMet')
                accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_BiggerModel_3contMet];
            end
            
            sensitivity_1contMet = [sensitivity_1contMet; sensitivity_BiggerModel_1contMet];
            sensitivity_2contMet = [sensitivity_2contMet; sensitivity_BiggerModel_2contMet];
            if exist('sensitivity_BiggerModel_3contMet')
                sensitivity_3contMet = [sensitivity_3contMet; sensitivity_BiggerModel_3contMet];
            end
            
            specificity_1contMet = [specificity_1contMet; specificity_BiggerModel_1contMet];
            specificity_2contMet = [specificity_2contMet; specificity_BiggerModel_2contMet];
            if exist('specificity_BiggerModel_3contMet')
                specificity_3contMet = [specificity_3contMet; specificity_BiggerModel_3contMet];
            end
            
            if exist('ppv_BiggerModel_1contMet','var')
                ppv_1contMet = [ppv_1contMet; ppv_BiggerModel_1contMet];
                ppv_2contMet = [ppv_2contMet; ppv_BiggerModel_2contMet];
                if exist('ppv_BiggerModel_3contMet','var')
                    ppv_3contMet = [ppv_3contMet; ppv_BiggerModel_3contMet];
                end
                
                F1_1contMet = [F1_1contMet (ppv_BiggerModel_1contMet*sensitivity_BiggerModel_1contMet)/(ppv_BiggerModel_1contMet + sensitivity_BiggerModel_1contMet)];
                F1_2contMet = [F1_1contMet (ppv_BiggerModel_2contMet*sensitivity_BiggerModel_2contMet)/(ppv_BiggerModel_2contMet + sensitivity_BiggerModel_2contMet)];
                if exist('ppv_BiggerModel_3contMet','var')
                    F1_3contMet = [F1_3contMet (ppv_BiggerModel_3contMet*sensitivity_BiggerModel_3contMet)/(ppv_BiggerModel_3contMet + sensitivity_BiggerModel_3contMet)];
                end
            end
            
            
            ppv_1contMet_random = [ppv_1contMet_random; randomdata.ppv_BiggerModel_1contMet];
            ppv_2contMet_random = [ppv_2contMet_random; randomdata.ppv_BiggerModel_2contMet];
            ppv_3contMet_random = [ppv_3contMet_random; randomdata.ppv_BiggerModel_3contMet];
            
            F1_1contMet_random = [F1_1contMet_random; (randomdata.ppv_BiggerModel_1contMet*randomdata.sensitivity_BiggerModel_1contMet)/(randomdata.ppv_BiggerModel_1contMet + sensitivity_BiggerModel_1contMet)];
            F1_2contMet_random = [F1_2contMet_random; (randomdata.ppv_BiggerModel_1contMet*randomdata.sensitivity_BiggerModel_1contMet)/(randomdata.ppv_BiggerModel_1contMet + sensitivity_BiggerModel_1contMet)];
            F1_3contMet_random = [F1_3contMet_random; (randomdata.ppv_BiggerModel_1contMet*randomdata.sensitivity_BiggerModel_1contMet)/(randomdata.ppv_BiggerModel_1contMet + sensitivity_BiggerModel_1contMet)];
        end
        mean_accuracy_1contMet(condition_count) = nanmean(accuracy_1contMet);
        mean_accuracy_2contMet(condition_count) = nanmean(accuracy_2contMet);
        mean_accuracy_3contMet(condition_count) = nanmean(accuracy_3contMet);
        
        mean_sensitivity_1contMet(condition_count) = nanmean(sensitivity_1contMet);
        mean_sensitivity_2contMet(condition_count) = nanmean(sensitivity_2contMet);
        mean_sensitivity_3contMet(condition_count) = nanmean(sensitivity_3contMet);
        
        mean_specificity_1contMet(condition_count) = nanmean(specificity_1contMet);
        mean_specificity_2contMet(condition_count) = nanmean(specificity_2contMet);
        mean_specificity_3contMet(condition_count) = nanmean(specificity_3contMet);
        
        mean_ppv_1contMet(condition_count) = nanmean(ppv_1contMet);
        mean_ppv_2contMet(condition_count) = nanmean(ppv_2contMet);
        mean_ppv_3contMet(condition_count) = nanmean(ppv_3contMet);
        
        mean_F1_1contMet(condition_count) = nanmean(F1_1contMet);
        mean_F1_2contMet(condition_count) = nanmean(F1_2contMet);
        mean_F1_3contMet(condition_count) = nanmean(F1_3contMet);
        
        sem_accuracy_1contMet(condition_count) = nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet)));
        sem_accuracy_2contMet(condition_count) = nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet)));
        sem_accuracy_3contMet(condition_count) = nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet)));
        
        sem_sensitivity_1contMet(condition_count) = nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet)));
        sem_sensitivity_2contMet(condition_count) = nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet)));
        sem_sensitivity_3contMet(condition_count) = nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet)));
        
        sem_specificity_1contMet(condition_count) = nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet)));
        sem_specificity_2contMet(condition_count) = nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet)));
        sem_specificity_3contMet(condition_count) = nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet)));
        
        sem_ppv_1contMet(condition_count) = nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));
        sem_ppv_2contMet(condition_count) = nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));
        sem_ppv_3contMet(condition_count) = nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)));
        
        sem_F1_1contMet(condition_count) = nanstd(F1_1contMet)/sqrt(sum(~isnan(F1_1contMet)));
        sem_F1_2contMet(condition_count) = nanstd(F1_2contMet)/sqrt(sum(~isnan(F1_2contMet)));
        sem_F1_3contMet(condition_count) = nanstd(F1_3contMet)/sqrt(sum(~isnan(F1_3contMet)));
        
        
        mean_ppv_1contMet_random(condition_count) = nanmean(ppv_1contMet_random);
        mean_ppv_2contMet_random(condition_count) = nanmean(ppv_2contMet_random);
        mean_ppv_3contMet_random(condition_count) = nanmean(ppv_3contMet_random);
        
        mean_F1_1contMet_random(condition_count) = nanmean(F1_1contMet_random);
        mean_F1_2contMet_random(condition_count) = nanmean(F1_2contMet_random);
        mean_F1_3contMet_random(condition_count) = nanmean(F1_3contMet_random);
        
        sem_ppv_1contMet_random(condition_count) = nanstd(ppv_1contMet_random)/sqrt(sum(~isnan(ppv_1contMet_random)));
        sem_ppv_2contMet_random(condition_count) = nanstd(ppv_2contMet_random)/sqrt(sum(~isnan(ppv_2contMet_random)));
        sem_ppv_3contMet_random(condition_count) = nanstd(ppv_3contMet_random)/sqrt(sum(~isnan(ppv_3contMet_random)));
        
        sem_F1_1contMet_random(condition_count) = nanstd(F1_1contMet_random)/sqrt(sum(~isnan(F1_1contMet_random)));
        sem_F1_2contMet_random(condition_count) = nanstd(F1_2contMet_random)/sqrt(sum(~isnan(F1_2contMet_random)));
        sem_F1_3contMet_random(condition_count) = nanstd(F1_3contMet_random)/sqrt(sum(~isnan(F1_3contMet_random)));
        
        condition_count = condition_count + 1;
    end
end

a = annotation('textbox', [0.11 0.73 0 0],'String','D.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.39 0.73 0 0],'String','E.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.67 0.73 0 0],'String','F.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(4,3,4)
hold on
errorbar(1:4,100*mean_F1_1contMet,100*sem_F1_1contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_1contMet_random,100*sem_F1_1contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels;
set(gca,'FontSize',11)
title({'Big Synthetic Model','One-Controller Metabolite'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,5)
hold on
errorbar(1:4,100*mean_F1_2contMet,100*sem_F1_2contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_2contMet_random,100*sem_F1_2contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'Big Synthetic Model','Two-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,6)
hold on
errorbar(1:4,100*mean_F1_3contMet,100*sem_F1_3contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_3contMet_random,100*sem_F1_3contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'Big Synthetic Model','Three-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

% S. cerevisiae
condition_count = 1;
for cov = [5 15]
    for nT = [50 15]
        accuracy_1contMet = [];
        accuracy_2contMet = [];
        accuracy_3contMet = [];
        
        sensitivity_1contMet = [];
        sensitivity_2contMet = [];
        sensitivity_3contMet = [];
        
        specificity_1contMet = [];
        specificity_2contMet = [];
        specificity_3contMet = [];
        
        ppv_1contMet = [];
        ppv_2contMet = [];
        ppv_3contMet = [];
        
        F1_1contMet = [];
        F1_2contMet = [];
        F1_3contMet = [];
        
        ppv_1contMet_random = [];
        ppv_2contMet_random = [];
        ppv_3contMet_random = [];
        
        F1_1contMet_random = [];
        F1_2contMet_random = [];
        F1_3contMet_random = [];
        
        for rep = 1:repetitions
            filename = sprintf('results/yeast_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            load(filename,'predictionAccuracy_Hynne_1contMet','predictionAccuracy_Hynne_2contMet','predictionAccuracy_Hynne_3contMet',...
                'sensitivity_Hynne_1contMet','sensitivity_Hynne_2contMet','sensitivity_Hynne_3contMet',...
                'specificity_Hynne_1contMet','specificity_Hynne_2contMet','specificity_Hynne_3contMet',...
                'ppv_Hynne_1contMet','ppv_Hynne_2contMet','ppv_Hynne_3contMet');
            
            randomdata = load(sprintf('results/randomclassifier/yeast_random_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep),...
                'sensitivity_Hynne_1contMet','sensitivity_Hynne_2contMet','sensitivity_Hynne_3contMet',...
                'ppv_Hynne_1contMet','ppv_Hynne_2contMet','ppv_Hynne_3contMet');
            
            
            accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_Hynne_1contMet];
            accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_Hynne_2contMet];
            accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_Hynne_3contMet];
            
            sensitivity_1contMet = [sensitivity_1contMet; sensitivity_Hynne_1contMet];
            sensitivity_2contMet = [sensitivity_2contMet; sensitivity_Hynne_2contMet];
            sensitivity_3contMet = [sensitivity_3contMet; sensitivity_Hynne_3contMet];
            
            specificity_1contMet = [specificity_1contMet; specificity_Hynne_1contMet];
            specificity_2contMet = [specificity_2contMet; specificity_Hynne_2contMet];
            specificity_3contMet = [specificity_3contMet; specificity_Hynne_3contMet];
            
            if exist('ppv_Hynne_1contMet','var')
                ppv_1contMet = [ppv_1contMet; ppv_Hynne_1contMet];
                ppv_2contMet = [ppv_2contMet; ppv_Hynne_2contMet];
                if exist('ppv_Hynne_3contMet','var')
                    ppv_3contMet = [ppv_3contMet; ppv_Hynne_3contMet];
                end
                
                F1_1contMet = [F1_1contMet (ppv_Hynne_1contMet*sensitivity_Hynne_1contMet)/(ppv_Hynne_1contMet + sensitivity_Hynne_1contMet)];
                F1_2contMet = [F1_1contMet (ppv_Hynne_2contMet*sensitivity_Hynne_2contMet)/(ppv_Hynne_2contMet + sensitivity_Hynne_2contMet)];
                if exist('ppv_Hynne_3contMet','var')
                    F1_3contMet = [F1_3contMet (ppv_Hynne_3contMet*sensitivity_Hynne_3contMet)/(ppv_Hynne_3contMet + sensitivity_Hynne_3contMet)];
                end
            end
            
            
            ppv_1contMet_random = [ppv_1contMet_random; randomdata.ppv_Hynne_1contMet];
            ppv_2contMet_random = [ppv_2contMet_random; randomdata.ppv_Hynne_2contMet];
            ppv_3contMet_random = [ppv_3contMet_random; randomdata.ppv_Hynne_3contMet];
            
            F1_1contMet_random = [F1_1contMet_random; (randomdata.ppv_Hynne_1contMet*randomdata.sensitivity_Hynne_1contMet)/(randomdata.ppv_Hynne_1contMet + sensitivity_Hynne_1contMet)];
            F1_2contMet_random = [F1_2contMet_random; (randomdata.ppv_Hynne_1contMet*randomdata.sensitivity_Hynne_1contMet)/(randomdata.ppv_Hynne_1contMet + sensitivity_Hynne_1contMet)];
            F1_3contMet_random = [F1_3contMet_random; (randomdata.ppv_Hynne_1contMet*randomdata.sensitivity_Hynne_1contMet)/(randomdata.ppv_Hynne_1contMet + sensitivity_Hynne_1contMet)];
        end
        mean_accuracy_1contMet(condition_count) = nanmean(accuracy_1contMet);
        mean_accuracy_2contMet(condition_count) = nanmean(accuracy_2contMet);
        mean_accuracy_3contMet(condition_count) = nanmean(accuracy_3contMet);
        
        mean_sensitivity_1contMet(condition_count) = nanmean(sensitivity_1contMet);
        mean_sensitivity_2contMet(condition_count) = nanmean(sensitivity_2contMet);
        mean_sensitivity_3contMet(condition_count) = nanmean(sensitivity_3contMet);
        
        mean_specificity_1contMet(condition_count) = nanmean(specificity_1contMet);
        mean_specificity_2contMet(condition_count) = nanmean(specificity_2contMet);
        mean_specificity_3contMet(condition_count) = nanmean(specificity_3contMet);
        
        mean_ppv_1contMet(condition_count) = nanmean(ppv_1contMet);
        mean_ppv_2contMet(condition_count) = nanmean(ppv_2contMet);
        mean_ppv_3contMet(condition_count) = nanmean(ppv_3contMet);
        
        mean_F1_1contMet(condition_count) = nanmean(F1_1contMet);
        mean_F1_2contMet(condition_count) = nanmean(F1_2contMet);
        mean_F1_3contMet(condition_count) = nanmean(F1_3contMet);
        
        sem_accuracy_1contMet(condition_count) = nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet)));
        sem_accuracy_2contMet(condition_count) = nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet)));
        sem_accuracy_3contMet(condition_count) = nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet)));
        
        sem_sensitivity_1contMet(condition_count) = nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet)));
        sem_sensitivity_2contMet(condition_count) = nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet)));
        sem_sensitivity_3contMet(condition_count) = nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet)));
        
        sem_specificity_1contMet(condition_count) = nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet)));
        sem_specificity_2contMet(condition_count) = nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet)));
        sem_specificity_3contMet(condition_count) = nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet)));
        
        sem_ppv_1contMet(condition_count) = nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));
        sem_ppv_2contMet(condition_count) = nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));
        sem_ppv_3contMet(condition_count) = nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)));
        
        sem_F1_1contMet(condition_count) = nanstd(F1_1contMet)/sqrt(sum(~isnan(F1_1contMet)));
        sem_F1_2contMet(condition_count) = nanstd(F1_2contMet)/sqrt(sum(~isnan(F1_2contMet)));
        sem_F1_3contMet(condition_count) = nanstd(F1_3contMet)/sqrt(sum(~isnan(F1_3contMet)));
        
        
        mean_ppv_1contMet_random(condition_count) = nanmean(ppv_1contMet_random);
        mean_ppv_2contMet_random(condition_count) = nanmean(ppv_2contMet_random);
        mean_ppv_3contMet_random(condition_count) = nanmean(ppv_3contMet_random);
        
        mean_F1_1contMet_random(condition_count) = nanmean(F1_1contMet_random);
        mean_F1_2contMet_random(condition_count) = nanmean(F1_2contMet_random);
        mean_F1_3contMet_random(condition_count) = nanmean(F1_3contMet_random);
        
        sem_ppv_1contMet_random(condition_count) = nanstd(ppv_1contMet_random)/sqrt(sum(~isnan(ppv_1contMet_random)));
        sem_ppv_2contMet_random(condition_count) = nanstd(ppv_2contMet_random)/sqrt(sum(~isnan(ppv_2contMet_random)));
        sem_ppv_3contMet_random(condition_count) = nanstd(ppv_3contMet_random)/sqrt(sum(~isnan(ppv_3contMet_random)));
        
        sem_F1_1contMet_random(condition_count) = nanstd(F1_1contMet_random)/sqrt(sum(~isnan(F1_1contMet_random)));
        sem_F1_2contMet_random(condition_count) = nanstd(F1_2contMet_random)/sqrt(sum(~isnan(F1_2contMet_random)));
        sem_F1_3contMet_random(condition_count) = nanstd(F1_3contMet_random)/sqrt(sum(~isnan(F1_3contMet_random)));
        
        condition_count = condition_count + 1;
    end
end

a = annotation('textbox', [0.11 0.51 0 0],'String','G.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.39 0.51 0 0],'String','H.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.67 0.51 0 0],'String','I.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(4,3,7)
hold on
errorbar(1:4,100*mean_F1_1contMet,100*sem_F1_1contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_1contMet_random,100*sem_F1_1contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels;
set(gca,'FontSize',11)
title({'S. cerevisiae Model','One-Controller Metabolite'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,8)
hold on
errorbar(1:4,100*mean_F1_2contMet,100*sem_F1_2contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_2contMet_random,100*sem_F1_2contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'S. cerevisiae Model','Two-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,9)
hold on
errorbar(1:4,100*mean_F1_3contMet,100*sem_F1_3contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_3contMet_random,100*sem_F1_3contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'S. cerevisiae Model','Three-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);


% E. coli
condition_count = 1;
for cov = [5 15]
    for nT = [50 15]
        accuracy_1contMet = [];
        accuracy_2contMet = [];
        accuracy_3contMet = [];
        
        sensitivity_1contMet = [];
        sensitivity_2contMet = [];
        sensitivity_3contMet = [];
        
        specificity_1contMet = [];
        specificity_2contMet = [];
        specificity_3contMet = [];
        
        ppv_1contMet = [];
        ppv_2contMet = [];
        ppv_3contMet = [];
        
        F1_1contMet = [];
        F1_2contMet = [];
        F1_3contMet = [];
        
        ppv_1contMet_random = [];
        ppv_2contMet_random = [];
        ppv_3contMet_random = [];
        
        F1_1contMet_random = [];
        F1_2contMet_random = [];
        F1_3contMet_random = [];
        
        for rep = 1:repetitions
            filename = sprintf('results/ecoli_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            if exist(filename)
                load(filename,'predictionAccuracy_Chass_1contMet','predictionAccuracy_Chass_2contMet','predictionAccuracy_Chass_3contMet',...
                'sensitivity_Chass_1contMet','sensitivity_Chass_2contMet','sensitivity_Chass_3contMet',...
                'specificity_Chass_1contMet','specificity_Chass_2contMet','specificity_Chass_3contMet',...
                'ppv_Chass_1contMet','ppv_Chass_2contMet','ppv_Chass_3contMet');

                randomdata = load(sprintf('results/randomclassifier/ecoli_random_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep),...
                    'sensitivity_Chass_1contMet','sensitivity_Chass_2contMet','sensitivity_Chass_3contMet',...
                    'ppv_Chass_1contMet','ppv_Chass_2contMet','ppv_Chass_3contMet');
            
            
                accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_Chass_1contMet];
                accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_Chass_2contMet];
                if exist('predictionAccuracy_Chass_3contMet','var')
                    accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_Chass_3contMet];
                end

                sensitivity_1contMet = [sensitivity_1contMet; sensitivity_Chass_1contMet];
                sensitivity_2contMet = [sensitivity_2contMet; sensitivity_Chass_2contMet];
                if exist('sensitivity_Chass_3contMet','var')
                    sensitivity_3contMet = [sensitivity_3contMet; sensitivity_Chass_3contMet];
                end

                specificity_1contMet = [specificity_1contMet; specificity_Chass_1contMet];
                specificity_2contMet = [specificity_2contMet; specificity_Chass_2contMet];
                if exist('specificity_Chass_3contMet','var')
                    specificity_3contMet = [specificity_3contMet; specificity_Chass_3contMet];
                end
                
                if exist('ppv_Chass_1contMet','var')
                    ppv_1contMet = [ppv_1contMet; ppv_Chass_1contMet];
                    ppv_2contMet = [ppv_2contMet; ppv_Chass_2contMet];
                    if exist('ppv_Chass_3contMet','var')
                        ppv_3contMet = [ppv_3contMet; ppv_Chass_3contMet];
                    end
                    
                    F1_1contMet = [F1_1contMet (ppv_Chass_1contMet*sensitivity_Chass_1contMet)/(ppv_Chass_1contMet + sensitivity_Chass_1contMet)];
                    F1_2contMet = [F1_1contMet (ppv_Chass_2contMet*sensitivity_Chass_2contMet)/(ppv_Chass_2contMet + sensitivity_Chass_2contMet)];
                    if exist('ppv_Chass_3contMet','var')
                        F1_3contMet = [F1_3contMet (ppv_Chass_3contMet*sensitivity_Chass_3contMet)/(ppv_Chass_3contMet + sensitivity_Chass_3contMet)];
                    end
                end
                
                
                ppv_1contMet_random = [ppv_1contMet_random; randomdata.ppv_Chass_1contMet];
                ppv_2contMet_random = [ppv_2contMet_random; randomdata.ppv_Chass_2contMet];
                ppv_3contMet_random = [ppv_3contMet_random; randomdata.ppv_Chass_3contMet];
                
                F1_1contMet_random = [F1_1contMet_random; (randomdata.ppv_Chass_1contMet*randomdata.sensitivity_Chass_1contMet)/(randomdata.ppv_Chass_1contMet + sensitivity_Chass_1contMet)];
                F1_2contMet_random = [F1_2contMet_random; (randomdata.ppv_Chass_1contMet*randomdata.sensitivity_Chass_1contMet)/(randomdata.ppv_Chass_1contMet + sensitivity_Chass_1contMet)];
                F1_3contMet_random = [F1_3contMet_random; (randomdata.ppv_Chass_1contMet*randomdata.sensitivity_Chass_1contMet)/(randomdata.ppv_Chass_1contMet + sensitivity_Chass_1contMet)];
            end
        end
        mean_accuracy_1contMet(condition_count) = nanmean(accuracy_1contMet);
        mean_accuracy_2contMet(condition_count) = nanmean(accuracy_2contMet);
        mean_accuracy_3contMet(condition_count) = nanmean(accuracy_3contMet);
        
        mean_sensitivity_1contMet(condition_count) = nanmean(sensitivity_1contMet);
        mean_sensitivity_2contMet(condition_count) = nanmean(sensitivity_2contMet);
        mean_sensitivity_3contMet(condition_count) = nanmean(sensitivity_3contMet);
        
        mean_specificity_1contMet(condition_count) = nanmean(specificity_1contMet);
        mean_specificity_2contMet(condition_count) = nanmean(specificity_2contMet);
        mean_specificity_3contMet(condition_count) = nanmean(specificity_3contMet);
        
        mean_ppv_1contMet(condition_count) = nanmean(ppv_1contMet);
        mean_ppv_2contMet(condition_count) = nanmean(ppv_2contMet);
        mean_ppv_3contMet(condition_count) = nanmean(ppv_3contMet);
        
        mean_F1_1contMet(condition_count) = nanmean(F1_1contMet);
        mean_F1_2contMet(condition_count) = nanmean(F1_2contMet);
        mean_F1_3contMet(condition_count) = nanmean(F1_3contMet);
        
        sem_accuracy_1contMet(condition_count) = nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet)));
        sem_accuracy_2contMet(condition_count) = nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet)));
        sem_accuracy_3contMet(condition_count) = nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet)));
        
        sem_sensitivity_1contMet(condition_count) = nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet)));
        sem_sensitivity_2contMet(condition_count) = nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet)));
        sem_sensitivity_3contMet(condition_count) = nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet)));
        
        sem_specificity_1contMet(condition_count) = nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet)));
        sem_specificity_2contMet(condition_count) = nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet)));
        sem_specificity_3contMet(condition_count) = nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet)));
        
        sem_ppv_1contMet(condition_count) = nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));
        sem_ppv_2contMet(condition_count) = nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));
        sem_ppv_3contMet(condition_count) = nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)));
        
        sem_F1_1contMet(condition_count) = nanstd(F1_1contMet)/sqrt(sum(~isnan(F1_1contMet)));
        sem_F1_2contMet(condition_count) = nanstd(F1_2contMet)/sqrt(sum(~isnan(F1_2contMet)));
        sem_F1_3contMet(condition_count) = nanstd(F1_3contMet)/sqrt(sum(~isnan(F1_3contMet)));
        
        
        mean_ppv_1contMet_random(condition_count) = nanmean(ppv_1contMet_random);
        mean_ppv_2contMet_random(condition_count) = nanmean(ppv_2contMet_random);
        mean_ppv_3contMet_random(condition_count) = nanmean(ppv_3contMet_random);
        
        mean_F1_1contMet_random(condition_count) = nanmean(F1_1contMet_random);
        mean_F1_2contMet_random(condition_count) = nanmean(F1_2contMet_random);
        mean_F1_3contMet_random(condition_count) = nanmean(F1_3contMet_random);
        
        sem_ppv_1contMet_random(condition_count) = nanstd(ppv_1contMet_random)/sqrt(sum(~isnan(ppv_1contMet_random)));
        sem_ppv_2contMet_random(condition_count) = nanstd(ppv_2contMet_random)/sqrt(sum(~isnan(ppv_2contMet_random)));
        sem_ppv_3contMet_random(condition_count) = nanstd(ppv_3contMet_random)/sqrt(sum(~isnan(ppv_3contMet_random)));
        
        sem_F1_1contMet_random(condition_count) = nanstd(F1_1contMet_random)/sqrt(sum(~isnan(F1_1contMet_random)));
        sem_F1_2contMet_random(condition_count) = nanstd(F1_2contMet_random)/sqrt(sum(~isnan(F1_2contMet_random)));
        sem_F1_3contMet_random(condition_count) = nanstd(F1_3contMet_random)/sqrt(sum(~isnan(F1_3contMet_random)));
        
        condition_count = condition_count + 1;
    end
end

a = annotation('textbox', [0.11 0.29 0 0],'String','J.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.39 0.29 0 0],'String','K.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

a = annotation('textbox', [0.67 0.29 0 0],'String','L.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(4,3,10)
hold on
errorbar(1:4,100*mean_F1_1contMet,100*sem_F1_1contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_1contMet_random,100*sem_F1_1contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels;
set(gca,'FontSize',11)
title({'E. coli Model','One-Controller Metabolite'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,11)
hold on
errorbar(1:4,100*mean_F1_2contMet,100*sem_F1_2contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_2contMet_random,100*sem_F1_2contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'E. coli Model','Two-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);

subplot(4,3,12)
hold on
errorbar(1:4,100*mean_F1_3contMet,100*sem_F1_3contMet,'k','LineWidth',1.5);
errorbar(1:4,100*mean_F1_3contMet_random,100*sem_F1_3contMet_random,'k--','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels; 
set(gca,'FontSize',11)
title({'E. coli Model','Three-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 110]);


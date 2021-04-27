% Plot Fig. 4
clear;clc;

names = categorical({'One-Cont. met','Two-Cont. met','Three-Cont. met'});
names = reordercats(names,{'One-Cont. met','Two-Cont. met','Three-Cont. met'});
repetitions = 30;
figure;
set(gcf, 'Position',  [100, 100, 1500, 500])

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
        
        accuracy_1contMet_random = [];
        accuracy_2contMet_random = [];
        accuracy_3contMet_random = [];
        
        sensitivity_1contMet_random = [];
        sensitivity_2contMet_random = [];
        sensitivity_3contMet_random = [];
        
        specificity_1contMet_random = [];
        specificity_2contMet_random = [];
        specificity_3contMet_random = [];
        
        ppv_1contMet_random = [];
        ppv_2contMet_random = [];
        ppv_3contMet_random = [];
        
        for rep = 1:repetitions
            filename = sprintf('results/autogentestdata/AutogenTest_results_IC-15_nT-%03d_cov-%02d_rep-%02d_compact.mat',nT,cov,rep);
            load(filename,'predictionAccuracy_AutogenTest_1contMet','predictionAccuracy_AutogenTest_2contMet','predictionAccuracy_AutogenTest_3contMet',...
                'sensitivity_AutogenTest_1contMet','sensitivity_AutogenTest_2contMet','sensitivity_AutogenTest_3contMet',...
                'specificity_AutogenTest_1contMet','specificity_AutogenTest_2contMet','specificity_AutogenTest_3contMet',...
                'ppv_AutogenTest_1contMet','ppv_AutogenTest_2contMet','ppv_AutogenTest_3contMet');
            
            
            accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_AutogenTest_1contMet];
            accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_AutogenTest_2contMet];
            if exist('predictionAccuracy_AutogenTest_3contMet')
                accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_AutogenTest_3contMet];
            end
            
            sensitivity_1contMet = [sensitivity_1contMet; sensitivity_AutogenTest_1contMet];
            sensitivity_2contMet = [sensitivity_2contMet; sensitivity_AutogenTest_2contMet];
            if exist('sensitivity_AutogenTest_3contMet')
                sensitivity_3contMet = [sensitivity_3contMet; sensitivity_AutogenTest_3contMet];
            end
            
            specificity_1contMet = [specificity_1contMet; specificity_AutogenTest_1contMet];
            specificity_2contMet = [specificity_2contMet; specificity_AutogenTest_2contMet];
            if exist('specificity_AutogenTest_3contMet')
                specificity_3contMet = [specificity_3contMet; specificity_AutogenTest_3contMet];
            end
            
            if exist('ppv_AutogenTest_1contMet','var')
                ppv_1contMet = [ppv_1contMet; ppv_AutogenTest_1contMet];
                ppv_2contMet = [ppv_2contMet; ppv_AutogenTest_2contMet];
                if exist('ppv_AutogenTest_3contMet','var')
                    ppv_3contMet = [ppv_3contMet; ppv_AutogenTest_3contMet];
                end
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

subplot(1,3,1)
hold on
errorbar(1:4,100*mean_accuracy_1contMet,100*sem_accuracy_1contMet,'r','LineWidth',1.5);
errorbar(1:4,100*mean_sensitivity_1contMet,100*sem_sensitivity_1contMet,'g','LineWidth',1.5);
errorbar(1:4,100*mean_specificity_1contMet,100*sem_specificity_1contMet,'b','LineWidth',1.5);
errorbar(1:4,100*mean_ppv_1contMet,100*sem_ppv_1contMet,'m','LineWidth',1.5);
row1 = {'nT = 50' 'nT = 15' 'nT = 50' 'nT = 15'};
row2 = {'CoV = 0.05' 'CoV = 0.05' 'CoV = 0.15' 'CoV = 0.15'};
labelArray = [row1; row2]; 
labelArray = strjust(pad(labelArray),'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = tickLabels;
legend('Accuracy','Sensitivity','Specificity','PPV','FontSize',11,'location','northwest')
set(gca,'FontSize',11)
title({'Autogenerated Testing Data','One-Controller Metabolite'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 105]);

subplot(1,3,2)
hold on
errorbar(1:4,100*mean_accuracy_2contMet,100*sem_accuracy_2contMet,'r','LineWidth',1.5);
errorbar(1:4,100*mean_sensitivity_2contMet,100*sem_sensitivity_2contMet,'g','LineWidth',1.5);
errorbar(1:4,100*mean_specificity_2contMet,100*sem_specificity_2contMet,'b','LineWidth',1.5);
errorbar(1:4,100*mean_ppv_2contMet,100*sem_ppv_2contMet,'m','LineWidth',1.5);
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
title({'Autogenerated Testing Data','Two-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 105]);

subplot(1,3,3)
hold on
errorbar(1:4,100*mean_accuracy_3contMet,100*sem_accuracy_3contMet,'r','LineWidth',1.5);
errorbar(1:4,100*mean_sensitivity_3contMet,100*sem_sensitivity_3contMet,'g','LineWidth',1.5);
errorbar(1:4,100*mean_specificity_3contMet,100*sem_specificity_3contMet,'b','LineWidth',1.5);
errorbar(1:4,100*mean_ppv_3contMet,100*sem_ppv_3contMet,'m','LineWidth',1.5);
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
title({'Autogenerated Testing Data','Three-Controller Metabolites'},'FontSize',13);
ylabel('%')
xlim([0.75 4.25])
ylim([-5 105]);



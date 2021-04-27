% Plot Fig. 3
clear;clc;

plotcount = 1;
names = categorical({'1 cont. met','2 cont. met','3 cont. met'});
names = reordercats(names,{'1 cont. met','2 cont. met','3 cont. met'});
repetitions = 30;
figure;
set(gcf, 'Position',  [100, 100, 1300, 900])

% Smaller Synthetic Model
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

for rep = 1:repetitions
    filename = sprintf('results/synthetic_results_IC-15_rep-%02d_compact.mat',rep);
    load(filename,'predictionAccuracy_SmallerModel_1contMet','predictionAccuracy_SmallerModel_2contMet','predictionAccuracy_SmallerModel_3contMet',...
        'sensitivity_SmallerModel_1contMet','sensitivity_SmallerModel_2contMet','sensitivity_SmallerModel_3contMet',...
        'specificity_SmallerModel_1contMet','specificity_SmallerModel_2contMet','specificity_SmallerModel_3contMet',...
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
    end
end
a = annotation('textbox', [0.11 0.96 0 0],'String','A.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(2,2,plotcount)
y = 100*[nanmean(accuracy_1contMet) nanmean(sensitivity_1contMet) nanmean(specificity_1contMet) nanmean(ppv_1contMet);...
    nanmean(accuracy_2contMet) nanmean(sensitivity_2contMet) nanmean(specificity_2contMet) nanmean(ppv_2contMet);...
    nanmean(accuracy_3contMet) nanmean(sensitivity_3contMet) nanmean(specificity_3contMet) nanmean(ppv_3contMet)];
bar(y');

row = {'Accuracy' 'Sensitivity' 'Specificity' 'PPV'}; 
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = row; 
hold on

% Error bars
err = 100*[nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet))) nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet))) nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet))) nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));...
    nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet))) nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet))) nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet))) nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));...
    nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet))) nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet))) nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet))) nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)))];
ngroups = 4;
nbars = 3;
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(i,:), err(i,:), 'k.');
end
ylim([0 105])

if plotcount == 1
    legend('1-controller','2-controller','3-controller','Location','Northwest');
end
ylabel('%');
title({'Smaller Synthetic Model';'Noiseless'});
plotcount = plotcount + 1;
set(gca,'FontSize',12,'FontWeight','bold')

% Bigger Synthetic Model
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

for rep = 1:repetitions
    filename = sprintf('results/synthetic_results_IC-15_rep-%02d_compact.mat',rep);
    load(filename,'predictionAccuracy_BiggerModel_1contMet','predictionAccuracy_BiggerModel_2contMet','predictionAccuracy_BiggerModel_3contMet',...
        'sensitivity_BiggerModel_1contMet','sensitivity_BiggerModel_2contMet','sensitivity_BiggerModel_3contMet',...
        'specificity_BiggerModel_1contMet','specificity_BiggerModel_2contMet','specificity_BiggerModel_3contMet',...
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
    end
end
a = annotation('textbox', [0.55 0.96 0 0],'String','B.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(2,2,plotcount)
y = 100*[nanmean(accuracy_1contMet) nanmean(sensitivity_1contMet) nanmean(specificity_1contMet) nanmean(ppv_1contMet);...
    nanmean(accuracy_2contMet) nanmean(sensitivity_2contMet) nanmean(specificity_2contMet) nanmean(ppv_2contMet);...
    nanmean(accuracy_3contMet) nanmean(sensitivity_3contMet) nanmean(specificity_3contMet) nanmean(ppv_3contMet)];
bar(y');

row = {'Accuracy' 'Sensitivity' 'Specificity' 'PPV'}; 
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = row; 
hold on

% Error bars
err = 100*[nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet))) nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet))) nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet))) nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));...
    nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet))) nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet))) nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet))) nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));...
    nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet))) nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet))) nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet))) nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)))];
ngroups = 4;
nbars = 3;
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(i,:), err(i,:), 'k.');
end
ylim([0 105])

if plotcount == 1
    legend('1-controller','2-controller','3-controller','Location','Northwest');
end
ylabel('%');
title({'Bigger Synthetic Model';'Noiseless'});
plotcount = plotcount + 1;
set(gca,'FontSize',12,'FontWeight','bold')

% S. cerevisiae
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

for rep = 1:repetitions
    filename = sprintf('results/yeast_results_IC-15_rep-%02d_compact.mat',rep);
    load(filename,'predictionAccuracy_Hynne_1contMet','predictionAccuracy_Hynne_2contMet','predictionAccuracy_Hynne_3contMet',...
        'sensitivity_Hynne_1contMet','sensitivity_Hynne_2contMet','sensitivity_Hynne_3contMet',...
        'specificity_Hynne_1contMet','specificity_Hynne_2contMet','specificity_Hynne_3contMet',...
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
        ppv_3contMet = [ppv_3contMet; ppv_Hynne_3contMet];
    end
end
a = annotation('textbox', [0.11 0.49 0 0],'String','C.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(2,2,plotcount)
y = 100*[nanmean(accuracy_1contMet) nanmean(sensitivity_1contMet) nanmean(specificity_1contMet) nanmean(ppv_1contMet);...
    nanmean(accuracy_2contMet) nanmean(sensitivity_2contMet) nanmean(specificity_2contMet) nanmean(ppv_2contMet);...
    nanmean(accuracy_3contMet) nanmean(sensitivity_3contMet) nanmean(specificity_3contMet) nanmean(ppv_3contMet)];
bar(y');

row = {'Accuracy' 'Sensitivity' 'Specificity' 'PPV'}; 
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = row; 
hold on

% Error bars
err = 100*[nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet))) nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet))) nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet))) nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));...
    nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet))) nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet))) nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet))) nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));...
    nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet))) nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet))) nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet))) nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)))];
ngroups = 4;
nbars = 3;
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(i,:), err(i,:), 'k.');
end
ylim([0 105])

if plotcount == 1
    legend('1-controller','2-controller','3-controller','Location','Northwest');
end
ylabel('%');
title({'S. cerevisiae Model';'Noiseless'});
plotcount = plotcount + 1;
set(gca,'FontSize',12,'FontWeight','bold')

% E. coli
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

for rep = 1:repetitions
    filename = sprintf('results/ecoli_results_IC-15_rep-%02d_compact.mat',rep);
    if exist(filename)
        load(filename,'predictionAccuracy_Chass_1contMet','predictionAccuracy_Chass_2contMet','predictionAccuracy_Chass_3contMet',...
        'sensitivity_Chass_1contMet','sensitivity_Chass_2contMet','sensitivity_Chass_3contMet',...
        'specificity_Chass_1contMet','specificity_Chass_2contMet','specificity_Chass_3contMet',...
        'ppv_Chass_1contMet','ppv_Chass_2contMet','ppv_Chass_3contMet');

        accuracy_1contMet = [accuracy_1contMet; predictionAccuracy_Chass_1contMet];
        accuracy_2contMet = [accuracy_2contMet; predictionAccuracy_Chass_2contMet];
        accuracy_3contMet = [accuracy_3contMet; predictionAccuracy_Chass_3contMet];

        sensitivity_1contMet = [sensitivity_1contMet; sensitivity_Chass_1contMet];
        sensitivity_2contMet = [sensitivity_2contMet; sensitivity_Chass_2contMet];
        sensitivity_3contMet = [sensitivity_3contMet; sensitivity_Chass_3contMet];

        specificity_1contMet = [specificity_1contMet; specificity_Chass_1contMet];
        specificity_2contMet = [specificity_2contMet; specificity_Chass_2contMet];
        specificity_3contMet = [specificity_3contMet; specificity_Chass_3contMet];

        if exist('ppv_Chass_1contMet','var')
            ppv_1contMet = [ppv_1contMet; ppv_Chass_1contMet];
            ppv_2contMet = [ppv_2contMet; ppv_Chass_2contMet];
            ppv_3contMet = [ppv_3contMet; ppv_Chass_3contMet];
        end
    end
end
a = annotation('textbox', [0.55 0.49 0 0],'String','D.','EdgeColor','none');
a.FontSize = 14;
a.FontWeight = 'bold';

subplot(2,2,plotcount)
y = 100*[nanmean(accuracy_1contMet) nanmean(sensitivity_1contMet) nanmean(specificity_1contMet) nanmean(ppv_1contMet);...
    nanmean(accuracy_2contMet) nanmean(sensitivity_2contMet) nanmean(specificity_2contMet) nanmean(ppv_2contMet);...
    nanmean(accuracy_3contMet) nanmean(sensitivity_3contMet) nanmean(specificity_3contMet) nanmean(ppv_3contMet)];
bar(y');

row = {'Accuracy' 'Sensitivity' 'Specificity' 'PPV'}; 
ax = gca(); 
ax.XTick = 1:4; 
ax.XLim = [0,5];
ax.XTickLabel = row; 
hold on

% Error bars
err = 100*[nanstd(accuracy_1contMet)/sqrt(sum(~isnan(accuracy_1contMet))) nanstd(sensitivity_1contMet)/sqrt(sum(~isnan(sensitivity_1contMet))) nanstd(specificity_1contMet)/sqrt(sum(~isnan(specificity_1contMet))) nanstd(ppv_1contMet)/sqrt(sum(~isnan(ppv_1contMet)));...
    nanstd(accuracy_2contMet)/sqrt(sum(~isnan(accuracy_2contMet))) nanstd(sensitivity_2contMet)/sqrt(sum(~isnan(sensitivity_2contMet))) nanstd(specificity_2contMet)/sqrt(sum(~isnan(specificity_2contMet))) nanstd(ppv_2contMet)/sqrt(sum(~isnan(ppv_2contMet)));...
    nanstd(accuracy_3contMet)/sqrt(sum(~isnan(accuracy_3contMet))) nanstd(sensitivity_3contMet)/sqrt(sum(~isnan(sensitivity_3contMet))) nanstd(specificity_3contMet)/sqrt(sum(~isnan(specificity_3contMet))) nanstd(ppv_3contMet)/sqrt(sum(~isnan(ppv_3contMet)))];
ngroups = 4;
nbars = 3;
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(i,:), err(i,:), 'k.');
end
ylim([0 105])

if plotcount == 1
    legend('1-controller','2-controller','3-controller','Location','Northwest');
end
ylabel('%');
title({'E. coli Model';'Noiseless'});
plotcount = plotcount + 1;
set(gca,'FontSize',12,'FontWeight','bold')
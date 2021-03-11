% Generate Fig. S3

clear;clc;

% Chass 2-controller metabolite interactions (met1,met2,flux)
interaction_list = [2 18 4;     %1
                    3 10 6;     %2
                    4 10 21;    %3
                    4 18 31;    %4
                    5 6 13;     %5
                    5 7 12;     %6
                    7 8 16;     %7
                    8 9 18;     %8
                    9 10 19;    %9
                    10 17 24;   %10
                    13 14 29;   %11
                    13 16 28;   %12
                    4 10 20;];  %13

count = 1;
figure;
for interaction_idx = [7 8 9] % Highly correlated interactions from interaction_list
    allConc1=[];
    allConc2=[];
    allFlux=[];
    met1 = interaction_list(interaction_idx,1);
    met2 = interaction_list(interaction_idx,2);
    flux = interaction_list(interaction_idx,3);

    for k = 1:15
        load(sprintf('chassV_k-%02d_hiRes',k))
        allConc1 = [allConc1 concMatrix(2:end-1,met1)];
        allConc2 = [allConc2 concMatrix(2:end-1,met2)];
        allFlux = [allFlux fluxMatrix(2:end,flux)];
    end
    subplot(1,3,count)
    plot(allConc1,allConc2,'o')
    xlabel(sprintf('Metabolite %d',met1'))
    ylabel(sprintf('Metabolite %d',met2'))
    title(sprintf('Interaction with Flux %d',flux))
    grid on
    set(gca,'FontSize',18)
    
    count = count + 1;
end
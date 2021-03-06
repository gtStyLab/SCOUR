function SCOUR_Ecoli_random(nT,cov,num_IC,rep)
warning('off','all')
rng('shuffle');

fprintf('Starting machine learning framework...\n');

%% Initial Preparation of Chass E. coli model
% Train on autogenerated data, test on Chass E. coli model

% E. coli stoichiometric interactions
load('chassSTM.mat');
Chass.S = stm;

% Find Chass mass action (MA) interactions
[row_ChassMA col_ChassMA] = find(Chass.S < 0);
ChassMA = [row_ChassMA col_ChassMA];

% Remove Mureine Synthesis reaction because it is held constant
ChassMA(13,:) = [];

unique_flux = unique(ChassMA(:,2));
count_1contMet = 1;
count_2contMet = 1;
for i = 1:length(unique_flux)
    controller_met_idx = find(ChassMA(:,2) == unique_flux(i));
    if length(ChassMA(controller_met_idx,1)) == 1
        ChassMA_1contMet_List(count_1contMet,:) = [ChassMA(controller_met_idx,1)' unique_flux(i)];
        count_1contMet = count_1contMet + 1;
    elseif length(ChassMA(controller_met_idx,1)) == 2
        ChassMA_2contMet_List(count_2contMet,:) = [ChassMA(controller_met_idx,1)' unique_flux(i)];
        count_2contMet = count_2contMet + 1;
    end
end

Chass_prefix = 'chassV';

%% Identify 1 controller metabolite reactions

% List of Chass interactions with one controller metabolite
true_1contMet_Chass = [2,5;
                        6,15;
                        8,17;
                        10,22;
                        11,23;
                        11,25;
                        12,27;
                        16,30;
                        2,32;
                        3,33;
                        4,34;
                        5,35;
                        6,36;
                        7,37;
                        8,38;
                        9,39;
                        10,40;
                        11,41;
                        12,42;
                        13,43;
                        14,44;
                        15,45;
                        16,46;
                        17,47;
                        18,48;];
count = 1;
for regIdx = 1:length(ChassMA_1contMet_List)
    for trueIdx = 1:size(true_1contMet_Chass,1)
        if isequal(ChassMA_1contMet_List(regIdx,:),true_1contMet_Chass(trueIdx,:))
            Chass_1contMet_trueInRegIdx(count,1) = regIdx;
            count = count + 1;
        end
    end
end

% Chass
% Setup testing set and testing label
testingLabel_Chass_1contMet = logical(zeros(size(ChassMA_1contMet_List,1),1));
testingLabel_Chass_1contMet(Chass_1contMet_trueInRegIdx) = 1;

% Random prediction
predictedLabel_L2_Chass_1contMet = logical(round(rand(length(testingLabel_Chass_1contMet),1)))

% Accuracy, sensitivity, and specificity calculations
predictionAccuracy_Chass_1contMet = sum(predictedLabel_L2_Chass_1contMet==testingLabel_Chass_1contMet)/length(testingLabel_Chass_1contMet)
fp = 0;
fn = 0;
for k = 1:length(testingLabel_Chass_1contMet)
    if testingLabel_Chass_1contMet(k) == 1 && predictedLabel_L2_Chass_1contMet(k) == 0
        fn = fn + 1;
    elseif testingLabel_Chass_1contMet(k) == 0 && predictedLabel_L2_Chass_1contMet(k) == 1
        fp = fp + 1;
    end
end

tp = 0;
tn = 0;
for k = 1:length(testingLabel_Chass_1contMet)
    if testingLabel_Chass_1contMet(k) == 1 && predictedLabel_L2_Chass_1contMet(k) == 1
        tp = tp + 1;
    elseif testingLabel_Chass_1contMet(k) == 0 && predictedLabel_L2_Chass_1contMet(k) == 0
        tn = tn + 1;
    end
end
sensitivity_Chass_1contMet = tp / (fn+tp)
specificity_Chass_1contMet = tn / (tn+fp)
ppv_Chass_1contMet = tp / (tp+fp);
npv_Chass_1contMet = tp / (tn+fn);

%% Remove 1 controller metabolite reactions

% Remove from Chass using predicted 1 controller metabolite
% interactions
predicted_Chass_1contMet = [ChassMA_1contMet_List(find(predictedLabel_L2_Chass_1contMet==1),:)];

%Chass_fluxes_to_remove =  unique([1 10 14 26 predicted_Chass_1contMet(:,2)']); % 10, 14, and 26 are fluxes that are held constant
Chass_fluxes_to_remove =  unique([1 10 14 26 5 15 17 22 23 25 27 30 32:48]);
if ~isequal(sort(Chass_fluxes_to_remove),1:size(Chass.S,2))
    Chass_regScheme_2contMet = createRegSchemeList_chass(Chass.S,Chass_fluxes_to_remove);
end

if exist('Chass_regScheme_2contMet','var')
    %% Identify 2 controller metabolite reactions

    % List of Chass interactions with two controller metabolites
    true_2contMet_Chass = [2,18,4;
                            3,10,6;
                            5,7,12;
                            5,6,13;
                            7,8,16;
                            8,9,18;
                            9,10,19;
                            4,10,20;
                            4,10,21;
                            10,17,24; % 2 controller mets
                            13,16,28;
                            13,14,29;
                            4,18,31;];
    count = 1;
    for regIdx = 1:length(Chass_regScheme_2contMet)
        for trueIdx = 1:size(true_2contMet_Chass,1)
            if isequal(Chass_regScheme_2contMet(regIdx,:),true_2contMet_Chass(trueIdx,:))
                Chass_2contMet_trueInRegIdx(count,1) = regIdx;
                count = count + 1;
            end
        end
    end
    
    % Chass
    % Setup testing set and testing label
    testingLabel_Chass_2contMet = logical(zeros(size(Chass_regScheme_2contMet,1),1));
    if exist('Chass_2contMet_trueInRegIdx','var')
        testingLabel_Chass_2contMet(Chass_2contMet_trueInRegIdx) = 1;
    end
    
    % Random prediction
    predictedLabel_L2_Chass_2contMet = logical(round(rand(length(testingLabel_Chass_2contMet),1)))

    % Accuracy, sensitivity, and specificity calculations
    predictionAccuracy_Chass_2contMet = sum(predictedLabel_L2_Chass_2contMet==testingLabel_Chass_2contMet)/length(testingLabel_Chass_2contMet)
    fp = 0;
    fn = 0;
    for k = 1:length(testingLabel_Chass_2contMet)
        if testingLabel_Chass_2contMet(k) == 1 && predictedLabel_L2_Chass_2contMet(k) == 0
            fn = fn + 1;
        elseif testingLabel_Chass_2contMet(k) == 0 && predictedLabel_L2_Chass_2contMet(k) == 1
            fp = fp + 1;
        end
    end

    tp = 0;
    tn = 0;
    for k = 1:length(testingLabel_Chass_2contMet)
        if testingLabel_Chass_2contMet(k) == 1 && predictedLabel_L2_Chass_2contMet(k) == 1
            tp = tp + 1;
        elseif testingLabel_Chass_2contMet(k) == 0 && predictedLabel_L2_Chass_2contMet(k) == 0
            tn = tn + 1;
        end
    end
    sensitivity_Chass_2contMet = tp / (fn+tp)
    specificity_Chass_2contMet = tn / (tn+fp)
    ppv_Chass_2contMet = tp / (tp+fp);
    npv_Chass_2contMet = tp / (tn+fn);

    %% Remove 2 controller metabolite reactions

    % Remove from Chass using predicted 2 controller metabolite
    % interactions
    predicted_Chass_2contMet = [Chass_regScheme_2contMet(find(predictedLabel_L2_Chass_2contMet==1),:)];

    %Chass_fluxes_to_remove =  unique([1 10 14 26 predicted_Chass_1contMet(:,2)' predicted_Chass_2contMet(:,3)']); % 10, 14, and 26 are fluxes that are held constant
    Chass_fluxes_to_remove =  unique([1 10 14 26 5 15 17 22 23 25 27 30 32:48 4 6 12 13 16 18:21 2 28 29 31]);
    if ~isequal(sort(Chass_fluxes_to_remove),1:size(Chass.S,2))
        [~,Chass_regScheme_3contMet] = createRegSchemeList_chass(Chass.S,Chass_fluxes_to_remove);
    end
end

if exist('Chass_regScheme_3contMet','var')
    %% Identify 3 controller metabolite reactions

    % List of Chass interactions with three controller metabolites
    true_3contMet_Chass = [2 3 12,3;
                           4 5 6,11];
    count = 1;
    for regIdx = 1:length(Chass_regScheme_3contMet)
        for trueIdx = 1:size(true_3contMet_Chass,1)
            if isequal(Chass_regScheme_3contMet(regIdx,:),true_3contMet_Chass(trueIdx,:))
                Chass_3contMet_trueInRegIdx(count,1) = regIdx;
                count = count + 1;
            end
        end
    end
    
    % Chass
    % Setup testing set and testing label
    testingLabel_Chass_3contMet = logical(zeros(size(Chass_regScheme_3contMet,1),1));
    if exist('Chass_3contMet_trueInRegIdx','var')
        testingLabel_Chass_3contMet(Chass_3contMet_trueInRegIdx) = 1;
    end
    
    % Random prediction
    predictedLabel_L2_Chass_3contMet = logical(round(rand(length(testingLabel_Chass_3contMet),1)))

    % Accuracy, sensitivity, and specificity calculations
    predictionAccuracy_Chass_3contMet = sum(predictedLabel_L2_Chass_3contMet==testingLabel_Chass_3contMet)/length(testingLabel_Chass_3contMet)
    fp = 0;
    fn = 0;
    for k = 1:length(testingLabel_Chass_3contMet)
        if testingLabel_Chass_3contMet(k) == 1 && predictedLabel_L2_Chass_3contMet(k) == 0
            fn = fn + 1;
        elseif testingLabel_Chass_3contMet(k) == 0 && predictedLabel_L2_Chass_3contMet(k) == 1
            fp = fp + 1;
        end
    end

    tp = 0;
    tn = 0;
    for k = 1:length(testingLabel_Chass_3contMet)
        if testingLabel_Chass_3contMet(k) == 1 && predictedLabel_L2_Chass_3contMet(k) == 1
            tp = tp + 1;
        elseif testingLabel_Chass_3contMet(k) == 0 && predictedLabel_L2_Chass_3contMet(k) == 0
            tn = tn + 1;
        end
    end
    sensitivity_Chass_3contMet = tp / (fn+tp)
    specificity_Chass_3contMet = tn / (tn+fp)
    ppv_Chass_3contMet = tp / (tp+fp);
    npv_Chass_3contMet = tp / (tn+fn);
    
    predicted_Chass_3contMet = [Chass_regScheme_3contMet(find(predictedLabel_L2_Chass_3contMet==1),:)];
end
save(sprintf('ecoli_random_results_IC-%02d_nT-%03d_cov-%02d_rep-%02d.mat',num_IC,nT,cov,rep));

function SCOUR_Ecoli_noisy(nT,cov,num_IC,rep)
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

% Load autogenerated data information
load(sprintf('AutoGenerateTrain_meta_1contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep),'train_true_regs_1contMet');
train_true_regs_meta_1contMet = train_true_regs_1contMet;
trueInRegIdx_AutoGenerateTrain_meta_1contMet = find(train_true_regs_meta_1contMet == 1);
load(sprintf('AutoGenerateTrain_1contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep),'train_true_regs_1contMet');
trueInRegIdx_AutoGenerateTrain_1contMet = find(train_true_regs_1contMet == 1);

% Create feature matrix
autogen_prefix = 'AutoGenerateTrain_1contMet';
autogen_meta_prefix = 'AutoGenerateTrain_meta_1contMet';
createFeatMatrix_1contMet_chass_noisy

% Normalize feature matrices
featureMatrix_AutoGenerateTrain_1contMet_n = (featureMatrix_AutoGenerateTrain_1contMet-prctile(featureMatrix_AutoGenerateTrain_1contMet,20,2))./(prctile(featureMatrix_AutoGenerateTrain_1contMet,80)-prctile(featureMatrix_AutoGenerateTrain_1contMet,20));
featureMatrix_AutoGenerateTrain_meta_1contMet_n = (featureMatrix_AutoGenerateTrain_meta_1contMet-prctile(featureMatrix_AutoGenerateTrain_meta_1contMet,20,2))./(prctile(featureMatrix_AutoGenerateTrain_meta_1contMet,80)-prctile(featureMatrix_AutoGenerateTrain_meta_1contMet,20));
featureMatrix_1contMet_Chass_n = (featureMatrix_1contMet_Chass-prctile(featureMatrix_1contMet_Chass,20,2))./(prctile(featureMatrix_1contMet_Chass,80)-prctile(featureMatrix_1contMet_Chass,20));

% Setup training set and training label
trueInteractionSet_1contMet = featureMatrix_AutoGenerateTrain_1contMet_n(:,trueInRegIdx_AutoGenerateTrain_1contMet);
trueInteractionLabel_1contMet = logical(ones(1,size(trueInteractionSet_1contMet,2)));
falseInteractionSet_1contMet = featureMatrix_AutoGenerateTrain_1contMet_n;
falseInteractionSet_1contMet(:,trueInRegIdx_AutoGenerateTrain_1contMet) = [];
falseInteractionLabel_1contMet = logical(zeros(1,size(falseInteractionSet_1contMet,2)));

trainingSet_1contMet = [trueInteractionSet_1contMet falseInteractionSet_1contMet];
trainingLabel_1contMet = [trueInteractionLabel_1contMet falseInteractionLabel_1contMet];

% Create first level models
Mdl_RF_1contMet = TreeBagger(200,trainingSet_1contMet',double(trainingLabel_1contMet),'Method','Regression','MinLeafSize',5);

Mdl_KNN_1contMet = fitcknn(trainingSet_1contMet',trainingLabel_1contMet,'NumNeighbors',6);

Mdl_SNN_1contMet = patternnet(20,'trainscg');
Mdl_SNN_1contMet.trainParam.showWindow = 0;    
Mdl_SNN_1contMet = train(Mdl_SNN_1contMet,trainingSet_1contMet,trainingLabel_1contMet);
Mdl_SNN_1contMet = train(Mdl_SNN_1contMet,trainingSet_1contMet,trainingLabel_1contMet);
Mdl_SNN_1contMet = train(Mdl_SNN_1contMet,trainingSet_1contMet,trainingLabel_1contMet);

Mdl_DA_1contMet = fitcdiscr(trainingSet_1contMet',trainingLabel_1contMet,'discrimType','pseudoLinear');

% Predicted labels using second training set
trueInteractionSet_meta_1contMet = featureMatrix_AutoGenerateTrain_meta_1contMet_n(:,trueInRegIdx_AutoGenerateTrain_meta_1contMet);
trueInteractionLabel_meta_1contMet = logical(ones(1,size(trueInteractionSet_meta_1contMet,2)));
falseInteractionSet_meta_1contMet = featureMatrix_AutoGenerateTrain_meta_1contMet_n;
falseInteractionSet_meta_1contMet(:,trueInRegIdx_AutoGenerateTrain_meta_1contMet) = [];
falseInteractionLabel_meta_1contMet = logical(zeros(1,size(falseInteractionSet_meta_1contMet,2)));

trainingSet_meta_1contMet = [trueInteractionSet_meta_1contMet falseInteractionSet_meta_1contMet];
trainingLabel_meta_1contMet = [trueInteractionLabel_meta_1contMet falseInteractionLabel_meta_1contMet];

predictedLabel_RF_meta_1contMet = Mdl_RF_1contMet.predict(trainingSet_meta_1contMet');
predictedLabel_KNN_meta_1contMet = double(Mdl_KNN_1contMet.predict(trainingSet_meta_1contMet'));
predictedLabel_SNN_meta_1contMet = Mdl_SNN_1contMet(trainingSet_meta_1contMet)';
predictedLabel_DA_meta_1contMet = double(Mdl_DA_1contMet.predict(trainingSet_meta_1contMet'));

predictedLabel_L1_meta_1contMet = [predictedLabel_RF_meta_1contMet predictedLabel_KNN_meta_1contMet predictedLabel_SNN_meta_1contMet predictedLabel_DA_meta_1contMet];

% Create second level model
predictedLabel_L1_meta_1contMet_good = predictedLabel_L1_meta_1contMet;
poor_classifier_1contMet = find(all(~diff(predictedLabel_L1_meta_1contMet_good)));
if ~isempty(poor_classifier_1contMet)
    predictedLabel_L1_meta_1contMet_good(:,poor_classifier_1contMet) = [];
end
Mdl_DA_meta_1contMet = fitcdiscr(predictedLabel_L1_meta_1contMet_good,trainingLabel_meta_1contMet,'discrimType','pseudoLinear');

% Chass
% Setup testing set and testing label
testingSet_Chass_1contMet = featureMatrix_1contMet_Chass_n;
testingLabel_Chass_1contMet = logical(zeros(size(testingSet_Chass_1contMet,2),1));
testingLabel_Chass_1contMet(Chass_1contMet_trueInRegIdx) = 1;

% Predict where 1 controller metabolite reactions occur in E. coli
% model
predictedLabel_RF_Chass_1contMet = Mdl_RF_1contMet.predict(testingSet_Chass_1contMet');
predictedLabel_KNN_Chass_1contMet = double(Mdl_KNN_1contMet.predict(testingSet_Chass_1contMet'));
predictedLabel_SNN_Chass_1contMet = Mdl_SNN_1contMet(testingSet_Chass_1contMet)';
predictedLabel_DA_Chass_1contMet = double(Mdl_DA_1contMet.predict(testingSet_Chass_1contMet'));

predictedLabel_L1_Chass_1contMet = [predictedLabel_RF_Chass_1contMet predictedLabel_KNN_Chass_1contMet predictedLabel_SNN_Chass_1contMet predictedLabel_DA_Chass_1contMet];
if ~isempty(poor_classifier_1contMet)
    predictedLabel_L1_Chass_1contMet(:,poor_classifier_1contMet) = [];
end
predictedLabel_L2_Chass_1contMet = Mdl_DA_meta_1contMet.predict(predictedLabel_L1_Chass_1contMet)

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

Chass_fluxes_to_remove =  unique([1 10 14 26 predicted_Chass_1contMet(:,2)']); % 10, 14, and 26 are fluxes that are held constant
%Chass_fluxes_to_remove =  unique([1 10 14 26 5 15 17 22 23 25 27 30 32:48]);
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

    % Load autogenerated data information
    load(sprintf('AutoGenerateTrain_meta_2contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep)','train_true_regs_2contMet','train_interaction_mets_2contMet');
    train_true_regs_meta_2contMet = train_true_regs_2contMet;
    train_interaction_mets_meta_2contMet = train_interaction_mets_2contMet;
    trueInRegIdx_AutoGenerateTrain_meta_2contMet = find(train_true_regs_meta_2contMet == 1);
    load(sprintf('AutoGenerateTrain_2contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep)','train_true_regs_2contMet','train_interaction_mets_2contMet');
    trueInRegIdx_AutoGenerateTrain_2contMet = find(train_true_regs_2contMet == 1);

    % Create feature matrix
    autogen_prefix = 'AutoGenerateTrain_2contMet';
    autogen_meta_prefix = 'AutoGenerateTrain_meta_2contMet';
    createFeatMatrix_2contMet_chass_noisy

    % Setup training set and training label
    trueInteractionSet_2contMet = featureMatrix_AutoGenerateTrain_2contMet_n(:,trueInRegIdx_AutoGenerateTrain_2contMet);
    trueInteractionLabel_2contMet = logical(ones(1,size(trueInteractionSet_2contMet,2)));
    falseInteractionSet_2contMet = featureMatrix_AutoGenerateTrain_2contMet_n;
    falseInteractionSet_2contMet(:,trueInRegIdx_AutoGenerateTrain_2contMet) = [];
    falseInteractionLabel_2contMet = logical(zeros(1,size(falseInteractionSet_2contMet,2)));

    trainingSet_2contMet = [trueInteractionSet_2contMet falseInteractionSet_2contMet];
    trainingLabel_2contMet = [trueInteractionLabel_2contMet falseInteractionLabel_2contMet];

    % Create first level models
    Mdl_RF_2contMet = TreeBagger(200,trainingSet_2contMet',double(trainingLabel_2contMet),'Method','Regression','MinLeafSize',5);

    Mdl_KNN_2contMet = fitcknn(trainingSet_2contMet',trainingLabel_2contMet,'NumNeighbors',6);

    Mdl_SNN_2contMet = patternnet(20,'trainscg');
    Mdl_SNN_2contMet.trainParam.showWindow = 0;    
    Mdl_SNN_2contMet = train(Mdl_SNN_2contMet,trainingSet_2contMet,trainingLabel_2contMet);
    Mdl_SNN_2contMet = train(Mdl_SNN_2contMet,trainingSet_2contMet,trainingLabel_2contMet);
    Mdl_SNN_2contMet = train(Mdl_SNN_2contMet,trainingSet_2contMet,trainingLabel_2contMet);

    Mdl_DA_2contMet = fitcdiscr(trainingSet_2contMet',trainingLabel_2contMet,'discrimType','pseudoLinear');
    
    % Predicted labels using second training set
    trueInteractionSet_meta_2contMet = featureMatrix_AutoGenerateTrain_meta_2contMet_n(:,trueInRegIdx_AutoGenerateTrain_meta_2contMet);
    trueInteractionLabel_meta_2contMet = logical(ones(1,size(trueInteractionSet_meta_2contMet,2)));
    falseInteractionSet_meta_2contMet = featureMatrix_AutoGenerateTrain_meta_2contMet_n;
    falseInteractionSet_meta_2contMet(:,trueInRegIdx_AutoGenerateTrain_meta_2contMet) = [];
    falseInteractionLabel_meta_2contMet = logical(zeros(1,size(falseInteractionSet_meta_2contMet,2)));

    trainingSet_meta_2contMet = [trueInteractionSet_meta_2contMet falseInteractionSet_meta_2contMet];
    trainingLabel_meta_2contMet = [trueInteractionLabel_meta_2contMet falseInteractionLabel_meta_2contMet];

    predictedLabel_RF_meta_2contMet = Mdl_RF_2contMet.predict(trainingSet_meta_2contMet');
    predictedLabel_KNN_meta_2contMet = double(Mdl_KNN_2contMet.predict(trainingSet_meta_2contMet'));
    predictedLabel_SNN_meta_2contMet = Mdl_SNN_2contMet(trainingSet_meta_2contMet)';
    predictedLabel_DA_meta_2contMet = double(Mdl_DA_2contMet.predict(trainingSet_meta_2contMet'));
    
    predictedLabel_L1_meta_2contMet = [predictedLabel_RF_meta_2contMet predictedLabel_KNN_meta_2contMet predictedLabel_SNN_meta_2contMet predictedLabel_DA_meta_2contMet];

    % Create second level model
    predictedLabel_L1_meta_2contMet_good = predictedLabel_L1_meta_2contMet;
    poor_classifier_2contMet = find(all(~diff(predictedLabel_L1_meta_2contMet_good)));
    if ~isempty(poor_classifier_2contMet)
        predictedLabel_L1_meta_2contMet_good(:,poor_classifier_2contMet) = [];
    end
    Mdl_DA_meta_2contMet = fitcdiscr(predictedLabel_L1_meta_2contMet_good,trainingLabel_meta_2contMet,'discrimType','pseudoLinear');

    % Chass
    % Setup testing set and testing label
    testingSet_Chass_2contMet = featureMatrix_2contMet_Chass_n;
    testingLabel_Chass_2contMet = logical(zeros(size(testingSet_Chass_2contMet,2),1));
    if exist('Chass_2contMet_trueInRegIdx','var')
        testingLabel_Chass_2contMet(Chass_2contMet_trueInRegIdx) = 1;
    end

    % Predict where 2 controller metabolite reactions occur in E. coli
    % model
    predictedLabel_RF_Chass_2contMet = Mdl_RF_2contMet.predict(testingSet_Chass_2contMet');
    predictedLabel_KNN_Chass_2contMet = double(Mdl_KNN_2contMet.predict(testingSet_Chass_2contMet'));
    predictedLabel_SNN_Chass_2contMet = Mdl_SNN_2contMet(testingSet_Chass_2contMet)';
    predictedLabel_DA_Chass_2contMet = double(Mdl_DA_2contMet.predict(testingSet_Chass_2contMet'));
    
    predictedLabel_L1_Chass_2contMet = [predictedLabel_RF_Chass_2contMet predictedLabel_KNN_Chass_2contMet predictedLabel_SNN_Chass_2contMet predictedLabel_DA_Chass_2contMet];
    if ~isempty(poor_classifier_2contMet)
        predictedLabel_L1_Chass_2contMet(:,poor_classifier_2contMet) = [];
    end
    predictedLabel_L2_Chass_2contMet = Mdl_DA_meta_2contMet.predict(predictedLabel_L1_Chass_2contMet)

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

    Chass_fluxes_to_remove =  unique([1 10 14 26 predicted_Chass_1contMet(:,2)' predicted_Chass_2contMet(:,3)']); % 10, 14, and 26 are fluxes that are held constant
    %Chass_fluxes_to_remove =  unique([1 10 14 26 5 15 17 22 23 25 27 30 32:48 4 6 12 13 16 18:21 2 28 29 31]);
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

    % Load autogenerated data information
    load(sprintf('AutoGenerateTrain_meta_3contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep),'train_true_regs_3contMet','train_interaction_mets_3contMet');
    train_true_regs_meta_3contMet = train_true_regs_3contMet;
    train_interaction_mets_meta_3contMet = train_interaction_mets_3contMet;
    trueInRegIdx_AutoGenerateTrain_meta_3contMet = find(train_true_regs_meta_3contMet == 1);
    load(sprintf('AutoGenerateTrain_3contMet_k-01_nT-%03d_cov-%02d_rep-%03d_smooth.mat',nT,cov,rep),'train_true_regs_3contMet','train_interaction_mets_3contMet');
    trueInRegIdx_AutoGenerateTrain_3contMet = find(train_true_regs_3contMet == 1);

    % Create feature matrix
    autogen_prefix = 'AutoGenerateTrain_3contMet';
    autogen_meta_prefix = 'AutoGenerateTrain_meta_3contMet';
    createFeatMatrix_3contMet_chass_noisy

    % Setup training set and training label
    trueInteractionSet_3contMet = featureMatrix_AutoGenerateTrain_3contMet_n(:,trueInRegIdx_AutoGenerateTrain_3contMet);
    trueInteractionLabel_3contMet = logical(ones(1,size(trueInteractionSet_3contMet,2)));
    falseInteractionSet_3contMet = featureMatrix_AutoGenerateTrain_3contMet_n;
    falseInteractionSet_3contMet(:,trueInRegIdx_AutoGenerateTrain_3contMet) = [];
    falseInteractionLabel_3contMet = logical(zeros(1,size(falseInteractionSet_3contMet,2)));

    trainingSet_3contMet = [trueInteractionSet_3contMet falseInteractionSet_3contMet];
    trainingLabel_3contMet = [trueInteractionLabel_3contMet falseInteractionLabel_3contMet];

    % Create first level models
    Mdl_RF_3contMet = TreeBagger(200,trainingSet_3contMet',double(trainingLabel_3contMet),'Method','Regression','MinLeafSize',5);

    Mdl_KNN_3contMet = fitcknn(trainingSet_3contMet',trainingLabel_3contMet,'NumNeighbors',6);

    Mdl_SNN_3contMet = patternnet(20,'trainscg');
    Mdl_SNN_3contMet.trainParam.showWindow = 0;    
    Mdl_SNN_3contMet = train(Mdl_SNN_3contMet,trainingSet_3contMet,trainingLabel_3contMet);
    Mdl_SNN_3contMet = train(Mdl_SNN_3contMet,trainingSet_3contMet,trainingLabel_3contMet);
    Mdl_SNN_3contMet = train(Mdl_SNN_3contMet,trainingSet_3contMet,trainingLabel_3contMet);

    Mdl_DA_3contMet = fitcdiscr(trainingSet_3contMet',trainingLabel_3contMet,'discrimType','pseudoLinear');
    
    % Predicted labels using second training set
    trueInteractionSet_meta_3contMet = featureMatrix_AutoGenerateTrain_meta_3contMet_n(:,trueInRegIdx_AutoGenerateTrain_meta_3contMet);
    trueInteractionLabel_meta_3contMet = logical(ones(1,size(trueInteractionSet_meta_3contMet,2)));
    falseInteractionSet_meta_3contMet = featureMatrix_AutoGenerateTrain_meta_3contMet_n;
    falseInteractionSet_meta_3contMet(:,trueInRegIdx_AutoGenerateTrain_meta_3contMet) = [];
    falseInteractionLabel_meta_3contMet = logical(zeros(1,size(falseInteractionSet_meta_3contMet,2)));

    trainingSet_meta_3contMet = [trueInteractionSet_meta_3contMet falseInteractionSet_meta_3contMet];
    trainingLabel_meta_3contMet = [trueInteractionLabel_meta_3contMet falseInteractionLabel_meta_3contMet];

    predictedLabel_RF_meta_3contMet = Mdl_RF_3contMet.predict(trainingSet_meta_3contMet');
    predictedLabel_KNN_meta_3contMet = double(Mdl_KNN_3contMet.predict(trainingSet_meta_3contMet'));
    predictedLabel_SNN_meta_3contMet = Mdl_SNN_3contMet(trainingSet_meta_3contMet)';
    predictedLabel_DA_meta_3contMet = double(Mdl_DA_3contMet.predict(trainingSet_meta_3contMet'));
    
    predictedLabel_L1_meta_3contMet = [predictedLabel_RF_meta_3contMet predictedLabel_KNN_meta_3contMet predictedLabel_SNN_meta_3contMet predictedLabel_DA_meta_3contMet];

    % Create second level model
    predictedLabel_L1_meta_3contMet_good = predictedLabel_L1_meta_3contMet;
    poor_classifier_3contMet = find(all(~diff(predictedLabel_L1_meta_3contMet_good)));
    if ~isempty(poor_classifier_3contMet)
        predictedLabel_L1_meta_3contMet_good(:,poor_classifier_3contMet) = [];
    end
    Mdl_DA_meta_3contMet = fitcdiscr(predictedLabel_L1_meta_3contMet_good,trainingLabel_meta_3contMet,'discrimType','pseudoLinear');

    % Chass
    % Setup testing set and testing label
    testingSet_Chass_3contMet = featureMatrix_3contMet_Chass_n;
    testingLabel_Chass_3contMet = logical(zeros(size(testingSet_Chass_3contMet,2),1));
    if exist('Chass_3contMet_trueInRegIdx','var')
        testingLabel_Chass_3contMet(Chass_3contMet_trueInRegIdx) = 1;
    end

    % Predict where 3 controller metabolite reactions occur in E. coli
    % model
    predictedLabel_RF_Chass_3contMet = Mdl_RF_3contMet.predict(testingSet_Chass_3contMet');
    predictedLabel_KNN_Chass_3contMet = double(Mdl_KNN_3contMet.predict(testingSet_Chass_3contMet'));
    predictedLabel_SNN_Chass_3contMet = Mdl_SNN_3contMet(testingSet_Chass_3contMet)';
    predictedLabel_DA_Chass_3contMet = double(Mdl_DA_3contMet.predict(testingSet_Chass_3contMet'));
    
    predictedLabel_L1_Chass_3contMet = [predictedLabel_RF_Chass_3contMet predictedLabel_KNN_Chass_3contMet predictedLabel_SNN_Chass_3contMet predictedLabel_DA_Chass_3contMet];
    if ~isempty(poor_classifier_3contMet)
        predictedLabel_L1_Chass_3contMet(:,poor_classifier_3contMet) = [];
    end
    predictedLabel_L2_Chass_3contMet = Mdl_DA_meta_3contMet.predict(predictedLabel_L1_Chass_3contMet)

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

    %% Remove 3 controller metabolite reactions

    % Remove from Chass using predicted 3 controller metabolite
    % interactions
    predicted_Chass_3contMet = [Chass_regScheme_3contMet(find(predictedLabel_L2_Chass_3contMet==1),:)];

    Chass_fluxes_to_remove =  unique([1 10 14 26 predicted_Chass_1contMet(:,2)'  predicted_Chass_2contMet(:,3)'  predicted_Chass_3contMet(:,4)']); % 10, 14, and 26 are fluxes that are held constant
    %Chass_fluxes_to_remove =  unique([1 10 14 26 5 15 17 22 23 25 27 30 32:48 4 6 12 13 16 18:21 2 28 29 31 3 11]);
    if ~isequal(sort(Chass_fluxes_to_remove),1:size(Chass.S,2))
        [~,~,Chass_regScheme_4contMet] = createRegSchemeList_chass(Chass.S,Chass_fluxes_to_remove);
    end
end
save(sprintf('ecoli_results_IC-%02d_nT-%03d_cov-%02d_rep-%02d.mat',num_IC,nT,cov,rep));

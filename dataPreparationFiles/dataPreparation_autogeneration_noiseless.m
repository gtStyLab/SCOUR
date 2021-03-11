function dataPreparation_autogeneration_noiseless(num_IC,reps)
% Generate noiseless training data for first and second levels of machine
% learning model.

%% Autogeneration step

warning('off','all')
rng('shuffle');

number_ints = 300;
tStart = 0;
tEnd = 10;
fraction_true_1contMet = 0.4;
fraction_true_2contMet = 0.05;
fraction_true_3contMet = 0.05;

nT_hiRes = 50;
timeVec = linspace(tStart,tEnd,nT_hiRes+1);
fluxTimeVec = timeVec(1:end-1)+0.5*diff(timeVec(1:2));

if ~exist('autogenData','dir')
    mkdir('autogenData')
end

% Generate train data (1 controller met)
fprintf('Autogenerating noisy training data...\n');
for rep = 1:reps
    [train_concentrations_1contMet,train_flux_1contMet,train_true_regs_1contMet,train_params_1contMet] = autogenerate_interactiondata_1contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_1contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_1contMet{IC,1};
       fluxMatrix = train_flux_1contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_1contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_1contMet','train_params_1contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end

% Generate train data (2 controller met)
for rep = 1:reps
    [train_concentrations_2contMet,train_flux_2contMet,train_interaction_mets_2contMet,train_true_regs_2contMet,train_params_2contMet] = autogenerate_interactiondata_2contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_2contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_2contMet{IC,1};
       fluxMatrix = train_flux_2contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_2contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_2contMet','train_params_2contMet','train_interaction_mets_2contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end

% Generate train data (3 controller met)
for rep = 1:reps
    [train_concentrations_3contMet,train_flux_3contMet,train_interaction_mets_3contMet,train_true_regs_3contMet,train_params_3contMet] = autogenerate_interactiondata_3contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_3contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_3contMet{IC,1};
       fluxMatrix = train_flux_3contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_3contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_3contMet','train_params_3contMet','train_interaction_mets_3contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end

% Generate second train data (1 controller met)
fprintf('Autogenerating second noisy training data...\n');
for rep = 1:reps
    [train_concentrations_1contMet,train_flux_1contMet,train_true_regs_1contMet,train_params_1contMet] = autogenerate_interactiondata_1contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_1contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_1contMet{IC,1};
       fluxMatrix = train_flux_1contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_meta_1contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_1contMet','train_params_1contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end

% Generate second train data (2 controller met)
for rep = 1:reps
    [train_concentrations_2contMet,train_flux_2contMet,train_interaction_mets_2contMet,train_true_regs_2contMet,train_params_2contMet] = autogenerate_interactiondata_2contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_2contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_2contMet{IC,1};
       fluxMatrix = train_flux_2contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_meta_2contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_2contMet','train_params_2contMet','train_interaction_mets_2contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end

% Generate second train data (3 controller met)
for rep = 1:reps
    [train_concentrations_3contMet,train_flux_3contMet,train_interaction_mets_3contMet,train_true_regs_3contMet,train_params_3contMet] = autogenerate_interactiondata_3contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_3contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_3contMet{IC,1};
       fluxMatrix = train_flux_3contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData/AutoGenerateTrain_meta_3contMet_k-%02d_hiRes_rep-%03d.mat',IC,rep),'concMatrix','fluxMatrix','train_true_regs_3contMet','train_params_3contMet','train_interaction_mets_3contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
end


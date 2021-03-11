function dataPreparation_autogeneration_noisy(nT,cov,num_IC,reps)
% Autogenerate triplicate noisy training data for the first and second 
% levels of the machine learning model. Then apply a smoothing function to 
% this data and also take the median.

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

if ~exist(sprintf('autogenData_nT%03d_cov%02d',nT,cov),'dir')
    mkdir(sprintf('autogenData_nT%03d_cov%02d',nT,cov))
end

% Generate train data (1 controller met)
fprintf('Autogenerating noisy training data...\n');
for rep = 1:reps
    [train_concentrations_1contMet,train_flux_1contMet,train_true_regs_1contMet,train_params_1contMet] = autogenerate_interactiondata_1contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_1contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_1contMet{IC,1};
       fluxMatrix = train_flux_1contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_1contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_1contMet','train_params_1contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_1contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep);
    end
end

% Generate train data (2 controller met)
for rep = 1:reps
    [train_concentrations_2contMet,train_flux_2contMet,train_interaction_mets_2contMet,train_true_regs_2contMet,train_params_2contMet] = autogenerate_interactiondata_2contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_2contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_2contMet{IC,1};
       fluxMatrix = train_flux_2contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_2contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_2contMet','train_params_2contMet','train_interaction_mets_2contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_2contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep)
    end
end

% Generate train data (3 controller met)
for rep = 1:reps
    [train_concentrations_3contMet,train_flux_3contMet,train_interaction_mets_3contMet,train_true_regs_3contMet,train_params_3contMet] = autogenerate_interactiondata_3contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_3contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_3contMet{IC,1};
       fluxMatrix = train_flux_3contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_3contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_3contMet','train_params_3contMet','train_interaction_mets_3contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_3contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep)
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
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_1contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_1contMet','train_params_1contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_1contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep);
    end
end

% Generate second train data (2 controller met)
for rep = 1:reps
    [train_concentrations_2contMet,train_flux_2contMet,train_interaction_mets_2contMet,train_true_regs_2contMet,train_params_2contMet] = autogenerate_interactiondata_2contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_2contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_2contMet{IC,1};
       fluxMatrix = train_flux_2contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_2contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_2contMet','train_params_2contMet','train_interaction_mets_2contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_2contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep)
    end
end

% Generate second train data (3 controller met)
for rep = 1:reps
    [train_concentrations_3contMet,train_flux_3contMet,train_interaction_mets_3contMet,train_true_regs_3contMet,train_params_3contMet] = autogenerate_interactiondata_3contMet(number_ints,num_IC,tStart,tEnd,nT_hiRes,fraction_true_3contMet);

    for IC = 1:num_IC
       concMatrix = train_concentrations_3contMet{IC,1};
       fluxMatrix = train_flux_3contMet{IC,1};
       x0 = concMatrix(1,:);
       save(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_3contMet_k-%02d_hiRes.mat',nT,cov,IC),'concMatrix','fluxMatrix','train_true_regs_3contMet','train_params_3contMet','train_interaction_mets_3contMet','timeVec','fluxTimeVec','tStart','tEnd','x0');
    end
    for IC = 1:num_IC
        wrapper_genNoisyData_autogen_3samples_multiDatasets(sprintf('autogenData_nT%03d_cov%02d/AutoGenerateTrain_meta_3contMet_k-%02d_hiRes.mat',nT,cov,IC),nT,cov,rep)
    end
end

%% Smooth autogenerated data
fprintf('Smoothing training data...\n')
smoothing_method = 'gaussian';
for rep = 1:reps
    for prefix = {'AutoGenerateTrain_1contMet','AutoGenerateTrain_2contMet','AutoGenerateTrain_3contMet'}
        for IC = 1:num_IC
            concMatrix_3samples = [];
            fluxMatrix_3samples = [];
            new_concMatrix_3samples = [];
            new_fluxMatrix_3samples = [];
            timeVec_3samples = [];
            fluxTimeVec_3samples = [];
            x0_concMatrix_3samples = [];
            v0_fluxMatrix_3samples = [];
            for s = 1:3
                filename = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',nT,cov,prefix{:},IC,nT,cov,s,rep);
                odeData = load(filename);
                concMatrix_3samples = [concMatrix_3samples; odeData.concMatrix(2:end,:)];
                timeVec_3samples = [timeVec_3samples; odeData.timeVec(2:end)];
                fluxMatrix_3samples = [fluxMatrix_3samples; odeData.fluxMatrix(2:end,:)];
                fluxTimeVec_3samples = [fluxTimeVec_3samples; odeData.fluxTimeVec(2:end)];
                x0_concMatrix_3samples = [x0_concMatrix_3samples; odeData.concMatrix(1,:)];
                v0_fluxMatrix_3samples = [v0_fluxMatrix_3samples; odeData.fluxMatrix(1,:)];
            end
            timeVec_3samples(1,:) = timeVec_3samples(1,:) - 0.0001;
            timeVec_3samples(3,:) = timeVec_3samples(3,:) + 0.0001;
            new_timeVec_3samples = reshape(timeVec_3samples,nT*3,1);

            fluxTimeVec_3samples(1,:) = fluxTimeVec_3samples(1,:) - 0.0001;
            fluxTimeVec_3samples(3,:) = fluxTimeVec_3samples(3,:) + 0.0001;
            new_fluxTimeVec_3samples = reshape(fluxTimeVec_3samples,(nT-1)*3,1);

            for met = 1:size(concMatrix_3samples,2)
                met_conc = concMatrix_3samples(:,met);
                met_conc = reshape(met_conc,nT,3)';
                met_conc = reshape(met_conc,nT*3,1);

                new_concMatrix_3samples = [new_concMatrix_3samples met_conc];
            end
            for flux = 1:size(fluxMatrix_3samples,2)
                flux_value = fluxMatrix_3samples(:,flux);
                flux_value = reshape(flux_value,nT-1,3)';
                flux_value = reshape(flux_value,(nT-1)*3,1);

                new_fluxMatrix_3samples = [new_fluxMatrix_3samples flux_value];
            end

            smooth_conc = smoothdata(new_concMatrix_3samples,smoothing_method,tEnd/4,'SamplePoints',new_timeVec_3samples);
            smooth_flux = smoothdata(new_fluxMatrix_3samples,smoothing_method,tEnd/4,'SamplePoints',new_fluxTimeVec_3samples);
            odeData.concMatrix = [median(x0_concMatrix_3samples); smooth_conc(2:3:end,:)];
            odeData.fluxMatrix = [median(v0_fluxMatrix_3samples); smooth_flux(2:3:end,:)];

            fileOutName = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_smooth.mat',nT,cov,prefix{:},IC,nT,cov,rep);
            save(fileOutName,'-struct','odeData');
        end
    end
end

% Smooth second autogenerated data
fprintf('Smoothing second training data...\n')
smoothing_method = 'gaussian';
for rep = 1:reps
    for prefix = {'AutoGenerateTrain_meta_1contMet','AutoGenerateTrain_meta_2contMet','AutoGenerateTrain_meta_3contMet'}
        for IC = 1:num_IC
            concMatrix_3samples = [];
            fluxMatrix_3samples = [];
            new_concMatrix_3samples = [];
            new_fluxMatrix_3samples = [];
            timeVec_3samples = [];
            fluxTimeVec_3samples = [];
            x0_concMatrix_3samples = [];
            v0_fluxMatrix_3samples = [];
            for s = 1:3
                filename = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',nT,cov,prefix{:},IC,nT,cov,s,rep);
                odeData = load(filename);
                concMatrix_3samples = [concMatrix_3samples; odeData.concMatrix(2:end,:)];
                timeVec_3samples = [timeVec_3samples; odeData.timeVec(2:end)];
                fluxMatrix_3samples = [fluxMatrix_3samples; odeData.fluxMatrix(2:end,:)];
                fluxTimeVec_3samples = [fluxTimeVec_3samples; odeData.fluxTimeVec(2:end)];
                x0_concMatrix_3samples = [x0_concMatrix_3samples; odeData.concMatrix(1,:)];
                v0_fluxMatrix_3samples = [v0_fluxMatrix_3samples; odeData.fluxMatrix(1,:)];
            end
            timeVec_3samples(1,:) = timeVec_3samples(1,:) - 0.0001;
            timeVec_3samples(3,:) = timeVec_3samples(3,:) + 0.0001;
            new_timeVec_3samples = reshape(timeVec_3samples,nT*3,1);

            fluxTimeVec_3samples(1,:) = fluxTimeVec_3samples(1,:) - 0.0001;
            fluxTimeVec_3samples(3,:) = fluxTimeVec_3samples(3,:) + 0.0001;
            new_fluxTimeVec_3samples = reshape(fluxTimeVec_3samples,(nT-1)*3,1);

            for met = 1:size(concMatrix_3samples,2)
                met_conc = concMatrix_3samples(:,met);
                met_conc = reshape(met_conc,nT,3)';
                met_conc = reshape(met_conc,nT*3,1);

                new_concMatrix_3samples = [new_concMatrix_3samples met_conc];
            end
            for flux = 1:size(fluxMatrix_3samples,2)
                flux_value = fluxMatrix_3samples(:,flux);
                flux_value = reshape(flux_value,nT-1,3)';
                flux_value = reshape(flux_value,(nT-1)*3,1);

                new_fluxMatrix_3samples = [new_fluxMatrix_3samples flux_value];
            end

            smooth_conc = smoothdata(new_concMatrix_3samples,smoothing_method,tEnd/4,'SamplePoints',new_timeVec_3samples);
            smooth_flux = smoothdata(new_fluxMatrix_3samples,smoothing_method,tEnd/4,'SamplePoints',new_fluxTimeVec_3samples);
            odeData.concMatrix = [median(x0_concMatrix_3samples); smooth_conc(2:3:end,:)];
            odeData.fluxMatrix = [median(v0_fluxMatrix_3samples); smooth_flux(2:3:end,:)];
            
            fileOutName = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_smooth.mat',nT,cov,prefix{:},IC,nT,cov,rep);
            save(fileOutName,'-struct','odeData');
        end
    end
end

%% Median autogenerated data
fprintf('Calculating training data medians...\n')
for rep = 1:reps
    for prefix = {'AutoGenerateTrain_1contMet','AutoGenerateTrain_2contMet','AutoGenerateTrain_3contMet'}
        for IC = 1:num_IC
            concMatrix_3samples = [];
            fluxMatrix_3samples = [];
            new_concMatrix_3samples = [];
            new_fluxMatrix_3samples = [];
            median_concMatrix = [];
            median_fluxMatrix = [];
            for s = 1:3
                filename = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',nT,cov,prefix{:},IC,nT,cov,s,rep);
                odeData = load(filename);
                concMatrix_3samples = [concMatrix_3samples; odeData.concMatrix];
                fluxMatrix_3samples = [fluxMatrix_3samples; odeData.fluxMatrix];
            end
            
            for met = 1:size(concMatrix_3samples,2)
                met_conc = concMatrix_3samples(:,met);
                met_conc = reshape(met_conc,nT+1,3)';
                met_conc = reshape(met_conc,(nT+1)*3,1);
                
                new_concMatrix_3samples = [new_concMatrix_3samples met_conc];
            end
            for timepoint = 1:length(odeData.timeVec)
                median_concMatrix(timepoint,:) = median(new_concMatrix_3samples(3*(timepoint-1)+1:3*(timepoint-1)+3,:));
            end
            
            for flux = 1:size(fluxMatrix_3samples,2)
                flux_value = fluxMatrix_3samples(:,flux);
                flux_value = reshape(flux_value,nT,3)';
                flux_value = reshape(flux_value,nT*3,1);
                
                new_fluxMatrix_3samples = [new_fluxMatrix_3samples flux_value];
            end
            for timepoint = 1:length(odeData.fluxTimeVec)
                median_fluxMatrix(timepoint,:) = median(new_fluxMatrix_3samples(3*(timepoint-1)+1:3*(timepoint-1)+3,:));
            end
            
            odeData.concMatrix = median_concMatrix;
            odeData.concMatrix(1,:) = odeData.x0;
            odeData.fluxMatrix = median_fluxMatrix;
            
            fileOutName = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_median.mat',nT,cov,prefix{:},IC,nT,cov,rep);
            save(fileOutName,'-struct','odeData');
        end
    end
end

% Median second autogenerated data
fprintf('Calculating second training data medians...\n')
for rep = 1:reps
    for prefix = {'AutoGenerateTrain_meta_1contMet','AutoGenerateTrain_meta_2contMet','AutoGenerateTrain_meta_3contMet'}
        for IC = 1:num_IC
            concMatrix_3samples = [];
            fluxMatrix_3samples = [];
            new_concMatrix_3samples = [];
            new_fluxMatrix_3samples = [];
            median_concMatrix = [];
            median_fluxMatrix = [];
            for s = 1:3
                filename = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',nT,cov,prefix{:},IC,nT,cov,s,rep);
                odeData = load(filename);
                concMatrix_3samples = [concMatrix_3samples; odeData.concMatrix];
                fluxMatrix_3samples = [fluxMatrix_3samples; odeData.fluxMatrix];
            end
            
            for met = 1:size(concMatrix_3samples,2)
                met_conc = concMatrix_3samples(:,met);
                met_conc = reshape(met_conc,nT+1,3)';
                met_conc = reshape(met_conc,(nT+1)*3,1);
                
                new_concMatrix_3samples = [new_concMatrix_3samples met_conc];
            end
            for timepoint = 1:length(odeData.timeVec)
                median_concMatrix(timepoint,:) = median(new_concMatrix_3samples(3*(timepoint-1)+1:3*(timepoint-1)+3,:));
            end
            
            for flux = 1:size(fluxMatrix_3samples,2)
                flux_value = fluxMatrix_3samples(:,flux);
                flux_value = reshape(flux_value,nT,3)';
                flux_value = reshape(flux_value,nT*3,1);
                
                new_fluxMatrix_3samples = [new_fluxMatrix_3samples flux_value];
            end
            for timepoint = 1:length(odeData.fluxTimeVec)
                median_fluxMatrix(timepoint,:) = median(new_fluxMatrix_3samples(3*(timepoint-1)+1:3*(timepoint-1)+3,:));
            end
            
            odeData.concMatrix = median_concMatrix;
            odeData.concMatrix(1,:) = odeData.x0;
            odeData.fluxMatrix = median_fluxMatrix;
            
            fileOutName = sprintf('autogenData_nT%03d_cov%02d/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_median.mat',nT,cov,prefix{:},IC,nT,cov,rep);
            save(fileOutName,'-struct','odeData');
        end
    end
end


function dataPreparation_Ecoli_noisy(nT,cov,num_IC,reps)
% Generate triplicate noisy data for E. coli model. Then apply a
% smoothing function to this data and also take the median.

%% Generate noisy data

warning('off','all')
rng('shuffle');

tStart = 0;
tEnd = 10;

% Generate noisy E. coli data
fprintf('Generating noisy E. coli testing data...\n');
for IC = 1:num_IC
    wrapper_genNoisyData_3samples(sprintf('ChassData/odeData/chassV_k-%02d_hiRes.mat',IC),nT,cov,reps)
end

%% Smooth E. coli data
fprintf('Smoothing testing data...\n')
smoothing_method = 'gaussian';
prefix = 'chassV';
for rep = 1:reps
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
            filename = sprintf('ChassData/odeData/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',prefix,IC,nT,cov,s,rep);
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

        smooth_conc = smoothdata(new_concMatrix_3samples,smoothing_method,odeData.tEnd/4,'SamplePoints',new_timeVec_3samples);
        smooth_flux = smoothdata(new_fluxMatrix_3samples,smoothing_method,odeData.tEnd/4,'SamplePoints',new_fluxTimeVec_3samples);
        odeData.concMatrix = [median(x0_concMatrix_3samples); smooth_conc(2:3:end,:)];
        odeData.fluxMatrix = [median(v0_fluxMatrix_3samples); smooth_flux(2:3:end,:)];

        fileOutName = sprintf('ChassData/odeData/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_smooth.mat',prefix,IC,nT,cov,rep);
        save(fileOutName,'-struct','odeData');
    end
end

%% Median E. coli data
fprintf('Calculating E. coli testing data medians...\n')
prefix = 'chassV';
for rep = 1:reps
    for IC = 1:num_IC
        concMatrix_3samples = [];
        fluxMatrix_3samples = [];
        new_concMatrix_3samples = [];
        new_fluxMatrix_3samples = [];
        median_concMatrix = [];
        median_fluxMatrix = [];
        for s = 1:3
            filename = sprintf('ChassData/odeData/%s_k-%02d_nT-%03d_cov-%02d_s%01d_rep-0%02d.mat',prefix,IC,nT,cov,s,rep);
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

        fileOutName = sprintf('ChassData/odeData/%s_k-%02d_nT-%03d_cov-%02d_rep-0%02d_median.mat',prefix,IC,nT,cov,rep);
        save(fileOutName,'-struct','odeData');
    end
end


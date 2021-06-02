function fluxSamePercent = feature_functionalityPercentage_3contMet_noisy(prefix,met1,met2,met3,tarFlux,num_IC,nT,cov,rep)

allIC_concMatrix = [];
allIC_fluxMatrix = [];
for IC = 1:num_IC
    data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));
    
    interpTimeVec = linspace(data.timeVec(2),data.timeVec(end-1),100);
    interpFluxTimeVec = linspace(data.fluxTimeVec(2),data.fluxTimeVec(end),100);
    interp_regMet1 = interp1(data.timeVec(2:end-1),data.concMatrix(2:end-1,met2),interpTimeVec)';
    interp_regMet2 = interp1(data.timeVec(2:end-1),data.concMatrix(2:end-1,met3),interpTimeVec)';
    interp_MA_Met = interp1(data.timeVec(2:end-1),data.concMatrix(2:end-1,met1),interpTimeVec)';
    interp_fluxMatrix = interp1(data.fluxTimeVec(2:end),data.fluxMatrix(2:end,tarFlux),interpFluxTimeVec)';
    
    interp_concMatrix = [interp_regMet1 interp_regMet2 interp_MA_Met];
    
    allIC_concMatrix = [allIC_concMatrix; interp_concMatrix];
    allIC_fluxMatrix = [allIC_fluxMatrix; interp_fluxMatrix];
    
end

small_CoV_count = 0;
big_CoV_count = 0;
for i = 1:size(allIC_concMatrix,1)
    current_x1 = allIC_concMatrix(i,1);
    current_x2 = allIC_concMatrix(i,2);
    current_x3 = allIC_concMatrix(i,3);

    % Find concentrations close together
    same_x1 = find(allIC_concMatrix(:,1) > 0.9*current_x1 & allIC_concMatrix(:,1) < 1.1*current_x1);
    same_x2 = find(allIC_concMatrix(same_x1,2) > 0.9*current_x2 & allIC_concMatrix(same_x1,2) < 1.1*current_x2);
    same_x3 = find(allIC_concMatrix(same_x1(same_x2),3) > 0.9*current_x3 & allIC_concMatrix(same_x1(same_x2),3) < 1.1*current_x3);

    % Avoid data with similar timepoints
    temp_index = same_x1(same_x2(same_x3));
    remove_same_time_idx = find(temp_index < i-5 | temp_index > i+5);
    count = 1;
    while count < length(remove_same_time_idx)
       remove_same_time_idx2 = find(temp_index(remove_same_time_idx) < temp_index(remove_same_time_idx(count))-5 | temp_index(remove_same_time_idx) > temp_index(remove_same_time_idx(count))+5 | temp_index(remove_same_time_idx) == temp_index(remove_same_time_idx(count))); % avoid data from same IC with similar timepoints
       remove_same_time_idx = remove_same_time_idx(remove_same_time_idx2);
       count = count + 1;
    end
    index = temp_index(remove_same_time_idx);

    % Calculate CoV of fluxes
    check_conc = allIC_concMatrix([i; index],:);
    check_flux = allIC_fluxMatrix([i; index]);
    if length(check_flux) > 1
       CoV = std(check_flux)/mean(check_flux);
       if CoV <= 5e-2
           small_CoV_count = small_CoV_count + 1;
       end
       if CoV > 5e-2
           big_CoV_count = big_CoV_count + 1;
       end
    end
end
fluxSamePercent = small_CoV_count/(small_CoV_count + big_CoV_count); % Want many small CoVs
if isnan(fluxSamePercent)
   fluxSamePercent = 0.5; 
end




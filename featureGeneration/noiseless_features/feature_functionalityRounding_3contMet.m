function functionality_percent = feature_functionalityRounding_3contMet(prefix,controller_mets,tarFlux,num_IC,rep)

all_interp_concData = [];
all_interp_fluxData = [];
for IC = 1:num_IC

    if contains(prefix,'AutoGen')
        data = load(sprintf('%s_k-%02d_hiRes_rep-%03d.mat',prefix,IC,rep));
    else
        data = load(sprintf('%s_k-%02d_hiRes.mat',prefix,IC));
    end
    
    concData = data.concMatrix(2:end-1,controller_mets);
    fluxData = data.fluxMatrix(2:end,tarFlux);
    newTimeVec = linspace(data.timeVec(2),data.timeVec(end-1),1000);
    newFluxTimeVec = linspace(data.fluxTimeVec(2),data.fluxTimeVec(end),1000);
    min_concData = min(concData);
    max_concData = max(concData);
    
    % Interpolate concentration data for 1000 points
    interp_concData = [];
    for met = 1:length(min_concData)
       interp_concData = [interp_concData interp1(data.timeVec(2:end-1),concData(:,met),newTimeVec)']; 
    end
    all_interp_concData = [all_interp_concData; interp_concData];
    
    % Interpolate flux data for 1000 points
    interp_fluxData = interp1(data.fluxTimeVec(2:end),fluxData,newFluxTimeVec)';
    all_interp_fluxData = [all_interp_fluxData; interp_fluxData];
end

% Find points that are close to equal to each other
round_all_interp_concData = round(all_interp_concData,2);
round_all_interp_fluxData = round(all_interp_fluxData,2);
[~,unique_idx] = unique(round_all_interp_concData,'rows','stable');
duplicate_idx = setdiff(1:size(round_all_interp_concData,1),unique_idx)';
duplicate_rows = unique(round_all_interp_concData(duplicate_idx,:),'rows','stable');

num_flux_same = 0;
num_flux_same_or_diff = 0;
for i = 1:size(duplicate_rows,1)
    row_values = duplicate_rows(i,:);
    
    % Find where same metabolite concentrations occur
    same_value_idx = find(all(row_values == round_all_interp_concData,2));
    
    % Check if flux values are the same
    flux_values = all_interp_fluxData(same_value_idx);
    if all(flux_values <= median(flux_values) + 0.002) && all(flux_values >= median(flux_values) - 0.002)
        num_flux_same = num_flux_same + 1;
    end
    num_flux_same_or_diff = num_flux_same_or_diff + 1;
end
if num_flux_same_or_diff == 0
    functionality_percent = 0;
else
    functionality_percent = num_flux_same/num_flux_same_or_diff;
end
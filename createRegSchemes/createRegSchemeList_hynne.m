function [regScheme_2contMet,regScheme_3contMet,regScheme_4contMet] = createRegSchemeList_hynne(S,fluxes_to_remove)
% Create list of possible regulatory interactions in the yeast model that
% are tested by SCOUR.

% Find Hynne mass action (MA) interactions
[row_MA col_MA] = find(S < 0);
MA_interactions = [row_MA col_MA];

unique_flux = unique(MA_interactions(:,2));
count_1contMet = 1;
count_2contMet = 1;
for i = 1:length(unique_flux)
    controller_met_idx = find(MA_interactions(:,2) == unique_flux(i));
    if length(MA_interactions(controller_met_idx,1)) == 1
        MA_1contMet_List(count_1contMet,:) = [MA_interactions(controller_met_idx,1)' unique_flux(i)];
        count_1contMet = count_1contMet + 1;
    elseif length(MA_interactions(controller_met_idx,1)) == 2
        MA_2contMet_List(count_2contMet,:) = [MA_interactions(controller_met_idx,1)' unique_flux(i)];
        count_2contMet = count_2contMet + 1;
    end
end

metabolites = 1:size(S,1);
original_fluxes = 1:size(S,2);

% Remove fluxes
fluxes = setdiff(original_fluxes,fluxes_to_remove);

% List all possible elementary regulatory interactions
elementary_reg = [];
for metabolite = metabolites
    for flux = fluxes
        elementary_reg(end+1,:) = [metabolite,flux];
    end
end

delete_index = [];
for i = 1:length(MA_1contMet_List)
    for j = 1:length(elementary_reg)
        if isequal(MA_1contMet_List(i,:),elementary_reg(j,:))
            delete_index = [delete_index j];
            continue
        end
    end
end
elementary_reg(delete_index,:) = [];

% 2 controller metabolite interactions
regScheme_2contMet = [];
for i = 1:length(elementary_reg)
    MA_1contMet = MA_1contMet_List(find(MA_1contMet_List(:,2)==elementary_reg(i,2)),1);
    MA_2contMet = MA_2contMet_List(find(MA_2contMet_List(:,3)==elementary_reg(i,2)),1:2);
    all_controller_mets = sort(unique([MA_1contMet MA_2contMet elementary_reg(i,1)]));
    if length(all_controller_mets) == 2
        regScheme_2contMet(end+1,:) = [all_controller_mets elementary_reg(i,2)];
    end
end
regScheme_2contMet = unique(regScheme_2contMet,'rows');

% 3 controller metabolite interactions
regScheme_3contMet = [];
for flux = fluxes
    tarFluxIdx = find(elementary_reg(:,2) == flux);
    regScheme_tarFlux = elementary_reg(tarFluxIdx,:);
    
    elemSchemePosition = 1:size(regScheme_tarFlux,1);
    scheme = nchoosek(elemSchemePosition,2);
    for i=1:length(scheme)
        MA_1contMet = MA_1contMet_List(find(MA_1contMet_List(:,2)==flux),1);
        MA_2contMet = MA_2contMet_List(find(MA_2contMet_List(:,3)==flux),1:2);
        all_controller_mets = sort(unique([MA_1contMet MA_2contMet regScheme_tarFlux(scheme(i,1),1) regScheme_tarFlux(scheme(i,2),1)]));
        if length(all_controller_mets) == 3
            regScheme_3contMet(end+1,:) = [all_controller_mets regScheme_tarFlux(scheme(i,1),2)];
        end
    end
end
regScheme_3contMet = unique(regScheme_3contMet,'rows');

% 4 controller metabolite interactions
regScheme_4contMet = [];
for flux = fluxes
    tarFluxIdx = find(elementary_reg(:,2) == flux);
    regScheme_tarFlux = elementary_reg(tarFluxIdx,:);
    
    elemSchemePosition = 1:size(regScheme_tarFlux,1);
    scheme = nchoosek(elemSchemePosition,3);
    for i=1:length(scheme)
        MA_1contMet = MA_1contMet_List(find(MA_1contMet_List(:,2)==flux),1);
        MA_2contMet = MA_2contMet_List(find(MA_2contMet_List(:,3)==flux),1:2);
        all_controller_mets = sort(unique([MA_1contMet MA_2contMet regScheme_tarFlux(scheme(i,1),1) regScheme_tarFlux(scheme(i,2),1) regScheme_tarFlux(scheme(i,3),1)]));
        if length(all_controller_mets) == 4
            regScheme_4contMet(end+1,:) = [all_controller_mets regScheme_tarFlux(scheme(i,1),2)];
        end
    end
end
regScheme_4contMet = unique(regScheme_4contMet,'rows');

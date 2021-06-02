function [min_corr_adjrsquare max_rmse] = fcn_hold1MetConstant_moreFeats_noisy(prefix,Met1,Met2,tarFlux,num_IC,nT,cov,rep)

% Find indices of lines to intersect with MA Met concentration data
allConc = [];
for IC = 1:num_IC
    data_IC = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));
    allConc = [allConc; data_IC.concMatrix(2:end-1,:)];
end
minConc_Met1 = min(allConc(:,Met1));
maxConc_Met1 = max(allConc(:,Met1));
minConc_Met2 = min(allConc(:,Met2));
maxConc_Met2 = max(allConc(:,Met2));

line_indices_Met1 = linspace(minConc_Met1,maxConc_Met1,12);
line_indices_Met1 = line_indices_Met1(2:11);
line_indices_Met2 = linspace(minConc_Met2,maxConc_Met2,12);
line_indices_Met2 = line_indices_Met2(2:11);

adjrsquare = [];
rmse = [];
for line_idx = line_indices_Met2
    interp_Met1 = [];
    interp_flux = [];
    for IC = 1:num_IC
        data_IC = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));

        % Intersection points of Met2 vs. line index
        intersectionPt_Met2 = InterX([data_IC.concMatrix(2:end-1,Met2)';data_IC.concMatrix(2:end-1,Met1)'],[line_idx*ones(1,length(data_IC.concMatrix(2:end-1,Met2)));linspace(0,1e10,length(data_IC.concMatrix(2:end-1,Met2)))]);
        
        % Interpolate Met1 and flux data at intersection point
        if ~isempty(intersectionPt_Met2)
            for numIntersect = 2:size(intersectionPt_Met2,2)
                F1 = scatteredInterpolant(data_IC.concMatrix(2:end-1,Met1),data_IC.concMatrix(2:end-1,Met2),data_IC.fluxMatrix(2:end,tarFlux));
                interp_Met1 = [interp_Met1 intersectionPt_Met2(2,numIntersect)];
                interp_flux = [interp_flux F1(interp_Met1(end),line_idx)];
            end
        end
    end
    if length(interp_Met1)==length(interp_flux)
        nan_Met1 = find(isnan(interp_Met1)==1);
        nan_flux = find(isnan(interp_flux)==1);
        
        interp_Met1(union(nan_Met1,nan_flux)) = [];
        interp_flux(union(nan_Met1,nan_flux)) = [];
        if length(interp_Met1) > 2
            [f gof] = fit(interp_Met1',interp_flux','poly2');

            adjrsquare = [adjrsquare gof.adjrsquare];
            rmse = [rmse gof.rmse];
        end
    end
end
avg_corr_adjrsquare_Met1 = abs(nanmean(adjrsquare));
avg_rmse_Met1 = abs(nanmean(rmse));

if isnan(avg_corr_adjrsquare_Met1)
    avg_corr_adjrsquare_Met1 = 0.5;
end
if isnan(avg_rmse_Met1)
    avg_rmse_Met1 = 0.5;
end

adjrsquare = [];
rmse = [];
for line_idx = line_indices_Met1
    interp_Met2 = [];
    interp_flux = [];
    for IC = 1:num_IC
        data_IC = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));

        % Intersection points of Met1 vs. line index
        intersectionPt_Met1 = InterX([data_IC.concMatrix(2:end-1,Met1)';data_IC.concMatrix(2:end-1,Met2)'],[line_idx*ones(1,length(data_IC.concMatrix(2:end-1,Met1)));linspace(0,1e10,length(data_IC.concMatrix(2:end-1,Met1)))]);
        
        % Interpolate Met2 and flux data at intersection point
        if ~isempty(intersectionPt_Met1)
            for numIntersect = 2:size(intersectionPt_Met1,2)
                F1 = scatteredInterpolant(data_IC.concMatrix(2:end-1,Met2),data_IC.concMatrix(2:end-1,Met1),data_IC.fluxMatrix(2:end,tarFlux));
                interp_Met2 = [interp_Met2 intersectionPt_Met1(2,numIntersect)];
                interp_flux = [interp_flux F1(interp_Met2(end),line_idx)];
            end
        end
    end
    if length(interp_Met2)==length(interp_flux)
        nan_Met2 = find(isnan(interp_Met2)==1);
        nan_flux = find(isnan(interp_flux)==1);
        
        interp_Met2(union(nan_Met2,nan_flux)) = [];
        interp_flux(union(nan_Met2,nan_flux)) = [];
        if length(interp_Met2) > 2
            [f gof] = fit(interp_Met2',interp_flux','poly2');

            adjrsquare = [adjrsquare gof.adjrsquare];
            rmse = [rmse gof.rmse];
        end
    end
end
avg_corr_adjrsquare_Met2 = abs(nanmean(adjrsquare));
avg_rmse_Met2 = abs(nanmean(rmse));

if isnan(avg_corr_adjrsquare_Met2)
    avg_corr_adjrsquare_Met2 = 0.5;
end
if isnan(avg_rmse_Met2)
    avg_rmse_Met2 = 0.5;
end

min_corr_adjrsquare = min([avg_corr_adjrsquare_Met1 avg_corr_adjrsquare_Met2]);
max_rmse = max([avg_rmse_Met1 avg_rmse_Met2]);

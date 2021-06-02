function [min_corr_all] = fcn_hold1MetConstant_noisy(prefix,Met1,Met2,tarFlux,num_IC,nT,cov,rep)

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

line_indices_Met1 = linspace(minConc_Met1,maxConc_Met1,22);
line_indices_Met1 = line_indices_Met1(2:21);
line_indices_Met2 = linspace(minConc_Met2,maxConc_Met2,22);
line_indices_Met2 = line_indices_Met2(2:21);

correlation_Met1_1 = [];
correlation_Met1_2 = [];
for line_idx = line_indices_Met2
    interp_Met1 = [];
    interp_flux = [];
    for IC = 1:num_IC
        data_IC = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));

        % Intersection points of Met2 vs. line index
        intersectionPt_Met2 = InterX([data_IC.concMatrix(2:end-1,Met2)';data_IC.concMatrix(2:end-1,Met1)'],[line_idx*ones(1,length(data_IC.concMatrix(2:end-1,Met2)));linspace(0,1e10,length(data_IC.concMatrix(2:end-1,Met2)))]);
        
        % Interpolate Met1 and flux data at intersection point
        if ~isempty(intersectionPt_Met2)
            for numIntersect = 1:size(intersectionPt_Met2,2)
                F1 = scatteredInterpolant(data_IC.concMatrix(2:end-1,Met1),data_IC.concMatrix(2:end-1,Met2),data_IC.fluxMatrix(2:end,tarFlux));
                interp_Met1 = [interp_Met1 intersectionPt_Met2(2,numIntersect)];
                interp_flux = [interp_flux F1(interp_Met1(end),line_idx)];
            end
        end
    end
    if ~isempty(interp_Met1) && ~isempty(interp_flux) && length(interp_Met1)==length(interp_flux)
        sorted_Met1_flux = sortrows([interp_Met1' interp_flux']);
        if sorted_Met1_flux(1,1) < 0.9*sorted_Met1_flux(end,1)
            correlation_Met1_1 = [correlation_Met1_1 corr([sorted_Met1_flux(1,1); sorted_Met1_flux(end,1)],[sorted_Met1_flux(1,2); sorted_Met1_flux(end,2)],'Type','Spearman')];
        end
            
        correlation_Met1_2 = [correlation_Met1_2 corr(interp_Met1',interp_flux','Type','Spearman')];
    end
end
avg_corr_Met1_1 = abs(nanmean(correlation_Met1_1));
avg_corr_Met1_2 = abs(nanmean(correlation_Met1_2));

if isnan(avg_corr_Met1_1)
    avg_corr_Met1_1 = 0.5;
end
if isnan(avg_corr_Met1_2)
    avg_corr_Met1_2 = 0.5;
end

correlation_Met2_1 = [];
correlation_Met2_2 = [];
for line_idx = line_indices_Met1
    interp_Met2 = [];
    interp_flux = [];
    for IC = 1:num_IC
        data_IC = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));

        % Intersection points of Met1 vs. line index
        intersectionPt_Met1 = InterX([data_IC.concMatrix(2:end-1,Met1)';data_IC.concMatrix(2:end-1,Met2)'],[line_idx*ones(1,length(data_IC.concMatrix(2:end-1,Met1)));linspace(0,1e10,length(data_IC.concMatrix(2:end-1,Met1)))]);
        
        % Interpolate Met2 and flux data at intersection point
        if ~isempty(intersectionPt_Met1)
            for numIntersect = 1:size(intersectionPt_Met1,2)
                F1 = scatteredInterpolant(data_IC.concMatrix(2:end-1,Met2),data_IC.concMatrix(2:end-1,Met1),data_IC.fluxMatrix(2:end,tarFlux));
                interp_Met2 = [interp_Met2 intersectionPt_Met1(2,numIntersect)];
                interp_flux = [interp_flux F1(interp_Met2(end),line_idx)];
            end
        end
    end
    if ~isempty(interp_Met2) && ~isempty(interp_flux) && length(interp_Met2)==length(interp_flux)
        sorted_Met2_flux = sortrows([interp_Met2' interp_flux']);
        if sorted_Met2_flux(1,1) < 0.9*sorted_Met2_flux(end,1)
            correlation_Met2_1 = [correlation_Met2_1 corr([sorted_Met2_flux(1,1); sorted_Met2_flux(end,1)],[sorted_Met2_flux(1,2); sorted_Met2_flux(end,2)],'Type','Spearman')];
        end
            
        correlation_Met2_2 = [correlation_Met2_2 corr(interp_Met2',interp_flux','Type','Spearman')];
    end
end
avg_corr_Met2_1 = abs(nanmean(correlation_Met2_1));
avg_corr_Met2_2 = abs(nanmean(correlation_Met2_2));

if isnan(avg_corr_Met2_1)
    avg_corr_Met2_1 = 0.5;
end
if isnan(avg_corr_Met2_2)
    avg_corr_Met2_2 = 0.5;
end

min_corr_1 = min([avg_corr_Met1_1 avg_corr_Met2_1]);
min_corr_2 = min([avg_corr_Met1_2 avg_corr_Met2_2]);
min_corr_all = min([avg_corr_Met1_1 avg_corr_Met2_1 avg_corr_Met1_2 avg_corr_Met2_2]);
mean_corr_all = nanmean([avg_corr_Met1_1 avg_corr_Met2_1 avg_corr_Met1_2 avg_corr_Met2_2]);

function [adjrsquare rmse] = feature_surfaceFit_multiContMet_noisy(prefix,metgroup1,metgroup2,tarFlux,num_IC,nT,cov,rep)
% Non-hyperplane surface fit (use power of 3)

    concData = [];
    fluxData = [];
    for IC = 1:num_IC
        data = load(sprintf('%s_k-%02d_nT-%03d_cov-%02d_rep-%03d_smooth.mat',prefix,IC,nT,cov,rep));
        concData = [concData; data.concMatrix(2:end-1,:)];
        fluxData = [fluxData; data.fluxMatrix(2:end,:)];
    end
    controller_concData = concData(:,[metgroup1 metgroup2]);
    tar_fluxData = fluxData(:,tarFlux);
    
    if size(controller_concData,2) == 2
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3);
        beta0 = [1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 3
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4);
        beta0 = [1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 4
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4)*x(:,4).^1+b(5);
        beta0 = [1 1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 5
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4)*x(:,4).^1+b(5)*x(:,5).^1+b(6);
        beta0 = [1 1 1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 6
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4)*x(:,4).^1+b(5)*x(:,5).^1+b(6)*x(:,6).^1+b(7);
        beta0 = [1 1 1 1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 7
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4)*x(:,4).^1+b(5)*x(:,5).^1+b(6)*x(:,6).^1+b(7)*x(:,7).^1+b(8);
        beta0 = [1 1 1 1 1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    if size(controller_concData,2) == 8
        modelfun = @(b,x)b(1)*x(:,1).^1+b(2)*x(:,2).^1+b(3)*x(:,3).^1+b(4)*x(:,4).^1+b(5)*x(:,5).^1+b(6)*x(:,6).^1+b(7)*x(:,7).^1+b(8)*x(:,8).^1+b(9);
        beta0 = [1 1 1 1 1 1 1 1 1];
        mdl = fitnlm(controller_concData,tar_fluxData,modelfun,beta0);
    end
    
    adjrsquare = mdl.Rsquared.Adjusted;
    rmse = mdl.RMSE;
end
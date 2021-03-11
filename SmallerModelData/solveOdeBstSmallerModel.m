function [timeVec, concMatrix, fluxMatrix] = solveOdeBstSmallerModel(tStart,tEnd,nT,x0,params)
% Solve ODE BST equations to simulate concentrations and flux.

    if ~any(imag(params(:)))
        
        if exist('params','var')
            params = convertOdeParams_SmallerModel(params);
        else
            params = setOdeParams;
        end
        
        [timeVec,concMatrix] = ode15s(@(t,x)fRHS(t,x,params),linspace(tStart,tEnd,nT+1),x0',odeset('NonNegative',ones(size(x0'))));

        fluxMatrix = zeros(length(timeVec),12);
        for k = 1:length(timeVec)
            fluxMatrix(k,1:6) = calcFluxes(timeVec(k),concMatrix(k,:)',params)';
            fluxMatrix(k,7:12) = fRHS(timeVec(k),concMatrix(k,:)',params)';
        end
    else
        timeVec = [];
        concMatrix = [];
        fluxMatrix = [];
    end
end

function xdot = fRHS(~,x,params)

    x = real(x);
    x(x<0) = 0;
    
    v = calcFluxes([],x,params);
    xdot = params.S*v;
    
end

function v = calcFluxes(~,x,params)
    
    minVal = 1e-3;
    
    v(1,1) = params.v0;
    
    if x(1) < minVal || x(5) < minVal
        v(2,1) = 0;
    else
        v(2,1) = params.a2*x(1)^params.b21*x(4)^params.b2r4*x(5)^params.b2r5;
    end
        
    if x(2) < minVal || x(6) < minVal
        v(3,1) = 0;
    else
        v(3,1) = params.a3*x(2)^params.b32*x(6)^params.b3r6;
    end
    
    if x(2) < minVal
        v(4,1) = 0;
    else
        v(4,1) = params.a4*x(2)^params.b42*x(5)^params.b4r5;
    end
    
    if x(2) < minVal
        v(5,1) = 0;
    else
        v(5,1) = params.a5*x(2)^params.b52;
    end
    
    if x(5) < minVal
        v(6,1) = 0;
    else
        v(6,1) = params.a6*x(5)^params.b65*x(3)^params.b6r3*x(6)^params.b6r6;
    end
    
end

function params = convertOdeParams_SmallerModel(paramVec)
% ParamVec = [a2; b21; b2r4; b2r5; a3; b32; b3r6; a4; b42; b4r5; a5; b52; a6; b65; b6r3; b6r6]; 

    paramVec = paramVec(:);
    
    params.S = [ 1 -1  0  0  0  0 ;
                 0  1 -1 -1 -1  0 ;
                 0  0  1  0  0  0 ;
                 0  0  0  1  0  0 ;
                 0  0  0  0  1 -1 ;
                 0  0  0  0  0  1 ;];

    params.v0 = 1;
    
    params.a2 = paramVec(1);
    params.b21 = paramVec(2);
    params.b2r4 = paramVec(3);
    params.b2r5 = paramVec(4);
    params.a3 = paramVec(5);
    params.b32 = paramVec(6);
    params.b3r6 = paramVec(7);
    params.a4 = paramVec(8);
    params.b42 = paramVec(9);
    params.b4r5 = paramVec(10);
    params.a5 = paramVec(11);
    params.b52 = paramVec(12);
    params.a6 = paramVec(13);
    params.b65 = paramVec(14);
    params.b6r3 = paramVec(15);
    params.b6r6 = paramVec(16);
    
end

function [timeVec, concMatrix, fluxMatrix] = solveOdeBstBiggerModel(tStart,tEnd,nT,x0,params)
% Solve ODE BST equations to simulate concentrations and flux.

    if ~any(imag(params(:)))
        
        if exist('params','var')
            params = convertOdeParams_BiggerModel(params);
        else
            params = setOdeParams;
        end
        
        [timeVec,concMatrix] = ode15s(@(t,x)fRHS(t,x,params),linspace(tStart,tEnd,nT+1),x0',odeset('NonNegative',ones(size(x0'))));

        fluxMatrix = zeros(length(timeVec),20);
        for k = 1:length(timeVec)
            fluxMatrix(k,1:10) = calcFluxes(timeVec(k),concMatrix(k,:)',params)';
            fluxMatrix(k,11:20) = fRHS(timeVec(k),concMatrix(k,:)',params)';
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
    
    if x(1) < minVal || x(7) < minVal
        v(2,1) = 0;
    else
        v(2,1) = params.a2*x(1)^params.b21*x(2)^params.b2r2*x(7)^params.b2r7;
    end
        
    if x(2) < minVal
        v(3,1) = 0;
    else
        v(3,1) = params.a3*x(2)^params.b32*x(4)^params.b3r4;
    end
    
    if x(3) < minVal
        v(4,1) = 0;
    else
        v(4,1) = params.a4*x(3)^params.b43*x(8)^params.b4r8;
    end
    
    if x(3) < minVal ||  x(6) < minVal ||  x(10) < minVal
        v(5,1) = 0;
    else
        v(5,1) = params.a5*x(3)^params.b53*x(6)^params.b5r6*x(10)^params.b5r10;
    end
    
    if x(2) < minVal ||  x(8) < minVal
        v(6,1) = 0;
    else
        v(6,1) = params.a6*x(2)^params.b62*x(8)^params.b6r8;
    end
    
    if x(6) < minVal
        v(7,1) = 0;
    else
        v(7,1) = params.a7*x(6)^params.b76;
    end
    
    if x(6) < minVal
        v(8,1) = 0;
    else
        v(8,1) = params.a8*x(6)^params.b86*x(5)^params.b8r5*x(7)^params.b8r7;
    end
    
    if x(4) < minVal
        v(9,1) = 0;
    else
        v(9,1) = params.a9*x(4)^params.b94;
    end
    
    if x(8) < minVal
        v(10,1) = 0;
    else
        v(10,1) = params.a10*x(8)^params.b108;
    end
    
end

function params = convertOdeParams_BiggerModel(paramVec)
% ParamVec = [a2; b21; b2r2; b2r7; a3; b32; b3r4; a4; b43; b4r8; a5; b53; b5r6; b5r10;
            % a6; b62; b6r8; a7; b76; a8; b86; b8r5; b8r7; a9; b94; a10; b108;]; 

    paramVec = paramVec(:);
    
    params.S = [ 1 -1  0  0  0  0  0  0  0  0 ;
                 0  1 -1  0  0 -1  0  0  0  0 ;
                 0  0  1 -1 -1  0  0  0  0  0 ;
                 0  0  0  1  0  0  0  0 -1  0 ;
                 0  0  0  0  1  0  0  0  0  0 ;
                 0  0  0  0  0  1 -1 -1  0  0 ;
                 0  0  0  0  0  0  1  0  0  0 ;
                 0  0  0  0  0  0  0  1  0 -1 ;
                 0  0  0  0  0  0  0  0  1  0 ;
                 0  0  0  0  0  0  0  0  0  1 ;];

    params.v0 = 1;
    
    params.a2 = paramVec(1);
    params.b21 = paramVec(2);
    params.b2r2 = paramVec(3);
    params.b2r7 = paramVec(4);
    params.a3 = paramVec(5);
    params.b32 = paramVec(6);
    params.b3r4 = paramVec(7);
    params.a4 = paramVec(8);
    params.b43 = paramVec(9);
    params.b4r8 = paramVec(10);
    params.a5 = paramVec(11);
    params.b53 = paramVec(12);
    params.b5r6 = paramVec(13);
    params.b5r10 = paramVec(14);
    params.a6 = paramVec(15);
    params.b62 = paramVec(16);
    params.b6r8 = paramVec(17);
    params.a7 = paramVec(18);
    params.b76 = paramVec(19);
    params.a8 = paramVec(20);
    params.b86 = paramVec(21);
    params.b8r5 = paramVec(22);
    params.b8r7 = paramVec(23);
    params.a9 = paramVec(24);
    params.b94 = paramVec(25);
    params.a10 = paramVec(26);
    params.b108 = paramVec(27);

end

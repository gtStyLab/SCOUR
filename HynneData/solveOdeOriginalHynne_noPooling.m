function [timeVec, concMatrix, fluxMatrix] = solveOdeOriginalHynne_noPooling(tStart,tEnd,nT,x0,params,stm)
% This function is hard-coded to integrate the branched pathway model as an
% ODE with Michaelis-Menten kinetic rate laws described in the
% Supplementary Methods. 
%
% Written by R.A. Dromms 2015-07-29
% Edited for Hynne S. cerevisiae model JL17May20
    %{
    if exist('params','var')
        params = convertOdeParams(params);
    else
        params = setOdeParams;
    end
    %}
    [timeVec,concMatrix] = ode45(@(t,x)fRHS(t,x,params,stm),linspace(tStart,tEnd,nT+1),x0');
    
    % From solveOdeBst...
    %[timeVec,concMatrix] = ode15s(@(t,x)fRHS(t,x,params,stm),linspace(tStart,tEnd,nT+1),x0',odeset('NonNegative',ones(size(x0'))));
    
    fluxMatrix = zeros(length(timeVec),24);
    for k = 1:length(timeVec)
        fluxMatrix(k,1:24) = calcFluxes(timeVec(k),concMatrix(k,:)',params)';
        %fluxMatrix(k,25:42) = fRHS(timeVec(k),concMatrix(k,:)',params,stm)';
    end
    
end

function xdot = fRHS(~,x,params,stm)
    
    x(x<0) = 0;
    v = calcFluxes([],x,params);
    
    xdot = stm*v; 

end

function v = calcFluxes(~,x,params)
    
    % Bad Things can happen with the math when we allow negative x
    % (Which isn't physically relevant, anyways)
    xMin = 1e-4;
    x(x<xMin) = xMin;
    
    % List of reactions
    %Glucose Mixed flow to extracellular medium
    v(1,1) = params(62)*(params(63) - x(1));    

    %Glucose uptake
    v(2,1) = (params(5)/params(61))*(x(1)/params(1))/(1 + x(1)/params(1) + ((params(4)*x(1)/params(1) + 1)/(params(4)*x(2)/params(1) + 1))*(1 + x(2)/params(1) + x(4)/params(2) + (x(2)*x(4))/(params(1)*params(3))))...
        - (params(6)/params(61))*(x(2)/params(1))/(1 + x(2)/params(1) + ((params(4)*x(2)/params(1) + 1)/(params(4)*x(1)/params(1) + 1))*(1 + x(1)/params(1)) + x(4)/params(2) + (x(2)*x(4))/(params(1)*params(3)));

    %Hexokinase
    v(3,1) = (params(10)*x(3)*x(2))/(params(8)*params(7) + params(9)*x(3) + params(7)*x(2) + x(2)*x(3));

    %Phosphoglucoisomerase
    v(4,1) = (params(14)*x(4))/(params(12) + x(4) + (params(12)/params(11))*x(6)) - (params(15)*x(6)/params(13))/(params(12) + x(4) + (params(12)/params(11))*x(6));

    %Phosphofructokinase
    v(5,1) = (params(17)*x(6)^2)/(params(16)*(1 + params(18)*(x(3)/x(22))*(x(3)/x(22))) + x(6)^2);

    %Aldolase
    v(6,1) = (params(24)*x(7))/(params(20) + x(7) + (x(8)*params(19)*params(24))/(params(23)*params(24)*params(25)) + (x(7)*x(8))/params(22) + (x(8)*x(9)*params(24))/(params(23)*params(24)*params(25)))...
        - ((params(24)*x(8)*x(9))/params(23))/(params(20) + x(7) + (x(8)*params(19)*params(24))/(params(23)*params(24)*params(25)) + (x(9)*params(21)*params(24))/(params(23)*params(24)*params(25)) + (x(7)*x(8))/params(22) + (x(8)*x(9)*params(24))/(params(23)*params(24)*params(25)));
    
    %Triosephosphate isomerase
    v(7,1) = (params(29)*x(9))/(params(26) + x(9) + (params(26)/params(27))*x(8)) - (params(30)*x(8)/params(28))/(params(26) + x(9) + (params(26)/params(27))*x(8));

    %Glyceraldehyde 3-phosphate dehydrogenase
    v(8,1) = ((params(36)*x(8)*x(10))/params(32)/params(33))/((1 + x(8)/params(32) + x(11)/params(31))*(1 + x(10)/params(33) + x(12)/params(34))) - ((params(37)*x(11)*x(12))/params(35)/params(32)/params(33))/((1 + x(8)/params(32) + x(11)/params(31))*(1 + x(10)/params(33) + x(12)/params(34)));

    %Phosphoenolpyruvate synthesis***
    v(9,1) = params(38)*x(11)*x(5) - params(39)*x(13)*x(3);

    %Pyruvate kinase
    v(10,1) = (params(42)*x(5)*x(13))/((params(41) + x(13))*(params(40) + x(5)));

    %Pyruvate decarboxylase
    v(11,1) = (params(44)*x(14))/(params(43) + x(14));

    %Alcohol dehydrogenase
    v(12,1) = (params(47)*x(15)*x(12))/((params(46) + x(12))*(params(45) + x(15)));
    
    %Ethanol out
    v(13,1) = (params(48)/params(61))*(x(16) - x(17));

    %Ethanol flow
    v(14,1) = params(62)*x(17);

    %Glycerol synthesis
    v(15,1) = (params(53)*x(9))/(params(49)*(1 + (params(51)/x(12))*(1 + x(10)/params(50))) + x(9)*(1 + (params(52)/x(12))*(1 + x(10)/params(50))));

    %Glycerol out
    v(16,1) = (params(54)/params(61))*(x(18) - x(19));

    %Glycerol flow
    v(17,1) = params(62)*x(19);

    %Acetaldehyde out
    v(18,1) = (params(55)/params(61))*(x(15) - x(20));

    %Acetaldehyde flow
    v(19,1) = params(62)*x(20);

    %Cyanide-Acetaldehyde flow
    v(20,1) = params(56)*x(20)*x(21);

    %Cyanide flow
    v(21,1) = params(62)*(params(64) - x(21));

    %Storage
    v(22,1) = params(57)*x(3)*x(4);

    %ATP consumption
    v(23,1) = params(58)*x(3);

    %Adenylate kinase***
    v(24,1) = params(59)*x(3)*x(22) - params(60)*x(5)^2;
    
end

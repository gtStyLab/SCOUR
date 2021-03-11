function [concentrations,flux,interaction_mets,true_regs,params,met_correlation] = autogenerate_interactiondata_3contMet(number_ints,number_IC,tStart,tEnd,nT,fraction_true)
% Generates random functional or non-functional data with 3 controller
% metabolites

% Randomly generate a and b parameters in BST equations
%params = rand(4,number_ints);
params(1:2,:) = 2*rand(2,number_ints);
params(3:4,:) = -2 + 2*2*rand(2,number_ints);

for IC = 1:number_IC
    for interaction = 1:number_ints

        % Randomly generate parameters for damped wave functions
        A= 2*rand(5,1); 
        lambda = rand(5,1);
        w = rand(5,1);
        phi = rand(5,1);
        t = linspace(tStart,tEnd,nT+1);

        % Generate initial metabolite time course data
        x1 = A(1)*exp(-lambda(1)*t).*(cos(w(1)*t+phi(1)) + (sin(w(1)*t+phi(1)))); % Mass Action Met
        x2 = A(2)*exp(-lambda(2)*t).*(cos(w(2)*t+phi(2)) + (sin(w(2)*t+phi(2)))); % Reg Met 1
        x3 = A(3)*exp(-lambda(3)*t).*(cos(w(3)*t+phi(3)) + (sin(w(3)*t+phi(3)))); % Reg Met 2
        x4 = A(4)*exp(-lambda(4)*t).*(cos(w(4)*t+phi(4)) + (sin(w(4)*t+phi(4)))); % Random Met 1
        x5 = A(5)*exp(-lambda(5)*t).*(cos(w(5)*t+phi(5)) + (sin(w(5)*t+phi(5)))); % Random Met 2

        % Randomly flip some of the time course data overthe x-axis (positive or negative)
        m = randi(2,5,1)-1;
        m(~m) = -1;

        x1 = m(1)*x1;
        x2 = m(2)*x2;
        x3 = m(3)*x3;
        x4 = m(4)*x4;
        x5 = m(5)*x5;

        % Shift data so there are no negative concentrations
        min_x1 = min(x1);
        min_x2 = min(x2);
        min_x3 = min(x3);
        min_x4 = min(x4);
        min_x5 = min(x5);
        x1 = x1 + abs(min_x1) + 0.5*rand(1);
        x2 = x2 + abs(min_x2) + 0.5*rand(1);
        x3 = x3 + abs(min_x3) + 0.5*rand(1);
        x4 = x4 + abs(min_x4) + 0.5*rand(1);
        x5 = x5 + abs(min_x5) + 0.5*rand(1);

        % Randomly force x2, x3, x4, and/or x5 to be correlated with x1
        chance_correlation_x2 = rand(1);
        chance_correlation_x3 = rand(1);
        chance_correlation_x4 = rand(1);
        chance_correlation_x5 = rand(1);
        if chance_correlation_x2 < 0.15 % 20% chance of x2 being correlated with x1
            chance_correlation_x2 = 1;
            x2 = 2*rand(1)*x1;
        end
        if chance_correlation_x3 < 0.15 % 20% chance of x3 being correlated with x1
            chance_correlation_x3 = 1;
            x3 = 2*rand(1)*x1;
        end
        if chance_correlation_x4 < 0.15 % 20% chance of x4 being correlated with x1
            chance_correlation_x4 = 1;
            x4 = 2*rand(1)*x1;
        end
        if chance_correlation_x5 < 0.15 % 20% chance of x5 being correlated with x1
            chance_correlation_x5 = 1;
            x5 = 2*rand(1)*x1;
        end
        
        % Calculate flux data using metabolite concentrations of the MA and
        % true regulatory metabolites
        v = params(1,interaction)*x1(1:end-1).^params(2,interaction).*x2(1:end-1).^params(3,interaction).*x3(1:end-1).^params(4,interaction);
        
        % Concatenate data together
        % Each cell in 'concentrations' represents an initial condition
        % (IC) and interaction. Each cell contains 5 columns that represent
        % the 5 metabolite concentration time courses.
        % Each cell in 'flux' represents an IC and interaction. Each cell
        % contains a single column representing the flux time course data
        % for that particular interaction.
        if interaction == 1
            met_correlation{IC,interaction} = [chance_correlation_x2 chance_correlation_x3 chance_correlation_x4 chance_correlation_x5];
            concentrations{IC,interaction} = [x1' x2' x3' x4' x5'];
            flux{IC,interaction} = v';
        else
            met_correlation{IC} = [met_correlation{IC} chance_correlation_x2 chance_correlation_x3 chance_correlation_x4 chance_correlation_x5];
            concentrations{IC} = [concentrations{IC} x1' x2' x3' x4' x5'];
            flux{IC} = [flux{IC} v'];
        end 
    end
end

% Label interactions with the number of true or false controller
% metabolites
% 1 represents the true MA metabolite (always present)
% 2 and 3 represent the true (existing) regulatory metabolites
% 4 and 5 represent the false (non-existing) regulatory metabolites
for interaction = 1:number_ints
    interaction_type = rand(1);
    if interaction_type <= fraction_true
        interaction_mets{interaction} = [1 2 3]; % Three true controller metabolites
        true_regs(interaction) = 1;
    elseif interaction_type > fraction_true && interaction_type <= fraction_true+0.5*(1-fraction_true)
        interaction_mets{interaction} = [1 2 4]; % Two true, one false controller metabolites
        true_regs(interaction) = 0;
    else
        interaction_mets{interaction} = [1 4 5]; % One true, two false controller metabolites
        true_regs(interaction) = 0;
    end
end
true_regs  = true_regs'; % true_regs tells the user if the interaction is true (existing) or not


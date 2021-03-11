function [concentrations,flux,true_regs,params] = autogenerate_interactiondata_1contMet(number_ints,number_IC,tStart,tEnd,nT,fraction_true)
% Generates flux data controlled by one metabolite or multiple metabolites.
% Also generates concentration time course data for aforementioned
% metabolites.

% Randomly generate a and b parameters in BST equations
params = rand(3,number_ints);

for IC = 1:number_IC
    for interaction = 1:number_ints

        % Randomly generate parameters for damped wave functions
        A= 2*rand(2,1); 
        lambda = rand(2,1);
        w = rand(2,1);
        phi = rand(2,1);
        t = linspace(tStart,tEnd,nT+1);

        % Generate initial metabolite time course data
        x1 = A(1)*exp(-lambda(1)*t).*(cos(w(1)*t+phi(1)) + (sin(w(1)*t+phi(1)))); % Mass Action Met
        x2 = A(2)*exp(-lambda(2)*t).*(cos(w(2)*t+phi(2)) + (sin(w(2)*t+phi(2)))); % Random Met

        % Randomly flip some of the time course data overthe x-axis (positive or negative)
        m = randi(2,2,1)-1;
        m(~m) = -1;

        x1 = m(1)*x1;
        x2 = m(2)*x2;

        % Shift data so there are no negative concentrations
        min_x1 = min(x1);
        min_x2 = min(x2);
        x1 = x1 + abs(min_x1) + 0.5*rand(1);
        x2 = x2 + abs(min_x2) + 0.5*rand(1);

        % Randomly select if interactions are controlled by 1 or 2
        % metabolites, and then generate flux data
        if IC == 1
            interaction_type = rand(1);
            if interaction_type <= fraction_true
                true_regs(interaction) = 1; % Controlled by 1 metabolite
                params(3,interaction) = 0;
            elseif interaction_type > fraction_true
                true_regs(interaction) = 0; % Controlled by 2 metabolites
            end
        end
    
        % Calculate flux data using metabolite concentrations of the MA and
        % true regulatory metabolite
        v = params(1,interaction)*x1(1:end-1).^params(2,interaction).*x2(1:end-1).^params(3,interaction);
        
        % Concatenate data together
        % Each cell in 'concentrations' represents an initial condition
        % (IC) and interaction. Each cell contains 3 columns that represent
        % the 3 metabolite concentration time courses.
        % Each cell in 'flux' represents an IC and interaction. Each cell
        % contains a single column representing the flux time course data
        % for that particular interaction.
        if interaction == 1
            concentrations{IC,interaction} = [x1' x2'];
            flux{IC,interaction} = v';
        else
            concentrations{IC} = [concentrations{IC} x1' x2'];
            flux{IC} = [flux{IC} v'];
        end 
    end
end
true_regs  = true_regs'; % true_regs tells the user if the interaction is true (existing) or not

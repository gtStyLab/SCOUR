function [concentrations,flux,interaction_mets,true_regs,params] = autogenerate_interactiondata_2contMet_smallchange(number_ints,number_IC,tStart,tEnd,nT,fraction_true)
% Generates random functional or non-functional data with 2 controller
% metabolites

% Randomly generate a and b parameters in BST equations
params(1:2,:) = 2*rand(2,number_ints);
params(3,:) = -2 + 2*2*rand(1,number_ints);

%params(1,:) = 2*rand(2,number_ints);
%params(2,:) = 1.5 + 0.4*randn(1,number_ints);
%params(params<0) = 2*rand(length(params(params<0)));
%params(3,:) = -2 + 2*2*rand(1,number_ints);

for interaction = 1:number_ints
    
    min_x1 = [];
    min_x2 = [];
    min_x3 = [];
    for IC = 1:number_IC

        % Randomly generate parameters for damped wave functions
        A = 2*rand(3,1); 
        lambda = rand(3,1);
        w = rand(3,1);
        phi = rand(3,1);
        t = linspace(tStart,tEnd,nT+1);

        % Generate initial metabolite time course data
        x1 = A(1)*exp(-lambda(1)*t).*(cos(w(1)*t+phi(1)) + (sin(w(1)*t+phi(1)))); % Mass Action Met
        x2 = A(2)*exp(-lambda(2)*t).*(cos(w(2)*t+phi(2)) + (sin(w(2)*t+phi(2)))); % Reg Met
        if rand(1) < 0.5
            x3 = A(3)*exp(-lambda(3)*t).*(cos(w(3)*t+phi(3)) + (sin(w(3)*t+phi(3)))); % Random Met
        else
            %x3 = x2*abs(1+0.2*randn(1)) + 0.1*randn(1)*median(x2); % Random Met
            %x3 = x2.*abs(1+0.2*randn(1,length(x2))) + 0.1*randn(1)*median(x2); % Random Met
            
            pd = makedist('Normal','mu',0,'sigma',3);
            x = linspace(-20,20,length(x2));
            y = abs(1+0.5*randn(1))*(pdf(pd,x)+1);
            x3 = x2.*y;
        end
                
        % Randomly flip some of the time course data overthe x-axis (positive or negative)
        m = randi(2,3,1)-1;
        m(~m) = -1;

        x1 = m(1)*x1;
        x2 = m(2)*x2;
        x3 = m(3)*x3;
        
        % Store minimum value data for later
        min_x1 = [min_x1 min(x1)];
        min_x2 = [min_x2 min(x2)];
        min_x3 = [min_x3 min(x3)];
        
        % Concatenate data together
        % Each cell in 'concentrations' represents an initial condition
        % (IC) and interaction. Each cell contains 3 columns that represent
        % the 3 metabolite concentration time courses.
        % Each cell in 'flux' represents an IC and interaction. Each cell
        % contains a single column representing the flux time course data
        % for that particular interaction.
        if interaction == 1
            concentrations{IC,interaction} = [x1' x2' x3'];
        else
            concentrations{IC} = [concentrations{IC} x1' x2' x3'];
        end 
    end
    overall_min_x1 = min(min_x1);
    overall_min_x2 = min(min_x2);
    overall_min_x3 = min(min_x3);
        
    for IC = 1:number_IC
        % Shift data so there are no negative concentrations
        concentrations{IC}(:,3*(interaction-1)+1) = concentrations{IC}(:,3*(interaction-1)+1) + abs(overall_min_x1) + 0.5*rand(1); % x1
        concentrations{IC}(:,3*(interaction-1)+2) = concentrations{IC}(:,3*(interaction-1)+2) + abs(overall_min_x2) + 0.5*rand(1); % x2
        concentrations{IC}(:,3*(interaction-1)+3) = concentrations{IC}(:,3*(interaction-1)+3) + abs(overall_min_x3) + 0.5*rand(1); % x3
        
        % Calculate flux data using metabolite concentrations of the MA and
        % true regulatory metabolite
        x1 = concentrations{IC}(:,3*(interaction-1)+1);
        x2 = concentrations{IC}(:,3*(interaction-1)+2);
        
        v = params(1,interaction)*x1(1:end-1).^params(2,interaction).*x2(1:end-1).^params(3,interaction);
        
        if interaction == 1
            flux{IC,interaction} = v;
        else
            flux{IC} = [flux{IC} v];
        end
    end
end

% Label interactions with the number of true or false controller
% metabolites
% 1 represents the true MA metabolite (always present)
% 2 represents the true (existing) regulatory metabolite
% 3 represents the false (non-existing) regulatory metabolite
for interaction = 1:number_ints
    interaction_type = rand(1);
    if interaction_type <= fraction_true
        interaction_mets{interaction} = [1 2]; % Two true controller metabolites
        true_regs(interaction) = 1;
    elseif interaction_type > fraction_true
        interaction_mets{interaction} = [1 3]; % One true, one false controller metabolites
        true_regs(interaction) = 0;
    end
end
true_regs  = true_regs'; % true_regs tells the user if the interaction is true (existing) or not


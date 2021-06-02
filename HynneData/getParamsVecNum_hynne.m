function vecOut = getParamsVecNum_hynne(n)
% Just a hard-coded list of parameter vectors, by index

    % Vary ICs
    paramsList{1}  = [
        1.7; % K2Glc
        1.2; % K2IG6P
        7.2; % K2IIG6P
        1; % P2
        1014.96; % V2f
        1014.96; % V2r
        0.1; % K3ATP
        0.37; % K3DGlc
        0; % K3Glc
        51.7547; % V3m
        0.15; % K4F6P
        0.8; % K4G6P
        0.13; % K4eq
        496.042; % V4f
        496.042; % V4r
        0.021; % K5
        45.4327; % V5m
        0.15; % kappa5
        2; % K6DHAP
        0.3; % K6FBP
        4; % K6GAP
        10; % K6IGAP
        0.81; % K6eq
        2207.82; % V6f
        5; % ratio6
        1.23; % K7DHAP
        1.27; % K7GAP
        0.055; % K7eq
        116.365; % V7f
        116.365; % V7r
        0.01; % K8BPG
        0.6; % K8GAP
        0.1; % K8NAD
        0.06; % K8NADH
        0.0055; % K8eq
        833.858; % V8f
        833.858; % V8r
        443866; % k9f
        1528.62; % k9r
        0.17; % K10ADP
        0.2; % K10PEP
        343.096; % V10m
        0.3; % K11
        53.1328; % V11m
        0.71; % K12ACA
        0.1; % K12NADH
        89.8023; % V12m
        16.72; % k13
        25; % K15DHAP
        0.13; % K15INAD
        0.034; % K15INADH
        0.13; % K15NADH
        81.4797; % V15m
        1.9; % k16
        24.7; % k18
        0.00283828; % k20
        2.25932; % k22
        3.2076; % k23
        432.9; % k24f
        133.333; % k24r
        
        59; % Yvol
        0.048; % k0
        
        24; % GlcX0 (default 18.5)
        5.6; % CNX0
        
        6.7; % x0_1 Extracellular Glucose (default 1.55307)
        0.573074; % x0_2 Cytsosolic glucose
        2.1; % x0_3 ATP
        4.2; % x0_4 Glucose-6-Phosphate
        1.5; % x0_5 ADP
        0.49; % x0_6 Fructose-6-Phosphate
        4.64; % x0_7 Fructose 1,6-bisphosphate
        0.115; % x0_8 Glyceraldehyde 3-phosphate
        2.95; % x0_9 Dihydroxyacetone phosphate
        0.65; % x0_10 NAD
        0.00027; % x0_11 1,3-Bisphosphoglycerate
        0.33; % x0_12 NADH
        0.04; % x0_13 Phosphoenolpyruvate
        8.7; % x0_14 Pyruvate
        1.48153; % x0_15 Acetaldehyde
        19.2379; % x0_16 EtOH
        16.4514; % x0_17 Extracellular ethanol
        4.196; % x0_18 Gycerol
        1.68478; % x0_19 Extracellular glycerol
        1.28836; % x0_20 Extracellular acetaldehyde
        5.20358; % x0_21 Extracellular cyanide
        0.33;]; % x0_22 AMP
    
    % Randomize initial conditions
    for i = 2:15
        paramsList{i} = paramsList{1};
        paramsList{i}(65:end) = abs(paramsList{i}(65:end) + 0.5*randn(length(paramsList{i}(65:end)),1).*paramsList{i}(65:end));
    end
    
    
    vecOut = paramsList{n};

end



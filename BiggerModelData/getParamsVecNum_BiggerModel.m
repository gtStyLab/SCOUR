function vecOut = getParamsVecNum_BiggerModel(n)
% Just a hard-coded list of parameter vectors, by index

    % Vary ICs
        %  Params  = [a2; b21; b2r2; b2r7; a3; b32; b3r4; a4; b43; b4r8; a5; b53; b5r6; b5r10;
                   % a6; b62; b6r8; a7; b76; a8; b86; b8r5; b8r7; a9; b94; a10; b108;
                       % x0_1;  x0_2;  x0_3;  x0_4;  x0_5;  x0_6;  x0_7;  x0_8;  x0_9;  x0_10;]; 
    paramsList{1}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.3;   0.4;   0.5;   0.3;   0.3;   0.5;   0.2;    0.2;   0.5;   0.8;];
                    
    paramsList{2}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.6;   0.9;   0.2;   0.9;   0.9;   0.3;   0.7;   0.8;   0.2;    0.9;];
    
    paramsList{3}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.5;   0.2;   0.7;   0.5;   0.3;   0.7;   0.8;   0.5;   0.7;    0.6;];
                    
    paramsList{4}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.4;   0.4;   0.6;   0.3;   0.8;   0.6;   0.3;   0.5;   0.6;    0.3;];
                    
    paramsList{5}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.1;   0.9;   0.8;   0.6;   0.7;   0.6;   0.7;   0.8;   0.7;    0.4;];
                    
    paramsList{6}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.5;   0.9;   0.4;   0.4;   0.9;   0.6;   0.2;   0.4;   0.4;    0.2;];
                    
    paramsList{7}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.4;   0.7;   0.7;   0.7;   0.1;   0.1;   0.8;   0.5;   0.6;    0.3;];
                    
    paramsList{8}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.9;   0.6;   0.8;   0.4;   0.4;   0.4;   0.2;   0.9;   0.8;    0.3;];
                    
    paramsList{9}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.8;   0.4;   0.3;   0.5;   0.6;   0.5;   0.6;   0.1;   0.1;    0.3;];
                    
    paramsList{10}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.5;   0.9;   0.5;   0.7;   0.3;   0.3;   0.4;   0.9;   0.1;    0.2;];
                    
    paramsList{11}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.4;   0.3;   0.3;   0.6;   0.7;   0.1;   0.3;    0.5;   0.4;   0.5;];
                    
    paramsList{12}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.7;   0.5;   0.7;   0.7;   0.8;   0.2;   0.7;   0.7;   0.6;    0.1;];
                    
    paramsList{13}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.1;   0.1;   0.8;   0.1;   0.7;   0.9;   0.8;   0.2;   0.1;    0.1;];
                    
    paramsList{14}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.1;   0.1;   0.9;   0.6;   0.2;   0.9;   0.5;   0.1;   0.6;    0.7;];
                    
    paramsList{15}  = [  0.7;  0.6;  -0.2;  0.4;    1; 0.75;  -0.3;  0.5;  0.4;  -0.6;  0.9;  0.5;   0.8;  0.4;   
                        0.7;  0.4;   0.4;  0.4; 0.5;   0.8;  0.3;  -0.2;  -0.5;    1;  0.5;   0.8;   0.8;
                        0.9;   0.8;   0.6;   0.4;   0.5;   0.7;   0.4;   0.2;   0.6;    0.2;];
                                          
    vecOut = paramsList{n};

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% StemGL_Fit Single stem Greenlab Fitting tool and
% StemGL_Sim Single stem GreenLab Simulation tool
%
%   MatLab_Octave code. 
%
% This code is part of GREENLAB project StemGL implementation
%
% Main Author: Philippe de Reffye CIRAD-AMAP
% Secondary author: Marc JAEGER CIRAD-AMAP
%
% Created: 2020
% Version 20_07_15
%
% Copyright (C) 2018 CIRAD-AMAP 
%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the Create Commons Licence  type 5, BY-NC-SA
% BY (Attribution): Licensees may copy, distribute, display and perform the work and make derivative
% works and remixes based on it only if they give the author or licensor the credits (attribution)
% in the manner specified by these.
% SA (Share-alike): Licensees may distribute derivative works only under a license identical
% ("not more restrictive") to the license that governs the original work.
% NC (Non-commercial): 	Licensees may copy, distribute, display, and perform the work and
% make derivative works and remixes based on it only for non-commercial purposes.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function [WPAR,WDEVPAR,WEPAR,WPRK,NPAR] = fit_lsqr_par(NVAR,chpm,A)
%
%   I   NVAR            int       Total number of  available parameters
%   I   chpm(NVAR)      int       Specifies is parameter is selected or not
%   I   A(NVAR)         double    Parameter initial value
%   I   scl             double    Scale increment
%   O   WPAR(NPAR)      double    Parameter values
%   O   WDEVPAR(NPAR)   double    Parameter initial deviation +/- 0.0001*WPAR
%   O   WEPAR(NPAR)     double    Parameter increment (0.001*WPAR) 
%   O   WPRK(NPAR)      int       Parameter initial index in variable list (integer)
%   O   NPAR            int       Number of parameters selected (<= NVAR)
%        
%   Last version 2018/11/27. Main author PdR/MJ. Copyright Cirad-AMAP
%   Last version 2019/5/21. Main author PdR/MJ. Copyright Cirad-AMAP

function [WPAR,WDEVPAR,WEPAR,WPRK,NPAR] = fit_lsqr_par(NVAR,chpm,A,scl)

    WPRK = zeros(NVAR,1,'int32');

    NPAR = 0;
    %NPAR: nomber des parametre on a ici 2 alpha et beta
    %wprk: le lieu des parametre le gammabeta le premier puis le  beta
    for var = 1 : NVAR
        if chpm(var) > 0
            NPAR = NPAR + 1;
            WPRK(NPAR) = var; % links the fitted parameter rank to its variable rank
        end
    end

%     WEPAR = zeros(NVAR,1);
%     WDEVPAR = zeros(NVAR,1);
%     WPAR = zeros(NVAR,1);
% 
    WEPAR = zeros(NPAR,1);
    WDEVPAR = zeros(NPAR,1);
    WPAR = zeros(NPAR,1);
    

    if NPAR > 0


        Init_Dev = scl;
        %WEPAR :

        for p = 1: NPAR
            var = WPRK(p);
            val = A(var);
            WPAR(p) = val; %choosen parameter to fit
            if (abs(val) < 0.001)
                val = 0.001;
            end
            WDEVPAR(p) = Init_Dev * val;% initial deviation
            WEPAR(p) = abs(0.001*val);% increment for numerical derivative
            Init_Dev = -Init_Dev; % change deviation direction
        end

    end

end
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

function [WM,WPD,WO,xregM,xregP,x] = fit_targ_comp(T,TQo,WM,WPD,WO,org,xregM,xregP,x)
xregP = x;
x = xregM ;% memory of mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To store compartment TQ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 0;
M1 = 0; 
V1 = 0;
for i = 1 : T
    if TQo(i) ~= 999 && TQo(i) ~= 0 
        k = k + 1;
        WM(x,1) = TQo(i);
        WO(x,1) = org;
        M1 = M1 + WM(x,1); % for means
        x = x + 1;
    end
end
xregM = x; %memory for indice of compartment
x = xregP;
%REM optimal weights for the compartment Qb
for i = 1 :T
    if TQo(i) ~= 999  &&  TQo(i) ~= 0  &&  k > 0
        if abs(V1 - M1^ 2 / k) > 0
            if k > 1
                WPD(x,1) = abs(1 / ((V1 - M1^ 2 / k)/(k - 1)));
            else
                WPD(x,1) = 0;
            end
        else  % special if only one data
            if k == 1
                WPD(x,1) = 1 / M1;
            else
                WPD(x,1) = 0;
            end
        end
        x = x + 1;
    end
end
xregP = x;
x = xregM ;% memory of mass
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

function [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qo,WM,WPD,WO,org,xregM,xregP,x)
xregP = x;
x = xregM ;% memory of mass
%%%%%%%%%%%%%%%%%%%%%%%%
% case of organ qo
%%%%%%%%%%%%%%%%%%%%%%%%
% reset counting
k = 0; 
M1 = 0; 
V1 = 0;
%for blade
    for i = 1 : mxTob % stop storing after expansion
        if Tob(i) > 0
            ind = (i-1)*T;
            for j = 1 : T
                ind = ind + 1;
                if qo(ind) ~= 999 && qo(ind) > -0.0001
                    k = k + 1;
                    if qo(ind) == 0.00001 
                        qo(ind) = 0; 
                    end % null data used for mark
                    WM(x,1) = qo(ind);%
                    WO(x,1) = org;
                    M1 = M1 + WM(x,1);% for all phy
                    V1 = V1 + WM(x,1)^2;
                    x = x + 1;
                end
            end
        end
    end
xregM = x;
x = xregP;
    for i = 1 : mxTob
        if Tob(i) > 0
            ind = (i-1)*T;
            for j = 1 : T
                ind = ind + 1;
                if qo(ind) ~= 999 && qo(ind) > -0.0001
                    if (abs(V1- M1^ 2 / k) >0.00001) && (k - 1 >1)  %
                        WPD(x,1) = abs(1 / ((V1 - M1^ 2 / k)/(k - 1)));
                    else
                        WPD(x,1) = 0;
                    end
                    x=x+1;
                end
            end
        end
    end
xregP = x;
x = xregM ;% memory of mass
end
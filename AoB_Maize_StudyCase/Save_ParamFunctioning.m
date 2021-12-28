
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

function [param] = Save_ParamFunctioning (param,Eo,Qo,aQo,aQr,Sp,r,kc)
%
% function [param] = Save_ParamFunctioning (param,Eo,Qo,aQo,aQr,Sp,r,kc)
%
%   I   Eo:         Default Environment E parameter value
%   I   Qo:         Seed Biomass value
%   I   aQo,aQr:    Seed emptying coeficients
%   I   Sp:         Surface of production
%   I   r:          Source organ resistivity (1/Water use efficiency)
%   I   kc:         Lambert-Behr extinction coeficient
%   I/O param:      the parameter table
%
%   Last version 2018/07/12. Main author MJ
%   Copyright Cirad-AMAP
%

    if length(param) > 1
        param(17,1) = Eo;
        param(17,2) = Qo;
        param(17,3) = aQo;
        param(17,4) = aQr;
        param(17,5) = r;
        param(17,6) = Sp;
        param(17,7) = kc;     
    else
    end

end



 
 
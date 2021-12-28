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

function [param] = Save_ParamFitting (param,comp,chpm)
%
% function [param] = Save_ParamFitting (param,comp,chpm)
%
%   I   comp:   table for parameter categories to fit
%   I   chpm:   boolean table specifying the parameters to be fitted
%   I/O param:  the parameter table
%
%   Last version 2018/07/12. Main author MJ
%   Copyright Cirad-AMAP
%
    if length(param) > 1
        param(18,1) = comp(1,1); 
        param(18,2) = comp(1,2);
        param(19,1:9) = chpm(1:9,1);
        param(20,1:9) = chpm(10:18,1);
        param(21,1:9) = chpm(19:27,1);
        param(22,1:9) = chpm(28:36,1);
    else
    end

end



 
 
 
 
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

function [modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20] = Load_ParamClimate (param)
%
% function [modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20] = Load_ParamClimate (param)
%
%   O   modE,Ec,cor,wE,bE,Lmx,Lmn:              climate parameters see climate function
%   O   modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20:    hydrology parameters see climate function
%   I   param:  the parameter table
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    modE=param(23,1);Ec=param(23,2);cor=param(23,3);wE=param(23,4);bE=param(23,5);
    Lmx=param(23,6);Lmn=param(23,7);
    
    modH=param(24,1);c1=param(24,2);c2=param(24,3);Hmx=param(24,4);Hmn=param(24,5);
    H1=param(24,6);psi=param(24,7);pH20=param(24,8);dH20=param(24,9);
end


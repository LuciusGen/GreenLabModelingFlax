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

function [T,Tm,N,w,kw,b,bf,rnd1,Msk,na,np,ni,nc,nf,nm,nt,tw] = Load_ParamStructure (param, p_Age)
%
% function [T,Tm,N,w,kw,b,bf,rnd1,Msk,na,np,ni,nc,nf,nm,nt,tw] = Load_ParamStructure (param)
%
%   O   T,Tm:       Plant final age and final development age
%   O   N:          Number of stachoastic repetitions
%   O   w,kw,tw,b:  Development parameters rhythm ratios, bernoulli
%   O   bf,rnd1:  	Fruit occurence probability and initial random seed 
%   O   Msk:        Mask indicator 
%   O   na,np,ni,nc,nf,nm,nt:   number of argans per phytomer
%   I   param:      the parameter table
%   I   p_Age:      plant age definesd as an external argument
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    %Plt age     death time    nb repeti     rythme      p Bernouilly  randomseed
    T = param(1,1);  Tm = param(1,2);  N = param(1,3);    w = param(1,4);   kw = param(1,5);
    b = param(1,6);  bf = param(1,7);  rnd1 = param(1,8); Msk = param(1,9);
    
    % overwrite plant age
    if p_Age > 0
        T = p_Age;
    end
    
    %nb leaves/ph nb petiol   nb intern/ph  nb fruits fem/ph  nb fruits mal/ph leaf fct time leaf exp time  int%exp time   frt ex time
    na = param(2,1); np = param(2,2); ni = param(2,3); nc = param(2,4); nf = param(2,5); nm = param(2,6); nt = param(2,7);

    tw = param(3,9);
    
end


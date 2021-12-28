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

function [param] = Save_ParamStructure (param,T,Tm,N,w,kw,b,bf,rnd1,Msk,na,np,ni,nc,nf,nm,nt,tw)
%
% function [param] = Save_Structure (param,T,Tm,N,w,kw,b,bf,rnd1,Msk,na,np,ni,nc,nf,nm,nt,tw)
%
%   I   T,Tm:       Plant final age and final development age
%   I   N:          Number of stachoastic repetitions
%   I   w,kw,tw,b:  Development parameters rhythm ratios, bernoulli
%   I   bf,rnd1:  	Fruit occurence probability and initial random seed 
%   I   Msk:        Mask indicator 
%   I   na,np,ni,nc,nf,nm,nt:   number of argans per phytomer
%   I/O param:  the parameter table
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

    if length(param) > 1
         param(1,1) = T;
         param(1,2) = Tm;
         param(1,3) = N;
         param(1,4) = w; 
         param(1,5) = kw;
         param(1,6) = b;
         param(1,7) = bf;
         param(1,8) = rnd1;
         param(1,9) = Msk;
         
         param(2,1) = na;
         param(2,2) = np;
         param(2,3) = ni;
         param(2,4) = nc;
         param(2,5) = nf;
         param(2,6) = nm;
         param(2,7) = nt;
        
         param(3,9) = tw;
    else
    end

end
 
 
 
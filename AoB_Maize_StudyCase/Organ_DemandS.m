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

function [ Do_is ] = Organ_DemandS(i,no,nf,po,kpo,Bo,Dlo,Axd,s)
%
% function [ Do_is ] = Organ_DemandS(i,no,nf,po,kpo,Bo,Dlo,Axd,Do_is,s)
%   Computes the organ cohort demand at cycle i for stochastic serial s
%
%   I   i: current cycle
%   I   no(T,Nrep_S):   number of organs
%   I   nf(T,Nrep_S):   number of female fruits
%   I   nf(T,Nrep_S):   number of fruits
%   I   po:             organ sink
%   I   kpo:            sink value if fruit correlation (=0 desactivate it)
%   I   Bo(T,Dlo):      sink variation beta law
%   I   Dlo:            organ expansion life span
%   I   Axd(T,Nrep_S):  development axis
%   I   s:              stochastic serial number
%
%   I/O Do_is:          organ demand at cycle i for stochastic serial s
%

    Do_is = 0;
    if po > 0
        x = i - Dlo;
        j = 1;
        if kpo > 0
            kpo = kpo * po;
            while x > 0    
                %xpo=po;
                if nf(j,s) > 0
                    %xpo = po*kpo;% 2 kinds of sink according type of phytomer (with fruit)
                    Do_is = Do_is + no(j,s)*kpo*Bo(j,x)*Axd(j,s);
                else
                    Do_is = Do_is + no(j,s)*po*Bo(j,x)*Axd(j,s);
                end
                %Do_is = Do_is + no(j,s)*xpo*Bo(j,x)*Axd(j,s);
                x = x - 1;
                j = j + 1;
            end
        else
            while x > 0    
                Do_is = Do_is + no(j,s)*po*Bo(j,x)*Axd(j,s);
                x = x - 1;
                j = j + 1;
            end
        end
        
    end
    
end



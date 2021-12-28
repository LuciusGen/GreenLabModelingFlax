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
% Copyright (C) 2018-2020 CIRAD-AMAP 
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

function D_org = Organ_DemandFit(i,no,nf,b2,po,kpo,Bo,Dlo,AxdPot)
% function D_org = Organ_DemandFit(i,no,nf,b2,po,kpo,Bo,Dlo,AxdPot)
%
%   returns Organ demand D_org at cycle i
%
%       no(i,j):number of organs
%       nf(i,j):number of fruits
%       b2:     organ occurence probability
%       po:     organ sink value (0: organ to skip)
%       kpo:    organ reduction 
%       Bo:     organ expansion variation law 
%       Dlo:    organ expansion duration (in cycles) 
%       AxdPot: potential structure
%       
%   Last version 2018/11/27. Main author PdR/MJ. Copyright Cirad-AMAP
%
    
    D_org = 0.0;
    iDlo = i - Dlo;
    if po > 0 && iDlo > 0
        x = iDlo;
        xpo = b2*po;
        if kpo > 0
            xpokpo = xpo * kpo;
            for j = 1 : iDlo % time selected
                if nf(j) > 0
                    D_org = D_org + no(j) * xpokpo * Bo(j,x) * AxdPot(j);
                else
                    D_org = D_org + no(j) * xpo * Bo(j,x) * AxdPot(j);
                end
                x = x - 1;
            end 
        else
            for j = 1 : iDlo % time selected
                D_org = D_org + no(j) * xpo * Bo(j,x) * AxdPot(j);
                x = x - 1;
            end             
        end     
    end
    
end

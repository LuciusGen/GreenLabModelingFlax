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

function [qout] = crunchq_downqo(qo,qref,T)
% function [qout] = crunchq_downqo(qa,qb,T)
%
%       stores the biomass values from the tip, skipping the breaks
% I:    qref(i,j):  leaf (or internode) biomass appeared at cycle i, a age j
% I:    qo(i,j):    organ biomass appeared at cycle i, for organs of age j
% I:    T:          plant age
% O:    qout(i,j)   the reversed qo table where data starts from the tip and skips the breaks;
%

    qout=zeros(T,T);
    for i = 1 : T
        %if sum(qo(:,i)) > 0
            x = T;
            %qs=zeros(T,1);
            for j = T : -1 : 1 % down
                if qref(j,i) > 0 % to crunch only if no internode even if no blade or fruit
                    qout(x,i) = qo(j,i);
                    x = x-1;
                end
            end
            %qout(:,i) = qs(:,1);
        %end
    end
end
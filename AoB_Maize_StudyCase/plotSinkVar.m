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

function plotSinkVar( rows, cols, num, T, mtxo, Dlo, Bo, po, cstyle, ctitle )
% 
% function plotSinkVar( rows, cols, num, T, mtxo, Dlo, Bo, po, cstyle, ctitle )
% 
% Plots Organ Sink variation function over time
%
%   I   rows:       Number of rows in the overall figure
%   I   cols:       Number of cols in the overall figure
%   I   num:        graphic rank (1 to rows*cols)
%   I   txo:        expansion durations table
%   I   mtxo:       max expansion duration
%   I   Dlo:        Expansion proleptic delay
%   I   Bo:         Expansion Law
%   I   po:         sink value
%   I   cstyle:     curve style (for instance -- r   means -- lines in red)
%   I   ctitle:     graphic subtitle
%
%   Last version 2019/02/10 Main author MJ/PdR
%   Copyright Cirad-AMAP
%
    if po > 0
        if mtxo > T
            Tmax = T;
        else
            Tmax = mtxo;
        end
        SinkOrgVar = zeros(Dlo+Tmax,1);
        for i = 1 : Dlo
            SinkOrgVar(i) = 0;
        end
        fsmx = 0;
        for i = 1 : Tmax
            fsval = Bo(T,i)*po;
            if (fsval > fsmx)
                fsmx = fsval;
            end
            SinkOrgVar(i+Dlo) = fsval;
        end
        subplot(rows,cols,num);
        plot(SinkOrgVar, cstyle,'LineWidth',3);
        hold on
        lnSinkOrgVar = log(1+SinkOrgVar);
        plot(lnSinkOrgVar, cstyle,'LineWidth',3);
        axis ([0 Dlo+Tmax+1 0 1.1*(fsmx+0.01)]);
        title(ctitle);
    end

end


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

function plotSingleTableAndDots ( rows, cols, num, tdata1, tdata2, tdoit1, tdoit2, cstyle1, cstyle2, ctitle )
% 
% plotSingleTableAndDots ( rows, cols, num, tdata1, tdata2, tdoit1, tdoit2, cstyle1, cstyle2, ctitle )
% 
% Plots a single table curve(uderstanding that values are given for
% sucessive indexes 1 ... dim(tdata), another one table as markers 
%
%   I   rows:       Number of rows in the overall figure
%   I   cols:       Number of cols in the overall figure
%   I   num:        subfig rank (1:rows*cols), if 0 had to current subfig
%   I   tdata1:     Data Table 1
%   I   tdata2:     Data Table 2
%   I   tdoit1:     Do the job for tdata1 if > 0, skip function else
%   I   tdoit2:     Do the job for tdata2 if > 0, skip function else
%   I   cstyle1:    curve style for tdata1 (for instance -- r   means -- lines in red)
%   I   cstyle2:    curve style for tdata1 (for instance -- g   means markers in green)
%   I   ctitle:     graphic subtitle
%
%   Last version 2019/02/22 Main author MJ
%   Copyright Cirad-AMAP
%
    leg = 0;
    if tdoit1 > 0 || tdoit2 > 0
        if (num > 0)
            subplot(rows,cols,num);
            title (ctitle);
            hold on;
        end
        if tdoit1 > 0
            plot (tdata1, cstyle1,'LineWidth',2,'markersize',3);
            leg = leg + 1;
        end
        if tdoit2 > 0
            plot (tdata2, cstyle2,'markersize',6);
            leg = leg + 10;
        end
        if leg > 10
            legend ('measured','observed');
        else
            if leg > 1
                legend ('observed');
            else
                if leg > 0
                    legend('simulated');
                end
            end
        end

    end

end


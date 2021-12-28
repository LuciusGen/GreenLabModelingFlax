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

function plotSimpleOneTable ( rows, cols, num, tdata, tdoit, cstyle, ctitle )
% 
% function plotSimpleOneTable ( rows, cols, num, tdata, tdoit, cstyle, ctitle )
% 
% Plots a sigle unique table (uderstanding that values are given for
% sucessive indexes 1 ... dim(tdata)
%
%   I   rows:       Number of rows in the overall figure
%   I   cols:       Number of cols in the overall figure
%   I   num:        subfig rank (1:rows*cols), if 0 adds to current subfig
%   I   tdata:      Data Table
%   I   tdoit:      Do the job if > 0, skip function else
%   I   cstyle:     curve style (for instance -- r   means -- lines in red)
%   I   ctitle:     graphic subtitle (skipped if num < 1)
%
%   Last version 2019/02/22 Main author MJ
%   Copyright Cirad-AMAP
%
    if tdoit > 0
        if (num > 0)
            subplot(rows,cols,num);
        else
            hold on;
        end
        plot (tdata, cstyle,'LineWidth',3,'markersize',6);
        title (ctitle);
    end

end


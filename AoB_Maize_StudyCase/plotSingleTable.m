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

function plotSingleTable ( rows, cols, num, tdata, tdoit, tmaxx, tmaxy, cstyle, ctitle )
% 
% function plotSingleTable ( rows, cols, num, tdata, tdoit, tmaxx, tmaxy, cstyle, ctitle )
% 
% Plots a unique table tdata (uderstanding that values are given for
% sucessive indexes 1 ... dim(tdata) if tdoit is > 0. Maxvalues are given
% by tmaxx and tmaxy
%
%   I   rows:       Number of rows in the overall figure
%   I   cols:       Number of cols in the overall figure
%   I   num:        graphic rank (1 to rows*cols)
%   I   tdata:      Data Table
%   I   tdoit:      Do the job if > 0, skip function else
%   I   tmaxx:      max on x axis
%   I   tmaxy:      max on y axis
%   I   cstyle:     curve style (for instance -- r   means -- lines in red)
%   I   ctitle:     graphic subtitle
%
%   Last version 2019/02/22 Main author MJ
%   Copyright Cirad-AMAP
%
    if tdoit > 0
        subplot(rows,cols,num);
        plot (tdata, cstyle,'LineWidth',3,'markersize',6);
        axis ([0 tmaxx 0 tmaxy]);
        title (ctitle);
    end

end


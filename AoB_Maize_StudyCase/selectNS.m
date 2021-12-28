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

% selection organic series
function [qosmt] = selectNS (T, Ti, N, Axdc, qos)
    qosmt = zeros(Ti,1);

    qost  = zeros(Ti,N);
    for s = 1 : N
        for i = 1 : Ti
            x = Ti;
            for j = Ti : -1 : 1
                if Axdc(j,s) > 0
                    qost(x,s) = qos(Ti,j,s);
                    x = x - 1;
                end
            end
        end
    end

    %%%%% average  simulated series topologic at T GC
    x = 0;
    for i = 1 : Ti
        nqosmt = 0;
        qosm = 0.0;
        for s = 1 : N
            qosm  = qosm  + qost(i,s);
            nqosmt = nqosmt + sign(qost(i,s));
        end
        if nqosmt > 0 && qosm > 0
            x = x + 1;
            qosmt(x) = qosm / nqosmt;
        end
    end
   
end


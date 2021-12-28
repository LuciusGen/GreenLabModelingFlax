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


function [AxdPot] = AxDevRythmRatioBernoulli (T, Tm, b, t_w, w0, w1)
% function [AxdPot] = AxDevRythmRatio (T, Tm, tw, w1, kw)
%
%   Theoritical development axis (potential structure) 
%   Computes Development axis on T cycles according to rythm ratio
%
%   I   T:      plant age
%   I   Tm:     plant development end (cycle of) 
%   I   b:      probability to have a phytomer
%   I   t_w:    step for rythm ratio change
%   I   w0:     initial rythm ratio (<= 1)
%   I   w1:     rythm ratio starting from t_w ( <= 1)
%   O   AxdPot(T,1):    The potential development axis
%
%   Stops growth at cyle Tm (Tm may be < T)
%   Rythm ratio is w0 until reaching setp t_w, then rythm is w1 
%   Bernoulli parameter b
%   Result in table AxdPot(T,1) = {0 or b} except for AxdPot(1,1) = 1; 
%
%   Last version 2018/07/10. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

% check rythm ratio value should always be < 1 exiting if not
if (w0 > 1 || w1 > 1)
        mess_err = sprintf('ERROR on Rythm ratio > 1. Values are: w0:%f w:%f\n', w0, w1);
        error_message (100, 1, 'AxDevRythmRatioBernoulli', mess_err);
end

AxdPot = zeros(T,1); % By default no phytomer created 

AxdPot(1,1) = 1; %First phytomer always exists    
state = 1; % Current phytomer state
total = 1.0; %total summarizes all phytomer development success
for t=2:Tm %% T nb of growth cycles (GC), but stops at Tm. (Axdc(Tm+...)=0 )
    %%%% rhytm at low ages (below t_w is w0, after is w1)
        if t < t_w
            total = total + w0;
        else
            total = total + w1;
        end
        nstate = floor (total+0.000001);
        if state ~= nstate
            AxdPot(t,1) = b;
            state = nstate;
        end
end
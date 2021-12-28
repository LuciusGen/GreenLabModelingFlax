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

function [txa,txp,txe,txc,txf,txm,txt,tfa,tfp,tfe,tff,tfm,tft] = OrganDurations (T, tx_o, tfo)
% function [txa,txp,txe,txc,txf,txm,txt,tfa,tfp,tfe,tff,tfm,tft] = OrganDurations (T, tx_o, tfo)
% Sets organ expansion duration and organ functioning duration
%
%   I   T:          Plant age
%   I   tx_o(T,1):  expansion durations
%   I   tfo(1,6):   functioning duration
%   O   txa.. txt:  individual organs expansion duration
%   O   tfa.. tft:  individual organs functioning duration
%
%   Last version 2018/07/05. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

    if  T > 0
        % copy the expansion times for the T cycles and the constant functioning duration 
        txa(:,1) =tx_o(:,1);  % for all cycles from i=1 to i=T
        txp(:,1) =tx_o(:,2);
        txe(:,1) =tx_o(:,3);
        txc(:,1) =tx_o(:,4);
        txf(:,1) =tx_o(:,5);
        txm(:,1) =tx_o(:,6);
        txt(:,1) =tx_o(:,7);
        tfa=tfo(1,1);
        tfp=tfo(1,2);
        tfe=tfo(1,3);
        tff=tfo(1,4);
        tfm=tfo(1,5);
        tft=tfo(1,6);
    end
end
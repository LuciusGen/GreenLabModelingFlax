%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


function [WDAT,WPD,NbMes]= fit_targ_phyt_up(mxTob,Tob,T,qob,qo,WDAT,WPD,NbMes)
% function [WDAT,WPD,NbMes]= fit_targ_phyt_up(mxTob,Tob,T,qob,qo,WDAT,WPD,NbMes)
%  Extracting Phytomer organ biomass from simulation 
%   I    mxTob:             int    Number of observation dates 
%   I    Tob(mxTob):        int    Observation dates 
%   I    T:                 int    Number of cycles 
%   I    qob(T,mxTob):      int    Measurment value indicator
%   I    qo(T,mxTob):       double Measurment value
%   I-0  WDAT(NbMes):       double Measurment value
%   I-O  WPD(NbMes):        double Measurment derivates
%   I-0  NbMes:             int    Number of Measurements
%
%   Last version 2018/11/22. Main author PdR/MJ   Copyright Cirad-AMAP
%
    for i = 1 : mxTob % stop storing after expansion
        if Tob(i) > 0
            ind = (i-1)*T;
            for j = 1 : T
                ind = ind + 1;
                if qob(ind) ~= 999 && qob(ind) > -0.00001
                    WDAT(NbMes) = qo(ind);
                    if WDAT(NbMes) == 0
                        WPD(NbMes) = 0;
                    end
                    NbMes = NbMes + 1;
                end
            end
        end
    end
    
end
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

function [WM,WPD,NbMes]=fit_targetQ_update(...
    pass,comp,T,mxTob,Tob,...
    moTQAt,moTQPt,moTQICt,moTQFt,moTQMt,moTQTt,...
    moqat,moqpt,moqict,moqft,moqmt,...
    TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,...
    qaob,qpob,qicob,qfob,qmob,...
    pa,pp,pe,pc,pf,pm,pt,WDAT,WM,WPD)
%
%  Extracting measurment values from simulation 
%   I    pass:              int    fitting pass (current variable 1:NPAR)
%   I    comp(2):           int    Compartment and Phytomer indicator 
%   I    T:                 int    Number of cycles 
%   I    mxTob:             int    Number of observation dates 
%   I    Tob(mxTob):        int    Observation dates 
%   I    TQo(T)             int    Measurment value indicator
%   I    TQ(T)              double Measurment value
%   I-0  WDAT(NbMes):       double Measurment value
%   I-O  WPD(NbMes):        double Measurment derivates
%   I-0  NbMes:             int    Number of Measurements
%
%   Last version 2018/11/22. Main author PdR/MJ   Copyright Cirad-AMAP
%
    NbMes = 1;
    if comp(1) > 0 % Global
        %[WDAT,NbMes] = fit_targ_comp_up(T,TQAob,moTQAt,WDAT,NbMes);
        for i = 1 : T
            if TQAob(i) ~= 999  &&  TQAob(i) ~= 0 
                WDAT(NbMes) = moTQAt(i);
                NbMes = NbMes + 1;
            end
        end
        % storage of petiol compartment
        if pp > 0
            %[WDAT,NbMes] = fit_targ_comp_up(T,TQPob,moTQPt,WDAT,NbMes);
            for i = 1 : T
                if TQPob(i) ~= 999  &&  TQPob(i) ~= 0 
                    WDAT(NbMes) = moTQPt(i);
                    NbMes = NbMes + 1;
                end
            end
        end
        % storage of internode compartment
        if pe > 0
            %[WDAT,NbMes] = fit_targ_comp_up(T,TQICob,moTQICt,WDAT,NbMes);
            for i = 1 : T
                if TQICob(i) ~= 999  &&  TQICob(i) ~= 0 
                    WDAT(NbMes) = moTQICt(i);
                    NbMes = NbMes + 1;
                end
            end
        end
        % storage of female fruit compartment
        if pf > 0
            %[WDAT,NbMes] = fit_targ_comp_up(T,TQFob,moTQFt,WDAT,NbMes);
            for i = 1 : T
                if TQFob(i) ~= 999  &&  TQFob(i) ~= 0 
                    WDAT(NbMes) = moTQFt(i);
                    NbMes = NbMes + 1;
                end
            end
        end
        % storage of male fruit compartment
        if pm > 0
            %[WDAT,NbMes] = fit_targ_comp_up(T,TQMob,moTQMt,WDAT,NbMes);
            for i = 1 : T
                if TQMob(i) ~= 999  &&  TQMob(i) ~= 0 
                    WDAT(NbMes) = moTQMt(i);
                    NbMes = NbMes + 1;
                end
            end
        end
        % storage of root compartment
        if pt > 0
            %[WDAT,NbMes] = fit_targ_comp_up(T,TQTob,moTQTt,WDAT,NbMes);
            for i = 1 : T
                if TQTob(i) ~= 999  &&  TQTob(i) ~= 0 
                    WDAT(NbMes) = moTQTt(i);
                    NbMes = NbMes + 1;
                end
            end
        end
    end

    if comp(2) > 0 %phyt
        %for storage blade organ (met rank)
        [WDAT,WPD,NbMes] = fit_targ_phyt_up(mxTob,Tob,T,qaob,moqat,WDAT,WPD,NbMes);
        %for storage petiol organ (met rank)
        if pp > 0
            [WDAT,WPD,NbMes] = fit_targ_phyt_up(mxTob,Tob,T,qpob,moqpt,WDAT,WPD,NbMes);
        end
        %for storage internode organ (met rank)
        if pe > 0
            [WDAT,WPD,NbMes] = fit_targ_phyt_up(mxTob,Tob,T,qicob,moqict,WDAT,WPD,NbMes);
        end
        %for storage female fruit organ (met rank)
        if pf > 0
            [WDAT,WPD,NbMes] = fit_targ_phyt_up(mxTob,Tob,T,qfob,moqft,WDAT,WPD,NbMes);
        end
        %for storage male fruit organ (met rank)
        if pm > 0
            [WDAT,WPD,NbMes] = fit_targ_phyt_up(mxTob,Tob,T,qmob,moqmt,WDAT,WPD,NbMes);
        end
    end
    % Update nb of measures
    NbMes = NbMes-1;
    % construction of target for lsqrm
    for i = 1 : NbMes
        WM(i,1+pass) = WDAT(i);
    end
end
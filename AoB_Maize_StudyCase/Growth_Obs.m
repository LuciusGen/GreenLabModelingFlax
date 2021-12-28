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

function [moTQAt,moTQPt,moTQICt,moTQFt,moTQMt,moTQTt,...
    moqat,moqpt,moqict,moqft,moqmt]=...
    Growth_Obs(Lsqr,comp,T,mxTob,Tob,TQAt,TQPt,TQICt,TQFt,TQMt,TQTt,...
    qat,qpt,qict,qft,qmt,TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob,...
   pp,pe,pc,pf,pm)
%
% function [moTQAt,moTQPt,moTQICt,moTQFt,moTQMt,moTQTt,...
%    moqat,moqpt,moqict,moqft,moqmt]=...
%    Growth_Obs(Lsqr,comp,T,mxTob,Tob,TQAt,TQPt,TQICt,TQFt,TQMt,TQTt,...
%    qat,qpt,qict,qft,qmt,TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob,...
%    pp,pe,pc,pf,pm)
%
%   I   Lsqr:           int     Fitting method (0:none,1:LSQR)
%   I   comp(2):        int     Global compartement on/off, phytomer compartment on/off
%   I   T:              int     Number of cycles
%   I   mxTob:          int     Number of Observation dates
%   I   Tob(mxTob)      int     Observation dates
%   I   TQAt(T)         double  Total Leaf Biomass at cycle T
%   I   TQPt(T)         double  Total Petiol Biomass at cycle T
%   I   TQICt(T)        double  Total Ring Biomass at cycle T
%   I   TQFt(T)         double  Total Female Fruit Biomass at cycle T
%   I   TQMt(T)         double  Total Male Fruit Biomass at cycle T
%   I   TQTt(T)         double  Total Root Biomass at cycle T
%   O   moqat(T,mxTob): double  Leaf biomass at observation dates 
%   ...... Not finished
%
%   Last version 2018/11/22. Main author PdR/MJ. Copyright Cirad-AMAP
%

    moTQAt = zeros(T,1);
    moTQTt = zeros(T,1);

    moqat = zeros(T,mxTob);
    moqatdata = moqat;

    if pp > 0
        moTQPt = zeros(T,1);
        moqpt = moqat;
        moqptdata = moqat;
    else
        moTQPt = 0;
        moqpt = 0;
        moqptdata = 0;
    end
    if pe > 0
        moTQICt = zeros(T,1);
        moqict = moqat;
        moqictdata = moqict;        
    else
        moTQICt = 0;
        moqict = 0;
        moqictdata = 0;    
    end    
    if pf > 0
        moTQFt = zeros(T,1);
        moqft = moqat;
        moqftdata = moqat;
    else
        moTQFt = 0;
        moqft = 0;
        moqftdata = 0;
    end
    if pm > 0
        moTQMt = zeros(T,1);
        moqmt = moqat;
        moqmtdata = moqat;
    else
        moTQMt = 0;
        moqmt = 0;
        moqmtdata = 0;
    end
    if comp(1) > 0
        Nob = 1;
        i = 1; % conditionning global biomass
        while i <= T
            if i == abs(Tob(Nob))
                moTQAt(i) = TQAt(i);
                if pp > 0
                    moTQPt(i) = TQPt(i);
                end
                if pe > 0
                    moTQICt(i) = TQICt(i);
                end
                if pf > 0
                    moTQFt(i) = TQFt(i);
                end
                if pm > 0
                    moTQMt(i) = TQMt(i);
                end
                moTQTt(i) = TQTt(i);
                if TQAob(i,1) == 999
                    moTQAt(i) = 999;
                end
                if pp > 0
                    if TQPob(i,1) == 999
                        moTQPt(i) = 999;
                    end
                end
                if pe > 0
                    if TQICob(i,1) == 999
                        moTQICt(i) = 999;
                    end
                end
                if pf > 0
                    if TQFob(i,1) == 999
                        moTQFt(i) = 999;
                    end
                end
                if pm > 0
                    if TQMob(i,1) == 999
                        moTQMt(i) = 999;
                    end
                end
                if TQTob(i,1) == 999
                    moTQTt(i) = 999;
                end
                if Nob == size(Tob)
                    i = T+1;
                else
                    Nob = Nob + 1;
                end
            end
            i = i + 1;
        end
    end
    
    if comp(2) > 0
        Nob = 1;
        for i = 1 : T %
            if i == Tob(Nob)
                j_ob1 = (Nob-1)*T + 1;
                j_ob2 = Nob*T;
                j_i = (i-1)*T + 1;
                for j_ob = j_ob1 : j_ob2                
                    moqat(j_ob) = qat(j_i);
                    moqatdata(j_ob) = moqat(j_ob);
                    if pp > 0
                        moqpt(j_ob) = qpt(j_i);
                        moqptdata(j_ob) = moqpt(j_ob);
                    end
                    if pe > 0
                        moqict(j_ob) = qict(j_i);%pith +layer
                        moqictdata(j_ob) = moqict(j_ob);
                    end
                    if pf > 0
                        moqft(j_ob) = qft(j_i);
                        moqftdata(j_ob) = moqft(j_ob);
                    end
                    if pm > 0
                        moqmt(j_ob) = qmt(j_i);
                        moqmtdata(j_ob) = moqmt(j_ob);
                    end
                    %%if Lsqr == 1
                        if qaob(j_ob) == 999
                            moqatdata(j_ob) = 999;
                        end
                        if qaob(j_ob) == -0.0001
                            moqat(j_ob) = -0.0001;
                            moqatdata(j_ob) = -0.0001;
                        end
                        if qaob(j_ob) == -1
                            moqat(j_ob) = -1;
                            moqatdata(j_ob) = -1;
                        end
                        if pp > 0
                            if qpob(j_ob) == 999
                                moqptdata(j_ob) = 999;
                            end
                            if qpob(j_ob) == -0.0001
                                moqpt(j_ob) = -0.0001;
                                moqptdata(j_ob) = -0.0001;
                            end
                            if qpob(j_ob) == -1
                                moqpt(j_ob) = -1;
                                moqptdata(j_ob) = -1;
                            end
                        end
                        if (pe+pc) > 0
                            if qicob(j_ob) == 999
                                moqictdata(j_ob) = 999;
                            end
                            if qicob(j_ob) == -0.0001
                                moqict(j_ob) = -0.0001;
                                moqictdata(j_ob) = -0.0001;
                            end
                            if qicob (j_ob) == -1
                                moqict(j_ob) = -0.0001;
                                moqictdata(j_ob) = -0.0001;
                            end
                        end
                        if pf > 0
                            if qfob(j_ob) == 999
                                moqftdata(j_ob) = 999;
                            end
                            if qfob(j_ob) == -0.0001
                                moqft(j_ob) = -0.0001;
                                moqftdata(j_ob) = -0.0001;
                            end
                            if qfob(j_ob) == -1
                                moqftdata(j_ob) = -1;
                            end
                        end
                        if pm >0
                            if qmob(j_ob) == 999
                                moqmtdata(j_ob) = 999;
                            end
                            if qmob(j_ob) == -0.0001
                                moqmtdata(j_ob) = -0.0001;
                            end
                            if qmob(j_ob) == -1
                                moqmtdata(j_ob) = -1;
                            end
                        end
                    %%end % Lsqr
                    j_i = j_i + 1;
                end
            end % if i == abs(Tob(1,x1)) &  Tob(1,x1) >0
            if i == abs(Tob(Nob)) && Nob < mxTob
                Nob = Nob + 1;
            end
        end % i
    end

end
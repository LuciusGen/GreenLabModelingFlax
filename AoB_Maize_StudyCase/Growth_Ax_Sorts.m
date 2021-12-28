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

function [qas,qps,qics,qfs,qms] = Growth_Ax_Sorts(Tmax,N,Axdc,nf,nm,pp,pf,pm,qav,qpv,qicv,qfv,qmv)
%function [qas,qps,qics,qfs,qms] = Growth_Ax_Sorts(Tmax,N,Axdc,nf,nm,pp,pf,pm,qav,qpv,qicv,qfv,qmv)  
%   I   Tmax:       int     Number of cycles (T)
%   I   N:          int     Number of stochastic repetitions
%   I   Axdc(T,N)   int     Axis of devlopment
%   I   nf(T,N)     int     Number of female fruits per cycle
%   I   nm(T,N)     int     Number of male fruits per cycle
%   I   pp          int     petiole used or not
%   I   pf          int     female fruit used or not
%   I   pm          int     male fruit used or not
%   I   qav(T,T,N)  double  leaf biomass
%   I   qpv(T,T,N)  double  petiol biomass
%   I   qicv(T,T,N) double  ring biomass
%   I   qfv(T,T,N)  double  female fruit biomass
%   I   qmv(T,T,N)  double  male fruit biomass
%   O   qas(T,T)    double  average leaf biomass (crunched)
%   O   qps(T,T)    double  average petiol biomass (crunched)
%   O   qics(T,T)   double  average ring biomass (crunched)
%   O   qfs(T,T)    double  average female fruit biomass (crunched)
%   O   qms(T,T)    double  average male fruit biomass (crunched)
%      
%   Last version 2019/01/23. Main author PdR/MJ. Copyright Cirad-AMAP
%

    qas = zeros(Tmax,Tmax);
    qics = zeros(Tmax,Tmax);
    nis = zeros(Tmax,Tmax);
    
    if pp > 0
        qps = zeros(Tmax,Tmax);
    else
        qps = 0;
    end
    if pf > 0
        qfs = zeros(Tmax,Tmax);
        nfs = zeros(Tmax,Tmax);
    else
        qfs = 0;
        nfs = 0;
    end
    if pm > 0
        qms = zeros(Tmax,Tmax);
        nms = zeros(Tmax,Tmax);
    else
        qms = 0;
        nms = 0;
    end
    
    
    for s = 1 : N
        st = (s-1)*Tmax;
        sind = (st - 1) * Tmax;
        
        for i = 1 : Tmax % for all age
            is = sind + i * Tmax;
            % j1is =  (st - 1) * Tmax + i * Tmax + i;
            j1is = (i-1) * Tmax + i;
            for j = i : -1 : 1 % exploration main structure
                js = st + j;
                ijs = sind + j * Tmax + i;
                %%% axis without pauses  so recuperate the AXD of the item!
                % Lo = sum(Axdc(j+1:i,s)); % we know the branch topo with so!
                % j1is = sind + i * Tmax + i - Lo;  
                %%% full axis with pause for shrubs or tree if lenght & diameter
                % blade
                qas(j1is) = qas(j1is) + qav(ijs);
                % internode
                qics(j1is) = qics(j1is) + qicv(ijs);
                nis(j1is) = nis(j1is) + Axdc(js);
                % blade
                if pp > 0 
                    qps(j1is) = qps(j1is) + qpv(ijs);
                end
                % fruits
                if pf > 0
                    qfs(j1is) = qfs(j1is) + qfv(ijs);
                    nfs(j1is) = nfs(j1is) + Axdc(js) * sign(nf(js));
                end
                if pm > 0
                    qms(j1is) = qms(j1is) + qmv(ijs);
                    nms(j1is) = nms(j1is) + Axdc(js) * sign(nm(js));
                end
                j1is = j1is - Axdc(js);
            end %j 
        end %i
        
    end %s

    % statistics
    onenxs = ones(Tmax,Tmax);
    
    Sgnnis = sign(nis);
    tnis = nis + abs(onenxs - Sgnnis); % so no more 0 for dicviding
    % diam average
    qas = qas./(tnis);
    qics = qics./(tnis);
    if pp > 0
        qps = qps./(tnis);
    end
    if pf > 0
        Sgnnfs = sign(nfs);
        nfs = nfs + abs(onenxs - Sgnnfs); % so no more 0 for dicviding
        qfs = qfs./(nfs);
    end
    if pm > 0
        Sgnnms = sign(nms);
        nms = nms + abs(onenxs - Sgnnms); % so no more 0 for dicviding
        qms = qms./(nms);
    end

    % all tips of axis on bottom for multifitting
    qtemp = qics;
    [qas] = crunchq_downqo(qas,nis,Tmax);
    if pp > 0
        [qps] = crunchq_downqo(qps,nis,Tmax);
    end
    [qics] = crunchq_downqo(qics,nis,Tmax);
    if pf > 0
        [qfs] = crunchq_downqo(qfs,nis,Tmax);
    end
    if pm > 0
        [qms] = crunchq_downqo(qms,nis,Tmax);
    end

end


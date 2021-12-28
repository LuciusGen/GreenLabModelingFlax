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

function [qas,qps,qics,qfs,qms] = Growth_Ax_Sorta(T,Axdc,PBN,MiPBN,MxPBN,nf,nm,pp,pi,pf,pm,qat,qpt,qict,qft,qmt)
%
% function [qas,qps,qics,qfs,qms] = Growth_Ax_Sorta(T,Axdc,PBN,MiPBN,MxPBN,nf,nm,pp,pi,pf,pm,qat,qpt,qict,qft,qmt)
%   Alignes and crunches organ biomass production   
%   I   T:          int     Number of cycles
%   I   Axdc(T)     int     Axis of devlopment
%   I   PBN(T,T)    double  Binomial law (filled with parameter b)
%   I   MiPBN(T)    double  Min cycle value for non zero value in PBN (:,T)
%   I   MxPBN(T)    double  Max cycle value for non zero value in PBN (:,T)
%   I   nf(T)       int     Number of female fruits per cycle
%   I   nm(T)       int     Number of male fruits per cycle
%   I   pp          int     petiole used or not
%   I   pi          int     ring used or not
%   I   pf          int     female fruit used or not
%   I   pm          int     male fruit used or not
%   I   qat(T,T)    double  leaf biomass
%   I   qpt(T,T)    double  petiol biomass
%   I   qict(T,T)   double  ring biomass
%   I   qft(T,T)    double  female fruit biomass
%   I   qmt(T,T)    double  male fruit biomass
%   O   qas(T,T)    double  leaf biomass (crunched)
%   O   qps(T,T)    double  petiol biomass (crunched)
%   O   qics(T,T)   double  ring biomass (crunched)
%   O   qfs(T,T)    double  female fruit biomass (crunched)
%   O   qms(T,T)    double  male fruit biomass (crunched)
%      
%   Last version 2018/11/23. Main author PdR/MJ. Copyright Cirad-AMAP
%
    qas = zeros(T,T);
    nis = zeros(T,T);
    
    if pp > 0
        qps = zeros(T,T);
    else
        qps = 0;
    end
    if pi > 0
        qics = zeros(T,T);
    else
        qics = 0;
    end
    if pf > 0
        qfs = zeros(T,T);
        nfs = zeros(T,T);
    else
        qfs = 0;
        nfs = 0;
    end
    if pm > 0
        qms = zeros(T,T);
        nms = zeros(T,T);
    else
        qms = 0;
        nms = 0;
    end

    for i = 1 : T % for all age
        %iT = (i-1)*T + i;
        %Lo = 0;
        j1i = (i-1)*T + i;
        for j = i : -1 : 1 % exploration main structure
            %%Lo = sum(Axdc(j+1:i));
            %j1i = iT - Lo;
            %Lo = Lo + Axdc(j);
            %%Lo = Lo + Axdc(j+1);
            ij = (j-1)*T + i;
            qas(j1i) = qas(j1i) + qat(ij);
            nis(j1i) = Axdc(j);
            if pp > 0
                qps(j1i) = qps(j1i) + qpt(ij);
            end
            if pi > 0
                qics(j1i) = qics(j1i) + qict(ij);
            end
            if pf > 0
                qfs(j1i) = qfs(j1i) + qft(ij);
                nfs(j1i) = Axdc(j) * sign(nf(j));
            end
            if pm > 0
                qms(j1i) = qms(j1i) + qmt(ij);
                nms(j1i) = Axdc(j) * sign(nm(j));
            end
            j1i = j1i - Axdc(j);
        end %j
    end %i

    % statistics for GL
    one_xs = ones(T,T);
    nis = nis + abs(one_xs - sign(nis)); % so no more 0 for dividing;
    % average
    qas = qas./(nis);
    if pp > 0
        qps = qps./(nis);
    end
    if pi > 0
        qics = qics./(nis);
    end
    if pf > 0
        nfs = nfs +  abs(one_xs - sign(nfs)); % so no more 0 for dividing
        qfs = qfs./(nfs);
    end
    if pm > 0
        qms = qms./(nis);
    end

% % To have the tip case of proba for rank according to negative binomial law
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sort phytomer and lateralstruct top down
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    [qas,qps,qics,qfs,qms] = Growth_Ax_PhytTopdown(T,PBN,MiPBN,MxPBN,qas,qps,qics,qfs,qms,pp,pi,pf,pm);


    if pi > 0
        qtemp = qics;
    else
        qtemp = qas;
    end
    [qas] = crunchq_downqo(qas,qtemp,T);
    if pp > 0
        [qps] = crunchq_downqo(qps,qtemp,T);
    end
    if pi > 0
        [qics] = crunchq_downqo(qics,qtemp,T);
    end
    if pf > 0
        [qfs] = crunchq_downqo(qfs,qtemp,T);
    end
    if pm > 0
        [qms] = crunchq_downqo(qms,qtemp,T);
    end


    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [qas,qps,qics,qfs,qms] = Growth_Ax_PhytTopdown(T,PBN,MiPBN,MxPBN,qax,qpx,qicx,qfx,qmx,pp,pi,pf,pm)
%
% function [qas,qps,qics,qfs,qms] = Growth_axPhytTopdown(T,PBN,MiPBN,MxPBN,qox,qax,qpx,qicx,qfx,qmx,pp,pi,pf,pm)
%
%   Alignes and crunches organ biomass production   
%   I   T:          int     Number of cycles
%   I   PBN(T,T)    double  Binomial law (filled with parameter b)
%   I   MiPBN(T)    double  Min cycle value for non zero value in PBN (:,T)
%   I   MxPBN(T)    double  Max cycle value for non zero value in PBN (:,T)
%   I   pp          int     petiole used or not
%   I   pi          int     ring used or not
%   I   pf          int     female fruit used or not
%   I   pm          int     male fruit used or not
%   I-O   qas(T,T)  double  leaf biomass (output is crunched)
%   I-O   qps(T,T)  double  petiol biomass (output is crunched)
%   I-O   qics(T,T) double  ring biomass (output is crunched)
%   I-O   qfs(T,T)  double  female fruit biomass (output is crunched)
%   I-O   qms(T,T)  double  male fruit biomass (output is crunched)
%      
%   Last version 2018/11/23. Main author PdR/MJ. Copyright Cirad-AMAP
%
%  
    qas=zeros(T,T);
    qps=zeros(T,T);
    qics=zeros(T,T);
    qfs=zeros(T,T);
    qms=zeros(T,T);
    %SPBN=zeros(T,T);
    
    if pi > 0
        qref = qicx;
    else
        qref = qax;
    end
    
    
    iT = 2;
    for i = 1 : T
        for k = 1 : i % because last internode has no struct!
            kmi = max(MiPBN(k),k);
            kma = min(MxPBN(k),i);
            SPBN_ki = 0.0;        
            ikki = iT - k;
            qas_ikki = 0;
            qps_ikki = 0;
            qics_ikki = 0;
            qfs_ikki = 0;
            qms_ikki = 0; 
            if kma >= kmi
                 ikji = iT - kmi;         
                 for  j = kmi : kma
                    if qref(ikji) > 0 %%%% qis cannot exist if qix =0
                        PBN_kj = PBN(k,j);
                        if PBN_kj > 0
                            qas_ikki = qas_ikki + PBN_kj * qax(ikji);
                            if pp > 0
                                qps_ikki = qps_ikki + PBN_kj * qpx(ikji);
                            end
                            if pi > 0
                                qics_ikki = qics_ikki + PBN_kj * qicx(ikji);
                            end
                            if pf > 0
                                qfs_ikki = qfs_ikki + PBN_kj * qfx(ikji);
                            end
                            if pm > 0
                                qms_ikki = qms_ikki + PBN_kj * qmx(ikji);
                            end
                            SPBN_ki = SPBN_ki + PBN_kj;
                        end
                    end
                    ikji = ikji - 1;
                end % j
            end

            if SPBN_ki > 0 % if the branch  is limited SPBN can be <1
                qas(ikki) = qas_ikki / SPBN_ki;
                if pp > 0
                    qps(ikki) = qps_ikki / SPBN_ki;
                end
                if pi > 0
                    qics(ikki) = qics_ikki / SPBN_ki;
                end
                if pf > 0
                    qfs(ikki) = qfs_ikki / SPBN_ki;
                end
                if pm > 0
                    qms(ikki) = qms_ikki / SPBN_ki;                  
                end

            end
        end % k
        iT = iT + T + 1; 
    end % i    


end
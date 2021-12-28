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

function [Ds,Dcs,Dsm,SLas] = DemandS(T,Axdc,N,na,ni,nf,nm,...
    tfa,pa,pp,pe,pc,pf,pm,pt,pq,kpa,kpe,...
    Ba,Bp,Bi,Bc,Bf,Bm,Bt,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt)
%
% function [Ds,Dcs,Dsm,SLas] 
%   = DemandS (T,Axdc,N,na,ni,nf,nm,tfa,pa,pp,pe,pc,pf,pm,pt,pq,kpa,kpe,...
%               Ba,Bp,Bi,Bc,Bf,Bm,Bt,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt)
%
% Compute plant demand
%
%   I   T:          Plant age
%   I   Axdc(T,N):  devlopment axis for N schocastic stems
%   I   N:          number of stochastic stems
%   I   na(T,N):    number of leaves 
%   I   ni(T,N):    number of internodes
%   I   nf(T,N):    number of female fruits
%   I   nm(T,N):    number of male fruits
%   I   tfa:        leaf functioning duration (in cycles)
%   I   pa,pp,pe,pc,pf,pm,pt,pq : organ sinks 
%                   (leaf, petiol, internode, ring, fruit (f&m), root,
%                   common pool
%   I   Ba, ...Bt:  organ sink variations (T,Dlxxx)
%   I   Dla, ..Dlt: organ sink variation period (expansion time)
%
%   O   Ds(T,N):    plant demand
%   O   Dcs(T,N):   plant secondary growth demand
%   O   SLas(T,T,N):number of fleaves seen at cycle i from phytomer appeared at age i on stochastic stem s
%   O   Dsm(T,1):   average plant demand
%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute plant demand:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ds = zeros(T,N);
    Dcs = zeros(T,N);
    Dsm = zeros(T,1); 
    SLas = zeros(T,T,N);
        

    % simulation N plants
    for i = 1 : T % T cycles
        nDsm = 0;
        Dts_i = 0.0;
        if i > Dlt
            Dts_i = pt * Bt(1,i-Dlt);
        end
        for s = 1 : N 
            
            % leaf demand
            Das_is = Organ_DemandS(i,na,nf,pa,kpa,Ba,Dla,Axdc,s);    
            % petiol demand  (same parameter for leaf except pp)
            Dps_is = Organ_DemandS(i,na,nf,pp,kpa,Bp,Dlp,Axdc,s);               
            %internode demand
            Dis_is = Organ_DemandS(i,ni,nf,pe,kpe,Bi,Dli,Axdc,s);            
            %fruit female demand
            Dfs_is = Organ_DemandS(i,nf,nf,pf,1,Bf,Dlf,Axdc,s);            
            %fruit male demand
            Dms_is = Organ_DemandS(i,nm,nf,pm,1,Bm,Dlm,Axdc,s);
            
            %ring_demand & Leaf seen
            Las_is = zeros(T,1);
            if i < tfa
                for j =1:i
                    Dcs(i,s) = Dcs(i,s) + na(j,s) * pc * Axdc(j,s);
                    Las_is(j) = na(j,s) * Axdc(j,s);
                end
            else
                for j =i-tfa+1:i
                    Dcs(i,s) = Dcs(i,s)+ na(j,s)* pc * Axdc(j,s);
                    Las_is(j) = na(j,s) * Axdc(j,s); % nb of leaves/phytomer
                end
            end
            if i < Dlc
                Dcs(i,s) = 0;
            end
            
            for j =1:i
                SLas(i,j,s) = sum(Las_is(j:i));% sum of leaf seen from rank of phytomer
            end
            
            % total demand (+tape root + pool)
            Ds(i,s) = Das_is + Dps_is + Dis_is + Dfs_is + Dms_is + Dcs(i,s)+ Dts_i + pq;
            
            % sum for average demand simulation
            Dsm(i,1) = Dsm(i,1) + Ds(i,s);
            nDsm = nDsm + sign(Dsm(i,1));
        end

        % average demand simulation
        if  nDsm > 0
             Dsm(i,1) = Dsm(i,1) / nDsm;
        end
    end 


end


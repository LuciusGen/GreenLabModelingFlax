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

function [E,DH] = climate (Krnd, Nrnd, Eo, Ec, T, modE, cor, wE, bE, Lmx, Lmn, modH, pH20, dH20)
% function [E,DH] = climate(Eo,Ec,T,modE,cor,wE,bE,Lmx,Lmn,modH,pH20,dH20)
% 
%   Computes Environmental coefficient and optional water resource
%   E(1:T): Greenlab environmental coefficient. Default is value 1
%   DH(1:T): Water supply default is value 0
%
%   modE: Environmental modes 
%       modE=1 => E(1:T) is a consstant  = Eo
%       modE=2 => E(1:T) is random with autocorrelation , strating from E(1)=Ec
%               then E(i) = cor * E(i-1) + (1-cor) * (Lmn + random *(Lmx-Lmn));
%       modE=3 => E(1:T) is periodic between values 0 and Ec with rhytm wE and
%           probaility bE (similar to development rhythm w with binomial law b)
%
%   modH : water supply mode and frequency
%       modH=0  => No irrigation DH(1:T) = 0
%       modH=-1 => randow irrigation DH(1:T) = random*dH20 (with randow < pH20)
%       modH >0 => regular irrigation DH(1:T) = dH20 * (1 - sign(mod(t,modH)))
%
%
%   Last version 2018/07/05. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

E=ones(T,1);
DH=zeros(T,1);
if modE ==1
    E(1:T,1)=Eo;
end
if modE ==2 %signal with auto correl r
    %E(1,1)=Ec; Changed MJ
    E(1,1)=1;
    for t = 2:T
        Nrnd = Krnd*Nrnd - floor(Krnd*Nrnd);
        E(t,1) = cor * E(t-1,1)+(1-cor) * (Lmn + Nrnd*(Lmx-Lmn));
    end
    %E(2:T,1)=Ec*E(2:T,1);  Changed MJ
    E = Ec * E;
end

if modE == 3 % periodic signal    
    status = 1;
    E(1,1) = Ec;
    dim = 1;

    for t=2:T %% T nb of growth cycles (GC)
        %%%% Rhythme ratio 0.5 ->( 1 0 1 0 1 0 ]common for all axis

        Nrnd = Krnd*Nrnd - floor(Krnd*Nrnd);
%         if Nrnd < bE && E(t,1) == Ec
%             E(t,1)=0;
%         end
        
        dim = dim + wE +0.000001;
        nstatus = floor (dim);
        if status == nstatus
            E(t,1)=0;
        else
            E(t,1)=Ec;
            if Nrnd < bE
                E(t,1)=0;
            end 
        end

    end
end


if abs(modH) > 0
    Nrnd = 0.77653479197 * 11;
    for t= 1:T  
        Nrnd = Krnd * Nrnd - floor(Krnd * Nrnd);    
        if modH == -1 % stochastic case
            if Nrnd < pH20
                DH(t,1) = dH20*Nrnd; % stochastic irrigation
            else
                DH(t,1) = 0;
            end
        else
            % modH donne la frequence des irrigations
            DH(t,1) = dH20 * (1- sign(mod(t,modH))); % regular irrigation case
        end
    end
end
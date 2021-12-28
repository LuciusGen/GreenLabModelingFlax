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

function [tfo,txo,txo_n,txo_ctl,txo_x,...
    pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,...
    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
    Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1] = Load_ParamOrgans (param)
%
% function [tfo,txo,txo_n,txo_ctl,txo_x,...
%    pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,...
%    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
%    Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1] = Load_ParamOrgans (param)
%
%   O   tfo,txo,txo_n,txo_ctl,txo_x:    Organ expansion duration parameters
%   O   pa,pp,pe,pc,pf,pm,pt,pq:        Organ sink functions
%   O   kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,x2p:    Organ sink corrections
%   O   Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2:   Beta law sink function parameters 
%   O   Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt:    Beta law sink function delays
%   O   e,b1,a1,f1:                     Leaf, internode and fruit allometry parameters
%   I   param:      the parameter table
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Last version 2018/05/21. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

    %organ fct time organ exansion time (a p i c f m t)
    tfo=param(3,1:8);
    txo=param(4,1:7);
    %parameter control for expansion
    txo_n = param(5,1);
    txo_ctl(1,1:txo_n) = param(5,2:1+txo_n);
    txo_x(1:4,1:9) = param(6:9,1:9);
    
    % sink leaf   sink intern   sink fruit    sink ring    sink taperoot  sink pool
    
    pa=param(10,1); 
    pp=param(10,2);
    pe=param(10,3);
    pc=param(10,4);
    pf=param(10,5); 
    pm=param(10,6);
    pt=param(10,7);
    pq=param(10,8);
    
    
    if pa < 0.00001
        pa=1;
    end
    
    
    if pa ~= 1
      
        pp=pp/pa;
        pe=pe/pa;
        pc=pc/pa;
        pf=pf/pa;
        pm=pm/pa;
        pt=pt/pa;
        pq=pq/pa;
        pa = 1;
    end
    
    
    
    
    
    
    
    %correction_for_sink
    kpc=param(11,1);
    kpa=param(11,2);
    kpe=param(11,3);
    mna=param(11,4);
    ca=param(11,5);
    mnp=param(11,6);
    cp=param(11,7);
    mni=param(11,8);
    ci=param(11,9);% no mnf and mnm...
    %x2p=param(12,1:9);
    
    %parameter_sink_variation(beta_law)&expansion_delay
    Ba1=param(13,1);Bp1=param(13,2);Bi1=param(13,3);Bc1=param(13,4);
    Bf1=param(13,5);Bm1=param(13,6);Bt1=param(13,7);
    
    Ba2=param(14,1);Bp2=param(14,2);Bi2=param(14,3);Bc2=param(14,4);
    Bf2=param(14,5);Bm2=param(14,6);Bt2=param(14,7);
    
    Dla=param(15,1);Dlp=param(15,2);Dli=param(15,3);Dlc=param(15,4);
    Dlf=param(15,5);Dlm=param(15,6);Dlt=param(15,7);

    %D/L allom leaf allom intern  allom fruit
    e=param(16,1);
    b1=param(16,2);
    a1=param(16,3);
    f1=param(16,4);


end


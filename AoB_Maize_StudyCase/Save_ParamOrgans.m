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

function [param] = Save_ParamOrgans (param,tfo,txo,txo_n,txo_ctl,txo_x,...
    pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,...
    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
    Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1)
%
% function [param] = Save_ParamOrgans (param,tfo,txo,txo_n,txo_ctl,txo_x,...
%    pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,...
%    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
%    Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1)
%
%   I   tfo,txo,txo_n,txo_ctl,txo_x:    Organ expansion duration parameters
%   I   pa,pp,pe,pc,pf,pm,pt,pq:        Organ sink functions
%   I   kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,x2p:    Organ sink corrections
%   I   Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2:   Beta law sink function parameters 
%   I   Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt:    Beta law sink function delays
%   I   e,b1,a1,f1:                     Leaf, internode and fruit allometry parameters
%   I/O param:      the parameter table
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    if length(param) > 1

        param(3,1:8) = tfo;
        param(4,1:7) = txo;
        param(5,1) = txo_n;
        param(5,2:1+txo_n) = txo_ctl(1,1:txo_n);
        param(6:9,1:9) = txo_x(1:4,1:9);
        
        param(10,1)=pa;param(10,2)=pp;param(10,3)=pe;param(10,4)=pc;
        param(10,5)=pf;param(10,6)=pm;param(10,7)=pt;param(10,8)=pq;
        
        param(11,1)=kpc;param(11,2)=kpa;param(11,3)=kpe;param(11,4)=mna;param(11,5)=ca;
        param(11,6)=mnp;param(11,7)=cp;param(11,8)=mni;param(11,9)=ci;

        param(13,1)=Ba1;param(13,2)=Bp1;param(13,3)=Bi1;
        param(13,4)=Bc1;param(13,5)=Bf1;param(13,6)=Bm1;param(13,7)=Bt1;
        param(14,1)=Ba2;param(14,2)=Bp2;param(14,3)=Bi2;
        param(14,4)=Bc2;param(14,5)=Bf2;param(14,6)=Bm2;param(14,7)=Bt2;
        param(15,1)=Dla;param(15,2)=Dlp;param(15,3)=Dli;
        param(15,4)=Dlc;param(15,5)=Dlf;param(15,6)=Dlm;param(15,7)=Dlt;    
        
        param(16,1)=e; param(16,2)=b1; param(16,3)=a1; param(16,4)=f1;
    else
    end
    
end
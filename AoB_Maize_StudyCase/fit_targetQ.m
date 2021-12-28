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

function [WM,WPD,WO,x] = fit_targetQ(comp,T,mxTob,Tob,TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,...
    qaob,qpob,qicob,qfob,qmob,pa,pp,pe,pf,pm,pt)
 WM=zeros(1,1); 
 WPD=zeros(1,1);
 WO=zeros(1,1);
x = 1;
xregM = x; 
xregP = x;
%%%%%%%%%%%%%%%%%%%%%
%mean of compartments
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To store total Biomass Q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if comp(1) > 0 % global
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % To store Blade compartment TQA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQAob,WM,WPD,WO,1,xregM,xregP,x);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % To store Petiol compartment Qp
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if pp >0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQPob,WM,WPD,WO,2,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % To store internode compartment Qi
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if pe >0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQICob,WM,WPD,WO,3,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % To store female fruit compartment Qf
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if pf > 0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQFob,WM,WPD,WO,4,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % To store male fruit compartment Qm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if pm > 0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQMob,WM,WPD,WO,5,xregM,xregP,x);
    end
end %comp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To store root compartment mean and variance Qr vQr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pt >0
    [WM,WPD,WO,xregM,xregP,x]=fit_targ_comp(T,TQTob,WM,WPD,WO,6,xregM,xregP,x);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To store phytomers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if comp(1,2) >0 % Phytomer
    %%%%%%%%%%%%%%%%%%%%%%%%
    % case of blades qb
    %%%%%%%%%%%%%%%%%%%%%%%%
    [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qaob,WM,WPD,WO,11,xregM,xregP,x);
    %%%%%%%%%%%%%%%%%%%%%%%%
    % case of petiols qp
    %%%%%%%%%%%%%%%%%%%%%%%%
    if pp >0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qpob,WM,WPD,WO,12,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    % case of internodes qi
    %%%%%%%%%%%%%%%%%%%%%%%%
    if pe >0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qicob,WM,WPD,WO,13,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%
    % case of female fruits
    %%%%%%%%%%%%%%%%%%%%
    if  pf > 0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qfob,WM,WPD,WO,14,xregM,xregP,x);
    end
    %%%%%%%%%%%%%%%%%%%%
    % case of male fruits
    %%%%%%%%%%%%%%%%%%%%
    if pm > 0
        [WM,WPD,WO,xregM,xregP,x]=fit_targ_phyt(T,mxTob,Tob,qmob,WM,WPD,WO,15,xregM,xregP,x);
    end
end
x=x-1;

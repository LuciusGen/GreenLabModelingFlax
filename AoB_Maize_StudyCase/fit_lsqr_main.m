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


% function [WDPAR,WDD,DY] = fit_lsqr_main(NbMes,npar,WM,WEPAR,WPD)
%  LSQR kernel computes derivates up to global error
%   I    NbMes:             int    Number of measurments 
%   I    npar:              int    Number of parameters to fit
%   I    WM(NbMes,npar)     double Measurments values
%   I    WEPAR(npar):       double Increment for numerical derivative
%   I    WPD(NbMes):        double Measurments variance
%   O    WDPAR(npar):       double Parameter derivate
%   O    WDD(npar,npar):    double Inverted Variance parameter Mattrix
%   O    DY:                double Cumulated Error 
%
%   Last version 2018/11/22. Main author PdR/MJ. Copyright Cirad-AMAP
%   Last version 2018/5/21. Main author PdR/MJ. Copyright Cirad-AMAP

function [WDPAR,WDD,DY] = fit_lsqr_main(NbMes,npar,WM,WEPAR,WPD)

    WDPAR = zeros(npar,1);
    WTEMP = zeros(npar,1);
    WADER = zeros(NbMes,npar);
    WPADER = zeros(npar,npar);
    WYDIST = zeros(NbMes,1);

    DY = 0;
    for im = 1 : NbMes
        % derivatives computation
        %WADER : La matrice M
        %WEPAR : DELTA P
        for ip = 1 : npar
            WADER(im,ip) = (WM(im,ip+2) - WM(im,2)) / WEPAR(ip,1);
        end
        % computing distance from target
        %pour calculer l'erreur
        WYDST = WM(im,1) - WM(im,2);
        WYDIST(im) = WYDST * WPD(im);
        % Error 
        % delta y=erreur
        DY = DY +  WYDIST(im) * WYDST;
    end

    for ip = 1 : npar
        for jp = 1 : npar
            WPADER(ip,jp) = 0;
            for k = 1 : NbMes
                WPADER(ip,jp) = WPADER(ip,jp) + WADER(k,ip)* WPD(k,1) * WADER(k,jp);
            end
        end
    end






    % Invert WPADER inversion  matrix WPADER^-1 -->D 
    %WDD = fit_invmat(npar, WPADER);

    % initialisation
    WDD = zeros(npar,npar);
    WPP = zeros(npar);
    for i = 1 :  npar
        WDD(i,i) = 1; 
    end
    
    % invert matrix WPADER^-1 -->WDD
    for k = 1 : npar - 1
        for i = k + 1 : npar
            if WPADER(k,k) == 0
                mess_err = sprintf('ERROR on Matrix inversion. Diagonal term WPADER(k,k) is zero: i:%g %f\n', k, WPADER(k,k));
                error_message (100, 1, 'fist_lsqr_main', mess_err);
            else
                Wik_Wkk = WPADER(i,k) / WPADER(k,k);
                for j = 1 : npar
                    WDD(i,j) = WDD(i,j) - WDD(k,j) * Wik_Wkk;
                end
                for j = npar : -1 : k 
                    WPADER(i,j) = WPADER(i,j) - WPADER(k,j) * Wik_Wkk;
                end
            end
        end
    end
    
    for k = 1 : npar
        for i = npar : -1 : 1
            s = 0;
            for j = i : npar
                s = s + WPADER(i,j) * WPP(j);
            end
            WDD(i,k) = (WDD(i,k) - s) / WPADER(i,i);
             WPP(i) = WDD(i,k);
         end
         for i = 1 : npar
             WPP(i) = 0;
         end
     end    
     % end inversion

    % product  WTADER  * WYDIST
    for ip = 1 : npar
        WTEMP(ip) = 0;
        for im = 1 : NbMes
            WTEMP(ip) = WTEMP(ip) + WADER(im, ip) * WYDIST(im) ;
        end
    end

    % calcul  des WXDIST
    for ip = 1 : npar
        WXDST = 0;
        for jp = 1 : npar
            WXDST = WXDST + WDD(ip, jp) * WTEMP(jp);
        end
        WDPAR(ip) = WXDST;
    end

end
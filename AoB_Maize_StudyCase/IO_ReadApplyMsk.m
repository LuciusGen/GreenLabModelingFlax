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

function [Axdc, na, np, ni, nf, nm] = IO_ReadApplyMsk (filename, T, Axdc, na, np, ni, nf, nm)
    % 
    % [Axdc, na, np, ni, nf, nm] = IO_ReadApplyMsk (filename, T, Axdc, na, np, ni, nf, nm)
    % Reads a mask file and apply it to Nrep_S (Nrep_S is the implicit dimension) development axis
    %   I   filename:       Mask file name
    %   I   T:              Plant age
    %   I/O Axdc(T,Nrep_S): development axis 
    %   I/O na(T,Nrep_S):   leaf 
    %   I/O np(T,Nrep_S):   petiol 
    %   I/O nf(T,Nrep_S):   female fruit 
    %   I/O nm(T,Nrep_S):   male fruit 
    %
    %   Last version 2018/07/05. Main author PdR/MJ
    %   Copyright Cirad-AMAP
    %

    fprintf(1,'\nMask: %s\n', filename);
    fid = fopen(filename,'rt');

    if fid > 0
        % read a mask form
        fscanf(fid,'%s',1);%read "  Age_max Nb observ  rank"
        temp = fscanf(fid,'%f',2);
        info(1,:) = temp';
        M_T = info(1,1);
        %Tm = info(1,2);
        M_Axd = zeros(M_T,1);
        M_na = zeros(M_T,1);
        M_np = zeros(M_T,1);
        M_ni = zeros(M_T,1);
        M_nf = zeros(M_T,1);
        M_nm = zeros(M_T,1);

        fscanf(fid,'%s',1);% read ____T____Axdc_na_np_ni_nf_nm
        for i = 1 : M_T
            temp = fscanf(fid,'%f',7);
            info(1,1:7)=temp';
            %t = info(1,1);
            M_Axd(i) = info(1,2);
            M_na(i) = info(1,3);
            M_np(i) = info(1,4);
            M_ni(i) = info(1,5);
            M_nf(i) = info(1,6);
            M_nm(i) = info(1,7);
        end

        fclose(fid);

        if (M_T > T)
            M_T = T;
        end
        % The mask overwrites values until data is available 
        Axdc(1:M_T) = M_Axd(1:M_T);
        na(1:M_T) = M_na(1:M_T);
        np(1:M_T) = M_np(1:M_T);
        ni(1:M_T) = M_ni(1:M_T);
        nf(1:M_T) = M_nf(1:M_T);
        nm(1:M_T) = M_nm(1:M_T);
    end

end
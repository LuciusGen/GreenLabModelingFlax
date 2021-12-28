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

function  [T, Tm, Nrep_S, Axdc, na, np, ni, nf, nm, Xas] = IO_RestoreDevelopment (filename)
    % 
    % function  IO_DumpDevelopment (filename, T, Nrep_S, Axdc, na, np, ni, nf, nm, Xas)
    % Restores the development file
    %   I   filename:       Mask file name
    %   O   T:              Plant age
    %   O   Tm:             Plant max development age
    %   O   Nrep_S:         Number of stochastic duplicates
    %   O   Axdc(T,Nrep_S): development axis 
    %   O   na(T,Nrep_S):   leaf 
    %   O   np(T,Nrep_S):   petiol 
    %   O   ni(T,Nrep_S):   internode 
    %   O   nf(T,Nrep_S):   female fruit 
    %   O   nm(T,Nrep_S):   male fruit 
    %
    %   Last version 2018/07/13. Main author MJ
    %   Copyright Cirad-AMAP
    %
    
    fprintf(1,'\nRestore Development: %s\n', filename);
    fid = fopen(filename,'rt');

    if fid > 0

        fscanf (fid,'%s',1); %__T___Tm___Nrep_S______Dump_Development_File;
        temp = fscanf(fid,'%f',3);
        info(1,:) = temp';
        rT = info(1,1);
        rTm = info(1,2);
        rS = info(1,3);
        T = round(rT);
        Tm = round(rTm);
        Nrep_S = round(rS);
        
        Axdc = zeros(T,Nrep_S);
        na = zeros(T,Nrep_S);
        np = zeros(T,Nrep_S);
        ni = zeros(T,Nrep_S);
        nf = zeros(T,Nrep_S);
        nm = zeros(T,Nrep_S);
        %Xas = zeros(T,1);
        for s = 1 : Nrep_S

%         for i = 1: T
            fscanf (fid,'%s',1); %_Axdc__na__np__ni__nf__nm__%d(s value)
            %temp = fscanf(fid,'%d',1);
%             info(1,:) = temp';
%             Xas(i,1) = info(1,1);
            for i = 1: T
            %for j = 1 : Nrep_S
                temp = fscanf(fid,'%f',6);
                info(1,1:6)=temp';
                Axdc(i,s) = info(1,1);
                na(i,s) = info(1,2);
                np(i,s) = info(1,3);
                ni(i,s) = info(1,4);
                nf(i,s) = info(1,5);
                nm(i,s) = info(1,6);
            end
        end
        fscanf (fid,'%s',1); %Phytomer_Distribution\n
        Xas = fscanf(fid,'%f',T);
        %Xas(:,1) = temp(:,1);
        fclose(fid);
    else
        T = 0;
        Tm = 0;
        Nrep_S = 0;
        Axdc = 0;
        na = 0;
        np = 0;
        ni = 0;
        nf = 0;
        nm = 0;
        Xas = 0;
    end

end
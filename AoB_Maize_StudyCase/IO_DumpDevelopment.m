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

function  IO_DumpDevelopment (filename, T, Tm, Nrep_S, Axdc, na, np, ni, nf, nm, Xas)
    % 
    % function  IO_DumpDevelopment (filename, T, Nrep_S, Axdc, na, np, ni, nf, nm, Xas)
    % Dumps the development file
    %   I   filename:       Mask file name
    %   I   T:              Plant age
    %   I   Tm:             Plant max development age
    %   I   Nrep_S:         Number of stochastic duplicates
    %   I   Axdc(T,Nrep_S): development axis 
    %   I   na(T,Nrep_S):   leaf 
    %   I   np(T,Nrep_S):   petiol 
    %   I   ni(T,Nrep_S):   internode 
    %   I   nf(T,Nrep_S):   female fruit 
    %   I   nm(T,Nrep_S):   male fruit 
    %
    %   Last version 2018/07/13. Main author MJ
    %   Copyright Cirad-AMAP
    %

    fprintf(1,'\nDevelopment Dump: %s\n', filename);
    fid = fopen(filename,'wt');

    if fid > 0

        fprintf (fid,'__T___Tm___Nrep_S______Dump_Development_File\n');
        fprintf (fid,' %d %d %d\n', T, Tm, Nrep_S);
        
        for s = 1 : Nrep_S       
            fprintf (fid,'_Axdc__na__np__ni__nf__nm__for_Stochastic_Id:%d\n',s);           
            for i = 1: T
                fprintf (fid,'%f %f %f %f %f %f\n',Axdc(i,s), na(i,s), np(i,s), ni(i,s), nf(i,s), nm(i,s));
            end
        end
        fprintf (fid,'Phytomer_Distribution\n');           
        %for i = 1: T
        fprintf (fid,'%f\n',Xas);           
        %end

        fclose(fid);
    end

end
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

function IO_WriteMsk (filename,T,Tm,na,np,ni,nf,nm) 
%
% function IO_WriteMsk (filename,T,Tm,na,np,ni,nf,nm) 
%
% Writes a mask file on disk 
%   I   filename:       Mask file name
%   I   T, Tm:          Plant age end final development cycle 
%   I   na(T,Nrep_S):   leaf 
%   I   np(T,Nrep_S):   petiol 
%   I   ni(T,Nrep_S):   internode
%   I   nf(T,Nrep_S):   female fruit 
%   I   nm(T,Nrep_S):   male fruit 
%
%   Last version 2018/07/05. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    fid = fopen(filename,'wt');
    if fid > 0
        fprintf(fid,'Age_Growth__Age_Dev\n');
        s = '%8.0f';
        fprintf(fid,s,T);
        fprintf(fid,s,Tm);
        fprintf(fid,'\n');
        fprintf(fid,'_______T______Axdc_______na_______np_______ni_______nf______nm');
        fprintf(fid,'\n');
        s ='%8.0f %8.0f %8.0f %8.0f %8.0f %8.0f %8.0f';
        for i=1:Tm
            fprintf(fid,s,i,1.0,na(i,1),np(i,1),ni(i,1),nf(i,1),nm(i,1));
            fprintf(fid,'\n');
        end
        if T > Tm
            for j=1:T-Tm
                fprintf(fid,s,i+j,0,0,0,0,0,0);
                fprintf(fid,'\n');
            end
        end
        fclose(fid);
    else
        mess_err = sprintf('Error opening (write) mask file %s. Return code : %d', filename, fid); 
        error_message (11, 1, 'IO_WriteMsk', mess_err);
    end
end
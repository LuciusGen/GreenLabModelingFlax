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

function IO_WriteParam (filename,text,param, nb_lines)
%
% function IO_WrParam (filename,text,param, nb_lines)
% 
% Dumps parameters to file
%
%   I   filename:   Parameter file name
%   I   text:       Parameter labels (nb lines)
%   I   param:      The parameter matrix (10*nb_lines)
%   I   nb_lines:   Number of parmeter lines 
%
%   Last version 2018/07/05. Main author MJ/PdR
%   Copyright Cirad-AMAP
%
    fid = fopen(filename,'wt');
    if fid > 0    
        i = 1;
        while (i <= nb_lines)
            fprintf (fid,'%s\n',text{i});
            fprintf (fid,'%g\t',param(i,1:9));
            fprintf (fid,'%g\n',i);
            i=i+1;
        end
        fclose(fid); % fin automatique de la lecture
    else
        mess_err = sprintf('Error opening (write) param file %s. Return code : %d', filename, fid); 
        error_message (11, 1, 'IO_WriteParam', mess_err);        
    end

 end


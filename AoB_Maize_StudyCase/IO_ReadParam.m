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

function [text, param, treename] = IO_ReadParam ( filename, nb_lines )
%
%    function [text, param, treename] = IO_ReadPar( filename )
%
%   I   filename:   full path to parameter filename
%   I   nb_lines:   number of parameter lines (24 default)
%   O   text:       parameter file labels
%   O   param:      paramater list (10 values/line, nb_lines)
%   O   plname:     plante name with path (extension supressed)
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%

    fprintf(1,'\nParam: %s \n', filename);
        
    treename = '';
    text{20} = '';
    param = 0;
    
    fid = fopen(filename,'rt');

    if fid > 0
        treename = strrep(filename, 'par.m','');
   
        param = zeros(nb_lines,10);
        temp  = zeros(10,1);        
        i=1;
        while (i <= nb_lines)
            text{i} = fscanf(fid,'%s',1); % comment line
            temp = fscanf(fid,'%f',10);
            param(i,1:10)=temp(1:10,1)';
            i=i+1;
        end
        fclose(fid);
    else
        mess_err = sprintf('Error opening (read) param file %s. Return code : %d', filename, fid); 
        error_message (11, 1, 'IO_ReadParam', mess_err); 
    end

end


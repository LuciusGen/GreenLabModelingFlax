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


function [filename] = IO_FileGUI(filename, label, directory, extension, wrmode)
%
% function [filename] = IO_FileGUI(filename, label, directory, extension)
%
%   Opens a filechoser window
%
%   I   label:      string label appearing on the Filechoser box
%   I   directory:  directory the browser points to
%   I   extension:  extension name (must include the '.')
%   I   wrmode:     writing mode if > 0
%
%   I-O filename:   the selected or new file name if box was not canceled
%
%   Last version 2018/07/12. Main author MJ
%   Copyright Cirad-AMAP
%
    if wrmode > 0
        fid = fopen(filename,'wt');
    else
        fid = fopen(filename,'rt');
    end
    if fid > 0
        fclose (fid);
    else
        sdir = ['.' filesep directory filesep 'test.m'];
        if (wrmode)
            [fname,path] = uiputfile(extension, label, sdir);
        else
            [fname,path] = uigetfile(extension, label, sdir);
        end
        filename = [path fname];
    end
end


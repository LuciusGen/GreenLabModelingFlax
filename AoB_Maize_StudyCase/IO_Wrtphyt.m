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

function IO_Wrtphyt (fid, mxTob, Tob, n, str, qob)
    %
    % IO_Wrtphyt (fid, mxTob, Tob, n, str, qob)
    %   Dumps a phytomer componant in a file
    %
    %   I   fid:    file id
    %   I   mxTob:  Number of observations dates
    %   I   Tob:    List of obsrvation dates (1..mxTob)
    %   I   n:      Number of ranks (plant age)
    %   I   str:    Phytomer label
    %   I   qob:    biomass value
    %
    fprintf(fid,' %s 1',str);
    fprintf(fid,'\n');
    si = '%12.0f';
    fprintf(fid,si,0);
    for k = 1 : mxTob
        if Tob(1,k) >0
            fprintf(fid,si,floor(Tob(1,k)));% write sampling date
        end
    end
    
    fprintf(fid,'\n');
    s = '%12.5f';  
    for j = 1 : n
        fprintf(fid,si,n-j+1); % write rank from tip
        for k = 1 : mxTob
            if Tob(1,k) > 0
                if qob(j,k) > 999
                    fprintf(1,' \n');
                    fprintf(1,'Alert writing target qo > 999 \n');
                end
                fprintf(fid,s,qob(j,k));
            end
        end
        fprintf(fid,'\n');
    end
end
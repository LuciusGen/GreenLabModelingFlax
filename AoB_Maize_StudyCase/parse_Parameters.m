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

function [inputName,outputName,envName,p_Age,p_E,p_Env,p_Sp,p_Q0,p_Dsp,p_Dev,aok,Normal_Env] = parse_Parameters (tabargs,nargs)
%
%
%
%
    inputName = '#';
    outputName = '#';
    envName = '#';
    p_Age = 0;
    p_E = 0;
    p_Env = zeros (1,256);
    p_Sp = 0;
    p_Q0 = 0;
    p_Dsp = 3;
    p_Dev = 0;
    aok = 0;
    Normal_Env =1;

    i = 1;
    while (i <= nargs)
        aok = 0;    
        if (aok == 0 && i < nargs && strcmp ('-i',tabargs{i}) )
            i = i+1;
            inputName = tabargs{i};
            aok = 1;
        end
        if (aok == 0 && i < nargs && strcmp ('-a',tabargs{i}) )
            i = i+1;
            p_Age = str2num ( tabargs{i} );
            if (p_Age < 1 || p_Age > 150)
                p_Age = 0;
            end
            aok = 1;
        end 
        if (aok == 0 && i < nargs && strcmp ('-d',tabargs{i}) )
            i = i+1;
            p_Dsp = str2num ( tabargs{i} );
            if (p_Dsp < 0 || p_Dsp > 3)
                p_Dsp = 0;
            end
            aok = 1;
        end
        if (aok == 0 && i < nargs && strcmp ('-e',tabargs{i}) )
            i = i+1;
            [p_E, isnum] = str2num ( tabargs{i} );
            if (isnum)
                if (p_E < 0.01 || p_E > 100)
                    p_E = 0;
                end
            else
                envName = tabargs{i};
                fid = fopen(envName, 'r');
                if (fid)
                    while ~feof(fid)
                        ival = fscanf(fid,'%d', 1);
                        fval = fscanf(fid,'%f', 1);
                        if (~feof(fid) && ival > 0 && ival < 1024 && fval > 0.01 && fval < 100.0)
                            p_Env(1,ival) = fval;
                            Normal_Env = 0;
                        end
                    end
                end
                if fid > 0
                    fclose (fid);
                end
            end
            aok = 1;
        end 
        if (aok == 0 && i < nargs && strcmp ('-g',tabargs{i}) ) % sets Structure restoration or not
            p_Dev = 1;
            aok = 1;
        end
        if (aok == 0 && i < nargs && strcmp ('-s',tabargs{i}) ) 
            i = i+1;
            p_Sp = str2num ( tabargs{i} );
            if (p_Sp < 0.01 || p_Sp > 10000000)
                p_Sp = 0;
            end 
            aok = 1;
        end
        if (aok == 0 && i < nargs && strcmp ('-q',tabargs{i}) )
            i = i+1;
            p_Q0 = str2num ( tabargs{i} );
            if (p_Q0 < 0.01 || p_Q0 > 100)
                p_Q0 = 0;
            end 
            aok = 1;
        end
        if (aok == 0 && i < nargs && strcmp ('-o',tabargs{i}) )
            i = i+1;
            outputName = tabargs{i};
            aok = 1;
        end 
        if (aok == 0 && i < nargs && strcmp ('-h',tabargs{i}) )
            fprintf(1,'Syntax is: PROG [options] \n');
            fprintf(1,'[options] are \n');
            fprintf(1,'  -a age \n');
            fprintf(1,'  -d display mode (0:none, 1:curves, 2:structure, 3:all) \n');
            fprintf(1,'  -e E_value (0.01 to 100.0) or E_filename\n');
            fprintf(1,'  -g Sets Structure restoration mode\n');
            fprintf(1,'  -h This help message \n');
            fprintf(1,'  -i input name \n');
            fprintf(1,'  -o outputName \n');
            fprintf(1,'  -q Q0_value (0.01 to 100.0) \n');
            fprintf(1,'  -s Sp_value (0.01 to 10000000.0) \n');
            aok = 1;
            return;
        end
        if (aok == 0)
            bad_param = char (tabargs{i});
            fprintf(1,'Bad syntax varargin(%d): %s \n', i, bad_param);
            fprintf(1,'Syntax is: PROG [options] \n');
            fprintf(1,'[options] are \n');
            fprintf(1,'  -a age \n');
            fprintf(1,'  -d display mode (0:none, 1:curves, 2:structure, 3:all) \n');
            fprintf(1,'  -e E_value (0.01 to 100.0) or E_filename\n');
            fprintf(1,'  -g Sets Structure restoration mode\n');
            fprintf(1,'  -h This help message \n');
            fprintf(1,'  -i input name \n');
            fprintf(1,'  -o outputName \n');
            fprintf(1,'  -q Q0_value (0.01 to 100.0) \n');
            fprintf(1,'  -s Sp_value (0.01 to 10000000.0) \n');
            i = nargs+1;
            return;
        end
        i = i+1;
    end
        

end

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

function [mxTob]= IO_WriteTarg (filename,comp,T,mxTob,Tob,TQbg,TQpg,TQeg,TQfg,TQmg,TQtg,...
    qbs,qps,qes,qfs,qms,pp,pe,pf,pm)
%
% function [mxTob]= IO_WriteTarg (filename,comp,T,mxTob,Tob,TQbg,TQpg,TQeg,TQfg,TQmg,TQtg,...
%    qbs,qps,qes,qfs,qms,pp,pe,pf,pm)
% 
% Writes a target file
%
%   I   filename:   Parameter file name
%   I   T:          Plant age
%   I   comp,mxTob,Tob,TQbg,TQpg,TQeg,TQfg,TQmg,TQtg,qbs,qps,qes,qfs,qms,pp,pe,pf,pm
%   I   param:      The parameter matrix (10*nb_lines)
%   I/O MxTob:     Why in I/O ????
%
%   Last version 2018/07/05. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    fid = fopen(filename,'wt');
    if fid > 0

        Tob1=Tob;
        Tobm =max(abs(Tob1));

        % write information
        fprintf(fid,'Information \n');
        fprintf(fid,'  Age_max____Dates_number\n');
        s = '%8.0f %8.0f ';
        fprintf(fid,s,Tobm,mxTob);
        fprintf(fid,'\n');

        fprintf(fid,'Dates_of_Plant_measurements \n');
        s = '%8.0f ';
        for i=1:mxTob
            fprintf(fid,s,Tob1(1,i));
        end
        fprintf(fid,'\n');    

        fprintf(fid,'Organ_production\n');
        if comp(1,1) > 0
            fprintf(fid,'      Age_____TQb_______TQp_______TQi______TQf_______TQm______TQt\n');
            for i = 1 : mxTob
                idx = abs(Tob1(1,i));
                fprintf(fid,'%8.0f ',idx);
                % the sum of compartments of GC abs(Tob(1,i)) comes from photosynthesis of
                % abs(Tob(1,i))-1!
                fprintf(fid,'%8.3f ',TQbg(idx,1));
                if pp == 0
                    fprintf(fid,'%8.3f ',0);
                else
                    fprintf(fid,'%8.3f ',TQpg(idx,1));
                end
                if pe == 0
                    fprintf(fid,'%8.3f ',0);
                else
                    fprintf(fid,'%8.3f ',TQeg(idx,1)); % impossible to separate pith from rings
                end
                if pf == 0
                    fprintf(fid,'%8.3f ',0);
                else
                    fprintf(fid,'%8.3f ',TQfg(idx,1));
                end
                if pm == 0
                    fprintf(fid,'%8.3f ',0);
                else
                    fprintf(fid,'%8.3f ',TQmg(idx,1));
                end
                fprintf(fid,'%8.3f ',TQtg(idx,1));
                fprintf(fid,'\n');
            end
        end

        if comp(1,2) > 0   % write phytomers
            qbob = zeros(T,mxTob);
            qpob = qbob;
            qeob = qbob;
            qfob = qbob;
            qmob = qbob;
            for i = 1 : mxTob
                if Tob(1,i) > 0
                    qbob(1:T,i) = qbs(1:T,abs(Tob(1,i)));
                    if pp >0
                        qpob(1:T,i) = qps(1:T,abs(Tob(1,i)));
                    end
                    qeob(1:T,i) = qes(1:T,abs(Tob(1,i)));
                    if pf >0
                        qfob(1:T,i) = qfs(1:T,abs(Tob(1,i)));
                    end
                    if pm >0
                        qmob(1:T,i) = qms(1:T,abs(Tob(1,i)));
                    end
                end
            end
            str='Blade-size/position ';
            IO_Wrtphyt(fid,mxTob,Tob,T,str,qbob)
            if pp > 0
                str='Petiol-size/position ';
                IO_Wrtphyt(fid,mxTob,Tob,T,str,qpob)
            end
            % if comp(1,5) = 2 omnly diam and lenght
            str = 'Internode-size/position ';
            IO_Wrtphyt(fid,mxTob,Tob,T,str,qeob)
            if pf > 0
                str = 'FruitF-size/position ';
                IO_Wrtphyt(fid,mxTob,Tob,T,str,qfob)
            end
            if pm > 0
                str = 'FruitM-size/position ';
                IO_Wrtphyt(fid,mxp,mxTob,Tob,No_I,T,str,qmob)
            end
        end

        fclose(fid);
    else
        mess_err = sprintf('Error opening (write) target file %s. Return code : %d', filename, fid); 
        error_message (11, 1, 'IO_WriteTarg', mess_err);
    end

end
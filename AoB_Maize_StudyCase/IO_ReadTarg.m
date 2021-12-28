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
% Copyright (C) 2018-2020 CIRAD-AMAP 
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

function [T,mxTob,Tob,TQaob,TQpob,TQiob,TQfob,TQmob,TQtob,...
    qaob,qpob,qiob,qfob,qmob] = IO_ReadTarg(filename, T, comp,pp,pe,pf,pm)   
%
% function [T,mxTob,Tob,TQaob,TQpob,TQiob,TQfob,TQmob,TQtob,...
%    qaob,qpob,qiob,qfob,qmob] = IO_ReadTarg(filename, T, comp,pp,pe,pf,pm)
%
%   Last version 2018/07/05. Main author PdR
%   Copyright Cirad-AMAP
%    
    fprintf(1,'\nTarget: %s\n',filename);

    fid = fopen(filename,'rt');
    if fid > 0

        %name = fscanf(fid,'%s',1);%read"information"
        fscanf(fid,'%s',1);%read"information"
        %name = fscanf(fid,'%s',1);%read "  Age_max Nb observ "
        fscanf(fid,'%s',1);%read "  Age_max Nb observ "
        temp = fscanf(fid,'%f',2);
        info(1,:) = temp';
        T_T = info(1,1);
        if T_T ~= T
            fprintf(1,'\nPlant age differs in Parameter file :%d and Target file: %d. Keeping: %d\n',T, T_T, T_T);
            T = T_T;
        end
        mxTob = info(1,2);
        %name = fscanf(fid,'%s',1);% "date_of_measurements"
        fscanf(fid,'%s',1); % "date_of_measurements"
        temp = fscanf(fid,'%f',mxTob);
        info(1,1:mxTob)=temp';
        info_Dat(1,1:mxTob) = info(1,1:mxTob);% non utilis�
        %name = fscanf(fid,'%s',1);%organe production
        fscanf(fid,'%s',1);%organe production

        TQaob = zeros(mxTob,1);
        TQpob = zeros(mxTob,1);
        TQiob = zeros(mxTob,1);
        TQfob = zeros(mxTob,1);
        TQmob = zeros(mxTob,1);
        TQtob = zeros(mxTob,1);
        if comp(1,1) >0
            %name = fscanf(fid,'%s',1);%blade__petiol_internode_fruitF_fruitM__root "
            fscanf(fid,'%s',1);%blade__petiol_internode_fruitF_fruitM__root "
            ncol =7;
            for k=1:mxTob
                temp=fscanf(fid,'%f',ncol);
                info(1,1:ncol)=temp';
                TQaob(k) = info(1,2);
                TQpob(k) = info(1,3);
                TQiob(k) = info(1,4);
                TQfob(k) = info(1,5);
                TQmob(k) = info(1,6);
                TQtob(k) = info(1,7);
            end
        else
            TQaob = zeros(mxTob,1);
            TQpob = zeros(mxTob,1);
            TQiob = zeros(mxTob,1);
            TQfob = zeros(mxTob,1);
            TQmob = zeros(mxTob,1);
            TQtob = zeros(mxTob,1);
        end

        Tob=info_Dat; % to select data with phytomers
        if comp(1,2) >0 % read phytomers
            qaob = 0;
            qpob = 0;
            qiob = 0;
            qfob = 0;
            qmob = 0;
            [name, nb] = fscanf(fid,'%s',1);%read "chrono_age_tq"
            while nb > 0
                posit = fscanf(fid,'%f \n',1);
                fprintf(1,'Target Organ(%d):%s %d\n', nb, name, posit);
                ok = 0;
                if  strncmpi(name,'Blade-size/position',18)
                    [qaob] = IO_ReadPhyt(fid,Tob,T,mxTob);
                    ok = 2;
                end
                if  strncmpi(name,'Petiol-size/position',19)
                    ok = 1;
                    if pp > 0
                        [qpob] = IO_ReadPhyt(fid,Tob,T,mxTob);
                        ok = 2;
                    end
                end
                if  strncmpi(name,'Internode-size/position',22) || strncmpi(name,'Pith-size/position',17)
                    ok = 1;
                    if pe > 0
                        [qiob] = IO_ReadPhyt(fid,Tob,T,mxTob);
                        ok = 2;
                    end
                end
                if  strncmpi(name,'FruitF-size/position',19)
                    ok = 1;
                    if pf > 0
                        [qfob] = IO_ReadPhyt(fid,Tob,T,mxTob);
                        ok = 2;
                    end
                end
                if  strncmpi(name,'FruitM-size/position',19)
                    ok = 1;
                    if pm > 0
                        [qmob] = IO_ReadPhyt(fid,Tob,T,mxTob);
                        ok = 2;
                    end
                end
                if ok == 1
                    IO_ReadPhyt(fid,Tob,T,mxTob); % IN the target file but not needed
                end
                if ok == 0
                    mess_err = sprintf('\nUnknown Organ Name [%s] in Target File: %s', name, filename); 
                    error_message (101, 1, 'IO_ReadTarg', mess_err);
                end
                [name, nb] = fscanf(fid,'%s',1);%read "chrono_age_tq"

            end
        end
        if comp(1,1) == 0
            TQAob  = zeros(mxTob,1);
            TQPob  = zeros(mxTob,1);
            TQICob = zeros(mxTob,1);
            TQFob  = zeros(mxTob,1);
            TQMob  = zeros(mxTob,1);
            TQTob  = zeros(mxTob,1);
        end
        if comp(1,2) == 0
            qaob = zeros(T,mxTob);
            qpob = zeros(T,mxTob);
            qiob = zeros(T,mxTob);
            qfob = zeros(T,mxTob);
            qmob = zeros(T,mxTob);
        end

        fclose(fid);
    end

end





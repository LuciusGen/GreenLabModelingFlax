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

function [] = Draw_Organ(position_y, n_cell, koef, Leaf_Display,Internode_Display,Fruit_Display,...
    t,i,ta,na,ni,nf,nm,nt,TQTs,pos_x,pos_y,IsPhyto,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms)

% Organ colors
Col_Inter = [0.6,0.6,0.6];
Col_NLeaf = [0 1 0];
Col_OLeaf = [1 1 0];
Col_FFruit = [1 0 0];
Col_MFruit = [0 0 1];
Col_Break = [1 1 1];

if nt > 0 && i == 1
    if TQTs > 0
        % Dts = 2 * (TQTs/(2*3.1415))^(1/3);
        % Dts = 1.0839 * (TQTs ^(1/3)); % SAME THEN PREVIOUS LINE => 1.0839 replaced by 1.0
        Dts = TQTs ^(1/3);
        LTs = Dts;
        %%draw tape root
        rectangle('position',[pos_x-Dts/2,pos_y-LTs,Dts,LTs],'Curvature',[0.5,0.5],'FaceColor', Col_Inter);
    end
end

if qlis > 0
    if IsPhyto > 0
        %internode
        if Internode_Display == 1
            x_orig = pos_x - (ni*qdics)/2.0;
            for j = 1 : ni
                rectangle('position',[x_orig,pos_y,qdics,qlis],'Curvature',[0,0],'FaceColor',Col_Inter);
                x_orig = x_orig + qdics;
            end
        end
        %leaf
        if Leaf_Display == 1
            if t-i+1 <= ta % green leaf
                Col_Leaf = Col_NLeaf;
            else
                Col_Leaf = Col_OLeaf;
            end
            x_orig = qdics + qlas;
            rectangle('position',[pos_x+qdics/2-mod(i,2)*x_orig,pos_y+qlis-qdas/2,qlas,qdas],'Curvature',[0.9,0.9],'FaceColor',Col_Leaf);
            if na > 1
                 rectangle('position',[pos_x+qdics/2-mod(i+1,2)*x_orig,pos_y+qlis-qdas/2,qlas,qdas],'Curvature',[0.9,0.9],'FaceColor',Col_Leaf);
            end
        end
        % fruits
        if Fruit_Display == 1
            if nf > 0 && qdfs*qlfs > 0
                for j =1:nf
                    x_orig = qdics/2 + j*qlfs ;
                    if mod(i,2) > 0
                        x_orig = -x_orig + qlfs;
                    end
                    ypos = qlis * (0.6 + mod(j,2)*0.3);
                    
                    x_l = pos_x-x_orig
                    y_l = position_y

                    X = [29, 38, 44, 37, 39, 63, 61, 49, 70, 58, 40, 66, 100, 74, 68, 50, 65, 74, 80, 92, 140, 33, 74, 29, 55, 85, 108, 53, 115, 164, 113, 142, 79, 175, 98, 103]
                    Y = [6, 6, 6, 7, 7, 7, 8, 8, 9, 10, 11, 11, 11, 11, 12, 12, 13, 13, 14, 16, 16, 17, 18, 20, 20, 20, 22, 23, 23, 23, 24, 24, 26, 36, 48, 52]
                    D = 1
                    
                    
                    R = polyfit(X, Y, D)
                    f_len = polyval(R, n_cell) * koef
                    
                    %x_coor = [x_l, x_l + qlfs, x_l + qlfs, x_l]
                    %y_coor = [y_l, y_l, y_l + qdfs, y_l + qdfs]
                                        
                    %fill(x_coor, y_coor,Col_FFruit);
                    % MJ correction 2018 05 11 One line replaced
                    rectangle('position',[x_l,y_l ,3,f_len],'Curvature',[0.7,0.7],'FaceColor',Col_FFruit);
                end
            end
            if nm >0 && qdms*qlms > 0
                for j =1:nm
                    % glue the fruits one after the other + half stem diameter
                    x_orig = qdics/2 + j*qlms ;
                    if mod(i,2) > 0 % reversed side skip one length
                        x_orig = -x_orig + qlms;
                    end
                    ypos = qlis * (0.4 + mod(j,2)*0.2);
                    rectangle('position',[pos_x-x_orig,pos_y+ypos,qlms,qdms],'Curvature',[0.7,0.7],'FaceColor',Col_MFruit);
                end
            end
        end
    else
        if qdics < 0.001 % should not happen
            qdics = 0.1 * qlis;
        end
        rectangle('position',[pos_x-qdics/2,pos_y,qdics,qlis],'Curvature',[0,0],'FaceColor',Col_Break);
    end
end
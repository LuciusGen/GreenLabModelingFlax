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

function Draw_Plant(position_y, n_cell, koef, chrono,plant_name,No,Leaf_Display,Internode_Display,Fruit_Display,T,Tm,Axdc,...
ta,na,ni,nf,nm,nt,TQTs,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms)
%%%
    
    anim = 0;    

    % MJ correction 2018 05 11 added 3 lines
    dlmax = max(qlas);
    dlm = max(dlmax,[],2); % retrieve max leaf size
    if No > 1
        dm = max(dlm,[],3);
    else
        dm = max(dlm,[],2);
    end
    decal_x = 2*dm;
    
    % define viewpoint boundaries 
    hm = 0;
    htot = 0.0;
    ym = 0;
    Nphy = 0;
    if Tm > T || Tm == 0
        Tmax = T;
    else
        Tmax = Tm;
    end
    for s = 1 : No
        np = 0;
        ht = 0.0;
        for i = 1 : Tmax
            if Axdc(i,s) > 0
                np = np+1;
                ht = ht + qlis(Tmax,i,s);
            end
        end
        ym = ht;
        if np > 0
            htot = ht * (1.0 + 0.75 * (T-np)/np );
        else
            htot = ht * (1.0 + 0.75 * T );
        end
        if htot > hm
            hm = htot;
            ym = ht;
            Nphy = np;
        end
    end
    
    nbpbreak = T-Nphy; % Number of breaks

    if htot < 0.0001
          ym = sum (qlis(T,1:T,1:No)) ;  % max on y axis
    end
    if Nphy > 0
        pbreaklength = 0.75 * ym / Nphy; % sets break lengths to 75% of average reals
    else
        pbreaklength = 0.75 * ym ; % sets break lengths to 75% of average reals
    end
    
    ym = ym + pbreaklength*nbpbreak + 0.25*dm;

    if decal_x*(No+0.01) > ym               % max on x axis greater ?
      ym = decal_x * (No+0.01);
    else
      decal_x = ym /(No+0.01);  
    end 
    dx = ym + 5; 
    xmi = -5 - 0.5*decal_x;
    xma = xmi + dx;
    ymi = -5;
    yma = ymi + dx;

    if chrono > 0
        fig12 = figure (12);
        title = sprintf('Plant chronological development and growth %s', plant_name); 
        set (fig12, 'Name', title);    
        %Dessin:

        %%%%m%%%%%%%%%%%%%%%%%%%%%%%%%
        % display chronological axis

        hold on;
        clf; % clear figure necessary for animation
        axis([xmi xma ymi yma]); 

        pos_x = 0;

        for s = 1 : No
            %qlpred = 1.0;
            previouswidth = 0.1;
            pos_y = 0;
            for i = 1 : T
                % defined length and diameter from previous one if break 
                if Axdc(i,s) > 0
                    plength = qlis(Tmax,i,s); % store length and diameter
                    pwidth = qdics(Tmax,i,s);
                    previouswidth = pwidth;
                else
                    %qlis(Tm,i,s)  = qlpred; % retrieve previous length and diameter
                    %qdics(Tm,i,s) = qdpred;
                    plength = pbreaklength;
                    pwidth = previouswidth;
                end
                Draw_Organ(position_y, n_cell, koef, Leaf_Display,Internode_Display,Fruit_Display,...
                    T,i,ta,na(i,s),ni(i,s),nf(i,s),nm(i,s),nt,TQTs(Tmax,s),pos_x,pos_y,...
                    Axdc(i,s),pwidth,plength,qdas(Tmax,i,s),qlas(Tmax,i,s),qdfs(Tmax,i,s),qlfs(Tmax,i,s),qdms(Tmax,i,s),qlms(Tmax,i,s));
                pos_y = pos_y + plength;
            end
            pos_x = pos_x + decal_x;
        end
        hold off;
    end

    fig13 = figure (13);
    title = sprintf('Plant topological development and growth %s', plant_name); 
    set (fig13, 'Name', title);    
    
    % first view is at final age even when animation
    if anim == 1
        t = 1; % animation : t = 1;  else  t = T
        animname =  sprintf('%s_Anim.gif', plant_name);
    else
        t = T; % animation : t = 1;  else  t = T
    end
    
    while t <= T  
        hold on;
        clf; % clear figure necessary for animation
        axis([xmi xma ymi yma]); 
    %    axis equal;
        pos_x = 0;
        for s=1:No
            pos_y = 0;        
            for i=1:t
                if Axdc(i,s) > 0
                    Draw_Organ(position_y, n_cell, koef, Leaf_Display,Internode_Display,Fruit_Display,...
                       t,i,ta,na(i,s),ni(i,s),nf(i,s),nm(i,s),nt,TQTs(t,s),pos_x,pos_y,...
                       Axdc(i,s),qdics(t,i,s),qlis(t,i,s),qdas(t,i,s),qlas(t,i,s),qdfs(t,i,s),qlfs(t,i,s),qdms(t,i,s),qlms(t,i,s));
                    pos_y = pos_y + qlis(t,i,s);
                end
            end
            pos_x = pos_x + decal_x;
        end
        
        if anim == 1
              % Capture the plot as an image 
              frame = getframe(fig13); 
              im = frame2im(frame); 
              [imind,cm] = rgb2ind(im,256);   
              % Write to the GIF File 
              if t == 1 
                  imwrite(imind,cm,animname,'gif','writemode','overwrite','LoopCount',65535,'DelayTime',1); 
              else 
                  if t == T
                        imwrite(imind,cm,animname,'gif','writemode','append','DelayTime',2); 
                  else
                        imwrite(imind,cm,animname,'gif','writemode','append','DelayTime',0); 
                  end
              end
        end        
               
        t = t+1;
        hold off;
    end

end
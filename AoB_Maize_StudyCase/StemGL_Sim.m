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


function[]= StemGL_Sim (varargin)
%
%
    [inputName,outputName,envName,p_Age,p_E,p_Env,p_Sp,p_Q0,p_Dsp,p_Dev,aok,Normal_Env] = parse_Parameters (varargin,nargin);
    
    %clear all;
    t0 = cputime;
    v=ver;
    fprintf(1,'%s %s\n',v(1).Name,v(1).Version);
    close all;
    
    global USE_CPP;
    USE_CPP = 0;
    if strncmp('MATLAB',v(1).Name,6)
        USE_CPP = 0;
    end

    if strncmp('Octave',v(1).Name,6)
        USE_CPP = 1;
    end
    USE_CPP = 0;

    NB_ORG = 7; %Maximum Number of organs

    global TreeName;
    TreeName = 'Empty';

    %read param
    sdir = 'target';
    [filename] = IO_FileGUI(inputName,'Select parameter file', sdir, '*par.m',0);
    t1 = cputime;
    [~, param, plant_name] = IO_ReadParam ( filename, 24 );
    
    % Alloc parameters    
    [T,Tm,Nrep_S,w,kw,b,bf,rnd1,Msk,nao,npo,nio,nco,nfo,nmo,nt,tw] = Load_ParamStructure (param, p_Age);

    [tfo,txo,txo_n,txo_ctl,txo_x,pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
        Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
        Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1] = Load_ParamOrgans (param);

    [modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20] = Load_ParamClimate (param);

    [Eo,Qo,aQo,aQr,Sp,r,kc] = Load_ParamFunctioning (param);
    
    [comp,~] = Load_ParamFitting (param);
    
    
    % Restore axes of development and organ cohorts numbering or create them
    Ti = 0;
    Get_Dev = p_Dev;
    if Get_Dev > 0
        [Ti, Tm, Nrep_S, Axdc, na, np, ni, nf, nm, Xas] = IO_RestoreDevelopment (strcat(plant_name, 'dev.m'));    
        %[Ti, Tm, Nrep_S, Axdc, na, np, ni, nf, nm, Xas] = IO_RestoreDevelopment ('Test_dev.m');    
    end
    
    t2 = cputime;
    
    if Ti > 0
        T = Ti;
        t3  = t2;
    else
        % Development Axis 
        % 
        if Tm > T  % development duration
            Tm = T;
        end


        if USE_CPP
            % The theoritical development axis 
            mkoctfile --mex CPPAxDevRythmRatioBernoulli.cpp;
            [AxdPot] = CPPAxDevRythmRatioBernoulli (T, Tm, b, tw, kw, w);
        else
            % The theoritical development axis 
            [AxdPot] = AxDevRythmRatioBernoulli (T, Tm, b, tw, kw, w);
        end

        if Nrep_S < 1
            Nrep_S = 1;
        end
        % Organ development axis
        na = nao*ones(T,Nrep_S);
        np = npo*ones(T,Nrep_S);
        ni = nio*ones(T,Nrep_S);
        %nf = nfo*ones(T,Nrep_S);
        nm = nmo*ones(T,Nrep_S);

        Krnd = 997;
        rnd1 = 0.77653479197 * rnd1;
        if USE_CPP
            % The theoritical development axis 
            mkoctfile --mex CPPAxdev_St2.cpp;
            % The stotastic development axis and fruit positioning
            [Axdc,nf,Xas]= CPPAxdev_St2(Krnd, rnd1, AxdPot, T, Nrep_S, nfo, bf);
        else
            % The stotastic development axis and fruit positioning
            [Axdc,nf,Xas]= Axdev_St(Krnd, rnd1, AxdPot, T, Nrep_S, nfo, bf);
        end

        t3 = cputime;
        % mask for organs along stem
        % 
        if Msk == 1
            [filename] = IO_FileGUI(strcat (plant_name, 'msk.m'),'Select Mask file', sdir, '*msk.m',0);
            [Axdc, na, np, ni, nf, nm] = IO_ReadApplyMsk (filename, T, AxdPot, na, np, ni, nf, nm);
        end  

        % Development finished Dump it to disk (and potentially retrieve it)
        Save_Dev = 1;
        if Save_Dev > 0
            IO_DumpDevelopment (strcat(plant_name, 'dev.m'), T, Tm, Nrep_S, Axdc, na, np, ni, nf, nm, Xas);     
            %[T_g, Tm_g, Nrep_S_g, Axdc_g, na_g, np_g, ni_g, nf_g, nm_g, Xas_g] = IO_RestoreDevelopment (strcat(plant_name, 'dev.m'));    
        end
    end
    t4 = cputime;
    
    %%%%%% Climate
    rnd1 = 3.14159265 * rnd1;
    Krnd = 1009;
    rnd1 = 0.77653479197 * rnd1;
    if USE_CPP
        mkoctfile --mex CPPclimate.cpp;
        [E,DH] = CPPclimate(Krnd,rnd1,Eo,Ec,T,modE,cor,wE,bE,Lmx,Lmn,modH,pH20,dH20);
    else
        [E,DH] = climate(Krnd,rnd1,Eo,Ec,T,modE,cor,wE,bE,Lmx,Lmn,modH,pH20,dH20);
    end
    t5 = cputime;
    
    
    if USE_CPP
        % Organ expansion duration
        mkoctfile --mex CPPInterpole_Int2.cpp;
        [tx_o] = CPPInterpole_Int2(T, NB_ORG, txo, txo_n, txo_ctl, txo_x);
        % Affect expansion and functionning durations to each organ
        mkoctfile --mex CPPOrganDurations.cpp;
        [txa,txp,txi,txc,txf,txm,txt,tfa,tfp,tfi,tff,tfm,tft] = CPPOrganDurations (T, tx_o, tfo);
    else
        % Organ expansion duration
        [tx_o] = Interpole_Int(T, NB_ORG, txo, txo_n, txo_ctl, txo_x);
        % Affect expansion and functionning durations to each organ
        [txa,txp,txi,txc,txf,txm,txt,tfa,tfp,tfi,tff,tfm,tft] = OrganDurations (T, tx_o, tfo);
        mtxa = max(txa);
        mtxp = max(txp);
        mtxi = max(txi);
        mtxc = max(txc);
        mtxf = max(txf);
        mtxm = max(txm);
        mtxt = max(txt);
    end
    t6 = cputime;
    
    if USE_CPP
        % organ sink variation functions
        mkoctfile --mex CPPGrowth_Beta2.cpp;    
        [Ba] = CPPGrowth_Beta2(T,txa,Ba1,Ba2); % Beta law for blade
        [Bp] = CPPGrowth_Beta2(T,txp,Bp1,Bp2); % Beta law for petiol
        [Be] = CPPGrowth_Beta2(T,txi,Be1,Be2); % Beta law for internode
        [Bc] = CPPGrowth_Beta2(T,txc,Bc1,Bc2); % Beta law for ring
        [Bf] = CPPGrowth_Beta2(T,txf,Bf1,Bf2); % Beta law for female fruit
        [Bm] = CPPGrowth_Beta2(T,txm,Bm1,Bm2); % Beta law for male fruit
        [Bt] = CPPGrowth_Beta2(T,txt,Bt1,Bt2); % Beta law for tape root
    else
        % organ sink variation functions
        [Ba] = Growth_Beta(T,txa,mtxa,Ba1,Ba2); % Beta law for blade
        [Bp] = Growth_Beta(T,txp,mtxp,Bp1,Bp2); % Beta law for petiol
        [Be] = Growth_Beta(T,txi,mtxi,Be1,Be2); % Beta law for internode
        [Bc] = Growth_Beta(T,txc,mtxc,Bc1,Bc2); % Beta law for ring
        [Bf] = Growth_Beta(T,txf,mtxf,Bf1,Bf2); % Beta law for female fruit
        [Bm] = Growth_Beta(T,txm,mtxm,Bm1,Bm2); % Beta law for male fruit
        [Bt] = Growth_Beta(T,txt,mtxt,Bt1,Bt2); % Beta law for tape root
    end
    t7 = cputime;
   
    if USE_CPP
        % Plant and organ demand
        mkoctfile --mex CPPDemandS.cpp;  
        [Ds,Dcs,Dsm,SLas] = CPPDemandS(T,Axdc,Nrep_S,na,ni,nf,nm,...
            tfa,pa,pp,pe,pc,pf,pm,pt,pq,kpa,kpe,...
            Ba,Bp,Be,Bc,Bf,Bm,Bt,Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt);
    else
        % Plant and organ demand
        [Ds,Dcs,Dsm,SLas] = DemandS(T,Axdc,Nrep_S,na,ni,nf,nm,...
            tfa,pa,pp,pe,pc,pf,pm,pt,pq,kpa,kpe,...
            Ba,Bp,Be,Bc,Bf,Bm,Bt,Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt);
    end
    t8 = cputime; 
    
    
%G R O W T H
% %%%%%%%%%%%
% [Qsm,TQs,Qs,TQAS,TQPS,TQIS,TQICS,TQFS,TQMS,TQTS,TQTs,TQRS,...
%     qas,qps,qis,qics,qfs,qms,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms,...
%     qasm,qpsm,qism,qicsm,qfsm,qmsm] = GrowthS(modH,T,Tm,Nrep_S,Ds,Dcs,SLas,...
%     tfa,tfp,tfi,tff,tfm,tft,na,np,ne,nf,nm,nt,Ba,Bp,Be,Bc,Bf,Bm,Bt,...
%     Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,Axdc,e,b1,a1,f1,E,Qo,aQo,aQr,Sp,kc,r,...
%     pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
%     c1,c2,Hmx,Hmn,H1,psi,DH);
[Qsm,TQs,Qs,TQAS,TQPS,TQIS,TQICS,TQFS,TQMS,TQTS,TQTs,TQRS,...
    qas,qps,qis,qics,qfs,qms,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms,...
    qasm,qpsm,qism,qicsm,qfsm,qmsm] = GrowthS(modH,T,Tm,Nrep_S,Ds,Dcs,SLas,...
    tfa,tfp,tfi,tff,tfm,na,ni,nf,nm,Ba,Bp,Be,Bf,Bm,Bt,...
    Dla,Dlp,Dle,Dlf,Dlm,Dlt,Axdc,e,b1,a1,f1,E,Qo,aQo,aQr,Sp,kc,r,...
    pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
    c1,c2,Hmx,Hmn,H1,psi,DH);
    t9 = cputime;
% conditioning model output (Compartment,organic series for target and graphs)
%[qatg,qptg,qictg,qftg,qmtg]=Growth_Ax_Sorts(T,Tm,Nrep_S,Axdc,...
%    qas,qps,qics,qfs,qms,np,nf,nm,pa,pp,pe,pf,pm);

% TQFS - total biomass of f fruit => if we need to simulate growth of linear, we need to update the parm
% вставить здесь нормальное распределение

pkg load statistics

t_f_tmp = txo(5)
height_tmp = 0

if t_f_tmp <= T
  for i = 1: t_f_tmp
    height_tmp = height_tmp + qlis(t_f_tmp, i)
  end
end
position_y = random("normal", height_tmp / 2, height_tmp / 8)
pos_dol = (position_y / height_tmp) * 40

X = [0.3, 0.5, 1.5, 2.0, 15, 20, 20, 40]
Y = [40, 90, 500, 600, 700, 800, 700, 800]
D = 3

R = polyfit(X, Y, D)
n_cell = polyval(R, pos_dol)
n_cell = n_cell
TQFS = n_cell * TQFS
qdfs = qdfs * n_cell
qlfs = qlfs * n_cell
qfs = qfs * n_cell

[qatg,qptg,qictg,qftg,qmtg] = Growth_Ax_Sorts(T,Nrep_S,Axdc,nf,nm,pp,pf,pm,qas,qps,qics,qfs,qms);
%%%%%%%%%%%%%%%%%
%  R E S U L T S
%%%%%%%%%%%%%%%%%

    t10 = cputime;
    %Selected observation periods
Tob=[floor(T/3) floor(T/2) floor(2*T/3) floor(T)];
%growth duration
Tob_max=max(abs(Tob));
if (Tob_max > T)
    Tob=[floor(T/2) floor(T)];
end
[~,mxTob] = size(Tob);

    plot_HistoS(comp,E,T,Nrep_S,Tob,mxTob,pa,pp,pe,pc,pf,pm,pq,pt,Xas,Axdc,Dsm,Ds,Qsm,Qs,...
    TQs,TQAS,TQPS,TQIS,TQICS,TQFS,TQMS,TQRS,TQTS,...
    qasm,qpsm,qism,qicsm,qfsm,qmsm,qas,qps,qis,qics,qfs,qms,...
    txa,txp,txi,txf,txm,txt,mtxa,mtxp,mtxi,mtxf,mtxm,mtxt,Ba,Bp,Be,Bf,Bm,Bt,Dla,Dlp,Dle,Dlf,Dlm,Dlt);


    t11 = cputime;
    % DISPLAY Plant structure and geometry
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Leaf_Display =1;
    Internode_Display=1;
    Fruit_Display=1;
    No=1;
    chrono=1;
    if b*bf < 1 || Nrep_S > 1 % Means stochastic case
        No=min(5,Nrep_S);% number of displayed random structures, maximum 5 or Nrep_S if N_rep_S is smaller.
    end
    Draw_Plant(position_y, n_cell, 40 / height_tmp, chrono,plant_name,No,Leaf_Display,Internode_Display,Fruit_Display,T,Tm,Axdc,...
    tfa,na,ni,nf,nm,nt,TQTs,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms);

    t12 = cputime;
    % Output target
    Write_Target = 1;
    if Write_Target==1
        filename = ['.' filesep 'target' filesep 'targ.m'];
        IO_WriteTarg(filename,comp,T,mxTob,Tob,TQAS,TQPS,TQICS,TQFS,TQMS,TQTS,...
            qatg,qptg,qictg,qftg,qmtg,pp,pe,pf,nm);
    end

    % Output Mask
    Write_Mask = 1;
    if Write_Mask == 1
        filename = ['.' filesep 'target' filesep 'mask.m'];
        IO_WriteMsk(filename,T,Tm,na,np,ni,nf,nm); % MJ Juste ? j'aurai pris Axdc
    end


    t13 = cputime;
    fprintf (1,'\n%s\nPerformances Env: %s %s Use CPP: %d\n', plant_name,v(1).Name, v(1).Version, USE_CPP);
    fprintf (1,'TOTAL CPU TIME     %f      Total simulation     %f\n', t13-t0, t10-t3); 
    fprintf (1,'----------------------------------------------------------\n');        
    fprintf (1,'Parameter loading  %f      Development Axis     %f\n', t2-t1, t3-t2);               
    fprintf (1,'Mask load & apply  %f      Climate model        %f\n', t4-t3, t5-t4);        
    fprintf (1,'Organ durations    %f      Sink Organ Beta laws %f\n', t6-t5, t7-t6);        
    fprintf (1,'Plant Organ demand %f      Plant Organ growth   %f\n', t8-t7, t9-t8);        
    fprintf (1,'Organic series     %f      Plotting results     %f\n', t10-t9, t11-t10);        
    fprintf (1,'Plant Display      %f      Target & Mask save   %f\n', t12-t11, t13-t12);      
end
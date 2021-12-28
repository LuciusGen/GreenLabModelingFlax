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


function[]= StemGL_Fit (varargin)
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


    % read parameter file
    %%%%%%%%%%%%%%%%%%%%%
    %sdir = ['.' filesep 'target' filesep 'test.m'];
    sdir = 'target';
    [filename] = IO_FileGUI(inputName,'Select parameter file', sdir, '*par.m',0);
    t1 = cputime;
    [text, param, plant_name] = IO_ReadParam ( filename, 24 );


    % Load data into variables
    % [T,Tm,Nrep_S,w,kw,b,bf,rnd1,Msk,nao,npo,nio,nco,nfo,nmo,nt,tfo,tw,txo,txo_n,txo_ctl,txo_x,...
    %     pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
    %     Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
    %     Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1,Eo,Qo,aQo,aQr,Sp,r,kc,comp,chpm,...
    %     modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20] = I_O_Alloc_All( param);

    [T,Tm,Nrep_S,w,kw,b,bf,rnd1,Msk,nao,npo,nio,nco,nfo,nmo,nt,tw] = Load_ParamStructure (param, p_Age);
    

    [tfo,txo,txo_n,txo_ctl,txo_x,pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
        Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
        Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1] = Load_ParamOrgans (param);

    [modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20] = Load_ParamClimate (param);

    [Eo,Qo,aQo,aQr,Sp,r,kc] = Load_ParamFunctioning (param);

    [comp,chpm] = Load_ParamFitting (param);

    if (Nrep_S ~= 1)
        Nrep_S = 1;%no repetition for computation
    end


    t2 = cputime;
    
    % Read Target
    %%%%%%%%%%%%%%%%%%%%%%%
    [filename] = IO_FileGUI(strcat (plant_name, 'tar.m'),'Select target file', sdir, '*tar.m', 0);
    [T,mxTob,Tob,TQaob,TQpob,TQicob,TQfob,TQmob,TQtob,...
            qaob,qpob,qicob,qfob,qmob] = IO_ReadTarg (filename, T, comp, pp, pe, pf, pm);%read target
    
    % Restore axes of development and organ cohorts numbering or create them
    Ti = 0;
    Get_Dev = p_Dev;
    if Get_Dev > 0
        [Ti, Tm, Nrep_S, AxdPot, na, np, ni, nf, nm, ~] = IO_RestoreDevelopment (strcat(plant_name, 'pdev.m'));    
    end
    
    t3 = cputime;
    
    if Ti > 0
        T = Ti;
        t4 = t3;
    else
        % Development Axis 
        % 
        if Tm > T  % development duration
            Tm = T;
        end
        
        % ************** Developpment axis *************************
        if USE_CPP
            % Theoritical development axis (potential structure) 
            mkoctfile --mex CPPAxDevRythmRatioBernoulli.cpp;
            [AxdPot] = CPPAxDevRythmRatioBernoulli (T, Tm, b, tw, kw, w);
        else
            % Theoritical development axis (potential structure) 
            [AxdPot] = AxDevRythmRatioBernoulli (T, Tm, b, tw, kw, w);
        end


        t4 = cputime;

        % mask for organs along stem
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        na=nao*ones(T,1);
        np=npo*ones(T,1);
        ni=nio*ones(T,1);
        nf=nfo*ones(T,1);
        nm=nmo*ones(T,1); 
        if Msk ==1
            [filename] = IO_FileGUI(strcat (plant_name, 'msk.m'),'Select Mask file', sdir, '*msk.m', 0);
            [AxdPot, na, np, ni, nf, nm] = IO_ReadApplyMsk (filename, T, AxdPot, na, np, ni, nf, nm);
        end
    
        % Development finished Dump it to disk (and potentially retrieve it)
        Save_Dev = 1;
        if Save_Dev > 0
            IO_DumpDevelopment (strcat(plant_name, 'pdev.m'), T, Tm, Nrep_S, AxdPot, na, np, ni, nf, nm, zeros(T,1));     
            %[T_g, Tm_g, Nrep_S_g, AxdPot_g, na_g, np_g, ni_g, nf_g, nm_g, Xas_g] = IO_RestoreDevelopment (strcat(plant_name, 'pdev.m'));    
        end
    end    

    if USE_CPP
        % Inverse Binomial Law
        mkoctfile --mex CPPfunc_binomialinverse.cpp;
        [PBN] = CPPfunc_binomialinverse (T, b);
    else
        % Inverse Binomial Law
        [PBN, MiPBN, MxPBN] = func_binomialinverse (T, b); 
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
    %%%%%% Climate (E value and water supply)
    rnd1 = 3.14159265 * rnd1;
    Krnd = 1009;
    rnd1 = 0.77653479197 * rnd1;
    if USE_CPP
        mkoctfile --mex CPPclimate.cpp;
        [E,DH] = CPPclimate(Krnd,rnd1,Eo,Ec,T,modE,cor,wE,bE,Lmx,Lmn,modH,pH20,dH20);
    else
        [E,DH] = climate(Krnd,rnd1,Eo,Ec,T,modE,cor,wE,bE,Lmx,Lmn,modH,pH20,dH20);
    end


    t7 = cputime;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F I T T I N G  P R O C E S S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Least square method
Lsqr = 1;
N_iter = 20;
if Lsqr == 0
   N_iter = 1; 
end

TQAob = zeros(T,1);
    TQPob = zeros(T,1);
    TQICob= zeros(T,1);
    TQFob = zeros(T,1);
    TQMob = zeros(T,1);
    TQTob = zeros(T,1);
    if comp(1,1)>0
        x=1;
        for i=1:T
            if i == abs(Tob(x))
                TQAob(i,1) = TQaob(x,1);
                TQPob(i,1) = TQpob(x,1);
                TQICob(i,1)= TQicob(x,1);
                TQFob(i,1) = TQfob(x,1);
                TQMob(i,1) = TQmob(x,1);
                TQTob(i,1) = TQtob(x,1);
                x=x+1;
            end
        end
    end

    if USE_CPP
        mkoctfile --mex CPPGrowth_Beta2.cpp;
        mkoctfile --mex CPPOrgan_DemandFit.cpp;
        mkoctfile --mex CPPGrowth_Fit.cpp;
    end
    
    
 [Dt,Qt,TQt,TQAT,TQPT,TQICT,TQFT,TQMT,TQRT,TQTT,Ba,Bp,Be,Bc,Bf,Bm,Bt,...
  qat,qpt,qict,qft,qmt,qdict,qlit,qdat,qlat,qdft,qlft,qdmt,qlmt,MesO,MesS,MesT,MesNb,...
  Qo,Sp,r,pp,pe,pc,pf,pm,pt,kpc,kpa,kpe,ca,cp,ci,...
  Ba1,Bp1,Be1,Bf1,Bm1,Bt1,Ba2,Bp2,Be2,Bf2,Bm2,Bt2]=...
     fit_GLmain(modH,Lsqr,N_iter,chpm,comp,T,Tm,mxTob,Tob,...
  tfa,tfp,tfi,tff,tfm,tft,txa,txp,txi,txc,txf,txm,txt,mtxa,mtxp,mtxi,mtxc,mtxf,mtxm,mtxt,...
  na,np,ni,nf,nm,nt,AxdPot,PBN,MiPBN,MxPBN,e,b1,a1,f1,...
  Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,...
  E,bf,Qo,aQo,aQr,Sp,kc,r,pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,...
  mna,ca,mnp,cp,mne,ci,c1,c2,Hmx,Hmn,H1,psi,DH,...
  TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob);

    t8 = cputime;

%%%%%%%%%%%%%%%%%
%  R E S U L T S
%%%%%%%%%%%%%%%%%
    plot_HistoA(Lsqr,comp,E,T,Tm,Tob,mxTob,pa,pp,pe,pf,pm,pt,Dt,Qt,TQt,MesO,MesS,MesT,MesNb,...
    TQAT,TQAob,TQPT,TQPob,TQICT,TQICob,TQFT,TQFob,TQMT,TQMob,TQTT,TQTob,...
    qat,qaob,qpt,qpob,qict,qicob,qft,qfob,qmt,qmob,...
    txa,txp,txi,txf,txm,txt,mtxa,mtxp,mtxi,mtxf,mtxm,mtxt,Ba,Bp,Be,Bf,Bm,Bt,Dla,Dlp,Dle,Dlf,Dlm,Dlt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Backup of optimised parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [param]  = I_OWrtAlloc(T,Tm,Nrep_S,w,kw,b,bf,rnd1,Msk,nao,npo,nio,nco,nfo,nmo,nt,tfo,tw,txo,txo_n,txo_ctl,txo_x,...
%     pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
%     Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
%     Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1,Eo,Qo,aQo,aQr,Sp,r,kc,comp,chpm,...
%     modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20);

    t9 = cputime;

    param = zeros(24,10);
    [param] = Save_ParamStructure (param,T,Tm,Nrep_S,w,kw,b,bf,rnd1,Msk,nao,npo,nio,nco,nfo,nmo,nt,tw);    
    [param] = Save_ParamOrgans (param,tfo,txo,txo_n,txo_ctl,txo_x,...
    pa,pp,pe,pc,pf,pm,pt,pq,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
    Ba1,Ba2,Bp1,Bp2,Be1,Be2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,...
    Dla,Dlp,Dle,Dlc,Dlf,Dlm,Dlt,e,b1,a1,f1);
    [param] = Save_ParamClimate (param,modE,Ec,cor,wE,bE,Lmx,Lmn,modH,c1,c2,Hmx,Hmn,H1,psi,pH20,dH20);    
    [param] = Save_ParamFunctioning (param,Eo,Qo,aQo,aQr,Sp,r,kc);    
    [param] = Save_ParamFitting (param,comp,chpm);    

    %filename = ['target' filesep 'param5.m']; % default name of optimised param file
    [filename] = IO_FileGUI (strcat (plant_name, 'fitted_par.m'),'Save fitted parameter file as:', sdir, '*par.m', 1);
    IO_WriteParam (filename, text, param, 24);

    t10 = cputime;

    % Display Plant structure and geometry
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % drawing settings
    No=1;% potential structure
    Leaf_Display =1;
    Internode_Display=1;
    Fruit_Display=1;
    chrono=0;
    Draw_Plant(chrono,plant_name,No,Leaf_Display,Internode_Display,Fruit_Display,T,Tm,AxdPot,...
    tfa,na,ni,nf,nm,nt,TQTT,qdict,qlit,qdat,qlat,qdft,qlft,qdmt,qlmt);

    t11 = cputime;
    fprintf (1,'\n%s\nPerformances Env: %s %s Use CPP: %d\n', plant_name,v(1).Name, v(1).Version, USE_CPP);
    fprintf (1,'TOTAL CPU TIME    %f      Total simulation  %f\n', t11-t0, t8-t3);                
    fprintf (1,'----------------------------------------------------------\n');                
    fprintf (1,'Parameter loading %f      Target loading    %f\n', t2-t1, t3-t2);        
    fprintf (1,'Development Axis  %f      Mask load & apply %f\n', t4-t3, t5-t4);        
    fprintf (1,'Organ durations   %f      Climate model     %f\n', t6-t5, t7-t6);        
    fprintf (1,'Parameter fitting %f      Plotting results  %f\n', t8-t7, t9-t8);        
    fprintf (1,'Parameter saving: %f      Plant Display     %f\n', t10-t9, t11-t10);     

end
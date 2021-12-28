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

function [Dt,Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,Ba,Bp,Bi,Bc,Bf,Bm,Bt,...
    qat,qpt,qict,qft,qmt,qdict,qlit,qdat,qlat,qdft,qlft,qdmt,qlmt,MesO,MesS,MesT,DMS,...
    Qo,Sp,r,pp,pe,pc,pf,pm,pt,kpc,kpa,kpe,ca,cp,ci,...
    Ba1,Bp1,Bi1,Bf1,Bm1,Bt1,Ba2,Bp2,Bi2,Bf2,Bm2,Bt2]=...
    fit_GLmain(modH,Lsqr,N_iter,chpm,comp,T,Tm,mxTob,Tob,...
    tfa,tfp,tfi,tff,tfm,tft,txa,txp,txi,txc,txf,txm,txt,mtxa,mtxp,mtxi,mtxc,mtxf,mtxm,mtxt,...
    na,np,ni,nf,nm,nt,AxdPot,PBN,MiPBN,MxPBN,e,b1,a1,f1,...
    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,...
    E,bf,Qo,aQo,aQr,Sp,kc,r,pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,...
    mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH,...
    TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob)

    global USE_CPP;
    USE_CPP_OFF = 0;

    [NVAR,~]=size(chpm);
    % AA 27/05 DMS=0;
    % AA 27/05 WM=0;
    % AA 27/05 WPD=0;
    % AA 27/05 WDAT=0;
    % AA 27/05 WDD=0;
    % AA 27/05 WPAR=0;
    % WPAR = zeros(NVAR, N_iter+1);
    % AA 27/05 WDPAR=0;
    % AA 27/05 WEPAR=0;
    %WDEVPAR=0;
    % AA 27/05 ERR=0;
    %XPAR=0;
    % AA 27/05 NPAR=0;
    % MJ 18/10/19 Axdc = round (AxdPot + 0.499999);


    
        %NVAR=x;
        [WM,WPD,WO,DMS] = fit_targetQ(comp,T,mxTob,Tob,TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,...
            qaob,qpob,qicob,qfob,qmob,pa,pp,pe,pf,pm,pt);
        %%%%%%%%%% Array for GLSM
        WDAT=zeros(DMS,1);
        WDD=zeros(NVAR,NVAR);
        %WDPAR=zeros(NVAR,1);

        SPAR=[ 'xQo__'; 'xaQo_'; 'xr___'; 'xSp__'; 'xpp__'; 'xpe__'; ...
            'xpc__'; 'xpf__'; 'xpm__'; 'xpt__'; 'xkpc_'; 'xkpa_'; ...
            'xkpe_'; 'ca___'; 'cp___'; 'ci___'; 'c1___'; 'c2___'; ...
            'x19__'; 'x20__'; 'x21__'; 'x22__'; 'x23__'; 'x24__'; ...
            'xBa1_'; 'xBp1_'; 'xBi1_'; 'xBf1_'; 'xBm1_'; 'xBt1_'; ...
            'xBa2_'; 'xBp2_'; 'xBi2_'; 'xBf2_'; 'xBm2_'; 'xBt2_';] ;

        % AA 27/05 ERR=0;
        % Variable transfert%
        A = zeros(NVAR,1);

        %pa=1;% fixed
        A(1) = Qo;   A(2) = aQo;  A(3) = r;    A(4) = Sp;   A(5) = pp;   A(6) = pe;
        A(7) = pc;   A(8) = pf;   A(9) = pm;   A(10) = pt;  A(11) = kpc; A(12) = kpa;
        A(13) = kpe; A(14) = ca;  A(15) = cp;  A(16) = ci;  A(17) = c1;  A(18) = c2;
        %A(19) = 0;   A(20) = 0;   A(21) = 0;   A(22) = 0;   A(23) = 0;   A(24) = 0;
        A(25) = Ba1; A(26) = Bp1; A(27) = Bi1; A(28) = Bf1; A(29) = Bm1; A(30) = Bt1;
        A(31) = Ba2; A(32) = Bp2; A(33) = Bi2; A(34) = Bf2; A(35) = Bm2; A(36) = Bt2;

        % Check function for parameters selection
        [W1PAR,WDPAR,WEPAR,WPRK,NPAR] = fit_lsqr_par(NVAR,chpm,A,0.1);
        WPAR = zeros(NPAR, N_iter+1);
        WPAR(:,1) = W1PAR(:); % starting values
        %if NPAR == 0
        if Lsqr == 0 || NPAR == 0
            N_iter=1;
        end

    

    % *************************
    % *LOOP for iterations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iter = 1 : N_iter% Loop for accuracy on the fitted parameters,iter-----grad
       % deriv = NPAR+1;
%         if iter > 1
%             deriv = NPAR+1;
%         end
% 
%         % *************************
%         % LOOP for derivatives
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         if iter == N_iter
%             deriv =1;
%         end
        prevpar = 1;
        for par = 1 : NPAR+1 % Loop for the derivative of least square method,pass-----pass
            
            % affectation
            Qo = A(1);   aQo = A(2);  r = A(3);    Sp = A(4);   pp = A(5);   pe = A(6);
            pc = A(7);   pf = A(8);   pm = A(9);   pt = A(10);  kpc = A(11); kpa = A(12);
            kpe = A(13); ca = A(14);  cp = A(15);  ci = A(16);  c1 = A(17);  c2 = A(18);
            %x19 = A(19); x20 = A(20); x21 = A(21); x22 = A(22); x23 = A(20); x24 = A(24);
            Ba1 = A(25); Bp1 = A(26); Bi1 = A(27); Bf1 = A(28); Bm1 = A(29); Bt1 = A(30);
            Ba2 = A(31); Bp2 = A(32); Bi2 = A(33); Bf2 = A(34); Bm2 = A(35); Bt2 = A(36);
            

            [WM,WPD,x,Dt,Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,Ba,Bp,Bi,Bc,Bf,Bm,Bt,...
                qat,qpt,qict,qft,qmt,qdict,qlit,qdat,qlat,qdft,qlft,qdmt,qlmt,...
                Qo,Sp,r,pp,pe,pc,pf,pm,pt,kpc,kpa,kpe,ca,cp,ci,...
                Ba1,Bp1,Bi1,Bf1,Bm1,Bt1,Ba2,Bp2,Bi2,Bf2,Bm2,Bt2]=...
                fit_GL(modH,Lsqr,par,WDAT,WM,WPD,comp,T,Tm,mxTob,Tob,...
                tfa,tfp,tfi,tff,tfm,tft,txa,txp,txi,txc,txf,txm,txt,mtxa,mtxp,mtxi,mtxc,mtxf,mtxm,mtxt,...
                na,np,ni,nf,nm,nt,AxdPot,PBN,MiPBN,MxPBN,e,b1,a1,f1,...
                Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,...
                E,bf,Qo,aQo,aQr,Sp,kc,r,pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,...
                mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH,...
                TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob);


               % Restore processed parameter to its latest value
              if NPAR > 0 
                A(WPRK(prevpar)) = WPAR(prevpar,iter);
              end
              % applied local deviation to the next current parameter
              if par <= NPAR
                  A(WPRK(par)) = WPAR(par,iter) + WEPAR(par);
                  prevpar = par;  % par was changed
              end           
            
            
        end % for pass = 1:NPAR+1. All the derivatives are done
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %if  par > 1 && Lsqr == 1
        if  Lsqr == 1
            [W1DPAR,WDD,ERR] = fit_lsqr_main(x,NPAR,WM,WEPAR,WPD);
            WDPAR(1:NPAR,1) = W1DPAR(1:NPAR,1); % starting values
        end


          % Show current parameter values
          fprintf(1,' %d ',iter);
          for i = 1 : NPAR
              fprintf(1,' %g ',WPAR(i,iter));
          end
          fprintf(1,' error = %g \n',ERR);
          
          % Apply parameter deviation for next iteration
          % and store the changed parameter value
          if iter < N_iter
              for ip = 1 : NPAR
                  WPAR(ip,iter+1) = WPAR(ip,iter) + WDPAR(ip);
                  A(WPRK(ip)) = WPAR(ip,iter+1);
              end
          end
                                

    end % for iter =1 :N_iter

    if Lsqr == 0
        MesO=0;
        MesS=0;
        MesT=0;
    end

    if Lsqr == 1 && iter > 0

        % %********************************************
        % % estimation of the variances for parameters
        % %*********************************************
        % % computing total variation (Y'.W.Y)

        STDV = zeros(NPAR,1);
        S2M = 0;
        for i = 1 : DMS
            S2M = S2M + (WM(i, 1) - WM(i, 2))*WPD(i,1) * (WM(i, 1) - WM(i, 2));
        end
        S2M = S2M / (DMS - NPAR);
        for i = 1 : NPAR
            STDV(i) = sqrt(S2M * WDD(i, i));
        end

        % Print Parameter value and deviation
        fprintf(1,'\nFitted Parameter values. Error: %g \n',ERR);
        for i = 1 : NPAR
            fprintf(1,' %s:%g ',SPAR(WPRK(i),:), WPAR(i,N_iter));
        end
        fprintf(1,'\nFitted Parameter standard deviation \n');
        for i = 1 : NPAR
            fprintf(1,' %s:%g ',SPAR(WPRK(i),:), STDV(i));
        end
        fprintf(1,' \n');

  
        % WDPAR=zeros(NPAR,1);
        % to test fitting conputed data versus observed data
        MesO(:,1) = WM(:,1).*WPD(:,1);  % Observed measurements
        MesS(:,1) = WM(:,2).*WPD(:,1);  % Simulated measurements
        MesT(:,1) = WO(:,1);   % Organ type (1 to 9 at compartment level), (11 to 19 at phytomer level)
    end
  
end

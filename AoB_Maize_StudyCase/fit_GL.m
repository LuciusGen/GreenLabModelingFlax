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

function [WM,WPD,x,Dt,Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,Ba,Bp,Bi,Bc,Bf,Bm,Bt,...
    qat,qpt,qict,qft,qmt,qdict,qlit,qdat,qlat,qdft,qlft,qdmt,qlmt,...
    Qo,Sp,r,pp,pe,pc,pf,pm,pt,kpc,kpa,kpe,ca,cp,ci,...
    Ba1,Bp1,Bi1,Bf1,Bm1,Bt1,Ba2,Bp2,Bi2,Bf2,Bm2,Bt2]=...
    fit_GL(modH,Lsqr,pass,WDAT,WM,WPD,comp,T,Tm,mxTob,Tob,...
    tfa,tfp,tfi,tff,tfm,tft,txa,txp,txi,txc,txf,txm,txt,mtxa,mtxp,mtxi,mtxc,mtxf,mtxm,mtxt,...
    na,np,ni,nf,nm,nt,AxdPot,PBN,MiPBN,MxPBN,e,b1,a1,f1,...
    Ba1,Ba2,Bp1,Bp2,Bi1,Bi2,Bc1,Bc2,Bf1,Bf2,Bm1,Bm2,Bt1,Bt2,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,...
    E,bf,Qo,aQo,aQr,Sp,kc,r,pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,...
    mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH,...
    TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,qaob,qpob,qicob,qfob,qmob)

global USE_CPP;
USE_CPP_OFF = 0;


          
          %sink variation function
          if USE_CPP
              [Ba] = CPPGrowth_Beta2(T,txa,Ba1,Ba2); % Beta law for blade
              [Bp] = CPPGrowth_Beta2(T,txp,Bp1,Bp2); % Beta law for petiol
              [Bi] = CPPGrowth_Beta2(T,txi,Bi1,Bi2); % Beta law for internode
              [Bc] = CPPGrowth_Beta2(T,txc,Bc1,Bc2); % Beta law for ring
              [Bf] = CPPGrowth_Beta2(T,txf,Bf1,Bf2); % Beta law for female fruit
              [Bm] = CPPGrowth_Beta2(T,txm,Bm1,Bm2); % Beta law for male fruit
              [Bt] = CPPGrowth_Beta2(T,txt,Bt1,Bt2); % Beta law for tape root
          else
              
              [Ba] = Growth_Beta(T,txa,mtxa,Ba1,Ba2); % Beta law for blade
              [Bp] = Growth_Beta(T,txp,mtxp,Bp1,Bp2); % Beta law for petiol
              [Bi] = Growth_Beta(T,txi,mtxi,Bi1,Bi2); % Beta law for internode
              [Bc] = Growth_Beta(T,txc,mtxc,Bc1,Bc2); % Beta law for ring
              [Bf] = Growth_Beta(T,txf,mtxf,Bf1,Bf2); % Beta law for female fruit
              [Bm] = Growth_Beta(T,txm,mtxm,Bm1,Bm2); % Beta law for male fruit
              [Bt] = Growth_Beta(T,txt,mtxt,Bt1,Bt2); % Beta law for tape root

          end
       
          % Compute Demand
          %
          Dt=zeros(T,1);
          Slat=zeros(T,T);       
          D_rings = zeros(T,1);
          
          %fprintf (1,'CG  Total  Leaf   Petiol   Internode   FruitF   FruitM   Rings   TapeRoot   pq\n');
          
          for i = 1 : T
              if USE_CPP 
                  % leaf demand
                  D_blade = CPPOrgan_DemandFit(i,na,nf,1,pa,kpa,Ba,Dla,AxdPot,T);
                  % petiol demand
                  D_petiol = CPPOrgan_DemandFit(i,np,nf,1,pp,kpa,Bp,Dlp,AxdPot,T);
                  %internode demand
                  D_internode = CPPOrgan_DemandFit(i,ni,nf,1,pe,kpe,Bi,Dli,AxdPot,T);
                  % female fruit demand
                  D_ffruit = CPPOrgan_DemandFit(i,nf,nf,bf,pf,1,Bf,Dlf,AxdPot,T);
                  % male fruit demand
                  D_mfruit = CPPOrgan_DemandFit(i,nm,nf,1,pm,1,Bm,Dlm,AxdPot,T);          
                  %ring demand && leaf seen
              else
                  % leaf demand
                  D_blade = Organ_DemandFit(i,na,nf,1,pa,kpa,Ba,Dla,AxdPot);
                  % petiol demand
                  D_petiol = Organ_DemandFit(i,np,nf,1,pp,kpa,Bp,Dlp,AxdPot);
                  %internode demand
                  D_internode = Organ_DemandFit(i,ni,nf,1,pe,kpe,Bi,Dli,AxdPot);
                  % female fruit demand
                  D_ffruit = Organ_DemandFit(i,nf,nf,bf,pf,1,Bf,Dlf,AxdPot);
                  % male fruit demand
                  D_mfruit = Organ_DemandFit(i,nm,nf,1,pm,1,Bm,Dlm,AxdPot);          
                  %ring demand && leaf seen
              end
              if pc > 0
                  Lat = zeros(T,1);
                  if (i > tfa)
                      i0 = i - tfa + 1;
                  else
                      i0 = 1;
                  end
                  for j = i0 : i
                      Lat(j) = na(i)*AxdPot(j);
                      D_rings(i) = D_rings(i) + pc*Lat(j);
                  end
                  if i < Dlc
                     D_rings(i) = 0;
                  end
                  for j = 1 : i
                      Slat(i,j) = sum(Lat(j:i));% sum of leaf seen from rank of phytomer
                  end
              end
              % tape root demand
              D_root = 0;
              if i > Dlt
                  D_root = pt * Bt(1,i-Dlt);
              end
              % total demand (+tape_root + pool)
              Dt(i) = D_blade + D_petiol +D_internode + D_ffruit + D_mfruit +D_rings(i)+ D_root + pq;%

          end
          %i=T;
          %fprintf (1,'%d) %g   %g   %g   %g   %g   %g   %g   %g   %g\n', i, Dt(i),D_blade,D_petiol,D_internode,D_ffruit,D_mfruit,D_rings(i),D_root,pq);
               
          
          %%%%%%%%%%%%%%%%%%%%%%%%%
          % GROWTH computation and data results storages Size of organs
          %%%%%%%%%%%%%%%%%%%%%%%
          if USE_CPP
              [Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,...
                  qat,qpt,qict,qft,qmt,qlit,qdict,qdat,qlat,qdft,qlft,qdmt,qlmt] = CPPGrowth_Fit(modH,T,Tm,Dt,D_rings,Slat,...
                  tfa,tfp,tfi,tff,tfm,tft,na,np,ni,nf,nm,nt,Ba,Bp,Bi,Bc,Bf,Bm,Bt,Dla,Dlp,Dli,Dlc,Dlf,Dlm,Dlt,......
                  AxdPot,b1,a1,f1,E,bf,Qo,aQo,aQr,e,Sp,kc,r,...
                  pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH);
          else
              [Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,...
                  qat,qpt,qict,qft,qmt,qlit,qdict,qdat,qlat,qdft,qlft,qdmt,qlmt] = Growth_Fit(modH,T,Tm,Dt,D_rings,Slat,...
                  tfa,tfp,tfi,tff,tfm,na,np,ni,nf,nm,Ba,Bp,Bi,Bf,Bm,Bt,Dla,Dlp,Dli,Dlf,Dlm,Dlt,......
                  AxdPot,b1,a1,f1,E,bf,Qo,aQo,aQr,e,Sp,kc,r,...
                  pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH);
          end
          
          % MJ 18/10/19
          Axdc = round (AxdPot + 0.499999);
          [qat,qpt,qict,qft,qmt]=...
              Growth_Ax_Sorta (T,Axdc,PBN,MiPBN,MxPBN,nf,nm,pp,pe,pf,pm,qat,qpt,qict,qft,qmt);
          %
          [moTQAt,moTQPt,moTQICt,moTQFt,moTQMt,moTQTt,moqat,moqpt,moqict,moqft,moqmt]=...
              Growth_Obs( Lsqr,comp,T,mxTob,Tob,TQAt,TQPt,TQICt,TQFt,TQMt,TQTt,...
              qat,qpt,qict,qft,qmt,TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,...
              qaob,qpob,qicob,qfob,qmob,pp,pe,pc,pf,pm);
          % store the computed data for glsqr
          
              [WM,WPD,x]=fit_targetQ_update(pass,comp,T,mxTob,Tob,...
                  moTQAt,moTQPt,moTQICt,moTQFt,moTQMt,moTQTt,...
                  moqat,moqpt,moqict,moqft,moqmt,...
                  TQAob,TQPob,TQICob,TQFob,TQMob,TQTob,...
                  qaob,qpob,qicob,qfob,qmob,...
                  pa,pp,pe,pc,pf,pm,pt,WDAT,WM,WPD);
          



end

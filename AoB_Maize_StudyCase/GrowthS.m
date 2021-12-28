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

function [TQ,TQB,QS,TQA,TQP,TQI,TQIC,TQF,TQM,TQT,TQTS,TQR,...
    qas,qps,qis,qics,qfs,qms,qdics,qlis,qdas,qlas,qdfs,qlfs,qdms,qlms,...
    qasm,qpsm,qesm,qicsm,qfsm,qmsm] = GrowthS(modH,T,Tm,N,Ds,Dcs,SLas,...
    tfa,tfp,tfi,tff,tfm,na,ni,nf,nm,Ba,Bp,Be,Bf,Bm,Bt,...
    Dla,Dlp,Dle,Dlf,Dlm,Dlt,Axdc,e,b1,a1,f1,E,Qo,aQo,aQr,Sp,kc,r,...
     pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,mna,ca,mnp,cp,mne,ci,...
     c1,c2,Hmx,Hmn,H1,psi,DH)
 
 
% Cumulative arrays
Tmax = T;

TQ = zeros(Tmax,1);
TQB = zeros(Tmax,1);

TQA = zeros(Tmax,1);   
TQP = zeros(Tmax,1);
TQI = zeros(Tmax,1);   
TQC = zeros(Tmax,1);     
TQIC = zeros(Tmax,1);  
TQT = zeros(Tmax,1);   
TQR = zeros(Tmax,1);
TQF = zeros(Tmax,1);   
TQM = zeros(Tmax,1);

Qmobs=zeros(Tmax,N);

% rings
QCs=zeros(Tmax,N);
DC1s=zeros(Tmax,N);
DC2s=zeros(Tmax,N);

%hydro
HS=zeros(Tmax,N);

% Cumulative (growth cycle and stochastic number)
QS=zeros(Tmax,N);
TQBS=zeros(Tmax,N);
TQAS=zeros(Tmax,N);
TQPS=zeros(Tmax,N);
TQES=zeros(Tmax,N);
TQCS=zeros(Tmax,N);
TQFS=zeros(Tmax,N);
TQMS=zeros(Tmax,N);
TQTS=zeros(Tmax,N);
TQRS=zeros(Tmax,N);


qas=zeros(Tmax,Tmax,N); %mxqas=zeros(T,T,N);% biomass leaf
qasm=zeros(Tmax,Tmax); 
nqasm=zeros(Tmax,Tmax);% mean of chronological and item number
qps=zeros(Tmax,Tmax,N); %mxqps=zeros(T,T,N);
qpsm=zeros(Tmax,Tmax); %biomass petiol
qis=zeros(Tmax,Tmax,N); %mxqes=zeros(T,T,N);
qcs=zeros(Tmax,Tmax,N);
qics=zeros(Tmax,Tmax,N); 
qdics=zeros(Tmax,Tmax,N);% biomass internode
qesm=zeros(Tmax,Tmax); 
nqesm=zeros(Tmax,Tmax); 
qicsm=zeros(Tmax,Tmax); 
nqicsm=zeros(Tmax,Tmax);
qfs=zeros(Tmax,Tmax,N); %mxqfs=zeros(T,T,N);
qms=zeros(Tmax,Tmax,N); %mxqms=zeros(T,T,N);% biomass fuit fem and mal
qfsm=zeros(Tmax,Tmax); 
nqfsm=zeros(Tmax,Tmax); 
qmsm=zeros(Tmax,Tmax); 
nqmsm=zeros(Tmax,Tmax);%


SAS=zeros(Tmax,N);%leaf surface


qlis=zeros(Tmax,Tmax,N); 
qdis=zeros(Tmax,Tmax,N);
qlas=zeros(Tmax,Tmax,N); 
qdas=zeros(Tmax,Tmax,N);
qlfs=zeros(Tmax,Tmax,N); 
qdfs=zeros(Tmax,Tmax,N);
qlms=zeros(Tmax,Tmax,N); 
qdms=zeros(Tmax,Tmax,N);


    for i = 1 : T

        for s = 1 : N

            is = (s-1)*Tmax + i;
            
            Di_s = Ds(is);
            SAS(i,s) = 0.0;

            if  i > 1
                Qim_s = QS(is-1);
            else
                Qim_s = Qo*aQo;
            end

            if Di_s > 0
                Q_D = Qim_s / Di_s;
                Qmob_is = Qmobs(is);

                %Leaf growth
                [qas,qasm,nqasm,Qmob_is,TQAS(is)]=...
                    Organ_GrowthS(Q_D,qas,qasm,nqasm,Qmob_is,i,Axdc,...
                    tfa,mna,ca,na,nf,pa,kpa,Ba, Dla,TQAS(is),Tmax,s);
                
                %Petiol growth
                [qps,qpsm,nqasm,Qmob_is,TQPS(is)]=...
                    Organ_GrowthS(Q_D,qps,qpsm,nqasm,Qmob_is,i,Axdc,...
                    tfp,mnp,cp,na,nf,pp,kpa,Bp,Dlp,TQPS(is),Tmax,s);

                % internode growth (pith)
                [qis,qesm,nqesm,Qmob_is,TQES(is)]=...
                    Organ_GrowthS(Q_D,qis,qesm,nqesm,Qmob_is,i,Axdc,...
                    tfi,mne,ci,ni,nf,pe,kpe,Be,Dle,TQES(is),Tmax,s);
                
                % female fruit growth               % fruits have no remobilisation
                [qfs,qfsm,nqfsm,Qmob_is,TQFS(is)]=...
                    Organ_GrowthS(Q_D,qfs,qfsm,nqfsm,Qmob_is,i,Axdc,...
                    tff,0,0,nf,nf,pf,1,Bf,Dlf,TQFS(is),Tmax,s);
                
                % male fruit growth               % fruits have no remobilisation
                [qms,qmsm,nqmsm,Qmob_is,TQMS(is)]=...
                    Organ_GrowthS(Q_D,qms,qmsm,nqmsm,Qmob_is,i,Axdc,...
                    tfm,0,0,nm,nf,pm,1,Bm,Dlm,TQMS(is),Tmax,s);
                               

                if pc > 0
                    QCs(is)  = Dcs(is) * Q_D;%%rings compartment
                    TQCS(is) = QCs(is);
                    if i > 1
                        TQCS(is) = TQCS(is) + TQCS(is-1);
                    end
                end            

                if pq > 0           % total biomass common pool
                    TQRS(is) = pq * Q_D; % total biomass common pool                    
                    if i > 1
                        TQRS(is) = TQRS(is-1) + TQRS(is);
                    end
                end

                if pt > 0 && i > Dlt % Tape root% total biomass tape root
                    TQTS(is) = pt * Bt(1,i-Dlt) * Q_D; 
                    if i > 1
                        TQTS(is) = TQTS(is-1) + TQTS(is); 
                    end
                end           


                % Update leaf surface for photosynthesis
                im = i; % the older cycle to consider
                if i > Tm
                    im = Tm;
                end  
                k = 1; % the first cycle to consider
                if i > tfa
                    k = i-tfa+1;
                end
                for j = k : im
                    SAS(is) = SAS(is) + na(j,s) * qas(i,j,s) / e;
                end            

                Sf = SAS(is); % First cycle case 
                if i > 1
                    Sf = Sp * (1-exp(-kc*(SAS(is)/Sp)));%% surface feuilles actives           
                end

                dQr = 0.0;
                if i > 1 && (SAS(is) == 0 || E(i) == 0) % no photosynthesis but common pool can remobilize biomass
                    dQr = TQRS(is) * aQr;
                    TQRS(is) = TQRS(is) - dQr;
                end

                dQo = 0.0; % Seed Default case 
                if i > 1 && aQo < 1 % Seed empties
                    dQo = Qo * aQo * (1-aQo)^(i-1); 
                end

                %Total Biomass
                TQBS(is) = TQAS(is) + TQPS(is) + TQES(is) + TQCS(is) +...
                        TQFS(is) + TQMS(is) + TQTS(is) + TQRS(is);

                % hydrology
                Rue = 1/r; % Default mode no hydrology
                if modH ~= 0   % With hydrology
                    if i > 1
                        HH = HS(is-1);
                    else
                        HH = H1;
                    end
                    HNew = HH - (Sf/Sp) * c1 * (HH-Hmn) + c2 * (Hmx-HH) * DH(i);
                    % bornes limites
                    if HNew > Hmx % point de ruissellement.
                        HNew = Hmx; %
                    end
                    if HNew < Hmn % point de fletrissement
                        HNew = Hmn;
                    end           
                    Rue =  c1 * (HH-Hmn)/psi;
                    HS(is) = HNew; %for the next cycle
                end

                QS(is) = (E(i) * Sf * Rue) + dQo + dQr + Qmob_is;
                Qmobs(i) = Qmob_is;        

            else
                if i > 1        % Di_s = 0 dead plant, to copy last organic series
                    qas(i,:,s) = qas(i-1,:,s);
                    qps(i,:,s) = qps(i-1,:,s);
                    qis(i,:,s) = qis(i-1,:,s);
                    qfs(i,:,s) = qfs(i-1,:,s);
                    qms(i,:,s) = qms(i-1,:,s);
                end
            end
            
        TQ(i)  = TQ(i) + QS(is);
        TQA(i) = TQA(i) + TQAS(is); 
        if (i > 1)
            TQB(i) = TQB(i) + TQBS(is);
        else
            TQB(i) = TQB(i) + QS(is);
        end
        TQP(i) = TQP(i) + TQPS(is);
        TQI(i) = TQI(i) + TQES(is);
        TQC(i) = TQC(i) + TQCS(is);
        TQF(i) = TQF(i) + TQFS(is);
        TQM(i) = TQM(i) + TQMS(is); 
        TQT(i) = TQT(i) + TQTS(is);
        TQR(i) = TQR(i) + TQRS(is);
        end
              
    TQ(i)  = TQ(i) / N;
    TQA(i) = TQA(i) / N;      
    TQB(i) = TQB(i) / N;
    TQP(i) = TQP(i) / N;
    TQI(i) = TQI(i) / N;
    TQC(i) = TQC(i) / N;
    TQIC(i)= TQI(i) + TQC(i);%pith+rings
    TQF(i) = TQF(i) / N;
    TQM(i) = TQM(i) / N; 
    TQT(i) = TQT(i) / N;
    TQR(i) = TQR(i) / N;
    fprintf(1,'C:%d  Biomass:%f(%f)  leaf:%f  internode:%f  rings:%f  ffruit:%f  roots:%f\n', i, TQ(i), TQB(i), TQA(i), TQI(i), TQIC(i), TQF(i), TQT(i));

    end
    i = T;
    fprintf(1,'\nFinal stage (%d reps) \nC:%d  Biomass:%f(%f)  leaf:%f  internode:%f  rings:%f  ffruit:%f  roots:%f\n', N, i, TQ(i), TQB(i), TQA(i), TQI(i), TQIC(i), TQF(i), TQT(i));
       
    % organ dimension for plant construction
    la_f1 = 1.0 / sqrt(e*f1);
    li_s1 = sqrt(b1);
    li_s2 = (1.0 + a1) / 2;
    si_1 = 4.0 / b1^0.5 / 3.14159265;
    si_2 = (1.0 - a1) / 2;
    dfm = 24 / (4 * 3.14159265);
    
    %sub2ind(size(A), i1, i2, i3). This is the equivalent expression:  i1 + (i2-1)*size(A,1) + (i3-1)*size(A,1)*size(A,2) 
    
    
    for s = 1 : N
        sind = (s-1)*Tmax;    
        for i = 1 : T
            is = sind + i;
            for j = 1 : i
                ij = (j-1)*Tmax + i;
                ijs = sind*Tmax + ij; 
                %blade
                qlas(ijs) = la_f1*sqrt(qas(ijs));
                qdas(ijs) = f1*qlas(ijs);
                %internode
                if pe > 0 && qis(ijs) > 0
                    qlis(ijs) = li_s1 * qis(ijs)^li_s2;% internode length
                    qdis(ijs) = sqrt ( si_1 * qis(ijs)^si_2 );% internode diameter
                else
                    qlis(ijs) = li_s1;
                    qdics(ijs) = 0.05 * li_s1;
                    qdis(ijs) = 0.05 * li_s1;
                end
                if pc > 0
                    DC1s(is) = DC1s(is) + sign(SLas(ijs)) * qlis(ijs);%kpc=0; 
                    DC2s(is) = DC2s(is) + SLas(ijs) * qlis(ijs); % %kpc=1 ring phytomer demand
                end
                % fruit
                if pf > 0
    %                 qlfs(i,j,s) = 2.0 * (qfs(i,j,s) * 3/(4*3.14))^(1/3);
                    qlfs(ijs) = (qfs(ijs) * dfm)^(1/3);
                    qdfs(ijs) = qlfs(ijs);
                end
                if pm > 0
    %                 qlms(i,j,s) = 2.0 * (qms(i,j,s) * 3/(4*3.14))^(1/3);
                    qlms(ijs) = (qms(ijs) * dfm)^(1/3);
                    qdms(ijs) = qlms(ijs);
                end
            end
        end
    end

    Srg = zeros(Tmax,Tmax);
    csi = 4.0 / 3.14159265;
    % computing ring along stem
    for s = 1 : N
        sind = (s-1)*Tmax; 
        if pc > 0    
            for i = 1 : T
                is = sind + i;
                ijs = sind*Tmax + i; 
                QC_DC1 = (1-kpc) * QCs(is) / DC1s(is);
                QC_DC2 = kpc * QCs(i) / DC2s(i);
                for j = 1 : i
                    qcs(ijs) = qlis(ijs) * sign(qis(ijs)) * ( sign(SLas(ijs))*QC_DC1 + SLas(ijs)*QC_DC2 );
                    if (i > 1)
                        Srg(i,j) = Srg(i-1,j) + qcs(ijs);
                    else
                        Srg(i,j) = qcs(ijs);
                    end
                    ijs = ijs + Tmax;
                end
            end
        end

        % ring stack
        for i = 1 : T
            for j = 1 : i
                ij = (j-1)*Tmax + i;
                ijs = sind*Tmax + ij;
                %SumRing = sum(qcs(1:i,j,s));
                %qics(ijs) = qes(ijs) + SumRing; % adding pith to ring stack
                qics(ijs) = qis(ijs) + Srg(ij); % adding pith to ring stack                
                qicsm(ij)  = qicsm(ij) + qics(ijs);
                nqicsm(ij) = nqicsm(ij) + sign(qics(ijs));
                if pe > 0
                    if qlis(ijs) > 0 && qics(ijs) > 0
                        qdics(ijs) = sqrt(csi * qics(ijs) / qlis(ijs));% internode diameter
                    else
                        qdics(ijs) = qdis(ijs);% internode diameter
                    end
                end
            end
        end
    end

    % dead organic serie
    i = 1;
    while i < T
        i = i + 1;
        for s = 1 : N
            if Ds(i,s) == 0 % dead plant, to copy last organic series
%                 qas(i,:,s)  = qas(i-1,:,s);
%                 qps(i,:,s)  = qps(i-1,:,s);
%                 qes(i,:,s)  = qes(i-1,:,s);
                qics(i,:,s) = qics(i-1,:,s);
%                 qfs(i,:,s)  = qfs(i-1,:,s);
%                 qms(i,:,s)  = qms(i-1,:,s);
                qlis(i,:,s) = qlis(i-1,:,s);
                qdis(i,:,s) = qdis(i-1,:,s);
                qdics(i,:,s)= qdics(i-1,:,s);
                qlas(i,:,s) = qlas(i-1,:,s);
                qdas(i,:,s) = qdas(i-1,:,s);
                qlfs(i,:,s) = qlfs(i-1,:,s);
                qdfs(i,:,s) = qdfs(i-1,:,s);
                qlms(i,:,s) = qlms(i-1,:,s);
                qdms(i,:,s) = qdms(i-1,:,s);
            end
        end
    end

 
    % average simulated organic series
    for i = 1 :T
        for j = 1 : i
            ij = (j-1)*Tmax + i;
                            
            if nqasm(ij) > 0
                qasm(ij) = qasm(ij) / nqasm(ij);
            end
            if nqasm(ij) > 0 && pp > 0
                qpsm(ij) = qpsm(ij) / nqasm(ij); % nb petiol= nb blade
            end
            if nqesm(ij) > 0
                qesm(ij) = qesm(ij) / nqesm(ij);
            end
            if pc > 0
                if nqicsm(ij) > 0
                    qicsm(ij) = qicsm(ij) / nqicsm(ij);
                end
            end
            if nqfsm(ij) > 0 && pf > 0
                qfsm(ij) = qfsm(ij) / nqfsm(ij);
            end
            if nqmsm(ij) > 0 && pm > 0
                qmsm(ij) = qmsm(ij) / nqmsm(ij);
            end
        end
    end

end


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


function [Qt,TQt,TQAt,TQPt,TQICt,TQFt,TQMt,TQRt,TQTt,...
    qat,qpt,qict,qft,qmt,qlit,qdict,qdat,qlat,qdft,qlft,qdmt,qlmt] = Growth_Fit (modH,T,Tm,Dt,Dct,Slat,...
    tfa,tfp,tfi,tff,tfm,na,np,ni,nf,nm,Ba,Bp,Bi,Bf,Bm,Bt,Dla,Dlp,Dli,Dlf,Dlm,Dlt,......
    AxdPot,b1,a1,f1,E,bf,Qo,aQo,aQr,e,Sp,kc,r,pa,pp,pe,pc,pf,pm,pq,pt,kpc,kpa,kpe,...
    mna,ca,mnp,cp,mni,ci,c1,c2,Hmx,Hmn,H1,psi,DH)
%array declaration
Tmax = T;
% Biomass production
Qt=zeros(Tmax,1);
QTt=zeros(Tmax,1);
QRt=zeros(Tmax,1);
QCt=zeros(Tmax,1);

% cumul
TQt=zeros(Tmax,1);
Qmob=zeros(Tmax,1);
TQAt=zeros(Tmax,1);
TQPt=zeros(Tmax,1);
TQIt=zeros(Tmax,1);
TQCt=zeros(Tmax,1);
TQICt=zeros(Tmax,1);
TQFt=zeros(Tmax,1);
TQMt=zeros(Tmax,1);
TQTt=zeros(Tmax,1);
TQRt=zeros(Tmax,1);

SAT=zeros(Tmax,1);

qat=zeros(Tmax,Tmax); 
qpt=zeros(Tmax,Tmax);
qit=zeros(Tmax,Tmax); 
DC1t=zeros(Tmax,1);
DC2t=zeros(Tmax,1);
qct=zeros(Tmax,Tmax);
qict=zeros(Tmax,Tmax);
qft=zeros(Tmax,Tmax); 
qmt=zeros(Tmax,Tmax); 
qlat=zeros(Tmax,Tmax);
qdat=zeros(Tmax,Tmax);
qlit=zeros(Tmax,Tmax);
qdit=zeros(Tmax,Tmax);
qdict=zeros(Tmax,Tmax);
qlft=zeros(Tmax,Tmax);
qdft=zeros(Tmax,Tmax);
qlmt=zeros(Tmax,Tmax);
qdmt=zeros(Tmax,Tmax);


AxdPfru = bf*AxdPot;

HH = H1; %hydrology
   
    for i = 1 : Tmax

        D_i = Dt(i);
        SAT(i) = 0.0;

        if D_i > 0
            % Computes the Q/D ratio
            %
            if (i > 1)
                Q_D = Qt(i-1) / D_i;
            else
                Q_D = Qo*aQo / D_i;
            end
            Qmob_i = Qmob(i);

            %Leaf growth
            [qat,Qmob_i,TQAt(i)] = Organ_GrowthFit(Q_D,qat,Qmob_i,...
                i,AxdPot,tfa,mna,ca,na,nf,pa,kpa,Ba,Dla,TQAt(i),Tmax,1);

            % petiol growth 
            [qpt,Qmob_i,TQPt(i)] = Organ_GrowthFit(Q_D,qpt,Qmob_i,...
                i,AxdPot,tfp,mnp,cp,np,nf,pp,kpa,Bp,Dlp,TQPt(i),Tmax,1);

            % internode growth
            [qit,Qmob_i,TQIt(i)] = Organ_GrowthFit(Q_D,qit,Qmob_i,...
                i,AxdPot,tfi,mni,ci,ni,nf,pe,kpe,Bi,Dli,TQIt(i),Tmax,1);

            % fem fruit growth
            [qft,Qmob_i,TQFt(i)] = Organ_GrowthFit(Q_D,qft,Qmob_i,...
                i,AxdPfru,tff,0,0,nf,nf,pf,1,Bf,Dlf,TQFt(i),Tmax,1);

            % male fruit growth
            [qmt,Qmob_i,TQMt(i)] = Organ_GrowthFit(Q_D,qmt,Qmob_i,...
                i,AxdPot,tfm,0,0,nm,nf,pm,1,Bm,Dlm,TQMt(i),Tmax,1);

            if pc > 0           % ring growth
                QCt(i)  = Dct(i) * Q_D;
                TQCt(i) = QCt(i);
                if i > 1
                    TQCt(i) = TQCt(i) + TQCt(i-1);
                end
            end
            TQICt(i) = TQIt(i) + TQCt(i);%pith+ring

            if pq > 0           % common pool
                QRt(i)  = pq * Q_D;
                TQRt(i) = QRt(i);
                if i > 1
                    TQRt(i) = TQRt(i) + TQRt(i-1);
                end            
            end

            if pt > 0 && i > Dlt % root growth
                QTt(i)  = pt*Bt(1,i-Dlt) * Q_D; 
                TQTt(i) = QTt(i);
                if i > 1
                    TQTt(i) = TQTt(i) + TQTt(i-1);
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
                SAT(i) = SAT(i) + AxdPot(j) * na(j) * qat(i,j) / e;
            end

            Sf = SAT(i);      % First cycle case  
            if i > 1            % biomass production Beer Law
                Sf = Sp * (1 - exp( -kc * (SAT(i)/Sp) ) );
            end        

            dQr = 0; % Default Reserve Pool case
            if i > 1 && (SAT(i) == 0 || E(i) == 0)  % No growth no leaves, Pool reserve remobilze 
                dQr = TQRt(i) * aQr;
                TQRt(i) = TQRt(i) - dQr;
            end

            % total biomass shared in compartments TQt(i)
            TQt(i) = TQAt(i) + TQPt(i) + TQIt(i) + TQCt(i)+...
                    + TQFt(i) + TQMt(i) + TQTt(i) + TQRt(i);

            dQo = 0.0; % Seed Default case 
            if i > 1 && aQo < 1 % Seed empties
                dQo = Qo * aQo * (1-aQo)^(i-1); 
            end

            % hydrology
            Rue = 1/r; % Default mode no hydrology

            if modH ~= 0   % With hydrology
                HNew = HH - (Sf/Sp) * c1 * (HH-Hmn) + c2 * (Hmx-HH) * DH(i);
                % bornes limites
                 if HNew > Hmx % point de ruissellement.
                    HNew = Hmx; %
                end
                if HNew < Hmn % point de fletrissement
                    HNew = Hmn;
                end
                Rue =  c1 * (HH-Hmn)/psi;
                HH = HNew; %for the next cycle
            end

            Qt(i)=(E(i) * Sf * Rue) + dQo + dQr + Qmob_i; 
            Qmob(i) = Qmob_i;
        end

        if i > 1 && Dt(i) == 0 % dead plant, to copy last organic series
            qat(i,:)= qat(i-1,:);
            qpt(i,:)= qpt(i-1,:);
            qit(i,:)= qit(i-1,:);
            qft(i,:)= qft(i-1,:);
            qmt(i,:)= qmt(i-1,:);
        end

    end

    % organ dimension theory
    la_f1 = 1.0 / (e*f1);
    li_s1 = sqrt(b1);
    li_s2 = (1.0 + a1) / 2;
    si_1 = 1.0 / b1^0.5;
    si_2 = (1.0 - a1) / 2;
    dfm = 24 / (4 * 3.14159265);
    for i = 1 : Tmax
        ij = i;
        for j = 1 : i
            %ij = (j-1)*Tmax + i;
            %blade flat shape
            %qlat(i,j) = (qat(i,j)/(e*f1))^0.5;
            qlat(ij) = sqrt(qat(ij)*la_f1);
            qdat(ij) = f1*qlat(ij);
            %internode cylinder shape
            %qlit(i,j) = b1^0.5 * qit(i,j)^((1+a1)/2);% internode length
            qlit(ij) = li_s1 * qit(ij)^li_s2;% internode length
            if pe == 0
                qdict(ij) = 0.05 * qlit(ij);
            end
            %Si = (1/b1^0.5)*qit(i,j)^((1-a1)/2);% internode section
            Si = si_1 * qit(ij)^si_2;% internode section
            qdit(ij) = 2 * sqrt( Si /3.14159265);% internode diameter
            if pc > 0
                DC1t(i) = DC1t(i) + sign(Slat(ij)) * qlit(ij);%kpc=0;
                DC2t(i) = DC2t(i) + Slat(ij) * qlit(ij); % %kpc=1 ring phytomer demand
            end
            % fruit sphere shape
            if pf > 0
                qlft(ij) = (qft(ij) * dfm )^(1/3);
                qdft(ij) = qlft(ij);
            end
            if pm > 0
                qlmt(ij) = (qmt(ij) * dfm)^(1/3);
                qdmt(ij) = qlmt(ij);
            end
            ij = ij + Tmax;
        end
    end

    Srg = zeros(Tmax,Tmax);
    if pc > 0
        % computing ring along stem
        for i = 1 : Tmax
            QC_DC1 = (1-kpc) * QCt(i) / DC1t(i);
            QC_DC2 = kpc * QCt(i) / DC2t(i);
            ij = i;
            for j = 1 : i
                %ij = (j-1)*Tmax + i;
    %             qct(i,j) = (1-kpc) * sign(Slat(i,j)) * qlit(i,j) * sign(qit(i,j)) * QCt(i,1) / DC1t(i,1)+...
    %                 kpc * Slat(i,j) * qlit(i,j) * sign(qit(i,j)) * QCt(i,1) / DC2t(i,1); 
                qct(ij) = qlit(ij) * sign(qit(ij)) * (sign(Slat(ij)) * QC_DC1  +  Slat(ij) * QC_DC2 );
                if (i > 1)
                    Srg(i,j) = Srg(i-1,j) + qct(ij);
                else
                    Srg(i,j) = qct(ij);
                end
                ij = ij + Tmax;
            end
        end
    end
    % pith+rings
    if pe > 0
        csi = 4.0 / 3.14159265;
        for i = 1 : Tmax
            ij = i;
            for j = 1 : i
                %ij = (j-1)*Tmax + i; 
%                SumRing = sum(qct(1:i,j));       
%                qict(ij) = qit(ij) + SumRing; % adding pith to ring stack
                qict(ij) = qit(ij) + Srg(i,j); % adding pith to ring stack                
                if qlit(ij) > 0 && qict(ij) > 0
                    Si = csi * qict(ij) / qlit(ij);
                    qdict(ij) = sqrt( Si );% internode diameter
                else
                    qdict(ij) = qdit(ij);% internode diameter
                end
                ij = ij + Tmax;
            end
        end
    end

% dead organic serie
    for i = 1 : Tmax
        if i > 1 && Dt(i) == 0 % dead plant, to copy last organic series
            qict(i,:)= qict(i-1,:);
            qlat(i,:)= qlat(i-1,:);
            qdat(i,:)= qdat(i-1,:);
            qlit(i,:)= qlit(i-1,:);
            qdit(i,:)= qdit(i-1,:);
            qdict(i,:)= qdict(i-1,:);
            qlft(i,:)= qlft(i-1,:);
            qdft(i,:)= qdft(i-1,:);
            qlmt(i,:)= qlmt(i-1,:);
            qdmt(i,:)= qdmt(i-1,:);    
        end
    end

end

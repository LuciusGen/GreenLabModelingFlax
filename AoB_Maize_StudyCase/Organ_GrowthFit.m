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


function [qo,Qmob_i,TQo_i] = Organ_GrowthFit(Q_D,qo,Qmob_i,i,AxdPot,tfo,nmo,co,no,nf,po,kpo,Bo,Dlo,TQo_i,dim,s)
% function  [qo,mxqo,Qmob_i,TQo_i] = Organ_GrowthFit(Q_D,qo,mxqo,Qmob_i,i,AxdPot,tfo,nmo,co,no,nf,po,kpo,Bo,Dlo,TQo_i)
%
% Organ growth at cycle i
%   I:   Q_D:    Plant Production on demand ratio 
%           production at previous cycle Q(i -1) or seed Qà*aQo / demand at cycle i
%   I:   i          : the cycle the computation applies to
%   I:   AcdPot(i)  : the potential axis of development
%   I:   tfo        : organ functioning duration time
%   I:   nmo        : remobilisation "intensity"
%   I:   co         : remobilisation coefficient (= 0: no remobilization)
%   I:   no(i)      : organ cohort occurences 
%   I:   nf(i)      : fruit cohort occurrences (make cause a feed back on sink multiplying it by kpo) 
%   I:   po         : sink function ratio (relative to leaf one)
%   I:   kpo        : sink ratio fruit feedback (if kpo > 0)
%   I:   Bo(j,Period): Sink variation BetaLaw 
%   I:   dim        : Table dimension 1  
%   I:   s          : Stochastic number (should be 1)
%   I&O: qo(i,j)    : organ production at cycle i when born at cycle j ( j <=i)
%   I&O: Qmob_i:    : Pool for remobilization at cycle i
%   I&O: TQo_i:     : Total organ biomass at cycle i
%
%
%   Last version 2018/11/22. Main author PdR/MJ. Copyright Cirad-AMAP
%
    if po > 0
        sdim = (s-1) * dim;

        por = po * Q_D;
        if (kpo > 0)
            pokpo = por*kpo;
        else
            pokpo = por;
        end

        if (i == 1)
            js = sdim + 1;
            ijs = sdim * dim + 1;

            % organ expansion first phytomer
            if  Dlo == 0
                if no(js) > 0
                    if AxdPot(js) > 0
                        if nf(js) > 0
                            qo_ijs = pokpo * Bo(1);
                        else
                            qo_ijs = por * Bo(1);
                        end
                    else
                        qo_ijs = 0;
                    end
                else
                    qo_ijs = qo(ijs);
                end
            else
                qo_ijs = qo(ijs);                
            end
            if qo_ijs > 0
                % MJ 18/10/19 TQo_i = TQo_i + AxdPot(j)* b2 * no(j)* qo(i,j); % global compartment
                TQo_i = TQo_i + AxdPot(js) * no(js)* qo_ijs; % global compartment bé allready in AxdPot
            else
                 qo_ijs = 0.0000001; % organ always exists
            end
            qo(ijs) = qo_ijs;
        else
            Dlo = i - Dlo;
            iDlo = Dlo;
            tfo = i + 1 - tfo;
            for j = 1 : i
                js = sdim + j;
                ijs = (js - 1) * dim + i;
                % organ expansion general case (i > 1)
                if  Dlo > 0
                    if no(js) > 0
                        if AxdPot(js) > 0
                            if nf(js) > 0
                                qo_ijs = qo(ijs-1) + pokpo * Bo(j,Dlo);
                            else
                                qo_ijs = qo(ijs-1) + por * Bo(j,Dlo);
                            end
                        else
                            qo_ijs = qo(ijs-1);
                        end
                    else
                        qo_ijs = qo(ijs);
                    end
                    Dlo = iDlo - j;
                else
                    qo_ijs = qo(ijs);
                end

                % MJ 18/10/19 if qo(i,j) > 0
                if qo_ijs > 0
                    % organ remobilisation
                    if co > 0 
                        if tfo-j > 0
                            qo_ijs = qo_ijs * (1-nmo*(1-(1-co)^(tfo-j)));
                            Qmob_i  = Qmob_i + qo(ijs-1) - qo_ijs;
                        end
                    end
                    % MJ 18/10/19 TQo_i = TQo_i + AxdPot(j)* b2 * no(j)* qo(i,j); % global compartment
                    TQo_i = TQo_i + AxdPot(js) * no(js)* qo_ijs; % global compartment b2 allready in AsxPot
                else
                    qo_ijs = 0.0000001; % organ always exists
                end
                qo(ijs) = qo_ijs;                
            end
        end
    end
end
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

function [Axdc,nf,Xas]= Axdev_St(Krnd, Nrnd, AxdPot, T, Nrep_S, nfo, bf)
%
% function [Axdc,nf,Xas]= Axdev_St(Krnd,Nrnd,AxdPot,T,Nrep_S,nfo,bf)
% 
% Computes Nrep_S development axis with theeir potential fruits
%   I   Krnd:       random generator congruence coefficient
%   I   Nrnd:       random generator current seed
%   I   AxdPot(T,1):Potential development axis
%   I   T:          Plant age
%   I   Nrep_S:     Number of stochastic repetitions
%   I   nfo:        Maximum number of female fruits per phytomer
%   I   bf:         fruit occurence probability
%   O   Axdc(T,Nrep_S): Development axis
%   O   nf(T,Nrep_S):   Number of fruits
%   O   Xas(T):         Number of axis distribution
%

    Xas  = zeros(T,1);    % distribution of phytomers (simulations)
    Axdc = zeros(T,Nrep_S); % development axis 
    nf = nfo*ones(T,Nrep_S);   % fruit development axis (number of fruits per cycle)

    for s = 1 : Nrep_S % N random simulations of axis
        % simule law of development Bernouilly process Axdc( 1 0 0 1 1 0,...)
        len = 0; %axis length
        for i = 1 : T
            % generating random number series
            Nrnd = Krnd*Nrnd - floor(Krnd*Nrnd);
            if Nrnd <= AxdPot(i,1) % phytomer exists
                len = len + 1;
                Axdc(i,s) = 1;
                %% fruit stochastic
                if bf < 1
                    n = 0;
                    for z = 1 : nfo
                        %Zrnd=Zrnd+1;
                        %Nrnd(1,Zrnd)= Krnd*Nrnd(1,Zrnd-1)-floor(Krnd*Nrnd(1,Zrnd-1));
                        Nrnd = Krnd*Nrnd - floor(Krnd*Nrnd);
                        %rnd=Nrnd(1,Zrnd);
                        if Nrnd <= bf   % fruit exists
                            n = n + 1;
                        end
                    end
                    nf(i,s) = n;
                end
            end
        end
        if len > 0
            Xas(len,1) = Xas(len,1) + 1;  % Updates the distribution (there is a new axis of len phytomers) 
        end
    end
end

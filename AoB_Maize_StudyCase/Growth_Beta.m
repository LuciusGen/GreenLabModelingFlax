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

function [F_S] = Growth_Beta(n,tx,mtx,Bo1,Bo2)
% 
% function [F_S] = Growth_Beta(n,tx,mtx,Bo1,Bo2)
% 
% computes normalize beta law (Bo1,bo2) on a given period
%   I   n:          number of durations to consider (usually plant age)
%   I   tx(1:n):    Beta Law intervals 
%   I   mtx:        max(tx(1:n)) 
%   I   Bo1:        Beta Law first parameter
%   I   Bo2:        Beta Law second parameter
%   O   F_S(n,n+1)  Normalized BetaLaw output F_S(i=1:n, 1:tx(i))
%
%   Last version 2018/10/23 Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    
    F_S = zeros (n,n+1);
    
    if Bo1 > 0 &&  Bo2 > 0 % Should always be the case
        if Bo1 == 1 && Bo2 == 1  % Case where Ba=Bb=1 => F_O is constant = 1      
           for i = 1 : n
                if tx(i) > 0  % expansion time is > 0 (if not default is zero)
                    %computing classes and cumulating function 
                    if tx(i) > n  % We only need to feel up to first reched : plant age or current age + expansion time
                        for j = 1 : n 
                            F_S(i,j) = 1.0;
                        end
                    else
                        for j = 1 : tx(i) 
                            F_S(i,j) = 1.0;
                        end
                    end
                end
           end 
        else  % Regular case Ba and Bb both > 0, and != 1 ( usually > 1)
           Bo1 = Bo1-1;
           Bo2 = Bo2-1; 
           nt = int32(mtx) + n + 1;
           F_O = zeros(nt,1);        
           for i = 1 : n
                txi = tx(i);
                if (txi > 0)  % expansion time is > 0 (if not default is zero)
                    Mx = 0.0; % Max value for normalization
                    ftxi = 1.0 / txi;  % interval length
                    x = ftxi * 0.5;    % starting value
                    for j = 1 : txi
                        F_O(j) = x^Bo1  *  (1 - x)^Bo2;
                        x = x + ftxi;
                        if Mx < F_O(j)
                            Mx = F_O(j);
                        end
                    end
                    %computing classes and cumulating function 
                    if (txi > n) % We only need to feel up to first reched : plant age or current age + expansion time
                        txi = n;
                    end
                    for j = 1 : txi % Copy normalized
                        F_S(i,j) = F_O(j) / Mx;
                    end
                end  % loop on expansion periods
           end  % loop on age           
           
        end  % Bo1,Bo2 = 1 and other case

    end % Bo1 > 0 and Bo2 > 0       
        
end

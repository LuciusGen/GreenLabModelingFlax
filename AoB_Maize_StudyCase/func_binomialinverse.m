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


function [PBN,Tmin,Tmax] = func_binomialinverse(N, b)
% function [PBN,Tmin,Tmax] = func_binomialinverse(N, b)
%
%     returns invere binomial number of trials when having N events occured% function [PBN] = func_binomialinverse(N, b)
%
%     returns invere binomial number of trials when having N events occured
%     with probability b (we have thus PBN >= N)
%     Calls Pascal triangle computation (Newton binom)
%     
%     CAUTION: the table is transposed ! PBN(k,j) (when j >= k and 0 else)
%     I     N           int        Number of Events
%     I     b           double     Bernouilli probability
%     O     PBN(N,N)    double     Binomial Law table 
%     O     Tmin(N)     int        Min index line par line from PBN(N,N)
%     O     Tmax(N)     int        Max index line par line from PBN(N,N)
%
%   Last version 2018/07/12. Main author PdR/MJ
%   Copyright Cirad-AMAP
%
    Tmin = N*ones(N,1);
    Tmax = zeros(N,1);
    PBN=zeros(N,N);
    [CN] = func_comb(N+1); %binome newtown
    for k = 1 : N % because last internode has no struct!
        bk = b^k;
        for  j = k : N
             PBN(k,j) = CN(1+j-k,j) * bk * (1-b)^(j-k);% negative binomial law
          %end
          %for j = 1 : N
             if PBN(k,j) > 0
                if j < Tmin(k)
                    Tmin(k) = j;
                end
                if j > Tmax(k)
                    Tmax(k) = j;
                end
            end
        end          
    end
    
end

% function [PBN] = func_binomialinverse(N, b)
% % function [PBN] = func_binomialinverse(N, b)
% %
% %     returns invere binomial number of trials when having N events occured
% %     with probability b (we have thus PBN >= N)
% % 
% %     Calls Pascal triangle computation (Newton binom)
% %     
% %     CAUTION: the table is transposed ! PBN(k,j) (when j >= k and 0 else)
% %
% %   Last version 2018/07/12. Main author PdR/MJ
% %   Copyright Cirad-AMAP
% %
%     PBN=zeros(N,N);
%     [CN] = func_comb(N+1); %binome newtown
%     for k = 1:N % because last internode has no struct!
%           for  j = k:N
%                 PBN(k,j) = CN(1+j-k,j) * b^k * (1-b)^(j-k);% negative binomial law
%           end 
%     end
% end
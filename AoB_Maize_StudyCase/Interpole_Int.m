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

function [T_out] = Interpole_Int(T, Nb_el, val, n_ctl, t_ctl, t_val )
% function [T_out] = Interpole_Int(T, Nb_el, val, n_ctl, t_ctl, t_val )
%
% Intepolate values (supposed integers) for Nb_el elements on T cycles
%
%   Default value given by val[1:Nb_el]
%
%   Where are n_ctl control points
%       control point position are t_ctl[1:n_ctl] (sorted, supposed to be < T)
%       related coeficient is t_cf[1:n-ctl] 
%       At contol point n for element el we have :
%           T_out(t_ctl(n),el) = round ( val(1,el) * t_val(t_ctl(n), el) );
%       Between two control points we have an linear interpolation
%
%   Used to build organ expansion time
%       (Nb_el = Number of organs)
%
%
%   Last version 2018/07/05. Main author MJ/PdR
%   Copyright Cirad-AMAP
%

T_out = zeros (T, Nb_el);

%%% Loop on control points, then within the interval, then on the elements
%%%
% k is the current control point 
% t is the current cycle
% el is the current 
% t1 is the first landmak
% t2 is the seconnd one
% idt1 is the index value at t1;
% idt2 is the index value at t2;

t1 = 1;
idt1 = 1;
for k=1: n_ctl
    idt2 = k;
    t2 = t_ctl(1,k);
    if (t2 > T)
        t2 = T;
    end
    dt = t2-t1;
    if (dt < 0)
        mess_err = sprintf('Interpolation index %d value (%d) lower then the previous one (%d)', idt2, t2, t1); 
        error_message (101, 1, 'Interpole_Int', mess_err);
    end
    if (dt < 0.01)
        dt = 1;
    end
    for t=t1:t2
        for el=1:Nb_el
            T_out(t,el) = round( val(1,el) * (t_val(idt1,el) + (t_val(idt2,el)-t_val(idt1,el))*(t-t1)/dt ) );
        end
    end
    t1 = t2;
    idt1 = idt2;
end  
% fill the left cycles between last landmark and number of cycles with the
% last value
if (t1 < T)
    for t=t1:T
        for el=1:Nb_el
            T_out(t,el)=round( val(1,el) * t_val(idt1,el) );
        end
    end
end
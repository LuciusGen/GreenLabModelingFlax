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

function [qoob] = IO_ReadPhyt(fid,Tob,ts,mxTob)
qob=zeros(ts,mxTob);
qoob=zeros(ts,mxTob);
x=0;
for i=1:mxTob 
    if Tob(i) >0 
        x=x+1; 
    end
end
mxTob1=x;
ncol=x+1;
 
fscanf(fid,'%f \n',ncol);%absorb line mxTob
for k=1:ts
    temp = fscanf(fid,'%f',ncol);
    info(1,1:ncol) = temp;
    qob(k,1:mxTob1)=info(1,2:ncol);
end

x=0;
for i=1:mxTob
    if Tob(i) >0 
        x=x+1;
        qoob(:,i) = qob(:,x);
    end
end

    
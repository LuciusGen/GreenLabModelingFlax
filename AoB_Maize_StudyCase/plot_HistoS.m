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


%%%%%%%%%%%%
% histogrammes biomass
function plot_HistoS(comp,E,T,N,Tob,mxTob,pa,pp,pi,pc,pf,pm,pq,pt,...
    Xas,Axdc,Dsm,Ds,Qsm,Qs,TQS,TQAS,TQPS,TQIS,TQICS,TQFS,TQMS,TQRS,TQTS,...
    qasm,qpsm,qism,qicsm,qfsm,qmsm,qas,qps,qis,qics,qfs,qms,...
    txa,txp,txi,txf,txm,txt,mtxa,mtxp,mtxi,mtxf,mtxm,mtxt,Ba,Bp,Bi,Bf,Bm,Bt,Dla,Dlp,Dli,Dlf,Dlm,Dlt)


figure ('Name', 'Plant functionning results');

    plotSimpleOneTable ( 2, 2, 1, E, 1, 'b', 'Climate value' );
    plotSimpleOneTable ( 2, 2, 2, Xas, 1, '-r', 'Number of Phytomers' );
    plotSimpleOneTable ( 2, 2, 3, Dsm, 1, '-k', 'Demand per cycle' );
    ns = 15;
    if ns >= N
        ns = N-1;
    end
    for i = 1 : ns
    	plotSimpleOneTable ( 2, 2, 0, Ds(:,i), 1, '--g', 'Demand per cycle' );
    end
    plotSimpleOneTable ( 2, 2, 4, Qsm, 1, '-k', 'Biomass per cycle' );
    ns = 15;
    if ns >= N
        ns = N-1;
    end
    for i = 1 : ns
    	plotSimpleOneTable ( 2, 2, 0, Qs(:,i), 1, '--g', 'Biomass per cycle' );
    end


    %%%%%%%%%%%% organ expansion time
    figure ('Name', 'Organ Expansion time/rank');
    plotSingleTable ( 2, 3, 1, txa, 1, T+1, 1.1*(mtxa+0.01), '- g','Leaf' );
    plotSingleTable ( 2, 3, 2, txp, pp, T+1, 1.1*(mtxp+0.01), '- b','Petiol-Sheath' );
    plotSingleTable ( 2, 3, 3, txi, pi, T+1, 1.1*(mtxi+0.01), '- k','Internode' );
    plotSingleTable ( 2, 3, 4, txf, pf, T+1, 1.1*(mtxf+0.01), '- r','Fruit Female' );
    plotSingleTable ( 2, 3, 5, txm, pm, T+1, 1.1*(mtxm+0.01), '- c','Fruit Male' );
    plotSingleTable ( 2, 3, 6, txt, pt, T+1, 1.1*(mtxt+0.01), '- m','Root' );
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Expansion durations', 'VerticalAlignment','baseline','FontWeight','bold');
    

    %%%%%%%%%% sink variation law of organ
    figure ('Name', 'Sink variation law');
    plotSinkVar( 2, 3, 1, T, mtxa, Dla, Ba, pa, '- g', 'Leaf Sink Var.' );
    plotSinkVar( 2, 3, 2, T, mtxp, Dlp, Bp, pp, '-- g', 'Petiol-Sheath Sink Var.' );
    plotSinkVar( 2, 3, 3, T, mtxi, Dli, Bi, pi, '- b', 'Internode Sink Var.' );
    plotSinkVar( 2, 3, 4, T, mtxf, Dlf, Bf, pf, '- r', 'Fruit Female Sink Var.' );
    plotSinkVar( 2, 3, 5, T, mtxm, Dlm, Bm, pm, '- c', 'Fruit Male Sink Var.' );
    plotSinkVar( 2, 3, 6, T, mtxt, Dlt, Bt, pt, '- m', 'Root Sink Var.' );
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Sink Variations', 'VerticalAlignment','baseline','FontWeight','bold');


    % Global Organ Compartments
    if comp(1) > 0
        
        figure ( 'Name', 'Biomass/Compartment');

        plotSimpleTwoTables (2,3,1, TQAS, TQPS, 1, pp, '-o g', '-* b','Leaf & Petiol-Sheath' );  
        plotSimpleTwoTables (2,3,2, TQIS, TQICS, pi, pi, '-- b','-* k', 'Internode' );  
        plotSimpleTwoTables (2,3,3, TQFS, TQMS, pf, pm, '-- r','-* c', 'Fruit Female / Male' ); 
        plotSimpleOneTable (2,3,4, TQRS, pq, '-- c', 'Common Pool' );    
        plotSimpleOneTable (2,3,5, TQTS, pt, '-- m', 'Root' ); 
        plotSimpleTwoTables (2,3,6, TQAS, TQPS, 1, pp, '- g', '-- c', 'All Organs' )
        plotSimpleTwoTables (2,3,0, TQICS, TQFS, pi, pf, '- k', '-- r', 'All Organs' )
        plotSimpleTwoTables (2,3,0, TQMS, TQTS, pm, pt, '- c', '-- m', 'All Organs' )
        plotSimpleOneTable (2,3,0, TQS, 1, '- k', 'All Organs' );

        axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
        title ('Biomass per compartments', 'VerticalAlignment','baseline','FontWeight','bold');

    end

    % Mean of Organic chronological series at T GC    
    figure ( 'Name', 'Organ chronological organic series');

    plotSimpleOneTable (2,2,1, qasm(T,:), 1, '-o g', 'Blade o, Petiol *' );    
    plotSimpleOneTable (2,2,0, qpsm(T,:), pp, '-* g', 'Blade o, Petiol *' );    
    plotSimpleTwoTables (2,2,2, qism(T,:), qicsm(T,:), pi, pc, '-o g', '-* g', 'Pith o, Inner Rings *' );    
    plotSimpleOneTable (2,2,3, qfsm(T,:), pf, '-o r', 'Fruit Female' );    
    plotSimpleOneTable (2,2,4, qmsm(T,:), pm, '-o c', 'Fruit Male' );    
    
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Phytomer Biomass per Chronological Organic Series', 'VerticalAlignment','baseline','FontWeight','bold');
   
    
    % Mean of Organic topological series at T GC    
    figure ('Name', 'Organ topological organic series');
    
    nc = 1; % Leaf and petiols
    for k = 1 : mxTob
        Ti = Tob(1,k);
        [qot] = selectNS(T,Ti,N,Axdc,qas);    
        [qott] = selectNS(T,Ti,N,Axdc,qps);
        plotSingleTableAndDots ( 2, 2, nc, qot(:,1), qott(:,1), 1, pp, '-o g', '-* b', 'Leaf(o) / Petiol(*)');
        nc = 0;
    end

    nc = 2; % internode (pith+rings)
    for k = 1 : mxTob
        Ti = Tob(1,k);
        [qot] = selectNS(T,Ti,N,Axdc,qis);
        [qott] = selectNS(T,Ti,N,Axdc,qics);
        plotSingleTableAndDots ( 2, 2, nc, qot(:,1), qott(:,1), pi, pi, '-* b', '-o b', 'Pith(*) / Rings(o)');
        nc = 0;
    end
   
    nc = 3;  % Fruits
    for k = 1 : mxTob
        Ti = Tob(1,k);
        [qot] = selectNS(T,Ti,N,Axdc,qfs);
        [qott] = selectNS(T,Ti,N,Axdc,qms);
        plotSingleTableAndDots ( 2, 2, nc, qot(:,1), qott(:,1), pf, pm, '-* b', '-* c', 'Fruit fem(o) / mal(*)');
        nc = 0;
    end
    
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Phytomer Biomass per Topological Organic Series', 'VerticalAlignment','baseline','FontWeight','bold');
    
end
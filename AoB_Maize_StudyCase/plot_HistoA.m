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

function plot_HistoA(Lsqr,comp,E,T,Tm,Tob,mxTob,pa,pp,pi,pf,pm,pt,Dt,Qt,TQt,MesO,MesS,MesT,MesNb,...
    TQAT,TQAob,TQPT,TQPob,TQICT,TQICob,TQFT,TQFob,TQMT,TQMob,TQTT,TQTob,...
    qat,qaob,qpt,qpob,qict,qicob,qft,qfob,qmt,qmob,...
    txa,txp,txi,txf,txm,txt,mtxa,mtxp,mtxi,mtxf,mtxm,mtxt,Ba,Bp,Bi,Bf,Bm,Bt,Dla,Dlp,Dli,Dlf,Dlm,Dlt)


figure ('Name', 'Demand & Biomass');

    if Lsqr > 0
        subplot(2,2,1);
        hold on;
        plot([0 1],[0 1],'- k');
        %[MesNb,~] = size(XX);
        MesO1 = zeros(MesNb,1);
        MesO2 = zeros(MesNb,1);
        MesS1 = zeros(MesNb,1);    
        MesS2 = zeros(MesNb,1);
        idx1 = 0;
        idx2 = 0;
        mx1 = 0;
        mx2 = 0;
        for i = 1 : MesNb
            if MesT(i) < 10
                idx1 = idx1+1;
                MesO1(idx1) = MesO(i);
                MesS1(idx1) = MesS(i);
                if (mx1 < MesO(i))
                    mx1 = MesO(i);
                end
            else
                idx2 = idx2+1;
                MesO2(idx2) = MesO(i);
                MesS2(idx2) = MesS(i);
                if (mx2 < MesO(i))
                    mx2 = MesO(i);
                end
            end
        end
        if (mx2 > 0)
            X = MesO2(1:idx2,1) / mx2;
            Y = MesS2(1:idx2,1) / mx2;
            plot(X,Y,'* m','MarkerSize',5);
        end
        if (mx1 > 0)
            X = MesO1(1:idx1,1) / mx1;
            Y = MesS1(1:idx1,1) / mx1;
            plot(X,Y,'o c','MarkerSize',5);
        end
        axis ([0.0 1.02 0.0 1.02]);
        title ('Fit. overview: Comp(o) Phyt(*)');
    end

    plotSimpleOneTable ( 2, 2, 2, E, 1, 'b', 'Climate value' );
    plotSimpleOneTable ( 2, 2, 3, Dt, 1, '-k', 'Demand per cycle' );
    plotSimpleOneTable ( 2, 2, 4, Qt, 1, '-g', 'Biomass per cycle' );


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
    plotSinkVar( 2, 3, 2, T, mtxp, Dlp, Bp, pp, '-- b', 'Petiol-Sheath Sink Var.' );
    plotSinkVar( 2, 3, 3, T, mtxi, Dli, Bi, pi, '- k', 'Internode Sink Var.' );
    plotSinkVar( 2, 3, 4, T, mtxf, Dlf, Bf, pf, '- r', 'Fruit Female Sink Var.' );
    plotSinkVar( 2, 3, 5, T, mtxm, Dlm, Bm, pm, '- c', 'Fruit Male Sink Var.' );
    plotSinkVar( 2, 3, 6, T, mtxt, Dlt, Bt, pt, '- m', 'Root Sink Var.' );
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Sink Variations', 'VerticalAlignment','baseline','FontWeight','bold');
    
    
    if comp(1) > 0
        
        figure ( 'Name', 'Biomass/Compartment');

        plotSingleTableAndDots (2,3,1, TQAT, TQAob, 1, 1, '-- g','o g', 'Leaf' );
        plotSingleTableAndDots (2,3,2, TQPT, TQPob, pp, pp, '-- b','o b', 'Petiol-Sheath' );  
        plotSingleTableAndDots (2,3,3, TQICT, TQICob, pi, pi, '-- k','o b', 'Internode' );  
        plotSingleTableAndDots (2,3,4, TQFT, TQFob, pf, pf, '-- r','o r', 'Fruit Female / Male' ); 
        plotSingleTableAndDots (2,3,0, TQMT, TQMob, pm, pm, '-- c','o c', 'Fruit Female / Male' );    
        plotSingleTableAndDots (2,3,5, TQTT, TQTob, pt, pt, '-- m','o m', 'Root' ); 
        plotSimpleTwoTables (2,3,6, TQAT, TQPT, 1, pp, '- g', '-- g', 'All Organs' )
        plotSimpleTwoTables (2,3,0, TQICT, TQFT, pi, pf, '- b', '-- r', 'All Organs' )
        plotSimpleTwoTables (2,3,0, TQMT, TQTT, pm, pt, '- c', '-- m', 'All Organs' )
        plotSimpleOneTable (2,3,0, TQt, 1, '- k', 'All Organs' );

        axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
        title ('Biomass per compartments', 'VerticalAlignment','baseline','FontWeight','bold');

    end

    
if comp(1,2) > 0
    % series organic computed topological
    %%%%%%%%%%%%%%%%%%%%
    % conditioning fruit organic series
    % fruit biomass must exist event very small
    for i = 1 : mxTob
        for j = 1 : max(Tob)
            if pf > 0 && qfob(j,i) == -0.0001 && qicob(j,i) > 0
                if j <= Tm
                    qfob(j,i) = 0.0001;
                    qft(j,Tob(i)) = 0.0001;
                end
            end
        end
    end
    % supress non data =999
    for i = 1 : mxTob
        for j = 1 : max(Tob)
            if pa > 0
                if qaob(j,i) == 999
                    qaob(j,i) = 0.0001;
                end
            end
            if pp > 0
                if qpob(j,i) == 999
                    qpob(j,i) = 0.0001;
                end
            end
            if pi > 0
                if qicob(j,i) == 999
                    qicob(j,i) = 0.0001;
                end
            end
            if pf > 0
                if qfob(j,i) == 999
                    qfob(j,i) = 0.0001;
                end
            end
        end
    end
    
    
    figure ( 'Name', 'Phytomer Biomass/Organic Series');
    
    % leaves
    nc = 1;
    [qaob] = crunchq_upqo(qaob,T);
    for k = 1 : mxTob
        Ti = Tob(1,k);
        if Ti > 0
            Tplot = Ti;
            if Ti > Tm
                Tplot = Tm+1;
            end
            [qatw] = selectNA(T,Ti,qat);
            [qo] = crunchq_upqos(qaob(:,k),Ti);
            plotSingleTableAndDots ( 2, 3, nc, qatw(1:Tplot,1), qo(1:Tplot,1), 1, 1, '- g', '* g', 'Leaf');
            nc = 0;
        end
    end
    
    if pp > 0
        [qpob] = crunchq_upqo(qpob,T);
        nc = 2;
        for k = 1 : mxTob
            Ti = Tob(1,k);
            if Ti > 0
                Tplot = Ti;
                if Ti > Tm
                    Tplot = Tm+1;
                end
                [qptw] = selectNA(T,Ti,qpt);
                [qo] = crunchq_upqos(qpob(:,k),Ti);
                plotSingleTableAndDots ( 2, 3, nc, qptw(1:Tplot,1), qo(1:Tplot,1), pp, pp, '- b', '* b', 'Petiol-Sheath');
                nc = 0;
            end
        end
    end
    
    % internodes
    if pi > 0
        nc = 3;
        [qicob] = crunchq_upqo(qicob,T);
        for k = 1 : mxTob
            Ti = Tob(1,k);
            if Ti > 0
                Tplot = Ti;
                if Ti > Tm
                    Tplot = Tm+1;
                end
                [qictw] = selectNA(T,Ti,qict);
                [qo] = crunchq_upqos(qicob(:,k),Ti);
                plotSingleTableAndDots ( 2, 3, nc, qictw(1:Tplot,1), qo(1:Tplot,1), pp, pp, '- k', '* k', 'Internode');
                nc = 0;
            end
        end
    end
    
    if pf > 0
        nc = 4;
        [qfob] = crunchq_upqo(qfob,T);
        for k = 1 : mxTob
            Ti = Tob(1,k);
            if Ti > 0
                Tplot = Ti;
                if Ti > Tm
                    Tplot = Tm+1;
                end
                [qftw] = selectNA(T,Ti,qft);
                [qo] = crunchq_upqos(qfob(:,k),Ti);
                plotSingleTableAndDots ( 2, 3, nc, qftw(1:Tplot,1), qo(1:Tplot,1), pp, pp, '- r', '* r', 'Fruit Female');
                nc = 0;
            end
        end
    end
    
    if pm > 0
        nc = 5;
        [qmob] = crunchq_upqo(qmob,T);
        for k = 1 : mxTob
            Ti = Tob(1,k);
            if Ti > 0
                Tplot = Ti;
                if Ti > Tm
                    Tplot = Tm+1;
                end
                [qmtw] = selectNA(T,Ti,qmt);
                [qo] = crunchq_upqos(qmob(:,k),Ti);
                plotSingleTableAndDots ( 2, 3, nc, qmtw(1:Tplot,1), qo(1:Tplot,1), pp, pp, '- c', '* c', 'Fruit Male');
                nc = 0;
            end
        end
    end
    
    axes('Position', [.49, 0.0, .0001, .0001,],'XTick',[],'YTick',[]);
    title ('Phytomer Biomass per Topological Organic Series', 'VerticalAlignment','baseline','FontWeight','bold');
    
end
end
function  MaOEADS(Global)
% <algorithm> <M>
%--------------------------------------------------------------------------
    %% Parameter setting
    [coefficient,~] = Global.ParameterSet(Global.coefficient,0.9);
    %% Generate the reference points and random population
    Population      = Global.Initialization();
    Zmin            = min(Population.objs,[],1);
    %% Optimization
    while Global.NotTermination(Population)
        MatingPool = TournamentSelection(2,Global.N,sum(max(0,Population.cons),2));
        Offspring  = GA(Population(MatingPool));
        Zmin       = min([Zmin;Offspring.objs],[],1);
        Population = EnvironmentalSelection([Population,Offspring],Global.N,Global,Zmin,coefficient);
        
    end
    
end
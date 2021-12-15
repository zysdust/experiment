% Note: 运行前先修改保存路径、以及每次运行计算的HV值和IGD值
% 评价50000次
% 基于分解的MOEAs:     NSGA-III、MOEA/D、RVEA
% 基于支配关系的MOEAs: KnEA 、GrEA
% 基于指标的MOEAs:     IBEA 、MOMBI-II、AR-MOEA 
% 其他的               onebyoneEA、MOEA/DD

runtime  = 20;

M        = [3,5,8,10];

N         = [120,210,240,275];

evaluation = [60000,126000,192000,275000];

for k = 2:2
    
    problem = str2func(['@MaF',num2str(k)]);

for i = 2:length(M)  

    for j = 1 : runtime   

    end  
    
end

end

%%  Result output
M           =  [3,5,8,10];

N           =  [120,210,240,275];

evaluation  =  [60000,126000,192000,275000];

algorithm   = {'MaOEADS','MaOEADES','NSGAIII','RVEA','MOEADD','tDEA','MOMBIII','onebyoneEA','KnEA'};


runtime     =  20;

statistical_res   = {};

statistical_res.IGD(1,:)= [' ',' ',algorithm];

statistical_res.HV(1,:) = [' ',' ',algorithm];

Q           = 2;

for i = 1:9
    
    problem     = ['MaF',num2str(i)];
    
    for j = 1:length(M)

        switch i
            
            case 7
                D = M(j) + 19;
            case 8
                D = 2;
            case 9
                D = 2;
            case 13
                D = 5;
            case 14
                D = 20* M(j);
            case 15
                D = 20* M(j);
            otherwise
                D = M(j) + 9;
        end
        
        Metrics                 = AlgorithmsTest_MaF(problem,algorithm,M(j),runtime,D,j+Q);
        
        statistical_res.IGD(Q,:)= Metrics.IGD;
        
        statistical_res.HV(Q,:) = Metrics.HV;

        Q=Q+1;
        
    end
        
end

MaF2excel(statistical_res,algorithm);



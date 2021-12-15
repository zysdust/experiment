%% This code compare indicators of all MaOEAs  这段代码比较了所有MaOEAs的指示器   多目标优化问题(MaOPs)
% the result is recorded in table with csv format  结果记录在CSV格式的表格中

% MOEA, multi-objective evolutionary algorithms	多目标优化算法
% MOP ,   multi-objective optimization problem(MOP) 多目标优化问题	
% -algorithm. 要执行的MOEA的函数。
% -problem. 待解决的MOP。
% -N. MOEA的种群规模。注意，它被固定在某些MOEAs(例如moea .m)中的某些特定值上，因此这些MOEAs的实际种群大小可能并不完全等于这个参数。
% -M. MOP的目标数目。注意，在不可伸缩的MOPs(例如ZDT1.m)中，目标的数量是恒定的，因此这个参数对于这些MOPs是无效的。
% -D. MOP决策变量的个数。注意，在某些MOP中，决策变量的数量是常量或固定到某些特定整数上的(例如：ZDT5.m)，因此决策变量的实际数量可能并不完全等于这个参数。
% -evaluation. 函数评价的最大数目。
% -run. 运行数。如果用户希望为相同的算法、问题、M和D参数保存多个结果，则在每次运行时修改此参数，使结果的文件名不同。
% -save. 保存的种群。如果将该参数设置为0(默认值)，则会在终止后显示结果图;否则，在进化过程中获得的种群将保存在一个名为的文件中Data\algorithm\algorithm_problem_M_D_run.mat。例如：如果save为5并且evaluation是20000，评价数量为4000、8000、12000、16000、20000时得到的种群将被保存。
% -outputFcn. 每次生成后调用的函数，通常不需要修改。


problem             = 'CSSP';%待解决的MOP

algorithm           = {'MOEADS','MaOEADES','RVEA','NSGAIII','MOEADD','onebyoneEA','MOMBIII','KnEA','tDEA'};

M                   =  [5,8];%创建矩阵M，矩阵M为一行两个元素的向量。M表示节点数量，执行5节点 和 8节点情况

runtime             =  20;%运行时间

algorithmName           = {'MaOEA-DS','MaOEA-DES','RVEA','NSGA-III','MOEA/DD','1by1EA','MOMBI-II','KnEA','tDEA'};

for k = 1:length(M)%矩阵M有连个元素，长度为2，循环两遍

    Q                   =  2;

    statis_res          = {};%新建元胞数组，用来最后生成CSV表格

    statis_res.IGD(1,:) = [' ',algorithmName];%元胞数组的IGD属性的第一行为算法名字

    statis_res.HV(1,:)  = [' ',algorithmName];

    statis_res.Time(1,:) = [' ',algorithmName];
    
    for i = 1:16
        
        [user,~,~,~,~,NoV]  = TestCase(i); %user为全局变量，次数获取数据里的用户数量 NoV为数据累加值

        %计算每个实例的HV和IGD
        Metrics             = AlgorithmsEvaluate(problem,algorithm,M(k),user,runtime,NoV,i);
        
        %保存时间结果的各类数据，存入statis_res
        statis_res.IGD(Q,:) = Metrics.IGD;statis_res.HV(Q,:)  = Metrics.HV;
        
        statis_res.Time(Q,:)= Metrics.time;
    
        statis_res.NDS(Q-1,1) = Metrics.NDS;
        
                       Q    =  Q + 1;               
    end
    
    CSSP2excel(statis_res,M(k));%将结果 statis_res 生成表格文件并保存
    
end




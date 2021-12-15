
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

problem             = 'CSSP';

%algorithm           = {'MaOEADS','KnEA','MaOEADES'};

algorithm           = {'MOEADS','MaOEADES','RVEA','NSGAIII','MOEADD','onebyoneEA','MOMBIII','KnEA','tDEA'};

M                   =  [5,8];

runtime             =  1;

Q                   =  1;

statis_res          = {};

statis_res.IGD(1,:) = [' ',algorithm];

statis_res.HV(1,:)  = [' ',algorithm];

statis_res.Time(1,:) = [' ',algorithm];

for k = 2:length(M)
    
    for i = 1:1
        
        [user,~,~,~,~,NoV]  = TestCase(i); 
        
        TPS             = Boxplot_sh(problem,algorithm,M(k),user,runtime,NoV,i);
           
    end
    
    
end




function TPS_normal = Boxplot_sh(problem,algorithm,M,user,runtime,NoV,Q)
allalgorithm = cell(length(algorithm),1);
currentDepth = 2;                               % get the supper path of the current path
currPath     = fileparts(mfilename('fullpath'));    % get current path
fsep         = filesep;
pos_v        = strfind(currPath,fsep);
p            = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1); % -1: delete the last character '/' or '\'

for i = 1:length(algorithm)
          
     A =[];
     
     folder = fullfile('/data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);

     for j = 1:runtime

         filename = [folder,'/',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,NoV,num2str(j))];

         load( filename );                                   

         A = [A;result{1,2}']; 
         
     end
     
Nondominated     = NDSort(A.objs,1) == 1; 
NondomIndividual = A(Nondominated,:);
allalgorithm{i,:}= {[algorithm{1,i},'_U',num2str(user)],NondomIndividual}; 
             
end

%% get the truePareto

allal =[]; 

for i = 1:length(algorithm) 
    
    allal = [allal;allalgorithm{i,1}{1,2}];  
    
end

FN         = NDSort(allal.objs,1) == 1;

truePareto = allal(FN,:);

TPS        = unique(truePareto.objs,'rows','stable');


% TPS_normal = (TPS-min(TPS,[],1))./repmat(max(TPS)-min(TPS),size(TPS,1),1);

TPS_normal = TPS;
TPS_normal(:,3) = 1./TPS(:,3);
TPS_normal(:,4) = 1./TPS(:,4);

if M==5
    
    order = [1 3 4 2 5];
    
else
    
    order = [1 3 4 2 5 8 6 7];
    
end

TPS_normal = TPS_normal(:,order);


%result_table=array2table(TPS_normal);
%writetable(result_table,['/results/','temp','.csv']);
%% plot the boxplot
f = {'CT','SQ','SR','CC','EC','LC','WL','WT'};

if Q == 1 && runtime ==1
    
    figure;
    
    ha = tight_subplot(2,4,[0.06,0.045],[0.06,0.03],[0.05,0.02]);
    
    for i = 1:M
        
        Obj = [];group = [];
        
        for j = 1:length(algorithm)
            
            u     = allalgorithm{j,1}{1,2}.objs;
            
            u      = u(:,order);
            
            group = [group;repmat({num2str(j)},length(u),1)];
            
            if i==2 || i==3
                
                Obj   = [Obj;1./u(:,i)];
            else
                
                Obj   = [Obj;u(:,i)];
            end
        end
        
        axes(ha(i));
        h = boxplot(Obj,group);
%         set(h,'LineWidth',0.8);
        fontsize = 8;
        ylabel(f{1,i},'Fontsize',fontsize,'Fontname','Times New Roman');
        algorithmName = {'MaOEA-DS','MaOEA-DES','RVEA','NSGA-III','MOEA/DD','1by1EA','MOMBI-II','KnEA','tDEA'};
        set(gca,'xticklabel',algorithmName,'XTickLabelRotation',46,'Fontname','Times New Roman','Fontsize',fontsize,'LineWidth',0.5);
        hold on;
    end
    set(gcf,'unit','centimeters','position',[10 5 19 11.7]);
    print(gcf,'-djpeg','-r600',['\results\solution for group',num2str(Q)]);
end

end

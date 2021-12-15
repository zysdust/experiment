function ins = AlgorithmsEvaluate(problem,algorithm,M,user,runtime,NoV,Q)
% Caluate the HV and IGD for each instance 计算每个实例的HV和IGD

allalgorithm = cell(length(algorithm),1);
currentDepth = 2;                               % get the supper path of the current path 得到当前路径的晚餐路径
currPath     = fileparts(mfilename('fullpath'));    % get current path
fsep         = filesep;
pos_v        = strfind(currPath,fsep);
p            = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1); % -1: delete the last character '/' or '\'

for i = 1:length(algorithm)%从文件导入数据
          
     A =[];
     
     folder = fullfile('/data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);

     for j = 1:runtime

         filename = [folder,'/',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,NoV,num2str(j))];

         load( filename );                                   

         A = [A;result{1,2}']; 
         
     end
     
Nondominated     = NDSort(A.objs,1) == 1; %排序
NondomIndividual = A(Nondominated,:);
allalgorithm{i,:}= {[algorithm{1,i},'_U',num2str(user)],NondomIndividual}; 
             
end

%% get the true Pareto 得到真正的 Pareto ；  Pareto  是指资源分配的一种理想状态，

allal =[]; 

for i = 1:length(algorithm) 
    
    allal = [allal;allalgorithm{i,1}{1,2}];  
    
end

FN         = NDSort(allal.objs,1) == 1;

truePareto = allal(FN,:);

TPS        = unique(truePareto.objs,'rows','stable');   % unique 返回与 A 中相同的数据；  TPS  非主导解

fprintf('            group %d has %d non-dominant solutions                \n',Q,length(TPS));


TPS_normal = TPS;
TPS_normal(:,3) = 1./TPS(:,3);
TPS_normal(:,4) = 1./TPS(:,4);

if M==5
    
    order = [1 3 4 2 5];
    
else
    
    order = [1 3 4 2 5 8 6 7];
    
end

TPS_normal = TPS_normal(:,order);


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
        set(gca,'xticklabel',algorithm,'XTickLabelRotation',46,'Fontname','Times New Roman','Fontsize',fontsize,'LineWidth',0.5);
        hold on;
    end
    set(gcf,'unit','centimeters','position',[10 5 19 11.7]);
    savefig([currPath,'\output\solution for group',num2str(Q),'.fig']);
    print(gcf,'-djpeg','-r600',[currPath,'\output\solution for group',num2str(Q)]);
end


Metrics = {};

% smaller is better

IGD_index  = zeros(runtime,length(algorithm));    

Time_index = zeros(runtime,length(algorithm));

% larger is better
HV_index   = zeros(runtime,length(algorithm));    

for i = 1:length(algorithm)
    
    folder = fullfile('/data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);
          
    for j = 1:runtime
        
        filename = [folder,'/',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,NoV,num2str(j))];
           
        load(filename);
         
        Nondominated       =  NDSort(result{1,2}.objs,1) == 1; 
        
        NondomIndividual   =  result{1,2}(Nondominated); 
        
        NDS                =  unique(NondomIndividual.objs,'rows');
        
%         NDS                =  (NDS - min(TPS,[],1))./repmat(max(TPS,[],1)-min(TPS,[],1),size(NDS,1),1);
%         
%         TPS1               =  ones(1,M);
         
        IGD_index(j,i)     =  IGD(NDS,TPS);
         
        HV_index(j,i)      =  HV(NDS,TPS); 
        
        Time_index(j,i)    =  metric.time;
             
    end
    
           
end

ins.NDS = length(TPS);

ins.IGD = CSSPresult(IGD_index,'min',algorithm,Q);

ins.HV  = CSSPresult(HV_index,'max',algorithm,Q);

ins.time  = CSSPresult(Time_index,'min',algorithm,Q);

fprintf('================Group %d with %d objectives has finished ! ==================\n',Q,M);

end






function  ins = CSSPresult(metric,indicator,algorithm,Q)

% 
%   

m1 = mean(metric);  %mean平均值

m2 = std(metric);   %std标准差

%%==================== ָ���������
if strcmp(indicator,'min') % strcmp 比较字符串 
    
    [~,index] = ismember(m1,sort(m1));% ismember 判断数组元素是否为集数组成员
    
elseif  strcmp(indicator,'max') 
    
    [~,index] = ismember(m1,sort(m1,'descend'));
    
end


%% wilcoxson rank sum
R={' '};

for i = 2:length(algorithm)
    
    [~,h] = ranksum(metric(:,1),metric(:,i),0.05);%秩和检验
    
    switch indicator
        
        case 'min'
            
            if h == 1 && m1(i)> m1(1)
                
                R{1,i} = '+';
                
            elseif h == 1 && m1(i)< m1(1)
                
                R{1,i} = '-';
            else
                R{1,i} = '=';
            end
            
        case 'max'
            
            if h == 1 && m1(i)< m1(1)
                
                R{1,i} = '+';
                
            elseif h == 1 && m1(i)> m1(1)
                
                R{1,i} = '-';
            else
                R{1,i} = '=';
            end
    end
            
            
    
end


% �����е�����
ins = {num2str(Q)};%Q为第几组，一共2组，一组5节点，一组8节点

for i = 1:length(algorithm)
    % sprintf 将数据格式化为字符串或字符向量
    ins{1,i+1} = sprintf('%.3e(%.2e)[%d]%s',m1(i),m2(i),index(i),R{1,i});
    
end

end



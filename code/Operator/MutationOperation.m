function pop = MutationOperation(varargin)
% MutationOperation for NSGA-III
%   默认情况下，变异方法随机取一种
%

if nargin == 3
    
    pop = varargin{1};  % 种群
    
    mc  = varargin{2};  %  变异概率
    
    available_index = varargin{3}; % 可用云服务
  
    method = {'Swap','Inverse','Insert'};
    
else
    
    pop = varargin{1};
    
    mc  = varargin{2};
    
    available_index = varargin{3};
    
    method = varargin{4};
    
%     available_index = Global.ETC.AE;
    
end

[r,c] = size(pop);

for i=1:r
                
   if rand <= mc
       
       mode = method{1,unidrnd(length(method))};
       
       part1 = pop(i,1:c/2); part2 = pop(i,(c/2+1):c);
                    
       switch mode
        
          case 'Swap'
              % 云服务选择采用单点变异 
              s1 = singlemutation(part1,available_index);
              % 任务排序进行两点交换     
              s2 = swap(part2);
              pop(i,:) = [s1,s2];
              
          case 'Inverse'
               % 云服务选择部分进行单点变异
               s1 = singlemutation(part1,available_index);
               % 任务排序进行片段翻转     
               b = sort(randperm(c/2,2));
               s2 = part2;
               s2(b(1):b(2)) = fliplr(s2(b(1):b(2)));
               pop(i,:) = [s1,s2];
              
          case 'Insert'
                    mpoint = randperm(c/2,2);  % 变异的位置
                    pop(i,mpoint(1))=available_index(mpoint(1)).s(unidrnd(length(available_index(mpoint(1)).s)));%可选的云服务随机选一个赋给变异点
                    pop(i,mpoint(2))=available_index(mpoint(2)).s(unidrnd(length(available_index(mpoint(2)).s)));
                % 任务排序将两点的数值插入到另外两个点     
                     d = sort(randperm(c/2,4)) + c/2;
                     x =[];
                     for j = c/2+1:c
                         if j~=d(3)&&j~=d(4)
                            if j == d(1) 
                                x = [x,pop(i,j)];
                                x = [x,pop(i,d(3)),pop(i,d(4))];

                            else
                                x = [x,pop(i,j)];
                            end
                         end
                     end
                     pop(i,c/2+1:c) = x;
                     
                     
%           case 'wheel'
%               
%                pop(i,:) = wheel(pop(i,:),Global);
      end
                    
   end
   
end
end



function bestpop = wheel(bestpop,Global)

    c = size(bestpop,2);

    t_record = calTime(bestpop(1:c),Global);  % 记录每个云服务的工作时间

    available_index = Global.ETC.available;

for j = 1:c/2
                        
      CSoptions = available_index(j).s;
            
      if length(CSoptions)>1
            
         p_selection = zeros(1,length(CSoptions));
            
                % 所有云服务的运行时间之和
            
         cs_sum = sum(t_record(CSoptions));
            
         for k = 1:length(CSoptions)
                
             if t_record(CSoptions(k)) == 0
                    
                 p_selection(1,k) = 0.99;
             else
                 p_selection(1,k) = 1 - t_record(CSoptions(k))/cs_sum;
             end
                
          end
            
            
            % 轮盘赌选择进行重新选择
            
                p_selection = p_selection./sum(p_selection);
                
                r = rand;
                
                C = cumsum(p_selection);
                
                position = find(r<=C,1,'first');
                
                bestpop(j) = CSoptions(position);
                
      end          
            
end      

end



function t_record = calTime(pop,Global)

% 计算每个云服务的总工作时间
cs = Global.cs; st = Global.st; t = length(st);
process_T = Global.ETC.process_T;
trans_T   = Global.ETC.logistic_T;
[r,c]     =size(pop);
stlj      = cumsum(st);
stlj1     = [1,stlj+1];
P = calculateP(pop(:,c/2+1:c));
for i =1:r
    
    t_record=zeros(cs,1);ST=zeros(t,max(st));FT=zeros(t,max(st));
    
    for k = 1:c/2
            x=floor(P(i,k)/10);  % 第x个任务
            y=round(rem(P(i,k),10)*10); % 第y个子任务
            position = stlj1(x)+y-1;
            M = pop(i,position);
            
            if y == 1   
                ST(x,y) = t_record(M);
                t_record(M) = process_T(position,M) + ST(x,y);
                FT(x,y) = t_record(M); 
            else    
                ST(x,y) = max([t_record(M),FT(x,y-1)+trans_T(pop(i,position-1),M)]);
                t_record(M) = process_T(position,M) + ST(x,y);
                FT(x,y) = t_record(M); 
            end

    end

end

end

function s = singlemutation(s,available_index)

    c = length(s);  mpoint = randperm(c,1);

    s(mpoint(1))=available_index(mpoint(1)).s(unidrnd(length(available_index(mpoint(1)).s)));

end

function s = swap(s)

         c = length(s);
         b=randperm(c,2);
         p = s(b(1));
         s(b(1)) = s(b(2));
         s(b(2)) = p;
end


function P = calculateP(pop)
    t_number = length(unique(pop));
    [r,c] = size(pop);
    P = zeros(r,c);
    
    for i =1 : r
        a = ones(t_number,1);
        for j = 1:c                                        
            if pop(i,j) == 1
                P(i,j) = 10 + 0.1*a(1);
                 a(1) = a(1) + 1;
            end
        
            for p=2:t_number
                if pop(i,j) == p
                    P(i,j) = 10 * p + 0.1 * a(p);
                    a(p) = a(p) + 1;
                end
            end      
        end
    end
end


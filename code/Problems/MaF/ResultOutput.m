function  ins = ResultOutput(metric,indicator,algorithm,problem,M)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

currPath = fileparts(mfilename('fullpath')); 

m1 = mean(metric);     
m2 = std(metric);

%%==================== 指标进行排序
if strcmp(indicator,'min') 
    
    [~,index] = ismember(m1,sort(m1));
    
elseif  strcmp(indicator,'max') 
    
    [~,index] = ismember(m1,sort(m1,'descend'));
    
end


%% wilcoxson rank sum
R={' '};

for i = 2:length(algorithm)
    
    [~,h] = ranksum(metric(:,1),metric(:,i),0.05);
    
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


% 表格中的内容
ins = {problem,num2str(M)};

for i = 1:length(algorithm)
    
    ins{1,i+2} = sprintf('%.3e(%.2e)[%d]%s',m1(i),m2(i),index(i),R{1,i});
    
end

% expand = char(abs('B')+length(algorithm));% A--->F
% 
% ce = ['A',num2str(Q+2),':',expand,num2str(Q+2)];
% 
% titleposition = ['B',num2str(2),':',expand,num2str(2)];
% 
% % 写入标题
% 
% xlswrite([currPath,'\MaFresult.xlsx'],algorithm,metricname,titleposition);
% 
% xlswrite([currPath,'\MaFresult.xlsx'],ins,metricname,ce);
% 
% fprintf('==========第%d组试验各算法的%s值已写入表格中=============\n',Q,metricname);

end
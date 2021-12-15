function statistical_res = AlgorithmsTest_MaF(problem,algorithm,M,runtime,D,Q)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ

Metrics = {};

% smaller is better
IGD_index  = zeros(runtime,length(algorithm));  

% larger is better
HV_index   = zeros(runtime,length(algorithm)); 

currentDepth = 2;                               % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));    % get current path
fsep = filesep;
pos_v = strfind(currPath,fsep);
p = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1);

for i = 1:length(algorithm)
    
    folder = fullfile('/data/MaF',problem,algorithm{1,i});
          
    for j = 1:runtime
        
        filename = [folder,'/',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,D,num2str(j))];
           
        load(filename);
         
        IGD_index(j,i)     =  cell2mat(metric.IGD);
         
        HV_index(j,i)      =  cell2mat(metric.HV); 
             
         
    end
    
end  


statistical_res.IGD = ResultOutput(IGD_index,'min',algorithm,problem,M);

statistical_res.HV  = ResultOutput( HV_index,'max',algorithm,problem,M);


end


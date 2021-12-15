% sensitivity analysis 


%% Result group

folder =  fileparts(mfilename('fullpath'));

problem     = 'CSSP';

algorithm   = {'MOEADS','MaOEADES','NSGAIII','RVEA','MOEADD','onebyoneEA','MOMBIII','KnEA','tDEA'};

M           = [5,8];

runtime     = 20;

coefficient = {0,0.01,0.1,0.5,1,2,5,10,20};

s ='gbkm'; % colors

color = [0.49 0.18 0.56;0 0.45 0.74;71/256 51/256 53/256;189/255 30/255 30/255];

u ='dosvxp'; 

v ={'-','-','-','-','-',':','-.'};
%ha = tight_subplot(2,2,[0.12,0.06],[0.1,0.1],[0.08,0.01]);
q = 0;
for i = 1:length(M)
    %q=q+1;
    %axes(ha(q));
    
    MeanHV = [];MeanIGD = [];
    
    for group = 1:4
        
        [user,~,~,~,~,D]      = TestCase(group);  
        
        [HV_index,IGD_index]  =  cal_HV(algorithm,problem,M(i),user,D,runtime,group,coefficient);
        
        MeanHV                = [MeanHV;mean(HV_index)];
        
        MeanIGD               = [MeanIGD;mean(IGD_index)];
        
    end

    fontsize = 7;
    figure
    for j = 1:4
        plot(MeanHV(j,:),[s(j),u(j),v{j}],'Color',s(j),...
        'MarkerSize',3.5,'Linewidth',0.8,'MarkerFaceColor','w');   
        %text(MeanHV(j,:),[s(j),u(j),v{j}],num2str([MeanHV(j,:);[s(j),u(j),v{j}]].','(%.2f,%.2f)'));%标记点
        hold on;
    end
    legend({'g1','g2','g3','g4'},'Location','SouthWest');
    set(gcf,'unit','centimeters','position',[10 5 7 5.5]);
    set(gca,'xticklabel',coefficient,'Fontsize',fontsize );% 'XTickLabelRotation',46,
    set(gca,'LooseInset',get(gca,'TightInset'));
    if M(i) == 5
        tag = '(b)';
    else
        tag = '(d)';
    end
    xlabel({'\lambda',tag},'Fontname','Times New Roman','Fontsize',fontsize );
    ylabel('HV','Fontname','Times New Roman','Fontsize',fontsize );
    title(['HV with ', num2str(M(i)),'-objective for groups 1-4'],'Fontsize',fontsize );
    print(gcf,'-djpeg','-r600',['\results\sa-HV-M',num2str(M(i))]);
    
    figure;
%     subplot(1,2,2);
%    q=q+1;
%   axes(ha(q));
    for j = 1:4
        plot(MeanIGD(j,:),[s(j),u(j),v{j}],'Color',s(j),'MarkerSize',3.5,...
        'Linewidth',0.8,'MarkerFaceColor','w');
        hold on;
    end
    legend({'g1','g2','g3','g4'},'Location','NorthWest');
    set(gcf,'unit','centimeters','position',[10 5 7 5.5]);
    set(gca,'xticklabel',coefficient,'Fontsize',fontsize );% 'XTickLabelRotation',46,
    set(gca,'LooseInset',get(gca,'TightInset'));
    title(['IGD with ', num2str(M(i)),'-objective for groups 1-4'],'fontname','Times New Roman');
    if M(i) == 5
        tag = '(a)';
    else
        tag = '(c)';
    end
    xlabel({'\lambda',tag},'Fontname','Times New Roman','Fontsize',fontsize );
    ylabel('IGD','Fontname','Times New Roman','Fontsize',fontsize );
    print(gcf,'-djpeg','-r600',['\results\sa-IGD-M',num2str(M(i))]);;
    
    
end

%print(gcf,'-djpeg','-r600','\results\sa-IGD-HV');










function [HV_index,IGD_index] =  cal_HV(algorithm,problem,M,user,D,runtime,group,coefficient)

currentDepth = 2;                               % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));    % get current path
fsep = filesep;
pos_v = strfind(currPath,fsep);
p = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1);


for i = 1:length(algorithm)
          
     A =[];
     
     if i ~=1
     
         folder = fullfile('/data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);
         
         for j = 1:runtime
             
             filename = [folder,'/',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,D,num2str(j))];
             
             load( filename );
             
             A = [A;result{1,2}'];
             
         end
         
     else 
         
         folder = fullfile('/data',problem,algorithm{1,1},['SensitivityAnalysis',num2str(group)]);
         
         for j = 1:runtime
             
             filename = fullfile(folder,sprintf('%s_%s_M%d_D%d_%d_%s.mat',algorithm{1,1},problem,...
                 M,D,j,num2str(coefficient{i})));
             
             load(filename);
             
             A = [A;result{1,2}'];
         end
         
     end

Nondominated     = NDSort(A.objs,1) == 1; 
     
NondomIndividual = A(Nondominated,:);

allalgorithm{i,:} = {[algorithm{1,i},'_U',num2str(user)],NondomIndividual}; 
             
end


%% get the truePareto

allal =[]; 

for i = 1:length(algorithm) 
    
    allal = [allal;allalgorithm{i,1}{1,2}];  
    
end

FN         = NDSort(allal.objs,1) == 1;

truePareto = allal(FN,:);

TPS        = unique(truePareto.objs,'rows','stable');


folder     = fullfile('/data',problem,algorithm{1,1},['SensitivityAnalysis',num2str(group)]);

HV_index   = zeros(runtime,length(coefficient));

IGD_index   = zeros(runtime,length(coefficient));

for i = 1:length(coefficient)
    
    for j = 1:runtime
        
        filename = fullfile(folder,sprintf('%s_%s_M%d_D%d_%d_%s.mat',algorithm{1,1},problem,...
            M,D,j,num2str(coefficient{i})));
        
        load(filename);
        
        Nondominated       =  NDSort(result{1,2}.objs,1) == 1;
        
        NondomIndividual   =  result{1,2}(Nondominated);
        
        NDS                =  unique(NondomIndividual.objs,'rows');
        
        HV_index(j,i)      =  HV(NDS,TPS);
        
        IGD_index(j,i)     =  IGD(NDS,TPS);
        
    end
    
    
end


fprintf('group-%d with %d objectives has finished\n',group, M);


end





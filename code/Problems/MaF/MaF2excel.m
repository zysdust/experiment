function MaF2excel(statistical_res,algorithm)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ

currPath = fileparts(mfilename('fullpath')); 
%  ����ÿ���㷨���ڵ�һ�ĸ���

statistical_res = computeRank(statistical_res,currPath);


[r,c] = size(statistical_res.IGD);




expand = char(abs('A')+c-1);% A--->F

% title_loc = ['C2:',expand,num2str(2)];
% 
result_loc = ['A2:',expand,num2str(r+1)];

a = array2table(statistical_res.IGD);

b = array2table(statistical_res.HV);


writetable(a,['/results/MaF_IGD.csv']);
 
writetable(b,['/results/MaF_HV.csv']);
% xlswrite([currPath,'\MaFresult.xlsx'],algorithm,'IGD',title_loc);

%xlswrite([currPath,'\output\MaFresult.xlsx'],statistical_res.IGD,'IGD',result_loc);

% xlswrite([currPath,'\MaFresult.xlsx'],algorithm,'HV',title_loc);

%xlswrite([currPath,'\output\MaFresult.xlsx'],statistical_res.HV,'HV',result_loc);

fprintf('Results has filled the excel');

end


function statistical_res = computeRank(statistical_res,currPath)

[r,c] = size(statistical_res.IGD);
% 
rank_IGD = zeros(r-1,c-2);

rank_HV  = zeros(r-1,c-2);

for i = 1:r-1
    for j =1:c-2
        rank_IGD(i,j) = str2num(statistical_res.IGD{i+1,j+2}(end-2));
        rank_HV(i,j)  = str2num(statistical_res.HV{i+1,j+2}(end-2));

    end
end

% p_IGD = friedman(rank_IGD);
% p_HV  = friedman(rank_HV);

for j = 1:c-2
    
    IGD_rank1                    = find(rank_IGD(:,j)==1);
    HV_rank1                     = find(rank_HV(:,j)==1);
    statistical_res.IGD{r+1,j+2} = length(IGD_rank1);
    statistical_res.HV{r+1,j+2}  = length(HV_rank1);
    
end


IGDc.better  = false(r-1,c-3);
IGDc.similar = false(r-1,c-3);
IGDc.worse   = false(r-1,c-3);
HVc.better   = false(r-1,c-3);
HVc.similar  = false(r-1,c-3);
HVc.worse    = false(r-1,c-3);

for i = 1:r-1
    for j = 1:c-3
        switch statistical_res.IGD{i+1,j+3}(end)
            case '+'
                IGDc.better(i,j) = true;
            case '-'
                IGDc.worse(i,j) = true;
            otherwise
                IGDc.similar(i,j) = true;
        end
        switch statistical_res.HV{i+1,j+3}(end)
            case '+'
                HVc.better(i,j) = true;
            case '-'
                HVc.worse(i,j)  = true;
            otherwise
                HVc.similar(i,j) = true;
        end
             
    end
end

IGDcomp = zeros(c-3,3);

HVcomp  = zeros(c-3,3);

for i = 1:c-3
    
    IGDcomp(i,:) = [sum(IGDc.better(:,i)),sum(IGDc.similar(:,i)),sum(IGDc.worse(:,i))];
    
    HVcomp(i,:)  = [sum(HVc.better(:,i)),sum(HVc.similar(:,i)),sum(HVc.worse(:,i))];
    
end

filename = [currPath,'\output\'];
% figure(1);
% ha = tight_subplot(1,2,[0.08,0.065],[0.15,0.03],[0.08,0.02]);
% axes(ha(1));
barplot(IGDcomp,'(a) IGD ',filename);
% axes(ha(2));
barplot(HVcomp,'(b) HV ',filename);


% b  = bar(IGDcomp,1,'grouped');
% % grid on;
% ch = get(b,'children');
% % set(ch,'FaceVertexCData',[0.85 0.33 0.10;0 0.45 0.74;0.93 0.69 0.13])
% set(ch{1},'FaceColor',[0.85 0.33 0.10]);
% set(ch{2},'FaceColor',[0 0.45 0.74]);
% set(ch{3},'FaceColor',[0.93 0.69 0.13]);
% set(gca,'XTickLabel',statistical_res.IGD(1,4:end),'XTickLabelRotation',46,'Fontsize',5,'Ygrid','on');
% fontsize = 6;
% h=legend('better','similar','worse');
% set(h,'FontName','Times New Roman','FontSize',fontsize,'FontWeight','normal','Location','Northeast')
% xlabel('(a) IGD','FontName','Times New Roman','FontSize',fontsize);
% ylabel('Number of test problems','FontName','Times New Roman','FontSize',fontsize);
% % title('Wilcoxon rank sum test in terms of IGD');
% set(gcf,'unit','centimeters','position',[10 5 9 8]);
% set(gca,'LooseInset',get(gca,'TightInset'),'ylim',[0,35])
% box off;
% % ax1 = axes('XAxisLocation','top','YAxisLocation','right','Color','none');
% % set(ax1,'XTick',[]);
% % set(ax1,'YTick',[]);
% set(gcf,'unit','centimeters','position',[16 5 9 8]);
% 
% savefig([filename,'IGD and HV of MaFs.fig']);
% print(gcf,'-djpeg','-r600',[filename,'IGD and HV of MaFs']);



% figure(2);
% b  = bar(HVcomp,1,'grouped');
% ch = get(b,'children');
% set(ch{1},'Facecolor',[1 0 0]);
% set(ch{2},'Facecolor',[0 1 0]);
% set(ch{3},'Facecolor',[0 0 1]);
% set(gca,'XTickLabel',statistical_res.HV(1,4:end),'XTickLabelRotation',46,'Fontsize',5,'Ygrid','on');
% h = legend('better','similar','worse');
% set(h,'FontName','Times New Roman','FontSize',5,'FontWeight','normal')
% xlabel('(b) HV');
% ylabel('Number of test problems ');
% box off;
% ax1 = axes('XAxisLocation','top','YAxisLocation','right','Color','none');
% set(ax1,'XTick',[]);
% set(ax1,'YTick',[]);
% set(gca,'Visible','off')
% % title('Wilcoxon rank sum test in terms of HV');
% set(gcf,'unit','centimeters','position',[10 5 9 8]);
% set(gca,'LooseInset',get(gca,'TightInset'),'ylim',[0,35]);
% savefig([filename,'HV of MaFs.fig'])
% print(gcf,'-djpeg','-r600',[filename,'HV of MaFs']);

end




function barplot(indicator,title_name,filename)
algorithmXlable   = {'MaOEA-DES','NSGA-III','RVEA','MOEA/DD','tDEA','MOMBI-II','1by1EA','KnEA'};
figure;
ha = tight_subplot(1,1,[0.08,0.065],[0.18,0.01],[0.07,0.01]);
axes(ha(1));
b  = bar(indicator,1,'grouped');
ch = get(b,'children');
set(ch{1},'Facecolor',[1 0 0]);
set(ch{2},'Facecolor',[0 1 0]);
set(ch{3},'Facecolor',[0 0 1]);
fontsize = 6;
set(gca,'XTickLabel',algorithmXlable,'XTickLabelRotation',36,'Fontsize',fontsize,'Ygrid','on');
h = legend('better','similar','worse');
set(h,'FontName','Times New Roman','FontSize',fontsize,'FontWeight','normal')
xlabel(title_name,'Fontname','Times New Roman');
ylabel('Number of test problems ','Fontname','Times New Roman');
box off;
ax1 = axes('XAxisLocation','top','YAxisLocation','right','Color','none');
set(ax1,'XTick',[],'YTick',[]);

set(gcf,'unit','centimeters','position',[6 5 9 8]);
set(gca,'Visible','off','LooseInset',get(gca,'TightInset'),'ylim',[0,35]);
%savefig([filename,title_name,'of MaFs.fig'])
print(gcf,'-djpeg','-r600',['/results/',title_name,'of MaFs']);

end
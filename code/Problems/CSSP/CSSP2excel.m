function CSSP2excel(statistical_res,M)
%save the result to excel

sheetname_IGD = ['MaOEA-MCSSS-IGD-M',num2str(M)];
sheetname_HV  = ['MaOEA-MCSSS-HV-M',num2str(M)];
sheetname_Time  = ['MaOEA-MCSSS-Time-M',num2str(M)];
statistical_res.IGD = Ranksum_evaluate(statistical_res.IGD);
statistical_res.HV = Ranksum_evaluate(statistical_res.HV);
statistical_res.Time = Ranksum_evaluate(statistical_res.Time);
[r,c]    = size( statistical_res.IGD );

currPath = fileparts( mfilename('fullpath') ); 

expand   = char(abs('A')+c-1);% A--->F

result_loc = ['A2:',expand,num2str(r+1)];


%write([currPath,'\output\RESULT.xlsx'],statistical_res.IGD,sheetname_IGD,result_loc);

%xlswrite([currPath,'\output\RESULT.xlsx'],statistical_res.HV,sheetname_HV,result_loc);
a = array2table(statistical_res.IGD);
b = array2table(statistical_res.HV);
c = array2table(statistical_res.Time);
%writetable(a,[currPath,'\output\RESULT.xlsx'],'Sheet',sheetname_IGD,'Range',result_loc);

%writetable(b,[currPath,'\output\RESULT.xlsx'],'Sheet',sheetname_HV,'Range',result_loc);


writetable(a,['/results/',sheetname_IGD,'.csv']);
 
writetable(b,['/results/',sheetname_HV,'.csv']);
 
writetable(c,['/results/',sheetname_Time,'.csv']);

fprintf('%d objectives results has filled the csv \n',M);


end






function IGD = Ranksum_evaluate(IGD)

[r,c] = size(IGD);
IGDc.better  = false(r-1,c-2);
IGDc.similar = false(r-1,c-2);
IGDc.worse   = false(r-1,c-2);

for i = 1:r-1
    
    for j = 1:c-2
        
        switch IGD{i+1,j+2}(end)
            case '+'
                IGDc.better(i,j) = true;
            case '-'
                IGDc.worse(i,j) = true;
            otherwise
                IGDc.similar(i,j) = true;
        end
             
    end
end

% IGDcomp = zeros(1c-2);

for j = 1:c-2
    
    IGD{r+1,j+2} = [num2str(sum(IGDc.better(:,j))),'/',num2str(sum(IGDc.similar(:,j))),'/',num2str(sum(IGDc.worse(:,j)))];
    
end





end

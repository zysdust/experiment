%%  algorithms test
runtime = 20;

M       = [5,8];

N       = [210,240];

evaluations = [50000,80000];

for k = 1:length(M)
    
for i = 1:16
    
    for j = 1 : runtime
        
        main('-algorithm',@MaOEADS,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-coefficient',0.1,'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MaOEADES,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-coefficient',0.2,'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@NSGAIII,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@tDEA, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@RVEA,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MOEADD, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@onebyoneEA,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MOMBIII,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@KnEA, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
    
    end
    
end

end









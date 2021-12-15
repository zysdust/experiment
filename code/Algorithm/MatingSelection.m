function ParentC = MatingSelection(Population,delta)
% %UNTITLED �˴���ʾ�йش˺�����ժҪ
% %   �˴���ʾ��ϸ˵��

N      = length(Population);

PopObj = Population.objs;

T      = ceil(N/10);

Angle  = acos(1 - pdist2(PopObj,PopObj,'cosine'));    

[~,B]  = sort(Angle,2);
    
B      = B(:,1:T);

ParentC = zeros(1, 2*N );

q = 1;

for i = 1: N
    
    if rand < delta
        
        P   = B(i,randperm(size(B,2)));
        
        two = P(1:2);
        
        ParentC(1,q)    = i;
        
        ParentC(1,q+1)  = two(2);
        
        q = q + 2;
        
    else
        
          
        ParentC(1,q)   = i;
        
        ParentC(1,q+1) = randi(N);
        
        q= q+2;
        
    end

end


end


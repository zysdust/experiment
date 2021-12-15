function Population = EnvironmentalSelection(Population,Maxsize,Global,Zmin,coefficient)
% The environmental selection of MaOEA-DS
PopObj = Population.objs;

[N,M]  = size(PopObj);

PopObj = PopObj - repmat(Zmin,N,1);

Extreme = zeros(1,M);

w       = zeros(M)+1e-6+eye(M);

for i = 1 : M
    
    [~,Extreme(i)] = min( max(PopObj./repmat(w(i,:),N,1),[],2) );
    
end

% Calculate the intercepts of the hyperplane constructed by the extreme points and the axes
%计算由极值点和轴构成的超平面的截距

if rank(PopObj(Extreme,:)) == M
    
    Hyperplane = PopObj(Extreme,:)\ones(M,1);
    
    a = 1./Hyperplane;
    
else
    
    a = max(PopObj,[],1)';
    
end

%  Normalization 标准化
% a = max(PopObj,[],1)'-Zmin';

PopObj      = PopObj./repmat(a',N,1);

%% Translate the population 转换种群

[V,W,Angle,Cosine] = BeaconIdentify(PopObj,Maxsize);

R  = find(~W);

B  = find(W);

%% Associate each solution to a beacon vector 将每个解决方案关联到一个信标矢量

R_associate = zeros(Maxsize,1);

for i = 1:Maxsize
    
    R_angle   = Angle(R(i),W);
    
   [~,index]  =  min(R_angle);
   
   R_associate(i) = index;
   
end

associate               = zeros(N,1);

associate( B )          = 1:Maxsize;

associate( R )          = R_associate;

%% Select one solution for each beacons vector 为每个信标矢量选择一个解决方案

Next          = false(1,N);

% Next(Extreme)  = true;

for i = 1: Maxsize
    
    current     = find(associate == i);
    
%     if ~isempty(intersect(current,Extreme))
%         
%         continue;
%         
%     end
    
    l = length(current);
    
    if l > 1
        
        Cosine_value =  Cosine(current,B(i));
        
%         Cosine      =  1 - pdist2(PopObj(current,:),V(i,:),'cosine');
        
        Distance2   =  sqrt(sum(PopObj(current,:).^2,2)).* sqrt(1-Cosine_value.^2); % 垂直距离
        
        Distance1   =  sqrt(sum(PopObj(current,:).^2,2)).* Cosine_value;           % 投影距离
        
        theta       =  coefficient * exp(Global.M * Global.evaluated/Global.evaluation / sum(V(i,:)));
        
        Distance    =  Distance1 + theta * Distance2;
        
        [~,index]   =  min( Distance ,[],1);
        
        Next( current(index) ) = true;
        
    else
        
        Next( current ) = true;
        
    end
    
    
end

Population = Population(Next);

end



function [UV,W,Angle,Cosine] = BeaconIdentify(PopObj,Maxsize)

N      = size(PopObj,1);

[~,Extrem]  = min(PopObj,[],1);

W = false(1,N);

% Extrem = zeros(1,M);
%     
% w       = zeros(M)+1e-6+eye(M);
% 
% for i = 1 : M
%     
%     [~,Extrem(i)] = min( max( (PopObj-repmat(Zmin,N,1))./repmat(w(i,:),N,1),[],2) );
%     
% end

% [~,Extrem]= min(PopObj,[],1);

W(1,Extrem) = true;

if sum(W) > N
    
    index = Extrem(randperm(length(Extrem),sum(W)-N));
    
    W(1,index) = false;
    
end

Cosine = 1 - pdist2(PopObj,PopObj,'cosine');

Angle = acos(Cosine);

Angle(logical(eye(N))) = inf;

R = ~W;

while sum(W)< Maxsize
    
    pos    = find(R);
    
    Assign = Angle(R,W);
   
    [B,~]         = min(Assign,[],2);
    
    [~,index]     = max(B);
    
    R(pos(index)) = false;
    
    W(pos(index)) = true;
       
end

V  = PopObj(W,:);

UV = zeros(size(V));

for i = 1:Maxsize

    UV(i,:) = V(i,:)/norm(V(i,:),2);

end


end





%     x  = sum(R);       y  =  sum(W);
%      
% %     Assign = zeros(length(x),length(y));
% %     
% %     for i = 1:length(x)
% %         
% %         for j = 1:length(y)
%             
%             Assign(i,j)= Angle(R(i),W(j));
%             
% %         end
% %         
% %     end
%     
%     [B,~]         = min(Assign,[],2);
%     
%     [~,index]     = max(B);
%     
%     R(index) = true;
%     
%     W(index) = True;
%     
%   %  W(1,x(index)) = true;
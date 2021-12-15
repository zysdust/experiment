function [newpop] = CrossoverOperation(varargin)
%CrossOver Operation

%
%   �Ʒ���ѡ�񲿷�===========mode1:
%   ���������򲿷�===========mode2:

if nargin == 4
    
    pop   = varargin{1}; % ��Ⱥ
    
    pc    = varargin{2};  % �������
    
    Guide = varargin{3};   % ��������
    
    mode1 = varargin{4}{1,1};
    
    mode2 = varargin{4}{1,2};
    
else
    
    pop    = varargin{1};
    
    pc     = varargin{2};
    
    Guide  = varargin{3};
    
    gen    = varargin{4};
    
    maxgen = varargin{5};
    
    if rand <= gen/maxgen
        
        mode1 = 'Uniform';mode2 = 'POX';
        
    else
        mode1 =  'Guide1';mode2 = 'Guide2';
    end
    
    
end

[r,c] = size(pop); newpop = pop;

for i = 1:2:r-1
    
    aa        = unidrnd(size(Guide,1));
    
    G         = Guide(aa,:);
    
    if rand <= pc
        
        switch mode1
            
            case 'Uniform'  %�Ʒ���ѡ����þ��Ƚ���
                
                temp = round(rand(1,c/2));
                
                for j = 1:c/2
                    
                    if temp(j) == 1
                        
                        newpop(i+1,j) = pop(i,j);
                        
                        newpop(i,j) = pop(i+1,j);
                        
                    end
                end
                
            case 'SinglePoint'% ���㽻��
                
                insert = unidrnd(c/2);
                
                newpop(i,1:insert) = pop(i+1,1:insert);
                
                newpop(i,insert+1:c/2) = pop(i,insert+1:c/2);
                
            case 'TwoPoint' % ���㽻��
                
                co=randperm(c/2,2);g=sort(co);
                
                cpoint1=g(1);cpoint2=g(2);
                
                newpop(i,1:c/2) = [pop(i,1:cpoint1),pop(i+1,cpoint1+1:cpoint2),pop(i,(cpoint2+1):c/2)];
                
                newpop(i+1,1:c/2) = [pop(i+1,1:cpoint1),pop(i,(cpoint1+1):cpoint2),pop(i+1,(cpoint2+1):c/2)];
                
            case 'Guide1' % �����Ÿ������������������Ϣ

                [newpop(i,1:c/2),newpop(i+1,1:c/2)] = GC1(pop(i,1:c/2),pop(i+1,1:c/2),G(1:c/2));
                
            case'MAV'
                
                newpop(i,1:c/2)   = MAV(G(1:c/2),pop(i,1:c/2));
                newpop(i+1,1:c/2) = MAV(G(1:c/2),pop(i+1,1:c/2));
                
            case 'RPX'
                
                p   = 0.9-(0.9-0.2)*Global.gen/Global.maxgen;
                
                temp = rand(1,c/2);
                
                index = temp< p;
                
                newpop(i+1,index) = pop(i,index);
                
                newpop(i,index)   = pop(i+1,index);
                
                
        end
        
        switch mode2
            
            case 'POX'   %  �����������POX���档 �ų��¡�������ҵ�����������������Ŵ��㷨*��
                
                [Child1,Child2] = POX(pop(i,c/2+1:c),pop(i+1,c/2+1:c));
                
                newpop(i,c/2+1:c) = Child1;
                
                newpop(i+1,c/2+1:c) = Child2;
                
            case 'OB'  % ����˳��Ľ���
                
                b = randperm(c/2,2);d = sort(b); e = d(1);f = d(2); % e��f����������Ĳ����
                
                [C1,C2] = OB(pop(i,c/2+1:c),pop(i+1,c/2+1:c),e,f);
                
                newpop(i,c/2+1:c) = C1;newpop(i+1,c/2+1:c) = C2;
                
            case 'Guide2'
                
                [newpop(i,1+c/2:c),newpop(i+1,1+c/2:c)] = GC2(pop(i,1+c/2:c),pop(i+1,1+c/2:c),G(c/2+1:c));
                
            case 'JSV'
                
                newpop(i,1+c/2:c)   = JSV(G(c/2+1:c),pop(i,1+c/2:c));
                
                newpop(i+1,1+c/2:c) = JSV(G(c/2+1:c),pop(i+1,1+c/2:c));
                
        end
        
        
    else
        
        newpop(i,1:c) = pop(i,1:c);newpop(i+1,1:c) = pop(i+1,1:c);
        
        
    end
    
end

end

function [Child1,Child2] = POX(parent1,parent2)

    Child1 = zeros(size(parent1));Child2 = zeros(size(parent2));
    Jobset = unique(parent1); % �����ŵļ���
    number_Jobset1 = unidrnd(length(Jobset));% ����1�ĸ���
    a = randperm(length(Jobset),number_Jobset1);
    Jobset1 = zeros(number_Jobset1,1);
    for i = 1:number_Jobset1
        Jobset1(i) = a(i);
    end
    P1.s = [];P2.s = [];

    for i = 1:length(parent1)
        if ismember(parent1(i),Jobset1) == 1
            Child1(i) = parent1(i);
        else
            P1.s = [P1.s,parent1(i)];
        end
    end

    for i = 1:length(parent2)
        if ismember(parent2(i),Jobset1) == 1
            Child2(i) = parent2(i);
        else
            P2.s = [P2.s,parent2(i)];
        end
    end
    p1=1;
    i = 1;
    while i<= length(P2.s)
        if Child1(p1) == 0
            Child1(p1)= P2.s(i);
            i = i + 1;
        else
            p1 = p1 + 1;
        end
    end
    p2 = 1;
    i = 1;
    while i<= length(P1.s)
        if Child2(p2) == 0
            Child2(p2)= P1.s(i);
            i = i + 1;
        else
            p2 = p2+1;
        end
         
    end

end



function [C1,C2] = OB(F1,F2,s1,s2)
% ����ĳ������p�����µ�Ⱦɫ������
% s1 ��s2 ��ʾ���������,s1<s2
% F1,F2: ����Ⱦɫ��
% C1,C2���Ӵ�Ⱦɫ��
C1=zeros(size(F1));
C2=zeros(size(F2));
L=length(F1);
P1=transtoP(F1);% ������������ʶ
P2=transtoP(F2);
F1_gene=P1(s1:s2); % ����1�б����Ļ���Ƭ�α�ʶ
F2_gene=P2(s1:s2); % ����2�б����Ļ���Ƭ�α�ʶ
C1(s1:s2)=F1(s1:s2);
C2(s1:s2)=F2(s1:s2);
F2_temp=zeros(size(F2));
F1_temp=zeros(size(F1));
if s2==L
    F2_temp=F2;
    F1_temp=F1;
else
    F1_temp(1:L-s2)=F1(s2+1:L);
    F1_temp(L-s2+1:L)=F1(1:s2);
    F2_temp(1:L-s2)=F2(s2+1:L);
    F2_temp(L-s2+1:L)=F2(1:s2);  
end
P1_temp=transtoP(F1_temp);  
P2_temp=transtoP(F2_temp);
rr(1).index=[];  % �ҳ���������Ƭ����ģ���е�λ��
rr(2).index=[];
for i=1:s2-s1+1
    index1=find(P2_temp==F1_gene(i));% ��¼Ҫɾ����ָ��
    index2=find(P1_temp==F2_gene(i));
    rr(1).index=[rr(1).index index1];
    rr(2).index=[rr(2).index index2];
end
F2_temp(rr(1).index)=[];
F1_temp(rr(2).index)=[];
if s2~=L
    if s1~=1
    C1(s2+1:L)=F2_temp(1:L-s2);
    C1(1:s1-1)=F2_temp(L-s2+1:length(F2_temp));
    C2(s2+1:L)=F1_temp(1:L-s2);
    C2(1:s1-1)=F1_temp(L-s2+1:length(F1_temp));
    else
     C1(s2+1:L)=F2_temp;
     C2(s2+1:L)=F1_temp;
    end
else
    if s1==1
        C1=F1;
        C2=F2;
    else 
        C1(1:s1-1)=F2_temp;
        C2(1:s1-1)=F1_temp;
    
    end
end
        
end

function P_record=transtoP(p)
% ����������������ת��Ϊ�ܹ�����ڼ�������͵ڼ���������
c=length(p);
task=unique(p);
a=ones(length(task),1);  % ͳ��ÿ�������������ڼ��γ���
P_record=zeros(1,length(p));
for i=1:c   
        if p(i)==1
           P_record(i)=10+0.1*a(1);
           a(1)=a(1)+1;
        end
        
       for u=2:length(task)
          if p(i)==u
           P_record(i)=10*u+0.1*a(u);
           a(u)=a(u)+1;
          end
       end 
end
end



function [P1,P2] = GC1(P1,P2,G)

% �Ʒ���ѡ�񲿷ָ�������������н���

c    = length(P1);

Set  = randperm(c); G_remain = round(c* 0.2); P1_remain = round(c * 0.3);
                
set1 = Set(1:1+G_remain); % 

set2 = Set(2+G_remain:2+G_remain+P1_remain);
                
set3 = setdiff(Set,[set1,set2]);

for j = 1:c
                    
    if ismember(j,set1)
                        
        P1(j) = G(j);
                        
        P2(j) = G(j);
                        
    elseif ismember(j,set3)
                        
         p     = P1(j);
         
         P1(j) = P2(j);
         
         P2(j) = p;
                        
    end
    
end


end



function [C1,C2] = GC2(P1,P2,G)
% ���������򲿷ָ�������������н���
% G�е�c*k1������λ����Ӧ�������񱣳ֲ��䣬C1��C2�ֱ�̳�P1��P2���ⲿ�ֻ���λ
% ʣ�µĻ���λ�໥�����������
c        = length(P1);

C1 = P1;C2=P2;

d        = randperm(c);
G_remain = d(1:round(0.1 * c)); % ��������λ
G_P      = transtoP(G);

P1_P     = transtoP(P1); P2_P     = transtoP(P2);
P1_index = [];           P2_index = [];

for i = 1:length(G_remain)
    
    P1_index = [P1_index,find(  P1_P == G_P(G_remain(i)))];
    P2_index = [P2_index,find(  P2_P == G_P(G_remain(i)))];
    
end
P1_exchange = setdiff(1:c,P1_index);
P2_exchange = setdiff(1:c,P2_index);
k=1; r=1;
for j = 1:c
    
    if ~ismember(j,P1_index)
        
        C1(j) = P2(P2_exchange(k));
        
        k=k+1;
    end
    
    if ~ismember(j,P2_index)
        
        C2(j) = P1(P1_exchange(r));
        
        r=r+1;
        
    end
    
end

end




function new = JSV(Leader,Wolf)
new      = Leader;
Jobset   = unique(Wolf); % �����ŵļ���
n        = unidrnd(length(Jobset));% ���ѡ����ٸ�����������Ӧ�Ļ���λ��������
set1     = randperm(length(Jobset),n); % [1,2]
set2     = setdiff(Jobset,set1); %[3,4]
pos      = ismember(set2,Wolf);
npos     = ismember(set1,Wolf);
new(pos) = Wolf(npos);

end



function new = MAV(Leader,Wolf)
c = length(Wolf);
new      = Leader;
temp = round(rand(1,c));

for j = 1:c
    
    if temp(j) == 1
        
        new(j) = Wolf(j);
        
    end
    
end


end
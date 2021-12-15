function objectvalue = Obj_CSSP(Global,pop)

%   Objectives_functions

[r,c]           = size(pop);

lt = 0.008;    lc = 0.005;     le = 0.002;   

t  = length(Global.st);  st = Global.st;    cs = Global.cs;    user = Global.user;

ETC =   Global.ETC;

stlj = cumsum(st); stlj1=[1,stlj+1];

uer_cumsum = cumsum(Global.utasknum);



userT     =  zeros(r,user);       userC       = zeros(r,user); 
userE     =  zeros(r,user);       userQ       = zeros(r,user); %
userR       = zeros(r,user);


taskT    =  zeros(r,t);          tasksumC    = zeros(r,t);   tasksumE   =zeros(r,t);
taskQ    =  zeros(r,t);          taskLT      = zeros(r,t);    taskLC    =zeros(r,t);
taskR    =  zeros(r,t); 


Makespan    =  zeros(r,1);       Completecost = zeros(r,1);    TEC      = zeros(r,1);

AvgserviceQ =  zeros(r,1);        Workload    = zeros(r,1);    Idle     = zeros(r,1);

AvgserviceR =  zeros(r,1); 


P = calculateP( pop(:,c/2+1:c) );


yi = 1;
for i = 1:length(Global.utasknum)
    U(yi:uer_cumsum(i))= i;
    yi = uer_cumsum(i)+1;
end



for i = 1:r
    
    % Time -----1.����ҵ��   2. ��Դ����  3.����ʱ��  4.����ɱ�+�����ɱ� 5.�������� 6.����ɿ���
    
    %        7. �����ܺ� 8.ST(��ʼʱ��)  9.FT(����ʱ��)  10. �����ɱ�
    
    Time = zeros(c/2,10);
    
    for u = 1:size(ETC.EInform,1)
        
        t_record{u,1} = zeros(size(ETC.EInform{u,1})); % ÿ����ҵ��ÿ�ַ�����깤ʱ���¼
        
    end
    
    %% ��������깤ʱ��
    
    for j = 1:c/2
        
            x = floor(P(i,j)/10);    y = round(rem(P(i,j),10)*10); % ��x������ĵ�y��������
            
            position = stlj1(x) + y - 1;
            
            M = pop(i,position);  % ��M����ҵ
            
            POSITION = find( ETC.AE(position).s == M ); % ��ҵ�ĵڼ�����Դ
            
            f = ETC.AE(position).index(POSITION);  % ��ҵM�ĵ�f����Դ
            
            Time(position,1) = M;   Time(position,2) = ETC.StInform(position,1);
            
            Time(position,3) = ETC.EInform{M,2}(f);
            
            if y == 1 
                
               Time(position,4)     = ETC.EInform{M,3}(f);% ����ɱ�
               
               Time(position,5)     = ETC.EInform{M,4}(f); % ��������
               
               Time(position,6)     = ETC.EInform{M,5}(f); % ����ɿ���
               
               Time(position,7)     = ETC.EInform{M,6}(f); % �����ܺ�
               
               Time(position,8)     = t_record{M,1}(f); % ��ʼʱ��
               
               Time(position,9)     = Time(position,8) +Time(position,3) ;% �깤ʱ��
               
               t_record{M,1}(f)     = Time(position,9);  % ��ҵ��i����Դ��ʱ���¼
               
               Time(position,10)    = 0;  % �����ɱ�
               
            else  
               
               Time(position,4)          = ETC.EInform{M,3}(f)+ETC.D(Time(position-1,1),M) * lc;  % ����ɱ�+�����ɱ�
               Time(position,5)          = ETC.EInform{M,4}(f);                                   % �������� 
               Time(position,6)          = ETC.EInform{M,5}(f);                                   % ����ɿ���
               Time(position,7)          = ETC.EInform{M,6}(f) + ETC.D(Time(position-1,1),M) * le; % �����ܺ�
               Time(position,8)          = max([t_record{M,1}(f),Time(position-1,9) + ETC.D(Time(position-1,1),M)*lt]);
               Time(position,9)          = Time(position,8) + Time(position,3);  % ����ʱ��
               t_record{M,1}(f)          = Time(position,9);
               Time(position,10)         = ETC.D(Time(position-1,1),M) * lc;
               
           end

    end 
    
    % ����ÿ��������깤ʱ�䡢�깤�ɱ�
    
    q = 1;
    
    for k = 1:t
        
        taskT(i,k)    = max(Time(q:stlj(k),9)) + ETC.D( pop(i,stlj(k)),cs+U(k))*lt;
        
        tasksumC(i,k) = sum(Time(q:stlj(k),4)) + ETC.D(pop(i,stlj(k)),cs+U(k)) *lc;
        
        tasksumE(i,k) = sum(Time(q:stlj(k),7)) + ETC.D(pop(i,stlj(k)),cs+U(k)) *le;
        
        taskQ(i,k)    = prod(Time(q:stlj(k),5));
        
        taskR(i,k)    = prod(Time(q:stlj(k),6));
        
        taskLC(i,k)   = sum(Time(q:stlj(k),10));
        
        q = stlj(k) + 1;
        
    end
    
        W = zeros(cs,1); E_Idle = zeros(cs,1);
        
        for g = 1:cs   % ��ҵ����
            
            index = find( Time(:,1)==g );
            
            if ~isempty(index)
                
                g2          = length(unique(Time(index,2))); % ��Դ��������
                
                W(g,1)      = sum(Time(index,3));        % ��g����ҵ�Ĺ�������
                
                E_Idle(g,1) = g2 * max(Time(index,9)) -W(g,1);
                
            end
            
        end  
    
    
    % ����ÿ���û����ܺ�
    
    
    p     = 1;
        
    for u = 1: user
            
            userT(i,u) = max(taskT(i,p:uer_cumsum(u)));       % ��i���û��Ľ���ʱ��
            
            userC(i,u) = sum(tasksumC(i,p:uer_cumsum(u)));    % ��i���û��ύ������ĳɱ�
            
            userE(i,u) = sum(tasksumE(i,p:uer_cumsum(u)));    % ��i���û�����������ܺ�
            
            userQ(i,u) = sum(taskQ(i,p:uer_cumsum(u)))/Global.utasknum(u); % ��i���û���ƽ����������
            
            userR(i,u) = sum(taskR(i,p:uer_cumsum(u)))/Global.utasknum(u); % ��i���û���ƽ������ɿ���

            p = 1 + uer_cumsum(u);   
            
    end  
    
       Makespan(i,1)        = max(userT(i,:));    % ��¼����Ⱥ��ÿ���Ʒ����ϵ��깤ʱ�䣬ȡ���ֵ��Ϊ����������깤ʱ��
       
       Completecost(i,1)    = sum(userC(i,:));    % �����û����ܳɱ�
       
       AvgserviceQ(i,1)     = 1/min( userQ(i,:) );
       
       AvgserviceR(i,1)     = 1/min( userR(i,:) );
       
       TEC(i,1)             = sum(userE(i,:));    % �����û����ܺ�
       
       Workload(i,1)        = max(W);
       
       Idle(i,1)            = sum(E_Idle);
       
       
    
end

if Global.M == 5
    
    objectvalue = [Makespan,Completecost,AvgserviceQ,AvgserviceR,TEC];
    
elseif Global.M == 8
    
    objectvalue = [Makespan,Completecost,AvgserviceQ,AvgserviceR,TEC,Workload,Idle,sum(taskLC,2)];
    
end

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

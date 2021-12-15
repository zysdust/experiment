classdef PROBLEM < handle
%PROBLEM - The superclass of all the problems.
%
%   This is the superclass of all the problems. This class cannot be
%   instantiated.

    properties(SetAccess = private)
        Global; % The current GLOBAL object
    end
    methods(Access = protected)
        %% Constructor
        function obj = PROBLEM()
            obj.Global = GLOBAL.GetObj();
        end
    end
    methods
        %% Generate initial population
        function PopDec = Init(obj,N)
            switch obj.Global.encoding               
                case 'binary'
                    PopDec = randi([0,1],N,obj.Global.D);
                case 'permutation'
                    [~,PopDec] = sort(rand(N,obj.Global.D),2);
                case 'integer3'
                        stlj = cumsum(obj.Global.st);r=1;
                        for i=1:length(obj.Global.st)
                            seed(r:stlj(i))=i;r=stlj(i)+1;
                        end
                        PopDec=zeros(obj.Global.N,obj.Global.D);
                        available = obj.Global.ETC.available;
                        LS_options = obj.Global.ETC.LS_options;
                        for i=1:obj.Global.N
                            for j=1:obj.Global.D/3
                                PopDec(i,j)=available(j).s(unidrnd(length(available(j).s)));
                            end
                            PopDec(i,(obj.Global.D/3+1):(2*obj.Global.D/3))=seed(randperm(numel(seed)));
                            p=1;
                            for j = (2*obj.Global.D/3+1):obj.Global.D
                                PopDec(i,j)=LS_options(p).s(unidrnd(length(LS_options(p).s)));
                                p = p+1;
                            end
                        end
                        
                 case 'integer2'
                     
                            stlj = cumsum(obj.Global.st);
                            
                            r=1;
                            
                            for i=1:length(obj.Global.st)
                                
                                seed(r:stlj(i))=i;r=stlj(i)+1;
                            end
                            
                            PopDec=zeros(N,obj.Global.D);
                            
                            available = obj.Global.ETC.available;
                            
                            for i=1:N
                                
                                for j=1:obj.Global.D/2
                                    
                                    PopDec(i,j)=available(j).s(unidrnd(length(available(j).s)));
                                    
                                end
                                    PopDec(i,(obj.Global.D/2+1):obj.Global.D)=seed(randperm(numel(seed)));                        
                            end
%                     PopDec = InitialPop_heuristic(obj.Global);
                    
                case 'float'
                    
                    PopDec = unifrnd(0,1,N,obj.Global.D);
                    
                case 'INTEGER'
                    
                    stlj = cumsum(obj.Global.st);r=1;
                    for i=1:length(obj.Global.st)
                        seed(r:stlj(i))=i;r=stlj(i)+1;
                    end
                    
                    PopDec=zeros(obj.Global.N,obj.Global.D);
                    
                    available = obj.Global.ETC.AE;
                    
                    for i=1:obj.Global.N
                                
                        for j=1:obj.Global.D/2
                             PopDec(i,j)=available(j).s(unidrnd(length(available(j).s)));
                        end
                        PopDec(i,(obj.Global.D/2+1):obj.Global.D)=seed(randperm(numel(seed)));                        
                    end
                        
                    
                otherwise
                    
                    PopDec = unifrnd(repmat(obj.Global.lower,N,1),repmat(obj.Global.upper,N,1));
            end
        end
        %% Repair infeasible solutions
        function PopDec = CalDec(obj,PopDec)
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            PopObj(:,1) = PopDec(:,1)   + sum(PopDec(:,2:end),2);
            PopObj(:,2) = 1-PopDec(:,1) + sum(PopDec(:,2:end),2);
        end
        %% Calculate constraint violations
        function PopCon = CalCon(obj,PopDec)
            PopCon = zeros(size(PopDec,1),1);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P = ones(1,obj.Global.M);
        end
        %% Draw special figure
        function Draw(obj,PopDec)
            
        end
    end
end
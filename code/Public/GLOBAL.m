classdef GLOBAL < handle
%GLOBAL - The class of experimental setting.

    properties
        N=100;                          % ��Ⱥ��С  
    end  
    properties(SetAccess = ?PROBLEM)    
        M;                              % Ŀ�꺯���ĸ���
        D;                              % ���߱����ĸ���
        lower;                          % ���߱������½�
        upper;                          % ���߱������Ͻ� 
        user;
        st;         
        utasknum; 
        TEST;                           % ���û����������
        Mat;                            % ���û�����ľ���
        cs; 
        ETC; 
        coefficient;                    % ���û�����ĸ�����
        encoding;                       % ���뷽ʽ
        evaluation = 50000;             % ������������
        maxgen     = 500;               % ���ĵ�������
        pm         = 0.1;
        pc         = 0.9;
        gen        = 0; 
        KC         = 0.08;
    end
    
    properties(SetAccess = ?INDIVIDUAL)      
        evaluated  = 0;                 % Number of evaluated individuals
    end
    
    properties(SetAccess = private)
        algorithm  = @NSGAII;       	% Algorithm function
        problem    = @DTLZ2;            % Problem function
%         gen = 0;                      % Current generation
%         maxgen     = 10;              % Maximum generation
        run        = 1;                 % Run number
        runtime    = 0;                 % Runtime
        save       = 0;             	% Number of saved populations
        result     = {};                % Set of saved populations
        PF;                             % True Pareto front
        parameter  = struct();      	% Parameters of functions specified by users
        outputFcn  = @GLOBAL.Output;  	% Function invoked after each generation
    end
    
    
    
    methods
        %% Constructor
        function obj = GLOBAL(varargin)
            %   GLOBAL - Constructor of GLOBAL class.
            %
            %   GLOBAL('-Name',Value,'-Name',Value,...) returns an object with
            %   the properties specified by the inputs.
            %
            %   Example:
            %       GLOBAL('-algorithm',@NSGAII,'-problem',@DTLZ2,'-N',100,...
            %              '-M',2,'-D',10)
            
            obj.GetObj(obj);
            % Initialize the parameters which can be specified by users
            propertyStr = {'N','M','D','algorithm','maxgen','pm','pc','KC','problem','user',...
                'evaluation','run','parameter','Mat','TEST','coefficient','save','outputFcn'};
            if nargin > 0
                IsString = find(cellfun(@ischar,varargin(1:end-1))&~cellfun(@isempty,varargin(2:end)));
                [~,Loc]  = ismember(varargin(IsString),cellfun(@(S)['-',S],propertyStr,'UniformOutput',false));
                for i = find(Loc)
                    obj.(varargin{IsString(i)}(2:end)) = varargin{IsString(i)+1};
                end
            end
            % Instantiate a problem object ʵ����һ������
            obj.problem = obj.problem();
            % Add the folders of the algorithm and problem to the top of
            % the search path
            addpath(fileparts(which(class(obj.problem))));
            addpath(fileparts(which(func2str(obj.algorithm))));
        end
        %% Start running the algorithm
        function Start(obj)
            
            if obj.evaluated <= 0
                obj.PF = obj.problem.PF(10000);
                try
                    tic;
                    obj.algorithm(obj);  % �����㷨�Ķ���Global
                catch  err
                    if strcmp(err.identifier,'GLOBAL:Termination')
                        return;
                    else
                        rethrow(err);
                    end
                end
                
                obj.evaluated = max(obj.evaluated,obj.evaluation);
                
                if isempty(obj.result)
                    
                    obj.result = {obj.evaluated,INDIVIDUAL()};
                    
                end
                
                obj.outputFcn(obj);
            end
        end
        %% Randomly generate an initial population
        function Population = Initialization(obj,N)
            if nargin < 2
                N = obj.N;
            end
            Population = INDIVIDUAL(obj.problem.Init(N));
        end
        %% Terminate the algorithm if the number of evaluations has exceeded
        function notermination = NotTermination(obj,Population)
            % Accumulate the runtime
            obj.runtime = obj.runtime + toc;
            % Save the last population
            if obj.save<=0; num=10; else; num = obj.save; end
            index = max(1,min(min(num,size(obj.result,1)+1),ceil(num*obj.gen/obj.maxgen)));
            obj.result(index,:) = {obj.gen,Population};
            % Invoke obj.outputFcn
            drawnow();
            obj.outputFcn(obj);  % ������
%             obj.gen = obj.gen + 1;
            % Detect whether the number of evaluations has exceeded
            notermination = obj.evaluated < obj.evaluation;
%             notermination = obj.gen <= obj.maxgen;
            assert(notermination,'GLOBAL:Termination','Algorithm has terminated');
            tic;
        end
        %% Obtain the parameter settings from user
        function varargout = ParameterSet(obj,varargin)
            %ParameterSet - Obtain the parameter settings from user.
            %
            %   [p1,p2,...] = obj.ParameterSet(v1,v2,...) returns the values of
            %   p1, p2, ..., where v1, v2, ... are their default values. The
            %   values are specified by the user with the following form:
            %   MOEA(...,'-X_parameter',{p1,p2,...},...), where X is the
            %   function name of the caller.
            %
            %   MOEA(...,'-X_parameter',{[],p2,...},...) indicates that p1 is
            %   not specified by the user, and p1 equals to its default value
            %   v1.
            %
            %   Example:
            %       [p1,p2,p3] = obj.ParameterSet(1,2,3)
            
            CallStack = dbstack(); % ��ջ
            caller    = CallStack(2).file;
            caller    = caller(1:end-2);  % �㷨����
            varargout = varargin;
            if isfield(obj.parameter,caller) % �ж�caller �Ƿ�Ϊobj.parameter���ֶ�
                specified = cellfun(@(S)~isempty(S),obj.parameter.(caller));
                varargout(specified) = obj.parameter.(caller)(specified);
            end
        end
        %% Variable constraint
        function set.N(obj,value)
            obj.Validation(value,'int','size of population ''-N''',1);
            obj.N = value;
        end
        function set.M(obj,value)
            obj.Validation(value,'int','number of objectives ''-M''',2);
            obj.M = value;
        end
        function set.user(obj,value)
            obj.Validation(value,'int','number of users ''-user''',1);
            obj.user = value;
        end
        function set.D(obj,value)
            obj.Validation(value,'int','number of variables ''-D''',1);
            obj.D = value;
        end
        
        function set.maxgen(obj,value)
            obj.Validation(value,'int','maxmimal iteration ''-maxgen''',1);
            obj.maxgen = value;
        end
        
        function set.KC(obj,value)
            obj.Validation(value,'int','cluster ''-KC''',1);
            obj.KC = value;
        end
        
        function set.pm(obj,value)
            obj.Validation(value,'float','probability of mutation ''-pm''',1);
            obj.pm = value;
        end
        
        function set.pc(obj,value)
            obj.Validation(value,'float','probability of crossover ''-pc''',1);
            obj.pc = value;
        end
        function set.coefficient(obj,value)
            obj.Validation(value,'float','coefficient ''-coefficient''',1);
            obj.coefficient = value;
        end
        function set.Mat(obj,value)
            obj.Validation(value,'mat','mat''-mat''',1);
            obj.Mat = value;
        end
        function set.TEST(obj,value)
            obj.Validation(value,'int','case ''-TEST''',1);
            obj.TEST = value;
        end
        function set.algorithm(obj,value)
            if iscell(value)
                obj.Validation(value{1},'function','algorithm ''-algorithm''');
                obj.algorithm = value{1};
                obj.parameter.(func2str(value{1})) = value(2:end);
            else
                obj.Validation(value,'function','algorithm ''-algorithm''');
                obj.algorithm = value;
            end
        end
        function set.problem(obj,value)
            if iscell(value)
                obj.Validation(value{1},'function','test problem ''-problem''');
                obj.problem = value{1};
                obj.parameter.(func2str(value{1})) = value(2:end);
                
            elseif ~isa(value,'PROBLEM')
                obj.Validation(value,'function','test problem ''-problem''');
                obj.problem = value;
            else
                obj.problem = value;
            end
        end
        function set.evaluation(obj,value)
            obj.Validation(value,'int','number of evaluations ''-evaluation''',1);
            obj.evaluation = value;
        end
        function set.run(obj,value)
            obj.Validation(value,'int','run number ''-run''',1);
            obj.run = value;
        end
        function set.save(obj,value)
            obj.Validation(value,'int','number of saved populations ''-save''',0);
            obj.save = value;
        end
        %         Variable dependence
        function value = get.gen(obj)
            value = ceil(obj.evaluated/obj.N);
        end
        function value = get.maxgen(obj)
            value = ceil(obj.evaluation/obj.N);
        end
        
    end
    methods(Static)
        %% Get the current GLOBAL object
        function obj = GetObj(obj)
        
            persistent Global;
            if nargin > 0
                Global = obj;
            else
                obj = Global;
            end
        end
    end
    

    % The following functions cannot be invoked by users
    methods(Access = private)
        %% Check the validity of the specific variable
        function Validation(obj,value,Type,str,varargin)
            switch Type       
                case 'function'
                    assert(isa(value,'function_handle'),'INPUT ERROR: the %s must be a function handle',str);
                    assert(~isempty(which(func2str(value))),'INPUT ERROR: the function <%s> does not exist',func2str(value));
                case 'int'                   
                    assert(isa(value,'double') && isreal(value) && isscalar(value) && value==fix(value),'INPUT ERROR: the %s must be an integer scalar',str);
%                     if ~isempty(varargin); assert(value>=varargin{1},'INPUT ERROR: the %s must be not less than %d',str,varargin{1}); end
                    if length(varargin) > 1; assert(value<=varargin{2},'INPUT ERROR: the %s must be not more than %d',str,varargin{2}); end
                    if length(varargin) > 2; assert(mod(value,varargin{3})==0,'INPUT ERROR: the %s must be a multiple of %d',str,varargin{3}); end
                    
                otherwise
           
            end
        end
    end
    methods(Access = private, Static)
        %% Display or save the result after the algorithm is terminated
        function Output(obj)
            
            clc; fprintf('%s on %s, %d objectives %d variables, run %d (%6.2f%%), %.2fs passed...\n',...
                         func2str(obj.algorithm),class(obj.problem),obj.M,obj.D,obj.run,(obj.gen/obj.maxgen)*100,obj.runtime);
            if obj.evaluated>= obj.evaluation
                if obj.save == 0  % explay the result only
                    
                    Feasible     = find(all(obj.result{end}.cons<=0,2));          
                    NonDominated = NDSort(obj.result{end}(Feasible).objs,1) == 1; 
                    Population   = obj.result{end}(NonDominated);
                    % Calculate the metric values
                    if length(Population) >= size(obj.PF,1)
                        Metrics = {@HV};
                    else
                        Metrics = {@IGD};
                    end
                    Score = cellfun(@(S)GLOBAL.Metric(S,Population,obj.PF),Metrics,'UniformOutput',false);
                    MetricStr = cellfun(@(S)[func2str(S),' : %.4e  '],Metrics,'UniformOutput',false);
                    % Display the results
                    figure('NumberTitle','off','UserData',struct(),...
                        'Name',sprintf([MetricStr{:},'Runtime : %.2fs'],Score{:},obj.runtime));
                    title(sprintf('%s on %s %d iteration',func2str(obj.algorithm),class(obj.problem),obj.gen),'Interpreter','none');
                    Draw(Population.objs);hold on;
                    % Add new menus to the figure
                    top = uimenu(gcf,'Label','Data Source');
                    uimenu(top,'Label','Result (PF)',     'CallBack',{@(hObject,~,obj,P)eval('cla;Draw(P.objs);GLOBAL.cb_menu(hObject);'),obj,Population},'Checked','on');
                    uimenu(top,'Label','Result (PS)',     'CallBack',{@(hObject,~,obj,P)eval('cla;Draw(P.decs);GLOBAL.cb_menu(hObject);'),obj,Population});
                    uimenu(top,'Label','Result (Special)','CallBack',{@(hObject,~,obj,P)eval('obj.problem.Draw(P.decs);GLOBAL.cb_menu(hObject);'),obj,Population});
                    uimenu(top,'Label','True PF',         'CallBack',{@(hObject,~,obj)eval('cla;Draw(obj.PF);GLOBAL.cb_menu(hObject);'),obj},'Separator','on');
                    uimenu(top,'Label','IGD',             'CallBack',{@GLOBAL.cb_metric,obj,@IGD},'Separator','on');
                    uimenu(top,'Label','HV',              'CallBack',{@GLOBAL.cb_metric,obj,@HV});
                    uimenu(top,'Label','GD',              'CallBack',{@GLOBAL.cb_metric,obj,@GD});
                    uimenu(top,'Label','CPF',             'CallBack',{@GLOBAL.cb_metric,obj,@CPF});
                    
                else
                    % folder = fullfile('Data\MaF\',class(obj.problem),func2str(obj.algorithm));
                    folder = fullfile('./data',class(obj.problem),func2str(obj.algorithm),[func2str(obj.algorithm),'_U',num2str(obj.user)]);
                    % folder = fullfile('Data',class(obj.problem),func2str(obj.algorithm),['SensitivityAnalysis',num2str(obj.TEST)]);
                    [~,~]        = mkdir(folder);
                    NonDominated = NDSort(obj.result{end}.objs,1) == 1; 
                    Population   = obj.result{end}(NonDominated);
                    Score_HV     = cellfun(@(S)GLOBAL.Metric(S,Population,obj.PF),{@HV},'UniformOutput',false);
                    Score_IGD    = cellfun(@(S)GLOBAL.Metric(S,Population,obj.PF),{@IGD},'UniformOutput',false);
                    result       = obj.result;
                    metric.time  = obj.runtime;
                    metric.HV    = Score_HV;
                    metric.IGD   = Score_IGD;
                    save(fullfile(folder,sprintf('%s_%s_M%d_D%d_%d.mat',...
                        func2str(obj.algorithm),class(obj.problem),obj.M,obj.D,obj.run)),'result','metric');
                    
                    % ----------------------------coefficient-------------------------------------
                    %                       save(fullfile(folder,sprintf('%s_%s_M%d_D%d_%d_%s.mat',func2str(obj.algorithm),class(obj.problem),obj.M,obj.D,obj.run,...
                    %                           num2str(obj.coefficient))),'result','metric');

                end
            end
        end
        
        function value = Metric(metric,Population,PF)
            % Calculate the metric value of the population
            Feasible     = find(all(Population.cons<=0,2));
            NonDominated = NDSort(Population(Feasible).objs,1) == 1;
            try
                value = metric(Population(Feasible(NonDominated)).objs,PF);
            catch
                value = NaN;
            end
        end
    end
end
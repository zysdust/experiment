
Source code introduction:
Relying on the development of platEMO, platEMO is a multi-objective optimization tool based on MATLAB.
Folder and file description:
1. Algorithms: used to store the source code of all MOEAs.
2.Metrics: used to store the source code of all performance indicators.
3.Operators: used to store the source code of all operators.
4.Problems: used to store the source code of all MOPs.
5. Public: used to store public classes and utility functions.
6.results: used to store experimental results. The position needs to be reset when the code reappears.
7.main.m: The interface of PlatEMO.
8.run.m: program entry for MATLAB operation.
Parameter introduction:
-algorithm. The function of the MOEA to be executed.
-problem. MOP to be resolved.
-N. The population size of MOEA. Note that it is fixed at certain specific values ​​in some MOEAs (such as moea.m), so the actual population size of these MOEAs may not be exactly equal to this parameter.
-M. The target number of MOP. Note that in non-scalable MOPs (such as ZDT1.m), the number of targets is constant, so this parameter is invalid for these MOPs.
-D. The number of MOP decision variables. Note that in some MOPs, the number of decision variables is constant or fixed to some specific integer (for example: ZDT5.m), so the actual number of decision variables may not be completely equal to this parameter.
-evaluation. The maximum number of function evaluations.
-run. The number of runs. If the user wants to save multiple results for the same algorithm, problem, M and D parameters, then modify this parameter each time it runs to make the file name of the result different.
-save. The saved population. If this parameter is set to 0 (default value),
-outputFcn. The function to be called after each generation, usually does not need to be modified.


源码介绍：
依托 platEMO 的开发，platEMO是一款基于MATLAB的多目标优化工具。
文件夹与文件说明：
1.Algorithms：用于存储所有MOEAs的源代码。
2.Metrics：用于存储所有性能指标的源代码。
3.Operators：用于存储所有操作符的源代码。
4.Problems：用于存储所有MOPs的源代码。
5.Public：用于存储公共类和实用程序函数。
6.results: 用于存储实验结果。代码复现时需重设位置。
7.main.m：PlatEMO的接口。
8.run.m: MATLAB运行的程序入口。
参数介绍：
-algorithm. 要执行的MOEA的函数。
-problem. 待解决的MOP。
-N. MOEA的种群规模。注意，它被固定在某些MOEAs(例如moea .m)中的某些特定值上，因此这些MOEAs的实际种群大小可能并不完全等于这个参数。
-M. MOP的目标数目。注意，在不可伸缩的MOPs(例如ZDT1.m)中，目标的数量是恒定的，因此这个参数对于这些MOPs是无效的。
-D. MOP决策变量的个数。注意，在某些MOP中，决策变量的数量是常量或固定到某些特定整数上的(例如：ZDT5.m)，因此决策变量的实际数量可能并不完全等于这个参数。
-evaluation. 函数评价的最大数目。
-run. 运行数。如果用户希望为相同的算法、问题、M和D参数保存多个结果，则在每次运行时修改此参数，使结果的文件名不同。
-save. 保存的种群。如果将该参数设置为0(默认值)，
-outputFcn. 每次生成后调用的函数，通常不需要修改。
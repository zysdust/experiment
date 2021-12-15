 function main(varargin)%varargin就是一个cell数组，它包含了用户输入的参数
%cd newFolder 将当前文件夹更改为 newFolder    cd 显示当前文件夹。
%fileparts(filename) 返回指定文件的路径名称、文件名和扩展名  不会验证文件是否存在。
%mfilename('fullpath') 返回其中进行了调用的文件的完整路径和名称，不包括文件扩展名。
%genpath(folderName) 返回一个包含路径名称的字符向量，该路径名称中包含 folderName 以及 folderName 下的多级子文件夹
%addpath向搜索路径中添加文件夹
    cd(fileparts(mfilename('fullpath')));  % 将当前文件夹更改为该函数所在的路径
    addpath(genpath(cd)); % 将文件夹及其子文件夹添加到搜索路径
    %本函数function main(varargin)，在调用该main的时候，输入的参数就是varargin
    if isempty(varargin)    %确定数组是否为空，为空返回true；本函数执行执行的，varargin为空，则true
        if verLessThan('matlab','8.4')  %将工具箱版本与指定的字符向量进行比较；8.4是2014，本程序是2021，版本号9.11.0。如果工具箱的版本早于 version 指定的值，将返回逻辑值 (true)
            errordlg('Fail to establish the GUI of PlatEMO, since the version of MATLAB is lower than 8.4 (R2014b). You can run PlatEMO without GUI by invoking main() with parameters.','Error','modal');
        else
            GUI();
        end
    else
        if verLessThan('matlab','7.14')
            error('Fail to execute PlatEMO, since the version of MATLAB is lower than 7.14 (R2012a). Please update the version of your MATLAB software.');
        else
            Global = GLOBAL(varargin{:});
            Global.Start();
        end
    end
end
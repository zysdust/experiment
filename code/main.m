 function main(varargin)%varargin����һ��cell���飬���������û�����Ĳ���
%cd newFolder ����ǰ�ļ��и���Ϊ newFolder    cd ��ʾ��ǰ�ļ��С�
%fileparts(filename) ����ָ���ļ���·�����ơ��ļ�������չ��  ������֤�ļ��Ƿ���ڡ�
%mfilename('fullpath') �������н����˵��õ��ļ�������·�������ƣ��������ļ���չ����
%genpath(folderName) ����һ������·�����Ƶ��ַ���������·�������а��� folderName �Լ� folderName �µĶ༶���ļ���
%addpath������·��������ļ���
    cd(fileparts(mfilename('fullpath')));  % ����ǰ�ļ��и���Ϊ�ú������ڵ�·��
    addpath(genpath(cd)); % ���ļ��м������ļ�����ӵ�����·��
    %������function main(varargin)���ڵ��ø�main��ʱ������Ĳ�������varargin
    if isempty(varargin)    %ȷ�������Ƿ�Ϊ�գ�Ϊ�շ���true��������ִ��ִ�еģ�vararginΪ�գ���true
        if verLessThan('matlab','8.4')  %��������汾��ָ�����ַ��������бȽϣ�8.4��2014����������2021���汾��9.11.0�����������İ汾���� version ָ����ֵ���������߼�ֵ (true)
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
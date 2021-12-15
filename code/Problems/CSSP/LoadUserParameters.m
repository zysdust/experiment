function obj = LoadUserParameters(TEST)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

 path = fileparts(mfilename('fullpath'));
 
 load([path,'/resource/Group',num2str(TEST),'.mat']); 
 
end



%% ����ģʽ����
skipsynctests = 1;  % �Ƿ�����ͬ������
fullscreen    = 0;  % �Ƿ�ȫ��
savedata      = 1;  % �Ƿ񱣴����ݣ��������û�ã�

%% ���ƽ���
useoldstim    = 0;  % �Ƿ�ʹ��֮ǰ�Ĵ̼�����

%% ���Ʋ�����ʽ
dfactcase     = 0;  % �Ƿ�Ҫ���ݱ��Ա�ŵ���ż�����ְ���

%% ����ʵ�����
try
ExperimentReport = main(skipsynctests,fullscreen,savedata,useoldstim,dfactcase);
catch err
    sca;
    fclose('all');
    ShowCursor;
    ListenChar(0);
    Screen('Preference','SkipSyncTests',0);
end

%% ��

function SETTINGS = settings()

% ʵ����̿��Ʊ���
ExpCtrl.resttrial         = 45  ;                % ���ٸ��Դν�����Ϣ
%ExpCtrl.timeout           = 60 ;                 % ��Ӧ�׶ε��ʱ��
ExpCtrl.trailsperblock    = 220 ;                % ÿ�������ٸ��Դ�

% ʵ�������Ϣ����
ExpInfo.expName           = 'Demo Experiment';  % ʵ������
ExpInfo.windowDFT         = [10 10 810 610] ;   % ����ģʽĬ�ϵĴ��ڷ�Χ
ExpInfo.bgcolorDFT        = [0 0 0] ;           % Ĭ�ϱ�����ɫ
ExpInfo.txtcolorDFT       = [255 255 255] ;     % Ĭ��������ɫ
recorduse.folderName      = 'data';             % �����ļ�������
recorduse.mode            = 'a';                % ����д��ģʽ��a����ӣ�w�Ǹ���
recorduse.prefix          = 'Demo_';            % �����ļ���ǰ׺
recorduse.suffix          = '.csv';             % �����ļ��ĺ�׺��ͨ����.csv��ͨ����Ҫ��
ExpInfo.recorduse         = recorduse;

% ʵ��Ĭ������ģʽ����
Running.skipsynctestsDFT  = 0 ;                 % ����ͬ������
Running.fullscreenDFT     = 1 ;                 % �Ƿ�ȫ��
Running.savedataDFT       = 1 ;                 % �Ƿ񱣴�����
Running.maxblockDFT       = 0 ;                 % �Ƿ�������������
Running.useoldstimDFT     = 1 ;                 % �Ƿ�ʹ�����еĴ̼�����
Running.startfromDFT      = 1 ;                 % �ӵڼ�����鿪ʼ
Running.dfactcaseDFT      = 0 ;                 % �Ƿ�Ҫ���ݱ��Ա�ŵ���ż�����ְ���
%Running.runWindowDFT      = runWindow ;         % ����ʱ�Ĵ������귶Χ


% ���£�fields-�ֶ�, record-�Ƿ�Ҫ��¼, defans-Ĭ��ֵ

% �Դ���Ϣ���ã��Դ�֮��Ĳ�֮ͬ��
TrialInfo.fields          = {'nLeft','nRight','chanceLeft','chanceRight'};
TrialInfo.record          = {1,1,1,1};
TrialInfo.defans          = {3,3,1/4,1/4};
TrialInfo.prompt          = {'���������','�Ҳ�������','�����ȷ����','�Ҳ���ȷ����'};

% �����Ϣ���ã����֮��Ĳ�֮ͬ��
BlockInfo.fields          = {'shouldfeedback'};
BlockInfo.record          = {1};
BlockInfo.defans          = {1};

% ������Ϣ���ã�prompt-������Ϣ¼�����ĸ�������ǩ�����������ģ�
SubInfo.fields            = {'id','gender','age','eye'};
SubInfo.record            = {1,1,1,1};
SubInfo.defans            = {'1','1','20','1'};
SubInfo.prompt            = {'���','�Ա�[1=��,2=Ů]','����','������[1=��,2=��]'};

% ���ݼ�¼����
DataRecord.fields         = {'key','correction','timeout','rt','correctRectID','colorMap'};
DataRecord.record         = {1,1,1,1,1,1};
DataRecord.defans         = {-1,-1,-1,-1,-1,[]};

% ����Ҫ��¼�����ݵ�������ĳ��ȣ���ϵ�в�Ҫ�Ķ�
SubInfo.len               = size(SubInfo.fields,2);
TrialInfo.len             = size(TrialInfo.fields,2);
BlockInfo.len             = size(BlockInfo.fields,2);
DataRecord.len            = size(DataRecord.fields,2);

% ��������
KbName('UnifyKeyNames');
Keys.spc                  = KbName('space');
Keys.esc                  = KbName('escape');
Keys.rtn                  = KbName('return');
Keys.f                    = KbName('f');
Keys.j                    = KbName('j');

% �������������÷���SETTINGS����
SETTINGS.ExpCtrl          = ExpCtrl;
SETTINGS.ExpInfo          = ExpInfo;
SETTINGS.Running          = Running;
SETTINGS.SubInfo          = SubInfo;
SETTINGS.TrialInfo        = TrialInfo;
SETTINGS.BlockInfo        = BlockInfo;
SETTINGS.DataRecord       = DataRecord;
SETTINGS.Keys             = Keys;

end

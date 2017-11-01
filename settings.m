function SETTINGS = settings()

% 实验进程控制变量
ExpCtrl.resttrial         = 45  ;                % 多少个试次进行休息
%ExpCtrl.timeout           = 60 ;                 % 反应阶段的最长时间
ExpCtrl.trailsperblock    = 220 ;                % 每个组块多少个试次

% 实验基本信息设置
ExpInfo.expName           = 'Demo Experiment';  % 实验名称
ExpInfo.windowDFT         = [10 10 810 610] ;   % 窗口模式默认的窗口范围
ExpInfo.bgcolorDFT        = [0 0 0] ;           % 默认背景颜色
ExpInfo.txtcolorDFT       = [255 255 255] ;     % 默认文字颜色
recorduse.folderName      = 'data';             % 数据文件夹名称
recorduse.mode            = 'a';                % 数据写入模式，a是添加，w是覆盖
recorduse.prefix          = 'Demo_';            % 数据文件的前缀
recorduse.suffix          = '.csv';             % 数据文件的后缀，通常是.csv，通常不要改
ExpInfo.recorduse         = recorduse;

% 实验默认运行模式设置
Running.skipsynctestsDFT  = 0 ;                 % 跳过同步测试
Running.fullscreenDFT     = 1 ;                 % 是否全屏
Running.savedataDFT       = 1 ;                 % 是否保存数据
Running.maxblockDFT       = 0 ;                 % 是否设置最大组块数
Running.useoldstimDFT     = 1 ;                 % 是否使用已有的刺激材料
Running.startfromDFT      = 1 ;                 % 从第几个组块开始
Running.dfactcaseDFT      = 0 ;                 % 是否要根据被试编号的奇偶来区分按键
%Running.runWindowDFT      = runWindow ;         % 运行时的窗口坐标范围


% 以下：fields-字段, record-是否要记录, defans-默认值

% 试次信息设置：试次之间的不同之处
TrialInfo.fields          = {'nLeft','nRight','chanceLeft','chanceRight'};
TrialInfo.record          = {1,1,1,1};
TrialInfo.defans          = {3,3,1/4,1/4};
TrialInfo.prompt          = {'左侧红块总数','右侧红块总数','左侧正确概率','右侧正确概率'};

% 组块信息设置：组块之间的不同之处
BlockInfo.fields          = {'shouldfeedback'};
BlockInfo.record          = {1};
BlockInfo.defans          = {1};

% 被试信息设置（prompt-被试信息录入栏的各个框格标签，可以是中文）
SubInfo.fields            = {'id','gender','age','eye'};
SubInfo.record            = {1,1,1,1};
SubInfo.defans            = {'1','1','20','1'};
SubInfo.prompt            = {'编号','性别[1=男,2=女]','年龄','优势眼[1=左,2=右]'};

% 数据记录设置
DataRecord.fields         = {'key','correction','timeout','rt','correctRectID','colorMap'};
DataRecord.record         = {1,1,1,1,1,1};
DataRecord.defans         = {-1,-1,-1,-1,-1,[]};

% 各需要记录进数据的设置项的长度，此系列不要改动
SubInfo.len               = size(SubInfo.fields,2);
TrialInfo.len             = size(TrialInfo.fields,2);
BlockInfo.len             = size(BlockInfo.fields,2);
DataRecord.len            = size(DataRecord.fields,2);

% 按键设置
KbName('UnifyKeyNames');
Keys.spc                  = KbName('space');
Keys.esc                  = KbName('escape');
Keys.rtn                  = KbName('return');
Keys.f                    = KbName('f');
Keys.j                    = KbName('j');

% 将以上所有设置放入SETTINGS变量
SETTINGS.ExpCtrl          = ExpCtrl;
SETTINGS.ExpInfo          = ExpInfo;
SETTINGS.Running          = Running;
SETTINGS.SubInfo          = SubInfo;
SETTINGS.TrialInfo        = TrialInfo;
SETTINGS.BlockInfo        = BlockInfo;
SETTINGS.DataRecord       = DataRecord;
SETTINGS.Keys             = Keys;

end

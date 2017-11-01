# 反馈学习实验程序：基于心理学程序通用框架

> 时间：2017-05-04



## 1. 反馈学习实验

> 参考文献：Bellebaum, C., & Daum, I. (2008). Learning-related changes in reward expectancy are reflected in the feedback-related negativity. *European Journal of Neuroscience, 27*(7), 1823-1835.

**实验目的**：探究反馈对概率学习的影响。

**实验详情**：详见参考文献

**实验变量**：

- 试次变量：刺激1奖励概率、刺激2奖励概率
- 组块变量：是否提供硬币位置反馈
- 因变量：被试的反应正确率、反应倾向

**实验程序流程（正式实验单试次）**：

1. 屏幕中央呈现注视点，持续400ms
2. 屏幕两侧各呈现2列方块，红白各若干，要求被试猜测硬币在哪一侧的方块中，并按键反应
3. 被试反应后，只显示被试选择的一侧，持续500ms
4. 空屏500ms
5. 通过图形告知被试是否猜对，错误则显示一个红方块，正确则显示红方块上有一枚硬币，持续500ms
6. 空屏600ms
7. 如果该组块需要反馈硬币具体位置，则在屏幕中间显示被试选择的一侧，以及硬币所在位置，持续500ms；否则进入下一个试次



## 2. 心理学程序通用框架



### 2.1 概述

为了让研究者能够更加迅速地使用PsychToolBox搭建出易于调试、易于配置、易于理解、易于管理的心理学实验程序，我们编写了一个通用的框架。

此框架具有以下特点：

- **自动错误检查和关窗机制**。研究者不需要在程序代码中手动添加错误检查，出错自动关闭窗口，节约编程精力。
- **统一而方便的实验配置选项**。研究者能够通过简单的设置对实验参数、变量等进行修改。
- **程序进程逻辑分明**。研究者能够对程序具体环节进行有针对性的局部调整。
- **便捷的数据记录方法**。研究者只需要把要记录的数据定义出来，就能够轻松记录到数据文件里，不用复杂编程。



### 2.2 使用本框架编程的思路

使用本框架进行编程，通常的思路如下：

1. 考虑要记录的数据、试次变量、组间变量、被试信息等，编辑 **settings.m** 。
2. 在 **stimulates.m** 中生成各个组块和各个试次的具体变量。
3. 编写 **onetrial.m**、**oneblock.m** 及 **main.m**，完成实验整体。
4. 运行 **run.m**，对程序进行调试和修改。



### 2.3 框架的核心文件结构

| 文件名                | 类型   | 描述                           |
| ------------------ | ---- | ---------------------------- |
| **run.m**          | 代码   | 用来运行实验的脚本文件，可在其中配置运行选项       |
| **settings.m**     | 代码   | 用来设置实验程序的各种配置                |
| **stimulates.m**   | 代码   | 用来生成实验需要的刺激条件                |
| **STIMULATES.mat** | 刺激   | 由 **stimulates.m** 生成的实验刺激条件 |
| **main.m**         | 代码   | 实验的整体逻辑实现                    |
| **oneblock.m**     | 代码   | 单个组块的逻辑实现                    |
| **onetrial.m**     | 代码   | 单个试次的逻辑实现，是实验编程的关键           |



## 3. 主要源代码

### run.m

> 用来运行实验的脚本文件，可在其中配置运行选项

```matlab
%% 运行模式设置
skipsynctests = 1;  % 是否跳过同步测试
fullscreen    = 0;  % 是否全屏
savedata      = 1;  % 是否保存数据（这个好像没用）

%% 控制进度
useoldstim    = 0;  % 是否使用之前的刺激材料

%% 控制操作方式
dfactcase     = 0;  % 是否要根据被试编号的奇偶来区分按键

%% 运行实验程序
try
ExperimentReport = main(skipsynctests,fullscreen,savedata,useoldstim,dfactcase);
catch err
    sca;
    fclose('all');
    ShowCursor;
    ListenChar(0);
    Screen('Preference','SkipSyncTests',0);
end
```



### settings.m

> 用来设置实验程序的各种配置

```matlab
function SETTINGS = settings()

% 实验进程控制变量
ExpCtrl.resttrial         = 2  ;                % 多少个试次进行休息
ExpCtrl.timeout           = 60 ;                % 反应阶段的最长时间
ExpCtrl.trailsperblock    = 12 ;                % 每个组块多少个试次

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
SubInfo.fields            = {'id','gender','age'};
SubInfo.record            = {1,1,1};
SubInfo.defans            = {'1','1','20'};
SubInfo.prompt            = {'id','gender[1=male,2=female]','age'};

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
```



### stimulates.m

> 用来生成实验需要的刺激条件

```matlab
function STIMULATES = stimulates()

practiceTrialNum = 10;
inBlockTrialNum  = 220;

% 按比例列出各种可能的情形
conditon_psb = {1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,8,8,8,9,9,10,10,11,11,12,12,13,13,13,13,14,14,14,14};

conditions0 = BalanceTrials( practiceTrialNum, 1, conditon_psb );
conditions1 = BalanceTrials( inBlockTrialNum,  1, conditon_psb );
conditions2 = BalanceTrials( inBlockTrialNum,  1, conditon_psb );
conditions3 = BalanceTrials( inBlockTrialNum,  1, conditon_psb );

conditions  = [conditions1,conditions2,conditions3];
trials      = {{},{},{}};
trialsP     = {};

conditionsets={4,4,0/3,1/3;4,4,1/3,0/3;4,4,1/3,2/3;8,8,1/3,2/3;4,4,2/3,1/3;8,8,2/3,1/3;4,4,0/3,2/3;4,4,2/3,0/3;4,8,1/3,1/3;8,4,1/3,1/3;4,8,2/3,2/3;8,4,2/3,2/3;8,8,1/3,3/3;8,8,3/3,1/3};

% Practice
for i=1:practiceTrialNum
    x = conditions0{i};
    temp = trialsP;
    newtrial = conditionsets(x,:);
    trialsP = [temp;newtrial];
end

% Test
for k=1:3
    for i=1:size(conditions1,1)
        x = conditions{i,k};
        temp = trials(1,k);
        newtrial = conditionsets(x,:);
        trials{k} = [temp{1};newtrial];
    end
end

%% 生成每个组块的条件

% 初始化组块的试次和组块
blocktrials = {trialsP; trials{1}; trials{2}; trials{3};};
blocks = {0;0;1;0;};

%% 放入输出变量
STIMULATES.blocktrials = blocktrials;
STIMULATES.blocks      = blocks;

save('STIMULATES.mat','blocktrials','blocks');

end
```



### main.m

> 实验的整体逻辑实现

```matlab
function report=main(skipsynctests,fullscreen,savedata,useoldstim,dfactcase)


%% Clear To Get Ready
clc;
commandwindow;

% Set KeyNames As UnifyKeyNames
KbName('UnifyKeyNames');


%% BASIC VARIABLES AND SETTINGS
% -------------------------------------------------------------------------


%% Get Settings
SETTINGS = settings();

% Global Setting Variables
global ExpCtrl;
global ExpInfo;
global Running;
global SubInfo;
global BlockInfo;
global TrialInfo;
global DataRecord;
global Keys;
global recorduse;

% Get Setting Variables
ExpCtrl     = SETTINGS.ExpCtrl;
ExpInfo     = SETTINGS.ExpInfo;
Running     = SETTINGS.Running;
SubInfo     = SETTINGS.SubInfo;
TrialInfo   = SETTINGS.TrialInfo;
BlockInfo   = SETTINGS.BlockInfo;
DataRecord  = SETTINGS.DataRecord;
Keys        = SETTINGS.Keys;
recorduse   = ExpInfo.recorduse;

%% Default Argins
if nargin < 1 || isempty(skipsynctests)
    skipsynctests = Running.skipsynctestsDFT;
end
if nargin < 2 || isempty(fullscreen) || fullscreen~=0
    fullscreen = Running.fullscreenDFT;
end
if nargin < 3 || isempty(savedata)
    savedata = Running.savedataDFT;
end
if nargin < 4 || isempty(useoldstim)
    useoldstim = Running.useoldstimDFT;
end
if nargin < 5 || isempty(dfactcase)
    dfactcase = Running.dfactcaseDFT;
end

%% Make Window For Running This Program
if fullscreen
    runWindow = [];
else
    runWindow = ExpInfo.windowDFT;
end

%% Report Run Mode
report.runmode.skipsynctests   = skipsynctests ;
report.runmode.fullscreen      = fullscreen ;
report.runmode.savedata        = savedata ;
report.runmode.runWindow       = runWindow ;
report.runmode.useoldstim      = useoldstim ;

%% Report Settings
report.SETTINGS                = SETTINGS ;


%% MAKE SUBJECT INFORMATION
% -------------------------------------------------------------------------


% Global The Subject Information For Further Use
global subject;

% Display A Dialog To Get Subject Information
subinfogot = inputdlg(SubInfo.prompt,'Subject Information',1,SubInfo.defans);

% Return When Canceled
if isempty(subinfogot)
    report.messages.returnReason = 'Canceled while getting subject info.';
    return
end

% Make Subject Structure
subject = [];% subjecttext = [];
for i = 1:SubInfo.len
    subject.(SubInfo.fields{i})=subinfogot{i};%     tmptext = subjecttext;%     if i==1%         subjecttext = subinfogot{i};%     else%         subjecttext = [tmptext,',',subinfogot{i}];%     end
end

% Global Act Case
global actcaseA;

if dfactcase
    % Return When Error
    subjectid = str2double(subject.id);
    if isempty(subjectid)
        fprintf('Warning: Experiment Canceled Because of Uncorrect Subject ID!');
        report.messages.returnReason = 'Uncorrect subject id.';
        return
    end
    actcaseA = mod(subjectid,2)==1;
else
    actcaseA = 1;
end

% Report Subject
report.subject = subject;


%% MAKING DATA FILE
% -------------------------------------------------------------------------


%% Creat File To Record Data

% Make Floder To Save Data File
if ~(exist(recorduse.folderName,'dir')==7)
    mkdir(recorduse.folderName);
end

% Generate File Name
filename=[recorduse.prefix,subject.(SubInfo.fields{1}),recorduse.suffix];
filepath=fullfile(recorduse.folderName,filename);

% Global The Record File For Further Use
global recordfile;

% Open File As Record File
[recordfile,openFileFalseMessage]=fopen(filepath,recorduse.mode);

% Report Record File
report.messages.openfilemsg = openFileFalseMessage;
report.recordfile           = recordfile;


%% Generate Title Line

% Get Length
SBlen = SubInfo.len;
BIlen = BlockInfo.len;
TIlen = TrialInfo.len;
DRlen = DataRecord.len;

% Prepare An Empty String For Titles
titles='';

% Make Titles Of Sbuject Information
titles = fun_maketitles( 'sub_', SubInfo, titles, SBlen);

% Make Titles Of Block ID & Trial ID
if isempty(titles)
    titles=['blockid',',','trialid'];
else
    titles=[titles,',','blockid',',','trialid'];
end

% Make Titles Of Block Information
titles = fun_maketitles( 'block_', BlockInfo, titles, BIlen);

% Make Titles Of Trial Information
titles = fun_maketitles( 'trial_', TrialInfo, titles, TIlen);

% Make Titles Of Data To Record
titles = fun_maketitles( 'resp_', DataRecord, titles, DRlen);

% Print Title Line In File
fprintf(recordfile,'%s\r\n',titles);


%% OPEN WINDOW
% -------------------------------------------------------------------------
Screen('Preference','SkipSyncTests',skipsynctests);
% AssertOpenGL;
scrnNum      = max(Screen('Screens'));
[wptr,wrect] = Screen('OpenWindow',scrnNum,ExpInfo.bgcolorDFT,runWindow);
report.wptr  = wptr;
report.wrect = wrect;


%% Initialize Stimulates

% global coinTex;
global coinTexR;
global coinTexW;

% coinImg = imread('coin.png');
% coinTex = Screen('MakeTexture',wptr,coinImg);
coinImgR = imread('coinR.png');
coinTexR = Screen('MakeTexture',wptr,coinImgR);
coinImgW = imread('coinW.png');
coinTexW = Screen('MakeTexture',wptr,coinImgW);

Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
drawCenteredTextInRect(wptr,'initializing stimulates, please wait...',wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr);

if useoldstim && (exist('STIMULATES.mat','file')==2)
    STIMULATES = load('STIMULATES.mat');
else
    STIMULATES = stimulates();
end

blocktrials = STIMULATES.blocktrials;
blocks      = STIMULATES.blocks;


%% Disable Key Output To Matlab Window And Hide Cursor
% ListenChar(2);
% HideCursor;

if actcaseA
groupText='您需要按 F键 或 J键 判断\n硬币在 左侧 方格集合中 还是在 右侧 方格集合中。\n（ F-左    J-右 ）';
else
groupText='您需要按 F键 或 J键 判断\n硬币在 右侧 方格集合中 还是在 左侧 方格集合中。\n（ F-右    J-左 ）';
end
zhidaoyu=sprintf('您好!欢迎参加实验!\n\n实验中，屏幕左右两侧各有12个方格，其中一些方格是红色的，\n另一些是白色的。有一枚一元硬币隐藏在其中一个方格中，\n\n%s\n\n实验中蕴含一个规则可以帮助您更准确地（但不是100%）判断硬币所在的区域，\n通过发现并运用这个规则做出选择，可以使获得的奖励最大化。\n您最终猜对的总次数与实验后所获得的实际金钱奖励相关。',groupText);


%% Say Welcome
while KbCheck;end
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
drawCenteredTextInRect(wptr,zhidaoyu,wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr);
KbWait;

%% Traverse Blocks & Get Data
expdata=[];
fprintf(['blocks start','\n']);
for i=1:size(blocks,1)
    trials       = [blocktrials{i,:}];
    blockset     = blocks(i,:);
    blockid      = i-1;
    fprintf(['\n','block%d start','\n'],blockid);
    blockdatanew = oneblock(wptr,blockid,trials,blockset);
    edtmp        = expdata;
    expdata      = [edtmp,blockdatanew];
end % for % Traverse Blocks


%% ENDING
% -------------------------------------------------------------------------


%% Wait For End
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
drawCenteredTextInRect(wptr,'...Saving Data, Please Wait...',wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr);

%% Report Data
report.expdata = expdata;

%% Close File And Resume Cursor & Keyboard
fclose(recordfile);
ShowCursor;
ListenChar(0);

%% Say Goodbye
while KbCheck;end
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
drawCenteredTextInRect(wptr,'Thank you again. Bye!',wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr);
KbWait;

%% Close Window
sca;
Screen('Preference','SkipSyncTests',0);

end % MAIN FUNCTION

```



### oneblock.m

> 单个组块的逻辑实现

```matlab
function blockdata = oneblock(wptr,blockid,trials,blockset)

%% BLOCK INIT
% -------------------------------------------------------------------------

% global ExpCtrl;
global ExpInfo;
% global TrialInfo;
global BlockInfo;
% global SubInfo;
% global DataRecord;
% global Keys;
% global subject;
% global recordfile;

if nargin < 1 || isempty(wptr)
    blockdata.err='[ err caused lost data ]';
    fprintf('function oneblock need window pointer as first input.');
    return;
end
if nargin < 2 || isempty(blockid)
    blockid = 0;
end
if nargin < 3 || isempty(trials)
    trials = {};
end
if nargin < 4 || isempty(blockset)
    blockset = {};
end

BIlen = BlockInfo.len;
bslen = size(blockset,2);

if bslen == BIlen
    for i=1:BIlen
        block.(BlockInfo.fields{i})=blockset{i};
    end
elseif bslen < BIlen
    for i=1:bslen
        block.(BlockInfo.fields{i})=blockset{i};
    end
    for i=(bslen+1):BIlen
        block.(BlockInfo.fields{i})=BlockInfo.defans{i};
    end
else
    disp(BIlen);
    disp(bslen);
    error('blockset too long!');
end


%% BLOCK MAIN
% -------------------------------------------------------------------------


%[cx,cy]=WindowCenter(wptr);
%[w,h]=WindowSize(wptr);
wrect=Screen('Rect',wptr);


% Show Introduction
while KbCheck;end
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
switch blockid
    case 0
        drawCenteredTextInRect(wptr,'现在，通过几个练习熟悉一下实验。\n\n（按任意键开始）',wrect,ExpInfo.txtcolorDFT);
    case 1
        drawCenteredTextInRect(wptr,'练习结束！\n\n如果您已熟悉实验，且没有任何疑问，则请按任意键开始正式实验。',wrect,ExpInfo.txtcolorDFT);
    case 2
        drawCenteredTextInRect(wptr,'休息一下！\n\n您是否已发现并利用规则帮您做出判断？\n如果没有，接下来的实验中，\n每次反馈会告知您硬币的实际位置，帮助您发现并总结规则；\n如果您已发现规则，\n请利用硬币的实际位置信息帮您检验已发现的规则是否正确。\n\n休息结束后，请按任意键继续实验。',wrect,ExpInfo.txtcolorDFT);
    case 3
        drawCenteredTextInRect(wptr,'休息一下！\n\n接下来的实验中，将不会呈现硬币的实际位置。\n如您未发现规则，请继续通过反应尝试发现规则；\n如您已发现规则，请利用该规则进行判断。\n\n休息结束后，请按任意键继续实验。',wrect,ExpInfo.txtcolorDFT);
end
Screen('Flip',wptr);
KbWait;


fprintf(['block begin','\n']);
% Traverse Trials & Get Data
blockdata=[];
blocksize=size(trials,1);
% blocksize=1;
for i=1:blocksize
    trialset     = trials(i,:);
    trialid      = i;
    trialdatanew = onetrial(wptr,trialid,blockid,block,trialset);
    bdtmp        = blockdata;
    blockdata    = [bdtmp,trialdatanew];
end % for % Traverse Trials
fprintf(['block%d end','\n'],blockid);

end % ONE BLOCK FUNCTION
```



### onetrial.m

> 单个试次的逻辑实现，是实验编程的关键

```matlab
function trialdata = onetrial(wptr,trialid,blockid,blockinfo,trialset)


%% TRIAL INIT
% -------------------------------------------------------------------------


%% Get Global Information
global ExpCtrl;
global ExpInfo;
global TrialInfo;
global BlockInfo;
global SubInfo;
global DataRecord;
global Keys;
global subject;
global recordfile;
global actcaseA;
global coinTexR;
global coinTexW;

% Compute Length For Further Use
TIlen = TrialInfo.len;
BIlen = BlockInfo.len;
SBlen = SubInfo.len;
DRlen = DataRecord.len;


%% COMPUTE VARIABLES TO DRAW
% -------------------------------------------------------------------------


wrect     = Screen('Rect',wptr);
WinW      = wrect(3);
WinH      = wrect(4);

BoxW      = 560;
BoxH      = 420;

unitSzX   = round(BoxW/75);
unitSzY   = round(BoxH/75);

rectSpX   = 2*unitSzX;
rectSpY   = 6*unitSzY;
rectSzX   = 5*unitSzX;
rectSzY   = 5*unitSzY;
rectSzMin = min([rectSzX,rectSzY]);

MidH      = rectSpY*7+rectSzY*6;

CenterX   = round(WinW/2);
CenterY   = round(WinH/2);
%CenterY   = round(BoxH/2+rectSpX);

L1X1 = CenterX-rectSpX*2-rectSzX*2-rectSpX/2 - rectSzX*2;
L1X2 = CenterX-rectSpX*2-rectSzX*1-rectSpX/2 - rectSzX*2;
L2X1 = CenterX-rectSpX*1-rectSzX*1-rectSpX/2 - rectSzX*2;
L2X2 = CenterX-rectSpX*1-rectSzX*0-rectSpX/2 - rectSzX*2;

R1X1 = CenterX+rectSpX*1+rectSzX*0+rectSpX/2 + rectSzX*2;
R1X2 = CenterX+rectSpX*1+rectSzX*1+rectSpX/2 + rectSzX*2;
R2X1 = CenterX+rectSpX*2+rectSzX*1+rectSpX/2 + rectSzX*2;
R2X2 = CenterX+rectSpX*2+rectSzX*2+rectSpX/2 + rectSzX*2;


B1Y1 = CenterY-rectSpY*2.5-rectSzY*3;
B1Y2 = CenterY-rectSpY*2.5-rectSzY*2;

B2Y1 = CenterY-rectSpY*1.5-rectSzY*2;
B2Y2 = CenterY-rectSpY*1.5-rectSzY*1;

B3Y1 = CenterY-rectSpY*0.5-rectSzY*1;
B3Y2 = CenterY-rectSpY*0.5-rectSzY*0;

B4Y1 = CenterY+rectSpY*0.5+rectSzY*0;
B4Y2 = CenterY+rectSpY*0.5+rectSzY*1;

B5Y1 = CenterY+rectSpY*1.5+rectSzY*1;
B5Y2 = CenterY+rectSpY*1.5+rectSzY*2;

B6Y1 = CenterY+rectSpY*2.5+rectSzY*2;
B6Y2 = CenterY+rectSpY*2.5+rectSzY*3;


ctdX1     = CenterX-rectSzX-rectSpX/2;
ctdoffset = ctdX1-L1X1;
dspoffset = (rectSzY+rectSpY)/4;

rects = {...
    [L1X1,B1Y1,L1X2,B1Y2],...
    [L1X1,B2Y1,L1X2,B2Y2],...
    [L1X1,B3Y1,L1X2,B3Y2],...
    [L1X1,B4Y1,L1X2,B4Y2],...
    [L1X1,B5Y1,L1X2,B5Y2],...
    [L1X1,B6Y1,L1X2,B6Y2],...
    [L2X1,B1Y1,L2X2,B1Y2],...
    [L2X1,B2Y1,L2X2,B2Y2],...
    [L2X1,B3Y1,L2X2,B3Y2],...
    [L2X1,B4Y1,L2X2,B4Y2],...
    [L2X1,B5Y1,L2X2,B5Y2],...
    [L2X1,B6Y1,L2X2,B6Y2],...
    [R1X1,B1Y1,R1X2,B1Y2],...
    [R1X1,B2Y1,R1X2,B2Y2],...
    [R1X1,B3Y1,R1X2,B3Y2],...
    [R1X1,B4Y1,R1X2,B4Y2],...
    [R1X1,B5Y1,R1X2,B5Y2],...
    [R1X1,B6Y1,R1X2,B6Y2],...
    [R2X1,B1Y1,R2X2,B1Y2],...
    [R2X1,B2Y1,R2X2,B2Y2],...
    [R2X1,B3Y1,R2X2,B3Y2],...
    [R2X1,B4Y1,R2X2,B4Y2],...
    [R2X1,B5Y1,R2X2,B5Y2],...
    [R2X1,B6Y1,R2X2,B6Y2],...
    };

% makeGlobal();

fdbkrect     = [CenterX-3*rectSzX,CenterY-3*rectSzY,CenterX+3*rectSzX,CenterY+3*rectSzY];
fdbkcoinrect = [CenterX-2*rectSzMin,CenterY-2*rectSzMin,CenterX+2*rectSzMin,CenterY+2*rectSzMin];

rectMidLine  = [CenterX-2,CenterY-MidH/2,CenterX+2,CenterY+MidH/2];
rectMidLineColor = [255 255 255];

% leftTextBox  = [L1X1,(B4Y2+rectSpY*2),L2X2,(WinH-rectSpY)];
% rightTextBox = [R1X1,(B4Y2+rectSpY*2),R2X2,(WinH-rectSpY)];
% 
% correctColor = [0 255 0];
% incorrectColor = [255 0 0];
% correctCoinColor = [255 200 0];


%% Check Default Argins
if nargin < 1 || isempty(wptr)
    trialdata.err = '[ err caused lost data ]';
    fprintf('\n\nError: function onetrial need window pointer as first input.\n\n');
    return
end
if nargin < 2 || isempty(trialid)
    trialid = -1;
end
if nargin < 3 || isempty(blockid)
    blockid = -1;
end

if nargin < 4 || isempty(blockinfo)
    for i=1:BIlen
        blockinfo.(BlockInfo.fields{i})=BlockInfo.defans{i};
    end
end
if nargin < 5 || isempty(trialset)
    trialset = {};
end

tslen = size(trialset,2);


%% Generate Trial Conditions

if tslen == TIlen
    for i=1:TIlen
        trial.(TrialInfo.fields{i})=trialset{i};
    end
elseif tslen < TIlen
    for i=1:tslen
        trial.(TrialInfo.fields{i})=trialset{i};
    end
    for i=(tslen+1):TIlen
        trial.(TrialInfo.fields{i})=TrialInfo.defans{i};
    end
else
    trialdata.err='[ err caused lost data ]';
    fprintf('\n\nError: trialset too long!\n\n');
    disp(tslen);
    disp(Tslen);
    return
end

% note- TrialInfo.fields={'nLeft','nRight','chanceLeft','chanceRight','correctRect'};
nLeft          = trial.nLeft;
nRight         = trial.nRight;
chanceLeft     = trial.chanceLeft;
chanceRight    = trial.chanceRight;
shouldfeedback = blockinfo.shouldfeedback;


%% Generate Color Map

if chanceLeft == 1/3
    mapL2    = BalanceTrials(4,1,[0,0,0,0,1,1])';
    switch nLeft
        case 4
            mapL1    = BalanceTrials(4,1,[0,0,0,0,1,1])';
        case 8
            mapL1    = [1,1,1,1,1,1];
    end
elseif chanceLeft == 2/3
    mapL2    = BalanceTrials(4,1,[0,0,1,1,1,1])';
    switch nLeft
        case 4
            mapL1    = [0,0,0,0,0,0];
        case 8
            mapL1    = BalanceTrials(4,1,[0,0,1,1,1,1])';
    end
elseif chanceLeft == 3/3
    mapL2    = [1,1,1,1,1,1];
    mapL1    = BalanceTrials(4,1,[0,0,0,0,1,1])';
elseif chanceLeft == 0/3
    mapL2    = [0,0,0,0,0,0];
    mapL1    = BalanceTrials(4,1,[0,0,1,1,1,1])';
end

if chanceRight == 1/3
    mapR2    = BalanceTrials(4,1,[0,0,0,0,1,1])';
    switch nRight
        case 4
            mapR1    = BalanceTrials(4,1,[0,0,0,0,1,1])';
        case 8
            mapR1    = [1,1,1,1,1,1];
    end
elseif chanceRight == 2/3
    mapR2    = BalanceTrials(4,1,[0,0,1,1,1,1])';
    switch nLeft
        case 4
            mapR1    = [0,0,0,0,0,0];
        case 8
            mapR1    = BalanceTrials(4,1,[0,0,1,1,1,1])';
    end
elseif chanceRight == 3/3
    mapR2    = [1,1,1,1,1,1];
    mapR1    = BalanceTrials(4,1,[0,0,0,0,1,1])';
elseif chanceRight == 0/3
    mapR2    = [0,0,0,0,0,0];
    mapR1    = BalanceTrials(4,1,[0,0,1,1,1,1])';
end

colorMap = [mapL1,mapL2,mapR1,mapR2];
resp.colorMap =colorMap;


%% TRIAL MAIN
% -------------------------------------------------------------------------


modoftrialid = mod(trialid,ExpCtrl.resttrial);
% fprintf(['trialid           is %d','\n'],trialid);
% fprintf(['ExpCtrl.resttrial is %d','\n'],ExpCtrl.resttrial);
% fprintf(['modoftrialid      is %d','\n'],modoftrialid);

if ( ExpCtrl.resttrial==1 || modoftrialid==1 ) && trialid~=1
    while KbCheck;end
    Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
    drawCenteredTextInRect(wptr,'休息一下！\n\n休息结束后，请按任意键继续实验。',wrect,ExpInfo.txtcolorDFT);
    Screen('Flip',wptr,[],1);
    KbWait;
end

while KbCheck;end
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
drawCenteredTextInRect(wptr,'+',wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr,[],1);

WaitSecs(0.4);

tic;

%% Draw
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
Screen('FillRect',wptr,rectMidLineColor,rectMidLine);

for i=1:size(rects,2)
    if colorMap(i)==1
        thisRectColor = [255 0 0];
    else
        thisRectColor = [255 255 255];
    end
    if (0<i && i<= (size(rects,2)/4))||((size(rects,2)/2)<i && i<= (size(rects,2)/4*3))
        boxrect = OffsetRect(rects{i},0,-dspoffset);
    elseif ((size(rects,2)/4)<i && i<= (size(rects,2)/2))||((size(rects,2)/4*3)<i && i<= (size(rects,2)))
        boxrect = OffsetRect(rects{i},0,dspoffset);
    end
    Screen('FillRect',wptr,thisRectColor,boxrect);
end

Screen('Flip',wptr,[],1);

%% Response
if actcaseA
    leftKey  = Keys.f;
    rightKey = Keys.j;
else
    leftKey  = Keys.j;
    rightKey = Keys.f;
end

while true
%     currenttime = toc;
    [~,~,kC] = KbCheck;
%     if currenttime >= 2.7
%         resp.key           = -999;
%         resp.rt            = currenttime;
%         resp.timeout       = 1;
% %         feedbackbox        = leftTextBox;
%         corrchance         = -1;
%         chosen             = 1;
%         break
%     end
    if kC(leftKey) && ~kC(rightKey)
        resp.key           = leftKey;
        resp.rt            = toc;
        resp.timeout       = 0;
%         feedbackbox        = leftTextBox;
        corrchance         = chanceLeft;
        chosen             = 1;
        break
    elseif kC(rightKey) && ~kC(leftKey)
        resp.key           = rightKey;
        resp.rt            = toc;
        resp.timeout       = 0;
%         feedbackbox        = rightTextBox;
        corrchance         = chanceRight;
        chosen             = 2;
        break
    end
end


%% Draw Again
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);

if resp.key == leftKey
    drawAgainRange = 1:(size(rects,2)/2);
elseif resp.key == rightKey
    drawAgainRange = (size(rects,2)/2+1):size(rects,2);
else
    drawAgainRange = 0;
end

if ~isequal(drawAgainRange,0)
    for i=drawAgainRange
        if colorMap(i)==1
            thisRectColor = [255 0 0];
        else
            thisRectColor = [255 255 255];
        end
        if (0<i && i<= (size(rects,2)/4))||((size(rects,2)/2)<i && i<= (size(rects,2)/4*3))
            boxrect = OffsetRect(rects{i},0,-dspoffset);
        elseif ((size(rects,2)/4)<i && i<= (size(rects,2)/2))||((size(rects,2)/4*3)<i && i<= (size(rects,2)))
            boxrect = OffsetRect(rects{i},0,dspoffset);
        end
        Screen('FillRect',wptr,thisRectColor,boxrect);
    end
    Screen('Flip',wptr,[],1);
    WaitSecs(0.5);
end


%% Black
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
Screen('Flip',wptr,[],1);
WaitSecs(0.5);


%% Make Feedback
if rand <= corrchance
    correction = 1;
%     corrtext   = 'Correct';
%     textcolor  = correctColor;
else
    correction = 0;
%     corrtext   = 'Incorrect';
%     textcolor  = incorrectColor;
end

resp.correction = correction;

% Make Correct Rect
if correction && chosen == 1
    % left half
    lctFdbkRange = 1:(size(rects,2)/2);
    offsetX = ctdoffset;
    
    correctRectID = 6+ceil(6*rand);
    % must be red
    while colorMap(correctRectID) ~= 1
        if correctRectID == (6+6)
            correctRectID = (6+1);
        else
            correctRectID = correctRectID+1;
        end
    end
    resp.correctRectID = correctRectID;
elseif  correction && chosen == 2
    % right half
    lctFdbkRange = (size(rects,2)/2+1):size(rects,2);
    offsetX = -ctdoffset;
    
    correctRectID = 18+ceil(6*rand);
    % must be red
    while colorMap(correctRectID) ~= 1
        if correctRectID == (18+6)
            correctRectID = (18+1);
        else
            correctRectID = correctRectID+1;
        end
    end
    resp.correctRectID = correctRectID;
elseif ~correction && chosen == 1
    % right half
    lctFdbkRange = (size(rects,2)/2+1):size(rects,2);
    offsetX = -ctdoffset;
    
    correctRectID = 18+ceil(6*rand);
    % must be white
    while colorMap(correctRectID) == 1
        if correctRectID == (18+6)
            correctRectID = (18+1);
        else
            correctRectID = correctRectID+1;
        end
    end
    resp.correctRectID = correctRectID;
elseif ~correction && chosen == 2
    % left half
    lctFdbkRange = 1:(size(rects,2)/2);
    offsetX = ctdoffset;
    
    correctRectID = 6+ceil(6*rand);
    % must be white
    while colorMap(correctRectID) == 1
        if correctRectID == (6+6)
            correctRectID = (6+1);
        else
            correctRectID = correctRectID+1;
        end
    end
    resp.correctRectID = correctRectID;
end


%% Correction Feedback
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
Screen('FillRect',wptr,[255 0 0],fdbkrect);
if correction
    Screen('DrawTexture',wptr,coinTexR,[],fdbkcoinrect);
else
    % Screen('DrawTexture',wptr,coinTexW,[],fdbkcoinrect);
end
% drawCenteredTextInRect(wptr,corrtext,feedbackbox,textcolor);
% Screen('FillOval',wptr,correctRectColor,rects{resp.correctRectID});
Screen('Flip',wptr,[],1);
WaitSecs(0.5);


%% Black Again
Screen('FillRect',wptr,ExpInfo.bgcolorDFT,wrect);
Screen('Flip',wptr,[],1);
WaitSecs(0.6);


%% Location Feedback
if shouldfeedback
    for i=lctFdbkRange
        if colorMap(i)==1
            thisRectColor = [255 0 0];
        else
            thisRectColor = [255 255 255];
        end
        if (0<i && i<= (size(rects,2)/4))||((size(rects,2)/2)<i && i<= (size(rects,2)/4*3))
            ctdrect = OffsetRect(rects{i},offsetX,-dspoffset);
            offcoinY = -dspoffset;
        elseif ((size(rects,2)/4)<i && i<= (size(rects,2)/2))||((size(rects,2)/4*3)<i && i<= (size(rects,2)))
            ctdrect = OffsetRect(rects{i},offsetX,dspoffset);
            offcoinY = dspoffset;
        end
        Screen('FillRect',wptr,thisRectColor,ctdrect);
    end
    corrRect = rects{resp.correctRectID};
    corrMidX = round((corrRect(1)+corrRect(3))/2);
    corrMidY = round((corrRect(2)+corrRect(4))/2);
    tmp = rectSzMin/2-2;
    corrcoinrect = [corrMidX-tmp,corrMidY-tmp,corrMidX+tmp,corrMidY+tmp];
    ctdcoinrect  = OffsetRect(corrcoinrect,offsetX,offcoinY);
    if correction
        Screen('DrawTexture',wptr,coinTexR,[],ctdcoinrect);
    else
        Screen('DrawTexture',wptr,coinTexW,[],ctdcoinrect);
    end
    Screen('Flip',wptr,[],1);
    WaitSecs(0.5);
end


%% Main End

fprintf(['one trial ending','\n']);


%% TRIAL ENDING
% -------------------------------------------------------------------------
% do NOT edit this part!

if 1
    
    % Prepare An Empty String For Data Text
    datatext='';
    
    % Prepare An Empty Struct For Data Object
    trialdata=struct;
    
    % Make Data-For-Record Of Sbuject Information
    [datatext, trialdata] = fun_datatexts( 'sub_', SubInfo, subject, trialdata, datatext, SBlen);
    
    % Make Data-For-Record Of Block ID & Trial ID
    trialdata.blockid=blockid;
    blockidtext=num2str(blockid);
    trialdata.trialid=trialid;
    trialidtext=num2str(trialid);
    
    if isempty(datatext)
        datatext=[blockidtext,',',trialidtext];
    else
        datatext=[datatext,',',blockidtext,',',trialidtext];
    end
    
    % Make Data-For-Record Of Block Information
    [datatext, trialdata] = fun_datatexts( 'block_', BlockInfo, blockinfo, trialdata, datatext, BIlen);
    
    % Make Data-For-Record Of Trial Information
    [datatext, trialdata] = fun_datatexts( 'trial_', TrialInfo, trial, trialdata, datatext, TIlen);
    
    % Make Data-For-Record Of Data To Record
    [datatext, trialdata] = fun_datatexts( 'resp_', DataRecord, resp, trialdata, datatext, DRlen);
    
    % new data line of recording file
    newline=datatext;
    fprintf(recordfile,'%s\r\n',newline);
    
end

% mark end
fprintf(['one trial ended','\n']);

end % ONE TRIAL FUNCTION
```



### 其他文件

> 程序中用到的其他辅助文件，不给出具体代码。

| 文件名                          | 类型   | 描述                |
| ---------------------------- | ---- | ----------------- |
| **drawCenteredTextInRect.m** | 代码   | 用来绘制文字的辅助函数       |
| **drawTextInRect.m**         | 代码   | 用来绘制文字的辅助函数       |
| **fun_datatexts.m**          | 代码   | 用来生成数据记录文件内容的辅助函数 |
| **fun_maketitles.m**         | 代码   | 用来生成数据记录文件表头的辅助函数 |
| **coinR.png**                | 图片   | 红色背景的硬币图片素材       |
| **coinW.png**                | 图片   | 白色背景的硬币图片素材       |




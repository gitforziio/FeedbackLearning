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

% =========================================================================


%% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% =========================================================================

% makeVariables(wptr);
% Screen('Flip',wptr);


%% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% -------------------------------------------------------------------------


%% MAIN PROGRAM
% -------------------------------------------------------------------------


%% Disable Key Output To Matlab Window And Hide Cursor
% ListenChar(2);
% HideCursor;

if actcaseA
groupText='����Ҫ�� F�� �� J�� �ж�\nӲ���� ��� ���񼯺��� ������ �Ҳ� ���񼯺��С�\n�� F-��    J-�� ��';
else
groupText='����Ҫ�� F�� �� J�� �ж�\nӲ���� �Ҳ� ���񼯺��� ������ ��� ���񼯺��С�\n�� F-��    J-�� ��';
end
zhidaoyu=sprintf('����!��ӭ�μ�ʵ��!\n\nʵ���У���Ļ�����������12����������һЩ�����Ǻ�ɫ�ģ�\n��һЩ�ǰ�ɫ�ġ���һöһԪӲ������������һ�������У�\n\n%s\n\nʵ�����̺�һ��������԰�������׼ȷ�أ�������100%���ж�Ӳ�����ڵ�����\nͨ�����ֲ����������������ѡ�񣬿���ʹ��õĽ�����󻯡�\n�����ղ¶Ե��ܴ�����ʵ�������õ�ʵ�ʽ�Ǯ������ء�',groupText);


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
% -------------------------------------------------------------------------

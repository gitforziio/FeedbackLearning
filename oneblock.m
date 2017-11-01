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
        drawCenteredTextInRect(wptr,'���ڣ�ͨ��������ϰ��Ϥһ��ʵ�顣\n\n�����������ʼ��',wrect,ExpInfo.txtcolorDFT);
    case 1
        drawCenteredTextInRect(wptr,'��ϰ������\n\n���������Ϥʵ�飬��û���κ����ʣ����밴�������ʼ��ʽʵ�顣',wrect,ExpInfo.txtcolorDFT);
    case 2
        drawCenteredTextInRect(wptr,'��Ϣһ�£�\n\n���Ƿ��ѷ��ֲ����ù�����������жϣ�\n���û�У���������ʵ���У�\nÿ�η������֪��Ӳ�ҵ�ʵ��λ�ã����������ֲ��ܽ����\n������ѷ��ֹ���\n������Ӳ�ҵ�ʵ��λ����Ϣ���������ѷ��ֵĹ����Ƿ���ȷ��\n\n��Ϣ�������밴���������ʵ�顣',wrect,ExpInfo.txtcolorDFT);
    case 3
        drawCenteredTextInRect(wptr,'��Ϣһ�£�\n\n��������ʵ���У����������Ӳ�ҵ�ʵ��λ�á�\n����δ���ֹ��������ͨ����Ӧ���Է��ֹ���\n�����ѷ��ֹ��������øù�������жϡ�\n\n��Ϣ�������밴���������ʵ�顣',wrect,ExpInfo.txtcolorDFT);
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
% -------------------------------------------------------------------------

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
% -------------------------------------------------------------------------

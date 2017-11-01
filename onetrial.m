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
rectMidLineColor = [0 0 0];

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
orgTextSize=Screen('TextSize',wptr,60);
drawCenteredTextInRect(wptr,'+',wrect,ExpInfo.txtcolorDFT);
Screen('Flip',wptr,[],1);
Screen('TextSize',wptr,orgTextSize);

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

% -------------------------------------------------------------------------

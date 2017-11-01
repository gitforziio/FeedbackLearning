function STIMULATES = stimulates()

practiceTrialNum = 10;
inBlockTrialNum  = 220;

% 各个变量可能的值

% {'nLeft','nRight','chanceLeft','chanceRight'}
% {'左侧红块总数','右侧红块总数','左侧正确概率','右侧正确概率'}

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
blocktrials = {
    trialsP;
    trials{1};
    trials{2};
    trials{3};
    };

blocks = {
    0;
    0;
    1;
    0;
    };


%% 放入输出变量
STIMULATES.blocktrials = blocktrials;
STIMULATES.blocks      = blocks;

save('STIMULATES.mat','blocktrials','blocks');

end

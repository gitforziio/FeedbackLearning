
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

%% 完

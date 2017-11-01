function [texts, DataObj] = fun_datatexts( prefix, ClassObj, ActObj, DataObj, pretexts, len)

if nargin < 1 || isempty(prefix)
    prefix = '';
end
if nargin < 2 || isempty(ClassObj)
    error('maketitle needs an ClassObj!');
end
if nargin < 3 || isempty(ActObj)
    error('maketitle needs an ActObj!');
end
if nargin < 4 || isempty(DataObj)
    error('maketitle needs an DataObj!');
end
if nargin < 5 || isempty(pretexts)
    pretexts = '';
end
if nargin < 6 || isempty(len)
    len = ClassObj.len;
end

% Prepare An Empty String For Texts
texts = pretexts;

% Make Texts Of Obj
for i=1:len
    DataObj.([prefix,ClassObj.fields{i}])=ActObj.(ClassObj.fields{i});
    if ClassObj.record{i}
        data_i=DataObj.([prefix,ClassObj.fields{i}]);
        if ~ischar(data_i)
            data_i=num2str(data_i);
        end
        if isempty(texts)
            texts=data_i;
        else
            texts_tmp=texts;
            texts=[texts_tmp,',',data_i];
        end
    end
end

end

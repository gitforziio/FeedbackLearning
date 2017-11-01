function titles = fun_maketitles( prefix, Obj, pretitles, len)

if nargin < 1 || isempty(prefix)
    prefix = '';
end
if nargin < 2 || isempty(Obj)
    error('maketitle needs an Obj!');
end
if nargin < 3 || isempty(pretitles)
    pretitles = '';
end
if nargin < 4 || isempty(len)
    len = Obj.len;
end

% Prepare An Empty String For Titles
titles = pretitles;

% Make Titles Of Obj
for i=1:len
    if Obj.record{i}
        titles_tmp=titles;
        title_i=[prefix,Obj.fields{i}];
        if isempty(titles)
            titles=title_i;
        else
            titles=[titles_tmp,',',title_i];
        end
    end
end

end

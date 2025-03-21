-- 正则表达式1：所有假名都是某一段
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^',
    (SELECT pattern FROM j.reg_lib WHERE name = 'Ux'),
    '{4,}$') as pattern
)
SELECT * FROM jmdict_tmp WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式2：满足特定假名顺序
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^',
    (SELECT pattern FROM j.reg_lib WHERE name = 'U'),
    (SELECT pattern FROM j.reg_lib WHERE name = 'U'),
    (SELECT pattern FROM j.reg_lib WHERE name = 'I'),
    (SELECT pattern FROM j.reg_lib WHERE name = ''),
    '$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式3：长度为2且两个假名相同的单词
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^',
    '(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')\\1',
    '$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式4：一个汉字念4个假名的单词
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    '{4}$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp)
and char_length(termName) = 1;

-- 正则表达式5：XっXX拟态词
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    'っ',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    '{2}$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式6：ABAB拟态词，用负向前瞻排除AAAA型
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')(?!\\1\\1)\\1\\2$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式7：AAB型词语，用(?!\1)负向前瞻排除AAA型
with jmdict_tmp as (
     select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
     select CONCAT('^(',
     (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
     ')\\1(?!\\1)',
     (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
     '$') as pattern
)
SELECT * FROM jmdict_tmp WHERE yomi REGEXP (SELECT pattern FROM query_exp)
;

-- 正则表达式8：ABB型词语，用(?!\1)负向前瞻排除AAA型
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')(?!\\1)(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
	')\\2$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

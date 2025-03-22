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

-- 正则表达式6：ABAB拟态词，使用负向前瞻排除AAAA型词语
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

-- 正则表达式7：AAB型词语，使用负向前瞻(?!\1)排除AAA型词语
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
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式8：ABB型词语，使用负向前瞻(?!\1)排除AAA型词语
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

-- 正则表达式9：ABA型词语，使用负向前瞻(?!\1)排除AAA型词语
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')(?!\\1)',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    '\\1$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式9：ABAC型词语
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
query_exp as (
    select CONCAT('^(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')(?!\\1)(',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    ')\\1(?!\\1|\\2)',
    (SELECT pattern FROM j.reg_lib WHERE name = 'X'),
    '$') as pattern
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT pattern FROM query_exp);

-- 正则表达式10：长度为5，且每段各一个
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP '^.{5}$'
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'A'),'.*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'I'),'.*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'U'),'.*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'E'),'.*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'O'),'.*$'));

-- 正则表达式11：长度为5，且每段各一个（含拗音）
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
)
SELECT * FROM jmdict_tmp
WHERE yomi REGEXP (SELECT CONCAT('^',(SELECT pattern FROM j.reg_lib WHERE name = 'X'),'{5}$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'Ax'),'[^ゃャぁァぃィゅュぅゥぇェょョぉォ]*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'Ix'),'[^ゃャぁァぃィゅュぅゥぇェょョぉォ]*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'Ux'),'[^ゃャぁァぃィゅュぅゥぇェょョぉォ]*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'Ex'),'[^ゃャぁァぃィゅュぅゥぇェょョぉォ]*$'))
and yomi REGEXP (SELECT CONCAT('^.*',(SELECT pattern FROM j.reg_lib WHERE name = 'Ox'),'[^ゃャぁァぃィゅュぅゥぇェょョぉォ]*$'));

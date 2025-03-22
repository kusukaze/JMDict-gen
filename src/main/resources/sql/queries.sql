-- 十字填字游戏
select a.tail as answer,a.ID,a.termName,a.yomi,b.ID,b.termName,b.yomi,
c.ID,c.termName,c.yomi,d.ID,d.termName,d.yomi from
(select *,SUBSTRING(termName, 2, 1) as tail from j.jmdict_cross_puzzle) a
inner join
(select *,SUBSTRING(termName, 2, 1) as tail from j.jmdict_cross_puzzle) b
inner join
(select *,SUBSTRING(termName, 1, 1) as head from j.jmdict_cross_puzzle) c
inner join
(select *,SUBSTRING(termName, 1, 1) as head from j.jmdict_cross_puzzle) d
on a.tail = b.tail and a.tail = c.head and a.tail = d.head
where a.termName like "学_" and b.termName like "下_"
and c.termName like "_門" and d.termName like "_歌";

-- 找到一对动词和形容词，使得它们的た形写成假名后完全相同
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
),
    jmdict_tmp2 as (
    select ID,termName,substring_index(substring_index(yomi,',',3),',',-1) as yomi,partOfSpeech from j.jmdict
)
select * from jmdict_tmp a inner join jmdict_tmp b
on binary left(a.yomi,char_length(a.yomi)-2) = binary left(b.yomi,char_length(b.yomi)-1)
where a.partOfSpeech like "%v%" and a.partOfSpeech not like "%vs%"
and b.partOfSpeech like "%adj-i%" and b.yomi != "いい"
and binary right(a.yomi,2) in ('かる','かう','かつ')
and binary right(b.yomi,1) = 'い'
order by a.ID,b.ID;

-- 统计动词词尾占比
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
)
select right(yomi,1) as ending, count(1) as cnt,
count(1) / sum(count(1)) over() AS ratio from jmdict_tmp
where partOfSpeech like "%v5%"
group by binary ending order by ratio desc;

-- 搜索回文单词
with jmdict_tmp as (
    select ID,termName,substring_index(yomi,',',1) as yomi,partOfSpeech from j.jmdict
)
SELECT * FROM jmdict_tmp
WHERE yomi = reverse(yomi)
and char_length(yomi) >= 4;

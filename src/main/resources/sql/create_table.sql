-- jmdict建表语句
CREATE TABLE `j.jmdict` (
  `ID` int NOT NULL,
  `termName` varchar(200) DEFAULT NULL,
  `yomi` varchar(200) DEFAULT NULL,
  `partOfSpeech` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `KAKI` (`termName`),
  KEY `YOMI` (`yomi`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- 导入词库
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/JMdict_e.txt'
INTO TABLE j.jmdict
character set utf8mb4
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

-- jmdict_cross_puzzle建表语句
-- 提取出两个字的词语，以用于填字游戏效率优化
create table j.jmdict_cross_puzzle as
select * from j.jmdict where termName like "__";

-- 正则表达式表
CREATE TABLE j.reg_lib (
    name VARCHAR(50) PRIMARY KEY NOT NULL,
    pattern VARCHAR(1000) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

truncate table j.reg_lib;

INSERT INTO j.reg_lib (name, pattern) VALUES
('',''),
('A', '[あかさたなはまやらわがざばぱアカサタナハマヤラワガザバパ]'),
('I', '[いきしちにひみりぎじびぴイキシチニヒミリギジビピ]'),
('U', '[うくすつぬふむゆるぐずぶぷウクスツヌフムユルグズブプ]'),
('E', '[えけせてねへめれゑげぜべぺエケセテネヘメレヱゲゼベペ]'),
('O', '[おこそとのほもよろをござぼぽオコソトノホモヨロヲゴゾボポ]'),
('Ax', '(?:[あかさたなはまやらわがざばぱアカサタナハマヤラワガザバパ]|[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ゃャぁァ])'),
('Ix', '(?:[いきしちにひみりぎじびぴイキシチニヒミリギジビピ]|[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ぃィ])'),
('Ux', '(?:[うくすつぬふむゆるぐずぶぷウクスツヌフムユルグズブプ]|[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ゅュぅゥ])'),
('Ex', '(?:[えけせてねへめれゑげぜべぺエケセテネヘメレヱゲゼベペ]|[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ぇェ])'),
('Ox', '(?:[おこそとのほもよろをござぼぽオコソトノホモヨロヲゴゾボポ]|[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ょョぉォ])'),
('a','[あいうえおアイウエオ]'),
('k','[かきくけこカキクケコ]'),
('s','[さしすせそサシスセソ]'),
('t','[たちつてとタチツテト]'),
('n','[なにぬねのナニヌネノ]'),
('h','[はひふへほハヒフヘホ]'),
('m','[まみむめもマミムメモ]'),
('y','[やいゆえよヤイユエヨ]'),
('r','[らりるれろラリルレロ]'),
('w','[わゐうゑをワゐウヱヲ]'),
('g','[がぎぐげごガギグゲゴ]'),
('z','[ざじずぜぞザジズゼゾ]'),
('d','[だぢづでどダヂヅデド]'),
('b','[ばびぶべぼバビブベボ]'),
('p','[ぱぴぷぺぽパピプペポ]');

insert into j.reg_lib
select concat(name,'x') as name,
concat('(?:',pattern,'[ゃャぁァぃィゅュぅゥぇェょョぉォ]?)') as pattern
from j.reg_lib where name in
('a','k','s','t','n','h','m','y','r','w','g','z','d','b','p');

insert into j.reg_lib values
('X','(?:[^ゃャぁァぃィゅュぅゥぇェょョぉォ][ゃャぁァぃィゅュぅゥぇェょョぉォ]?)');

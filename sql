CREATE TABLE users
(
  id bigserial NOT NULL,
  username character(20),
  parola character(20),
  varsta bigint,
  oras character(20),
  blocat bigint,
  CONSTRAINT user_pkey PRIMARY KEY (id)
)

INSERT INTO users(username,parola,varsta,oras,blocat)
VALUES ('ionel','pwd',30,'cluj',0)
       ('danut','pwd',27,'iasi',0)
       ('marius','pwd',17,'dej',1)
       ('costica','pwd',10,'dej',0)
       ('ion','pwd',55,'turda',0)
       ('daniel','pwd',38,'buzau',0);

CREATE TABLE postare
(
  id bigserial NOT NULL,
  mesaj character(350),
  data_postarii date,
  fkuser bigint,
  CONSTRAINT pkpostari PRIMARY KEY (id),
  CONSTRAINT fkusers FOREIGN KEY (fkuser)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

INSERT INTO postare(mesaj, data_postarii, fkuser)
VALUES ('hey this is a test', '20180708', 1)
       ('another one', '20170708',3)
       ('buna ziua prieteni mei de pe facebook','20160327',6)
       ('weeeee varutuuuu','20180708',1)
       ('buying gf','20180708',2)
       ('testing','20180708',4)
       ('sunt pe facebook?','20180708',5)


-- afisare postari ionel
SELECT mesaj,data_postarii
FROM postare where fkuser=1;

-- afisarea tuturor user-ilor
SELECT *
FROM users;

-- afisarea tuturor user-ilor care nu sunt blocati
SELECT *
FROM users
WHERE blocat=0;

-- afisare user cu cea mai mica varsta
SELECT username
FROM users
WHERE varsta=(select min(varsta) from users);

-- afisarea tuturor user-ilor care au varsta intre 23 si 33 de ani, ordonat crescator
SELECT username,varsta
FROM users
WHERE varsta<33 AND varsta>23
ORDER BY varsta ASC;

-- afisare media varstei userilor blocati
SELECT avg(varsta)
FROM users
WHERE blocat=1;

-- afisare useri neblocati din dej
SELECT username
FROM users
WHERE orasul='dej'
AND blocat=0;

-- afisare postari useri neblocati din turda care au varsta peste 40 ani
SELECT mesaj,data_postarii
FROM postare,users
WHERE users.blocat=0
AND users.orasul='turda' AND users.varsta>40 AND fkuser=users.id;

-- afisare user cu cele mai multe postari
SELECT username
FROM users,postare
WHERE users.id=postare.fkuser
GROUP BY username
ORDER BY count(mesaj) desc
LIMIT 1;

-- afisare postari ale userilor ar care nume incepe cu D si sunt postate intre 1 si 31 martie 2016
SELECT mesaj
FROM postare,users
WHERE users.username LIKE 'd%'
AND users.id=postare.fkuser AND postare.data_postarii > '20160301' AND postare.data_postarii<'20160331';

-- afisare postari descendent
SELECT mesaj
FROM postare,users
WHERE users.id = postare.fkuser
ORDER BY postare.data_postarii DESC;

-- sa se stearga postarile userilor sub 18 ani care contin cuvantul "politica"
DELETE FROM postare
USING users
WHERE users.id=postare.fkuser
AND mesaj like '%politica%' AND varsta < 18;
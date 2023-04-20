--Affichez les exp�ditions en transit qui ont �t� initi�es par un entrep�t situ� en Europe et � destination d'un entrep�t situ� en Asie.

--(requ�te en plus pour l'execution des requ�tes suivantes) ajout d'une colonne continent dans entrepots
ALTER TABLE entrepots
ADD continent VARCHAR(20);

UPDATE entrepots SET continent='europe' WHERE pays IN ('France','Angleterre','Autriche')
UPDATE entrepots SET continent='AFRIQUE' WHERE pays='Maroc'
UPDATE entrepots SET continent='Amerique' WHERE pays='Etats-unis'

INSERT INTO entrepots (nom_entrepot, adresse, ville, pays, continent)
VALUES 
('SingapourInc.','123 rue singapour','Singapour','Singapour','Asie'),
('Bangkok','123 rue bangkok','Bangkok','Tha�lande','Asie'),
('los Angels', '20 8 Avenue', 'Los Angeles', 'Etats-Unis', 'Amerique');

INSERT INTO expeditions (date_expedition, id_entrepot_source, id_entrepot_destination, poids, statut)
VALUES
	('2023-04-01',8,5,896,'en transit'),
	('2023-04-04',3,5,89,'en transit'),
	('2023-03-28',5,8,540,'arriver'),
    ('2023-03-20', 8, 4, 1200, 'en transit'),
    ('2023-03-21', 3, 7, 180.6, 'en transit'),
    ('2023-03-28',4,6,40,'arriver');

--affichage des expeditions d'europe en destination d'Asie
SELECT 
	*
FROM
	expeditions expe
INNER JOIN entrepots entrs
	ON expe.id_entrepot_source=entrs.id
INNER JOIN entrepots entrd
	ON expe.id_entrepot_destination=entrd.id
WHERE entrs.continent='europe' AND entrd.continent='Asie';


--Affichez les entrep�ts qui ont envoy� des exp�ditions � destination d'un entrep�t situ� dans le m�me pays.

SELECT DISTINCT *
FROM expeditions expe
INNER JOIN entrepots entre1 ON entre1.id = expe.id_entrepot_source
INNER JOIN entrepots entre2 ON entre2.id = expe.id_entrepot_destination
WHERE entre1.pays = entre2.pays;



--Affichez les entrep�ts qui ont envoy� des exp�ditions � destination d'un entrep�t situ� dans un pays diff�rent.

SELECT DISTINCT *
FROM expeditions expe
INNER JOIN entrepots entre1 ON entre1.id = expe.id_entrepot_source
INNER JOIN entrepots entre2 ON entre2.id = expe.id_entrepot_destination
WHERE entre1.pays != entre2.pays;


--Affichez les exp�ditions en transit qui ont �t� initi�es par un entrep�t situ� dans un pays dont le nom commence par la lettre "F" et qui p�sent plus de 500 kg.

UPDATE expeditions SET poids=570 WHERE id=1;

SELECT *
FROM expeditions e
JOIN entrepots ent1 ON e.id_entrepot_source = ent1.id
WHERE e.statut = 'en transit'
AND ent1.pays LIKE 'F%'
AND e.poids > 500;

--Affichez le nombre total d'exp�ditions pour chaque combinaison de pays d'origine et de destination.

SELECT 
	e1.pays AS pays_origine, 
	e2.pays AS pays_destination, 
	COUNT(*) AS nb_expeditions
FROM 
	entrepots e1
JOIN expeditions ex ON ex.id_entrepot_source = e1.id
JOIN entrepots e2 ON ex.id_entrepot_destination = e2.id
GROUP BY e1.pays, e2.pays;

--Affichez les entrep�ts qui ont envoy� des exp�ditions au cours des 30 derniers jours et dont le poids total des exp�ditions est sup�rieur � 1000 kg.

SELECT 
	ent1.nom_entrepot,
	sum(poids)
FROM expeditions e
JOIN entrepots ent1 ON e.id_entrepot_source = ent1.id
WHERE
	DATEDIFF(day, date_expedition, GETDATE())<=30
GROUP BY 
	ent1.nom_entrepot
HAVING
	sum(e.poids) > 1000;

--Affichez les exp�ditions qui ont �t� livr�es avec un retard de plus de 2 jours ouvrables.

--cr�ation colonne date_livraison et date_livraison_pr�vu--
ALTER TABLE expeditions 
ADD date_livraison_pr�vu date , date_livraison date;

update expeditions SET date_livraison_pr�vu=DATEADD(day, 7,date_expedition);

update expeditions SET date_livraison=DATEADD(day, 7,date_expedition) WHERE id IN (1,3,5,8,10,4,9,7);

update expeditions SET date_livraison=DATEADD(day, 11,date_expedition) WHERE id IN (2,4,6,11);

update expeditions SET date_livraison=DATEADD(day, 4,date_expedition) WHERE id IN (12,14,16,15,18);

SELECT *
FROM expeditions 
WHERE 
statut='arriver' AND
DATEDIFF(DAY,date_livraison_pr�vu,date_livraison)>2;



--Affichez le nombre total d'exp�ditions pour chaque jour du mois en cours, tri� par ordre d�croissant.

SELECT 
	DAY(date_expedition) as jour,
	count(*) as nombre_expedition
FROM
	expeditions
WHERE 
	month(date_expedition)=month(getdate())
GROUP BY DAY(date_expedition)
ORDER BY nombre_expedition DESC;


SELECT * FROM entrepots;
select * FROM expeditions;


--Cr�ez une vue qui affiche les informations suivantes pour chaque entrep�t : 
--nom de l'entrep�t, adresse compl�te, nombre d'exp�ditions envoy�es au cours des 30 derniers jours.

CREATE VIEW entrepot_view AS
SELECT nom_entrepot,
		(adresse+ville+pays)as adresse, 
		count(id_entrepot_source) as nombres_expeditions
FROM entrepots e
INNER JOIN
	 expeditions expd
	 ON
	 e.id=expd.id_entrepot_source
WHERE
	DATEDIFF(day,date_expedition,getdate())<=30
GROUP BY 
		nom_entrepot,
		(adresse+ville+pays);
		
SELECT *
FROM entrepot_view;


--Cr�ez une proc�dure stock�e qui prend en entr�e l'ID d'un entrep�t et renvoie le nombre total d'exp�ditions 
--envoy�es par cet entrep�t au cours du dernier mois.


CREATE PROCEDURE nb_expeditions_envoyees_dernier_mois
    @id_entrepot INT
AS
BEGIN
    SELECT COUNT(*) AS nombre_expeditions_envoyees
    FROM expeditions
    WHERE id_entrepot_source = @id_entrepot
    AND date_expedition >= DATEADD(month, -1, GETDATE());
END

EXEC nb_expeditions_envoyees_dernier_mois @id_entrepot=3;


--Cr�ez une fonction qui prend en entr�e une date et renvoie le nombre total d'exp�ditions livr�es ce jour-l�.

CREATE FUNCTION nombre_total_dexp�ditions_livr�es(@date date)
RETURNS INT
AS
BEGIN
    DECLARE @result int;
    SELECT @result = COUNT(*) 
    FROM expeditions
    WHERE date_livraison = @date;
    RETURN @result;
END

SELECT dbo.nombre_total_dexp�ditions_livr�es('2023-03-22');



--Ajoutez une table "clients" contenant les colonnes suivantes :
--id (entier auto-incr�ment�, cl� primaire) nom (cha�ne de caract�res) adresse (cha�ne de caract�res) 
--ville (cha�ne de caract�res) pays (cha�ne de caract�res)
CREATE TABLE clients 
(id INT NOT NULL IDENTITY(1,1),
nom VARCHAR(20),
adresse VARCHAR(50),
ville VARCHAR(50),
pays VARCHAR(20)
);

ALTER TABLE clients ADD PRIMARY KEY (id);



--Ajoutez une table de jointure "expeditions_clients" contenant les colonnes suivantes :
--id_expedition (entier, cl� �trang�re faisant r�f�rence � la table "expeditions") 
--id_client (entier, cl� �trang�re faisant r�f�rence � la table "clients")

CREATE TABLE expeditions_clients
(id_expeditions int not null,
id_client int not null,
FOREIGN KEY (id_expeditions) REFERENCES expeditions(id),
FOREIGN KEY (id_client) REFERENCES clients(id)
);


--Modifiez la table "expeditions" pour y ajouter une colonne "id_client" (entier, 
--cl� �trang�re faisant r�f�rence � la table "clients").

ALTER TABLE expeditions ADD 
id_client INT, 
FOREIGN KEY (id_client) REFERENCES clients(id);

UPDATE expeditions SET id_client=1 WHERE id IN (1,6,7,10,15,9);
UPDATE expeditions SET id_client=2 WHERE id IN (2,5,3,4,12);
UPDATE expeditions SET id_client=3 WHERE id IN (8,13,11);
UPDATE expeditions SET id_client=4 WHERE id IN (14,16);

--Ajoutez des donn�es aux tables "clients" et "expeditions_clients". 
--**�crivez des requ�tes pour extraire les informations suivantes : 
--**- Pour chaque client, affichez son nom, son adresse compl�te, le nombre total d'exp�ditions 
--qu'il a envoy�es et le nombre total d'exp�ditions qu'il a re�ues.

INSERT INTO clients(nom, adresse, ville,pays)
VALUES
	('rasolo',  'Michelle de montaigne',' eybens','France'),
	('michel','rue de la republique', 'Vaulx-en-velin', 'LOS ANGELES'),
	('ferry','felix fort', 'lyon', 'THAILANDE'),
	('sotos','les granges', 'la tours','BRESIL');

INSERT INTO expeditions_clients(id_client,id_expeditions)
VALUES
(1,2),
(1,9),
(1,10),
(1,5),
(2,1),
(2,11),
(3,15),
(3,3),
(3,4),
(4,16),
(4,13),
(4,12);




--renome les colonnes--
EXEC sp_rename 'expeditions.id_client', 'id_client_receveur', 'COLUMN';
EXEC sp_rename 'expeditions_clients.id_client', 'id_client_expediteur', 'COLUMN';


--<<<<<<<<<<<<<<<<<<< MARCHE >>>>>>>>>>>>>>>>>>>>>>>>>

SELECT c.nom AS nom_client, 
       c.adresse AS adresse_client, 
       CONCAT(c.adresse, ', ', c.ville, ', ', c.pays) AS adresse_complete,
       COUNT(DISTINCT ec.id_expeditions) AS nb_expeditions_envoyees, 
       (SELECT COUNT(*) FROM expeditions WHERE id_client_receveur = c.id) AS nb_expeditions_recues
FROM clients c
LEFT JOIN expeditions_clients ec ON c.id = ec.id_client_expediteur
GROUP BY c.id, c.nom, c.adresse, c.ville, c.pays;

--<<<<<<<<<<<<<<<<<<< MARCHE >>>>>>>>>>>>>>>>>>>>>>>>>	
	



---Pour chaque exp�dition, affichez son ID, son poids, le nom du client qui l'a envoy�e, 
--le nom du client qui l'a re�ue et le statut



SELECT e.id AS id_expedition,
       e.poids AS poids,
       c1.nom AS expediteur_nom,
       c2.nom AS destinataire_nom,
       e.statut AS statut
FROM expeditions e
INNER JOIN expeditions_clients ec ON ec.id_expeditions=e.id
JOIN clients c1 ON ec.id_client_expediteur = c1.id
JOIN clients c2 ON e.id_client_receveur = c2.id;




SELECT *
FROM 
	expeditions;

SELECT *
FROM 
	entrepots;

SELECT *
FROM 
	expeditions_clients;

SELECT *
FROM clients
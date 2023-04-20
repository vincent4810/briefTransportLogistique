

CREATE DATABASE transport_logistique;

USE transport_logistique;


--Cr�ez une table "entrepots" contenant les colonnes suivantes : 
--id (entier auto-incr�ment�, cl� primaire) , nom_entrepot (cha�ne de caract�res), 
--adresse (cha�ne de caract�res), ville (cha�ne de caract�res) ,pays (cha�ne de caract�res).

CREATE TABLE entrepots (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nom_entrepot VARCHAR(25),
    adresse VARCHAR(250),
    ville VARCHAR(30),
    pays VARCHAR(20)
);



--Cr�ez une table "expeditions" contenant les colonnes suivantes : 
--id (entier auto-incr�ment�, cl� primaire), date_expedition (date), date_livraison (date), 
--id_entrepot_source (entier, cl� �trang�re faisant r�f�rence � la table "entrepots"), id_entrepot_destination 
--(entier, cl� �trang�re faisant r�f�rence � la table "entrepots"), poids (d�cimal), statut (cha�ne de caract�res).

CREATE TABLE expeditions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    date_expedition DATE,
    id_entrepot_source INT FOREIGN KEY REFERENCES entrepots(id),
    id_entrepot_destination INT FOREIGN KEY REFERENCES entrepots(id),
    poids DECIMAL(10,2), --permet de pouvoir stocker des nombres d�cimaux allant jusqu�� 10 chiffres avec 2 d�cimales (ex: 12345.67).
    statut VARCHAR(30)
);
-- "------------------ QUESTION 3 ------------------"
SELECT Classes.Enseignant, GROUP_CONCAT(Eleves.nom) AS Liste_eleves -- cree une liste de noms d'eleves separes par une virgule
FROM Classes, Eleves WHERE Classes.ClassID = Eleves.ClassID
GROUP BY Classes.Enseignant
ORDER BY Classes.Enseignant ASC; -- tri par noms d'enseignants dans l'ordre alphabetique


-- "------------------ QUESTION 4 ------------------"
SELECT Activites.Jour, Activites.Bus, COUNT(Repartition.ElevID) AS Nb_eleves -- compte le nombre d'eleves par bus pour chaque jour
FROM Activites, Repartition WHERE Activites.ActID = Repartition.ActID
GROUP BY Activites.Jour, Activites.Bus
ORDER BY Activites.Jour ASC, Activites.Bus ASC; -- optionnel


-- "------------------ QUESTION 5 ------------------"
SELECT Activites.Jour, Eleves.ElevID
FROM Activites, Repartition, Eleves WHERE Activites.ActID = Repartition.ActID AND Eleves.ElevID = Repartition.ElevID
GROUP BY Activites.Jour, Eleves.ElevID
HAVING COUNT(Activites.ActID) >= 2 -- garde que les eleves qui ont plus de 2 activites
ORDER BY Activites.Jour ASC; -- optionnel


-- "------------------ QUESTION 6 ------------------"
SELECT Eleves.ElevID
FROM Activites, Repartition, Eleves WHERE Activites.ActID = Repartition.ActID AND Eleves.ElevID = Repartition.ElevID
GROUP BY Eleves.ElevID
HAVING COUNT(DISTINCT Activites.Jour) = ( -- les eleves doivent avoir des activites autant de jours que ...
    SELECT COUNT(DISTINCT Activites.Jour) -- il y a de jour avec activite
    FROM Activites)
ORDER BY Eleves.ElevID ASC; -- optionnel


-- "------------------ QUESTION 7 ------------------"
SELECT COUNT(DISTINCT Eleves.ElevID) AS Nb_eleves -- compte le nombre d'eleves qui ...
FROM Eleves, Repartition, Activites WHERE Eleves.ElevID=Repartition.ElevID AND Repartition.ActID=Activites.ActID AND Eleves.Ville=Activites.Lieu; -- ont une activite ou ils vivent


-- "------------------ QUESTION 8 ------------------"
SELECT Activites.Theme,COUNT(Repartition.ElevID) AS Nb_eleves 
FROM Repartition,Activites WHERE Repartition.ActID=Activites.ActID
GROUP BY Activites.ActID 
HAVING COUNT(Repartition.ElevID) IN 
    (SELECT A.Nb_eleves -- Selectionne tous les nombres d'etudiants, partage par 2 activites  
    FROM (SELECT Activites.ActID,COUNT(Repartition.ElevID) AS Nb_eleves -- Table A = nombre d'etudiants par activite 
         FROM Repartition,Activites WHERE Repartition.ActID=Activites.ActID
         GROUP BY Activites.ActID) AS A
    GROUP BY A.Nb_eleves
    HAVING COUNT(A.ActID)>=2)
ORDER BY Nb_eleves DESC;


-- "------------------ QUESTION 9 ------------------"
SELECT  Activites.Theme,COUNT(Eleves.ElevID) AS Nb_eleves 
FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
GROUP BY Activites.Theme
ORDER BY COUNT(Eleves.ElevID) DESC LIMIT 2; 


-- "------------------ QUESTION 10 ------------------"
SELECT Activites.Theme, COUNT(Repartition.ActID) AS Nb_eleves,Repartition.ActID
FROM Activites, Repartition
WHERE Activites.ActID=Repartition.ActID
GROUP BY Repartition.ActID
ORDER BY COUNT(Repartition.ActID) DESC, Activites.ActID ASC;


--  "------------------ QUESTION 11 ------------------"
SELECT Classes.Enseignant, COUNT(Eleves.ElevID) AS Nb_eleves
FROM Classes, Eleves
WHERE Eleves.ClassID=Classes.ClassID
GROUP BY Classes.Enseignant
HAVING COUNT(Eleves.ElevID)>=
    (SELECT AVG(N.nb)
    FROM 
        (SELECT COUNT(*) AS nb
        FROM Eleves GROUP BY ClassID) as N);


--  "------------------ QUESTION 12 ------------------"
SELECT Activites.Theme,AVG(Eleves.Age) AS Moy,MIN(Eleves.Age) AS Min,MAX(Eleves.Age) AS Max,MAX(Eleves.Age)- MIN(Eleves.Age) AS Inter
FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID
GROUP BY Activites.Theme;


--  "------------------ QUESTION 13 ------------------"
SELECT C.Theme,GROUP_CONCAT(C.Ville) AS Ville,C.Nb_eleves
FROM (SELECT Activites.Theme,COUNT(Eleves.ElevID) AS Nb_eleves,Eleves.Ville -- Toutes les villes ou il y a le nombre maximal de participant dans une activite
      FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
      GROUP BY Activites.Theme,Activites.ActID,Eleves.Ville
      HAVING CONCAT(Activites.ActID,COUNT(Eleves.ElevID)) IN
          (SELECT CONCAT(Activites.ActID,MAX(B.Nb_eleves)) -- Table avec le max de participants d'une meme ville par activite
          FROM (SELECT Activites.ActID,COUNT(Eleves.ElevID) AS Nb_eleves -- Table avec le nombre de participant d'une meme activite par ville
               FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
               GROUP BY Activites.ActID,Eleves.Ville) B,
          Activites WHERE Activites.ActID=B.ActID
          GROUP BY Activites.ActID)
      ORDER BY Activites.Theme) C
GROUP BY C.Theme,C.Nb_eleves;


--  "------------------ QUESTION 14 ------------------"
SELECT Eleves.ElevID,Eleves.nom,Eleves.Ville,GROUP_CONCAT(DISTINCT(Activites.Lieu)) AS Ville_activite
FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
AND Eleves.Ville!=Activites.Lieu
GROUP BY Eleves.ElevID,Eleves.nom,Eleves.Ville;


--  "------------------ QUESTION 15 ------------------"
SELECT A.Ville,ROUND(A.Nb_eleves*100/SUM(A.Nb_eleves) OVER(),1) AS Pourcentage -- SUM(A.nb_student) Over() Somme sur tout "nb_student" (toutes les lignes)
FROM (SELECT Eleves.Ville,COUNT(Eleves.ElevID) AS Nb_eleves    
     FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
     GROUP BY Eleves.Ville) A;


--  "------------------ QUESTION 16 ------------------"
DROP TABLE IF EXISTS Temp;
CREATE TABLE Temp AS -- Creer une table avec nom, id, act_id, classe_id pour rendre la fin de la question plus facile
    SELECT Eleves.nom,Eleves.ElevID,Activites.ActID,Eleves.ClassID
    FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID;
 
SELECT GROUP_CONCAT(DISTINCT(X.nom)) AS X,GROUP_CONCAT(DISTINCT(Y.nom)) AS Y -- On ecrit GROUP_CONCAT(DISTINCT(Z.nom)) car Z.nom ne suffit pas. Un couple d'etudiant de different classe peuvent avoir plus d'une activite en commun donc le couple apparait sur plusieurs lignes
FROM Temp AS X,Temp AS Y -- duplicate the class crated
WHERE X.ElevID<Y.ElevID AND X.ClassID!=Y.ClassID AND X.ActID=Y.ActID -- On ecrit X.elevID<Y.elevID pour ne pas avoir XY et YX 
GROUP BY X.ElevID,Y.ElevID; 

DROP TABLE IF EXISTS Temp;


--  "------------------ QUESTION 17 ------------------"
SELECT Nb_par_couple.ActID, Nb_par_couple.ClassID
FROM ( -- on utilise 2 sous-requetes pour construire des tables et simplifier le probleme
    SELECT Activites.ActID, Eleves.ClassID, COUNT(Eleves.ElevID) AS Nb_eleves
    FROM Activites, Repartition, Eleves
    WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID
    GROUP BY Activites.ActID, Eleves.ClassID) AS Nb_par_couple, ( -- d'abord, on cree une table avec le nombre d'eleves par couple(activite,classe)
    SELECT Eleves.ClassID, COUNT(Eleves.ElevID) AS Nb_eleves
    FROM Eleves
    GROUP BY Eleves.ClassID) AS Nb_par_classe -- ensuite, on cree une table avec le nombre d'eleves total par classe
WHERE Nb_par_couple.ClassID=Nb_par_classe.ClassID AND Nb_par_couple.Nb_eleves=Nb_par_classe.Nb_eleves; -- enfin, on fait une jointure sur CLassID et on ne garde que les couples qui ont le meme nombre d'eleve que le nombre total d'eleve dans la classe du couple

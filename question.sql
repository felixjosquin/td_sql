USE TD_NOTE;

-- "------------------ QUESTION 8 ------------------"
DROP TABLE IF EXISTS nb_act;
CREATE TABLE nb_act AS 
    SELECT Repartition.actID,Activite.theme,COUNT(Repartition.elevID)AS nb_eleve 
    FROM Repartition,Activite WHERE Activite.actID=Repartition.actID 
    GROUP BY Repartition.actID;

SELECT Activite.theme,COUNT(Repartition.elevID) AS nb_eleve 
FROM Repartition,Activite WHERE Repartition.actID=Activite.actID
GROUP BY Activite.actID 
HAVING COUNT(Repartition.elevID) IN
    (SELECT nb_eleve FROM nb_act GROUP BY nb_eleve HAVING COUNT(*)>1)
ORDER BY nb_eleve DESC;


-- "------------------ QUESTION 10 ------------------""
SELECT Activite.theme, COUNT(Repartition.actID) AS Nb_elve,Repartition.actID
FROM Activite, Repartition
WHERE Activite.actID=Repartition.actID
GROUP BY Repartition.actID
ORDER BY COUNT(Repartition.actID) DESC, Activite.actID ASC;


--  "------------------ QUESTION 11 ------------------"

SELECT Classes.enseignant, COUNT(Eleve.elevID) AS Nb_eleve
FROM Classes, Eleve
WHERE Eleve.classe_id=Classes.classe_id
GROUP BY Classes.enseignant
HAVING COUNT(Eleve.elevID)>=
    (SELECT AVG(nb_student.nb)
    FROM 
        (SELECT COUNT(*) AS nb
        FROM Eleve GROUP BY classe_id) as nb_student);


--  "------------------ QUESTION 12 ------------------"
SELECT Activite.theme,AVG(Eleve.age) AS Moy,MIN(Eleve.age) AS Min,MAX(Eleve.age) AS Max,MAX(Eleve.age)- MIN(Eleve.age) AS Inter
FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID
GROUP BY Activite.theme;


--  "------------------ QUESTION 13 ------------------"
SELECT Activite.theme,COUNT(Eleve.elevID) AS nb_eleve,GROUP_CONCAT(DISTINCT(Eleve.ville)) AS villes
FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
GROUP BY Activite.theme,Activite.actID,Eleve.ville
HAVING CONCAT(Activite.actID,COUNT(Eleve.elevID)) IN
    (SELECT CONCAT(Activite.actID,MAX(B.nb_student))
    FROM (SELECT Activite.actID,COUNT(Eleve.elevID) AS nb_student
         FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
         GROUP BY Activite.actID,Eleve.ville) B,
    Activite WHERE Activite.actID=B.actID
    GROUP BY Activite.actID)
ORDER BY Activite.theme;



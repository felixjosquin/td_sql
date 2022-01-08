USE TD_NOTE;

-- "------------------ QUESTION 8 ------------------"
SELECT Activite.theme,COUNT(Repartition.elevID) AS nb_eleve 
FROM Repartition,Activite WHERE Repartition.actID=Activite.actID
GROUP BY Activite.actID 
HAVING COUNT(Repartition.elevID) IN 
    (SELECT A.nb_student -- Select all number of students which have commun in 2 differents Activity
    FROM (SELECT Activite.actID,COUNT(Repartition.elevID) AS nb_student -- Create table A with nb student by ActivityID
         FROM Repartition,Activite WHERE Repartition.actID=Activite.actID
         GROUP BY Activite.actID) A
    GROUP BY A.nb_student
    HAVING COUNT(A.actID)>1)
ORDER BY nb_eleve DESC;


-- "------------------ QUESTION 9 ------------------"
SELECT  Activite.theme,COUNT(Eleve.elevID) AS nb_eleve 
FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
GROUP BY Activite.theme
ORDER BY COUNT(Eleve.elevID) DESC LIMIT 2;


-- "------------------ QUESTION 10 ------------------"
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
    (SELECT AVG(N.nb)
    FROM 
        (SELECT COUNT(*) AS nb
        FROM Eleve GROUP BY classe_id) as N);


--  "------------------ QUESTION 12 ------------------"
SELECT Activite.theme,AVG(Eleve.age) AS Moy,MIN(Eleve.age) AS Min,MAX(Eleve.age) AS Max,MAX(Eleve.age)- MIN(Eleve.age) AS Inter
FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID
GROUP BY Activite.theme;


--  "------------------ QUESTION 13 ------------------"
SELECT C.theme,GROUP_CONCAT(C.ville) AS ville,C.nb_eleve
FROM (SELECT Activite.theme,COUNT(Eleve.elevID) AS nb_eleve,Eleve.ville -- all city where there is the max student in a activity 
      FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
      GROUP BY Activite.theme,Activite.actID,Eleve.ville
      HAVING CONCAT(Activite.actID,COUNT(Eleve.elevID)) IN
          (SELECT CONCAT(Activite.actID,MAX(B.nb_student)) -- table with the max of student by activity
          FROM (SELECT Activite.actID,COUNT(Eleve.elevID) AS nb_student -- table with the nb of student by activity and town
               FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
               GROUP BY Activite.actID,Eleve.ville) B,
          Activite WHERE Activite.actID=B.actID
          GROUP BY Activite.actID)
      ORDER BY Activite.theme) C
GROUP BY C.theme,C.nb_eleve;


--  "------------------ QUESTION 14 ------------------"
SELECT Eleve.elevID,Eleve.nom,Eleve.ville,GROUP_CONCAT(DISTINCT(Activite.lieu)) AS ville_activité
FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
AND Eleve.ville!=Activite.lieu
GROUP BY Eleve.elevID,Eleve.nom,Eleve.ville;


--  "------------------ QUESTION 15 ------------------"
SELECT A.ville,ROUND(A.nb_student*100/SUM(A.nb_student) OVER(),1) AS Pourcentage -- SUM(A.nb_student) Over() Somme on all "nb_student" on all row of "A"
FROM (SELECT Eleve.ville,COUNT(Eleve.elevID) AS nb_student    
     FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID 
     GROUP BY Eleve.ville) A;


--  "------------------ QUESTION 16 ------------------"
DROP TABLE IF EXISTS temp;
CREATE TABLE temp AS -- Crate a table with just nom, id, "all" act_id, classe_id to simplified the rest
    SELECT Eleve.nom,Eleve.elevID,Activite.actID,Eleve.classe_id
    FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID;
 
SELECT GROUP_CONCAT(DISTINCT(X.nom)) AS X,GROUP_CONCAT(DISTINCT(Y.nom)) AS Y -- Write GROUP_CONCAT(DISTINCT(Z.nom)) because Z.nom don't work student of class different can have differents activity in commun so there are 2 or + row for them
FROM temp AS X,temp AS Y -- duplicate the class crated
WHERE X.elevID<Y.elevID AND X.classe_id!=Y.classe_id AND X.actID=Y.actID -- choise X.elevID<Y.elevID to don't have XY and YX in liste than choice just studants with same activite and not same class
GROUP BY X.elevID,Y.elevID; -- We can just write X.nom,Y.nom ans SELECT X.nom,Y.nom but it bette to Group on ID

DROP TABLE IF EXISTS temp;


--  "------------------ QUESTION 17 ------------------"

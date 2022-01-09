-- "------------------ QUESTION 3 ------------------"
SELECT Classes.enseignant, GROUP_CONCAT(Eleve.nom) AS liste_eleve -- create a string of students' name separated by a ","
FROM Classes, Eleve WHERE Classes.classe_id = Eleve.classe_id
GROUP BY Classes.enseignant
ORDER BY Classes.enseignant ASC; -- sort enseignants' name by alphabetical order 


-- "------------------ QUESTION 4 ------------------"
SELECT Activite.jour, Activite.bus, COUNT(Repartition.elevID) AS nb_student -- count the number of students by bus for each day
FROM Activite, Repartition WHERE Activite.actID = Repartition.actID
GROUP BY Activite.jour, Activite.bus
ORDER BY Activite.jour ASC, Activite.bus ASC; -- optional


-- "------------------ QUESTION 5 ------------------"
SELECT Activite.jour, Eleve.elevID
FROM Activite, Repartition, Eleve WHERE Activite.actID = Repartition.actID AND Eleve.elevID = Repartition.elevID
GROUP BY Activite.jour, Eleve.elevID
HAVING COUNT(Activite.actID) >= 2 -- select students who have more than 2 activities
ORDER BY Activite.jour ASC; -- optional


-- "------------------ QUESTION 6 ------------------"
SELECT Eleve.elevID
FROM Activite, Repartition, Eleve WHERE Activite.actID = Repartition.actID AND Eleve.elevID = Repartition.elevID
GROUP BY Eleve.elevID
HAVING COUNT(DISTINCT Activite.jour) = ( -- student must have activities the same number of distinct days as ...
    SELECT COUNT(DISTINCT Activite.jour) -- the number of days with activities
    FROM Activite)
ORDER BY Eleve.elevID ASC; -- optional


-- "------------------ QUESTION 7 ------------------"
SELECT COUNT(DISTINCT Eleve.elevID) AS nb_student -- count the number of students who have ...
FROM Eleve, Repartition, Activite WHERE Eleve.elevID=Repartition.elevID AND Repartition.actID=Activite.actID AND Eleve.ville=Activite.lieu; -- an activity where they live


-- "------------------ QUESTION 8 ------------------"
SELECT Activite.theme,COUNT(Repartition.elevID) AS nb_eleve 
FROM Repartition,Activite WHERE Repartition.actID=Activite.actID
GROUP BY Activite.actID 
HAVING COUNT(Repartition.elevID) IN 
    (SELECT A.nb_student -- Select all number of students which have in 2 different activities in common 
    FROM (SELECT Activite.actID,COUNT(Repartition.elevID) AS nb_student -- Create table A containing the number of students by activity
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
SELECT Eleve.elevID,Eleve.nom,Eleve.ville,GROUP_CONCAT(DISTINCT(Activite.lieu)) AS ville_activite
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
CREATE TABLE temp AS -- Create a table with just nom, id, "all" act_id, classe_id to simplify the rest
    SELECT Eleve.nom,Eleve.elevID,Activite.actID,Eleve.classe_id
    FROM Repartition,Activite,Eleve WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID;
 
SELECT GROUP_CONCAT(DISTINCT(X.nom)) AS X,GROUP_CONCAT(DISTINCT(Y.nom)) AS Y -- Write GROUP_CONCAT(DISTINCT(Z.nom)) because Z.nom does not work. Student of different class different can have differents activity in commun so there are 2 or + row for them
FROM temp AS X,temp AS Y -- duplicate the class crated
WHERE X.elevID<Y.elevID AND X.classe_id!=Y.classe_id AND X.actID=Y.actID -- choise X.elevID<Y.elevID to don't have XY and YX in liste than choice just studants with same activite and not same class
GROUP BY X.elevID,Y.elevID; 

DROP TABLE IF EXISTS temp;


--  "------------------ QUESTION 17 ------------------"
SELECT Nb_per_couple.actID, Nb_per_couple.classe_id
FROM ( -- 2 subqueries to construct useful tables
    SELECT Activite.actID, Eleve.classe_id, COUNT(Eleve.elevID) AS nb_student
    FROM Activite, Repartition, Eleve
    WHERE Activite.actID=Repartition.actID AND Repartition.elevID=Eleve.elevID
    GROUP BY Activite.actID, Eleve.classe_id) AS Nb_per_couple, ( -- first, create a table with the number of student per couple(activity,class)
    SELECT Eleve.classe_id, COUNT(Eleve.elevID) AS nb_student
    FROM Eleve
    GROUP BY Eleve.classe_id) AS Nb_per_class -- then, create a table with the number of student per class
WHERE Nb_per_couple.classe_id=Nb_per_class.classe_id AND Nb_per_couple.nb_student=Nb_per_class.nb_student; -- finally, join on the classe_id and the couple must have the same number of students as the number of students of its class

-- "------------------ QUESTION 3 ------------------"
SELECT Classes.Enseignant, GROUP_CONCAT(Eleves.nom) AS Liste_eleves -- create a string of students' name separated by a ","
FROM Classes, Eleves WHERE Classes.ClassID = Eleves.ClassID
GROUP BY Classes.Enseignant
ORDER BY Classes.Enseignant ASC; -- sort Enseignants' name by alphabetical order 


-- "------------------ QUESTION 4 ------------------"
SELECT Activites.Jour, Activites.Bus, COUNT(Repartition.ElevID) AS Nb_eleves -- count the number of students by Bus for each day
FROM Activites, Repartition WHERE Activites.ActID = Repartition.ActID
GROUP BY Activites.Jour, Activites.Bus
ORDER BY Activites.Jour ASC, Activites.Bus ASC; -- optional


-- "------------------ QUESTION 5 ------------------"
SELECT Activites.Jour, Eleves.ElevID
FROM Activites, Repartition, Eleves WHERE Activites.ActID = Repartition.ActID AND Eleves.ElevID = Repartition.ElevID
GROUP BY Activites.Jour, Eleves.ElevID
HAVING COUNT(Activites.ActID) >= 2 -- select students who have more than 2 activities
ORDER BY Activites.Jour ASC; -- optional


-- "------------------ QUESTION 6 ------------------"
SELECT Eleves.ElevID
FROM Activites, Repartition, Eleves WHERE Activites.ActID = Repartition.ActID AND Eleves.ElevID = Repartition.ElevID
GROUP BY Eleves.ElevID
HAVING COUNT(DISTINCT Activites.Jour) = ( -- student must have activities the same number of distinct days as ...
    SELECT COUNT(DISTINCT Activites.Jour) -- the number of days with activities
    FROM Activites)
ORDER BY Eleves.ElevID ASC; -- optional


-- "------------------ QUESTION 7 ------------------"
SELECT COUNT(DISTINCT Eleves.ElevID) AS Nb_eleves -- count the number of students who have ...
FROM Eleves, Repartition, Activites WHERE Eleves.ElevID=Repartition.ElevID AND Repartition.ActID=Activites.ActID AND Eleves.Ville=Activites.Lieu; -- an activity where they live


-- "------------------ QUESTION 8 ------------------"
SELECT Activites.Theme,COUNT(Repartition.ElevID) AS Nb_eleves 
FROM Repartition,Activites WHERE Repartition.ActID=Activites.ActID
GROUP BY Activites.ActID 
HAVING COUNT(Repartition.ElevID) IN 
    (SELECT A.Nb_eleves -- Select all number of students which have in 2 different activities in common 
    FROM (SELECT Activites.ActID,COUNT(Repartition.ElevID) AS Nb_eleves -- Create table A containing the number of students by activity
         FROM Repartition,Activites WHERE Repartition.ActID=Activites.ActID
         GROUP BY Activites.ActID) AS A
    GROUP BY A.Nb_eleves
    HAVING COUNT(A.ActID)>1)
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
FROM (SELECT Activites.Theme,COUNT(Eleves.ElevID) AS Nb_eleves,Eleves.Ville -- all city where there is the max student in a activity 
      FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
      GROUP BY Activites.Theme,Activites.ActID,Eleves.Ville
      HAVING CONCAT(Activites.ActID,COUNT(Eleves.ElevID)) IN
          (SELECT CONCAT(Activites.ActID,MAX(B.Nb_eleves)) -- table with the max of student by activity
          FROM (SELECT Activites.ActID,COUNT(Eleves.ElevID) AS Nb_eleves -- table with the nb of student by activity and town
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
SELECT A.Ville,ROUND(A.Nb_eleves*100/SUM(A.Nb_eleves) OVER(),1) AS Pourcentage -- SUM(A.Nb_eleves) Over() Somme on all "Nb_eleves" on all row of "A"
FROM (SELECT Eleves.Ville,COUNT(Eleves.ElevID) AS Nb_eleves    
     FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID 
     GROUP BY Eleves.Ville) A;


--  "------------------ QUESTION 16 ------------------"
DROP TABLE IF EXISTS Temp;
CREATE TABLE Temp AS -- Create a table with just nom, id, "all" act_id, ClassID to simplify the rest
    SELECT Eleves.nom,Eleves.ElevID,Activites.ActID,Eleves.ClassID
    FROM Repartition,Activites,Eleves WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID;
 
SELECT GROUP_CONCAT(DISTINCT(X.nom)) AS X,GROUP_CONCAT(DISTINCT(Y.nom)) AS Y -- Write GROUP_CONCAT(DISTINCT(Z.nom)) because Z.nom does not work. Student of different class different can have differents activity in commun so there are 2 or + row for them
FROM Temp AS X,Temp AS Y -- duplicate the class crated
WHERE X.ElevID<Y.ElevID AND X.ClassID!=Y.ClassID AND X.ActID=Y.ActID -- choise X.ElevID<Y.ElevID to don't have XY and YX in liste than choice just studants with same activite and not same class
GROUP BY X.ElevID,Y.ElevID; 

DROP TABLE IF EXISTS Temp;


--  "------------------ QUESTION 17 ------------------"
SELECT Nb_per_couple.ActID, Nb_per_couple.ClassID
FROM ( -- 2 subqueries to construct useful tables
    SELECT Activites.ActID, Eleves.ClassID, COUNT(Eleves.ElevID) AS Nb_eleves
    FROM Activites, Repartition, Eleves
    WHERE Activites.ActID=Repartition.ActID AND Repartition.ElevID=Eleves.ElevID
    GROUP BY Activites.ActID, Eleves.ClassID) AS Nb_per_couple, ( -- first, create a table with the number of student per couple(activity,class)
    SELECT Eleves.ClassID, COUNT(Eleves.ElevID) AS Nb_eleves
    FROM Eleves
    GROUP BY Eleves.ClassID) AS Nb_per_class -- then, create a table with the number of student per class
WHERE Nb_per_couple.ClassID=Nb_per_class.ClassID AND Nb_per_couple.Nb_eleves=Nb_per_class.Nb_eleves; -- finally, join on the ClassID and the couple must have the same number of students as the number of students of its class

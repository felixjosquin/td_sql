DROP TABLE IF EXISTS `Eleve`;
CREATE TABLE IF NOT EXISTS `Eleve` (
  `elevID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `age` int(10) NOT NULL,
  `ville` varchar(100) NOT NULL,
  `classe_id` int(10) NOT NULL,
  PRIMARY KEY (`elevID`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;


INSERT INTO `Eleve` (`elevID`, `nom`, `age`, `ville`, `classe_id`) VALUES
(1, 'Enzo', 21,'LoveTown',1),
(2, 'Ines', 20,'LoveTown',4),
(3, 'Valentin',22, 'Buvilly', 2),
(4, 'Gustave', 22, 'Marseille', 2),
(5, 'Emilien',23, 'Toulouse', 3),
(6, 'Olivier', 20, 'Lugagnac', 4),
(7, 'Felix', 21, 'Avignon', 1),
(8, 'Maurice', 21, 'Villemareuil', 2),
(9, 'Manon', 23, 'Saint-Etienne', 1),
(10, 'Joachim', 20, 'Marseille', 3),
(11, 'Muriel', 24, 'Paris', 3),
(12, 'Christiane',25 , 'Les Abrets', 4),
(13, 'Jacinthe', 22, 'Toulouse', 2),
(14, 'Mbappe', 21,'Paris', 1),
(15, 'Antoine', 25, 'Epinal', 5),
(16, 'Zidane', 23, 'Marseille', 3),
(17, 'Patrick', 24, 'Nancy', 1),
(18, 'Messi', 20, 'Paris', 1),
(19, 'Payet', 21, 'Marseille', 5),
(20, 'Neymar', 23,'Rio', 2),
(21, 'Lucas', 20, 'Coulgens', 4),
(22, 'Firmin', 22,'Lyon', 3),
(23, 'Felix', 21, 'Trecon',2),
(24, 'Lucie', 20, 'Montcuq', 1);

DROP TABLE IF EXISTS `Classes`;
CREATE TABLE IF NOT EXISTS `Classes` (
  `classe_id` int(10) NOT NULL,
  `enseignant` varchar(100) NOT NULL,
  PRIMARY KEY (`classe_id`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;


INSERT INTO `Classes` (`classe_id`, `enseignant`) VALUES
(1, 'Payre'),
(2, 'Pierre-Etienne'),
(3, 'Mesh'),
(4, 'Pierre'),
(5, 'Benmouffek');

DROP TABLE IF EXISTS `Activite`;
CREATE TABLE IF NOT EXISTS `Activite` (
  `actID` int(10) NOT NULL,
  `lieu` varchar(100) NOT NULL,
  `bus` int(10) NOT NULL,
  `theme` varchar(100) NOT NULL,
  `jour` int(10) NOT NULL,
  PRIMARY KEY (`actID`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

INSERT INTO `Activite` (`actID`, `lieu`,`bus`,`theme`,`jour`) VALUES
(1,'Paris',3,'tennis',2),
(2,'Marseille',4,'foot',2),
(3,'Toulouse',3,'echec',3),
(4,'Paris',1,'babyfoot',4),
(5,'Epinal',5,'golf',1),
(6,'Marseille',3,'ping-pong',2),
(7,'Paris',4,'gym',1),
(8,'Epinal',2,'rudby',3),
(9,'Paris',4,'hand',5),
(10,'Toulouse',3,'course',5),
(11,'Paris',1,'foot_salle',2),
(12,'Marseille',1,'volley',1),
(13,'Epinal',2,'trail',3),
(14,'Paris',4,'badminton',2);

DROP TABLE IF EXISTS `Repartition`;
CREATE TABLE IF NOT EXISTS `Repartition` (
  `elevID` int(10) NOT NULL,
  `actID` int(100) NOT NULL,
  PRIMARY KEY (`elevID`,`actID`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

INSERT INTO `Repartition` (`elevID`, `actID`) VALUES
(17,14),
(3,5),
(7,8),
(12,6),
(1,3),
(2,9),
(4,2),
(2,13),
(22,1),
(5,7),
(15,3),
(11,8),
(2,11),
(9,13),
(4,12),
(10,11),
(3,4),
(8,5),
(3,8),
(1,1),
(21,6),
(16,6),
(7,7),
(19,3),
(18,7),
(4,3),
(13,2),
(21,5),
(18,6),
(6,12),
(6,3),
(5,1),
(11,10),
(22,11),
(8,9),
(9,6),
(19,13),
(17,4),
(7,10),
(13,6),
(8,7),
(10,6),
(3,3),
(1,11),
(18,9),
(21,10),
(2,3),
(8,13),
(13,14),
(16,5),
(6,4),
(7,5),
(14,9),
(3,9),
(12,2),
(3,12),
(20,7),
(3,11),
(17,8),
(10,14),
(13,7),
(5,3),
(19,9),
(7,2),
(7,9),
(11,5),
(19,6),
(13,9),
(12,10),
(13,3),
(20,13),
(14,6),
(16,9),
(17,5),
(1,9),
(13,8),
(22,10),
(3,2),
(8,14),
(1,14),
(19,1),
(2,8),
(19,8),
(15,13),
(5,5),
(9,12),
(14,4),
(8,1),
(1,8),
(9,7),
(7,11),
(5,4),
(12,4),
(22,12),
(11,9),
(15,5),
(1,4),
(3,10),
(6,2),
(2,7);
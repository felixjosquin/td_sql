DROP TABLE IF EXISTS `Eleve`;
CREATE TABLE IF NOT EXISTS `Eleve` (
  `elevID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `age` int(10) NOT NULL,
  `ville` varchar(100) NOT NULL,
  `classe_id` int(10) NOT NULL,
  PRIMARY KEY (`elevID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Classes`;
CREATE TABLE IF NOT EXISTS `Classes` (
  `classe_id` int(10) NOT NULL,
  `enseignant` varchar(100) NOT NULL,
  PRIMARY KEY (`classe_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Activite`;
CREATE TABLE IF NOT EXISTS `Activite` (
  `actID` int(10) NOT NULL,
  `lieu` varchar(100) NOT NULL,
  `bus` int(10) NOT NULL,
  `theme` varchar(100) NOT NULL,
  `jour` int(10) NOT NULL,
  PRIMARY KEY (`actID`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Repartition`;
CREATE TABLE IF NOT EXISTS `Repartition` (
  `elevID` int(10) NOT NULL,
  `actID` int(100) NOT NULL,
  PRIMARY KEY (`elevID`,`actID`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
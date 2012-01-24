package microbe.vo;

/// requiert deux bases de données taxo et tagSpod

//gaffe à pas mettre de cle primaire
/*CREATE TABLE `tagSpod` (
  `tag_id` int(11) DEFAULT NULL,
  `spod_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;*/

/*CREATE TABLE `taxo` (
  `taxo_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) NOT NULL,
  `spodtype` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`taxo_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;*/


interface Taggable
{
function getTags():List<String>;

}
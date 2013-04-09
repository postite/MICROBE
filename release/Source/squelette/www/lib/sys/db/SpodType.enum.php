<?php

class sys_db_SpodType extends Enum {
	public static $DBigId;
	public static $DBigInt;
	public static $DBinary;
	public static $DBool;
	public static function DBytes($n) { return new sys_db_SpodType("DBytes", 19, array($n)); }
	public static $DDate;
	public static $DDateTime;
	public static $DEncoded;
	public static function DFlags($flags, $autoSize) { return new sys_db_SpodType("DFlags", 23, array($flags, $autoSize)); }
	public static $DFloat;
	public static $DId;
	public static $DInt;
	public static $DInterval;
	public static $DLongBinary;
	public static $DMediumInt;
	public static $DMediumUInt;
	public static $DNekoSerialized;
	public static $DNull;
	public static $DSerialized;
	public static $DSingle;
	public static $DSmallBinary;
	public static $DSmallInt;
	public static $DSmallText;
	public static $DSmallUInt;
	public static function DString($n) { return new sys_db_SpodType("DString", 9, array($n)); }
	public static $DText;
	public static $DTimeStamp;
	public static $DTinyInt;
	public static $DTinyText;
	public static $DTinyUInt;
	public static $DUId;
	public static $DUInt;
	public static $__constructors = array(4 => 'DBigId', 5 => 'DBigInt', 18 => 'DBinary', 8 => 'DBool', 19 => 'DBytes', 10 => 'DDate', 11 => 'DDateTime', 20 => 'DEncoded', 23 => 'DFlags', 7 => 'DFloat', 0 => 'DId', 1 => 'DInt', 30 => 'DInterval', 17 => 'DLongBinary', 28 => 'DMediumInt', 29 => 'DMediumUInt', 22 => 'DNekoSerialized', 31 => 'DNull', 21 => 'DSerialized', 6 => 'DSingle', 16 => 'DSmallBinary', 26 => 'DSmallInt', 14 => 'DSmallText', 27 => 'DSmallUInt', 9 => 'DString', 15 => 'DText', 12 => 'DTimeStamp', 24 => 'DTinyInt', 13 => 'DTinyText', 25 => 'DTinyUInt', 2 => 'DUId', 3 => 'DUInt');
	}
sys_db_SpodType::$DBigId = new sys_db_SpodType("DBigId", 4);
sys_db_SpodType::$DBigInt = new sys_db_SpodType("DBigInt", 5);
sys_db_SpodType::$DBinary = new sys_db_SpodType("DBinary", 18);
sys_db_SpodType::$DBool = new sys_db_SpodType("DBool", 8);
sys_db_SpodType::$DDate = new sys_db_SpodType("DDate", 10);
sys_db_SpodType::$DDateTime = new sys_db_SpodType("DDateTime", 11);
sys_db_SpodType::$DEncoded = new sys_db_SpodType("DEncoded", 20);
sys_db_SpodType::$DFloat = new sys_db_SpodType("DFloat", 7);
sys_db_SpodType::$DId = new sys_db_SpodType("DId", 0);
sys_db_SpodType::$DInt = new sys_db_SpodType("DInt", 1);
sys_db_SpodType::$DInterval = new sys_db_SpodType("DInterval", 30);
sys_db_SpodType::$DLongBinary = new sys_db_SpodType("DLongBinary", 17);
sys_db_SpodType::$DMediumInt = new sys_db_SpodType("DMediumInt", 28);
sys_db_SpodType::$DMediumUInt = new sys_db_SpodType("DMediumUInt", 29);
sys_db_SpodType::$DNekoSerialized = new sys_db_SpodType("DNekoSerialized", 22);
sys_db_SpodType::$DNull = new sys_db_SpodType("DNull", 31);
sys_db_SpodType::$DSerialized = new sys_db_SpodType("DSerialized", 21);
sys_db_SpodType::$DSingle = new sys_db_SpodType("DSingle", 6);
sys_db_SpodType::$DSmallBinary = new sys_db_SpodType("DSmallBinary", 16);
sys_db_SpodType::$DSmallInt = new sys_db_SpodType("DSmallInt", 26);
sys_db_SpodType::$DSmallText = new sys_db_SpodType("DSmallText", 14);
sys_db_SpodType::$DSmallUInt = new sys_db_SpodType("DSmallUInt", 27);
sys_db_SpodType::$DText = new sys_db_SpodType("DText", 15);
sys_db_SpodType::$DTimeStamp = new sys_db_SpodType("DTimeStamp", 12);
sys_db_SpodType::$DTinyInt = new sys_db_SpodType("DTinyInt", 24);
sys_db_SpodType::$DTinyText = new sys_db_SpodType("DTinyText", 13);
sys_db_SpodType::$DTinyUInt = new sys_db_SpodType("DTinyUInt", 25);
sys_db_SpodType::$DUId = new sys_db_SpodType("DUId", 2);
sys_db_SpodType::$DUInt = new sys_db_SpodType("DUInt", 3);

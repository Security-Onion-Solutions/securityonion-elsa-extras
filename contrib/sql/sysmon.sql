/*  v. 2/8/15 --- Copyright (c) 2015 Josh Brower, Josh@DefensiveDepth.com */

use syslog;

/*  Creates SYSMON_PROCESS Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10778, "SYSMON_PROCESS");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("processguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("image","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hash","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("parentimage","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="processguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="user"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="hash"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESS"), (SELECT id FROM fields WHERE field="parentimage"), 16);


/*  Creates SYSMON_NETWORK Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10779, "SYSMON_NETWORK");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("initiated","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("destip","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("sourceport","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("destport","string", "QSTRING");
	
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="processguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="user"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="initiated"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="destip"), 16);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="sourceport"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_NETWORK"), (SELECT id FROM fields WHERE field="destport"), 6);


/*  Creates SYSMON_REMOTETHREAD Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10777, "SYSMON_REMOTETHREAD");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("sourceprocessguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("sourceimage","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("targetprocessguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("targetimage","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("startmodule","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="sourceprocessguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="sourceimage"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="targetprocessguid"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="targetimage"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_REMOTETHREAD"), (SELECT id FROM fields WHERE field="startmodule"), 16);


/* ---- https://github.com/jtaylo78/Sysmon_ELSA_Parsers/edit/master/sysmon.sql 10782-10787 ----- */

/*  Creates SYSMON_IMAGE Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10782, "SYSMON_IMAGE");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("processguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("image","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("imageloaded","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hash","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("signed","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="processguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="imageloaded"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="hash"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_IMAGE"), (SELECT id FROM fields WHERE field="signed"), 16);


/*  Creates SYSMON_FILECREATE Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10783, "SYSMON_FILECREATE");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("processguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("image","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("targetfilename","string", "QSTRING");


INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_FILECREATE"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_FILECREATE"), (SELECT id FROM fields WHERE field="processguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_FILECREATE"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_FILECREATE"), (SELECT id FROM fields WHERE field="targetfilename"), 14);



/*  Creates SYSMON_DRIVERLOADED Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10785, "SYSMON_DRIVERLOADED");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("imageloaded","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hash","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("signed","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("signature","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_DRIVERLOADED"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_DRIVERLOADED"), (SELECT id FROM fields WHERE field="imageloaded"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_DRIVERLOADED"), (SELECT id FROM fields WHERE field="hash"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_DRIVERLOADED"), (SELECT id FROM fields WHERE field="signed"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_DRIVERLOADED"), (SELECT id FROM fields WHERE field="signature"), 15);

/*  Creates SYSMON_RAWACCESS Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10786, "SYSMON_RAWACCESS");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("processguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("image","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("device","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_RAWACCESS"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_RAWACCESS"), (SELECT id FROM fields WHERE field="processguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_RAWACCESS"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_RAWACCESS"), (SELECT id FROM fields WHERE field="device"), 14);

/*  Creates SYSMON_PROCESSACCESS Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10787, "SYSMON_PROCESSACCESS");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("hostname","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("sourceprocessguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("sourceimage","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("targetprocessguid","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("targetimage","string", "QSTRING");


INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESSACCESS"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESSACCESS"), (SELECT id FROM fields WHERE field="sourceprocessguid"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESSACCESS"), (SELECT id FROM fields WHERE field="sourceimage"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESSACCESS"), (SELECT id FROM fields WHERE field="targetprocessguid"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SYSMON_PROCESSACCESS"), (SELECT id FROM fields WHERE field="targetimage"), 15);

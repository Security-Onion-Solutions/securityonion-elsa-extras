/*  v. 2/8/15 --- Copyright (c) 2015 Josh Brower, Josh@DefensiveDepth.com */

use syslog;

/*  Creates WINDOWS_PROCESS Class & associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (10780, "WINDOWS_PROCESS");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("token-elevation","string", "QSTRING");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS_PROCESS"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS_PROCESS"), (SELECT id FROM fields WHERE field="user"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS_PROCESS"), (SELECT id FROM fields WHERE field="image"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS_PROCESS"), (SELECT id FROM fields WHERE field="token-elevation"), 14);
use syslog;

/*  Create class */
INSERT IGNORE INTO classes (id, class) VALUES (26013, "BRO_MYSQL");

/*  Add new fields */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("cmd","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("success","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("rows","integer", "QSTRING");

/*  Map integer fields */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="rows"), 9);

/*  Map string fields */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="cmd"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="arg"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="success"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_MYSQL"), (SELECT id FROM fields WHERE field="response"), 14);

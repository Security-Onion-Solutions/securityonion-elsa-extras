/* 10/11/2016 --- Brian Kellogg */
use syslog;

/* Create CISCO_BOTNET ELSA class and all its associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (12002, "CISCO_BOTNET");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="proto"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="srcip"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="srcport"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="dstip"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="dstport"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="sig_classification"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_BOTNET"), (SELECT id FROM fields WHERE field="indicator"), 13);

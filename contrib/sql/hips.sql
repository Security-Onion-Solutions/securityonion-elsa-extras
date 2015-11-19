/* v. 11/15/2015 --- Brian Kellogg */
use syslog;

/* Create HIPS ELSA class and all its associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (12000, "HIPS");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="proto"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="total_bytes"), 10);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="hostname"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="user"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="parentimage"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="image"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="indicator"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="HIPS"), (SELECT id FROM fields WHERE field="hash"), 16);

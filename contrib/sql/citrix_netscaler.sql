/* v. 3/22/2016 --- Brian Kellogg */
use syslog;

/* Create CITRIX_NETSCALER ELSA class and all its associated fields */
INSERT IGNORE INTO classes (id, class) VALUES (12001, "CITRIX_NETSCALER");

INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("session_id","int", "NUMBER");

INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="dstip"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="dstport"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="session_id"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="bytes_in"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="bytes_out"), 10);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="user"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="type"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="site"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="method"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="uri"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CITRIX_NETSCALER"), (SELECT id FROM fields WHERE field="user_agent"), 16);

// Create keyspace part
CREATE KEYSPACE IF NOT EXISTS {{.Keyspace}}
    WITH REPLICATION = {
        'class': '{{.Strategy}}',
        'replication_factor': {{.Replication}}
    } AND DURABLE_WRITES = true;

// Create table part
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.events (
    tsp   timestamp,     // timestamp for partition key
    uid   timeuuid,      // time based uuid
    did   ascii,         // data id the of the data
    data  blob,          // data
PRIMARY KEY (tsp, uid))
    WITH CLUSTERING ORDER BY (uid DESC);

// uid table to get the uidm using uid
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.uid (
    uid  timeuuid,       // time based UUID of the input event
    uidm timeuuid,       // time based UUID of the merkle tree event
PRIMARY KEY (uid));

// mapping table to get the root hash and fingerprint using root uuid
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.fp (
    uid  timeuuid,       // time based UUID of the input root
    root ascii,          // input root hash
    fpr  ascii,          // fingerprint from external anchor provider
    pvdr ascii,          // fingerprint provider name
PRIMARY KEY (uid));

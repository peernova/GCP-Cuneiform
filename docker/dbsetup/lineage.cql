// Create lineage keyspace
CREATE KEYSPACE IF NOT EXISTS {{.Keyspace}}
    WITH REPLICATION = {
        'class': '{{.Strategy}}',
        'replication_factor': {{.Replication}}
    } AND DURABLE_WRITES = true;

// Create link type
CREATE TYPE IF NOT EXISTS {{.Keyspace}}.link (
	id text,
	edge text,
	edge_source text,
	tags frozen<set<text>>,
	category text
);

// Create links table
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.links(
	id text PRIMARY KEY, // hash
	type text,
	links set<frozen <link>>,
	attributes map<text, text>
);

// Create schema categories table
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.schema_categories(
	schema_cat text PRIMARY KEY, // schema is a keyword in cassandra, so use schema_cat instead
	categories set<text>
);

// Create edge sources table
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.edge_sources(
	id text PRIMARY KEY, // hash of rule
	rule text,
	ldl_name text
);

// Create event_data table for duplicate messages
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.event_data(
	event_id text PRIMARY KEY,
	data_id text
);

// Create a secondary index on event_data
CREATE INDEX IF NOT EXISTS eventIndex on {{.Keyspace}}.event_data(data_id);

// Create rules table
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.rules(
	id text PRIMARY KEY, // hash of rule
	schema_category text,
	parser text,
	active boolean,
	script text,
	ldl_name text);

// Create raw ldl table
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.ldls(
	id text PRIMARY KEY,
	raw_ldl text,
	active boolean);

// Create a secondary indexes on the table
CREATE INDEX IF NOT EXISTS rule_schema_category ON {{.Keyspace}}.rules (schema_category);

// Create a secondary indexes on the table
CREATE INDEX IF NOT EXISTS rule_ldl_name ON {{.Keyspace}}.rules (ldl_name);

// Create sandboxes store
CREATE TABLE IF NOT EXISTS {{.Keyspace}}.sandboxes(
   	id text PRIMARY KEY,
    type text,
   	data text,
    ldl text,
    category text,
    hash text,
    ts timestamp
);

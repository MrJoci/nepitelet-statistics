# + rows: table name
# \t rows: columns
+brands
	id - INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
	name - VARCHAR(100) NOT NULL;
	url - TEXT NOT NULL;
+types
	id - INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
	brand_id - INTEGER UNSIGNED NOT NULL;
	name - VARCHAR(100) NOT NULL;
	url - TEXT NOT NULL;
+verdicts
	id - INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
	type_id - INTEGER UNSIGNED NOT NULL;
	name - VARCHAR(100) NOT NULL;
	written_at - DATETIME;
	year_of_build - INTEGER;
	usage_time - INTEGER;
	km_at_buy - INTEGER;
	km_driven - INTEGER;
	consuption - DOUBLE;
	next_car - VARCHAR(100);
	rate - DOUBLE;
	story - TEXT;
	faults - TEXT;
	service_location - TEXT;
	url - TEXT NOT NULL;
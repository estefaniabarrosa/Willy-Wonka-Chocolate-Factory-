CREATE TABLE [Product] (
	[Product_id] int IDENTITY(1,1) NOT NULL UNIQUE,
	[Product_name] nvarchar(max) NOT NULL,
	[Division] nvarchar(max) NOT NULL,
	[Factory] nvarchar(max) NOT NULL,
	[unit_cost] int NOT NULL,
	PRIMARY KEY ([Product_id])
);

CREATE TABLE [Customer] (
	[customer_id] int IDENTITY(1,1) NOT NULL UNIQUE,
	PRIMARY KEY ([customer_id])
);

CREATE TABLE [Location] (
	[location_id_PK] int IDENTITY(1,1) NOT NULL UNIQUE,
	[country_region] nvarchar(max) NOT NULL,
	[region] nvarchar(max) NOT NULL,
	[state_province] nvarchar(max) NOT NULL,
	[city] nvarchar(max) NOT NULL,
	[postal_code] nvarchar(max) NOT NULL,
	[latitude] decimal(18,0) NOT NULL,
	[longitude] decimal(18,0) NOT NULL,
	PRIMARY KEY ([location_id_PK])
);

CREATE TABLE [Orders] (
	[order_id] int IDENTITY(1,1) NOT NULL UNIQUE,
	[order_date] date NOT NULL,
	[ship_date] date NOT NULL,
	[customer_id] int NOT NULL,
	[Product_id] int NOT NULL,
	[location_id] int NOT NULL,
	[sales] int NOT NULL,
	[units] int NOT NULL,
	[gross_profit] int NOT NULL,
	[cost] int NOT NULL,
	PRIMARY KEY ([order_id])
);




ALTER TABLE [Orders] ADD CONSTRAINT [Orders_fk3] FOREIGN KEY ([customer_id]) REFERENCES [Customer]([customer_id]);

ALTER TABLE [Orders] ADD CONSTRAINT [Orders_fk4] FOREIGN KEY ([Product_id]) REFERENCES [Product]([Product_id]);

ALTER TABLE [Orders] ADD CONSTRAINT [Orders_fk5] FOREIGN KEY ([location_id]) REFERENCES [Location]([location_id_PK]);
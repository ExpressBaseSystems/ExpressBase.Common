--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;



SET default_tablespace = '';

SET default_with_oids = false;


---
--- drop tables
---


DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS shippers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS purchase_details;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id serial  ,
    category_name character varying(15) ,
    description text,
    picture bytea,
	eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer
); 
 
--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
	id serial, 
    customer_id bpchar unique ,
    company_name character varying(40) ,
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    CONSTRAINT customers_customer_id_key UNIQUE (customer_id)
);


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees (
    id serial ,
    last_name character varying(20) ,
    first_name character varying(10) ,
    title character varying(30),
    title_of_courtesy character varying(25),
    birth_date date,
    hire_date date,
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    home_phone character varying(24),
    extension character varying(4),
    photo bytea,
    notes text,
    reports_to smallint,
    photo_path character varying(255),
	eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer
);
  
--
-- Name: order_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_details (
	id serial,
    orders_id smallint ,
    product_id smallint ,
    unit_price real ,
    quantity smallint ,
    discount real,
	eb_row_num numeric,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    amount numeric
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
   id serial,
    customer_id bpchar,
    employee_id smallint,
    order_date date,
    required_date date,
    shipped_date date,
    ship_via smallint,
    freight real,
    ship_name character varying(40),
    ship_address character varying(60),
    ship_city character varying(15),
    ship_region character varying(15),
    ship_postal_code character varying(10),
    ship_country character varying(15),
    order_id text ,
    order_id_ebbkup text ,
    shipping_location text ,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    eb_ver_id numeric,
    order_value numeric
); 

--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id serial ,
    product_name character varying(40) ,
    supplier_id smallint,
    category_id smallint,
    quantity_per_unit character varying(20),
    unit_price real,
    units_in_stock smallint,
    units_on_order smallint,
    reorder_level smallint,
    discontinued integer,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    eb_ver_id numeric	
);

--
-- Name: shippers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shippers (
    id serial ,
    company_name character varying(40) ,
    phone character varying(24),
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer
);

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suppliers (
    id serial ,
    company_name character varying(40),
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    homepage text,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer
);

 CREATE TABLE purchases
(
    id serial,
    purchase_id text,
    purchase_id_ebbkup text,
    purchase_date date,
    suppliers_id numeric,
    freight numeric,
    employee_id numeric,
    payment_amt numeric,
    eb_ver_id numeric,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    CONSTRAINT purchases_pkey PRIMARY KEY (id)
);

CREATE TABLE purchase_details
(
    id serial,
    product_id numeric,
    unit_price numeric,
    quantity numeric,
    amount numeric,
    purchases_id numeric,
    eb_row_num numeric,
    eb_created_by numeric,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by numeric,
    eb_lastmodified_at timestamp without time zone,
    eb_del character(1),
    eb_void character(1),
    eb_loc_id integer,
    CONSTRAINT purchase_details_pkey PRIMARY KEY (id)
);

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
-- 
INSERT INTO categories VALUES (2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings', '\x', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO categories VALUES (3, 'Confections', 'Desserts, candies, and sweet breads', '\x', NULL, NULL, 2, '2019-08-08 05:51:58.872412', 'F', 'F', 1);
INSERT INTO categories VALUES (1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales', '\x', NULL, NULL, 2, '2019-08-08 05:53:40.302094', 'F', 'F', 1);
INSERT INTO categories VALUES (4, 'Dairy Products', 'Cheeses', '\x', NULL, NULL, 2, '2019-08-08 05:54:45.927662', 'F', 'F', 1);
INSERT INTO categories VALUES (5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal', '\x', NULL, NULL, 2, '2019-08-08 05:56:53.176807', 'F', 'F', 1);
INSERT INTO categories VALUES (6, 'Meat/Poultry', 'Prepared meats', '\x', NULL, NULL, 2, '2019-08-08 05:58:26.045689', 'F', 'F', 1);
INSERT INTO categories VALUES (7, 'Produce', 'Dried fruit and bean curd', '\x', NULL, NULL, 2, '2019-08-08 05:59:51.117994', 'F', 'F', 1);
INSERT INTO categories VALUES (9, 'Bakery', 'Sweets, Snacks', NULL, 2, '2019-08-08 05:27:02.725495', NULL, NULL, 'F', 'F', 6);
INSERT INTO categories VALUES (10, 'Snacks', 'Samoosa', NULL, 2, '2019-10-02 05:43:53.102638', NULL, NULL, 'F', 'F', 6);
INSERT INTO categories VALUES (8, 'Seafood', 'Seaweed and fishes', '\x', NULL, NULL, 2, '2019-10-02 07:31:19.65964', 'F', 'F', 1);
 
--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--
INSERT INTO customers VALUES (96, 'GINRM', 'Ginger Mumbai, Andheri', 'Mr. John Kenedy', 'Manager', ' Mahakali Caves Rd', 'Mumbai', NULL, '400093', 'India', '2266666333', '22-6666-6333', 2, '2019-08-21 05:08:10.939874', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (92, 'KLNS', 'Kalyan ', 'T.S. Pattabhiraman', 'Key People', 'Chembukavu', 'Thrissur', NULL, '123485', 'India', '04560205140', '94852-04585', 2, '2019-08-06 10:53:43.669511', 2, '2019-08-21 05:55:59.1599', 'F', 'F', 6);
INSERT INTO customers VALUES (99, 'ATLNT', 'Atlanta', 'Mr.Johanan John', 'Managing Director', '7971, Arakashan Rd', 'New Delhi', NULL, '110055', 'India', '1143008648', '123-147-88', 2, '2019-08-21 06:19:46.943502', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (97, 'FABHS', 'FabHotel Sahar Garden Marol', 'Vinod Patil', 'Supervisor', 'metro stn, Marol Maroshi Rd', 'Mumbai', NULL, '400059', 'India', '7042424242', '3333-24-24242', 2, '2019-08-21 05:40:45.441296', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (98, 'AMXIN', 'Amax Inn', 'Mr.Pangj', 'Supervisor', '8145/6, Arakashan Road', 'New Delhi', NULL, '110055', 'India', '9811272629', ' 011- 43685742', 2, '2019-08-21 06:04:04.369662', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (100, 'RADSN', 'Radisson ', 'Mr.Raddison ', 'Managing Director', 'Cantonment Rd, Kaiserbagh Officer''s Colony', 'Lucknow', NULL, '226001', 'India', '5224299999', '522- 429-9999', 2, '2019-08-21 06:25:22.903795', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (48, 'LONEP', 'Lonesome Pine Restaurant', 'Fran Wilson', 'Sales Manager', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', '(503) 555-9573', '(503) 555-9646', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (93, 'SRMHL', 'Sree Mahalakshmi Food Industries', 'Mr. George Varghese', 'managing director', '18/1348, Palluruthy', 'Kochi', NULL, ' 682006', 'India', '90371 02581', '91 - 11 - 46710500', 2, '2019-08-19 03:54:47.677017', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (94, 'CAMEM', 'Camilo Mendid Mellow ', 'Mr Vinod', 'Proprietor', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', NULL, '682306', 'India', '99469 95544', '484-6468778', 2, '2019-08-19 04:08:10.619817', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (95, 'CANNG', 'CANNING INDUSTRIES COCHIN LTD.', 'Mr. Alex Ittycheriah', 'Chief Executive', 'Kochi Mg Road', 'Kochi', NULL, '682016', 'India', '0487-2442036', '487-2442036', 2, '2019-08-19 04:18:53.273626', NULL, NULL, 'F', 'F', 6);
INSERT INTO customers VALUES (1, 'ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321', '030-0076545', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (2, 'ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', '(5) 555-4729', '(5) 555-3745', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (3, 'ANTON', 'Antonio Moreno Taquería', 'Antonio Moreno', 'Owner', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', '(5) 555-3932', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (4, 'AROUT', 'Around the Horn', 'Thomas Hardy', 'Sales Representative', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK', '(171) 555-7788', '(171) 555-6750', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (5, 'BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', '0921-12 34 65', '0921-12 34 67', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (6, 'BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Representative', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', '0621-08460', '0621-08924', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (7, 'BLONP', 'Blondesddsl père et fils', 'Frédérique Citeaux', 'Marketing Manager', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', '88.60.15.31', '88.60.15.32', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (8, 'BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Owner', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain', '(91) 555 22 82', '(91) 555 91 99', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (9, 'BONAP', 'Bon app''', 'Laurence Lebihan', 'Owner', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', '91.24.45.40', '91.24.45.41', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (10, 'BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Accounting Manager', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', '(604) 555-4729', '(604) 555-3745', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (11, 'BSBEV', 'B''s Beverages', 'Victoria Ashworth', 'Sales Representative', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', '(171) 555-1212', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (12, 'CACTU', 'Cactus Comidas para llevar', 'Patricio Simpson', 'Sales Agent', 'Cerrito 333', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 135-5555', '(1) 135-4892', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (13, 'CENTC', 'Centro comercial Moctezuma', 'Francisco Chang', 'Marketing Manager', 'Sierras de Granada 9993', 'México D.F.', NULL, '05022', 'Mexico', '(5) 555-3392', '(5) 555-7293', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (14, 'CHOPS', 'Chop-suey Chinese', 'Yang Wang', 'Owner', 'Hauptstr. 29', 'Bern', NULL, '3012', 'Switzerland', '0452-076545', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (15, 'COMMI', 'Comércio Mineiro', 'Pedro Afonso', 'Sales Associate', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', '(11) 555-7647', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (16, 'CONSH', 'Consolidated Holdings', 'Elizabeth Brown', 'Sales Representative', 'Berkeley Gardens 12  Brewery', 'London', NULL, 'WX1 6LT', 'UK', '(171) 555-2282', '(171) 555-9199', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (17, 'DRACD', 'Drachenblut Delikatessen', 'Sven Ottlieb', 'Order Administrator', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', '0241-039123', '0241-059428', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (18, 'DUMON', 'Du monde entier', 'Janine Labrune', 'Owner', '67, rue des Cinquante Otages', 'Nantes', NULL, '44000', 'France', '40.67.88.88', '40.67.89.89', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (19, 'EASTC', 'Eastern Connection', 'Ann Devon', 'Sales Agent', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', '(171) 555-0297', '(171) 555-3373', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (20, 'ERNSH', 'Ernst Handel', 'Roland Mendel', 'Sales Manager', 'Kirchgasse 6', 'Graz', NULL, '8010', 'Austria', '7675-3425', '7675-3426', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (21, 'FAMIA', 'Familia Arquibaldo', 'Aria Cruz', 'Marketing Assistant', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', '(11) 555-9857', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (22, 'FISSA', 'FISSA Fabrica Inter. Salchichas S.A.', 'Diego Roel', 'Accounting Manager', 'C/ Moralzarzal, 86', 'Madrid', NULL, '28034', 'Spain', '(91) 555 94 44', '(91) 555 55 93', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (23, 'FOLIG', 'Folies gourmandes', 'Martine Rancé', 'Assistant Sales Agent', '184, chaussée de Tournai', 'Lille', NULL, '59000', 'France', '20.16.10.16', '20.16.10.17', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (24, 'FOLKO', 'Folk och fä HB', 'Maria Larsson', 'Owner', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', '0695-34 67 21', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (25, 'FRANK', 'Frankenversand', 'Peter Franken', 'Marketing Manager', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', '089-0877310', '089-0877451', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (26, 'FRANR', 'France restauration', 'Carine Schmitt', 'Marketing Manager', '54, rue Royale', 'Nantes', NULL, '44000', 'France', '40.32.21.21', '40.32.21.20', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (27, 'FRANS', 'Franchi S.p.A.', 'Paolo Accorti', 'Sales Representative', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', '011-4988260', '011-4988261', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (28, 'FURIB', 'Furia Bacalhau e Frutos do Mar', 'Lino Rodriguez', 'Sales Manager', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', '(1) 354-2534', '(1) 354-2535', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (29, 'GALED', 'Galería del gastrónomo', 'Eduardo Saavedra', 'Marketing Manager', 'Rambla de Cataluña, 23', 'Barcelona', NULL, '08022', 'Spain', '(93) 203 4560', '(93) 203 4561', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (30, 'GODOS', 'Godos Cocina Típica', 'José Pedro Freyre', 'Sales Manager', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', '(95) 555 82 82', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (31, 'GOURL', 'Gourmet Lanchonetes', 'André Fonseca', 'Sales Associate', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', '(11) 555-9482', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (32, 'GREAL', 'Great Lakes Food Market', 'Howard Snyder', 'Marketing Manager', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', '(503) 555-7555', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (33, 'GROSR', 'GROSELLA-Restaurante', 'Manuel Pereira', 'Owner', '5ª Ave. Los Palos Grandes', 'Caracas', 'DF', '1081', 'Venezuela', '(2) 283-2951', '(2) 283-3397', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (34, 'HANAR', 'Hanari Carnes', 'Mario Pontes', 'Accounting Manager', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', '(21) 555-0091', '(21) 555-8765', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (35, 'HILAA', 'HILARION-Abastos', 'Carlos Hernández', 'Sales Representative', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', '(5) 555-1340', '(5) 555-1948', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (36, 'HUNGC', 'Hungry Coyote Import Store', 'Yoshi Latimer', 'Sales Representative', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', '(503) 555-6874', '(503) 555-2376', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (37, 'HUNGO', 'Hungry Owl All-Night Grocers', 'Patricia McKenna', 'Sales Associate', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', '2967 542', '2967 3333', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (38, 'ISLAT', 'Island Trading', 'Helen Bennett', 'Marketing Manager', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', '(198) 555-8888', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (39, 'KOENE', 'Königlich Essen', 'Philip Cramer', 'Sales Associate', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', '0555-09876', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (40, 'LACOR', 'La corne d''abondance', 'Daniel Tonini', 'Sales Representative', '67, avenue de l''Europe', 'Versailles', NULL, '78000', 'France', '30.59.84.10', '30.59.85.11', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (41, 'LAMAI', 'La maison d''Asie', 'Annette Roulet', 'Sales Manager', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', '61.77.61.10', '61.77.61.11', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (42, 'LAUGB', 'Laughing Bacchus Wine Cellars', 'Yoshi Tannamuri', 'Marketing Assistant', '1900 Oak St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada', '(604) 555-3392', '(604) 555-7293', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (43, 'LAZYK', 'Lazy K Kountry Store', 'John Steel', 'Marketing Manager', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', 'USA', '(509) 555-7969', '(509) 555-6221', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (44, 'LEHMS', 'Lehmanns Marktstand', 'Renate Messner', 'Sales Representative', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', '069-0245984', '069-0245874', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (45, 'LETSS', 'Let''s Stop N Shop', 'Jaime Yorres', 'Owner', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', '(415) 555-5938', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (46, 'LILAS', 'LILA-Supermercado', 'Carlos González', 'Accounting Manager', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', '(9) 331-6954', '(9) 331-7256', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (47, 'LINOD', 'LINO-Delicateses', 'Felipe Izquierdo', 'Owner', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', '(8) 34-56-12', '(8) 34-93-93', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (49, 'MAGAA', 'Magazzini Alimentari Riuniti', 'Giovanni Rovelli', 'Marketing Manager', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', '035-640230', '035-640231', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (50, 'MAISD', 'Maison Dewey', 'Catherine Dewey', 'Sales Agent', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', '(02) 201 24 67', '(02) 201 24 68', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (51, 'MEREP', 'Mère Paillarde', 'Jean Fresnière', 'Marketing Assistant', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', '(514) 555-8054', '(514) 555-8055', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (52, 'MORGK', 'Morgenstern Gesundkost', 'Alexander Feuer', 'Marketing Assistant', 'Heerstr. 22', 'Leipzig', NULL, '04179', 'Germany', '0342-023176', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (53, 'NORTS', 'North/South', 'Simon Crowther', 'Sales Associate', 'South House 300 Queensbridge', 'London', NULL, 'SW7 1RZ', 'UK', '(171) 555-7733', '(171) 555-2530', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (54, 'OCEAN', 'Océano Atlántico Ltda.', 'Yvonne Moncada', 'Sales Agent', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 135-5333', '(1) 135-5535', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (55, 'OLDWO', 'Old World Delicatessen', 'Rene Phillips', 'Sales Representative', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', '(907) 555-7584', '(907) 555-2880', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (56, 'OTTIK', 'Ottilies Käseladen', 'Henriette Pfalzheim', 'Owner', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', '0221-0644327', '0221-0765721', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (57, 'PARIS', 'Paris spécialités', 'Marie Bertrand', 'Owner', '265, boulevard Charonne', 'Paris', NULL, '75012', 'France', '(1) 42.34.22.66', '(1) 42.34.22.77', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (58, 'PERIC', 'Pericles Comidas clásicas', 'Guillermo Fernández', 'Sales Representative', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', '(5) 552-3745', '(5) 545-3745', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (59, 'PICCO', 'Piccolo und mehr', 'Georg Pipps', 'Sales Manager', 'Geislweg 14', 'Salzburg', NULL, '5020', 'Austria', '6562-9722', '6562-9723', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (60, 'PRINI', 'Princesa Isabel Vinhos', 'Isabel de Castro', 'Sales Representative', 'Estrada da saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', '(1) 356-5634', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (61, 'QUEDE', 'Que Delícia', 'Bernardo Batista', 'Accounting Manager', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', '(21) 555-4252', '(21) 555-4545', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (62, 'QUEEN', 'Queen Cozinha', 'Lúcia Carvalho', 'Marketing Assistant', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', '(11) 555-1189', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (63, 'QUICK', 'QUICK-Stop', 'Horst Kloss', 'Accounting Manager', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', '0372-035188', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (64, 'RANCH', 'Rancho grande', 'Sergio Gutiérrez', 'Sales Representative', 'Av. del Libertador 900', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 123-5555', '(1) 123-5556', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (65, 'RATTC', 'Rattlesnake Canyon Grocery', 'Paula Wilson', 'Assistant Sales Representative', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', '(505) 555-5939', '(505) 555-3620', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (66, 'REGGC', 'Reggiani Caseifici', 'Maurizio Moroni', 'Sales Associate', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', '0522-556721', '0522-556722', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (67, 'RICAR', 'Ricardo Adocicados', 'Janete Limeira', 'Assistant Sales Agent', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', '(21) 555-3412', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (68, 'RICSU', 'Richter Supermarkt', 'Michael Holz', 'Sales Manager', 'Grenzacherweg 237', 'Genève', NULL, '1203', 'Switzerland', '0897-034214', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (69, 'ROMEY', 'Romero y tomillo', 'Alejandra Camino', 'Accounting Manager', 'Gran Vía, 1', 'Madrid', NULL, '28001', 'Spain', '(91) 745 6200', '(91) 745 6210', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (70, 'SANTG', 'Santé Gourmet', 'Jonas Bergulfsen', 'Owner', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', '07-98 92 35', '07-98 92 47', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (71, 'SAVEA', 'Save-a-lot Markets', 'Jose Pavarotti', 'Sales Representative', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', '(208) 555-8097', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (72, 'SEVES', 'Seven Seas Imports', 'Hari Kumar', 'Sales Manager', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', '(171) 555-1717', '(171) 555-5646', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (73, 'SIMOB', 'Simons bistro', 'Jytte Petersen', 'Owner', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', '31 12 34 56', '31 13 35 57', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (74, 'SPECD', 'Spécialités du monde', 'Dominique Perrier', 'Marketing Manager', '25, rue Lauriston', 'Paris', NULL, '75016', 'France', '(1) 47.55.60.10', '(1) 47.55.60.20', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (75, 'SPLIR', 'Split Rail Beer & Ale', 'Art Braunschweiger', 'Sales Manager', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', '(307) 555-4680', '(307) 555-6525', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (76, 'SUPRD', 'Suprêmes délices', 'Pascale Cartrain', 'Accounting Manager', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', '(071) 23 67 22 20', '(071) 23 67 22 21', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (77, 'THEBI', 'The Big Cheese', 'Liz Nixon', 'Marketing Manager', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', '(503) 555-3612', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (78, 'THECR', 'The Cracker Box', 'Liu Wong', 'Marketing Assistant', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA', '(406) 555-5834', '(406) 555-8083', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (79, 'TOMSP', 'Toms Spezialitäten', 'Karin Josephs', 'Marketing Manager', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', '0251-031259', '0251-035695', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (80, 'TORTU', 'Tortuga Restaurante', 'Miguel Angel Paolino', 'Owner', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', '(5) 555-2933', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (81, 'TRADH', 'Tradição Hipermercados', 'Anabela Domingues', 'Sales Representative', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', '(11) 555-2167', '(11) 555-2168', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (82, 'TRAIH', 'Trail''s Head Gourmet Provisioners', 'Helvetius Nagy', 'Sales Associate', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA', '(206) 555-8257', '(206) 555-2174', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (83, 'VAFFE', 'Vaffeljernet', 'Palle Ibsen', 'Sales Manager', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', '86 21 32 43', '86 22 33 44', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (84, 'VICTE', 'Victuailles en stock', 'Mary Saveley', 'Sales Agent', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', '78.32.54.86', '78.32.54.87', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (85, 'VINET', 'Vins et alcools Chevalier', 'Paul Henriot', 'Accounting Manager', '59 rue de l''Abbaye', 'Reims', NULL, '51100', 'France', '26.47.15.10', '26.47.15.11', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (86, 'WANDK', 'Die Wandernde Kuh', 'Rita Müller', 'Sales Representative', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', '0711-020361', '0711-035428', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (87, 'WARTH', 'Wartian Herkku', 'Pirkko Koskitalo', 'Accounting Manager', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', '981-443655', '981-443655', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (88, 'WELLI', 'Wellington Importadora', 'Paula Parente', 'Sales Manager', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', '(14) 555-8122', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (89, 'WHITC', 'White Clover Markets', 'Karl Jablonski', 'Owner', '305 - 14th Ave. S. Suite 3B', 'Seattle', 'WA', '98128', 'USA', '(206) 555-4112', '(206) 555-4115', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (90, 'WILMK', 'Wilman Kala', 'Matti Karttunen', 'Owner/Marketing Assistant', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', '90-224 8858', '90-224 8858', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO customers VALUES (91, 'WOLZA', 'Wolski  Zajazd', 'Zbyszek Piestrzeniewicz', 'Owner', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', '(26) 642-7012', '(26) 642-7012', NULL, NULL, NULL, NULL, 'F', 'F', 1);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employees VALUES (1, 'Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1988-12-08', '2012-05-01', '507 - 20th Ave. E.\nApt. 2A', 'Seattle', 'WA', '98122', 'USA', '(206) 555-9857', '5467', '\x', 'Education includes a BA in psychology from Colorado State University in 1970.  She also completed The Art of the Cold Call.  Nancy is a member of Toastmasters International.', 2, 'http://accweb/emmployees/davolio.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (2, 'Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1982-02-19', '2010-08-14', '908 W. Capital Way', 'Tacoma', 'WA', '98401', 'USA', '(206) 555-9482', '3457', '\x', 'Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.', NULL, 'http://accweb/emmployees/fuller.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (3, 'Leverling', 'Janet', 'Sales Representative', 'Ms.', '1983-08-30', '2015-04-01', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '98033', 'USA', '(206) 555-3412', '3355', '\x', 'Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.', 2, 'http://accweb/emmployees/leverling.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (4, 'Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1987-09-19', '2013-05-03', '4110 Old Redmond Rd.', 'Redmond', 'WA', '98052', 'USA', '(206) 555-8122', '5176', '\x', 'Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.', 2, 'http://accweb/emmployees/peacock.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (5, 'Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1990-03-04', '2013-10-17', '14 Garrett Hill', 'London', NULL, 'SW1 8JR', 'UK', '(71) 555-4848', '3453', '\x', 'Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses Successful Telemarketing and International Sales Management.  He is fluent in French.', 2, 'http://accweb/emmployees/buchanan.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (6, 'Suyama', 'Michael', 'Sales Representative', 'Mr.', '1993-07-02', '2018-10-17', 'Coventry House\nMiner Rd.', 'London', NULL, 'EC2 7JR', 'UK', '(71) 555-7773', '428', '\x', 'Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses Multi-Cultural Selling and Time Management for the Sales Professional.  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.', 5, 'http://accweb/emmployees/davolio.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (7, 'King', 'Robert', 'Sales Representative', 'Mr.', '1990-05-29', '2014-01-02', 'Edgeham Hollow\nWinchester Way', 'London', NULL, 'RG1 9SP', 'UK', '(71) 555-5598', '465', '\x', 'Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992, the year he joined the company.  After completing a course entitled Selling in Europe, he was transferred to the London office in March 1993.', 5, 'http://accweb/emmployees/davolio.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (10, 'Ginoj', 'Dona', 'Manager', 'Mrs.', '1993-07-12', '2019-08-04', 'N. Paravoor', 'Ernakulam', 'South', '680888', 'India', '12346789', '0487', NULL, '......', 2, NULL, 2, '2019-08-13 03:48:42.388055', NULL, NULL, 'F', 'F', 6);
INSERT INTO employees VALUES (8, 'Callahan', 'Laura', 'Inside Sales Coordinator', 'Ms.', '1988-01-09', '2016-03-05', '4726 - 11th Ave. N.E.', 'Seattle', 'WA', '98105', 'USA', '(206) 555-1189', '2344', '\x', 'Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.', 2, 'http://accweb/emmployees/davolio.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO employees VALUES (9, 'Dodsworth', 'Anne', 'Sales Representative', 'Ms.', '1986-01-27', '2017-11-15', '7 Houndstooth Rd.', 'London', NULL, 'WG2 7LT', 'UK', '(71) 555-4444', '452', '\x', 'Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German.', 5, 'http://accweb/emmployees/davolio.bmp', NULL, NULL, NULL, NULL, 'F', 'F', 1);
 
-- Data for Name: order_details; Type: TABLE DATA; Schema: public; Owner: -
--
INSERT INTO order_details VALUES (2052, 11042, 61, 28.5, 4, 0, 1, NULL, NULL, 2, '2019-08-28 10:43:37.783319', 'F', 'F', 1, 114.00);
INSERT INTO order_details VALUES (2053, 11043, 11, 21, 10, 0, 1, NULL, NULL, 2, '2019-08-29 07:13:05.937948', 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (2054, 11044, 62, 49.2999992, 12, 0, 1, NULL, NULL, 2, '2019-08-29 07:26:41.962582', 'F', 'F', 1, 591.60);
INSERT INTO order_details VALUES (2222, 11098, 3, 10, 10, 0, 1, 2, '2019-08-28 06:03:00.916423', 2, '2019-09-06 04:28:30.118452', 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (2034, 11035, 1, 18, 10, 0, 2, NULL, NULL, 2, '2019-08-28 10:36:21.281009', 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (2035, 11035, 35, 18, 60, 0, 3, NULL, NULL, 2, '2019-08-28 10:36:21.281009', 'F', 'F', 1, 1080.00);
INSERT INTO order_details VALUES (2036, 11035, 42, 14, 30, 0, 4, NULL, NULL, 2, '2019-08-28 10:36:21.281009', 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (243, 10339, 4, 17.6000004, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 176.00);
INSERT INTO order_details VALUES (244, 10339, 17, 31.2000008, 70, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2183.95);
INSERT INTO order_details VALUES (245, 10339, 62, 39.4000015, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1103.20);
INSERT INTO order_details VALUES (246, 10340, 18, 50, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 999.95);
INSERT INTO order_details VALUES (247, 10340, 41, 7.69999981, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 92.35);
INSERT INTO order_details VALUES (248, 10340, 43, 36.7999992, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1471.95);
INSERT INTO order_details VALUES (249, 10341, 33, 2, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 16.00);
INSERT INTO order_details VALUES (250, 10341, 59, 44, 9, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 395.85);
INSERT INTO order_details VALUES (251, 10342, 2, 15.1999998, 24, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.60);
INSERT INTO order_details VALUES (252, 10342, 31, 10, 56, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 559.80);
INSERT INTO order_details VALUES (253, 10342, 36, 15.1999998, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 607.80);
INSERT INTO order_details VALUES (254, 10342, 55, 19.2000008, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 767.80);
INSERT INTO order_details VALUES (257, 10343, 76, 14.3999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 216.00);
INSERT INTO order_details VALUES (258, 10344, 4, 17.6000004, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 616.00);
INSERT INTO order_details VALUES (259, 10344, 8, 32, 70, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2239.75);
INSERT INTO order_details VALUES (260, 10345, 8, 32, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2240.00);
INSERT INTO order_details VALUES (261, 10345, 19, 7.30000019, 80, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 584.00);
INSERT INTO order_details VALUES (262, 10345, 42, 11.1999998, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.80);
INSERT INTO order_details VALUES (263, 10346, 17, 31.2000008, 36, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1123.10);
INSERT INTO order_details VALUES (264, 10346, 56, 30.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (265, 10347, 25, 11.1999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (266, 10347, 39, 14.3999996, 50, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.85);
INSERT INTO order_details VALUES (267, 10347, 40, 14.6999998, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 58.80);
INSERT INTO order_details VALUES (268, 10347, 75, 6.19999981, 6, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.05);
INSERT INTO order_details VALUES (269, 10348, 1, 14.3999996, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 215.85);
INSERT INTO order_details VALUES (270, 10348, 23, 7.19999981, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (271, 10349, 54, 5.9000001, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 141.60);
INSERT INTO order_details VALUES (272, 10350, 50, 13, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.90);
INSERT INTO order_details VALUES (273, 10350, 69, 28.7999992, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 518.30);
INSERT INTO order_details VALUES (278, 10352, 24, 3.5999999, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (279, 10352, 54, 5.9000001, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 117.85);
INSERT INTO order_details VALUES (282, 10354, 1, 14.3999996, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 172.80);
INSERT INTO order_details VALUES (283, 10354, 29, 99, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 396.00);
INSERT INTO order_details VALUES (284, 10355, 24, 3.5999999, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (285, 10355, 57, 15.6000004, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (286, 10356, 31, 10, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (287, 10356, 55, 19.2000008, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 230.40);
INSERT INTO order_details VALUES (288, 10356, 69, 28.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 576.00);
INSERT INTO order_details VALUES (289, 10357, 10, 24.7999992, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 743.80);
INSERT INTO order_details VALUES (290, 10357, 26, 24.8999996, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 398.40);
INSERT INTO order_details VALUES (291, 10357, 60, 27.2000008, 8, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 217.40);
INSERT INTO order_details VALUES (292, 10358, 24, 3.5999999, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.95);
INSERT INTO order_details VALUES (293, 10358, 34, 11.1999998, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.95);
INSERT INTO order_details VALUES (294, 10358, 36, 15.1999998, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 303.95);
INSERT INTO order_details VALUES (295, 10359, 16, 13.8999996, 56, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 778.35);
INSERT INTO order_details VALUES (296, 10359, 31, 10, 70, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 699.95);
INSERT INTO order_details VALUES (297, 10359, 60, 27.2000008, 80, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2175.95);
INSERT INTO order_details VALUES (298, 10360, 28, 36.4000015, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1092.00);
INSERT INTO order_details VALUES (299, 10360, 29, 99, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3465.00);
INSERT INTO order_details VALUES (300, 10360, 38, 210.800003, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2108.00);
INSERT INTO order_details VALUES (301, 10360, 49, 16, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (302, 10360, 54, 5.9000001, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 165.20);
INSERT INTO order_details VALUES (2180, 11082, 28, 45.5999985, 4, 0, 2, 2, '2019-08-16 06:44:51.328072', 2, '2019-08-28 10:48:45.42041', 'F', 'F', 1, 182.40);
INSERT INTO order_details VALUES (2181, 11082, 19, 9.19999981, 4, 0, 3, 2, '2019-08-16 06:44:51.328072', 2, '2019-08-28 10:48:45.42041', 'F', 'F', 1, 36.80);
INSERT INTO order_details VALUES (1913, 10989, 6, 25, 40, 0, 1, NULL, NULL, 2, '2019-08-28 11:00:20.730242', 'F', 'F', 1, 1000.00);
INSERT INTO order_details VALUES (1914, 10989, 11, 21, 15, 0, 2, NULL, NULL, 2, '2019-08-28 11:00:20.730242', 'F', 'F', 1, 315.00);
INSERT INTO order_details VALUES (1915, 10989, 41, 9.64999962, 4, 0, 3, NULL, NULL, 2, '2019-08-28 11:00:20.730242', 'F', 'F', 1, 38.60);
INSERT INTO order_details VALUES (1547, 10839, 58, 13.25, 30, 0.100000001, 1, NULL, NULL, 2, '2019-08-28 11:07:04.76543', 'F', 'F', 1, 397.40);
INSERT INTO order_details VALUES (1548, 10839, 72, 34.7999992, 15, 0.100000001, 2, NULL, NULL, 2, '2019-08-28 11:07:04.76543', 'F', 'F', 1, 521.90);
INSERT INTO order_details VALUES (1467, 10810, 13, 6, 7, 0, 1, NULL, NULL, 2, '2019-08-28 11:18:16.288146', 'F', 'F', 1, 42.00);
INSERT INTO order_details VALUES (1468, 10810, 25, 14, 5, 0, 2, NULL, NULL, 2, '2019-08-28 11:18:16.288146', 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (1469, 10810, 70, 15, 5, 0, 3, NULL, NULL, 2, '2019-08-28 11:18:16.288146', 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (303, 10361, 39, 14.3999996, 54, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 777.50);
INSERT INTO order_details VALUES (304, 10361, 60, 27.2000008, 55, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1495.90);
INSERT INTO order_details VALUES (305, 10362, 25, 11.1999998, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (306, 10362, 51, 42.4000015, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 848.00);
INSERT INTO order_details VALUES (307, 10362, 54, 5.9000001, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 141.60);
INSERT INTO order_details VALUES (308, 10363, 31, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (309, 10363, 75, 6.19999981, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 74.40);
INSERT INTO order_details VALUES (310, 10363, 76, 14.3999996, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 172.80);
INSERT INTO order_details VALUES (311, 10364, 69, 28.7999992, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 864.00);
INSERT INTO order_details VALUES (312, 10364, 71, 17.2000008, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.00);
INSERT INTO order_details VALUES (313, 10365, 11, 16.7999992, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 403.20);
INSERT INTO order_details VALUES (314, 10366, 65, 16.7999992, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 84.00);
INSERT INTO order_details VALUES (315, 10366, 77, 10.3999996, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 52.00);
INSERT INTO order_details VALUES (316, 10367, 34, 11.1999998, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 403.20);
INSERT INTO order_details VALUES (317, 10367, 54, 5.9000001, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 106.20);
INSERT INTO order_details VALUES (318, 10367, 65, 16.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 252.00);
INSERT INTO order_details VALUES (319, 10367, 77, 10.3999996, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.80);
INSERT INTO order_details VALUES (324, 10369, 29, 99, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1980.00);
INSERT INTO order_details VALUES (325, 10369, 56, 30.3999996, 18, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 546.95);
INSERT INTO order_details VALUES (326, 10370, 1, 14.3999996, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 215.85);
INSERT INTO order_details VALUES (329, 10371, 36, 15.1999998, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 91.00);
INSERT INTO order_details VALUES (330, 10372, 20, 64.8000031, 12, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 777.35);
INSERT INTO order_details VALUES (331, 10372, 38, 210.800003, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 8431.75);
INSERT INTO order_details VALUES (332, 10372, 60, 27.2000008, 70, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1903.75);
INSERT INTO order_details VALUES (333, 10372, 72, 27.7999992, 42, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1167.35);
INSERT INTO order_details VALUES (334, 10373, 58, 10.6000004, 80, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 847.80);
INSERT INTO order_details VALUES (335, 10373, 71, 17.2000008, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 859.80);
INSERT INTO order_details VALUES (336, 10374, 31, 10, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (337, 10374, 58, 10.6000004, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.00);
INSERT INTO order_details VALUES (338, 10375, 14, 18.6000004, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 279.00);
INSERT INTO order_details VALUES (339, 10375, 54, 5.9000001, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 59.00);
INSERT INTO order_details VALUES (340, 10376, 31, 10, 42, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 419.95);
INSERT INTO order_details VALUES (341, 10377, 28, 36.4000015, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 727.85);
INSERT INTO order_details VALUES (342, 10377, 39, 14.3999996, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.85);
INSERT INTO order_details VALUES (343, 10378, 71, 17.2000008, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 103.20);
INSERT INTO order_details VALUES (344, 10379, 41, 7.69999981, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 61.50);
INSERT INTO order_details VALUES (345, 10379, 63, 35.0999985, 16, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 561.50);
INSERT INTO order_details VALUES (346, 10379, 65, 16.7999992, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 335.90);
INSERT INTO order_details VALUES (347, 10380, 30, 20.7000008, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 372.50);
INSERT INTO order_details VALUES (348, 10380, 53, 26.2000008, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.90);
INSERT INTO order_details VALUES (349, 10380, 60, 27.2000008, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 163.10);
INSERT INTO order_details VALUES (350, 10380, 70, 12, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (351, 10381, 74, 8, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (357, 10383, 13, 4.80000019, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 96.00);
INSERT INTO order_details VALUES (358, 10383, 50, 13, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 195.00);
INSERT INTO order_details VALUES (359, 10383, 56, 30.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (2172, 11081, 21, 10, 8, 0, 11, 2, '2019-08-16 05:57:02.869628', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 80.00);
INSERT INTO order_details VALUES (2173, 11081, 40, 18.3999996, 7, 0, 12, 2, '2019-08-16 05:57:02.869628', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 128.80);
INSERT INTO order_details VALUES (2174, 11081, 21, 10, 7, 0, 13, 2, '2019-08-16 05:57:02.869628', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (2175, 11081, 22, 21, 8, 0, 14, 2, '2019-08-16 05:58:30.696721', NULL, NULL, 'F', 'F', 1, 168.00);
INSERT INTO order_details VALUES (2176, 11081, 21, 10, 7, 0, 15, 2, '2019-08-16 05:58:30.696721', NULL, NULL, 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (2177, 11081, 50, 16.25, 8, 0, 16, 2, '2019-08-16 05:58:30.696721', NULL, NULL, 'F', 'F', 1, 130.00);
INSERT INTO order_details VALUES (2178, 11081, 21, 10, 7, 0, 17, 2, '2019-08-16 05:58:30.696721', NULL, NULL, 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (2179, 11081, 18, 62.5, 8, 0, 18, 2, '2019-08-16 05:58:30.696721', NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (2187, 11085, 76, 18, 10, 0, 1, 2, '2019-08-19 04:30:44.906299', 2, '2019-08-27 11:19:56.664384', 'F', 'F', 6, 180.00);
INSERT INTO order_details VALUES (2188, 11085, 78, 5, 14, 0, 2, 2, '2019-08-19 04:30:44.906299', 2, '2019-08-27 11:19:56.664384', 'F', 'F', 6, 70.00);
INSERT INTO order_details VALUES (2189, 11085, 79, 7, 25, 0, 3, 2, '2019-08-19 04:30:44.906299', 2, '2019-08-27 11:19:56.664384', 'F', 'F', 6, 175.00);
INSERT INTO order_details VALUES (2195, 11088, 80, 111, 10, 0, 1, 2, '2019-08-19 10:58:59.609907', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, 1110.00);
INSERT INTO order_details VALUES (2196, 11088, 81, 50, 0, 0, 2, 2, '2019-08-19 10:58:59.609907', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, 0.00);
INSERT INTO order_details VALUES (2184, 11084, 80, 111, 2, 0, 2, 2, '2019-08-19 04:27:42.850892', 2, '2019-08-27 11:20:16.396792', 'F', 'F', 6, 222.00);
INSERT INTO order_details VALUES (2185, 11084, 16, 17.4500008, 10, 0, 3, 2, '2019-08-19 04:27:42.850892', 2, '2019-08-27 11:20:16.396792', 'F', 'F', 6, 174.50);
INSERT INTO order_details VALUES (2186, 11084, 32, 32, 25, 0, 4, 2, '2019-08-19 04:27:42.850892', 2, '2019-08-27 11:20:16.396792', 'F', 'F', 6, 800.00);
INSERT INTO order_details VALUES (2190, 11086, 81, 50, 10, 0, 1, 2, '2019-08-19 05:39:28.41565', 2, '2019-08-27 11:20:26.933186', 'F', 'F', 6, 500.00);
INSERT INTO order_details VALUES (2191, 11086, 79, 7, 0, 0, 2, 2, '2019-08-19 05:39:28.41565', 2, '2019-08-27 11:20:26.933186', 'F', 'F', 6, 0.00);
INSERT INTO order_details VALUES (2193, 11087, 78, 5, 12, 0, 1, 2, '2019-08-19 10:57:38.143033', 2, '2019-08-27 11:20:35.522237', 'F', 'F', 6, 60.00);
INSERT INTO order_details VALUES (2194, 11087, 81, 50, 15, 0, 2, 2, '2019-08-19 10:57:38.143033', 2, '2019-08-27 11:20:35.522237', 'F', 'F', 6, 750.00);
INSERT INTO order_details VALUES (2182, 11083, 12, 38, 2, 0, 2, 2, '2019-08-16 11:03:31.118949', 2, '2019-08-27 11:26:10.918728', 'F', 'F', 6, 76.00);
INSERT INTO order_details VALUES (2183, 11083, 62, 49.2999992, 75, 0, 3, 2, '2019-08-16 11:03:31.118949', 2, '2019-08-27 11:26:10.918728', 'F', 'F', 6, 3697.50);
INSERT INTO order_details VALUES (216, 10329, 19, 7.30000019, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.95);
INSERT INTO order_details VALUES (217, 10329, 30, 20.7000008, 8, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 165.55);
INSERT INTO order_details VALUES (218, 10329, 38, 210.800003, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4215.95);
INSERT INTO order_details VALUES (219, 10329, 56, 30.3999996, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.75);
INSERT INTO order_details VALUES (220, 10330, 26, 24.8999996, 50, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1244.85);
INSERT INTO order_details VALUES (221, 10330, 72, 27.7999992, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 694.85);
INSERT INTO order_details VALUES (222, 10331, 54, 5.9000001, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 88.50);
INSERT INTO order_details VALUES (223, 10332, 18, 50, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1999.80);
INSERT INTO order_details VALUES (224, 10332, 42, 11.1999998, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.80);
INSERT INTO order_details VALUES (225, 10332, 47, 7.5999999, 16, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 121.40);
INSERT INTO order_details VALUES (1783, 10935, 1, 18, 21, 0, 1, NULL, NULL, 2, '2019-08-28 11:12:24.89962', 'F', 'F', 1, 378.00);
INSERT INTO order_details VALUES (1784, 10935, 18, 62.5, 4, 0.25, 2, NULL, NULL, 2, '2019-08-28 11:12:24.89962', 'F', 'F', 1, 249.75);
INSERT INTO order_details VALUES (226, 10333, 14, 18.6000004, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 186.00);
INSERT INTO order_details VALUES (227, 10333, 21, 8, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 79.90);
INSERT INTO order_details VALUES (228, 10333, 71, 17.2000008, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 687.90);
INSERT INTO order_details VALUES (229, 10334, 52, 5.5999999, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.80);
INSERT INTO order_details VALUES (230, 10334, 68, 10, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (231, 10335, 2, 15.1999998, 7, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 106.20);
INSERT INTO order_details VALUES (232, 10335, 31, 10, 25, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.80);
INSERT INTO order_details VALUES (233, 10335, 32, 25.6000004, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 153.40);
INSERT INTO order_details VALUES (360, 10384, 20, 64.8000031, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1814.40);
INSERT INTO order_details VALUES (2197, 11088, 78, 5, 12, 0, 3, 2, '2019-08-21 04:00:40.575258', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, 60.00);
INSERT INTO order_details VALUES (2198, 11088, 81, 50, 10, 0, 4, 2, '2019-08-21 04:00:40.575258', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, 500.00);
INSERT INTO order_details VALUES (234, 10335, 51, 42.4000015, 48, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2035.00);
INSERT INTO order_details VALUES (235, 10336, 4, 17.6000004, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 316.70);
INSERT INTO order_details VALUES (236, 10337, 23, 7.19999981, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (237, 10337, 26, 24.8999996, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 597.60);
INSERT INTO order_details VALUES (238, 10337, 36, 15.1999998, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 304.00);
INSERT INTO order_details VALUES (239, 10337, 37, 20.7999992, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 582.40);
INSERT INTO order_details VALUES (240, 10337, 72, 27.7999992, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 695.00);
INSERT INTO order_details VALUES (241, 10338, 17, 31.2000008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 624.00);
INSERT INTO order_details VALUES (242, 10338, 30, 20.7000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 310.50);
INSERT INTO order_details VALUES (15, 10253, 39, 14.3999996, 42, 0, 2, NULL, NULL, 2, '2019-08-26 08:20:58.167188', 'F', 'F', 1, 604.80);
INSERT INTO order_details VALUES (16, 10253, 49, 16, 40, 0, 3, NULL, NULL, 2, '2019-08-26 08:20:58.167188', 'F', 'F', 1, 640.00);
INSERT INTO order_details VALUES (2199, 11089, 80, 111, 14, 0, 1, 2, '2019-08-21 04:02:31.914656', 2, '2019-08-27 11:20:41.804531', 'F', 'F', 6, 1554.00);
INSERT INTO order_details VALUES (2200, 11089, 81, 50, 10, 0, 2, 2, '2019-08-21 04:02:31.914656', 2, '2019-08-27 11:20:41.804531', 'F', 'F', 6, 500.00);
INSERT INTO order_details VALUES (327, 10370, 64, 26.6000004, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 798.00);
INSERT INTO order_details VALUES (328, 10370, 74, 8, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.85);
INSERT INTO order_details VALUES (435, 10411, 41, 7.69999981, 25, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.30);
INSERT INTO order_details VALUES (436, 10411, 44, 15.5, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 619.80);
INSERT INTO order_details VALUES (437, 10411, 59, 44, 9, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 395.80);
INSERT INTO order_details VALUES (438, 10412, 14, 18.6000004, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 371.90);
INSERT INTO order_details VALUES (439, 10413, 1, 14.3999996, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 345.60);
INSERT INTO order_details VALUES (440, 10413, 62, 39.4000015, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1576.00);
INSERT INTO order_details VALUES (441, 10413, 76, 14.3999996, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 201.60);
INSERT INTO order_details VALUES (383, 10392, 69, 28.7999992, 50, 0, 1, NULL, NULL, 2, '2019-08-28 04:40:58.917094', 'F', 'F', 1, 1440.00);
INSERT INTO order_details VALUES (2203, 11091, 81, 50, 15, 0, 1, 2, '2019-08-21 05:41:57.683605', 2, '2019-08-27 11:25:09.902861', 'F', 'F', 6, 750.00);
INSERT INTO order_details VALUES (2204, 11091, 37, 26, 80, 0, 2, 2, '2019-08-21 05:41:57.683605', 2, '2019-08-27 11:25:09.902861', 'F', 'F', 6, 2080.00);
INSERT INTO order_details VALUES (2205, 11091, 40, 18.3999996, 100, 0, 3, 2, '2019-08-21 05:41:57.683605', 2, '2019-08-27 11:25:09.902861', 'F', 'F', 6, 1840.00);
INSERT INTO order_details VALUES (1659, 10881, 73, 15, 10, 0, 1, NULL, NULL, 2, '2019-08-27 11:30:04.380024', 'F', 'F', 1, 150.00);
INSERT INTO order_details VALUES (477, 10427, 14, 18.6000004, 35, 0, 1, NULL, NULL, 2, '2019-08-28 04:41:02.523954', 'F', 'F', 1, 651.00);
INSERT INTO order_details VALUES (498, 10436, 64, 26.6000004, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 797.90);
INSERT INTO order_details VALUES (499, 10436, 75, 6.19999981, 24, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 148.70);
INSERT INTO order_details VALUES (500, 10437, 53, 26.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 393.00);
INSERT INTO order_details VALUES (501, 10438, 19, 7.30000019, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 109.30);
INSERT INTO order_details VALUES (502, 10438, 34, 11.1999998, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.80);
INSERT INTO order_details VALUES (503, 10438, 57, 15.6000004, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 233.80);
INSERT INTO order_details VALUES (504, 10439, 12, 30.3999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 456.00);
INSERT INTO order_details VALUES (505, 10439, 16, 13.8999996, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 222.40);
INSERT INTO order_details VALUES (506, 10439, 64, 26.6000004, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.60);
INSERT INTO order_details VALUES (507, 10439, 74, 8, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (508, 10440, 2, 15.1999998, 45, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 683.85);
INSERT INTO order_details VALUES (509, 10440, 16, 13.8999996, 49, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 680.95);
INSERT INTO order_details VALUES (510, 10440, 29, 99, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2375.85);
INSERT INTO order_details VALUES (511, 10440, 61, 22.7999992, 90, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2051.85);
INSERT INTO order_details VALUES (512, 10441, 27, 35.0999985, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1755.00);
INSERT INTO order_details VALUES (516, 10443, 11, 16.7999992, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.60);
INSERT INTO order_details VALUES (517, 10443, 28, 36.4000015, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 436.80);
INSERT INTO order_details VALUES (518, 10444, 17, 31.2000008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 312.00);
INSERT INTO order_details VALUES (519, 10444, 26, 24.8999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 373.50);
INSERT INTO order_details VALUES (520, 10444, 35, 14.3999996, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 115.20);
INSERT INTO order_details VALUES (521, 10444, 41, 7.69999981, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 231.00);
INSERT INTO order_details VALUES (522, 10445, 39, 14.3999996, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.40);
INSERT INTO order_details VALUES (523, 10445, 54, 5.9000001, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 88.50);
INSERT INTO order_details VALUES (524, 10446, 19, 7.30000019, 12, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 87.50);
INSERT INTO order_details VALUES (525, 10446, 24, 3.5999999, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 71.90);
INSERT INTO order_details VALUES (526, 10446, 31, 10, 3, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.90);
INSERT INTO order_details VALUES (527, 10446, 52, 5.5999999, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 83.90);
INSERT INTO order_details VALUES (528, 10447, 19, 7.30000019, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 292.00);
INSERT INTO order_details VALUES (529, 10447, 65, 16.7999992, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 588.00);
INSERT INTO order_details VALUES (530, 10447, 71, 17.2000008, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 34.40);
INSERT INTO order_details VALUES (578, 10465, 29, 99, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1781.90);
INSERT INTO order_details VALUES (579, 10465, 40, 14.6999998, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 294.00);
INSERT INTO order_details VALUES (580, 10465, 45, 7.5999999, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 227.90);
INSERT INTO order_details VALUES (581, 10465, 50, 13, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 325.00);
INSERT INTO order_details VALUES (582, 10466, 11, 16.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 168.00);
INSERT INTO order_details VALUES (583, 10466, 46, 9.60000038, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (584, 10467, 24, 3.5999999, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.80);
INSERT INTO order_details VALUES (585, 10467, 25, 11.1999998, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 134.40);
INSERT INTO order_details VALUES (586, 10468, 30, 20.7000008, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 165.60);
INSERT INTO order_details VALUES (587, 10468, 43, 36.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 552.00);
INSERT INTO order_details VALUES (588, 10469, 2, 15.1999998, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 607.85);
INSERT INTO order_details VALUES (589, 10469, 16, 13.8999996, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 486.35);
INSERT INTO order_details VALUES (2072, 11054, 33, 2.5, 10, 0, 1, NULL, NULL, 2, '2019-08-27 11:18:16.669686', 'F', 'F', 1, 25.00);
INSERT INTO order_details VALUES (2073, 11054, 67, 14, 20, 0, 2, NULL, NULL, 2, '2019-08-27 11:18:16.669686', 'F', 'F', 1, 280.00);
INSERT INTO order_details VALUES (2206, 11092, 59, 55, 18, 0, 1, 2, '2019-08-21 06:05:54.708271', 2, '2019-08-27 11:24:21.978795', 'F', 'F', 6, 990.00);
INSERT INTO order_details VALUES (2207, 11092, 18, 62.5, 87, 0, 2, 2, '2019-08-21 06:05:54.708271', 2, '2019-08-27 11:24:21.978795', 'F', 'F', 6, 5437.50);
INSERT INTO order_details VALUES (2208, 11092, 20, 81, 77, 0, 3, 2, '2019-08-21 06:05:54.708271', 2, '2019-08-27 11:24:21.978795', 'F', 'F', 6, 6237.00);
INSERT INTO order_details VALUES (590, 10469, 44, 15.5, 2, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 30.85);
INSERT INTO order_details VALUES (591, 10470, 18, 50, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1500.00);
INSERT INTO order_details VALUES (1785, 10935, 23, 9, 8, 0.25, 3, NULL, NULL, 2, '2019-08-28 11:12:24.89962', 'F', 'F', 1, 71.75);
INSERT INTO order_details VALUES (2219, 11097, 79, 7, 12, 1, 1, 2, '2019-08-26 06:31:20.890637', 2, '2019-09-06 04:24:59.007874', 'F', 'F', 1, 83.00);
INSERT INTO order_details VALUES (2220, 11097, 23, 9, 33, 0, 2, 2, '2019-08-26 06:31:20.890637', 2, '2019-09-06 04:24:59.007874', 'F', 'F', 1, 297.00);
INSERT INTO order_details VALUES (361, 10384, 60, 27.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 408.00);
INSERT INTO order_details VALUES (362, 10385, 7, 24, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.80);
INSERT INTO order_details VALUES (363, 10385, 60, 27.2000008, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 543.80);
INSERT INTO order_details VALUES (364, 10385, 68, 10, 8, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 79.80);
INSERT INTO order_details VALUES (365, 10386, 24, 3.5999999, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (366, 10386, 34, 11.1999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (367, 10387, 24, 3.5999999, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (368, 10387, 28, 36.4000015, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 218.40);
INSERT INTO order_details VALUES (369, 10387, 59, 44, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 528.00);
INSERT INTO order_details VALUES (370, 10387, 71, 17.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.00);
INSERT INTO order_details VALUES (371, 10388, 45, 7.5999999, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 113.80);
INSERT INTO order_details VALUES (372, 10388, 52, 5.5999999, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.80);
INSERT INTO order_details VALUES (373, 10388, 53, 26.2000008, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1048.00);
INSERT INTO order_details VALUES (374, 10389, 10, 24.7999992, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 396.80);
INSERT INTO order_details VALUES (274, 10351, 38, 210.800003, 20, 0.0500000007, 1, NULL, NULL, 2, '2019-08-28 04:30:18.324222', 'F', 'F', 1, 4215.95);
INSERT INTO order_details VALUES (275, 10351, 41, 7.69999981, 13, 0, 2, NULL, NULL, 2, '2019-08-28 04:30:18.324222', 'F', 'F', 1, 100.10);
INSERT INTO order_details VALUES (592, 10470, 23, 7.19999981, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (593, 10470, 64, 26.6000004, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 212.80);
INSERT INTO order_details VALUES (594, 10471, 7, 24, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 720.00);
INSERT INTO order_details VALUES (595, 10471, 56, 30.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (596, 10472, 24, 3.5999999, 80, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.95);
INSERT INTO order_details VALUES (597, 10472, 51, 42.4000015, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 763.20);
INSERT INTO order_details VALUES (598, 10473, 33, 2, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 24.00);
INSERT INTO order_details VALUES (599, 10473, 71, 17.2000008, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 206.40);
INSERT INTO order_details VALUES (600, 10474, 14, 18.6000004, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.20);
INSERT INTO order_details VALUES (601, 10474, 28, 36.4000015, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 655.20);
INSERT INTO order_details VALUES (678, 10506, 70, 15, 14, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 209.90);
INSERT INTO order_details VALUES (679, 10507, 43, 46, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 689.85);
INSERT INTO order_details VALUES (680, 10507, 48, 12.75, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 191.10);
INSERT INTO order_details VALUES (2209, 11093, 80, 111, 18, 0, 1, 2, '2019-08-21 06:21:28.605365', 2, '2019-08-27 11:23:21.600952', 'F', 'F', 6, 1998.00);
INSERT INTO order_details VALUES (2210, 11093, 81, 50, 58, 0, 2, 2, '2019-08-21 06:21:28.605365', 2, '2019-08-27 11:23:21.600952', 'F', 'F', 6, 2900.00);
INSERT INTO order_details VALUES (1840, 10958, 5, 21.3500004, 20, 0, 1, NULL, NULL, 2, '2019-08-27 11:27:58.406538', 'F', 'F', 1, 427.00);
INSERT INTO order_details VALUES (1841, 10958, 7, 30, 6, 0, 2, NULL, NULL, 2, '2019-08-27 11:27:58.406538', 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1842, 10958, 72, 34.7999992, 5, 0, 3, NULL, NULL, 2, '2019-08-27 11:27:58.406538', 'F', 'F', 1, 174.00);
INSERT INTO order_details VALUES (1736, 10916, 32, 32, 6, 0, 2, NULL, NULL, 2, '2019-08-27 11:29:21.090609', 'F', 'F', 1, 192.00);
INSERT INTO order_details VALUES (1737, 10916, 57, 19.5, 20, 0, 3, NULL, NULL, 2, '2019-08-27 11:29:21.090609', 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (1700, 10898, 13, 6, 5, 0, 1, NULL, NULL, 2, '2019-08-27 11:29:50.771078', 'F', 'F', 1, 30.00);
INSERT INTO order_details VALUES (1491, 10819, 43, 46, 7, 0, 1, NULL, NULL, 2, '2019-08-27 11:31:06.549228', 'F', 'F', 1, 322.00);
INSERT INTO order_details VALUES (1492, 10819, 75, 7.75, 20, 0, 2, NULL, NULL, 2, '2019-08-27 11:31:06.549228', 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (1013, 10633, 12, 38, 36, 0.150000006, 1, NULL, NULL, 2, '2019-08-28 04:29:34.704256', 'F', 'F', 1, 1367.85);
INSERT INTO order_details VALUES (1014, 10633, 13, 6, 13, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 04:29:34.704256', 'F', 'F', 1, 77.85);
INSERT INTO order_details VALUES (1015, 10633, 26, 31.2299995, 35, 0.150000006, 3, NULL, NULL, 2, '2019-08-28 04:29:34.704256', 'F', 'F', 1, 1092.90);
INSERT INTO order_details VALUES (1016, 10633, 62, 49.2999992, 80, 0.150000006, 4, NULL, NULL, 2, '2019-08-28 04:29:34.704256', 'F', 'F', 1, 3943.85);
INSERT INTO order_details VALUES (1001, 10626, 60, 34, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 680.00);
INSERT INTO order_details VALUES (1002, 10626, 71, 21.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 430.00);
INSERT INTO order_details VALUES (1003, 10627, 62, 49.2999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 739.50);
INSERT INTO order_details VALUES (1004, 10627, 73, 15, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 524.85);
INSERT INTO order_details VALUES (1005, 10628, 1, 18, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (1006, 10629, 29, 123.790001, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2475.80);
INSERT INTO order_details VALUES (1007, 10629, 64, 33.25, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 299.25);
INSERT INTO order_details VALUES (1008, 10630, 55, 24, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.95);
INSERT INTO order_details VALUES (1009, 10630, 76, 18, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 630.00);
INSERT INTO order_details VALUES (1010, 10631, 75, 7.75, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 61.90);
INSERT INTO order_details VALUES (1011, 10632, 2, 19, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.95);
INSERT INTO order_details VALUES (1012, 10632, 33, 2.5, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 49.95);
INSERT INTO order_details VALUES (1017, 10634, 7, 30, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1050.00);
INSERT INTO order_details VALUES (1018, 10634, 18, 62.5, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3125.00);
INSERT INTO order_details VALUES (1019, 10634, 51, 53, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 795.00);
INSERT INTO order_details VALUES (1020, 10634, 75, 7.75, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 15.50);
INSERT INTO order_details VALUES (1021, 10635, 4, 22, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 219.90);
INSERT INTO order_details VALUES (1022, 10635, 5, 21.3500004, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 320.15);
INSERT INTO order_details VALUES (1023, 10635, 22, 21, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 840.00);
INSERT INTO order_details VALUES (1024, 10636, 4, 22, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 550.00);
INSERT INTO order_details VALUES (1025, 10636, 58, 13.25, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 79.50);
INSERT INTO order_details VALUES (1026, 10637, 11, 21, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (1027, 10637, 50, 16.25, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 406.20);
INSERT INTO order_details VALUES (1028, 10637, 56, 38, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2279.95);
INSERT INTO order_details VALUES (1029, 10638, 45, 9.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (1030, 10638, 65, 21.0499992, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 442.05);
INSERT INTO order_details VALUES (1031, 10638, 72, 34.7999992, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2088.00);
INSERT INTO order_details VALUES (1032, 10639, 18, 62.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (1033, 10640, 69, 36, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.75);
INSERT INTO order_details VALUES (1034, 10640, 70, 15, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 224.75);
INSERT INTO order_details VALUES (2211, 11094, 74, 10, 11, 0, 1, 2, '2019-08-21 06:26:57.91072', 2, '2019-08-27 11:25:37.393012', 'F', 'F', 6, 110.00);
INSERT INTO order_details VALUES (2212, 11094, 16, 17.4500008, 147, 0, 2, 2, '2019-08-21 06:26:57.91072', 2, '2019-08-27 11:25:37.393012', 'F', 'F', 6, 2565.15);
INSERT INTO order_details VALUES (752, 10531, 59, 55, 2, 0, 1, NULL, NULL, 2, '2019-08-27 11:33:07.956207', 'F', 'F', 1, 110.00);
INSERT INTO order_details VALUES (720, 10521, 35, 18, 3, 0, 1, NULL, NULL, 2, '2019-08-27 11:33:39.371774', 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (721, 10521, 41, 9.64999962, 10, 0, 2, NULL, NULL, 2, '2019-08-27 11:33:39.371774', 'F', 'F', 1, 96.50);
INSERT INTO order_details VALUES (722, 10521, 68, 12.5, 6, 0, 3, NULL, NULL, 2, '2019-08-27 11:33:39.371774', 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (531, 10448, 26, 24.8999996, 6, 0, 1, NULL, NULL, 2, '2019-08-27 11:36:44.732511', 'F', 'F', 1, 149.40);
INSERT INTO order_details VALUES (532, 10448, 40, 14.6999998, 20, 0, 2, NULL, NULL, 2, '2019-08-27 11:36:44.732511', 'F', 'F', 1, 294.00);
INSERT INTO order_details VALUES (431, 10409, 14, 18.6000004, 12, 0, 1, NULL, NULL, 2, '2019-08-27 11:37:27.517248', 'F', 'F', 1, 223.20);
INSERT INTO order_details VALUES (2007, 11025, 1, 18, 10, 0.100000001, 1, NULL, NULL, 2, '2019-08-28 11:29:58.08507', 'F', 'F', 1, 179.90);
INSERT INTO order_details VALUES (2008, 11025, 13, 6, 20, 0.100000001, 2, NULL, NULL, 2, '2019-08-28 11:29:58.08507', 'F', 'F', 1, 119.90);
INSERT INTO order_details VALUES (1679, 10890, 17, 39, 15, 0, 1, NULL, NULL, 2, '2019-08-28 11:42:35.328397', 'F', 'F', 1, 585.00);
INSERT INTO order_details VALUES (1680, 10890, 34, 14, 10, 0, 2, NULL, NULL, 2, '2019-08-28 11:42:35.328397', 'F', 'F', 1, 140.00);
INSERT INTO order_details VALUES (1681, 10890, 41, 9.64999962, 14, 0, 3, NULL, NULL, 2, '2019-08-28 11:42:35.328397', 'F', 'F', 1, 135.10);
INSERT INTO order_details VALUES (1418, 10789, 63, 43.9000015, 30, 0, 3, NULL, NULL, 2, '2019-08-28 11:43:58.483875', 'F', 'F', 1, 1317.00);
INSERT INTO order_details VALUES (1419, 10789, 68, 12.5, 18, 0, 4, NULL, NULL, 2, '2019-08-28 11:43:58.483875', 'F', 'F', 1, 225.00);
INSERT INTO order_details VALUES (1870, 10972, 33, 2.5, 7, 0, 2, NULL, NULL, 2, '2019-08-28 11:46:28.792992', 'F', 'F', 1, 17.50);
INSERT INTO order_details VALUES (276, 10351, 44, 15.5, 77, 0.0500000007, 3, NULL, NULL, 2, '2019-08-28 04:30:18.324222', 'F', 'F', 1, 1193.45);
INSERT INTO order_details VALUES (320, 10368, 21, 8, 5, 0.100000001, 1, NULL, NULL, 2, '2019-08-28 04:30:21.826992', 'F', 'F', 1, 39.90);
INSERT INTO order_details VALUES (321, 10368, 28, 36.4000015, 13, 0.100000001, 2, NULL, NULL, 2, '2019-08-28 04:30:21.826992', 'F', 'F', 1, 473.10);
INSERT INTO order_details VALUES (322, 10368, 57, 15.6000004, 25, 0, 3, NULL, NULL, 2, '2019-08-28 04:30:21.826992', 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (280, 10353, 11, 16.7999992, 12, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:40:19.142838', 'F', 'F', 1, 201.40);
INSERT INTO order_details VALUES (281, 10353, 38, 210.800003, 50, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 04:40:19.142838', 'F', 'F', 1, 10539.80);
INSERT INTO order_details VALUES (377, 10389, 70, 12, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (382, 10391, 13, 4.80000019, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.40);
INSERT INTO order_details VALUES (432, 10409, 21, 8, 12, 0, 2, NULL, NULL, 2, '2019-08-27 11:37:27.517248', 'F', 'F', 1, 96.00);
INSERT INTO order_details VALUES (681, 10508, 13, 6, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (682, 10508, 39, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (683, 10509, 28, 45.5999985, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 136.80);
INSERT INTO order_details VALUES (684, 10510, 29, 123.790001, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4456.44);
INSERT INTO order_details VALUES (685, 10510, 75, 7.75, 36, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 278.90);
INSERT INTO order_details VALUES (686, 10511, 4, 22, 50, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1099.85);
INSERT INTO order_details VALUES (687, 10511, 7, 30, 50, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1499.85);
INSERT INTO order_details VALUES (688, 10511, 8, 40, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.85);
INSERT INTO order_details VALUES (689, 10512, 24, 4.5, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.85);
INSERT INTO order_details VALUES (690, 10512, 46, 12, 9, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 107.85);
INSERT INTO order_details VALUES (691, 10512, 47, 9.5, 6, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 56.85);
INSERT INTO order_details VALUES (692, 10512, 60, 34, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 407.85);
INSERT INTO order_details VALUES (693, 10513, 21, 10, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.80);
INSERT INTO order_details VALUES (694, 10513, 32, 32, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1599.80);
INSERT INTO order_details VALUES (695, 10513, 61, 28.5, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 427.30);
INSERT INTO order_details VALUES (701, 10515, 9, 97, 16, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1551.85);
INSERT INTO order_details VALUES (702, 10515, 16, 17.4500008, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 872.50);
INSERT INTO order_details VALUES (703, 10515, 27, 43.9000015, 120, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 5268.00);
INSERT INTO order_details VALUES (704, 10515, 33, 2.5, 16, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 39.85);
INSERT INTO order_details VALUES (705, 10515, 60, 34, 84, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2855.85);
INSERT INTO order_details VALUES (706, 10516, 18, 62.5, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1562.40);
INSERT INTO order_details VALUES (707, 10516, 41, 9.64999962, 80, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 771.90);
INSERT INTO order_details VALUES (708, 10516, 42, 14, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 280.00);
INSERT INTO order_details VALUES (712, 10518, 24, 4.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 22.50);
INSERT INTO order_details VALUES (713, 10518, 38, 263.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3952.50);
INSERT INTO order_details VALUES (714, 10518, 44, 19.4500008, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 175.05);
INSERT INTO order_details VALUES (715, 10519, 10, 31, 16, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 495.95);
INSERT INTO order_details VALUES (716, 10519, 56, 38, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1520.00);
INSERT INTO order_details VALUES (717, 10519, 60, 34, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 339.95);
INSERT INTO order_details VALUES (718, 10520, 24, 4.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (719, 10520, 53, 32.7999992, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 164.00);
INSERT INTO order_details VALUES (723, 10522, 1, 18, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.80);
INSERT INTO order_details VALUES (724, 10522, 8, 40, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 960.00);
INSERT INTO order_details VALUES (725, 10522, 30, 25.8899994, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 517.60);
INSERT INTO order_details VALUES (726, 10522, 40, 18.3999996, 25, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 459.80);
INSERT INTO order_details VALUES (727, 10523, 17, 39, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 974.90);
INSERT INTO order_details VALUES (728, 10523, 20, 81, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1214.90);
INSERT INTO order_details VALUES (729, 10523, 37, 26, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 467.90);
INSERT INTO order_details VALUES (730, 10523, 41, 9.64999962, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.80);
INSERT INTO order_details VALUES (731, 10524, 10, 31, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.00);
INSERT INTO order_details VALUES (732, 10524, 30, 25.8899994, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.90);
INSERT INTO order_details VALUES (733, 10524, 43, 46, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2760.00);
INSERT INTO order_details VALUES (734, 10524, 54, 7.44999981, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.75);
INSERT INTO order_details VALUES (696, 10514, 20, 81, 39, 0, 1, NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, 3159.00);
INSERT INTO order_details VALUES (697, 10514, 28, 45.5999985, 35, 0, 2, NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, 1596.00);
INSERT INTO order_details VALUES (639, 10489, 11, 16.7999992, 15, 0.25, 1, NULL, NULL, 2, '2019-08-28 04:40:26.638731', 'F', 'F', 1, 251.75);
INSERT INTO order_details VALUES (640, 10489, 16, 13.8999996, 18, 0, 2, NULL, NULL, 2, '2019-08-28 04:40:26.638731', 'F', 'F', 1, 250.20);
INSERT INTO order_details VALUES (739, 10526, 56, 38, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1139.85);
INSERT INTO order_details VALUES (740, 10527, 4, 22, 50, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1099.90);
INSERT INTO order_details VALUES (741, 10527, 36, 19, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.90);
INSERT INTO order_details VALUES (742, 10528, 11, 21, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 63.00);
INSERT INTO order_details VALUES (743, 10528, 33, 2.5, 8, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 19.80);
INSERT INTO order_details VALUES (744, 10528, 72, 34.7999992, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 313.20);
INSERT INTO order_details VALUES (745, 10529, 55, 24, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 336.00);
INSERT INTO order_details VALUES (746, 10529, 68, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (747, 10529, 69, 36, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (753, 10532, 30, 25.8899994, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.35);
INSERT INTO order_details VALUES (754, 10532, 66, 17, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 408.00);
INSERT INTO order_details VALUES (755, 10533, 4, 22, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1099.95);
INSERT INTO order_details VALUES (756, 10533, 72, 34.7999992, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 835.20);
INSERT INTO order_details VALUES (757, 10533, 73, 15, 24, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.95);
INSERT INTO order_details VALUES (758, 10534, 30, 25.8899994, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.90);
INSERT INTO order_details VALUES (759, 10534, 40, 18.3999996, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 183.80);
INSERT INTO order_details VALUES (760, 10534, 54, 7.44999981, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 74.30);
INSERT INTO order_details VALUES (761, 10535, 11, 21, 50, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1049.90);
INSERT INTO order_details VALUES (762, 10535, 40, 18.3999996, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 183.90);
INSERT INTO order_details VALUES (763, 10535, 57, 19.5, 5, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 97.40);
INSERT INTO order_details VALUES (764, 10535, 59, 55, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 824.90);
INSERT INTO order_details VALUES (765, 10536, 12, 38, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.75);
INSERT INTO order_details VALUES (766, 10536, 31, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (2213, 11095, 64, 33.25, 12, 0, 1, 2, '2019-08-21 10:10:48.943081', 2, '2019-08-27 11:24:48.63443', 'F', 'F', 6, 399.00);
INSERT INTO order_details VALUES (2214, 11095, 20, 81, 15, 0, 2, 2, '2019-08-21 10:10:48.943081', 2, '2019-08-27 11:24:48.63443', 'F', 'F', 6, 1215.00);
INSERT INTO order_details VALUES (2119, 11072, 50, 16.25, 22, 0, 3, NULL, NULL, 2, '2019-08-27 11:41:21.789088', 'F', 'F', 1, 357.50);
INSERT INTO order_details VALUES (2120, 11072, 64, 33.25, 130, 0, 4, NULL, NULL, 2, '2019-08-27 11:41:21.789088', 'F', 'F', 1, 4322.50);
INSERT INTO order_details VALUES (767, 10536, 33, 2.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (768, 10536, 60, 34, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1189.75);
INSERT INTO order_details VALUES (769, 10537, 31, 12.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 375.00);
INSERT INTO order_details VALUES (770, 10537, 51, 53, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 318.00);
INSERT INTO order_details VALUES (771, 10537, 58, 13.25, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 265.00);
INSERT INTO order_details VALUES (1755, 10924, 75, 7.75, 6, 0, 3, NULL, NULL, 2, '2019-08-29 05:18:30.235341', 'F', 'F', 1, 46.50);
INSERT INTO order_details VALUES (709, 10517, 52, 7, 6, 0, 1, NULL, NULL, 2, '2019-08-29 06:32:28.994317', 'F', 'F', 1, 42.00);
INSERT INTO order_details VALUES (710, 10517, 59, 55, 4, 0, 2, NULL, NULL, 2, '2019-08-29 06:32:28.994317', 'F', 'F', 1, 220.00);
INSERT INTO order_details VALUES (711, 10517, 70, 15, 6, 0, 3, NULL, NULL, 2, '2019-08-29 06:32:28.994317', 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (384, 10393, 2, 15.1999998, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.75);
INSERT INTO order_details VALUES (385, 10393, 14, 18.6000004, 42, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 780.95);
INSERT INTO order_details VALUES (386, 10393, 25, 11.1999998, 7, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 78.15);
INSERT INTO order_details VALUES (387, 10393, 26, 24.8999996, 70, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1742.75);
INSERT INTO order_details VALUES (388, 10393, 31, 10, 32, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 320.00);
INSERT INTO order_details VALUES (389, 10394, 13, 4.80000019, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (390, 10394, 62, 39.4000015, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 394.00);
INSERT INTO order_details VALUES (391, 10395, 46, 9.60000038, 28, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 268.70);
INSERT INTO order_details VALUES (392, 10395, 53, 26.2000008, 70, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1833.90);
INSERT INTO order_details VALUES (393, 10395, 69, 28.7999992, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 230.40);
INSERT INTO order_details VALUES (772, 10537, 72, 34.7999992, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 730.80);
INSERT INTO order_details VALUES (773, 10537, 73, 15, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 135.00);
INSERT INTO order_details VALUES (774, 10538, 70, 15, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 105.00);
INSERT INTO order_details VALUES (775, 10538, 72, 34.7999992, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 34.80);
INSERT INTO order_details VALUES (776, 10539, 13, 6, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (777, 10539, 21, 10, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 150.00);
INSERT INTO order_details VALUES (778, 10539, 33, 2.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.50);
INSERT INTO order_details VALUES (779, 10539, 49, 20, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (780, 10540, 3, 10, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (781, 10540, 26, 31.2299995, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1249.20);
INSERT INTO order_details VALUES (782, 10540, 38, 263.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7905.00);
INSERT INTO order_details VALUES (783, 10540, 68, 12.5, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 437.50);
INSERT INTO order_details VALUES (784, 10541, 24, 4.5, 35, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 157.40);
INSERT INTO order_details VALUES (785, 10541, 38, 263.5, 4, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1053.90);
INSERT INTO order_details VALUES (786, 10541, 65, 21.0499992, 36, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 757.70);
INSERT INTO order_details VALUES (787, 10541, 71, 21.5, 9, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 193.40);
INSERT INTO order_details VALUES (788, 10542, 11, 21, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 314.95);
INSERT INTO order_details VALUES (789, 10542, 54, 7.44999981, 24, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 178.75);
INSERT INTO order_details VALUES (790, 10543, 12, 38, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1139.85);
INSERT INTO order_details VALUES (791, 10543, 23, 9, 70, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 629.85);
INSERT INTO order_details VALUES (792, 10544, 28, 45.5999985, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 319.20);
INSERT INTO order_details VALUES (793, 10544, 67, 14, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.00);
INSERT INTO order_details VALUES (795, 10546, 7, 30, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (796, 10546, 35, 18, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (797, 10546, 62, 49.2999992, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1972.00);
INSERT INTO order_details VALUES (798, 10547, 32, 32, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 767.85);
INSERT INTO order_details VALUES (799, 10547, 36, 19, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1140.00);
INSERT INTO order_details VALUES (800, 10548, 34, 14, 10, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.75);
INSERT INTO order_details VALUES (801, 10548, 41, 9.64999962, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 135.10);
INSERT INTO order_details VALUES (802, 10549, 31, 12.5, 55, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 687.35);
INSERT INTO order_details VALUES (803, 10549, 45, 9.5, 100, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 949.85);
INSERT INTO order_details VALUES (804, 10549, 51, 53, 48, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2543.85);
INSERT INTO order_details VALUES (805, 10550, 17, 39, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 311.90);
INSERT INTO order_details VALUES (806, 10550, 19, 9.19999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 92.00);
INSERT INTO order_details VALUES (807, 10550, 21, 10, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 59.90);
INSERT INTO order_details VALUES (808, 10550, 61, 28.5, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 284.90);
INSERT INTO order_details VALUES (809, 10551, 16, 17.4500008, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 697.85);
INSERT INTO order_details VALUES (810, 10551, 35, 18, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.85);
INSERT INTO order_details VALUES (811, 10551, 44, 19.4500008, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 778.00);
INSERT INTO order_details VALUES (812, 10552, 69, 36, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 648.00);
INSERT INTO order_details VALUES (813, 10552, 75, 7.75, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 232.50);
INSERT INTO order_details VALUES (814, 10553, 11, 21, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 315.00);
INSERT INTO order_details VALUES (815, 10553, 16, 17.4500008, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 244.30);
INSERT INTO order_details VALUES (816, 10553, 22, 21, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (817, 10553, 31, 12.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 375.00);
INSERT INTO order_details VALUES (818, 10553, 35, 18, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (819, 10554, 16, 17.4500008, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.45);
INSERT INTO order_details VALUES (820, 10554, 23, 9, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 179.95);
INSERT INTO order_details VALUES (821, 10554, 62, 49.2999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 985.95);
INSERT INTO order_details VALUES (822, 10554, 77, 13, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 129.95);
INSERT INTO order_details VALUES (823, 10555, 14, 23.25, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 697.30);
INSERT INTO order_details VALUES (824, 10555, 19, 9.19999981, 35, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 321.80);
INSERT INTO order_details VALUES (825, 10555, 24, 4.5, 18, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 80.80);
INSERT INTO order_details VALUES (826, 10555, 51, 53, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1059.80);
INSERT INTO order_details VALUES (827, 10555, 56, 38, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1519.80);
INSERT INTO order_details VALUES (831, 10558, 47, 9.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 237.50);
INSERT INTO order_details VALUES (832, 10558, 51, 53, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1060.00);
INSERT INTO order_details VALUES (833, 10558, 52, 7, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (834, 10558, 53, 32.7999992, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 590.40);
INSERT INTO order_details VALUES (835, 10558, 73, 15, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 45.00);
INSERT INTO order_details VALUES (836, 10559, 41, 9.64999962, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 115.75);
INSERT INTO order_details VALUES (837, 10559, 55, 24, 18, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 431.95);
INSERT INTO order_details VALUES (838, 10560, 30, 25.8899994, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 517.80);
INSERT INTO order_details VALUES (839, 10560, 62, 49.2999992, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 739.25);
INSERT INTO order_details VALUES (840, 10561, 44, 19.4500008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.50);
INSERT INTO order_details VALUES (841, 10561, 51, 53, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2650.00);
INSERT INTO order_details VALUES (842, 10562, 33, 2.5, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 49.90);
INSERT INTO order_details VALUES (843, 10562, 62, 49.2999992, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 492.90);
INSERT INTO order_details VALUES (844, 10563, 36, 19, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 475.00);
INSERT INTO order_details VALUES (845, 10563, 52, 7, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 490.00);
INSERT INTO order_details VALUES (846, 10564, 17, 39, 16, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 623.95);
INSERT INTO order_details VALUES (847, 10564, 31, 12.5, 6, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 74.95);
INSERT INTO order_details VALUES (848, 10564, 55, 24, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 599.95);
INSERT INTO order_details VALUES (849, 10565, 24, 4.5, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.40);
INSERT INTO order_details VALUES (850, 10565, 64, 33.25, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 598.40);
INSERT INTO order_details VALUES (851, 10566, 11, 21, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 734.85);
INSERT INTO order_details VALUES (852, 10566, 18, 62.5, 18, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1124.85);
INSERT INTO order_details VALUES (853, 10566, 76, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (854, 10567, 31, 12.5, 60, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 749.80);
INSERT INTO order_details VALUES (858, 10569, 31, 12.5, 35, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 437.30);
INSERT INTO order_details VALUES (859, 10569, 76, 18, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (860, 10570, 11, 21, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 314.95);
INSERT INTO order_details VALUES (861, 10570, 56, 38, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2279.95);
INSERT INTO order_details VALUES (2215, 11096, 11, 21, 12, 0, 1, 2, '2019-08-23 11:05:43.500131', 2, '2019-08-27 11:24:55.124605', 'F', 'F', 1, 252.00);
INSERT INTO order_details VALUES (1407, 10785, 10, 31, 10, 0, 1, NULL, NULL, 2, '2019-08-29 06:02:35.006881', 'F', 'F', 1, 310.00);
INSERT INTO order_details VALUES (794, 10545, 11, 21, 10, 0, 1, NULL, NULL, 2, '2019-08-29 06:18:44.690113', 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (394, 10396, 23, 7.19999981, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (395, 10396, 71, 17.2000008, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1032.00);
INSERT INTO order_details VALUES (396, 10396, 72, 27.7999992, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 583.80);
INSERT INTO order_details VALUES (397, 10397, 21, 8, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 79.85);
INSERT INTO order_details VALUES (398, 10397, 51, 42.4000015, 18, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 763.05);
INSERT INTO order_details VALUES (399, 10398, 35, 14.3999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (400, 10398, 55, 19.2000008, 120, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2303.90);
INSERT INTO order_details VALUES (401, 10399, 68, 10, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (402, 10399, 71, 17.2000008, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 516.00);
INSERT INTO order_details VALUES (403, 10399, 76, 14.3999996, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (404, 10399, 77, 10.3999996, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 145.60);
INSERT INTO order_details VALUES (405, 10400, 29, 99, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2079.00);
INSERT INTO order_details VALUES (406, 10400, 35, 14.3999996, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (407, 10400, 49, 16, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 480.00);
INSERT INTO order_details VALUES (408, 10401, 30, 20.7000008, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 372.60);
INSERT INTO order_details VALUES (409, 10401, 56, 30.3999996, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2128.00);
INSERT INTO order_details VALUES (410, 10401, 65, 16.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 336.00);
INSERT INTO order_details VALUES (411, 10401, 71, 17.2000008, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1032.00);
INSERT INTO order_details VALUES (416, 10404, 26, 24.8999996, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 746.95);
INSERT INTO order_details VALUES (417, 10404, 42, 11.1999998, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 447.95);
INSERT INTO order_details VALUES (418, 10404, 49, 16, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 479.95);
INSERT INTO order_details VALUES (419, 10405, 3, 8, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (420, 10406, 1, 14.3999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (421, 10406, 21, 8, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.90);
INSERT INTO order_details VALUES (422, 10406, 28, 36.4000015, 42, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1528.70);
INSERT INTO order_details VALUES (423, 10406, 36, 15.1999998, 5, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.90);
INSERT INTO order_details VALUES (1904, 10986, 11, 21, 30, 0, 2, NULL, NULL, 2, '2019-08-27 11:10:57.853433', 'F', 'F', 1, 630.00);
INSERT INTO order_details VALUES (1906, 10986, 76, 18, 10, 0, 3, NULL, NULL, 2, '2019-08-27 11:10:57.853433', 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1907, 10986, 77, 13, 15, 0, 4, NULL, NULL, 2, '2019-08-27 11:10:57.853433', 'F', 'F', 1, 195.00);
INSERT INTO order_details VALUES (1235, 10716, 21, 10, 5, 0, 1, NULL, NULL, 2, '2019-08-27 11:13:16.031494', 'F', 'F', 1, 50.00);
INSERT INTO order_details VALUES (1236, 10716, 51, 53, 7, 0, 2, NULL, NULL, 2, '2019-08-27 11:13:16.031494', 'F', 'F', 1, 371.00);
INSERT INTO order_details VALUES (1237, 10716, 61, 28.5, 10, 0, 3, NULL, NULL, 2, '2019-08-27 11:13:16.031494', 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (2201, 11090, 78, 5, 10, 0, 1, 2, '2019-08-21 05:24:30.249047', 2, '2019-08-27 11:25:24.97793', 'F', 'F', 6, 50.00);
INSERT INTO order_details VALUES (2202, 11090, 80, 111, 12, 0, 2, 2, '2019-08-21 05:24:30.249047', 2, '2019-08-27 11:25:24.97793', 'F', 'F', 6, 1332.00);
INSERT INTO order_details VALUES (1510, 10828, 20, 81, 5, 0, 1, NULL, NULL, 2, '2019-08-27 11:30:13.810029', 'F', 'F', 1, 405.00);
INSERT INTO order_details VALUES (1511, 10828, 38, 263.5, 2, 0, 2, NULL, NULL, 2, '2019-08-27 11:30:13.810029', 'F', 'F', 1, 527.00);
INSERT INTO order_details VALUES (424, 10406, 40, 14.6999998, 2, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.30);
INSERT INTO order_details VALUES (425, 10407, 11, 16.7999992, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (426, 10407, 69, 28.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (427, 10407, 71, 17.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.00);
INSERT INTO order_details VALUES (428, 10408, 37, 20.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 208.00);
INSERT INTO order_details VALUES (429, 10408, 54, 5.9000001, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.40);
INSERT INTO order_details VALUES (430, 10408, 62, 39.4000015, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1379.00);
INSERT INTO order_details VALUES (433, 10410, 33, 2, 49, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.00);
INSERT INTO order_details VALUES (434, 10410, 59, 44, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 704.00);
INSERT INTO order_details VALUES (2076, 11055, 51, 53, 20, 0, 3, NULL, NULL, 2, '2019-08-29 06:10:23.032288', 'F', 'F', 1, 1060.00);
INSERT INTO order_details VALUES (2077, 11055, 57, 19.5, 20, 0, 4, NULL, NULL, 2, '2019-08-29 06:10:23.032288', 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (1086, 10660, 20, 81, 21, 0, 1, NULL, NULL, 2, '2019-08-29 06:11:36.529815', 'F', 'F', 1, 1701.00);
INSERT INTO order_details VALUES (1666, 10884, 65, 21.0499992, 12, 0.0500000007, 3, NULL, NULL, 2, '2019-08-29 06:21:08.218865', 'F', 'F', 1, 252.55);
INSERT INTO order_details VALUES (1809, 10945, 31, 12.5, 10, 0, 2, NULL, NULL, 2, '2019-08-29 06:28:47.977338', 'F', 'F', 1, 125.00);
INSERT INTO order_details VALUES (1961, 11007, 29, 123.790001, 10, 0, 2, NULL, NULL, 2, '2019-08-29 06:41:30.968608', 'F', 'F', 1, 1237.90);
INSERT INTO order_details VALUES (1962, 11007, 42, 14, 14, 0, 3, NULL, NULL, 2, '2019-08-29 06:41:30.968608', 'F', 'F', 1, 196.00);
INSERT INTO order_details VALUES (2134, 11077, 7, 30, 1, 0.0500000007, 5, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 29.95);
INSERT INTO order_details VALUES (2135, 11077, 8, 40, 2, 0.100000001, 6, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 79.90);
INSERT INTO order_details VALUES (2136, 11077, 10, 31, 1, 0, 7, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 31.00);
INSERT INTO order_details VALUES (2137, 11077, 12, 38, 2, 0.0500000007, 8, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 75.95);
INSERT INTO order_details VALUES (2138, 11077, 13, 6, 4, 0, 9, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 24.00);
INSERT INTO order_details VALUES (2139, 11077, 14, 23.25, 1, 0.0299999993, 10, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 23.22);
INSERT INTO order_details VALUES (2140, 11077, 16, 17.4500008, 2, 0.0299999993, 11, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 34.87);
INSERT INTO order_details VALUES (2141, 11077, 20, 81, 1, 0.0399999991, 12, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 80.96);
INSERT INTO order_details VALUES (2142, 11077, 23, 9, 2, 0, 13, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 18.00);
INSERT INTO order_details VALUES (2143, 11077, 32, 32, 1, 0, 14, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 32.00);
INSERT INTO order_details VALUES (2144, 11077, 39, 18, 2, 0.0500000007, 15, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 35.95);
INSERT INTO order_details VALUES (2145, 11077, 41, 9.64999962, 3, 0, 16, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 28.95);
INSERT INTO order_details VALUES (2146, 11077, 46, 12, 3, 0.0199999996, 17, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 35.98);
INSERT INTO order_details VALUES (2147, 11077, 52, 7, 2, 0, 18, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 14.00);
INSERT INTO order_details VALUES (2148, 11077, 55, 24, 2, 0, 19, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (2149, 11077, 60, 34, 2, 0.0599999987, 20, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 67.94);
INSERT INTO order_details VALUES (2150, 11077, 64, 33.25, 2, 0.0299999993, 21, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 66.47);
INSERT INTO order_details VALUES (2151, 11077, 66, 17, 1, 0, 22, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 17.00);
INSERT INTO order_details VALUES (2152, 11077, 73, 15, 2, 0.00999999978, 23, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 29.99);
INSERT INTO order_details VALUES (2153, 11077, 75, 7.75, 4, 0, 24, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 31.00);
INSERT INTO order_details VALUES (2154, 11077, 77, 13, 2, 0, 25, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 26.00);
INSERT INTO order_details VALUES (2092, 11062, 70, 15, 12, 0.200000003, 2, NULL, NULL, 2, '2019-08-29 06:53:16.162349', 'F', 'F', 1, 179.80);
INSERT INTO order_details VALUES (442, 10414, 19, 7.30000019, 18, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 131.35);
INSERT INTO order_details VALUES (443, 10414, 33, 2, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (444, 10415, 17, 31.2000008, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.40);
INSERT INTO order_details VALUES (445, 10415, 33, 2, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (446, 10416, 19, 7.30000019, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 146.00);
INSERT INTO order_details VALUES (447, 10416, 53, 26.2000008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 262.00);
INSERT INTO order_details VALUES (448, 10416, 57, 15.6000004, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 312.00);
INSERT INTO order_details VALUES (449, 10417, 38, 210.800003, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 10540.00);
INSERT INTO order_details VALUES (450, 10417, 46, 9.60000038, 2, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 18.95);
INSERT INTO order_details VALUES (451, 10417, 68, 10, 36, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.75);
INSERT INTO order_details VALUES (452, 10417, 77, 10.3999996, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.00);
INSERT INTO order_details VALUES (453, 10418, 2, 15.1999998, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (454, 10418, 47, 7.5999999, 55, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 418.00);
INSERT INTO order_details VALUES (455, 10418, 61, 22.7999992, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.80);
INSERT INTO order_details VALUES (456, 10418, 74, 8, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (457, 10419, 60, 27.2000008, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1631.95);
INSERT INTO order_details VALUES (458, 10419, 69, 28.7999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 575.95);
INSERT INTO order_details VALUES (2216, 11096, 2, 19, 25, 0, 2, 2, '2019-08-23 11:05:43.500131', 2, '2019-08-27 11:24:55.124605', 'F', 'F', 1, 475.00);
INSERT INTO order_details VALUES (2217, 11096, 80, 111, 25, 0, 3, 2, '2019-08-23 11:05:43.500131', 2, '2019-08-27 11:24:55.124605', 'F', 'F', 1, 2775.00);
INSERT INTO order_details VALUES (2218, 11096, 81, 50, 2, 0, 4, 2, '2019-08-23 11:05:43.500131', 2, '2019-08-27 11:24:55.124605', 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (1888, 10979, 24, 4.5, 80, 0, 3, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1889, 10979, 27, 43.9000015, 30, 0, 4, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 1317.00);
INSERT INTO order_details VALUES (1890, 10979, 31, 12.5, 24, 0, 5, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1891, 10979, 63, 43.9000015, 35, 0, 6, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 1536.50);
INSERT INTO order_details VALUES (1432, 10795, 17, 39, 35, 0.25, 2, NULL, NULL, 2, '2019-08-28 04:25:21.603999', 'F', 'F', 1, 1364.75);
INSERT INTO order_details VALUES (1693, 10895, 39, 18, 45, 0, 2, NULL, NULL, 2, '2019-08-28 04:25:32.384392', 'F', 'F', 1, 810.00);
INSERT INTO order_details VALUES (1694, 10895, 40, 18.3999996, 91, 0, 3, NULL, NULL, 2, '2019-08-28 04:25:32.384392', 'F', 'F', 1, 1674.40);
INSERT INTO order_details VALUES (1695, 10895, 60, 34, 100, 0, 4, NULL, NULL, 2, '2019-08-28 04:25:32.384392', 'F', 'F', 1, 3400.00);
INSERT INTO order_details VALUES (1591, 10854, 13, 6, 65, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 04:25:38.80377', 'F', 'F', 1, 389.85);
INSERT INTO order_details VALUES (1919, 10990, 61, 28.5, 66, 0.150000006, 4, NULL, NULL, 2, '2019-08-28 04:25:48.375918', 'F', 'F', 1, 1880.85);
INSERT INTO order_details VALUES (30, 10258, 5, 17, 65, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 04:28:47.801201', 'F', 'F', 1, 1104.80);
INSERT INTO order_details VALUES (31, 10258, 32, 25.6000004, 6, 0.200000003, 3, NULL, NULL, 2, '2019-08-28 04:28:47.801201', 'F', 'F', 1, 153.40);
INSERT INTO order_details VALUES (1536, 10836, 35, 18, 6, 0, 2, NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (1537, 10836, 57, 19.5, 24, 0, 3, NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, 468.00);
INSERT INTO order_details VALUES (1538, 10836, 60, 34, 60, 0, 4, NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, 2040.00);
INSERT INTO order_details VALUES (1539, 10836, 64, 33.25, 30, 0, 5, NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, 997.50);
INSERT INTO order_details VALUES (1389, 10776, 42, 14, 12, 0.0500000007, 2, NULL, NULL, 2, '2019-08-28 04:29:06.48725', 'F', 'F', 1, 167.95);
INSERT INTO order_details VALUES (1390, 10776, 45, 9.5, 27, 0.0500000007, 3, NULL, NULL, 2, '2019-08-28 04:29:06.48725', 'F', 'F', 1, 256.45);
INSERT INTO order_details VALUES (1391, 10776, 51, 53, 120, 0.0500000007, 4, NULL, NULL, 2, '2019-08-28 04:29:06.48725', 'F', 'F', 1, 6359.95);
INSERT INTO order_details VALUES (514, 10442, 54, 5.9000001, 80, 0, 2, NULL, NULL, 2, '2019-08-28 04:29:14.467374', 'F', 'F', 1, 472.00);
INSERT INTO order_details VALUES (515, 10442, 66, 13.6000004, 60, 0, 3, NULL, NULL, 2, '2019-08-28 04:29:14.467374', 'F', 'F', 1, 816.00);
INSERT INTO order_details VALUES (483, 10430, 56, 30.3999996, 30, 0, 3, NULL, NULL, 2, '2019-08-28 04:30:05.933158', 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (484, 10430, 59, 44, 70, 0.200000003, 4, NULL, NULL, 2, '2019-08-28 04:30:05.933158', 'F', 'F', 1, 3079.80);
INSERT INTO order_details VALUES (45, 10263, 30, 20.7000008, 60, 0.25, 3, NULL, NULL, 2, '2019-08-28 04:30:14.630269', 'F', 'F', 1, 1241.75);
INSERT INTO order_details VALUES (46, 10263, 74, 8, 36, 0.25, 4, NULL, NULL, 2, '2019-08-28 04:30:14.630269', 'F', 'F', 1, 287.75);
INSERT INTO order_details VALUES (277, 10351, 65, 16.7999992, 10, 0.0500000007, 4, NULL, NULL, 2, '2019-08-28 04:30:18.324222', 'F', 'F', 1, 167.95);
INSERT INTO order_details VALUES (323, 10368, 64, 26.6000004, 35, 0.100000001, 4, NULL, NULL, 2, '2019-08-28 04:30:21.826992', 'F', 'F', 1, 930.90);
INSERT INTO order_details VALUES (864, 10572, 16, 17.4500008, 12, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 209.30);
INSERT INTO order_details VALUES (865, 10572, 32, 32, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 319.90);
INSERT INTO order_details VALUES (866, 10572, 40, 18.3999996, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 920.00);
INSERT INTO order_details VALUES (867, 10572, 75, 7.75, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 116.15);
INSERT INTO order_details VALUES (868, 10573, 17, 39, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 702.00);
INSERT INTO order_details VALUES (869, 10573, 34, 14, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (870, 10573, 53, 32.7999992, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 820.00);
INSERT INTO order_details VALUES (875, 10575, 59, 55, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 660.00);
INSERT INTO order_details VALUES (876, 10575, 63, 43.9000015, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 263.40);
INSERT INTO order_details VALUES (877, 10575, 72, 34.7999992, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1044.00);
INSERT INTO order_details VALUES (878, 10575, 76, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (879, 10576, 1, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (880, 10576, 31, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (881, 10576, 44, 19.4500008, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 408.45);
INSERT INTO order_details VALUES (885, 10578, 35, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (886, 10578, 57, 19.5, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 117.00);
INSERT INTO order_details VALUES (887, 10579, 15, 15.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (888, 10579, 75, 7.75, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 162.75);
INSERT INTO order_details VALUES (889, 10580, 14, 23.25, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 348.70);
INSERT INTO order_details VALUES (890, 10580, 41, 9.64999962, 9, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.80);
INSERT INTO order_details VALUES (891, 10580, 65, 21.0499992, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 631.45);
INSERT INTO order_details VALUES (892, 10581, 75, 7.75, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 387.30);
INSERT INTO order_details VALUES (893, 10582, 57, 19.5, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 78.00);
INSERT INTO order_details VALUES (894, 10582, 76, 18, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 252.00);
INSERT INTO order_details VALUES (897, 10583, 69, 36, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.85);
INSERT INTO order_details VALUES (898, 10584, 31, 12.5, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 624.95);
INSERT INTO order_details VALUES (899, 10585, 47, 9.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 142.50);
INSERT INTO order_details VALUES (2014, 11028, 59, 55, 24, 0, 2, NULL, NULL, 2, '2019-08-29 06:16:29.770175', 'F', 'F', 1, 1320.00);
INSERT INTO order_details VALUES (1330, 10752, 69, 36, 3, 0, 2, NULL, NULL, 2, '2019-08-29 06:32:16.119386', 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (882, 10577, 39, 18, 10, 0, 1, NULL, NULL, 2, '2019-08-29 07:21:09.34386', 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (883, 10577, 75, 7.75, 20, 0, 2, NULL, NULL, 2, '2019-08-29 07:21:09.34386', 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (884, 10577, 77, 13, 18, 0, 3, NULL, NULL, 2, '2019-08-29 07:21:09.34386', 'F', 'F', 1, 234.00);
INSERT INTO order_details VALUES (871, 10574, 33, 2.5, 14, 0, 1, NULL, NULL, 2, '2019-08-29 07:21:20.592626', 'F', 'F', 1, 35.00);
INSERT INTO order_details VALUES (872, 10574, 40, 18.3999996, 2, 0, 2, NULL, NULL, 2, '2019-08-29 07:21:20.592626', 'F', 'F', 1, 36.80);
INSERT INTO order_details VALUES (873, 10574, 62, 49.2999992, 10, 0, 3, NULL, NULL, 2, '2019-08-29 07:21:20.592626', 'F', 'F', 1, 493.00);
INSERT INTO order_details VALUES (874, 10574, 64, 33.25, 6, 0, 4, NULL, NULL, 2, '2019-08-29 07:21:20.592626', 'F', 'F', 1, 199.50);
INSERT INTO order_details VALUES (459, 10420, 9, 77.5999985, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1551.90);
INSERT INTO order_details VALUES (460, 10420, 13, 4.80000019, 2, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 9.50);
INSERT INTO order_details VALUES (461, 10420, 70, 12, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.90);
INSERT INTO order_details VALUES (462, 10420, 73, 12, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.90);
INSERT INTO order_details VALUES (463, 10421, 19, 7.30000019, 4, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.05);
INSERT INTO order_details VALUES (464, 10421, 26, 24.8999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 747.00);
INSERT INTO order_details VALUES (465, 10421, 53, 26.2000008, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 392.85);
INSERT INTO order_details VALUES (900, 10586, 52, 7, 4, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 27.85);
INSERT INTO order_details VALUES (901, 10587, 26, 31.2299995, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 187.38);
INSERT INTO order_details VALUES (902, 10587, 35, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (903, 10587, 77, 13, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 260.00);
INSERT INTO order_details VALUES (904, 10588, 18, 62.5, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2499.80);
INSERT INTO order_details VALUES (905, 10588, 42, 14, 100, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1399.80);
INSERT INTO order_details VALUES (906, 10589, 35, 18, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.00);
INSERT INTO order_details VALUES (907, 10590, 1, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (908, 10590, 77, 13, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 779.95);
INSERT INTO order_details VALUES (909, 10591, 3, 10, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 140.00);
INSERT INTO order_details VALUES (910, 10591, 7, 30, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (911, 10591, 54, 7.44999981, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 372.50);
INSERT INTO order_details VALUES (912, 10592, 15, 15.5, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 387.45);
INSERT INTO order_details VALUES (913, 10592, 26, 31.2299995, 5, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 156.10);
INSERT INTO order_details VALUES (914, 10593, 20, 81, 21, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1700.80);
INSERT INTO order_details VALUES (915, 10593, 69, 36, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.80);
INSERT INTO order_details VALUES (916, 10593, 76, 18, 4, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 71.80);
INSERT INTO order_details VALUES (917, 10594, 52, 7, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 168.00);
INSERT INTO order_details VALUES (918, 10594, 58, 13.25, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 397.50);
INSERT INTO order_details VALUES (922, 10596, 56, 38, 5, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 189.80);
INSERT INTO order_details VALUES (923, 10596, 63, 43.9000015, 24, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1053.40);
INSERT INTO order_details VALUES (924, 10596, 75, 7.75, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 232.30);
INSERT INTO order_details VALUES (928, 10598, 27, 43.9000015, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2195.00);
INSERT INTO order_details VALUES (929, 10598, 71, 21.5, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 193.50);
INSERT INTO order_details VALUES (930, 10599, 62, 49.2999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 493.00);
INSERT INTO order_details VALUES (931, 10600, 54, 7.44999981, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.80);
INSERT INTO order_details VALUES (932, 10600, 73, 15, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (933, 10601, 13, 6, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (934, 10601, 59, 55, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1925.00);
INSERT INTO order_details VALUES (935, 10602, 77, 13, 5, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 64.75);
INSERT INTO order_details VALUES (936, 10603, 22, 21, 48, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1008.00);
INSERT INTO order_details VALUES (937, 10603, 49, 20, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 499.95);
INSERT INTO order_details VALUES (938, 10604, 48, 12.75, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 76.40);
INSERT INTO order_details VALUES (939, 10604, 76, 18, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 179.90);
INSERT INTO order_details VALUES (940, 10605, 16, 17.4500008, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.45);
INSERT INTO order_details VALUES (941, 10605, 59, 55, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1099.95);
INSERT INTO order_details VALUES (942, 10605, 60, 34, 70, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2379.95);
INSERT INTO order_details VALUES (943, 10605, 71, 21.5, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 322.45);
INSERT INTO order_details VALUES (944, 10606, 4, 22, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 439.80);
INSERT INTO order_details VALUES (945, 10606, 55, 24, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 479.80);
INSERT INTO order_details VALUES (946, 10606, 62, 49.2999992, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 492.80);
INSERT INTO order_details VALUES (947, 10607, 7, 30, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1350.00);
INSERT INTO order_details VALUES (948, 10607, 17, 39, 100, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3900.00);
INSERT INTO order_details VALUES (949, 10607, 33, 2.5, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.00);
INSERT INTO order_details VALUES (950, 10607, 40, 18.3999996, 42, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 772.80);
INSERT INTO order_details VALUES (951, 10607, 72, 34.7999992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 417.60);
INSERT INTO order_details VALUES (952, 10608, 56, 38, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1064.00);
INSERT INTO order_details VALUES (953, 10609, 1, 18, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (954, 10609, 10, 31, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 310.00);
INSERT INTO order_details VALUES (955, 10609, 21, 10, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (956, 10610, 36, 19, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 398.75);
INSERT INTO order_details VALUES (957, 10611, 1, 18, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (958, 10611, 2, 19, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (2056, 11045, 51, 53, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1272.00);
INSERT INTO order_details VALUES (2060, 11047, 1, 18, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 449.75);
INSERT INTO order_details VALUES (2061, 11047, 5, 21.3500004, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 640.25);
INSERT INTO order_details VALUES (2063, 11049, 2, 19, 10, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 10:52:34.955061', 'F', 'F', 1, 189.80);
INSERT INTO order_details VALUES (2064, 11049, 12, 38, 4, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 10:52:34.955061', 'F', 'F', 1, 151.80);
INSERT INTO order_details VALUES (2067, 11052, 43, 46, 30, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 10:56:51.957495', 'F', 'F', 1, 1379.80);
INSERT INTO order_details VALUES (2068, 11052, 61, 28.5, 10, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 10:56:51.957495', 'F', 'F', 1, 284.80);
INSERT INTO order_details VALUES (2085, 11059, 13, 6, 30, 0, 1, NULL, NULL, 2, '2019-08-28 11:04:55.418245', 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (2086, 11059, 17, 39, 12, 0, 2, NULL, NULL, 2, '2019-08-28 11:04:55.418245', 'F', 'F', 1, 468.00);
INSERT INTO order_details VALUES (2087, 11059, 60, 34, 35, 0, 3, NULL, NULL, 2, '2019-08-28 11:04:55.418245', 'F', 'F', 1, 1190.00);
INSERT INTO order_details VALUES (2062, 11048, 68, 12.5, 42, 0, 1, NULL, NULL, 2, '2019-08-28 11:14:32.265793', 'F', 'F', 1, 525.00);
INSERT INTO order_details VALUES (2066, 11051, 24, 4.5, 10, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 11:47:31.057113', 'F', 'F', 1, 44.80);
INSERT INTO order_details VALUES (2082, 11058, 21, 10, 3, 0, 1, NULL, NULL, 2, '2019-08-29 05:20:50.872284', 'F', 'F', 1, 30.00);
INSERT INTO order_details VALUES (2083, 11058, 60, 34, 21, 0, 2, NULL, NULL, 2, '2019-08-29 05:20:50.872284', 'F', 'F', 1, 714.00);
INSERT INTO order_details VALUES (2084, 11058, 61, 28.5, 4, 0, 3, NULL, NULL, 2, '2019-08-29 05:20:50.872284', 'F', 'F', 1, 114.00);
INSERT INTO order_details VALUES (2057, 11046, 12, 38, 20, 0.0500000007, 1, NULL, NULL, 2, '2019-08-29 05:43:22.483922', 'F', 'F', 1, 759.95);
INSERT INTO order_details VALUES (2058, 11046, 32, 32, 15, 0.0500000007, 2, NULL, NULL, 2, '2019-08-29 05:43:22.483922', 'F', 'F', 1, 479.95);
INSERT INTO order_details VALUES (2059, 11046, 35, 18, 18, 0.0500000007, 3, NULL, NULL, 2, '2019-08-29 05:43:22.483922', 'F', 'F', 1, 323.95);
INSERT INTO order_details VALUES (2078, 11056, 7, 30, 40, 0, 1, NULL, NULL, 2, '2019-08-29 05:47:52.17889', 'F', 'F', 1, 1200.00);
INSERT INTO order_details VALUES (2079, 11056, 55, 24, 35, 0, 2, NULL, NULL, 2, '2019-08-29 05:47:52.17889', 'F', 'F', 1, 840.00);
INSERT INTO order_details VALUES (2080, 11056, 60, 34, 50, 0, 3, NULL, NULL, 2, '2019-08-29 05:47:52.17889', 'F', 'F', 1, 1700.00);
INSERT INTO order_details VALUES (2065, 11050, 76, 18, 50, 0.100000001, 1, NULL, NULL, 2, '2019-08-29 05:49:46.217405', 'F', 'F', 1, 899.90);
INSERT INTO order_details VALUES (2088, 11060, 60, 34, 4, 0, 1, NULL, NULL, 2, '2019-08-29 05:51:48.12772', 'F', 'F', 1, 136.00);
INSERT INTO order_details VALUES (2089, 11060, 77, 13, 10, 0, 2, NULL, NULL, 2, '2019-08-29 05:51:48.12772', 'F', 'F', 1, 130.00);
INSERT INTO order_details VALUES (2090, 11061, 60, 34, 15, 0, 1, NULL, NULL, 2, '2019-08-29 06:00:06.118161', 'F', 'F', 1, 510.00);
INSERT INTO order_details VALUES (2074, 11055, 24, 4.5, 15, 0, 1, NULL, NULL, 2, '2019-08-29 06:10:23.032288', 'F', 'F', 1, 67.50);
INSERT INTO order_details VALUES (2075, 11055, 25, 14, 15, 0, 2, NULL, NULL, 2, '2019-08-29 06:10:23.032288', 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (2093, 11063, 34, 14, 30, 0, 1, NULL, NULL, 2, '2019-08-29 06:13:11.12174', 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (2094, 11063, 40, 18.3999996, 40, 0.100000001, 2, NULL, NULL, 2, '2019-08-29 06:13:11.12174', 'F', 'F', 1, 735.90);
INSERT INTO order_details VALUES (2095, 11063, 41, 9.64999962, 30, 0.100000001, 3, NULL, NULL, 2, '2019-08-29 06:13:11.12174', 'F', 'F', 1, 289.40);
INSERT INTO order_details VALUES (2081, 11057, 70, 15, 3, 0, 1, NULL, NULL, 2, '2019-08-29 06:32:02.514184', 'F', 'F', 1, 45.00);
INSERT INTO order_details VALUES (2033, 11034, 61, 28.5, 6, 0, 3, NULL, NULL, 2, '2019-08-29 06:33:14.704284', 'F', 'F', 1, 171.00);
INSERT INTO order_details VALUES (2091, 11062, 53, 32.7999992, 10, 0.200000003, 1, NULL, NULL, 2, '2019-08-29 06:53:16.162349', 'F', 'F', 1, 327.80);
INSERT INTO order_details VALUES (2096, 11064, 17, 39, 77, 0.100000001, 1, NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, 3002.90);
INSERT INTO order_details VALUES (2097, 11064, 41, 9.64999962, 12, 0, 2, NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, 115.80);
INSERT INTO order_details VALUES (466, 10421, 77, 10.3999996, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 103.85);
INSERT INTO order_details VALUES (467, 10422, 26, 24.8999996, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 49.80);
INSERT INTO order_details VALUES (468, 10423, 31, 10, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 140.00);
INSERT INTO order_details VALUES (469, 10423, 59, 44, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 880.00);
INSERT INTO order_details VALUES (470, 10424, 35, 14.3999996, 60, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 863.80);
INSERT INTO order_details VALUES (471, 10424, 38, 210.800003, 49, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 10329.00);
INSERT INTO order_details VALUES (472, 10424, 68, 10, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 299.80);
INSERT INTO order_details VALUES (473, 10425, 55, 19.2000008, 10, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 191.75);
INSERT INTO order_details VALUES (474, 10425, 76, 14.3999996, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.75);
INSERT INTO order_details VALUES (475, 10426, 56, 30.3999996, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 152.00);
INSERT INTO order_details VALUES (476, 10426, 64, 26.6000004, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 186.20);
INSERT INTO order_details VALUES (478, 10428, 46, 9.60000038, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.00);
INSERT INTO order_details VALUES (479, 10429, 50, 13, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 520.00);
INSERT INTO order_details VALUES (480, 10429, 63, 35.0999985, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1228.25);
INSERT INTO order_details VALUES (485, 10431, 17, 31.2000008, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1559.75);
INSERT INTO order_details VALUES (486, 10431, 40, 14.6999998, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 734.75);
INSERT INTO order_details VALUES (487, 10431, 47, 7.5999999, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 227.75);
INSERT INTO order_details VALUES (488, 10432, 26, 24.8999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.00);
INSERT INTO order_details VALUES (489, 10432, 54, 5.9000001, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 236.00);
INSERT INTO order_details VALUES (490, 10433, 56, 30.3999996, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 851.20);
INSERT INTO order_details VALUES (491, 10434, 11, 16.7999992, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.80);
INSERT INTO order_details VALUES (492, 10434, 76, 14.3999996, 18, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 259.05);
INSERT INTO order_details VALUES (493, 10435, 2, 15.1999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 152.00);
INSERT INTO order_details VALUES (494, 10435, 22, 16.7999992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 201.60);
INSERT INTO order_details VALUES (378, 10390, 31, 10, 60, 0.100000001, 1, NULL, NULL, 2, '2019-08-28 04:29:54.687489', 'F', 'F', 1, 599.90);
INSERT INTO order_details VALUES (2098, 11064, 53, 32.7999992, 25, 0.100000001, 3, NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, 819.90);
INSERT INTO order_details VALUES (1632, 10869, 68, 12.5, 20, 0, 4, NULL, NULL, 2, '2019-08-29 07:00:56.275108', 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (412, 10402, 23, 7.19999981, 60, 0, 1, NULL, NULL, 2, '2019-08-28 04:29:58.5727', 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (413, 10402, 63, 35.0999985, 65, 0, 2, NULL, NULL, 2, '2019-08-28 04:29:58.5727', 'F', 'F', 1, 2281.50);
INSERT INTO order_details VALUES (414, 10403, 16, 13.8999996, 21, 0.150000006, 1, NULL, NULL, 2, '2019-08-28 04:30:02.340283', 'F', 'F', 1, 291.75);
INSERT INTO order_details VALUES (415, 10403, 48, 10.1999998, 70, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 04:30:02.340283', 'F', 'F', 1, 713.85);
INSERT INTO order_details VALUES (481, 10430, 17, 31.2000008, 45, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:30:05.933158', 'F', 'F', 1, 1403.80);
INSERT INTO order_details VALUES (482, 10430, 21, 8, 50, 0, 2, NULL, NULL, 2, '2019-08-28 04:30:05.933158', 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (533, 10449, 10, 24.7999992, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 347.20);
INSERT INTO order_details VALUES (534, 10449, 52, 5.5999999, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (535, 10449, 62, 39.4000015, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1379.00);
INSERT INTO order_details VALUES (536, 10450, 10, 24.7999992, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 495.80);
INSERT INTO order_details VALUES (537, 10450, 54, 5.9000001, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.20);
INSERT INTO order_details VALUES (538, 10451, 55, 19.2000008, 120, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2303.90);
INSERT INTO order_details VALUES (539, 10451, 64, 26.6000004, 35, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 930.90);
INSERT INTO order_details VALUES (540, 10451, 65, 16.7999992, 28, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 470.30);
INSERT INTO order_details VALUES (2101, 11065, 30, 25.8899994, 4, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 103.31);
INSERT INTO order_details VALUES (2102, 11065, 54, 7.44999981, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 148.75);
INSERT INTO order_details VALUES (2166, 11079, 61, 28.5, 8, 0, 8, 2, '2019-08-16 04:22:20.006252', NULL, NULL, 'F', 'F', 1, 228.00);
INSERT INTO order_details VALUES (2167, 11081, 10, 31, 5, 0, 8, 2, '2019-08-16 04:47:22.560474', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (2168, 11080, 64, 33.25, 5, 0, 9, 2, '2019-08-06 09:58:37.932418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 166.25);
INSERT INTO order_details VALUES (2168, 11081, 64, 33.25, 5, 0, 9, 2, '2019-08-16 04:47:22.560474', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 166.25);
INSERT INTO order_details VALUES (2169, 11080, 29, 123.790001, 8, 0, 10, 2, '2019-08-06 09:58:37.932418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 990.32);
INSERT INTO order_details VALUES (2169, 11081, 29, 123.790001, 8, 0, 10, 2, '2019-08-16 04:47:22.560474', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 990.32);
INSERT INTO order_details VALUES (2170, 11081, 24, 4.5, 1, 0, 1, 2, '2019-08-07 11:26:39.360418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 4.50);
INSERT INTO order_details VALUES (2170, 11081, 24, 4.5, 1, 0, 1, 2, '2019-08-16 05:55:14.495978', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 4.50);
INSERT INTO order_details VALUES (2171, 11081, 55, 24, 2, 0, 2, 2, '2019-08-07 11:26:39.360418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (2171, 11081, 55, 24, 2, 0, 2, 2, '2019-08-16 05:55:14.495978', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (2117, 11072, 2, 19, 8, 0, 1, NULL, NULL, 2, '2019-08-27 11:41:21.789088', 'F', 'F', 1, 152.00);
INSERT INTO order_details VALUES (2118, 11072, 41, 9.64999962, 40, 0, 2, NULL, NULL, 2, '2019-08-27 11:41:21.789088', 'F', 'F', 1, 386.00);
INSERT INTO order_details VALUES (2069, 11053, 18, 62.5, 35, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:37:07.019155', 'F', 'F', 1, 2187.30);
INSERT INTO order_details VALUES (2070, 11053, 32, 32, 20, 0, 2, NULL, NULL, 2, '2019-08-28 04:37:07.019155', 'F', 'F', 1, 640.00);
INSERT INTO order_details VALUES (2071, 11053, 64, 33.25, 25, 0.200000003, 3, NULL, NULL, 2, '2019-08-28 04:37:07.019155', 'F', 'F', 1, 831.05);
INSERT INTO order_details VALUES (1035, 10641, 2, 19, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 950.00);
INSERT INTO order_details VALUES (1036, 10641, 40, 18.3999996, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1104.00);
INSERT INTO order_details VALUES (1037, 10642, 21, 10, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 299.80);
INSERT INTO order_details VALUES (1038, 10642, 61, 28.5, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.80);
INSERT INTO order_details VALUES (1039, 10643, 28, 45.5999985, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 683.75);
INSERT INTO order_details VALUES (698, 10514, 56, 38, 70, 0, 3, NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, 2660.00);
INSERT INTO order_details VALUES (699, 10514, 65, 21.0499992, 39, 0, 4, NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, 820.95);
INSERT INTO order_details VALUES (700, 10514, 75, 7.75, 50, 0, 5, NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, 387.50);
INSERT INTO order_details VALUES (862, 10571, 14, 23.25, 11, 0.150000006, 1, NULL, NULL, 2, '2019-08-28 04:29:25.017072', 'F', 'F', 1, 255.60);
INSERT INTO order_details VALUES (863, 10571, 42, 14, 28, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 04:29:25.017072', 'F', 'F', 1, 391.85);
INSERT INTO order_details VALUES (920, 10595, 61, 28.5, 120, 0.25, 2, NULL, NULL, 2, '2019-08-28 04:29:30.002937', 'F', 'F', 1, 3419.75);
INSERT INTO order_details VALUES (921, 10595, 69, 36, 65, 0.25, 3, NULL, NULL, 2, '2019-08-28 04:29:30.002937', 'F', 'F', 1, 2339.75);
INSERT INTO order_details VALUES (1101, 10667, 69, 36, 45, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:29:39.043122', 'F', 'F', 1, 1619.80);
INSERT INTO order_details VALUES (1102, 10667, 71, 21.5, 14, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 04:29:39.043122', 'F', 'F', 1, 300.80);
INSERT INTO order_details VALUES (1185, 10698, 29, 123.790001, 12, 0.0500000007, 3, NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, 1485.43);
INSERT INTO order_details VALUES (1186, 10698, 65, 21.0499992, 65, 0.0500000007, 4, NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, 1368.20);
INSERT INTO order_details VALUES (1187, 10698, 70, 15, 8, 0.0500000007, 5, NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, 119.95);
INSERT INTO order_details VALUES (2109, 11068, 77, 13, 28, 0.150000006, 1, NULL, NULL, 2, '2019-08-28 11:02:49.762899', 'F', 'F', 1, 363.85);
INSERT INTO order_details VALUES (2123, 11074, 16, 17.4500008, 14, 0.0500000007, 1, NULL, NULL, 2, '2019-08-28 11:22:45.535983', 'F', 'F', 1, 244.25);
INSERT INTO order_details VALUES (2127, 11076, 6, 25, 20, 0.25, 1, NULL, NULL, 2, '2019-08-28 11:38:22.437309', 'F', 'F', 1, 499.75);
INSERT INTO order_details VALUES (2128, 11076, 14, 23.25, 20, 0.25, 2, NULL, NULL, 2, '2019-08-28 11:38:22.437309', 'F', 'F', 1, 464.75);
INSERT INTO order_details VALUES (2129, 11076, 19, 9.19999981, 10, 0.25, 3, NULL, NULL, 2, '2019-08-28 11:38:22.437309', 'F', 'F', 1, 91.75);
INSERT INTO order_details VALUES (2111, 11070, 1, 18, 40, 0.150000006, 1, NULL, NULL, 2, '2019-08-29 06:19:54.341261', 'F', 'F', 1, 719.85);
INSERT INTO order_details VALUES (2112, 11070, 2, 19, 20, 0.150000006, 2, NULL, NULL, 2, '2019-08-29 06:19:54.341261', 'F', 'F', 1, 379.85);
INSERT INTO order_details VALUES (2113, 11070, 16, 17.4500008, 30, 0.150000006, 3, NULL, NULL, 2, '2019-08-29 06:19:54.341261', 'F', 'F', 1, 523.35);
INSERT INTO order_details VALUES (2114, 11070, 31, 12.5, 20, 0, 4, NULL, NULL, 2, '2019-08-29 06:19:54.341261', 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (2115, 11071, 7, 30, 15, 0.0500000007, 1, NULL, NULL, 2, '2019-08-29 06:22:52.921319', 'F', 'F', 1, 449.95);
INSERT INTO order_details VALUES (2116, 11071, 13, 6, 10, 0.0500000007, 2, NULL, NULL, 2, '2019-08-29 06:22:52.921319', 'F', 'F', 1, 59.95);
INSERT INTO order_details VALUES (2121, 11073, 11, 21, 10, 0, 1, NULL, NULL, 2, '2019-08-29 06:39:28.716231', 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (2122, 11073, 24, 4.5, 20, 0, 2, NULL, NULL, 2, '2019-08-29 06:39:28.716231', 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (2130, 11077, 2, 19, 24, 0.200000003, 1, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 455.80);
INSERT INTO order_details VALUES (2131, 11077, 3, 10, 4, 0, 2, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (2132, 11077, 4, 22, 1, 0, 3, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 22.00);
INSERT INTO order_details VALUES (2133, 11077, 6, 25, 1, 0.0199999996, 4, NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, 24.98);
INSERT INTO order_details VALUES (2124, 11075, 2, 19, 10, 0.150000006, 1, NULL, NULL, 2, '2019-08-29 06:55:49.921738', 'F', 'F', 1, 189.85);
INSERT INTO order_details VALUES (2125, 11075, 46, 12, 30, 0.150000006, 2, NULL, NULL, 2, '2019-08-29 06:55:49.921738', 'F', 'F', 1, 359.85);
INSERT INTO order_details VALUES (2126, 11075, 76, 18, 2, 0.150000006, 3, NULL, NULL, 2, '2019-08-29 06:55:49.921738', 'F', 'F', 1, 35.85);
INSERT INTO order_details VALUES (2099, 11064, 55, 24, 4, 0.100000001, 4, NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, 95.90);
INSERT INTO order_details VALUES (2100, 11064, 68, 12.5, 55, 0, 5, NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, 687.50);
INSERT INTO order_details VALUES (1953, 11003, 52, 7, 10, 0, 3, NULL, NULL, 2, '2019-08-29 07:16:50.782117', 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (1387, 10775, 67, 14, 3, 0, 2, NULL, NULL, 2, '2019-08-29 07:17:02.0213', 'F', 'F', 1, 42.00);
INSERT INTO order_details VALUES (2110, 11069, 39, 18, 20, 0, 1, NULL, NULL, 2, '2019-08-29 07:19:24.825289', 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (2103, 11066, 16, 17.4500008, 3, 0, 1, NULL, NULL, 2, '2019-08-29 07:24:44.116369', 'F', 'F', 1, 52.35);
INSERT INTO order_details VALUES (2104, 11066, 19, 9.19999981, 42, 0, 2, NULL, NULL, 2, '2019-08-29 07:24:44.116369', 'F', 'F', 1, 386.40);
INSERT INTO order_details VALUES (2105, 11066, 34, 14, 35, 0, 3, NULL, NULL, 2, '2019-08-29 07:24:44.116369', 'F', 'F', 1, 490.00);
INSERT INTO order_details VALUES (2055, 11045, 33, 2.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.50);
INSERT INTO order_details VALUES (1362, 10764, 3, 10, 20, 0.100000001, 1, NULL, NULL, 2, '2019-08-28 04:29:46.61755', 'F', 'F', 1, 199.90);
INSERT INTO order_details VALUES (1363, 10764, 39, 18, 130, 0.100000001, 2, NULL, NULL, 2, '2019-08-28 04:29:46.61755', 'F', 'F', 1, 2339.90);
INSERT INTO order_details VALUES (352, 10382, 5, 17, 32, 0, 1, NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, 544.00);
INSERT INTO order_details VALUES (353, 10382, 18, 50, 9, 0, 2, NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (354, 10382, 29, 99, 14, 0, 3, NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, 1386.00);
INSERT INTO order_details VALUES (355, 10382, 33, 2, 60, 0, 4, NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (356, 10382, 74, 8, 50, 0, 5, NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (379, 10390, 35, 14.3999996, 40, 0.100000001, 2, NULL, NULL, 2, '2019-08-28 04:29:54.687489', 'F', 'F', 1, 575.90);
INSERT INTO order_details VALUES (380, 10390, 46, 9.60000038, 45, 0, 3, NULL, NULL, 2, '2019-08-28 04:29:54.687489', 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (381, 10390, 72, 27.7999992, 24, 0.100000001, 4, NULL, NULL, 2, '2019-08-28 04:29:54.687489', 'F', 'F', 1, 667.10);
INSERT INTO order_details VALUES (748, 10530, 17, 39, 40, 0, 1, NULL, NULL, 2, '2019-08-28 04:40:32.027363', 'F', 'F', 1, 1560.00);
INSERT INTO order_details VALUES (749, 10530, 43, 46, 25, 0, 2, NULL, NULL, 2, '2019-08-28 04:40:32.027363', 'F', 'F', 1, 1150.00);
INSERT INTO order_details VALUES (1313, 10747, 41, 9.64999962, 35, 0, 2, NULL, NULL, 2, '2019-08-28 04:40:47.69697', 'F', 'F', 1, 337.75);
INSERT INTO order_details VALUES (1314, 10747, 63, 43.9000015, 9, 0, 3, NULL, NULL, 2, '2019-08-28 04:40:47.69697', 'F', 'F', 1, 395.10);
INSERT INTO order_details VALUES (1315, 10747, 69, 36, 30, 0, 4, NULL, NULL, 2, '2019-08-28 04:40:47.69697', 'F', 'F', 1, 1080.00);
INSERT INTO order_details VALUES (2039, 11036, 59, 55, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1650.00);
INSERT INTO order_details VALUES (2040, 11037, 70, 15, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1905, 10986, 20, 81, 15, 0, 1, NULL, NULL, 2, '2019-08-27 11:10:57.853433', 'F', 'F', 1, 1215.00);
INSERT INTO order_details VALUES (20, 10255, 2, 15.1999998, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 304.00);
INSERT INTO order_details VALUES (21, 10255, 16, 13.8999996, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 486.50);
INSERT INTO order_details VALUES (22, 10255, 36, 15.1999998, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (23, 10255, 59, 44, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1320.00);
INSERT INTO order_details VALUES (24, 10256, 53, 26.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 393.00);
INSERT INTO order_details VALUES (25, 10256, 77, 10.3999996, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 124.80);
INSERT INTO order_details VALUES (26, 10257, 27, 35.0999985, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 877.50);
INSERT INTO order_details VALUES (27, 10257, 39, 14.3999996, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.40);
INSERT INTO order_details VALUES (28, 10257, 77, 10.3999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 156.00);
INSERT INTO order_details VALUES (34, 10260, 41, 7.69999981, 16, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 122.95);
INSERT INTO order_details VALUES (35, 10260, 57, 15.6000004, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 780.00);
INSERT INTO order_details VALUES (36, 10260, 62, 39.4000015, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 590.75);
INSERT INTO order_details VALUES (37, 10260, 70, 12, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.75);
INSERT INTO order_details VALUES (38, 10261, 21, 8, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 160.00);
INSERT INTO order_details VALUES (39, 10261, 35, 14.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (40, 10262, 5, 17, 12, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 203.80);
INSERT INTO order_details VALUES (41, 10262, 7, 24, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (42, 10262, 56, 30.3999996, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.80);
INSERT INTO order_details VALUES (47, 10264, 2, 15.1999998, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 532.00);
INSERT INTO order_details VALUES (48, 10264, 41, 7.69999981, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.35);
INSERT INTO order_details VALUES (49, 10265, 17, 31.2000008, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 936.00);
INSERT INTO order_details VALUES (50, 10265, 70, 12, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (51, 10266, 12, 30.3999996, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.75);
INSERT INTO order_details VALUES (52, 10267, 40, 14.6999998, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 735.00);
INSERT INTO order_details VALUES (53, 10267, 59, 44, 70, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3079.85);
INSERT INTO order_details VALUES (54, 10267, 76, 14.3999996, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 215.85);
INSERT INTO order_details VALUES (55, 10268, 29, 99, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 990.00);
INSERT INTO order_details VALUES (56, 10268, 72, 27.7999992, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.20);
INSERT INTO order_details VALUES (57, 10269, 33, 2, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 119.95);
INSERT INTO order_details VALUES (58, 10269, 72, 27.7999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 555.95);
INSERT INTO order_details VALUES (59, 10270, 36, 15.1999998, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 456.00);
INSERT INTO order_details VALUES (60, 10270, 43, 36.7999992, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 920.00);
INSERT INTO order_details VALUES (61, 10271, 33, 2, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (62, 10272, 20, 64.8000031, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.80);
INSERT INTO order_details VALUES (63, 10272, 31, 10, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (64, 10272, 72, 27.7999992, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 667.20);
INSERT INTO order_details VALUES (65, 10273, 10, 24.7999992, 24, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 595.15);
INSERT INTO order_details VALUES (66, 10273, 31, 10, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 149.95);
INSERT INTO order_details VALUES (67, 10273, 33, 2, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (68, 10273, 40, 14.6999998, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 881.95);
INSERT INTO order_details VALUES (69, 10273, 76, 14.3999996, 33, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 475.15);
INSERT INTO order_details VALUES (70, 10274, 71, 17.2000008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 344.00);
INSERT INTO order_details VALUES (71, 10274, 72, 27.7999992, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.60);
INSERT INTO order_details VALUES (72, 10275, 24, 3.5999999, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 43.15);
INSERT INTO order_details VALUES (73, 10275, 59, 44, 6, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 263.95);
INSERT INTO order_details VALUES (74, 10276, 10, 24.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 372.00);
INSERT INTO order_details VALUES (2003, 11024, 26, 31.2299995, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 374.76);
INSERT INTO order_details VALUES (2004, 11024, 33, 2.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (2005, 11024, 65, 21.0499992, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 442.05);
INSERT INTO order_details VALUES (2006, 11024, 71, 21.5, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1075.00);
INSERT INTO order_details VALUES (2009, 11026, 18, 62.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (2010, 11026, 51, 53, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 530.00);
INSERT INTO order_details VALUES (2011, 11027, 24, 4.5, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 134.75);
INSERT INTO order_details VALUES (2012, 11027, 62, 49.2999992, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1035.05);
INSERT INTO order_details VALUES (2015, 11029, 56, 38, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (2016, 11029, 63, 43.9000015, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 526.80);
INSERT INTO order_details VALUES (2017, 11030, 2, 19, 100, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1899.75);
INSERT INTO order_details VALUES (2018, 11030, 5, 21.3500004, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1494.50);
INSERT INTO order_details VALUES (2019, 11030, 29, 123.790001, 60, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7427.15);
INSERT INTO order_details VALUES (2020, 11030, 59, 55, 100, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 5499.75);
INSERT INTO order_details VALUES (2021, 11031, 1, 18, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 810.00);
INSERT INTO order_details VALUES (2022, 11031, 13, 6, 80, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 480.00);
INSERT INTO order_details VALUES (2023, 11031, 24, 4.5, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 94.50);
INSERT INTO order_details VALUES (2024, 11031, 64, 33.25, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 665.00);
INSERT INTO order_details VALUES (2025, 11031, 71, 21.5, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 344.00);
INSERT INTO order_details VALUES (2026, 11032, 36, 19, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 665.00);
INSERT INTO order_details VALUES (2027, 11032, 38, 263.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 6587.50);
INSERT INTO order_details VALUES (2028, 11032, 59, 55, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1650.00);
INSERT INTO order_details VALUES (2029, 11033, 53, 32.7999992, 70, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2295.90);
INSERT INTO order_details VALUES (2030, 11033, 69, 36, 36, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1295.90);
INSERT INTO order_details VALUES (2037, 11035, 54, 7.44999981, 10, 0, 1, NULL, NULL, 2, '2019-08-28 10:36:21.281009', 'F', 'F', 1, 74.50);
INSERT INTO order_details VALUES (2001, 11023, 7, 30, 4, 0, 1, NULL, NULL, 2, '2019-08-29 05:31:36.959713', 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (2002, 11023, 43, 46, 30, 0, 2, NULL, NULL, 2, '2019-08-29 05:31:36.959713', 'F', 'F', 1, 1380.00);
INSERT INTO order_details VALUES (32, 10259, 21, 8, 10, 0, 1, NULL, NULL, 2, '2019-08-29 05:33:29.783797', 'F', 'F', 1, 80.00);
INSERT INTO order_details VALUES (33, 10259, 37, 20.7999992, 1, 0, 2, NULL, NULL, 2, '2019-08-29 05:33:29.783797', 'F', 'F', 1, 20.80);
INSERT INTO order_details VALUES (2013, 11028, 55, 24, 35, 0, 1, NULL, NULL, 2, '2019-08-29 06:16:29.770175', 'F', 'F', 1, 840.00);
INSERT INTO order_details VALUES (2031, 11034, 21, 10, 15, 0.100000001, 1, NULL, NULL, 2, '2019-08-29 06:33:14.704284', 'F', 'F', 1, 149.90);
INSERT INTO order_details VALUES (2032, 11034, 44, 19.4500008, 12, 0, 2, NULL, NULL, 2, '2019-08-29 06:33:14.704284', 'F', 'F', 1, 233.40);
INSERT INTO order_details VALUES (2038, 11036, 13, 6, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 42.00);
INSERT INTO order_details VALUES (2041, 11038, 40, 18.3999996, 5, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 91.80);
INSERT INTO order_details VALUES (2042, 11038, 52, 7, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 14.00);
INSERT INTO order_details VALUES (2043, 11038, 71, 21.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 645.00);
INSERT INTO order_details VALUES (2160, 11078, 18, 62.5, 3, 0, 3, 2, '2019-08-05 06:27:23.816371', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (2155, NULL, 14, 23.25, 5, 0, 3, 2, '2019-08-01 12:03:53.793382', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 116.25);
INSERT INTO order_details VALUES (2156, NULL, 12, 38, 1, 0, 5, 2, '2019-08-02 04:12:12.249251', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 38.00);
INSERT INTO order_details VALUES (2158, 11083, 12, 38, 1, 0, 1, 2, '2019-08-05 05:54:58.185526', 2, '2019-08-27 11:26:10.918728', 'F', 'F', 1, 38.00);
INSERT INTO order_details VALUES (75, 10276, 13, 4.80000019, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (76, 10277, 28, 36.4000015, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 728.00);
INSERT INTO order_details VALUES (77, 10277, 62, 39.4000015, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 472.80);
INSERT INTO order_details VALUES (78, 10278, 44, 15.5, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 248.00);
INSERT INTO order_details VALUES (79, 10278, 59, 44, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 660.00);
INSERT INTO order_details VALUES (80, 10278, 63, 35.0999985, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 280.80);
INSERT INTO order_details VALUES (81, 10278, 73, 12, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (82, 10279, 17, 31.2000008, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 467.75);
INSERT INTO order_details VALUES (83, 10280, 24, 3.5999999, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 43.20);
INSERT INTO order_details VALUES (84, 10280, 55, 19.2000008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 384.00);
INSERT INTO order_details VALUES (85, 10280, 75, 6.19999981, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 186.00);
INSERT INTO order_details VALUES (86, 10281, 19, 7.30000019, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7.30);
INSERT INTO order_details VALUES (87, 10281, 24, 3.5999999, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 21.60);
INSERT INTO order_details VALUES (88, 10281, 35, 14.3999996, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.60);
INSERT INTO order_details VALUES (89, 10282, 30, 20.7000008, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 124.20);
INSERT INTO order_details VALUES (90, 10282, 57, 15.6000004, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 31.20);
INSERT INTO order_details VALUES (91, 10283, 15, 12.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 248.00);
INSERT INTO order_details VALUES (92, 10283, 19, 7.30000019, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 131.40);
INSERT INTO order_details VALUES (93, 10283, 60, 27.2000008, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 952.00);
INSERT INTO order_details VALUES (94, 10283, 72, 27.7999992, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 83.40);
INSERT INTO order_details VALUES (95, 10284, 27, 35.0999985, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 526.25);
INSERT INTO order_details VALUES (96, 10284, 44, 15.5, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 325.50);
INSERT INTO order_details VALUES (97, 10284, 60, 27.2000008, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 543.75);
INSERT INTO order_details VALUES (98, 10284, 67, 11.1999998, 5, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 55.75);
INSERT INTO order_details VALUES (99, 10285, 1, 14.3999996, 45, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 647.80);
INSERT INTO order_details VALUES (100, 10285, 40, 14.6999998, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 587.80);
INSERT INTO order_details VALUES (101, 10285, 53, 26.2000008, 36, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 943.00);
INSERT INTO order_details VALUES (102, 10286, 35, 14.3999996, 100, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1440.00);
INSERT INTO order_details VALUES (103, 10286, 62, 39.4000015, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1576.00);
INSERT INTO order_details VALUES (104, 10287, 16, 13.8999996, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 555.85);
INSERT INTO order_details VALUES (105, 10287, 34, 11.1999998, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 224.00);
INSERT INTO order_details VALUES (106, 10287, 46, 9.60000038, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 143.85);
INSERT INTO order_details VALUES (107, 10288, 54, 5.9000001, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 58.90);
INSERT INTO order_details VALUES (108, 10288, 68, 10, 3, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.90);
INSERT INTO order_details VALUES (109, 10289, 3, 8, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (110, 10289, 64, 26.6000004, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.40);
INSERT INTO order_details VALUES (111, 10290, 5, 17, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 340.00);
INSERT INTO order_details VALUES (112, 10290, 29, 99, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1485.00);
INSERT INTO order_details VALUES (113, 10290, 49, 16, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (114, 10290, 77, 10.3999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 104.00);
INSERT INTO order_details VALUES (115, 10291, 13, 4.80000019, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.90);
INSERT INTO order_details VALUES (116, 10291, 44, 15.5, 24, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 371.90);
INSERT INTO order_details VALUES (117, 10291, 51, 42.4000015, 2, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 84.70);
INSERT INTO order_details VALUES (118, 10292, 20, 64.8000031, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1296.00);
INSERT INTO order_details VALUES (119, 10293, 18, 50, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (120, 10293, 24, 3.5999999, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (121, 10293, 63, 35.0999985, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 175.50);
INSERT INTO order_details VALUES (122, 10293, 75, 6.19999981, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.20);
INSERT INTO order_details VALUES (123, 10294, 1, 14.3999996, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 259.20);
INSERT INTO order_details VALUES (124, 10294, 17, 31.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 468.00);
INSERT INTO order_details VALUES (125, 10294, 43, 36.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 552.00);
INSERT INTO order_details VALUES (126, 10294, 60, 27.2000008, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 571.20);
INSERT INTO order_details VALUES (127, 10294, 75, 6.19999981, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.20);
INSERT INTO order_details VALUES (128, 10295, 56, 30.3999996, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 121.60);
INSERT INTO order_details VALUES (129, 10296, 11, 16.7999992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 201.60);
INSERT INTO order_details VALUES (130, 10296, 16, 13.8999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 417.00);
INSERT INTO order_details VALUES (131, 10296, 69, 28.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (132, 10297, 39, 14.3999996, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 864.00);
INSERT INTO order_details VALUES (133, 10297, 72, 27.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 556.00);
INSERT INTO order_details VALUES (2158, 11081, 12, 38, 1, 0, 1, 2, '2019-08-16 04:17:24.861301', 2, '2019-08-21 05:58:12.234294', 'F', 'F', 1, 38.00);
INSERT INTO order_details VALUES (11, 10252, 20, 64.8000031, 40, 0.0500000007, 1, NULL, NULL, 2, '2019-08-26 08:18:19.054165', 'F', 'F', 1, 2591.95);
INSERT INTO order_details VALUES (12, 10252, 33, 2, 25, 0.0500000007, 2, NULL, NULL, 2, '2019-08-26 08:18:19.054165', 'F', 'F', 1, 49.95);
INSERT INTO order_details VALUES (13, 10252, 60, 27.2000008, 40, 0, 3, NULL, NULL, 2, '2019-08-26 08:18:19.054165', 'F', 'F', 1, 1088.00);
INSERT INTO order_details VALUES (14, 10253, 31, 10, 20, 0, 1, NULL, NULL, 2, '2019-08-26 08:20:58.167188', 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (2159, 11084, 20, 81, 2, 0, 1, 2, '2019-08-05 06:19:15.719863', 2, '2019-08-27 11:20:16.396792', 'F', 'F', 1, 162.00);
INSERT INTO order_details VALUES (1958, 11006, 1, 18, 8, 0, 1, NULL, NULL, 2, '2019-08-19 10:12:35.579597', 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (1959, 11006, 29, 123.790001, 2, 0.25, 2, NULL, NULL, 2, '2019-08-19 10:12:35.579597', 'F', 'F', 1, 247.33);
INSERT INTO order_details VALUES (2165, 11079, 19, 9.19999981, 2, 0, NULL, 2, '2019-08-06 05:24:41.350693', 2, '2019-08-06 05:33:39.826029', 'T', 'F', 1, 18.40);
INSERT INTO order_details VALUES (2155, 11081, 14, 23.25, 5, 0, 3, 2, '2019-08-16 04:17:03.615308', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 116.25);
INSERT INTO order_details VALUES (2156, 11081, 12, 38, 1, 0, 5, 2, '2019-08-16 04:17:03.615308', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 38.00);
INSERT INTO order_details VALUES (2157, 11081, 14, 23.25, 5, 0, 4, 2, '2019-08-16 04:17:24.861301', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 116.25);
INSERT INTO order_details VALUES (2159, 11081, 20, 81, 2, 0, 7, 2, '2019-08-16 04:17:24.861301', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 162.00);
INSERT INTO order_details VALUES (2167, 11080, 10, 31, 5, 0, 8, 2, '2019-08-06 09:58:37.932418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (2160, 11079, 18, 62.5, 3, 0, 3, 2, '2019-08-16 04:18:43.07265', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (2161, 11078, 28, 45.5999985, 2, 0, 4, 2, '2019-08-05 11:53:10.835611', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 91.20);
INSERT INTO order_details VALUES (2161, 11079, 28, 45.5999985, 2, 0, 4, 2, '2019-08-16 04:20:20.313722', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 91.20);
INSERT INTO order_details VALUES (2162, 11078, 15, 13, 3, 0, 5, 2, '2019-08-05 11:53:10.835611', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 39.00);
INSERT INTO order_details VALUES (2162, 11079, 15, 13, 3, 0, 5, 2, '2019-08-16 04:20:20.313722', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 39.00);
INSERT INTO order_details VALUES (735, 10525, 36, 19, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (2, 10248, 72, 34.7999992, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 174.00);
INSERT INTO order_details VALUES (2051, 11042, 44, 19.4500008, 15, 0, 2, NULL, NULL, 2, '2019-08-28 10:43:37.783319', 'F', 'F', 1, 291.75);
INSERT INTO order_details VALUES (2157, 11082, 14, 23.25, 5, 0, 1, 2, '2019-08-05 05:49:57.647381', 2, '2019-08-28 10:48:45.42041', 'F', 'F', 1, 116.25);
INSERT INTO order_details VALUES (2050, 11041, 63, 43.9000015, 30, 0, 1, NULL, NULL, 2, '2019-08-29 05:37:16.083516', 'F', 'F', 1, 1317.00);
INSERT INTO order_details VALUES (2044, 11039, 28, 45.5999985, 20, 0, 1, NULL, NULL, 2, '2019-08-29 06:24:33.789648', 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (2045, 11039, 35, 18, 24, 0, 2, NULL, NULL, 2, '2019-08-29 06:24:33.789648', 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (1580, 10850, 33, 2.5, 4, 0.150000006, 2, NULL, NULL, 2, '2019-08-29 07:21:56.115537', 'F', 'F', 1, 9.85);
INSERT INTO order_details VALUES (1581, 10850, 70, 15, 30, 0.150000006, 3, NULL, NULL, 2, '2019-08-29 07:21:56.115537', 'F', 'F', 1, 449.85);
INSERT INTO order_details VALUES (541, 10451, 77, 10.3999996, 55, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 571.90);
INSERT INTO order_details VALUES (542, 10452, 28, 36.4000015, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 546.00);
INSERT INTO order_details VALUES (543, 10452, 44, 15.5, 100, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1549.95);
INSERT INTO order_details VALUES (544, 10453, 48, 10.1999998, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 152.90);
INSERT INTO order_details VALUES (545, 10453, 70, 12, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 299.90);
INSERT INTO order_details VALUES (546, 10454, 16, 13.8999996, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 277.80);
INSERT INTO order_details VALUES (547, 10454, 33, 2, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 39.80);
INSERT INTO order_details VALUES (548, 10454, 46, 9.60000038, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.80);
INSERT INTO order_details VALUES (549, 10455, 39, 14.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (550, 10455, 53, 26.2000008, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1310.00);
INSERT INTO order_details VALUES (551, 10455, 61, 22.7999992, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (552, 10455, 71, 17.2000008, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 516.00);
INSERT INTO order_details VALUES (553, 10456, 21, 8, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 319.85);
INSERT INTO order_details VALUES (554, 10456, 49, 16, 21, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 335.85);
INSERT INTO order_details VALUES (555, 10457, 59, 44, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1584.00);
INSERT INTO order_details VALUES (556, 10458, 26, 24.8999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 747.00);
INSERT INTO order_details VALUES (557, 10458, 28, 36.4000015, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1092.00);
INSERT INTO order_details VALUES (558, 10458, 43, 36.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 736.00);
INSERT INTO order_details VALUES (559, 10458, 56, 30.3999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 456.00);
INSERT INTO order_details VALUES (560, 10458, 71, 17.2000008, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 860.00);
INSERT INTO order_details VALUES (561, 10459, 7, 24, 16, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 383.95);
INSERT INTO order_details VALUES (562, 10459, 46, 9.60000038, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 191.95);
INSERT INTO order_details VALUES (563, 10459, 72, 27.7999992, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1112.00);
INSERT INTO order_details VALUES (564, 10460, 68, 10, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 209.75);
INSERT INTO order_details VALUES (565, 10460, 75, 6.19999981, 4, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 24.55);
INSERT INTO order_details VALUES (566, 10461, 21, 8, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 319.75);
INSERT INTO order_details VALUES (567, 10461, 30, 20.7000008, 28, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 579.35);
INSERT INTO order_details VALUES (568, 10461, 55, 19.2000008, 60, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1151.75);
INSERT INTO order_details VALUES (569, 10462, 13, 4.80000019, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4.80);
INSERT INTO order_details VALUES (570, 10462, 23, 7.19999981, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 151.20);
INSERT INTO order_details VALUES (571, 10463, 19, 7.30000019, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 153.30);
INSERT INTO order_details VALUES (572, 10463, 42, 11.1999998, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (573, 10464, 4, 17.6000004, 16, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 281.40);
INSERT INTO order_details VALUES (574, 10464, 43, 36.7999992, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.40);
INSERT INTO order_details VALUES (575, 10464, 56, 30.3999996, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 911.80);
INSERT INTO order_details VALUES (576, 10464, 60, 27.2000008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 544.00);
INSERT INTO order_details VALUES (577, 10465, 24, 3.5999999, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (602, 10474, 40, 14.6999998, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 308.70);
INSERT INTO order_details VALUES (603, 10474, 75, 6.19999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.00);
INSERT INTO order_details VALUES (604, 10475, 31, 10, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 349.85);
INSERT INTO order_details VALUES (605, 10475, 66, 13.6000004, 60, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 815.85);
INSERT INTO order_details VALUES (606, 10475, 76, 14.3999996, 42, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 604.65);
INSERT INTO order_details VALUES (607, 10476, 55, 19.2000008, 2, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 38.35);
INSERT INTO order_details VALUES (608, 10476, 70, 12, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (609, 10477, 1, 14.3999996, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 216.00);
INSERT INTO order_details VALUES (610, 10477, 21, 8, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.75);
INSERT INTO order_details VALUES (611, 10477, 39, 14.3999996, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.75);
INSERT INTO order_details VALUES (612, 10478, 10, 24.7999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 495.95);
INSERT INTO order_details VALUES (613, 10479, 38, 210.800003, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 6324.00);
INSERT INTO order_details VALUES (614, 10479, 53, 26.2000008, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 733.60);
INSERT INTO order_details VALUES (513, 10442, 11, 16.7999992, 30, 0, 1, NULL, NULL, 2, '2019-08-28 04:29:14.467374', 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (618, 10480, 59, 44, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 528.00);
INSERT INTO order_details VALUES (619, 10481, 49, 16, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 384.00);
INSERT INTO order_details VALUES (620, 10481, 60, 27.2000008, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1088.00);
INSERT INTO order_details VALUES (621, 10482, 40, 14.6999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 147.00);
INSERT INTO order_details VALUES (622, 10483, 34, 11.1999998, 35, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 391.95);
INSERT INTO order_details VALUES (623, 10483, 77, 10.3999996, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 311.95);
INSERT INTO order_details VALUES (624, 10484, 21, 8, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (3, 10249, 14, 18.6000004, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.40);
INSERT INTO order_details VALUES (4, 10249, 51, 42.4000015, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1696.00);
INSERT INTO order_details VALUES (5, 10250, 41, 7.69999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 77.00);
INSERT INTO order_details VALUES (6, 10250, 51, 42.4000015, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1483.85);
INSERT INTO order_details VALUES (7, 10250, 65, 16.7999992, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.85);
INSERT INTO order_details VALUES (8, 10251, 22, 16.7999992, 6, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.75);
INSERT INTO order_details VALUES (9, 10251, 57, 15.6000004, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 233.95);
INSERT INTO order_details VALUES (10, 10251, 65, 16.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 336.00);
INSERT INTO order_details VALUES (2163, 11079, 19, 9.19999981, 1, 0, 6, 2, '2019-08-16 04:20:20.313722', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 9.20);
INSERT INTO order_details VALUES (2164, 11079, 2, 19, 1, 0, 1, 2, '2019-08-06 05:24:41.350693', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 19.00);
INSERT INTO order_details VALUES (2164, 11079, 2, 19, 1, 0, 1, 2, '2019-08-16 04:20:20.313722', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 19.00);
INSERT INTO order_details VALUES (2166, 11079, 15, 13, 2, 0, 2, 2, '2019-08-06 05:33:39.826029', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 26.00);
INSERT INTO order_details VALUES (2165, 11079, 18, 62.5, 3, 0, 7, 2, '2019-08-16 04:22:20.006252', NULL, NULL, 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (134, 10298, 2, 15.1999998, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (29, 10258, 2, 15.1999998, 50, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:28:47.801201', 'F', 'F', 1, 759.80);
INSERT INTO order_details VALUES (43, 10263, 16, 13.8999996, 60, 0.25, 1, NULL, NULL, 2, '2019-08-28 04:30:14.630269', 'F', 'F', 1, 833.75);
INSERT INTO order_details VALUES (44, 10263, 24, 3.5999999, 28, 0, 2, NULL, NULL, 2, '2019-08-28 04:30:14.630269', 'F', 'F', 1, 100.80);
INSERT INTO order_details VALUES (135, 10298, 36, 15.1999998, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 607.75);
INSERT INTO order_details VALUES (136, 10298, 59, 44, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1319.75);
INSERT INTO order_details VALUES (137, 10298, 62, 39.4000015, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 591.00);
INSERT INTO order_details VALUES (138, 10299, 19, 7.30000019, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 109.50);
INSERT INTO order_details VALUES (17, 10254, 24, 3.5999999, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 53.85);
INSERT INTO order_details VALUES (18, 10254, 55, 19.2000008, 21, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 403.05);
INSERT INTO order_details VALUES (19, 10254, 74, 8, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 168.00);
INSERT INTO order_details VALUES (255, 10343, 64, 26.6000004, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1330.00);
INSERT INTO order_details VALUES (256, 10343, 68, 10, 4, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 39.95);
INSERT INTO order_details VALUES (375, 10389, 55, 19.2000008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (376, 10389, 62, 39.4000015, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 788.00);
INSERT INTO order_details VALUES (495, 10435, 72, 27.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 278.00);
INSERT INTO order_details VALUES (496, 10436, 46, 9.60000038, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.00);
INSERT INTO order_details VALUES (497, 10436, 56, 30.3999996, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1215.90);
INSERT INTO order_details VALUES (615, 10479, 59, 44, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2640.00);
INSERT INTO order_details VALUES (616, 10479, 64, 26.6000004, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 798.00);
INSERT INTO order_details VALUES (617, 10480, 47, 7.5999999, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 228.00);
INSERT INTO order_details VALUES (736, 10525, 40, 18.3999996, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 275.90);
INSERT INTO order_details VALUES (737, 10526, 1, 18, 8, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 143.85);
INSERT INTO order_details VALUES (738, 10526, 13, 6, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (855, 10567, 51, 53, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.00);
INSERT INTO order_details VALUES (856, 10567, 59, 55, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2199.80);
INSERT INTO order_details VALUES (857, 10568, 10, 31, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (163, 10309, 4, 17.6000004, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 352.00);
INSERT INTO order_details VALUES (164, 10309, 6, 20, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (165, 10309, 42, 11.1999998, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 22.40);
INSERT INTO order_details VALUES (166, 10309, 43, 36.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 736.00);
INSERT INTO order_details VALUES (167, 10309, 71, 17.2000008, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 51.60);
INSERT INTO order_details VALUES (168, 10310, 16, 13.8999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.00);
INSERT INTO order_details VALUES (169, 10310, 62, 39.4000015, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 197.00);
INSERT INTO order_details VALUES (170, 10311, 42, 11.1999998, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 67.20);
INSERT INTO order_details VALUES (171, 10311, 69, 28.7999992, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 201.60);
INSERT INTO order_details VALUES (172, 10312, 28, 36.4000015, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 145.60);
INSERT INTO order_details VALUES (173, 10312, 43, 36.7999992, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 883.20);
INSERT INTO order_details VALUES (174, 10312, 53, 26.2000008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 524.00);
INSERT INTO order_details VALUES (175, 10312, 75, 6.19999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.00);
INSERT INTO order_details VALUES (176, 10313, 36, 15.1999998, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 182.40);
INSERT INTO order_details VALUES (177, 10314, 32, 25.6000004, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1023.90);
INSERT INTO order_details VALUES (178, 10314, 58, 10.6000004, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 317.90);
INSERT INTO order_details VALUES (2221, 11097, 81, 50, 22, 0, 3, 2, '2019-08-26 06:31:20.890637', 2, '2019-09-06 04:24:59.007874', 'F', 'F', 1, 1100.00);
INSERT INTO order_details VALUES (2223, 11097, 8, 40, 5, 0, 4, 2, '2019-09-06 04:24:59.007874', NULL, NULL, 'F', 'F', 6, 200.00);
INSERT INTO order_details VALUES (2224, 11098, 21, 10, 20, 0, 2, 2, '2019-09-06 04:28:30.118452', NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (625, 10484, 40, 14.6999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 147.00);
INSERT INTO order_details VALUES (626, 10484, 51, 42.4000015, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 127.20);
INSERT INTO order_details VALUES (627, 10485, 2, 15.1999998, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 303.90);
INSERT INTO order_details VALUES (628, 10485, 3, 8, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.90);
INSERT INTO order_details VALUES (629, 10485, 55, 19.2000008, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 575.90);
INSERT INTO order_details VALUES (630, 10485, 70, 12, 60, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.90);
INSERT INTO order_details VALUES (631, 10486, 11, 16.7999992, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 84.00);
INSERT INTO order_details VALUES (632, 10486, 51, 42.4000015, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1060.00);
INSERT INTO order_details VALUES (633, 10486, 74, 8, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 128.00);
INSERT INTO order_details VALUES (634, 10487, 19, 7.30000019, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.50);
INSERT INTO order_details VALUES (635, 10487, 26, 24.8999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 747.00);
INSERT INTO order_details VALUES (636, 10487, 54, 5.9000001, 24, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 141.35);
INSERT INTO order_details VALUES (637, 10488, 59, 44, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1320.00);
INSERT INTO order_details VALUES (638, 10488, 73, 12, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.80);
INSERT INTO order_details VALUES (641, 10490, 59, 44, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2640.00);
INSERT INTO order_details VALUES (642, 10490, 68, 10, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (643, 10490, 75, 6.19999981, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.20);
INSERT INTO order_details VALUES (644, 10491, 44, 15.5, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 232.35);
INSERT INTO order_details VALUES (645, 10491, 77, 10.3999996, 7, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.65);
INSERT INTO order_details VALUES (646, 10492, 25, 11.1999998, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 671.95);
INSERT INTO order_details VALUES (647, 10492, 42, 11.1999998, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.95);
INSERT INTO order_details VALUES (648, 10493, 65, 16.7999992, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.90);
INSERT INTO order_details VALUES (649, 10493, 66, 13.6000004, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 135.90);
INSERT INTO order_details VALUES (650, 10493, 69, 28.7999992, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 287.90);
INSERT INTO order_details VALUES (651, 10494, 56, 30.3999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (652, 10495, 23, 7.19999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.00);
INSERT INTO order_details VALUES (653, 10495, 41, 7.69999981, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 154.00);
INSERT INTO order_details VALUES (654, 10495, 77, 10.3999996, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 52.00);
INSERT INTO order_details VALUES (655, 10496, 31, 10, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 199.95);
INSERT INTO order_details VALUES (656, 10497, 56, 30.3999996, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 425.60);
INSERT INTO order_details VALUES (657, 10497, 72, 27.7999992, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 695.00);
INSERT INTO order_details VALUES (658, 10497, 77, 10.3999996, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 260.00);
INSERT INTO order_details VALUES (659, 10498, 24, 4.5, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 63.00);
INSERT INTO order_details VALUES (660, 10498, 40, 18.3999996, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 92.00);
INSERT INTO order_details VALUES (661, 10498, 42, 14, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (662, 10499, 28, 45.5999985, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (663, 10499, 49, 20, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (664, 10500, 15, 15.5, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 185.95);
INSERT INTO order_details VALUES (665, 10500, 28, 45.5999985, 8, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 364.75);
INSERT INTO order_details VALUES (666, 10501, 54, 7.44999981, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 149.00);
INSERT INTO order_details VALUES (667, 10502, 45, 9.5, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 199.50);
INSERT INTO order_details VALUES (668, 10502, 53, 32.7999992, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 196.80);
INSERT INTO order_details VALUES (669, 10502, 67, 14, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (670, 10503, 14, 23.25, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1627.50);
INSERT INTO order_details VALUES (671, 10503, 65, 21.0499992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 421.00);
INSERT INTO order_details VALUES (672, 10504, 2, 19, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 228.00);
INSERT INTO order_details VALUES (673, 10504, 21, 10, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (674, 10504, 53, 32.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 328.00);
INSERT INTO order_details VALUES (179, 10314, 62, 39.4000015, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 984.90);
INSERT INTO order_details VALUES (180, 10315, 34, 11.1999998, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 156.80);
INSERT INTO order_details VALUES (181, 10315, 70, 12, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (182, 10316, 41, 7.69999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 77.00);
INSERT INTO order_details VALUES (183, 10316, 62, 39.4000015, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2758.00);
INSERT INTO order_details VALUES (184, 10317, 1, 14.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (185, 10318, 41, 7.69999981, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 154.00);
INSERT INTO order_details VALUES (186, 10318, 76, 14.3999996, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 86.40);
INSERT INTO order_details VALUES (2225, 11099, 78, 5, 30, 0, 1, 2, '2019-09-19 04:17:31.738566', NULL, NULL, 'F', 'F', 6, 150.00);
INSERT INTO order_details VALUES (2226, 11099, 85, 150, 20, 0, 2, 2, '2019-09-19 04:17:31.738566', NULL, NULL, 'F', 'F', 6, 3000.00);
INSERT INTO order_details VALUES (675, 10504, 61, 28.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 712.50);
INSERT INTO order_details VALUES (676, 10505, 62, 49.2999992, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 147.90);
INSERT INTO order_details VALUES (677, 10506, 25, 14, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.90);
INSERT INTO order_details VALUES (2227, 11100, 3, 10, 50, 0, 3, 2, '2019-10-05 09:24:51.602566', NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (2228, 11100, 32, 32, 78, 0, 2, 2, '2019-10-05 09:24:51.602566', NULL, NULL, 'F', 'F', 1, 2496.00);
INSERT INTO order_details VALUES (2229, 11101, 1, 18, 11, 0, 3, 2, '2019-10-05 16:36:50.655511', NULL, NULL, 'F', 'F', 6, 198.00);
INSERT INTO order_details VALUES (2230, 11101, 3, 10, 72, 0, 2, 2, '2019-10-05 16:36:50.655511', NULL, NULL, 'F', 'F', 6, 720.00);
INSERT INTO order_details VALUES (828, 10556, 72, 34.7999992, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 835.20);
INSERT INTO order_details VALUES (829, 10557, 64, 33.25, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 997.50);
INSERT INTO order_details VALUES (830, 10557, 75, 7.75, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (895, 10583, 29, 123.790001, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1237.90);
INSERT INTO order_details VALUES (896, 10583, 60, 34, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 815.85);
INSERT INTO order_details VALUES (2107, 11068, 28, 45.5999985, 8, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 11:02:49.762899', 'F', 'F', 1, 364.65);
INSERT INTO order_details VALUES (2108, 11068, 43, 46, 36, 0.150000006, 3, NULL, NULL, 2, '2019-08-28 11:02:49.762899', 'F', 'F', 1, 1655.85);
INSERT INTO order_details VALUES (2106, 11067, 41, 9.64999962, 9, 0, 1, NULL, NULL, 2, '2019-08-29 05:46:25.542768', 'F', 'F', 1, 86.85);
INSERT INTO order_details VALUES (750, 10530, 61, 28.5, 20, 0, 3, NULL, NULL, 2, '2019-08-28 04:40:32.027363', 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (751, 10530, 76, 18, 50, 0, 4, NULL, NULL, 2, '2019-08-28 04:40:32.027363', 'F', 'F', 1, 900.00);
INSERT INTO order_details VALUES (927, 10597, 65, 21.0499992, 12, 0.200000003, 3, NULL, NULL, 2, '2019-08-28 04:40:38.992488', 'F', 'F', 1, 252.40);
INSERT INTO order_details VALUES (2049, 11041, 2, 19, 30, 0.200000003, 2, NULL, NULL, 2, '2019-08-29 05:37:16.083516', 'F', 'F', 1, 569.80);
INSERT INTO order_details VALUES (2048, 11040, 21, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (2046, 11039, 49, 20, 60, 0, 3, NULL, NULL, 2, '2019-08-29 06:24:33.789648', 'F', 'F', 1, 1200.00);
INSERT INTO order_details VALUES (2047, 11039, 57, 19.5, 28, 0, 4, NULL, NULL, 2, '2019-08-29 06:24:33.789648', 'F', 'F', 1, 546.00);
INSERT INTO order_details VALUES (2163, 11078, 19, 9.19999981, 1, 0, 6, 2, '2019-08-05 11:53:10.835611', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, 9.20);
INSERT INTO order_details VALUES (2192, 11006, 45, 9.5, 2, 0, 3, 2, '2019-08-19 10:12:35.579597', NULL, NULL, 'F', 'F', 1, 19.00);
INSERT INTO order_details VALUES (1, 10248, 42, 9.80000019, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.00);
INSERT INTO order_details VALUES (187, 10319, 17, 31.2000008, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.60);
INSERT INTO order_details VALUES (188, 10319, 28, 36.4000015, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 509.60);
INSERT INTO order_details VALUES (189, 10319, 76, 14.3999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 432.00);
INSERT INTO order_details VALUES (190, 10320, 71, 17.2000008, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 516.00);
INSERT INTO order_details VALUES (191, 10321, 35, 14.3999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (192, 10322, 52, 5.5999999, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.00);
INSERT INTO order_details VALUES (193, 10323, 15, 12.3999996, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.00);
INSERT INTO order_details VALUES (194, 10323, 25, 11.1999998, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.80);
INSERT INTO order_details VALUES (195, 10323, 39, 14.3999996, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.60);
INSERT INTO order_details VALUES (196, 10324, 16, 13.8999996, 21, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 291.75);
INSERT INTO order_details VALUES (197, 10324, 35, 14.3999996, 70, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1007.85);
INSERT INTO order_details VALUES (198, 10324, 46, 9.60000038, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (199, 10324, 59, 44, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1759.85);
INSERT INTO order_details VALUES (200, 10324, 63, 35.0999985, 80, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2807.85);
INSERT INTO order_details VALUES (201, 10325, 6, 20, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (202, 10325, 13, 4.80000019, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.60);
INSERT INTO order_details VALUES (203, 10325, 14, 18.6000004, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.40);
INSERT INTO order_details VALUES (204, 10325, 31, 10, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (205, 10325, 72, 27.7999992, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1112.00);
INSERT INTO order_details VALUES (206, 10326, 4, 17.6000004, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 422.40);
INSERT INTO order_details VALUES (207, 10326, 57, 15.6000004, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.60);
INSERT INTO order_details VALUES (208, 10326, 75, 6.19999981, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 310.00);
INSERT INTO order_details VALUES (209, 10327, 2, 15.1999998, 25, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.80);
INSERT INTO order_details VALUES (210, 10327, 11, 16.7999992, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 839.80);
INSERT INTO order_details VALUES (211, 10327, 30, 20.7000008, 35, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 724.30);
INSERT INTO order_details VALUES (212, 10327, 58, 10.6000004, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 317.80);
INSERT INTO order_details VALUES (1977, 11013, 42, 14, 4, 0, 1, NULL, NULL, 2, '2019-08-29 06:57:09.202606', 'F', 'F', 1, 56.00);
INSERT INTO order_details VALUES (1978, 11013, 45, 9.5, 20, 0, 2, NULL, NULL, 2, '2019-08-29 06:57:09.202606', 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (1979, 11013, 68, 12.5, 2, 0, 3, NULL, NULL, 2, '2019-08-29 06:57:09.202606', 'F', 'F', 1, 25.00);
INSERT INTO order_details VALUES (994, 10624, 28, 45.5999985, 10, 0, 1, NULL, NULL, 2, '2019-08-29 07:17:13.34918', 'F', 'F', 1, 456.00);
INSERT INTO order_details VALUES (995, 10624, 29, 123.790001, 6, 0, 2, NULL, NULL, 2, '2019-08-29 07:17:13.34918', 'F', 'F', 1, 742.74);
INSERT INTO order_details VALUES (996, 10624, 44, 19.4500008, 10, 0, 3, NULL, NULL, 2, '2019-08-29 07:17:13.34918', 'F', 'F', 1, 194.50);
INSERT INTO order_details VALUES (213, 10328, 59, 44, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 396.00);
INSERT INTO order_details VALUES (214, 10328, 65, 16.7999992, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 672.00);
INSERT INTO order_details VALUES (215, 10328, 68, 10, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (975, 10617, 59, 55, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1649.85);
INSERT INTO order_details VALUES (976, 10618, 6, 25, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1750.00);
INSERT INTO order_details VALUES (1980, 11014, 41, 9.64999962, 28, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 270.10);
INSERT INTO order_details VALUES (959, 10611, 60, 34, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 510.00);
INSERT INTO order_details VALUES (960, 10612, 10, 31, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2170.00);
INSERT INTO order_details VALUES (961, 10612, 36, 19, 55, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1045.00);
INSERT INTO order_details VALUES (962, 10612, 49, 20, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (963, 10612, 60, 34, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1360.00);
INSERT INTO order_details VALUES (964, 10612, 76, 18, 80, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1440.00);
INSERT INTO order_details VALUES (965, 10613, 13, 6, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 47.90);
INSERT INTO order_details VALUES (966, 10613, 75, 7.75, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 310.00);
INSERT INTO order_details VALUES (967, 10614, 11, 21, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 294.00);
INSERT INTO order_details VALUES (968, 10614, 21, 10, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 80.00);
INSERT INTO order_details VALUES (969, 10614, 39, 18, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (970, 10615, 55, 24, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (971, 10616, 38, 263.5, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3952.45);
INSERT INTO order_details VALUES (972, 10616, 56, 38, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 532.00);
INSERT INTO order_details VALUES (973, 10616, 70, 15, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 224.95);
INSERT INTO order_details VALUES (974, 10616, 71, 21.5, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 322.45);
INSERT INTO order_details VALUES (919, 10595, 35, 18, 30, 0.25, 1, NULL, NULL, 2, '2019-08-28 04:29:30.002937', 'F', 'F', 1, 539.75);
INSERT INTO order_details VALUES (925, 10597, 24, 4.5, 35, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:40:38.992488', 'F', 'F', 1, 157.30);
INSERT INTO order_details VALUES (926, 10597, 57, 19.5, 20, 0, 2, NULL, NULL, 2, '2019-08-28 04:40:38.992488', 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (977, 10618, 56, 38, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (978, 10618, 68, 12.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (979, 10619, 21, 10, 42, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (980, 10619, 22, 21, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 840.00);
INSERT INTO order_details VALUES (981, 10620, 24, 4.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 22.50);
INSERT INTO order_details VALUES (982, 10620, 52, 7, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.00);
INSERT INTO order_details VALUES (983, 10621, 19, 9.19999981, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 46.00);
INSERT INTO order_details VALUES (984, 10621, 23, 9, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (985, 10621, 70, 15, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (986, 10621, 71, 21.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 322.50);
INSERT INTO order_details VALUES (987, 10622, 2, 19, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (988, 10622, 68, 12.5, 18, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 224.80);
INSERT INTO order_details VALUES (989, 10623, 14, 23.25, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 488.25);
INSERT INTO order_details VALUES (990, 10623, 19, 9.19999981, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 137.90);
INSERT INTO order_details VALUES (991, 10623, 21, 10, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.90);
INSERT INTO order_details VALUES (992, 10623, 24, 4.5, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 13.50);
INSERT INTO order_details VALUES (993, 10623, 35, 18, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 539.90);
INSERT INTO order_details VALUES (997, 10625, 14, 23.25, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 69.75);
INSERT INTO order_details VALUES (998, 10625, 42, 14, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (999, 10625, 60, 34, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 340.00);
INSERT INTO order_details VALUES (1040, 10643, 39, 18, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 377.75);
INSERT INTO order_details VALUES (1041, 10643, 46, 12, 2, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 23.75);
INSERT INTO order_details VALUES (1042, 10644, 18, 62.5, 4, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.90);
INSERT INTO order_details VALUES (1043, 10644, 43, 46, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 920.00);
INSERT INTO order_details VALUES (1044, 10644, 46, 12, 21, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.90);
INSERT INTO order_details VALUES (1045, 10645, 18, 62.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1250.00);
INSERT INTO order_details VALUES (1046, 10645, 36, 19, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (1047, 10646, 1, 18, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 269.75);
INSERT INTO order_details VALUES (1048, 10646, 10, 31, 18, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 557.75);
INSERT INTO order_details VALUES (1049, 10646, 71, 21.5, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 644.75);
INSERT INTO order_details VALUES (1050, 10646, 77, 13, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 454.75);
INSERT INTO order_details VALUES (1051, 10647, 19, 9.19999981, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 276.00);
INSERT INTO order_details VALUES (1052, 10647, 39, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1053, 10648, 22, 21, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 315.00);
INSERT INTO order_details VALUES (1054, 10648, 24, 4.5, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 67.35);
INSERT INTO order_details VALUES (1055, 10649, 28, 45.5999985, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (1056, 10649, 72, 34.7999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 522.00);
INSERT INTO order_details VALUES (1057, 10650, 30, 25.8899994, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 776.70);
INSERT INTO order_details VALUES (1058, 10650, 53, 32.7999992, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 819.95);
INSERT INTO order_details VALUES (1059, 10650, 54, 7.44999981, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.50);
INSERT INTO order_details VALUES (1060, 10651, 19, 9.19999981, 12, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.15);
INSERT INTO order_details VALUES (1061, 10651, 22, 21, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 419.75);
INSERT INTO order_details VALUES (1062, 10652, 30, 25.8899994, 2, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 51.53);
INSERT INTO order_details VALUES (1063, 10652, 42, 14, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 280.00);
INSERT INTO order_details VALUES (1064, 10653, 16, 17.4500008, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.40);
INSERT INTO order_details VALUES (1065, 10653, 60, 34, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 679.90);
INSERT INTO order_details VALUES (1066, 10654, 4, 22, 12, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 263.90);
INSERT INTO order_details VALUES (1067, 10654, 39, 18, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.90);
INSERT INTO order_details VALUES (1068, 10654, 54, 7.44999981, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.60);
INSERT INTO order_details VALUES (1069, 10655, 41, 9.64999962, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.80);
INSERT INTO order_details VALUES (1070, 10656, 14, 23.25, 3, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 69.65);
INSERT INTO order_details VALUES (1071, 10656, 44, 19.4500008, 28, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 544.50);
INSERT INTO order_details VALUES (1072, 10656, 47, 9.5, 6, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 56.90);
INSERT INTO order_details VALUES (1073, 10657, 15, 15.5, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 775.00);
INSERT INTO order_details VALUES (1074, 10657, 41, 9.64999962, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 231.60);
INSERT INTO order_details VALUES (1075, 10657, 46, 12, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (1076, 10657, 47, 9.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.00);
INSERT INTO order_details VALUES (1077, 10657, 56, 38, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1710.00);
INSERT INTO order_details VALUES (1078, 10657, 60, 34, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1020.00);
INSERT INTO order_details VALUES (1079, 10658, 21, 10, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (1080, 10658, 40, 18.3999996, 70, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1287.95);
INSERT INTO order_details VALUES (1081, 10658, 60, 34, 55, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1869.95);
INSERT INTO order_details VALUES (1082, 10658, 77, 13, 70, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 909.95);
INSERT INTO order_details VALUES (1083, 10659, 31, 12.5, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.95);
INSERT INTO order_details VALUES (1084, 10659, 40, 18.3999996, 24, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 441.55);
INSERT INTO order_details VALUES (1085, 10659, 70, 15, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 599.95);
INSERT INTO order_details VALUES (1087, 10661, 39, 18, 3, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 53.80);
INSERT INTO order_details VALUES (1088, 10661, 58, 13.25, 49, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 649.05);
INSERT INTO order_details VALUES (1089, 10662, 68, 12.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 125.00);
INSERT INTO order_details VALUES (1090, 10663, 40, 18.3999996, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 551.95);
INSERT INTO order_details VALUES (1091, 10663, 42, 14, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 419.95);
INSERT INTO order_details VALUES (1092, 10663, 51, 53, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1059.95);
INSERT INTO order_details VALUES (1093, 10664, 10, 31, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 743.85);
INSERT INTO order_details VALUES (1094, 10664, 56, 38, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 455.85);
INSERT INTO order_details VALUES (1134, 10680, 16, 17.4500008, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 872.25);
INSERT INTO order_details VALUES (1135, 10680, 31, 12.5, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 249.75);
INSERT INTO order_details VALUES (1136, 10680, 42, 14, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 559.75);
INSERT INTO order_details VALUES (1095, 10664, 65, 21.0499992, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 315.60);
INSERT INTO order_details VALUES (1096, 10665, 51, 53, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1060.00);
INSERT INTO order_details VALUES (1097, 10665, 59, 55, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 55.00);
INSERT INTO order_details VALUES (1098, 10665, 76, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1099, 10666, 29, 123.790001, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4456.44);
INSERT INTO order_details VALUES (1100, 10666, 65, 21.0499992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.50);
INSERT INTO order_details VALUES (1103, 10668, 31, 12.5, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 99.90);
INSERT INTO order_details VALUES (1104, 10668, 55, 24, 4, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.90);
INSERT INTO order_details VALUES (1105, 10668, 64, 33.25, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 498.65);
INSERT INTO order_details VALUES (1106, 10669, 36, 19, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (1107, 10670, 23, 9, 32, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (1108, 10670, 46, 12, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 720.00);
INSERT INTO order_details VALUES (1109, 10670, 67, 14, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 350.00);
INSERT INTO order_details VALUES (1110, 10670, 73, 15, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 750.00);
INSERT INTO order_details VALUES (1111, 10670, 75, 7.75, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 193.75);
INSERT INTO order_details VALUES (1112, 10671, 16, 17.4500008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 174.50);
INSERT INTO order_details VALUES (1113, 10671, 62, 49.2999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 493.00);
INSERT INTO order_details VALUES (1114, 10671, 65, 21.0499992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 252.60);
INSERT INTO order_details VALUES (1115, 10672, 38, 263.5, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3952.40);
INSERT INTO order_details VALUES (1116, 10672, 71, 21.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.00);
INSERT INTO order_details VALUES (1117, 10673, 16, 17.4500008, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 52.35);
INSERT INTO order_details VALUES (1118, 10673, 42, 14, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 84.00);
INSERT INTO order_details VALUES (1119, 10673, 43, 46, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 276.00);
INSERT INTO order_details VALUES (1120, 10674, 23, 9, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 45.00);
INSERT INTO order_details VALUES (1121, 10675, 14, 23.25, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 697.50);
INSERT INTO order_details VALUES (1122, 10675, 53, 32.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 328.00);
INSERT INTO order_details VALUES (1123, 10675, 58, 13.25, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 397.50);
INSERT INTO order_details VALUES (1124, 10676, 10, 31, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 62.00);
INSERT INTO order_details VALUES (1125, 10676, 19, 9.19999981, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 64.40);
INSERT INTO order_details VALUES (1126, 10676, 44, 19.4500008, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 408.45);
INSERT INTO order_details VALUES (1127, 10677, 26, 31.2299995, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 936.75);
INSERT INTO order_details VALUES (1128, 10677, 33, 2.5, 8, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 19.85);
INSERT INTO order_details VALUES (1129, 10678, 12, 38, 100, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3800.00);
INSERT INTO order_details VALUES (1130, 10678, 33, 2.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (1131, 10678, 41, 9.64999962, 120, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1158.00);
INSERT INTO order_details VALUES (1132, 10678, 54, 7.44999981, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 223.50);
INSERT INTO order_details VALUES (1133, 10679, 59, 55, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 660.00);
INSERT INTO order_details VALUES (1137, 10681, 19, 9.19999981, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 275.90);
INSERT INTO order_details VALUES (1138, 10681, 21, 10, 12, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 119.90);
INSERT INTO order_details VALUES (1139, 10681, 64, 33.25, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 931.00);
INSERT INTO order_details VALUES (1140, 10682, 33, 2.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (1141, 10682, 66, 17, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 68.00);
INSERT INTO order_details VALUES (1142, 10682, 75, 7.75, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 232.50);
INSERT INTO order_details VALUES (1143, 10683, 52, 7, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 63.00);
INSERT INTO order_details VALUES (1144, 10684, 40, 18.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 368.00);
INSERT INTO order_details VALUES (1145, 10684, 47, 9.5, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (1146, 10684, 60, 34, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1020.00);
INSERT INTO order_details VALUES (1147, 10685, 10, 31, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 620.00);
INSERT INTO order_details VALUES (1148, 10685, 41, 9.64999962, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 38.60);
INSERT INTO order_details VALUES (1149, 10685, 47, 9.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 142.50);
INSERT INTO order_details VALUES (1152, 10687, 9, 97, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4849.75);
INSERT INTO order_details VALUES (1153, 10687, 29, 123.790001, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1237.90);
INSERT INTO order_details VALUES (1154, 10687, 36, 19, 6, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 113.75);
INSERT INTO order_details VALUES (1155, 10688, 10, 31, 18, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 557.90);
INSERT INTO order_details VALUES (1156, 10688, 28, 45.5999985, 60, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2735.90);
INSERT INTO order_details VALUES (1157, 10688, 34, 14, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 196.00);
INSERT INTO order_details VALUES (1158, 10689, 1, 18, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 629.75);
INSERT INTO order_details VALUES (1159, 10690, 56, 38, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 759.75);
INSERT INTO order_details VALUES (1160, 10690, 77, 13, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 389.75);
INSERT INTO order_details VALUES (1161, 10691, 1, 18, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (1162, 10691, 29, 123.790001, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4951.60);
INSERT INTO order_details VALUES (1163, 10691, 43, 46, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1840.00);
INSERT INTO order_details VALUES (1164, 10691, 44, 19.4500008, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 466.80);
INSERT INTO order_details VALUES (1165, 10691, 62, 49.2999992, 48, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2366.40);
INSERT INTO order_details VALUES (1166, 10692, 63, 43.9000015, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 878.00);
INSERT INTO order_details VALUES (1167, 10693, 9, 97, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 582.00);
INSERT INTO order_details VALUES (1168, 10693, 54, 7.44999981, 60, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 446.85);
INSERT INTO order_details VALUES (1169, 10693, 69, 36, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1079.85);
INSERT INTO order_details VALUES (1170, 10693, 73, 15, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 224.85);
INSERT INTO order_details VALUES (1171, 10694, 7, 30, 90, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2700.00);
INSERT INTO order_details VALUES (1172, 10694, 59, 55, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1375.00);
INSERT INTO order_details VALUES (1173, 10694, 70, 15, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 750.00);
INSERT INTO order_details VALUES (1174, 10695, 8, 40, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (1175, 10695, 12, 38, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 152.00);
INSERT INTO order_details VALUES (1176, 10695, 24, 4.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1177, 10696, 17, 39, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 780.00);
INSERT INTO order_details VALUES (1178, 10696, 46, 12, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 216.00);
INSERT INTO order_details VALUES (1179, 10697, 19, 9.19999981, 7, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 64.15);
INSERT INTO order_details VALUES (1180, 10697, 35, 18, 9, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 161.75);
INSERT INTO order_details VALUES (1181, 10697, 58, 13.25, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 397.25);
INSERT INTO order_details VALUES (1182, 10697, 70, 15, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 449.75);
INSERT INTO order_details VALUES (1188, 10699, 47, 9.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 114.00);
INSERT INTO order_details VALUES (1189, 10700, 1, 18, 5, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 89.80);
INSERT INTO order_details VALUES (1190, 10700, 34, 14, 12, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.80);
INSERT INTO order_details VALUES (1191, 10700, 68, 12.5, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 499.80);
INSERT INTO order_details VALUES (1192, 10700, 71, 21.5, 60, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1289.80);
INSERT INTO order_details VALUES (1193, 10701, 59, 55, 42, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2309.85);
INSERT INTO order_details VALUES (1194, 10701, 71, 21.5, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 429.85);
INSERT INTO order_details VALUES (1195, 10701, 76, 18, 35, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 629.85);
INSERT INTO order_details VALUES (1196, 10702, 3, 10, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1197, 10702, 76, 18, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 270.00);
INSERT INTO order_details VALUES (1198, 10703, 2, 19, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.00);
INSERT INTO order_details VALUES (1199, 10703, 59, 55, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1925.00);
INSERT INTO order_details VALUES (1200, 10703, 73, 15, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 525.00);
INSERT INTO order_details VALUES (1201, 10704, 4, 22, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 132.00);
INSERT INTO order_details VALUES (1202, 10704, 24, 4.5, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 157.50);
INSERT INTO order_details VALUES (1203, 10704, 48, 12.75, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 306.00);
INSERT INTO order_details VALUES (1204, 10705, 31, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (1205, 10705, 32, 32, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 128.00);
INSERT INTO order_details VALUES (1254, 10722, 75, 7.75, 42, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 325.50);
INSERT INTO order_details VALUES (1255, 10723, 26, 31.2299995, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 468.45);
INSERT INTO order_details VALUES (1256, 10724, 10, 31, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 496.00);
INSERT INTO order_details VALUES (1206, 10706, 16, 17.4500008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 349.00);
INSERT INTO order_details VALUES (1207, 10706, 43, 46, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1104.00);
INSERT INTO order_details VALUES (1208, 10706, 59, 55, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 440.00);
INSERT INTO order_details VALUES (1209, 10707, 55, 24, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (1210, 10707, 57, 19.5, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 780.00);
INSERT INTO order_details VALUES (1211, 10707, 70, 15, 28, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 419.85);
INSERT INTO order_details VALUES (1212, 10708, 5, 21.3500004, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 85.40);
INSERT INTO order_details VALUES (1213, 10708, 36, 19, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 95.00);
INSERT INTO order_details VALUES (1214, 10709, 8, 40, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1600.00);
INSERT INTO order_details VALUES (1215, 10709, 51, 53, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1484.00);
INSERT INTO order_details VALUES (1216, 10709, 60, 34, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 340.00);
INSERT INTO order_details VALUES (1217, 10710, 19, 9.19999981, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 46.00);
INSERT INTO order_details VALUES (1218, 10710, 47, 9.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 47.50);
INSERT INTO order_details VALUES (1219, 10711, 19, 9.19999981, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.40);
INSERT INTO order_details VALUES (1220, 10711, 41, 9.64999962, 42, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 405.30);
INSERT INTO order_details VALUES (1221, 10711, 53, 32.7999992, 120, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 3936.00);
INSERT INTO order_details VALUES (1222, 10712, 53, 32.7999992, 3, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.35);
INSERT INTO order_details VALUES (1223, 10712, 56, 38, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1140.00);
INSERT INTO order_details VALUES (1224, 10713, 10, 31, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 558.00);
INSERT INTO order_details VALUES (1225, 10713, 26, 31.2299995, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 936.90);
INSERT INTO order_details VALUES (1226, 10713, 45, 9.5, 110, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1045.00);
INSERT INTO order_details VALUES (1227, 10713, 46, 12, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (1228, 10714, 2, 19, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.75);
INSERT INTO order_details VALUES (1229, 10714, 17, 39, 27, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1052.75);
INSERT INTO order_details VALUES (1230, 10714, 47, 9.5, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 474.75);
INSERT INTO order_details VALUES (1231, 10714, 56, 38, 18, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 683.75);
INSERT INTO order_details VALUES (1232, 10714, 58, 13.25, 12, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 158.75);
INSERT INTO order_details VALUES (1233, 10715, 10, 31, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 651.00);
INSERT INTO order_details VALUES (1234, 10715, 71, 21.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 645.00);
INSERT INTO order_details VALUES (1238, 10717, 21, 10, 32, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 319.95);
INSERT INTO order_details VALUES (1239, 10717, 54, 7.44999981, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 111.75);
INSERT INTO order_details VALUES (1240, 10717, 69, 36, 25, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 899.95);
INSERT INTO order_details VALUES (1241, 10718, 12, 38, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1368.00);
INSERT INTO order_details VALUES (1242, 10718, 16, 17.4500008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 349.00);
INSERT INTO order_details VALUES (1243, 10718, 36, 19, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (1244, 10718, 62, 49.2999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 986.00);
INSERT INTO order_details VALUES (1245, 10719, 18, 62.5, 12, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 749.75);
INSERT INTO order_details VALUES (1246, 10719, 30, 25.8899994, 3, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 77.42);
INSERT INTO order_details VALUES (1247, 10719, 54, 7.44999981, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 297.75);
INSERT INTO order_details VALUES (1248, 10720, 35, 18, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 378.00);
INSERT INTO order_details VALUES (1249, 10720, 71, 21.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 172.00);
INSERT INTO order_details VALUES (1250, 10721, 44, 19.4500008, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 972.45);
INSERT INTO order_details VALUES (1251, 10722, 2, 19, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.00);
INSERT INTO order_details VALUES (1252, 10722, 31, 12.5, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 625.00);
INSERT INTO order_details VALUES (1253, 10722, 68, 12.5, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 562.50);
INSERT INTO order_details VALUES (1183, 10698, 11, 21, 15, 0, 1, NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, 315.00);
INSERT INTO order_details VALUES (1184, 10698, 17, 39, 8, 0.0500000007, 2, NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, 311.95);
INSERT INTO order_details VALUES (1150, 10686, 17, 39, 30, 0.200000003, 1, NULL, NULL, 2, '2019-08-28 04:40:43.36436', 'F', 'F', 1, 1169.80);
INSERT INTO order_details VALUES (1151, 10686, 26, 31.2299995, 15, 0, 2, NULL, NULL, 2, '2019-08-28 04:40:43.36436', 'F', 'F', 1, 468.45);
INSERT INTO order_details VALUES (1257, 10724, 61, 28.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 142.50);
INSERT INTO order_details VALUES (1258, 10725, 41, 9.64999962, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 115.80);
INSERT INTO order_details VALUES (1259, 10725, 52, 7, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 28.00);
INSERT INTO order_details VALUES (1260, 10725, 55, 24, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (1261, 10726, 4, 22, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 550.00);
INSERT INTO order_details VALUES (1262, 10726, 11, 21, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 105.00);
INSERT INTO order_details VALUES (1263, 10727, 17, 39, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 779.95);
INSERT INTO order_details VALUES (1264, 10727, 56, 38, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.95);
INSERT INTO order_details VALUES (1265, 10727, 59, 55, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 549.95);
INSERT INTO order_details VALUES (1266, 10728, 30, 25.8899994, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.35);
INSERT INTO order_details VALUES (1267, 10728, 40, 18.3999996, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.40);
INSERT INTO order_details VALUES (1268, 10728, 55, 24, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (1269, 10728, 60, 34, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 510.00);
INSERT INTO order_details VALUES (1270, 10729, 1, 18, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 900.00);
INSERT INTO order_details VALUES (1271, 10729, 21, 10, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1272, 10729, 50, 16.25, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 650.00);
INSERT INTO order_details VALUES (1273, 10730, 16, 17.4500008, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 261.70);
INSERT INTO order_details VALUES (1274, 10730, 31, 12.5, 3, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.45);
INSERT INTO order_details VALUES (1275, 10730, 65, 21.0499992, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.45);
INSERT INTO order_details VALUES (1276, 10731, 21, 10, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.95);
INSERT INTO order_details VALUES (1277, 10731, 51, 53, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1589.95);
INSERT INTO order_details VALUES (1278, 10732, 76, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1279, 10733, 14, 23.25, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 372.00);
INSERT INTO order_details VALUES (1280, 10733, 28, 45.5999985, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (1281, 10733, 52, 7, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 175.00);
INSERT INTO order_details VALUES (1282, 10734, 6, 25, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 750.00);
INSERT INTO order_details VALUES (1283, 10734, 30, 25.8899994, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.35);
INSERT INTO order_details VALUES (1284, 10734, 76, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1285, 10735, 61, 28.5, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.90);
INSERT INTO order_details VALUES (1286, 10735, 77, 13, 2, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 25.90);
INSERT INTO order_details VALUES (1287, 10736, 65, 21.0499992, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 842.00);
INSERT INTO order_details VALUES (1288, 10736, 75, 7.75, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 155.00);
INSERT INTO order_details VALUES (1289, 10737, 13, 6, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 24.00);
INSERT INTO order_details VALUES (1290, 10737, 41, 9.64999962, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 115.80);
INSERT INTO order_details VALUES (1291, 10738, 16, 17.4500008, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 52.35);
INSERT INTO order_details VALUES (1294, 10740, 28, 45.5999985, 5, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 227.80);
INSERT INTO order_details VALUES (1295, 10740, 35, 18, 35, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 629.80);
INSERT INTO order_details VALUES (1296, 10740, 45, 9.5, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.80);
INSERT INTO order_details VALUES (1297, 10740, 56, 38, 14, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 531.80);
INSERT INTO order_details VALUES (1298, 10741, 2, 19, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 284.80);
INSERT INTO order_details VALUES (1299, 10742, 3, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (1300, 10742, 60, 34, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1700.00);
INSERT INTO order_details VALUES (1301, 10742, 72, 34.7999992, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1218.00);
INSERT INTO order_details VALUES (1302, 10743, 46, 12, 28, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 335.95);
INSERT INTO order_details VALUES (1303, 10744, 40, 18.3999996, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 919.80);
INSERT INTO order_details VALUES (1304, 10745, 18, 62.5, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1500.00);
INSERT INTO order_details VALUES (1305, 10745, 44, 19.4500008, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 311.20);
INSERT INTO order_details VALUES (1374, 10769, 52, 7, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 104.95);
INSERT INTO order_details VALUES (1375, 10769, 61, 28.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (1306, 10745, 59, 55, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2475.00);
INSERT INTO order_details VALUES (1307, 10745, 72, 34.7999992, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 243.60);
INSERT INTO order_details VALUES (1308, 10746, 13, 6, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (1309, 10746, 42, 14, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 392.00);
INSERT INTO order_details VALUES (1310, 10746, 62, 49.2999992, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 443.70);
INSERT INTO order_details VALUES (1311, 10746, 69, 36, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1440.00);
INSERT INTO order_details VALUES (1316, 10748, 23, 9, 44, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 396.00);
INSERT INTO order_details VALUES (1317, 10748, 40, 18.3999996, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 736.00);
INSERT INTO order_details VALUES (1318, 10748, 56, 38, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1064.00);
INSERT INTO order_details VALUES (1319, 10749, 56, 38, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (1320, 10749, 59, 55, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 330.00);
INSERT INTO order_details VALUES (1321, 10749, 76, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1322, 10750, 14, 23.25, 5, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 116.10);
INSERT INTO order_details VALUES (1323, 10750, 45, 9.5, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.85);
INSERT INTO order_details VALUES (1324, 10750, 59, 55, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1374.85);
INSERT INTO order_details VALUES (1325, 10751, 26, 31.2299995, 12, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 374.66);
INSERT INTO order_details VALUES (1326, 10751, 30, 25.8899994, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 776.70);
INSERT INTO order_details VALUES (1327, 10751, 50, 16.25, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 324.90);
INSERT INTO order_details VALUES (1328, 10751, 73, 15, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 225.00);
INSERT INTO order_details VALUES (1331, 10753, 45, 9.5, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 38.00);
INSERT INTO order_details VALUES (1332, 10753, 74, 10, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 50.00);
INSERT INTO order_details VALUES (1333, 10754, 40, 18.3999996, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 55.20);
INSERT INTO order_details VALUES (1334, 10755, 47, 9.5, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 284.75);
INSERT INTO order_details VALUES (1335, 10755, 56, 38, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1139.75);
INSERT INTO order_details VALUES (1336, 10755, 57, 19.5, 14, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 272.75);
INSERT INTO order_details VALUES (1337, 10755, 69, 36, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 899.75);
INSERT INTO order_details VALUES (1338, 10756, 18, 62.5, 21, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1312.30);
INSERT INTO order_details VALUES (1339, 10756, 36, 19, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.80);
INSERT INTO order_details VALUES (1340, 10756, 68, 12.5, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 74.80);
INSERT INTO order_details VALUES (1341, 10756, 69, 36, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.80);
INSERT INTO order_details VALUES (1342, 10757, 34, 14, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (1343, 10757, 59, 55, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 385.00);
INSERT INTO order_details VALUES (1344, 10757, 62, 49.2999992, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1479.00);
INSERT INTO order_details VALUES (1345, 10757, 64, 33.25, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 798.00);
INSERT INTO order_details VALUES (1346, 10758, 26, 31.2299995, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 624.60);
INSERT INTO order_details VALUES (1347, 10758, 52, 7, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (1348, 10758, 70, 15, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (1349, 10759, 32, 32, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 320.00);
INSERT INTO order_details VALUES (1350, 10760, 25, 14, 12, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.75);
INSERT INTO order_details VALUES (1351, 10760, 27, 43.9000015, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1756.00);
INSERT INTO order_details VALUES (1352, 10760, 43, 46, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1379.75);
INSERT INTO order_details VALUES (1353, 10761, 25, 14, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 489.75);
INSERT INTO order_details VALUES (1354, 10761, 75, 7.75, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.50);
INSERT INTO order_details VALUES (1355, 10762, 39, 18, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 288.00);
INSERT INTO order_details VALUES (1356, 10762, 47, 9.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (1357, 10762, 51, 53, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1484.00);
INSERT INTO order_details VALUES (1358, 10762, 56, 38, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2280.00);
INSERT INTO order_details VALUES (1359, 10763, 21, 10, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (1360, 10763, 22, 21, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 126.00);
INSERT INTO order_details VALUES (1361, 10763, 24, 4.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1364, 10765, 65, 21.0499992, 80, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1683.90);
INSERT INTO order_details VALUES (1365, 10766, 2, 19, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (1366, 10766, 7, 30, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1050.00);
INSERT INTO order_details VALUES (1367, 10766, 68, 12.5, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (1368, 10767, 42, 14, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 28.00);
INSERT INTO order_details VALUES (1369, 10768, 22, 21, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 84.00);
INSERT INTO order_details VALUES (1370, 10768, 31, 12.5, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 625.00);
INSERT INTO order_details VALUES (1371, 10768, 60, 34, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 510.00);
INSERT INTO order_details VALUES (1372, 10768, 71, 21.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 258.00);
INSERT INTO order_details VALUES (1373, 10769, 41, 9.64999962, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 289.45);
INSERT INTO order_details VALUES (1312, 10747, 31, 12.5, 8, 0, 1, NULL, NULL, 2, '2019-08-28 04:40:47.69697', 'F', 'F', 1, 100.00);
INSERT INTO order_details VALUES (1376, 10769, 62, 49.2999992, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 739.50);
INSERT INTO order_details VALUES (1377, 10770, 11, 21, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 314.75);
INSERT INTO order_details VALUES (1379, 10772, 29, 123.790001, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2228.22);
INSERT INTO order_details VALUES (1380, 10772, 59, 55, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1375.00);
INSERT INTO order_details VALUES (1384, 10774, 31, 12.5, 2, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 24.75);
INSERT INTO order_details VALUES (1385, 10774, 66, 17, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 850.00);
INSERT INTO order_details VALUES (1392, 10777, 42, 14, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 279.80);
INSERT INTO order_details VALUES (1393, 10778, 41, 9.64999962, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 96.50);
INSERT INTO order_details VALUES (1394, 10779, 16, 17.4500008, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 349.00);
INSERT INTO order_details VALUES (1395, 10779, 62, 49.2999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 986.00);
INSERT INTO order_details VALUES (1396, 10780, 70, 15, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 525.00);
INSERT INTO order_details VALUES (1397, 10780, 77, 13, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 195.00);
INSERT INTO order_details VALUES (1398, 10781, 54, 7.44999981, 3, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 22.15);
INSERT INTO order_details VALUES (1399, 10781, 56, 38, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 759.80);
INSERT INTO order_details VALUES (1400, 10781, 74, 10, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 350.00);
INSERT INTO order_details VALUES (1402, 10783, 31, 12.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 125.00);
INSERT INTO order_details VALUES (1403, 10783, 38, 263.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1317.50);
INSERT INTO order_details VALUES (1404, 10784, 36, 19, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 570.00);
INSERT INTO order_details VALUES (1405, 10784, 39, 18, 2, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.85);
INSERT INTO order_details VALUES (1406, 10784, 72, 34.7999992, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1043.85);
INSERT INTO order_details VALUES (1329, 10752, 1, 18, 8, 0, 1, NULL, NULL, 2, '2019-08-29 06:32:16.119386', 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (1386, 10775, 10, 31, 6, 0, 1, NULL, NULL, 2, '2019-08-29 07:17:02.0213', 'F', 'F', 1, 186.00);
INSERT INTO order_details VALUES (1292, 10739, 36, 19, 6, 0, 1, NULL, NULL, 2, '2019-08-29 07:23:03.903528', 'F', 'F', 1, 114.00);
INSERT INTO order_details VALUES (1293, 10739, 52, 7, 18, 0, 2, NULL, NULL, 2, '2019-08-29 07:23:03.903528', 'F', 'F', 1, 126.00);
INSERT INTO order_details VALUES (1409, 10786, 8, 40, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1199.80);
INSERT INTO order_details VALUES (1410, 10786, 30, 25.8899994, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.15);
INSERT INTO order_details VALUES (1411, 10786, 75, 7.75, 42, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 325.30);
INSERT INTO order_details VALUES (1412, 10787, 2, 19, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 284.95);
INSERT INTO order_details VALUES (1413, 10787, 29, 123.790001, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2475.75);
INSERT INTO order_details VALUES (1414, 10788, 19, 9.19999981, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 459.95);
INSERT INTO order_details VALUES (1415, 10788, 75, 7.75, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 309.95);
INSERT INTO order_details VALUES (1420, 10790, 7, 30, 3, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 89.85);
INSERT INTO order_details VALUES (1421, 10790, 56, 38, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 759.85);
INSERT INTO order_details VALUES (1422, 10791, 29, 123.790001, 14, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1733.01);
INSERT INTO order_details VALUES (1494, 10821, 35, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1495, 10821, 51, 53, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 318.00);
INSERT INTO order_details VALUES (1423, 10791, 41, 9.64999962, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.95);
INSERT INTO order_details VALUES (1424, 10792, 2, 19, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (1425, 10792, 54, 7.44999981, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 22.35);
INSERT INTO order_details VALUES (1426, 10792, 68, 12.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (1427, 10793, 41, 9.64999962, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 135.10);
INSERT INTO order_details VALUES (1428, 10793, 52, 7, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 56.00);
INSERT INTO order_details VALUES (1429, 10794, 14, 23.25, 15, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 348.55);
INSERT INTO order_details VALUES (1430, 10794, 54, 7.44999981, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.50);
INSERT INTO order_details VALUES (1433, 10796, 26, 31.2299995, 21, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 655.63);
INSERT INTO order_details VALUES (1434, 10796, 44, 19.4500008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.50);
INSERT INTO order_details VALUES (1435, 10796, 64, 33.25, 35, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1163.55);
INSERT INTO order_details VALUES (1436, 10796, 69, 36, 24, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 863.80);
INSERT INTO order_details VALUES (1437, 10797, 11, 21, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (1438, 10798, 62, 49.2999992, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.60);
INSERT INTO order_details VALUES (1439, 10798, 72, 34.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 348.00);
INSERT INTO order_details VALUES (1440, 10799, 13, 6, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 119.85);
INSERT INTO order_details VALUES (1441, 10799, 24, 4.5, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 89.85);
INSERT INTO order_details VALUES (1442, 10799, 59, 55, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1375.00);
INSERT INTO order_details VALUES (1443, 10800, 11, 21, 50, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1049.90);
INSERT INTO order_details VALUES (1444, 10800, 51, 53, 10, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 529.90);
INSERT INTO order_details VALUES (1445, 10800, 54, 7.44999981, 7, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 52.05);
INSERT INTO order_details VALUES (1446, 10801, 17, 39, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1559.75);
INSERT INTO order_details VALUES (1447, 10801, 29, 123.790001, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2475.55);
INSERT INTO order_details VALUES (1448, 10802, 30, 25.8899994, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 647.00);
INSERT INTO order_details VALUES (1449, 10802, 51, 53, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1589.75);
INSERT INTO order_details VALUES (1450, 10802, 55, 24, 60, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1439.75);
INSERT INTO order_details VALUES (1451, 10802, 62, 49.2999992, 5, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 246.25);
INSERT INTO order_details VALUES (1452, 10803, 19, 9.19999981, 24, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 220.75);
INSERT INTO order_details VALUES (1453, 10803, 25, 14, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 209.95);
INSERT INTO order_details VALUES (1454, 10803, 59, 55, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 824.95);
INSERT INTO order_details VALUES (1455, 10804, 10, 31, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1116.00);
INSERT INTO order_details VALUES (1456, 10804, 28, 45.5999985, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1094.40);
INSERT INTO order_details VALUES (1457, 10804, 49, 20, 4, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 79.85);
INSERT INTO order_details VALUES (1458, 10805, 34, 14, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 140.00);
INSERT INTO order_details VALUES (1459, 10805, 38, 263.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2635.00);
INSERT INTO order_details VALUES (1460, 10806, 2, 19, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.75);
INSERT INTO order_details VALUES (1461, 10806, 65, 21.0499992, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 42.10);
INSERT INTO order_details VALUES (1462, 10806, 74, 10, 15, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 149.75);
INSERT INTO order_details VALUES (1463, 10807, 40, 18.3999996, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 18.40);
INSERT INTO order_details VALUES (1464, 10808, 56, 38, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 759.85);
INSERT INTO order_details VALUES (1465, 10808, 76, 18, 50, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 899.85);
INSERT INTO order_details VALUES (1466, 10809, 52, 7, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 140.00);
INSERT INTO order_details VALUES (1470, 10811, 19, 9.19999981, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 138.00);
INSERT INTO order_details VALUES (1471, 10811, 23, 9, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 162.00);
INSERT INTO order_details VALUES (1472, 10811, 40, 18.3999996, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 552.00);
INSERT INTO order_details VALUES (1473, 10812, 31, 12.5, 16, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 199.90);
INSERT INTO order_details VALUES (1474, 10812, 72, 34.7999992, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1391.90);
INSERT INTO order_details VALUES (1475, 10812, 77, 13, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 260.00);
INSERT INTO order_details VALUES (1476, 10813, 2, 19, 12, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 227.80);
INSERT INTO order_details VALUES (1477, 10813, 46, 12, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 420.00);
INSERT INTO order_details VALUES (1478, 10814, 41, 9.64999962, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 193.00);
INSERT INTO order_details VALUES (1479, 10814, 43, 46, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 919.85);
INSERT INTO order_details VALUES (1480, 10814, 48, 12.75, 8, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 101.85);
INSERT INTO order_details VALUES (1481, 10814, 61, 28.5, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 854.85);
INSERT INTO order_details VALUES (1482, 10815, 33, 2.5, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (1483, 10816, 38, 263.5, 30, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7904.95);
INSERT INTO order_details VALUES (1484, 10816, 62, 49.2999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 985.95);
INSERT INTO order_details VALUES (1485, 10817, 26, 31.2299995, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1249.05);
INSERT INTO order_details VALUES (1486, 10817, 38, 263.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7905.00);
INSERT INTO order_details VALUES (1487, 10817, 40, 18.3999996, 60, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1103.85);
INSERT INTO order_details VALUES (1488, 10817, 62, 49.2999992, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1232.35);
INSERT INTO order_details VALUES (1489, 10818, 32, 32, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 640.00);
INSERT INTO order_details VALUES (1490, 10818, 41, 9.64999962, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 193.00);
INSERT INTO order_details VALUES (1493, 10820, 56, 38, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1140.00);
INSERT INTO order_details VALUES (1401, 10782, 31, 12.5, 1, 0, 1, NULL, NULL, 2, '2019-08-27 11:32:28.962811', 'F', 'F', 1, 12.50);
INSERT INTO order_details VALUES (1431, 10795, 16, 17.4500008, 65, 0, 1, NULL, NULL, 2, '2019-08-28 04:25:21.603999', 'F', 'F', 1, 1134.25);
INSERT INTO order_details VALUES (1388, 10776, 31, 12.5, 16, 0.0500000007, 1, NULL, NULL, 2, '2019-08-28 04:29:06.48725', 'F', 'F', 1, 199.95);
INSERT INTO order_details VALUES (1378, 10771, 71, 21.5, 16, 0, 1, NULL, NULL, 2, '2019-08-28 04:30:09.271323', 'F', 'F', 1, 344.00);
INSERT INTO order_details VALUES (1381, 10773, 17, 39, 33, 0, 1, NULL, NULL, 2, '2019-08-28 04:30:25.144815', 'F', 'F', 1, 1287.00);
INSERT INTO order_details VALUES (1382, 10773, 31, 12.5, 70, 0.200000003, 2, NULL, NULL, 2, '2019-08-28 04:30:25.144815', 'F', 'F', 1, 874.80);
INSERT INTO order_details VALUES (1383, 10773, 75, 7.75, 7, 0.200000003, 3, NULL, NULL, 2, '2019-08-28 04:30:25.144815', 'F', 'F', 1, 54.05);
INSERT INTO order_details VALUES (1498, 10823, 11, 21, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 419.90);
INSERT INTO order_details VALUES (1499, 10823, 57, 19.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 292.50);
INSERT INTO order_details VALUES (1500, 10823, 59, 55, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2199.90);
INSERT INTO order_details VALUES (1501, 10823, 77, 13, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.90);
INSERT INTO order_details VALUES (1502, 10824, 41, 9.64999962, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 115.80);
INSERT INTO order_details VALUES (1503, 10824, 70, 15, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 135.00);
INSERT INTO order_details VALUES (1504, 10825, 26, 31.2299995, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 374.76);
INSERT INTO order_details VALUES (1505, 10825, 53, 32.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 656.00);
INSERT INTO order_details VALUES (1508, 10827, 10, 31, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 465.00);
INSERT INTO order_details VALUES (1509, 10827, 39, 18, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 378.00);
INSERT INTO order_details VALUES (1506, 10826, 31, 12.5, 35, 0, 1, NULL, NULL, 2, '2019-08-28 11:35:50.792121', 'F', 'F', 1, 437.50);
INSERT INTO order_details VALUES (1507, 10826, 57, 19.5, 15, 0, 2, NULL, NULL, 2, '2019-08-28 11:35:50.792121', 'F', 'F', 1, 292.50);
INSERT INTO order_details VALUES (1416, 10789, 18, 62.5, 30, 0, 1, NULL, NULL, 2, '2019-08-28 11:43:58.483875', 'F', 'F', 1, 1875.00);
INSERT INTO order_details VALUES (1417, 10789, 35, 18, 15, 0, 2, NULL, NULL, 2, '2019-08-28 11:43:58.483875', 'F', 'F', 1, 270.00);
INSERT INTO order_details VALUES (1408, 10785, 75, 7.75, 10, 0, 2, NULL, NULL, 2, '2019-08-29 06:02:35.006881', 'F', 'F', 1, 77.50);
INSERT INTO order_details VALUES (1496, 10822, 62, 49.2999992, 3, 0, 1, NULL, NULL, 2, '2019-08-29 07:20:58.199106', 'F', 'F', 1, 147.90);
INSERT INTO order_details VALUES (1497, 10822, 70, 15, 6, 0, 2, NULL, NULL, 2, '2019-08-29 07:20:58.199106', 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1512, 10829, 2, 19, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (1513, 10829, 8, 40, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 800.00);
INSERT INTO order_details VALUES (1514, 10829, 13, 6, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1515, 10829, 60, 34, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 714.00);
INSERT INTO order_details VALUES (1516, 10830, 6, 25, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 150.00);
INSERT INTO order_details VALUES (1517, 10830, 39, 18, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 504.00);
INSERT INTO order_details VALUES (1518, 10830, 60, 34, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1020.00);
INSERT INTO order_details VALUES (1519, 10830, 68, 12.5, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1520, 10831, 19, 9.19999981, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 18.40);
INSERT INTO order_details VALUES (1614, 10862, 11, 21, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 525.00);
INSERT INTO order_details VALUES (1615, 10862, 52, 7, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 56.00);
INSERT INTO order_details VALUES (1616, 10863, 1, 18, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.85);
INSERT INTO order_details VALUES (1521, 10831, 35, 18, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (1522, 10831, 38, 263.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2108.00);
INSERT INTO order_details VALUES (1523, 10831, 43, 46, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 414.00);
INSERT INTO order_details VALUES (1524, 10832, 13, 6, 3, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 17.80);
INSERT INTO order_details VALUES (1525, 10832, 25, 14, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.80);
INSERT INTO order_details VALUES (1526, 10832, 44, 19.4500008, 16, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 311.00);
INSERT INTO order_details VALUES (1527, 10832, 64, 33.25, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 99.75);
INSERT INTO order_details VALUES (1528, 10833, 7, 30, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 599.90);
INSERT INTO order_details VALUES (1529, 10833, 31, 12.5, 9, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.40);
INSERT INTO order_details VALUES (1530, 10833, 53, 32.7999992, 9, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 295.10);
INSERT INTO order_details VALUES (1531, 10834, 29, 123.790001, 8, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 990.27);
INSERT INTO order_details VALUES (1532, 10834, 30, 25.8899994, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 517.75);
INSERT INTO order_details VALUES (1533, 10835, 59, 55, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 825.00);
INSERT INTO order_details VALUES (1534, 10835, 77, 13, 2, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 25.80);
INSERT INTO order_details VALUES (1540, 10837, 13, 6, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (1541, 10837, 40, 18.3999996, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 460.00);
INSERT INTO order_details VALUES (1542, 10837, 47, 9.5, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.75);
INSERT INTO order_details VALUES (1543, 10837, 76, 18, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 377.75);
INSERT INTO order_details VALUES (1544, 10838, 1, 18, 4, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 71.75);
INSERT INTO order_details VALUES (1545, 10838, 18, 62.5, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1562.25);
INSERT INTO order_details VALUES (1546, 10838, 36, 19, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 949.75);
INSERT INTO order_details VALUES (1549, 10840, 25, 14, 6, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 83.80);
INSERT INTO order_details VALUES (1550, 10840, 39, 18, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 179.80);
INSERT INTO order_details VALUES (1551, 10841, 10, 31, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 496.00);
INSERT INTO order_details VALUES (1552, 10841, 56, 38, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1140.00);
INSERT INTO order_details VALUES (1553, 10841, 59, 55, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2750.00);
INSERT INTO order_details VALUES (1554, 10841, 77, 13, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 195.00);
INSERT INTO order_details VALUES (1555, 10842, 11, 21, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 315.00);
INSERT INTO order_details VALUES (1556, 10842, 43, 46, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 230.00);
INSERT INTO order_details VALUES (1557, 10842, 68, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (1558, 10842, 70, 15, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1559, 10843, 51, 53, 4, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 211.75);
INSERT INTO order_details VALUES (1561, 10845, 23, 9, 70, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 629.90);
INSERT INTO order_details VALUES (1562, 10845, 35, 18, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 449.90);
INSERT INTO order_details VALUES (1563, 10845, 42, 14, 42, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 587.90);
INSERT INTO order_details VALUES (1564, 10845, 58, 13.25, 60, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 794.90);
INSERT INTO order_details VALUES (1565, 10845, 64, 33.25, 48, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1596.00);
INSERT INTO order_details VALUES (1566, 10846, 4, 22, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 462.00);
INSERT INTO order_details VALUES (1567, 10846, 70, 15, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (1568, 10846, 74, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (1569, 10847, 1, 18, 80, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1439.80);
INSERT INTO order_details VALUES (1570, 10847, 19, 9.19999981, 12, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.20);
INSERT INTO order_details VALUES (1571, 10847, 37, 26, 60, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1559.80);
INSERT INTO order_details VALUES (1572, 10847, 45, 9.5, 36, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 341.80);
INSERT INTO order_details VALUES (1573, 10847, 60, 34, 45, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1529.80);
INSERT INTO order_details VALUES (1574, 10847, 71, 21.5, 55, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1182.30);
INSERT INTO order_details VALUES (1577, 10849, 3, 10, 49, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 490.00);
INSERT INTO order_details VALUES (1578, 10849, 26, 31.2299995, 18, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 561.99);
INSERT INTO order_details VALUES (1582, 10851, 2, 19, 5, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 94.95);
INSERT INTO order_details VALUES (1583, 10851, 25, 14, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.95);
INSERT INTO order_details VALUES (1584, 10851, 57, 19.5, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 194.95);
INSERT INTO order_details VALUES (1585, 10851, 59, 55, 42, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2309.95);
INSERT INTO order_details VALUES (1586, 10852, 2, 19, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (1587, 10852, 17, 39, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 234.00);
INSERT INTO order_details VALUES (1588, 10852, 62, 49.2999992, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2465.00);
INSERT INTO order_details VALUES (1589, 10853, 18, 62.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 625.00);
INSERT INTO order_details VALUES (1592, 10855, 16, 17.4500008, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 872.50);
INSERT INTO order_details VALUES (1593, 10855, 31, 12.5, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 175.00);
INSERT INTO order_details VALUES (1594, 10855, 56, 38, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (1595, 10855, 65, 21.0499992, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 315.60);
INSERT INTO order_details VALUES (1596, 10856, 2, 19, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (1597, 10856, 42, 14, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 280.00);
INSERT INTO order_details VALUES (1598, 10857, 3, 10, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1599, 10857, 26, 31.2299995, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1092.80);
INSERT INTO order_details VALUES (1600, 10857, 29, 123.790001, 10, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1237.65);
INSERT INTO order_details VALUES (1601, 10858, 7, 30, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 150.00);
INSERT INTO order_details VALUES (1602, 10858, 27, 43.9000015, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 439.00);
INSERT INTO order_details VALUES (1603, 10858, 70, 15, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1604, 10859, 24, 4.5, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 179.75);
INSERT INTO order_details VALUES (1605, 10859, 54, 7.44999981, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 260.50);
INSERT INTO order_details VALUES (1606, 10859, 64, 33.25, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 997.25);
INSERT INTO order_details VALUES (1607, 10860, 51, 53, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 159.00);
INSERT INTO order_details VALUES (1608, 10860, 76, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1609, 10861, 17, 39, 42, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1638.00);
INSERT INTO order_details VALUES (1610, 10861, 18, 62.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1250.00);
INSERT INTO order_details VALUES (1611, 10861, 21, 10, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 400.00);
INSERT INTO order_details VALUES (1612, 10861, 33, 2.5, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 87.50);
INSERT INTO order_details VALUES (1613, 10861, 62, 49.2999992, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 147.90);
INSERT INTO order_details VALUES (1590, 10854, 10, 31, 100, 0.150000006, 1, NULL, NULL, 2, '2019-08-28 04:25:38.80377', 'F', 'F', 1, 3099.85);
INSERT INTO order_details VALUES (1535, 10836, 22, 21, 52, 0, 1, NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, 1092.00);
INSERT INTO order_details VALUES (1560, 10844, 22, 21, 35, 0, 1, NULL, NULL, 2, '2019-08-28 04:40:52.681619', 'F', 'F', 1, 735.00);
INSERT INTO order_details VALUES (1617, 10863, 58, 13.25, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 158.85);
INSERT INTO order_details VALUES (1618, 10864, 35, 18, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 72.00);
INSERT INTO order_details VALUES (1619, 10864, 67, 14, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (1620, 10865, 38, 263.5, 60, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 15809.95);
INSERT INTO order_details VALUES (1621, 10865, 39, 18, 80, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1439.95);
INSERT INTO order_details VALUES (1622, 10866, 2, 19, 21, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 398.75);
INSERT INTO order_details VALUES (1575, 10848, 5, 21.3500004, 30, 0, 1, NULL, NULL, 2, '2019-08-29 05:41:10.906842', 'F', 'F', 1, 640.50);
INSERT INTO order_details VALUES (1576, 10848, 9, 97, 3, 0, 2, NULL, NULL, 2, '2019-08-29 05:41:10.906842', 'F', 'F', 1, 291.00);
INSERT INTO order_details VALUES (1579, 10850, 25, 14, 20, 0.150000006, 1, NULL, NULL, 2, '2019-08-29 07:21:56.115537', 'F', 'F', 1, 279.85);
INSERT INTO order_details VALUES (1623, 10866, 24, 4.5, 6, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 26.75);
INSERT INTO order_details VALUES (1624, 10866, 30, 25.8899994, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1035.35);
INSERT INTO order_details VALUES (1625, 10867, 53, 32.7999992, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 98.40);
INSERT INTO order_details VALUES (1626, 10868, 26, 31.2299995, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 624.60);
INSERT INTO order_details VALUES (1734, 10915, 54, 7.44999981, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 74.50);
INSERT INTO order_details VALUES (1738, 10917, 30, 25.8899994, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 25.89);
INSERT INTO order_details VALUES (1739, 10917, 60, 34, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 340.00);
INSERT INTO order_details VALUES (1627, 10868, 35, 18, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (1628, 10868, 49, 20, 42, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 839.90);
INSERT INTO order_details VALUES (1633, 10870, 35, 18, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (1634, 10870, 51, 53, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 106.00);
INSERT INTO order_details VALUES (1635, 10871, 6, 25, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1249.95);
INSERT INTO order_details VALUES (1636, 10871, 16, 17.4500008, 12, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 209.35);
INSERT INTO order_details VALUES (1637, 10871, 17, 39, 16, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 623.95);
INSERT INTO order_details VALUES (1638, 10872, 55, 24, 10, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.95);
INSERT INTO order_details VALUES (1639, 10872, 62, 49.2999992, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 985.95);
INSERT INTO order_details VALUES (1640, 10872, 64, 33.25, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 498.70);
INSERT INTO order_details VALUES (1641, 10872, 65, 21.0499992, 21, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 442.00);
INSERT INTO order_details VALUES (1642, 10873, 21, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (1643, 10873, 28, 45.5999985, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 136.80);
INSERT INTO order_details VALUES (1644, 10874, 10, 31, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 310.00);
INSERT INTO order_details VALUES (1645, 10875, 19, 9.19999981, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 230.00);
INSERT INTO order_details VALUES (1646, 10875, 47, 9.5, 21, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 199.40);
INSERT INTO order_details VALUES (1647, 10875, 49, 20, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1648, 10876, 46, 12, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 252.00);
INSERT INTO order_details VALUES (1649, 10876, 64, 33.25, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 665.00);
INSERT INTO order_details VALUES (1650, 10877, 16, 17.4500008, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.25);
INSERT INTO order_details VALUES (1651, 10877, 18, 62.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1562.50);
INSERT INTO order_details VALUES (1652, 10878, 20, 81, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1619.95);
INSERT INTO order_details VALUES (1653, 10879, 40, 18.3999996, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 220.80);
INSERT INTO order_details VALUES (1654, 10879, 65, 21.0499992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.50);
INSERT INTO order_details VALUES (1655, 10879, 76, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1656, 10880, 23, 9, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 269.80);
INSERT INTO order_details VALUES (1657, 10880, 61, 28.5, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 854.80);
INSERT INTO order_details VALUES (1658, 10880, 70, 15, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 749.80);
INSERT INTO order_details VALUES (1660, 10882, 42, 14, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 350.00);
INSERT INTO order_details VALUES (1661, 10882, 49, 20, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.85);
INSERT INTO order_details VALUES (1662, 10882, 54, 7.44999981, 32, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 238.25);
INSERT INTO order_details VALUES (1663, 10883, 24, 4.5, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (1667, 10885, 2, 19, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (1668, 10885, 24, 4.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (1669, 10885, 70, 15, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (1670, 10885, 77, 13, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 325.00);
INSERT INTO order_details VALUES (1671, 10886, 10, 31, 70, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2170.00);
INSERT INTO order_details VALUES (1672, 10886, 31, 12.5, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 437.50);
INSERT INTO order_details VALUES (1673, 10886, 77, 13, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 520.00);
INSERT INTO order_details VALUES (1674, 10887, 25, 14, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 70.00);
INSERT INTO order_details VALUES (1675, 10888, 2, 19, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (1676, 10888, 68, 12.5, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 225.00);
INSERT INTO order_details VALUES (1677, 10889, 11, 21, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 840.00);
INSERT INTO order_details VALUES (1678, 10889, 38, 263.5, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 10540.00);
INSERT INTO order_details VALUES (1682, 10891, 30, 25.8899994, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 388.30);
INSERT INTO order_details VALUES (1683, 10892, 59, 55, 40, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2199.95);
INSERT INTO order_details VALUES (1684, 10893, 8, 40, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1200.00);
INSERT INTO order_details VALUES (1685, 10893, 24, 4.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 45.00);
INSERT INTO order_details VALUES (1686, 10893, 29, 123.790001, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2970.96);
INSERT INTO order_details VALUES (1687, 10893, 30, 25.8899994, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 906.15);
INSERT INTO order_details VALUES (1688, 10893, 36, 19, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 380.00);
INSERT INTO order_details VALUES (1689, 10894, 13, 6, 28, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 167.95);
INSERT INTO order_details VALUES (1690, 10894, 69, 36, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1799.95);
INSERT INTO order_details VALUES (1691, 10894, 75, 7.75, 120, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 929.95);
INSERT INTO order_details VALUES (1696, 10896, 45, 9.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 142.50);
INSERT INTO order_details VALUES (1697, 10896, 56, 38, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (1698, 10897, 29, 123.790001, 80, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 9903.20);
INSERT INTO order_details VALUES (1699, 10897, 30, 25.8899994, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 932.04);
INSERT INTO order_details VALUES (1701, 10899, 39, 18, 8, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 143.85);
INSERT INTO order_details VALUES (1702, 10900, 70, 15, 3, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.75);
INSERT INTO order_details VALUES (1703, 10901, 41, 9.64999962, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 289.50);
INSERT INTO order_details VALUES (1704, 10901, 71, 21.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 645.00);
INSERT INTO order_details VALUES (1705, 10902, 55, 24, 30, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 719.85);
INSERT INTO order_details VALUES (1706, 10902, 62, 49.2999992, 6, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 295.65);
INSERT INTO order_details VALUES (1707, 10903, 13, 6, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (1708, 10903, 65, 21.0499992, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 442.05);
INSERT INTO order_details VALUES (1709, 10903, 68, 12.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (1710, 10904, 58, 13.25, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 198.75);
INSERT INTO order_details VALUES (1711, 10904, 62, 49.2999992, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1725.50);
INSERT INTO order_details VALUES (1712, 10905, 1, 18, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 359.95);
INSERT INTO order_details VALUES (1713, 10906, 61, 28.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 427.50);
INSERT INTO order_details VALUES (1714, 10907, 75, 7.75, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 108.50);
INSERT INTO order_details VALUES (1715, 10908, 7, 30, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 599.95);
INSERT INTO order_details VALUES (1716, 10908, 52, 7, 14, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 97.95);
INSERT INTO order_details VALUES (1717, 10909, 7, 30, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1718, 10909, 16, 17.4500008, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 261.75);
INSERT INTO order_details VALUES (1719, 10909, 41, 9.64999962, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 48.25);
INSERT INTO order_details VALUES (1720, 10910, 19, 9.19999981, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 110.40);
INSERT INTO order_details VALUES (1721, 10910, 49, 20, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (1722, 10910, 61, 28.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 142.50);
INSERT INTO order_details VALUES (1723, 10911, 1, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1724, 10911, 17, 39, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 468.00);
INSERT INTO order_details VALUES (1725, 10911, 67, 14, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (1726, 10912, 11, 21, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 839.75);
INSERT INTO order_details VALUES (1727, 10912, 29, 123.790001, 60, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 7427.15);
INSERT INTO order_details VALUES (1728, 10913, 4, 22, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 659.75);
INSERT INTO order_details VALUES (1729, 10913, 33, 2.5, 40, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 99.75);
INSERT INTO order_details VALUES (1730, 10913, 58, 13.25, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 198.75);
INSERT INTO order_details VALUES (1731, 10914, 71, 21.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 537.50);
INSERT INTO order_details VALUES (1854, 10964, 18, 62.5, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 375.00);
INSERT INTO order_details VALUES (1664, 10884, 21, 10, 40, 0.0500000007, 1, NULL, NULL, 2, '2019-08-29 06:21:08.218865', 'F', 'F', 1, 399.95);
INSERT INTO order_details VALUES (1665, 10884, 56, 38, 21, 0.0500000007, 2, NULL, NULL, 2, '2019-08-29 06:21:08.218865', 'F', 'F', 1, 797.95);
INSERT INTO order_details VALUES (1629, 10869, 1, 18, 40, 0, 1, NULL, NULL, 2, '2019-08-29 07:00:56.275108', 'F', 'F', 1, 720.00);
INSERT INTO order_details VALUES (1630, 10869, 11, 21, 10, 0, 2, NULL, NULL, 2, '2019-08-29 07:00:56.275108', 'F', 'F', 1, 210.00);
INSERT INTO order_details VALUES (1631, 10869, 23, 9, 50, 0, 3, NULL, NULL, 2, '2019-08-29 07:00:56.275108', 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (1855, 10964, 38, 263.5, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1317.50);
INSERT INTO order_details VALUES (1732, 10915, 17, 39, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (1733, 10915, 33, 2.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 75.00);
INSERT INTO order_details VALUES (1692, 10895, 24, 4.5, 110, 0, 1, NULL, NULL, 2, '2019-08-28 04:25:32.384392', 'F', 'F', 1, 495.00);
INSERT INTO order_details VALUES (1740, 10918, 1, 18, 60, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1079.75);
INSERT INTO order_details VALUES (1741, 10918, 60, 34, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 849.75);
INSERT INTO order_details VALUES (1742, 10919, 16, 17.4500008, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 418.80);
INSERT INTO order_details VALUES (1743, 10919, 25, 14, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 336.00);
INSERT INTO order_details VALUES (1744, 10919, 40, 18.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 368.00);
INSERT INTO order_details VALUES (1745, 10920, 50, 16.25, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (1746, 10921, 35, 18, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1747, 10921, 63, 43.9000015, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1756.00);
INSERT INTO order_details VALUES (1748, 10922, 17, 39, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 585.00);
INSERT INTO order_details VALUES (1749, 10922, 24, 4.5, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 157.50);
INSERT INTO order_details VALUES (1750, 10923, 42, 14, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.80);
INSERT INTO order_details VALUES (1751, 10923, 43, 46, 10, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 459.80);
INSERT INTO order_details VALUES (1752, 10923, 67, 14, 24, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 335.80);
INSERT INTO order_details VALUES (1756, 10925, 36, 19, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 474.85);
INSERT INTO order_details VALUES (1757, 10925, 52, 7, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 83.85);
INSERT INTO order_details VALUES (1758, 10926, 11, 21, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 42.00);
INSERT INTO order_details VALUES (1759, 10926, 13, 6, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1760, 10926, 19, 9.19999981, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 64.40);
INSERT INTO order_details VALUES (1761, 10926, 72, 34.7999992, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 348.00);
INSERT INTO order_details VALUES (1762, 10927, 20, 81, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 405.00);
INSERT INTO order_details VALUES (1763, 10927, 52, 7, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 35.00);
INSERT INTO order_details VALUES (1764, 10927, 76, 18, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1767, 10929, 21, 10, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (1768, 10929, 75, 7.75, 49, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 379.75);
INSERT INTO order_details VALUES (1769, 10929, 77, 13, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 195.00);
INSERT INTO order_details VALUES (1770, 10930, 21, 10, 36, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1771, 10930, 27, 43.9000015, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1097.50);
INSERT INTO order_details VALUES (1772, 10930, 55, 24, 25, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 599.80);
INSERT INTO order_details VALUES (1773, 10930, 58, 13.25, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 397.30);
INSERT INTO order_details VALUES (1774, 10931, 13, 6, 42, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 251.85);
INSERT INTO order_details VALUES (1775, 10931, 57, 19.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 585.00);
INSERT INTO order_details VALUES (1776, 10932, 16, 17.4500008, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 523.40);
INSERT INTO order_details VALUES (1777, 10932, 62, 49.2999992, 14, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 690.10);
INSERT INTO order_details VALUES (1778, 10932, 72, 34.7999992, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 556.80);
INSERT INTO order_details VALUES (1779, 10932, 75, 7.75, 20, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 154.90);
INSERT INTO order_details VALUES (1782, 10934, 6, 25, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 500.00);
INSERT INTO order_details VALUES (1786, 10936, 36, 19, 30, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 569.80);
INSERT INTO order_details VALUES (1789, 10938, 13, 6, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 119.75);
INSERT INTO order_details VALUES (1790, 10938, 43, 46, 24, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1103.75);
INSERT INTO order_details VALUES (1791, 10938, 60, 34, 49, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1665.75);
INSERT INTO order_details VALUES (1792, 10938, 71, 21.5, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 752.25);
INSERT INTO order_details VALUES (1793, 10939, 2, 19, 10, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 189.85);
INSERT INTO order_details VALUES (1794, 10939, 67, 14, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 559.85);
INSERT INTO order_details VALUES (1795, 10940, 7, 30, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (1796, 10940, 13, 6, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (1797, 10941, 31, 12.5, 44, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 549.75);
INSERT INTO order_details VALUES (1798, 10941, 62, 49.2999992, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1478.75);
INSERT INTO order_details VALUES (1799, 10941, 68, 12.5, 80, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 999.75);
INSERT INTO order_details VALUES (1800, 10941, 72, 34.7999992, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1740.00);
INSERT INTO order_details VALUES (1801, 10942, 49, 20, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (1802, 10943, 13, 6, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1803, 10943, 22, 21, 21, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 441.00);
INSERT INTO order_details VALUES (1804, 10943, 46, 12, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 180.00);
INSERT INTO order_details VALUES (1805, 10944, 11, 21, 5, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 104.75);
INSERT INTO order_details VALUES (1806, 10944, 44, 19.4500008, 18, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 349.85);
INSERT INTO order_details VALUES (1807, 10944, 56, 38, 18, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 684.00);
INSERT INTO order_details VALUES (1810, 10946, 10, 31, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 775.00);
INSERT INTO order_details VALUES (1811, 10946, 24, 4.5, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 112.50);
INSERT INTO order_details VALUES (1812, 10946, 77, 13, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 520.00);
INSERT INTO order_details VALUES (1813, 10947, 59, 55, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 220.00);
INSERT INTO order_details VALUES (1814, 10948, 50, 16.25, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 146.25);
INSERT INTO order_details VALUES (1815, 10948, 51, 53, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2120.00);
INSERT INTO order_details VALUES (1816, 10948, 55, 24, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 96.00);
INSERT INTO order_details VALUES (1817, 10949, 6, 25, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1818, 10949, 10, 31, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 930.00);
INSERT INTO order_details VALUES (1819, 10949, 17, 39, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 234.00);
INSERT INTO order_details VALUES (1820, 10949, 62, 49.2999992, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2958.00);
INSERT INTO order_details VALUES (1822, 10951, 33, 2.5, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 37.45);
INSERT INTO order_details VALUES (1823, 10951, 41, 9.64999962, 6, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.85);
INSERT INTO order_details VALUES (1824, 10951, 75, 7.75, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 387.45);
INSERT INTO order_details VALUES (1825, 10952, 6, 25, 16, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.95);
INSERT INTO order_details VALUES (1826, 10952, 28, 45.5999985, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 91.20);
INSERT INTO order_details VALUES (1827, 10953, 20, 81, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 4049.95);
INSERT INTO order_details VALUES (1828, 10953, 31, 12.5, 50, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 624.95);
INSERT INTO order_details VALUES (1829, 10954, 16, 17.4500008, 28, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 488.45);
INSERT INTO order_details VALUES (1830, 10954, 31, 12.5, 25, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 312.35);
INSERT INTO order_details VALUES (1831, 10954, 45, 9.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (1832, 10954, 60, 34, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 815.85);
INSERT INTO order_details VALUES (1833, 10955, 75, 7.75, 12, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 92.80);
INSERT INTO order_details VALUES (1834, 10956, 21, 10, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (1835, 10956, 47, 9.5, 14, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 133.00);
INSERT INTO order_details VALUES (1836, 10956, 51, 53, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 424.00);
INSERT INTO order_details VALUES (1837, 10957, 30, 25.8899994, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 776.70);
INSERT INTO order_details VALUES (1838, 10957, 35, 18, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 720.00);
INSERT INTO order_details VALUES (1839, 10957, 64, 33.25, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 266.00);
INSERT INTO order_details VALUES (139, 10299, 70, 12, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 240.00);
INSERT INTO order_details VALUES (140, 10300, 66, 13.6000004, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 408.00);
INSERT INTO order_details VALUES (141, 10300, 68, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (142, 10301, 40, 14.6999998, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 147.00);
INSERT INTO order_details VALUES (143, 10301, 56, 30.3999996, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 608.00);
INSERT INTO order_details VALUES (1753, 10924, 10, 31, 20, 0.100000001, 1, NULL, NULL, 2, '2019-08-29 05:18:30.235341', 'F', 'F', 1, 619.90);
INSERT INTO order_details VALUES (1754, 10924, 28, 45.5999985, 30, 0.100000001, 2, NULL, NULL, 2, '2019-08-29 05:18:30.235341', 'F', 'F', 1, 1367.90);
INSERT INTO order_details VALUES (1765, 10928, 47, 9.5, 5, 0, 1, NULL, NULL, 2, '2019-08-29 05:56:55.504903', 'F', 'F', 1, 47.50);
INSERT INTO order_details VALUES (1766, 10928, 76, 18, 5, 0, 2, NULL, NULL, 2, '2019-08-29 05:56:55.504903', 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1780, 10933, 53, 32.7999992, 2, 0, 1, NULL, NULL, 2, '2019-08-29 06:15:24.909137', 'F', 'F', 1, 65.60);
INSERT INTO order_details VALUES (1781, 10933, 61, 28.5, 30, 0, 2, NULL, NULL, 2, '2019-08-29 06:15:24.909137', 'F', 'F', 1, 855.00);
INSERT INTO order_details VALUES (1821, 10950, 4, 22, 5, 0, 1, NULL, NULL, 2, '2019-08-29 06:26:55.924939', 'F', 'F', 1, 110.00);
INSERT INTO order_details VALUES (1808, 10945, 13, 6, 20, 0, 1, NULL, NULL, 2, '2019-08-29 06:28:47.977338', 'F', 'F', 1, 120.00);
INSERT INTO order_details VALUES (144, 10302, 17, 31.2000008, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1248.00);
INSERT INTO order_details VALUES (145, 10302, 28, 36.4000015, 28, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1019.20);
INSERT INTO order_details VALUES (146, 10302, 43, 36.7999992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 441.60);
INSERT INTO order_details VALUES (147, 10303, 40, 14.6999998, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 587.90);
INSERT INTO order_details VALUES (148, 10303, 65, 16.7999992, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 503.90);
INSERT INTO order_details VALUES (149, 10303, 68, 10, 15, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 149.90);
INSERT INTO order_details VALUES (150, 10304, 49, 16, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 480.00);
INSERT INTO order_details VALUES (151, 10304, 59, 44, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 440.00);
INSERT INTO order_details VALUES (152, 10304, 71, 17.2000008, 2, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 34.40);
INSERT INTO order_details VALUES (153, 10305, 18, 50, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1249.90);
INSERT INTO order_details VALUES (154, 10305, 29, 99, 25, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 2474.90);
INSERT INTO order_details VALUES (155, 10305, 39, 14.3999996, 30, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 431.90);
INSERT INTO order_details VALUES (156, 10306, 30, 20.7000008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 207.00);
INSERT INTO order_details VALUES (157, 10306, 53, 26.2000008, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 262.00);
INSERT INTO order_details VALUES (158, 10306, 54, 5.9000001, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 29.50);
INSERT INTO order_details VALUES (159, 10307, 62, 39.4000015, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 394.00);
INSERT INTO order_details VALUES (160, 10307, 68, 10, 3, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 30.00);
INSERT INTO order_details VALUES (161, 10308, 69, 28.7999992, 1, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 28.80);
INSERT INTO order_details VALUES (162, 10308, 70, 12, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 60.00);
INSERT INTO order_details VALUES (1788, 10937, 34, 14, 20, 0, 2, NULL, NULL, 2, '2019-08-27 11:28:49.483233', 'F', 'F', 1, 280.00);
INSERT INTO order_details VALUES (1735, 10916, 16, 17.4500008, 6, 0, 1, NULL, NULL, 2, '2019-08-27 11:29:21.090609', 'F', 'F', 1, 104.70);
INSERT INTO order_details VALUES (1856, 10964, 69, 36, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 360.00);
INSERT INTO order_details VALUES (1857, 10965, 51, 53, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 848.00);
INSERT INTO order_details VALUES (1858, 10966, 37, 26, 8, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 208.00);
INSERT INTO order_details VALUES (1859, 10966, 56, 38, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 455.85);
INSERT INTO order_details VALUES (1860, 10966, 62, 49.2999992, 12, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 591.45);
INSERT INTO order_details VALUES (1866, 10969, 46, 12, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (1871, 10973, 26, 31.2299995, 5, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 156.15);
INSERT INTO order_details VALUES (1872, 10973, 41, 9.64999962, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 57.90);
INSERT INTO order_details VALUES (1873, 10973, 75, 7.75, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 77.50);
INSERT INTO order_details VALUES (1875, 10975, 8, 40, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 640.00);
INSERT INTO order_details VALUES (1876, 10975, 75, 7.75, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 77.50);
INSERT INTO order_details VALUES (1877, 10976, 28, 45.5999985, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 912.00);
INSERT INTO order_details VALUES (1878, 10977, 39, 18, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (1879, 10977, 47, 9.5, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 285.00);
INSERT INTO order_details VALUES (1880, 10977, 51, 53, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 530.00);
INSERT INTO order_details VALUES (1881, 10977, 63, 43.9000015, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 878.00);
INSERT INTO order_details VALUES (1882, 10978, 8, 40, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 799.85);
INSERT INTO order_details VALUES (1883, 10978, 21, 10, 40, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 399.85);
INSERT INTO order_details VALUES (1884, 10978, 40, 18.3999996, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 184.00);
INSERT INTO order_details VALUES (1885, 10978, 44, 19.4500008, 6, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 116.55);
INSERT INTO order_details VALUES (1892, 10980, 75, 7.75, 40, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 309.80);
INSERT INTO order_details VALUES (1893, 10981, 38, 263.5, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 15810.00);
INSERT INTO order_details VALUES (1894, 10982, 7, 30, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (1895, 10982, 43, 46, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 414.00);
INSERT INTO order_details VALUES (1896, 10983, 13, 6, 84, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 503.85);
INSERT INTO order_details VALUES (1897, 10983, 57, 19.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 292.50);
INSERT INTO order_details VALUES (1898, 10984, 16, 17.4500008, 55, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 959.75);
INSERT INTO order_details VALUES (1899, 10984, 24, 4.5, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1900, 10984, 36, 19, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (1901, 10985, 16, 17.4500008, 36, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 628.10);
INSERT INTO order_details VALUES (1902, 10985, 18, 62.5, 8, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 499.90);
INSERT INTO order_details VALUES (1903, 10985, 32, 32, 35, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1119.90);
INSERT INTO order_details VALUES (1908, 10987, 7, 30, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1800.00);
INSERT INTO order_details VALUES (1909, 10987, 43, 46, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 276.00);
INSERT INTO order_details VALUES (1910, 10987, 72, 34.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 696.00);
INSERT INTO order_details VALUES (1911, 10988, 7, 30, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1800.00);
INSERT INTO order_details VALUES (1912, 10988, 62, 49.2999992, 40, 0.100000001, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1971.90);
INSERT INTO order_details VALUES (1920, 10991, 2, 19, 50, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 949.80);
INSERT INTO order_details VALUES (1921, 10991, 70, 15, 20, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 299.80);
INSERT INTO order_details VALUES (1922, 10991, 76, 18, 90, 0.200000003, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1619.80);
INSERT INTO order_details VALUES (1924, 10993, 29, 123.790001, 50, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 6189.25);
INSERT INTO order_details VALUES (1925, 10993, 41, 9.64999962, 35, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 337.50);
INSERT INTO order_details VALUES (1927, 10995, 51, 53, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1060.00);
INSERT INTO order_details VALUES (1928, 10995, 60, 34, 4, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 136.00);
INSERT INTO order_details VALUES (1929, 10996, 42, 14, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 560.00);
INSERT INTO order_details VALUES (1930, 10997, 32, 32, 50, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1600.00);
INSERT INTO order_details VALUES (1931, 10997, 46, 12, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 239.75);
INSERT INTO order_details VALUES (1932, 10997, 52, 7, 20, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 139.75);
INSERT INTO order_details VALUES (1933, 10998, 24, 4.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (1934, 10998, 61, 28.5, 7, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 199.50);
INSERT INTO order_details VALUES (1935, 10998, 74, 10, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 200.00);
INSERT INTO order_details VALUES (1936, 10998, 75, 7.75, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 232.50);
INSERT INTO order_details VALUES (1937, 10999, 41, 9.64999962, 20, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 192.95);
INSERT INTO order_details VALUES (1938, 10999, 51, 53, 15, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 794.95);
INSERT INTO order_details VALUES (1939, 10999, 77, 13, 21, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 272.95);
INSERT INTO order_details VALUES (1940, 11000, 4, 22, 25, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 549.75);
INSERT INTO order_details VALUES (1941, 11000, 24, 4.5, 30, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 134.75);
INSERT INTO order_details VALUES (1942, 11000, 77, 13, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 390.00);
INSERT INTO order_details VALUES (1943, 11001, 7, 30, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1800.00);
INSERT INTO order_details VALUES (1944, 11001, 22, 21, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 525.00);
INSERT INTO order_details VALUES (1945, 11001, 46, 12, 25, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 300.00);
INSERT INTO order_details VALUES (1946, 11001, 55, 24, 6, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 144.00);
INSERT INTO order_details VALUES (1947, 11002, 13, 6, 56, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 336.00);
INSERT INTO order_details VALUES (1948, 11002, 35, 18, 15, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 269.85);
INSERT INTO order_details VALUES (1949, 11002, 42, 14, 24, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 335.85);
INSERT INTO order_details VALUES (1950, 11002, 55, 24, 40, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 960.00);
INSERT INTO order_details VALUES (1926, 10994, 59, 55, 18, 0.0500000007, 1, NULL, NULL, 2, '2019-08-28 11:24:51.887499', 'F', 'F', 1, 989.95);
INSERT INTO order_details VALUES (1956, 11005, 1, 18, 2, 0, 1, NULL, NULL, 2, '2019-08-28 11:34:14.423278', 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (1957, 11005, 59, 55, 10, 0, 2, NULL, NULL, 2, '2019-08-28 11:34:14.423278', 'F', 'F', 1, 550.00);
INSERT INTO order_details VALUES (1868, 10971, 29, 123.790001, 14, 0, 1, NULL, NULL, 2, '2019-08-28 11:45:13.44612', 'F', 'F', 1, 1733.06);
INSERT INTO order_details VALUES (1869, 10972, 17, 39, 6, 0, 1, NULL, NULL, 2, '2019-08-28 11:46:28.792992', 'F', 'F', 1, 234.00);
INSERT INTO order_details VALUES (1867, 10970, 52, 7, 40, 0.200000003, 1, NULL, NULL, 2, '2019-08-29 05:25:31.671999', 'F', 'F', 1, 279.80);
INSERT INTO order_details VALUES (1960, 11007, 8, 40, 30, 0, 1, NULL, NULL, 2, '2019-08-29 06:41:30.968608', 'F', 'F', 1, 1200.00);
INSERT INTO order_details VALUES (1874, 10974, 63, 43.9000015, 10, 0, 1, NULL, NULL, 2, '2019-08-29 07:14:08.994939', 'F', 'F', 1, 439.00);
INSERT INTO order_details VALUES (1923, 10992, 72, 34.7999992, 2, 0, 1, NULL, NULL, 2, '2019-08-29 07:15:24.898166', 'F', 'F', 1, 69.60);
INSERT INTO order_details VALUES (1951, 11003, 1, 18, 4, 0, 1, NULL, NULL, 2, '2019-08-29 07:16:50.782117', 'F', 'F', 1, 72.00);
INSERT INTO order_details VALUES (1952, 11003, 40, 18.3999996, 10, 0, 2, NULL, NULL, 2, '2019-08-29 07:16:50.782117', 'F', 'F', 1, 184.00);
INSERT INTO order_details VALUES (1861, 10967, 19, 9.19999981, 12, 0, 1, NULL, NULL, 2, '2019-08-29 07:18:21.942433', 'F', 'F', 1, 110.40);
INSERT INTO order_details VALUES (1862, 10967, 49, 20, 40, 0, 2, NULL, NULL, 2, '2019-08-29 07:18:21.942433', 'F', 'F', 1, 800.00);
INSERT INTO order_details VALUES (1843, 10959, 75, 7.75, 20, 0.150000006, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 154.85);
INSERT INTO order_details VALUES (1844, 10960, 24, 4.5, 10, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 44.75);
INSERT INTO order_details VALUES (1845, 10960, 41, 9.64999962, 24, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 231.60);
INSERT INTO order_details VALUES (1846, 10961, 52, 7, 6, 0.0500000007, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 41.95);
INSERT INTO order_details VALUES (1847, 10961, 76, 18, 60, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1080.00);
INSERT INTO order_details VALUES (1848, 10962, 7, 30, 45, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1350.00);
INSERT INTO order_details VALUES (1849, 10962, 13, 6, 77, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 462.00);
INSERT INTO order_details VALUES (1850, 10962, 53, 32.7999992, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 656.00);
INSERT INTO order_details VALUES (1851, 10962, 69, 36, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 324.00);
INSERT INTO order_details VALUES (1852, 10962, 76, 18, 44, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 792.00);
INSERT INTO order_details VALUES (1787, 10937, 28, 45.5999985, 8, 0, 1, NULL, NULL, 2, '2019-08-27 11:28:49.483233', 'F', 'F', 1, 364.80);
INSERT INTO order_details VALUES (1966, 11009, 24, 4.5, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 54.00);
INSERT INTO order_details VALUES (1967, 11009, 36, 19, 18, 0.25, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 341.75);
INSERT INTO order_details VALUES (1968, 11009, 60, 34, 9, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 306.00);
INSERT INTO order_details VALUES (1969, 11010, 7, 30, 20, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 600.00);
INSERT INTO order_details VALUES (1970, 11010, 24, 4.5, 10, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 45.00);
INSERT INTO order_details VALUES (1886, 10979, 7, 30, 18, 0, 1, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 540.00);
INSERT INTO order_details VALUES (1887, 10979, 12, 38, 20, 0, 2, NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (1863, 10968, 12, 38, 30, 0, 1, NULL, NULL, 2, '2019-08-28 04:25:43.965129', 'F', 'F', 1, 1140.00);
INSERT INTO order_details VALUES (1864, 10968, 24, 4.5, 30, 0, 2, NULL, NULL, 2, '2019-08-28 04:25:43.965129', 'F', 'F', 1, 135.00);
INSERT INTO order_details VALUES (1865, 10968, 64, 33.25, 4, 0, 3, NULL, NULL, 2, '2019-08-28 04:25:43.965129', 'F', 'F', 1, 133.00);
INSERT INTO order_details VALUES (1916, 10990, 21, 10, 65, 0, 1, NULL, NULL, 2, '2019-08-28 04:25:48.375918', 'F', 'F', 1, 650.00);
INSERT INTO order_details VALUES (1971, 11011, 58, 13.25, 40, 0.0500000007, 1, NULL, NULL, 2, '2019-08-29 05:03:49.748107', 'F', 'F', 1, 529.95);
INSERT INTO order_details VALUES (1972, 11011, 71, 21.5, 20, 0, 2, NULL, NULL, 2, '2019-08-29 05:03:49.748107', 'F', 'F', 1, 430.00);
INSERT INTO order_details VALUES (1973, 11012, 19, 9.19999981, 50, 0.0500000007, 1, NULL, NULL, 2, '2019-08-29 05:53:12.730507', 'F', 'F', 1, 459.95);
INSERT INTO order_details VALUES (1974, 11012, 60, 34, 36, 0.0500000007, 2, NULL, NULL, 2, '2019-08-29 05:53:12.730507', 'F', 'F', 1, 1223.95);
INSERT INTO order_details VALUES (1975, 11012, 71, 21.5, 60, 0.0500000007, 3, NULL, NULL, 2, '2019-08-29 05:53:12.730507', 'F', 'F', 1, 1289.95);
INSERT INTO order_details VALUES (1853, 10963, 60, 34, 2, 0.150000006, 1, NULL, NULL, 2, '2019-08-29 05:55:27.098907', 'F', 'F', 1, 67.85);
INSERT INTO order_details VALUES (1976, 11013, 23, 9, 10, 0, 4, NULL, NULL, 2, '2019-08-29 06:57:09.202606', 'F', 'F', 1, 90.00);
INSERT INTO order_details VALUES (1917, 10990, 34, 14, 60, 0.150000006, 2, NULL, NULL, 2, '2019-08-28 04:25:48.375918', 'F', 'F', 1, 839.85);
INSERT INTO order_details VALUES (1918, 10990, 55, 24, 65, 0.150000006, 3, NULL, NULL, 2, '2019-08-28 04:25:48.375918', 'F', 'F', 1, 1559.85);
INSERT INTO order_details VALUES (1963, 11008, 28, 45.5999985, 70, 0.0500000007, 1, NULL, NULL, 2, '2019-08-28 04:25:53.267368', 'F', 'F', 1, 3191.95);
INSERT INTO order_details VALUES (1964, 11008, 34, 14, 90, 0.0500000007, 2, NULL, NULL, 2, '2019-08-28 04:25:53.267368', 'F', 'F', 1, 1259.95);
INSERT INTO order_details VALUES (1965, 11008, 71, 21.5, 21, 0, 3, NULL, NULL, 2, '2019-08-28 04:25:53.267368', 'F', 'F', 1, 451.50);
INSERT INTO order_details VALUES (1954, 11004, 26, 31.2299995, 6, 0, 1, NULL, NULL, 2, '2019-08-28 04:34:46.240349', 'F', 'F', 1, 187.38);
INSERT INTO order_details VALUES (1955, 11004, 76, 18, 6, 0, 2, NULL, NULL, 2, '2019-08-28 04:34:46.240349', 'F', 'F', 1, 108.00);
INSERT INTO order_details VALUES (1983, 11016, 31, 12.5, 15, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 187.50);
INSERT INTO order_details VALUES (1984, 11016, 36, 19, 16, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 304.00);
INSERT INTO order_details VALUES (1999, 11022, 19, 9.19999981, 35, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 322.00);
INSERT INTO order_details VALUES (2000, 11022, 69, 36, 30, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 1080.00);
INSERT INTO order_details VALUES (1000, 10626, 53, 32.7999992, 12, 0, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1, 393.60);
INSERT INTO order_details VALUES (1991, 11019, 46, 12, 3, 0, 1, NULL, NULL, 2, '2019-08-27 11:11:43.687025', 'F', 'F', 1, 36.00);
INSERT INTO order_details VALUES (1992, 11019, 49, 20, 2, 0, 2, NULL, NULL, 2, '2019-08-27 11:11:43.687025', 'F', 'F', 1, 40.00);
INSERT INTO order_details VALUES (1985, 11017, 3, 10, 25, 0, 1, NULL, NULL, 2, '2019-08-28 04:25:58.2129', 'F', 'F', 1, 250.00);
INSERT INTO order_details VALUES (1986, 11017, 59, 55, 110, 0, 2, NULL, NULL, 2, '2019-08-28 04:25:58.2129', 'F', 'F', 1, 6050.00);
INSERT INTO order_details VALUES (1987, 11017, 70, 15, 30, 0, 3, NULL, NULL, 2, '2019-08-28 04:25:58.2129', 'F', 'F', 1, 450.00);
INSERT INTO order_details VALUES (1988, 11018, 12, 38, 20, 0, 1, NULL, NULL, 2, '2019-08-29 06:25:37.11741', 'F', 'F', 1, 760.00);
INSERT INTO order_details VALUES (1989, 11018, 18, 62.5, 10, 0, 2, NULL, NULL, 2, '2019-08-29 06:25:37.11741', 'F', 'F', 1, 625.00);
INSERT INTO order_details VALUES (1990, 11018, 56, 38, 5, 0, 3, NULL, NULL, 2, '2019-08-29 06:25:37.11741', 'F', 'F', 1, 190.00);
INSERT INTO order_details VALUES (1993, 11020, 10, 31, 24, 0.150000006, 1, NULL, NULL, 2, '2019-08-29 06:37:56.722081', 'F', 'F', 1, 743.85);
INSERT INTO order_details VALUES (1994, 11021, 2, 19, 11, 0.25, 1, NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, 208.75);
INSERT INTO order_details VALUES (1995, 11021, 20, 81, 15, 0, 2, NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, 1215.00);
INSERT INTO order_details VALUES (1996, 11021, 26, 31.2299995, 63, 0, 3, NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, 1967.49);
INSERT INTO order_details VALUES (1997, 11021, 51, 53, 44, 0.25, 4, NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, 2331.75);
INSERT INTO order_details VALUES (1998, 11021, 72, 34.7999992, 35, 0, 5, NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, 1218.00);
INSERT INTO order_details VALUES (1981, 11015, 30, 25.8899994, 15, 0, 1, NULL, NULL, 2, '2019-08-29 06:58:21.781338', 'F', 'F', 1, 388.35);
INSERT INTO order_details VALUES (1982, 11015, 77, 13, 18, 0, 2, NULL, NULL, 2, '2019-08-29 06:58:21.781338', 'F', 'F', 1, 234.00);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO orders VALUES (10978, '50', 9, '2019-03-26', '2019-04-23', '2019-04-23', 2, 32.8199997, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00791', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1533.07);
INSERT INTO orders VALUES (10896, '50', 7, '2019-02-19', '2019-03-19', '2019-02-27', 3, 32.4500008, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00792', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 782.95);
INSERT INTO orders VALUES (10892, '50', 4, '2019-02-17', '2019-03-17', '2019-02-19', 2, 120.269997, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00793', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2320.22);
INSERT INTO orders VALUES (10760, '50', 4, '2018-12-01', '2018-12-29', '2018-12-10', 1, 155.639999, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00794', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3459.14);
INSERT INTO orders VALUES (11088, '94', 10, '2019-08-21', '2019-09-03', '2019-08-21', 10, 11, 'Camilo Mendid Mellow ', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', '', '682306', 'India', 'ORD-00842', NULL, '9.986262899999998,76.32980889999999', 2, '2019-08-21 04:00:40.575258', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, NULL, 1681.00);
INSERT INTO orders VALUES (11012, '25', 1, '2019-04-09', '2019-04-23', '2019-04-17', 3, 242.949997, 'Frankenversand', 'Berliner Platz 43', 'München', '', '80805', 'Germany', 'ORD-00207', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, 2, '2019-08-29 05:53:12.730507', 'F', 'F', 1, NULL, 3216.8);
INSERT INTO orders VALUES (10859, '25', 1, '2019-01-29', '2019-02-26', '2019-02-02', 2, 76.0999985, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00209', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1513.60);
INSERT INTO orders VALUES (10791, '25', 6, '2018-12-23', '2019-01-20', '2019-01-01', 2, 16.8500004, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00210', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1942.81);
INSERT INTO orders VALUES (10717, '25', 1, '2018-10-24', '2018-11-21', '2018-10-29', 2, 59.25, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00211', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1390.90);
INSERT INTO orders VALUES (10675, '25', 5, '2018-09-19', '2018-10-17', '2018-09-23', 2, 31.8500004, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00212', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1454.85);
INSERT INTO orders VALUES (10670, '25', 4, '2018-09-16', '2018-10-14', '2018-09-18', 1, 203.479996, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00213', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2505.23);
INSERT INTO orders VALUES (10623, '25', 8, '2018-08-07', '2018-09-04', '2018-08-12', 2, 97.1800003, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00214', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1526.63);
INSERT INTO orders VALUES (10560, '25', 8, '2018-06-06', '2018-07-04', '2018-06-09', 1, 36.6500015, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00215', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1293.70);
INSERT INTO orders VALUES (10488, '25', 8, '2018-03-27', '2018-04-24', '2018-04-02', 2, 4.92999983, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00216', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1564.73);
INSERT INTO orders VALUES (10396, '25', 1, '2017-12-27', '2018-01-10', '2018-01-06', 3, 135.350006, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00217', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2039.15);
INSERT INTO orders VALUES (10342, '25', 4, '2017-10-30', '2017-11-13', '2017-11-04', 2, 54.8300018, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00218', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2354.83);
INSERT INTO orders VALUES (10337, '25', 4, '2017-10-24', '2017-11-21', '2017-10-29', 3, 108.260002, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00219', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2575.26);
INSERT INTO orders VALUES (10604, '28', 1, '2018-07-18', '2018-08-15', '2018-07-29', 1, 7.46000004, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00530', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 263.76);
INSERT INTO orders VALUES (10551, '28', 4, '2018-05-28', '2018-07-09', '2018-06-06', 3, 72.9499969, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00531', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1908.65);
INSERT INTO orders VALUES (10934, '44', 3, '2019-03-09', '2019-04-06', '2019-03-12', 3, 32.0099983, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00318', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 532.01);
INSERT INTO orders VALUES (10293, '80', 1, '2017-08-29', '2017-09-26', '2017-09-11', 3, 21.1800003, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00292', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 869.88);
INSERT INTO orders VALUES (10276, '80', 8, '2017-08-08', '2017-08-22', '2017-08-14', 3, 13.8400002, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00293', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 433.84);
INSERT INTO orders VALUES (10546, '84', 1, '2018-05-23', '2018-06-20', '2018-05-27', 3, 194.720001, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00032', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3006.72);
INSERT INTO orders VALUES (10478, '84', 2, '2018-03-18', '2018-04-01', '2018-03-26', 3, 4.80999994, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00033', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 500.76);
INSERT INTO orders VALUES (10459, '84', 4, '2018-02-27', '2018-03-27', '2018-02-28', 2, 25.0900002, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00034', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1712.99);
INSERT INTO orders VALUES (10450, '84', 8, '2018-02-19', '2018-03-19', '2018-03-11', 2, 7.23000002, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00035', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 538.23);
INSERT INTO orders VALUES (10334, '84', 8, '2017-10-21', '2017-11-18', '2017-10-28', 2, 8.56000042, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00036', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 153.36);
INSERT INTO orders VALUES (10251, '84', 3, '2017-07-08', '2017-08-05', '2017-07-15', 1, 41.3400002, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00037', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 712.04);
INSERT INTO orders VALUES (11097, '99', 10, '2019-08-26', '2019-09-24', '2019-08-26', 9, 11, 'Atlanta', '7971, Arakashan Rd', 'New Delhi', '', '110055', 'India', 'ORD-00851', NULL, '28.6461917,77.21406619999993', 2, '2019-08-26 06:31:20.890637', 2, '2019-09-06 04:24:59.007874', 'F', 'F', 6, NULL, 1691);
INSERT INTO orders VALUES (10649, '50', 5, '2018-08-28', '2018-09-25', '2018-08-29', 3, 6.19999981, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00795', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1440.20);
INSERT INTO orders VALUES (10529, '50', 5, '2018-05-07', '2018-06-04', '2018-05-09', 2, 66.6900024, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', NULL, 'B-1180', 'Belgium', 'ORD-00796', NULL, '50.8029276,4.436011600000029', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1012.69);
INSERT INTO orders VALUES (10875, '5', 4, '2019-02-06', '2019-03-06', '2019-03-03', 2, 32.3699989, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00300', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 761.77);
INSERT INTO orders VALUES (10779, '52', 3, '2018-12-16', '2019-01-13', '2019-01-14', 2, 58.1300011, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', NULL, '04179', 'Germany', 'ORD-00295', NULL, '54.467353,9.397662399999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1393.13);
INSERT INTO orders VALUES (10699, '52', 3, '2018-10-09', '2018-11-06', '2018-10-13', 3, 0.579999983, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', NULL, '04179', 'Germany', 'ORD-00296', NULL, '54.467353,9.397662399999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 114.58);
INSERT INTO orders VALUES (10575, '52', 5, '2018-06-20', '2018-07-04', '2018-06-30', 1, 127.339996, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', NULL, '04179', 'Germany', 'ORD-00297', NULL, '54.467353,9.397662399999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2274.74);
INSERT INTO orders VALUES (10277, '52', 2, '2017-08-09', '2017-09-06', '2017-08-13', 3, 125.769997, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', NULL, '04179', 'Germany', 'ORD-00298', NULL, '54.467353,9.397662399999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1326.57);
INSERT INTO orders VALUES (10945, '52', 4, '2019-03-12', '2019-04-09', '2019-03-18', 1, 10.2200003, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '04179', 'Germany', 'ORD-00294', NULL, '54.467353,9.397662399999945', NULL, NULL, 2, '2019-08-29 06:28:47.977338', 'F', 'F', 1, NULL, 255.22);
INSERT INTO orders VALUES (11013, '69', 2, '2019-04-09', '2019-05-07', '2019-04-10', 1, 32.9900017, 'Romero y tomillo', 'Gran Vía, 1', 'Madrid', '', '28001', 'Spain', 'ORD-00332', NULL, '36.7050887,-4.4357711999999765', NULL, NULL, 2, '2019-08-29 06:57:09.202606', 'F', 'F', 1, NULL, 393.99);
INSERT INTO orders VALUES (10491, '28', 8, '2018-03-31', '2018-04-28', '2018-04-08', 3, 16.9599991, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00532', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 321.96);
INSERT INTO orders VALUES (11089, '93', 10, '2019-08-21', '2019-09-10', '2019-08-21', 9, 15, 'Sree Mahalakshmi Food Industries', '18/1348, Palluruthy', 'Kochi', '', ' 682006', 'India', 'ORD-00843', NULL, '10.0458956,76.3135595', 2, '2019-08-21 04:02:31.914656', 2, '2019-08-27 11:20:41.804531', 'F', 'F', 6, NULL, 2069.00);
INSERT INTO orders VALUES (10737, '85', 2, '2018-11-11', '2018-12-09', '2018-11-18', 2, 7.78999996, 'Vins et alcools Chevalier', '59 rue de l''Abbaye', 'Reims', NULL, '51100', 'France', 'ORD-00004', NULL, '48.93861547113219,2.6157318472213547', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 147.59);
INSERT INTO orders VALUES (10295, '85', 2, '2017-09-02', '2017-09-30', '2017-09-10', 2, 1.14999998, 'Vins et alcools Chevalier', '59 rue de l''Abbaye', 'Reims', NULL, '51100', 'France', 'ORD-00005', NULL, '48.93861547113219,2.6157318472213547', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 122.75);
INSERT INTO orders VALUES (10274, '85', 6, '2017-08-06', '2017-09-03', '2017-08-16', 1, 6.01000023, 'Vins et alcools Chevalier', '59 rue de l''Abbaye', 'Reims', NULL, '51100', 'France', 'ORD-00006', NULL, '48.93861547113219,2.6157318472213547', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 544.61);
INSERT INTO orders VALUES (10248, '85', 5, '2017-07-04', '2017-08-01', '2017-07-16', 3, 32.3800011, 'Vins et alcools Chevalier', '59 rue de l''Abbaye', 'Reims', NULL, '51100', 'France', 'ORD-00007', NULL, '48.93861547113219,2.6157318472213547', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 304.38);
INSERT INTO orders VALUES (10739, '85', 3, '2018-11-12', '2018-12-10', '2018-11-17', 3, 11.0799999, 'Vins et alcools Chevalier', '59 rue de l''Abbaye', 'Reims', '', '51100', 'France', 'ORD-00003', NULL, '48.93861547113219,2.6157318472213547', NULL, NULL, 2, '2019-08-29 07:23:03.903528', 'F', 'F', 1, NULL, 251.08);
INSERT INTO orders VALUES (10464, '28', 4, '2018-03-04', '2018-04-01', '2018-03-14', 2, 89, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00533', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1936.60);
INSERT INTO orders VALUES (10352, '28', 3, '2017-11-12', '2017-11-26', '2017-11-18', 3, 1.29999995, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00534', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 155.15);
INSERT INTO orders VALUES (10328, '28', 4, '2017-10-14', '2017-11-11', '2017-10-17', 3, 87.0299988, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00535', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1255.03);
INSERT INTO orders VALUES (10712, '37', 3, '2018-10-21', '2018-11-18', '2018-10-31', 1, 89.9300003, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00400', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1328.28);
INSERT INTO orders VALUES (10917, '69', 4, '2019-03-02', '2019-03-30', '2019-03-11', 2, 8.28999996, 'Romero y tomillo', 'Gran Vía, 1', 'Madrid', NULL, '28001', 'Spain', 'ORD-00333', NULL, '36.7050887,-4.4357711999999765', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 374.18);
INSERT INTO orders VALUES (11065, '46', 8, '2019-05-01', '2019-05-29', NULL, 1, 12.9099998, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00338', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 264.97);
INSERT INTO orders VALUES (10997, '46', 8, '2019-04-03', '2019-05-15', '2019-04-13', 2, 73.9100037, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00339', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2053.41);
INSERT INTO orders VALUES (10899, '46', 5, '2019-02-20', '2019-03-20', '2019-02-26', 3, 1.21000004, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00340', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 145.06);
INSERT INTO orders VALUES (10823, '46', 5, '2019-01-09', '2019-02-06', '2019-01-13', 2, 163.970001, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00341', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3271.17);
INSERT INTO orders VALUES (11035, '76', 2, '2019-04-20', '2019-05-18', '2019-04-24', 2, 0.170000002, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium', 'ORD-00039', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, 2, '2019-08-28 10:36:21.281009', 'F', 'F', 1, NULL, 1754.67);
INSERT INTO orders VALUES (10252, '76', 4, '2017-07-09', '2017-08-06', '2017-07-11', 2, 51.2999992, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium', 'ORD-00049', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, 2, '2019-08-26 08:18:19.054165', 'F', 'F', 1, NULL, 3781.20);
INSERT INTO orders VALUES (11059, '67', 2, '2019-04-29', '2019-06-10', '2019-08-28', 2, 85.8000031, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00351', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, 2, '2019-08-28 11:04:55.418245', 'F', 'F', 1, NULL, 1923.8);
INSERT INTO orders VALUES (10877, '67', 1, '2019-02-09', '2019-03-09', '2019-02-19', 1, 38.0600014, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00352', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2123.81);
INSERT INTO orders VALUES (10306, '69', 1, '2017-09-16', '2017-10-14', '2017-09-23', 3, 7.55999994, 'Romero y tomillo', 'Gran Vía, 1', 'Madrid', NULL, '28001', 'Spain', 'ORD-00334', NULL, '36.7050887,-4.4357711999999765', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 506.06);
INSERT INTO orders VALUES (10282, '69', 4, '2017-08-15', '2017-09-12', '2017-08-21', 1, 12.6899996, 'Romero y tomillo', 'Gran Vía, 1', 'Madrid', NULL, '28001', 'Spain', 'ORD-00335', NULL, '36.7050887,-4.4357711999999765', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 168.09);
INSERT INTO orders VALUES (10281, '69', 4, '2017-08-14', '2017-08-28', '2017-08-21', 1, 2.94000006, 'Romero y tomillo', 'Gran Vía, 1', 'Madrid', NULL, '28001', 'Spain', 'ORD-00336', NULL, '36.7050887,-4.4357711999999765', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 89.44);
INSERT INTO orders VALUES (11062, '66', 4, '2019-04-30', '2019-05-28', '2019-08-29', 2, 29.9300003, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy', 'ORD-00362', NULL, '44.64407,11.061351999999943', NULL, NULL, 2, '2019-08-29 06:53:16.162349', 'F', 'F', 1, NULL, 537.53);
INSERT INTO orders VALUES (11010, '66', 2, '2019-04-09', '2019-05-07', '2019-04-21', 2, 28.7099991, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00363', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 673.71);
INSERT INTO orders VALUES (10942, '66', 9, '2019-03-11', '2019-04-08', '2019-03-18', 3, 17.9500008, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00364', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 577.95);
INSERT INTO orders VALUES (10908, '66', 4, '2019-02-26', '2019-03-26', '2019-03-06', 2, 32.9599991, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00365', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 730.86);
INSERT INTO orders VALUES (10930, '76', 4, '2019-03-06', '2019-04-17', '2019-03-18', 3, 15.5500002, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00040', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2470.15);
INSERT INTO orders VALUES (10986, '54', 8, '2019-03-30', '2019-04-27', '2019-04-21', 2, 217.860001, 'Océano Atlántico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00730', NULL, '-34.7977576,-58.484311400000024', NULL, NULL, 2, '2019-08-27 11:10:57.853433', 'F', 'F', 1, NULL, 2437.86);
INSERT INTO orders VALUES (11019, '64', 6, '2019-04-13', '2019-05-11', '2019-08-27', 3, 3.17000008, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00753', NULL, '-34.37643680000001,-59.11336510000001', NULL, NULL, 2, '2019-08-27 11:11:43.687025', 'F', 'F', 1, NULL, 79.17);
INSERT INTO orders VALUES (10716, '64', 4, '2018-10-24', '2018-11-21', '2018-10-27', 2, 22.5699997, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00756', NULL, '-34.37643680000001,-59.11336510000001', NULL, NULL, 2, '2019-08-27 11:13:16.031494', 'F', 'F', 1, NULL, 728.57);
INSERT INTO orders VALUES (11090, '96', 9, '2019-08-21', '2019-10-08', '2019-08-21', 7, 25, 'Ginger Mumbai, Andheri', ' Mahakali Caves Rd', 'Mumbai', '', '400093', 'India', 'ORD-00844', NULL, '19.1285273,72.86867529999995', 2, '2019-08-21 05:24:30.249047', 2, '2019-08-27 11:25:24.97793', 'F', 'F', 6, NULL, 1407.00);
INSERT INTO orders VALUES (10303, '30', 7, '2017-09-11', '2017-10-09', '2017-09-18', 2, 107.830002, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00433', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1349.53);
INSERT INTO orders VALUES (10681, '32', 3, '2018-09-25', '2018-10-23', '2018-09-30', 3, 76.1299973, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00784', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1402.93);
INSERT INTO orders VALUES (10656, '32', 6, '2018-09-04', '2018-10-02', '2018-09-10', 1, 57.1500015, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00785', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 728.20);
INSERT INTO orders VALUES (10617, '32', 4, '2018-07-31', '2018-08-28', '2018-08-04', 2, 18.5300007, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00786', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1668.38);
INSERT INTO orders VALUES (10616, '32', 1, '2018-07-31', '2018-08-28', '2018-08-05', 2, 116.529999, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00787', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5148.38);
INSERT INTO orders VALUES (10589, '32', 8, '2018-07-04', '2018-08-01', '2018-07-14', 2, 4.42000008, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00788', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 76.42);
INSERT INTO orders VALUES (10528, '32', 6, '2018-05-06', '2018-05-20', '2018-05-09', 2, 3.3499999, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00789', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 399.35);
INSERT INTO orders VALUES (10693, '89', 3, '2018-10-06', '2018-10-20', '2018-10-10', 3, 139.339996, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00230', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2472.89);
INSERT INTO orders VALUES (11063, '37', 3, '2019-04-30', '2019-05-28', '2019-05-06', 2, 81.7300034, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '57810', 'Ireland', 'ORD-00395', NULL, '51.6940347,-9.725607800000034', NULL, NULL, 2, '2019-08-29 06:13:11.12174', 'F', 'F', 1, NULL, 1527.03);
INSERT INTO orders VALUES (10596, '89', 8, '2018-07-11', '2018-08-08', '2018-08-12', 1, 16.3400002, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00231', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1491.84);
INSERT INTO orders VALUES (10428, '66', 7, '2018-01-28', '2018-02-25', '2018-02-04', 1, 11.0900002, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00372', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 203.09);
INSERT INTO orders VALUES (10288, '66', 4, '2017-08-23', '2017-09-20', '2017-09-03', 1, 7.44999981, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00373', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 96.25);
INSERT INTO orders VALUES (10504, '89', 4, '2018-04-11', '2018-05-09', '2018-04-18', 3, 59.1300011, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00232', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1447.63);
INSERT INTO orders VALUES (10483, '89', 7, '2018-03-24', '2018-04-21', '2018-04-25', 2, 15.2799997, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00233', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 719.18);
INSERT INTO orders VALUES (10469, '89', 1, '2018-03-10', '2018-04-07', '2018-03-14', 1, 60.1800003, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00234', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1185.23);
INSERT INTO orders VALUES (10344, '89', 4, '2017-11-01', '2017-11-29', '2017-11-05', 2, 23.2900009, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00235', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2879.04);
INSERT INTO orders VALUES (10269, '89', 5, '2017-07-31', '2017-08-14', '2017-08-09', 1, 4.55999994, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00236', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 680.46);
INSERT INTO orders VALUES (10885, '76', 6, '2019-02-12', '2019-03-12', '2019-02-18', 3, 5.63999987, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00041', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1214.64);
INSERT INTO orders VALUES (10846, '76', 2, '2019-01-22', '2019-03-05', '2019-01-23', 3, 56.4599991, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00042', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1168.46);
INSERT INTO orders VALUES (10841, '76', 5, '2019-01-20', '2019-02-17', '2019-01-29', 2, 424.299988, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00043', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5005.30);
INSERT INTO orders VALUES (10767, '76', 4, '2018-12-05', '2019-01-02', '2018-12-15', 3, 1.59000003, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00044', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 29.59);
INSERT INTO orders VALUES (10969, '15', 1, '2019-03-23', '2019-04-20', '2019-03-30', 2, 0.209999993, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00385', NULL, '-22.7454216,-47.37616909999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 108.21);
INSERT INTO orders VALUES (10834, '81', 1, '2019-01-15', '2019-02-12', '2019-01-19', 3, 29.7800007, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00390', NULL, '-23.5394124,-46.6458308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1537.80);
INSERT INTO orders VALUES (10830, '81', 4, '2019-01-13', '2019-02-24', '2019-01-21', 2, 81.8300018, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00391', NULL, '-23.5394124,-46.6458308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2055.83);
INSERT INTO orders VALUES (10606, '81', 4, '2018-07-22', '2018-08-19', '2018-07-31', 3, 79.4000015, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00392', NULL, '-23.5394124,-46.6458308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1491.80);
INSERT INTO orders VALUES (10947, '11', 3, '2019-03-13', '2019-04-10', '2019-03-16', 2, 3.25999999, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00375', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 223.26);
INSERT INTO orders VALUES (10943, '11', 4, '2019-03-11', '2019-04-08', '2019-03-19', 2, 2.17000008, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00376', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 713.17);
INSERT INTO orders VALUES (10599, '11', 6, '2018-07-15', '2018-08-26', '2018-07-21', 3, 29.9799995, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00377', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 522.98);
INSERT INTO orders VALUES (10578, '11', 4, '2018-06-24', '2018-07-22', '2018-07-25', 3, 29.6000004, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00378', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 506.60);
INSERT INTO orders VALUES (10539, '11', 6, '2018-05-16', '2018-06-13', '2018-05-23', 3, 12.3599997, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00379', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 367.86);
INSERT INTO orders VALUES (10475, '76', 9, '2018-03-14', '2018-04-11', '2018-04-04', 1, 68.5199966, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00045', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1838.87);
INSERT INTO orders VALUES (10463, '76', 5, '2018-03-04', '2018-04-01', '2018-03-06', 3, 14.7799997, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00046', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 728.08);
INSERT INTO orders VALUES (11088, '94', 10, '2019-08-21', '2019-09-03', '2019-08-21', 10, 11, 'Camilo Mendid Mellow ', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', '', '682306', 'India', 'ORD-00841', NULL, '9.986262899999998,76.32980889999999', 2, '2019-08-19 10:58:59.609907', 2, '2019-08-27 11:20:08.994444', 'F', 'F', 6, NULL, 1681.00);
INSERT INTO orders VALUES (11091, '97', 9, '2019-08-21', '2019-09-24', '2019-08-21', 7, 0, 'FabHotel Sahar Garden Marol', 'metro stn, Marol Maroshi Rd', 'Mumbai', '', '400059', 'India', 'ORD-00845', NULL, '19.1090441,72.87868809999998', 2, '2019-08-21 05:41:57.683605', 2, '2019-08-27 11:25:09.902861', 'F', 'F', 6, NULL, 4670.00);
INSERT INTO orders VALUES (11044, '91', 4, '2019-04-23', '2019-05-21', '2019-05-01', 1, 8.72000027, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', '', '01-012', 'Poland', 'ORD-00681', NULL, '52.228826,20.99402550000002', NULL, NULL, 2, '2019-08-29 07:26:41.962582', 'F', 'F', 1, NULL, 600.32);
INSERT INTO orders VALUES (11037, '30', 7, '2019-04-21', '2019-05-19', '2019-04-27', 1, 3.20000005, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00424', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 63.20);
INSERT INTO orders VALUES (11009, '30', 2, '2019-04-08', '2019-05-06', '2019-04-10', 1, 59.1100006, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00425', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 760.86);
INSERT INTO orders VALUES (10948, '30', 3, '2019-03-13', '2019-04-10', '2019-03-19', 3, 23.3899994, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00426', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2385.64);
INSERT INTO orders VALUES (10911, '30', 3, '2019-02-26', '2019-03-26', '2019-03-05', 1, 38.1899986, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00427', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 896.19);
INSERT INTO orders VALUES (10888, '30', 1, '2019-02-16', '2019-03-16', '2019-02-23', 2, 51.8699989, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00428', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 656.87);
INSERT INTO orders VALUES (10874, '30', 5, '2019-02-06', '2019-03-06', '2019-02-11', 2, 19.5799999, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00429', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 329.58);
INSERT INTO orders VALUES (10872, '30', 5, '2019-02-05', '2019-03-05', '2019-02-09', 2, 175.320007, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00430', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2341.92);
INSERT INTO orders VALUES (10629, '30', 4, '2018-08-12', '2018-09-09', '2018-08-20', 3, 85.4599991, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00431', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2860.51);
INSERT INTO orders VALUES (10550, '30', 7, '2018-05-28', '2018-06-25', '2018-06-06', 3, 4.32000017, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', 'ORD-00432', NULL, '41.99937120000001,-1.6796237999999448', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 753.02);
INSERT INTO orders VALUES (10901, '35', 4, '2019-02-23', '2019-03-23', '2019-02-26', 1, 62.0900002, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00081', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 996.59);
INSERT INTO orders VALUES (10458, '76', 7, '2018-02-26', '2018-03-26', '2018-03-04', 3, 147.059998, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00047', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4038.06);
INSERT INTO orders VALUES (10302, '76', 4, '2017-09-10', '2017-10-08', '2017-10-09', 2, 6.26999998, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00048', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2715.07);
INSERT INTO orders VALUES (10863, '35', 4, '2019-02-02', '2019-03-02', '2019-02-17', 2, 30.2600002, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00082', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 548.96);
INSERT INTO orders VALUES (10668, '86', 1, '2018-09-15', '2018-10-13', '2018-09-23', 2, 47.2200012, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00415', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 741.67);
INSERT INTO orders VALUES (10796, '35', 3, '2018-12-25', '2019-01-22', '2019-01-14', 1, 26.5200005, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00083', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2904.00);
INSERT INTO orders VALUES (10705, '35', 9, '2018-10-15', '2018-11-12', '2018-11-18', 2, 3.51999998, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00084', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 381.52);
INSERT INTO orders VALUES (10641, '35', 4, '2018-08-22', '2018-09-19', '2018-08-26', 2, 179.610001, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00085', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2233.61);
INSERT INTO orders VALUES (10613, '35', 4, '2018-07-29', '2018-08-26', '2018-08-01', 2, 8.10999966, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00086', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 366.01);
INSERT INTO orders VALUES (10883, '48', 8, '2019-02-12', '2019-03-12', '2019-02-20', 3, 0.529999971, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00445', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 36.53);
INSERT INTO orders VALUES (10867, '48', 6, '2019-02-03', '2019-03-17', '2019-02-11', 1, 1.92999995, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00446', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 100.33);
INSERT INTO orders VALUES (10665, '48', 1, '2018-09-11', '2018-10-09', '2018-09-17', 2, 26.3099995, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00447', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1321.31);
INSERT INTO orders VALUES (10965, '55', 6, '2019-03-20', '2019-04-17', '2019-03-30', 3, 144.380005, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00435', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 992.38);
INSERT INTO orders VALUES (10855, '55', 3, '2019-01-27', '2019-02-24', '2019-02-04', 1, 170.970001, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00436', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2446.07);
INSERT INTO orders VALUES (10808, '55', 2, '2019-01-01', '2019-01-29', '2019-01-09', 3, 45.5299988, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00437', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1705.23);
INSERT INTO orders VALUES (10706, '55', 8, '2018-10-16', '2018-11-13', '2018-10-21', 3, 135.630005, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00438', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2028.63);
INSERT INTO orders VALUES (10680, '55', 1, '2018-09-24', '2018-10-22', '2018-09-26', 1, 26.6100006, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00439', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1708.36);
INSERT INTO orders VALUES (10594, '55', 3, '2018-07-09', '2018-08-06', '2018-07-16', 2, 5.23999977, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00440', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 570.74);
INSERT INTO orders VALUES (11092, '98', 8, '2019-08-21', '2019-09-30', '2019-08-21', 3, 18, 'Amax Inn', '8145/6, Arakashan Road', 'New Delhi', '', '110055', 'India', 'ORD-00846', NULL, '28.646759,77.21322409999993', 2, '2019-08-21 06:05:54.708271', 2, '2019-08-27 11:24:21.978795', 'F', 'F', 6, NULL, 12682.50);
INSERT INTO orders VALUES (10958, '54', 7, '2019-03-18', '2019-04-15', '2019-03-27', 2, 49.5600014, 'Océano Atlántico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00731', NULL, '-34.7977576,-58.484311400000024', NULL, NULL, 2, '2019-08-27 11:27:58.406538', 'F', 'F', 1, NULL, 830.56);
INSERT INTO orders VALUES (10937, '12', 7, '2019-03-10', '2019-03-24', '2019-03-13', 3, 31.5100002, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00774', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-08-27 11:28:49.483233', 'F', 'F', 1, NULL, 676.31);
INSERT INTO orders VALUES (10601, '35', 7, '2018-07-16', '2018-08-27', '2018-07-22', 1, 58.2999992, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00087', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2343.30);
INSERT INTO orders VALUES (10267, '25', 4, '2017-07-29', '2017-08-26', '2017-08-06', 1, 208.580002, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00220', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4239.28);
INSERT INTO orders VALUES (10552, '35', 2, '2018-05-29', '2018-06-26', '2018-06-05', 1, 83.2200012, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00088', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 963.72);
INSERT INTO orders VALUES (10498, '35', 8, '2018-04-07', '2018-05-05', '2018-04-11', 2, 29.75, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00089', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 604.75);
INSERT INTO orders VALUES (10998, '91', 8, '2019-04-03', '2019-04-17', '2019-04-17', 2, 20.3099995, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00682', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 706.31);
INSERT INTO orders VALUES (10906, '91', 4, '2019-02-25', '2019-03-11', '2019-03-03', 3, 26.2900009, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00683', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 453.79);
INSERT INTO orders VALUES (10870, '91', 5, '2019-02-04', '2019-03-04', '2019-02-13', 3, 12.04, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00684', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 172.04);
INSERT INTO orders VALUES (10792, '91', 1, '2018-12-23', '2019-01-20', '2018-12-31', 3, 23.7900009, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00685', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 423.64);
INSERT INTO orders VALUES (10611, '91', 6, '2018-07-25', '2018-08-22', '2018-08-01', 2, 80.6500015, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00686', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 888.65);
INSERT INTO orders VALUES (10374, '91', 1, '2017-12-05', '2018-01-02', '2017-12-09', 3, 3.94000006, 'Wolski Zajazd', 'ul. Filtrowa 68', 'Warszawa', NULL, '01-012', 'Poland', 'ORD-00687', NULL, '52.228826,20.99402550000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 462.94);
INSERT INTO orders VALUES (10494, '15', 4, '2018-04-02', '2018-04-30', '2018-04-09', 2, 65.9899979, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00386', NULL, '-22.7454216,-47.37616909999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 977.99);
INSERT INTO orders VALUES (10466, '15', 4, '2018-03-06', '2018-04-03', '2018-03-13', 1, 11.9300003, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00387', NULL, '-22.7454216,-47.37616909999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 227.93);
INSERT INTO orders VALUES (10290, '15', 8, '2017-08-27', '2017-09-24', '2017-09-03', 1, 79.6999969, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00388', NULL, '-22.7454216,-47.37616909999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2248.70);
INSERT INTO orders VALUES (11042, '15', 2, '2019-04-22', '2019-05-06', '2019-05-01', 1, 29.9899998, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00384', NULL, '-22.7454216,-47.37616909999997', NULL, NULL, 2, '2019-08-28 10:43:37.783319', 'F', 'F', 1, NULL, 435.74);
INSERT INTO orders VALUES (10759, '2', 3, '2018-11-28', '2018-12-26', '2018-12-12', 3, 11.9899998, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', 'ORD-00453', NULL, '22.1249642,-100.9622', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 331.99);
INSERT INTO orders VALUES (10683, '18', 2, '2018-09-26', '2018-10-24', '2018-10-01', 1, 4.4000001, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', NULL, '44000', 'France', 'ORD-00461', NULL, '47.1929341,-1.5738794999999755', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 67.40);
INSERT INTO orders VALUES (10625, '2', 3, '2018-08-08', '2018-09-05', '2018-08-14', 1, 43.9000015, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', 'ORD-00454', NULL, '22.1249642,-100.9622', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 523.65);
INSERT INTO orders VALUES (10308, '2', 7, '2017-09-18', '2017-10-16', '2017-09-24', 3, 1.61000001, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', 'ORD-00455', NULL, '22.1249642,-100.9622', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 90.41);
INSERT INTO orders VALUES (10893, '39', 9, '2019-02-18', '2019-03-18', '2019-02-20', 2, 77.7799988, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00481', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5579.89);
INSERT INTO orders VALUES (10849, '39', 9, '2019-01-23', '2019-02-20', '2019-01-30', 2, 0.560000002, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00482', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1052.55);
INSERT INTO orders VALUES (10817, '39', 3, '2019-01-06', '2019-01-20', '2019-01-13', 2, 306.070007, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00483', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11796.32);
INSERT INTO orders VALUES (10799, '39', 9, '2018-12-26', '2019-02-06', '2019-01-05', 3, 30.7600002, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00484', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1615.46);
INSERT INTO orders VALUES (10718, '39', 1, '2018-10-27', '2018-11-24', '2018-10-29', 3, 170.880005, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00485', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3633.88);
INSERT INTO orders VALUES (10630, '39', 1, '2018-08-13', '2018-09-10', '2018-08-19', 2, 32.3499985, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00486', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 950.30);
INSERT INTO orders VALUES (10542, '39', 1, '2018-05-20', '2018-06-17', '2018-05-26', 3, 10.9499998, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00487', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 504.65);
INSERT INTO orders VALUES (10506, '39', 9, '2018-04-15', '2018-05-13', '2018-05-02', 2, 21.1900005, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00488', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 482.99);
INSERT INTO orders VALUES (10995, '58', 1, '2019-04-02', '2019-04-30', '2019-04-06', 3, 46, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00475', NULL, '25.7519027,-100.25829570000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1242.00);
INSERT INTO orders VALUES (10502, '58', 2, '2018-04-10', '2018-05-08', '2018-04-29', 1, 69.3199997, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00476', NULL, '25.7519027,-100.25829570000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 885.62);
INSERT INTO orders VALUES (10474, '58', 5, '2018-03-13', '2018-04-10', '2018-03-21', 2, 83.4899979, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00477', NULL, '25.7519027,-100.25829570000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1332.59);
INSERT INTO orders VALUES (10354, '58', 8, '2017-11-14', '2017-12-12', '2017-11-20', 3, 53.7999992, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00478', NULL, '25.7519027,-100.25829570000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 622.60);
INSERT INTO orders VALUES (10322, '58', 7, '2017-10-04', '2017-11-01', '2017-10-23', 3, 0.400000006, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00479', NULL, '25.7519027,-100.25829570000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 112.40);
INSERT INTO orders VALUES (11073, '58', 2, '2019-05-05', '2019-06-02', '2019-08-29', 2, 24.9500008, 'Pericles Comidas clásicas', 'Calle Dr. Jorge Cash 321', 'México D.F.', '', '05033', 'Mexico', 'ORD-00474', NULL, '25.7519027,-100.25829570000002', NULL, NULL, 2, '2019-08-29 06:39:28.716231', 'F', 'F', 1, NULL, 324.95);
INSERT INTO orders VALUES (10805, '77', 2, '2018-12-30', '2019-01-27', '2019-01-09', 3, 237.339996, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', 'ORD-00457', NULL, '38.9781887,-76.48653780000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3012.34);
INSERT INTO orders VALUES (10708, '77', 6, '2018-10-17', '2018-11-28', '2018-11-05', 2, 2.96000004, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', 'ORD-00458', NULL, '38.9781887,-76.48653780000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 183.36);
INSERT INTO orders VALUES (10310, '77', 8, '2017-09-20', '2017-10-18', '2017-09-27', 2, 17.5200005, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', 'ORD-00459', NULL, '38.9781887,-76.48653780000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 353.52);
INSERT INTO orders VALUES (10992, '77', 1, '2019-04-01', '2019-04-29', '2019-04-03', 3, 4.26999998, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', 'ORD-00456', NULL, '38.9781887,-76.48653780000001', NULL, NULL, 2, '2019-08-29 07:15:24.898166', 'F', 'F', 1, NULL, 73.87);
INSERT INTO orders VALUES (11093, '99', 9, '2019-08-21', '2019-09-11', '2019-08-21', 9, 0, 'Atlanta', '7971, Arakashan Rd', 'New Delhi', '', '110055', 'India', 'ORD-00847', NULL, '28.6461917,77.21406619999993', 2, '2019-08-21 06:21:28.605365', 2, '2019-08-27 11:23:21.600952', 'F', 'F', 6, NULL, 4898.00);
INSERT INTO orders VALUES (10521, '12', 8, '2018-04-29', '2018-05-27', '2018-05-02', 2, 17.2199993, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00778', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-08-27 11:33:39.371774', 'F', 'F', 1, NULL, 242.72);
INSERT INTO orders VALUES (11099, '99', 10, '2019-09-19', '2019-09-30', '2019-09-24', 9, 25, 'Atlanta', '7971, Arakashan Rd', 'New Delhi', '', '110055', 'India', 'ORD-00853', NULL, '28.6462203,77.21426250000002', 2, '2019-09-19 04:17:31.738566', NULL, NULL, 'F', 'F', 6, NULL, 3175);
INSERT INTO orders VALUES (10490, '35', 7, '2018-03-31', '2018-04-28', '2018-04-03', 2, 210.190002, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00090', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3373.39);
INSERT INTO orders VALUES (11049, '31', 3, '2019-04-24', '2019-05-22', '2019-05-04', 1, 8.34000015, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00741', NULL, '-11.43836,-61.44469099999998', NULL, NULL, 2, '2019-08-28 10:52:34.955061', 'F', 'F', 1, NULL, 349.94);
INSERT INTO orders VALUES (10940, '9', 8, '2019-03-11', '2019-04-08', '2019-03-23', 3, 19.7700005, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00537', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 379.77);
INSERT INTO orders VALUES (10963, '28', 9, '2019-03-19', '2019-04-16', '2019-03-26', 3, 2.70000005, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal', 'ORD-00528', NULL, '38.7555971,-9.095354050926176', NULL, NULL, 2, '2019-08-29 05:55:27.098907', 'F', 'F', 1, NULL, 70.55);
INSERT INTO orders VALUES (10801, '8', 4, '2018-12-29', '2019-01-26', '2018-12-31', 2, 97.0899963, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain', 'ORD-00526', NULL, '39.4566454,-0.37177220000000943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4132.39);
INSERT INTO orders VALUES (10326, '8', 4, '2017-10-10', '2017-11-07', '2017-10-14', 2, 77.9199982, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain', 'ORD-00527', NULL, '39.4566454,-0.37177220000000943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1059.92);
INSERT INTO orders VALUES (10664, '28', 1, '2018-09-10', '2018-10-08', '2018-09-19', 3, 1.26999998, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', NULL, '1675', 'Portugal', 'ORD-00529', NULL, '38.7555971,-9.095354050926176', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1516.57);
INSERT INTO orders VALUES (10486, '35', 1, '2018-03-26', '2018-04-23', '2018-04-02', 2, 30.5300007, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00092', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1302.53);
INSERT INTO orders VALUES (10476, '35', 8, '2018-03-17', '2018-04-14', '2018-03-24', 3, 4.40999985, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00093', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 186.76);
INSERT INTO orders VALUES (10395, '35', 6, '2017-12-26', '2018-01-23', '2018-01-03', 1, 184.410004, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00094', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2517.41);
INSERT INTO orders VALUES (10257, '35', 4, '2017-07-16', '2017-08-13', '2017-07-22', 3, 81.9100037, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00095', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1201.81);
INSERT INTO orders VALUES (10457, '39', 2, '2018-02-25', '2018-03-25', '2018-03-03', 1, 11.5699997, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00490', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1595.57);
INSERT INTO orders VALUES (11031, '71', 6, '2019-04-17', '2019-05-15', '2019-04-24', 2, 227.220001, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00495', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2620.72);
INSERT INTO orders VALUES (11030, '71', 7, '2019-04-17', '2019-05-15', '2019-04-27', 2, 830.75, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00496', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 17151.90);
INSERT INTO orders VALUES (11002, '71', 4, '2019-04-06', '2019-05-04', '2019-04-16', 1, 141.160004, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00497', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2042.86);
INSERT INTO orders VALUES (10725, '21', 4, '2018-10-31', '2018-11-28', '2018-11-05', 3, 10.8299999, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00578', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 298.63);
INSERT INTO orders VALUES (10650, '21', 5, '2018-08-29', '2018-09-26', '2018-09-03', 3, 176.809998, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00579', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1996.96);
INSERT INTO orders VALUES (11094, '100', 10, '2019-08-21', '2019-09-10', '2019-08-21', 8, 120, 'Radisson ', 'Cantonment Rd, Kaiserbagh Officer''s Colony', 'Lucknow', '', '226001', 'India', 'ORD-00848', NULL, '26.8456649,80.93534590000002', 2, '2019-08-21 06:26:57.91072', 2, '2019-08-27 11:25:37.393012', 'F', 'F', 6, NULL, 2795.15);
INSERT INTO orders VALUES (11072, '20', 4, '2019-05-05', '2019-06-02', '2019-08-27', 2, 258.640015, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00096', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-27 11:41:21.789088', 'F', 'F', 1, NULL, 5476.64);
INSERT INTO orders VALUES (10985, '37', 2, '2019-03-30', '2019-04-27', '2019-04-02', 1, 91.5100021, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00396', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2339.41);
INSERT INTO orders VALUES (10912, '37', 2, '2019-02-26', '2019-03-26', '2019-03-18', 2, 580.909973, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00397', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 8847.81);
INSERT INTO orders VALUES (10897, '37', 3, '2019-02-19', '2019-03-19', '2019-02-25', 2, 603.539978, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00398', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11438.78);
INSERT INTO orders VALUES (10736, '37', 9, '2018-11-11', '2018-12-09', '2018-11-21', 2, 44.0999985, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00399', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1041.10);
INSERT INTO orders VALUES (10701, '37', 6, '2018-10-13', '2018-10-27', '2018-10-15', 3, 220.309998, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00401', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3589.86);
INSERT INTO orders VALUES (10687, '37', 9, '2018-09-30', '2018-10-28', '2018-10-30', 2, 296.429993, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00402', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6497.83);
INSERT INTO orders VALUES (10661, '37', 7, '2018-09-09', '2018-10-07', '2018-09-15', 3, 17.5499992, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00403', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 720.40);
INSERT INTO orders VALUES (10646, '37', 9, '2018-08-27', '2018-10-08', '2018-09-03', 3, 142.330002, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00404', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2069.33);
INSERT INTO orders VALUES (10567, '37', 1, '2018-06-12', '2018-07-10', '2018-06-17', 1, 33.9700012, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00405', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3142.57);
INSERT INTO orders VALUES (10516, '37', 2, '2018-04-24', '2018-05-22', '2018-05-01', 3, 62.7799988, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00406', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2677.08);
INSERT INTO orders VALUES (10503, '37', 6, '2018-04-11', '2018-05-09', '2018-04-16', 2, 16.7399998, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00407', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2065.24);
INSERT INTO orders VALUES (10477, '60', 5, '2018-03-17', '2018-04-14', '2018-03-25', 2, 13.0200005, 'Princesa Isabel Vinhos', 'Estrada da saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', 'ORD-00567', NULL, '38.72634879999999,-9.140951500000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 684.52);
INSERT INTO orders VALUES (11100, '15', 1, '2019-10-05', '2019-10-29', '2019-10-05', 3, 10, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', 'ORD-00854', NULL, '-3.082163599999999,-60.013529199999994', 2, '2019-10-05 09:24:51.602566', NULL, NULL, 'F', 'F', 1, NULL, 3006);
INSERT INTO orders VALUES (10581, '21', 3, '2018-06-26', '2018-07-24', '2018-07-02', 1, 3.00999999, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00580', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 390.31);
INSERT INTO orders VALUES (10512, '21', 7, '2018-04-21', '2018-05-19', '2018-04-24', 2, 3.52999997, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00581', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 620.93);
INSERT INTO orders VALUES (10790, '31', 6, '2018-12-22', '2019-01-19', '2018-12-26', 1, 28.2299995, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00743', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 877.93);
INSERT INTO orders VALUES (10783, '34', 4, '2018-12-18', '2019-01-15', '2018-12-19', 2, 124.980003, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00021', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1567.48);
INSERT INTO orders VALUES (10770, '34', 8, '2018-12-09', '2019-01-06', '2018-12-17', 3, 5.32000017, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00022', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 320.07);
INSERT INTO orders VALUES (10932, '9', 8, '2019-03-06', '2019-04-03', '2019-03-24', 1, 134.639999, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00538', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2059.84);
INSERT INTO orders VALUES (10802, '73', 4, '2018-12-29', '2019-01-26', '2019-01-02', 2, 257.26001, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00572', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4180.01);
INSERT INTO orders VALUES (10669, '73', 2, '2018-09-15', '2018-10-13', '2018-09-22', 1, 24.3899994, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00573', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 594.39);
INSERT INTO orders VALUES (10642, '73', 7, '2018-08-22', '2018-09-19', '2018-09-05', 3, 41.8899994, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00574', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 911.49);
INSERT INTO orders VALUES (10556, '73', 2, '2018-06-03', '2018-07-15', '2018-06-13', 1, 9.80000019, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00575', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 845.00);
INSERT INTO orders VALUES (10417, '73', 4, '2018-01-16', '2018-02-13', '2018-01-28', 3, 70.2900009, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00576', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11352.99);
INSERT INTO orders VALUES (10341, '73', 7, '2017-10-29', '2017-11-26', '2017-11-05', 3, 26.7800007, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', NULL, '1734', 'Denmark', 'ORD-00577', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 438.63);
INSERT INTO orders VALUES (11074, '73', 7, '2019-05-06', '2019-06-03', '2019-08-28', 2, 18.4400005, 'Simons bistro', 'Vinbæltet 34', 'Kobenhavn', '', '1734', 'Denmark', 'ORD-00571', NULL, '55.69342837599086,12.48788890000003', NULL, NULL, 2, '2019-08-28 11:22:45.535983', 'F', 'F', 1, NULL, 262.69);
INSERT INTO orders VALUES (10876, '9', 7, '2019-02-09', '2019-03-09', '2019-02-12', 3, 60.4199982, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00539', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 977.42);
INSERT INTO orders VALUES (10871, '9', 9, '2019-02-05', '2019-03-05', '2019-02-10', 2, 112.269997, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00540', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2195.52);
INSERT INTO orders VALUES (10827, '9', 1, '2019-01-12', '2019-01-26', '2019-02-06', 2, 63.5400009, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00541', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 906.54);
INSERT INTO orders VALUES (10755, '9', 4, '2018-11-26', '2018-12-24', '2018-11-28', 2, 16.7099991, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00542', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2613.71);
INSERT INTO orders VALUES (10732, '9', 3, '2018-11-06', '2018-12-04', '2018-11-07', 1, 16.9699993, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00543', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 376.97);
INSERT INTO orders VALUES (10730, '9', 5, '2018-11-05', '2018-12-03', '2018-11-14', 1, 20.1200008, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00544', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 529.72);
INSERT INTO orders VALUES (10715, '9', 3, '2018-10-23', '2018-11-06', '2018-10-29', 1, 63.2000008, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00545', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1359.20);
INSERT INTO orders VALUES (10663, '9', 2, '2018-09-10', '2018-09-24', '2018-10-03', 2, 113.150002, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00546', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2145.00);
INSERT INTO orders VALUES (10525, '9', 1, '2018-05-02', '2018-05-30', '2018-05-23', 2, 11.0600004, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00547', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 856.96);
INSERT INTO orders VALUES (10690, '34', 1, '2018-10-02', '2018-10-30', '2018-10-03', 1, 15.8000002, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00023', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1165.30);
INSERT INTO orders VALUES (10645, '34', 4, '2018-08-26', '2018-09-23', '2018-09-02', 1, 12.4099998, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00024', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1547.41);
INSERT INTO orders VALUES (10541, '34', 2, '2018-05-19', '2018-06-16', '2018-05-29', 1, 68.6500015, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00025', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2231.05);
INSERT INTO orders VALUES (10250, '34', 4, '2017-07-08', '2017-08-05', '2017-07-12', 2, 65.8300018, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00027', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1878.53);
INSERT INTO orders VALUES (10253, '34', 3, '2017-07-10', '2017-07-24', '2017-07-16', 2, 58.1699982, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00026', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, 2, '2019-08-26 08:20:58.167188', 'F', 'F', 1, NULL, 1502.97);
INSERT INTO orders VALUES (11052, '34', 3, '2019-04-27', '2019-05-25', '2019-05-01', 1, 67.2600021, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00014', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, 2, '2019-08-28 10:56:51.957495', 'F', 'F', 1, NULL, 1731.86);
INSERT INTO orders VALUES (10851, '67', 5, '2019-01-26', '2019-02-23', '2019-02-02', 1, 160.550003, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00353', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2900.35);
INSERT INTO orders VALUES (10813, '67', 1, '2019-01-05', '2019-02-02', '2019-01-09', 1, 47.3800011, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00354', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 695.18);
INSERT INTO orders VALUES (10648, '67', 5, '2018-08-28', '2018-10-09', '2018-09-09', 2, 14.25, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00355', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 396.60);
INSERT INTO orders VALUES (10622, '67', 4, '2018-08-06', '2018-09-03', '2018-08-11', 3, 50.9700012, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00356', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 655.77);
INSERT INTO orders VALUES (10563, '67', 2, '2018-06-10', '2018-07-22', '2018-06-24', 2, 60.4300003, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00357', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1025.43);
INSERT INTO orders VALUES (10481, '67', 8, '2018-03-20', '2018-04-17', '2018-03-25', 2, 64.3300018, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00358', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1536.33);
INSERT INTO orders VALUES (10447, '67', 4, '2018-02-14', '2018-03-14', '2018-03-07', 2, 68.6600037, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00359', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 983.06);
INSERT INTO orders VALUES (10299, '67', 4, '2017-09-06', '2017-10-04', '2017-09-13', 2, 29.7600002, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00360', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 379.26);
INSERT INTO orders VALUES (10287, '67', 8, '2017-08-22', '2017-09-19', '2017-08-28', 3, 12.7600002, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', 'ORD-00361', NULL, '-22.9348968,-43.56284959999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 936.46);
INSERT INTO orders VALUES (10809, '88', 7, '2019-01-01', '2019-01-29', '2019-01-07', 1, 4.86999989, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00071', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 144.87);
INSERT INTO orders VALUES (10803, '88', 4, '2018-12-30', '2019-01-27', '2019-01-06', 1, 55.2299995, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00072', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1310.88);
INSERT INTO orders VALUES (10644, '88', 3, '2018-08-25', '2018-09-22', '2018-09-01', 2, 0.140000001, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00073', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1421.94);
INSERT INTO orders VALUES (10585, '88', 7, '2018-07-01', '2018-07-29', '2018-07-10', 1, 13.4099998, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00074', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 155.91);
INSERT INTO orders VALUES (10420, '88', 3, '2018-01-21', '2018-02-18', '2018-01-27', 1, 44.1199989, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00075', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1941.32);
INSERT INTO orders VALUES (10256, '88', 3, '2017-07-15', '2017-08-12', '2017-07-17', 2, 13.9700003, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00076', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 531.77);
INSERT INTO orders VALUES (10935, '88', 4, '2019-03-09', '2019-04-06', '2019-03-18', 3, 47.5900002, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00068', NULL, '-22.8203705,-43.1813396', NULL, NULL, 2, '2019-08-28 11:12:24.89962', 'F', 'F', 1, NULL, 747.09);
INSERT INTO orders VALUES (10429, '37', 3, '2018-01-29', '2018-03-12', '2018-02-07', 2, 56.6300011, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00408', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1804.88);
INSERT INTO orders VALUES (10380, '37', 8, '2017-12-12', '2018-01-09', '2018-01-16', 3, 35.0299988, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00409', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1454.53);
INSERT INTO orders VALUES (10373, '37', 4, '2017-12-05', '2018-01-02', '2017-12-11', 3, 124.120003, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00410', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1831.72);
INSERT INTO orders VALUES (10335, '37', 7, '2017-10-22', '2017-11-19', '2017-10-24', 2, 42.1100006, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00411', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2586.51);
INSERT INTO orders VALUES (10309, '37', 3, '2017-09-19', '2017-10-17', '2017-10-23', 1, 47.2999992, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00412', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1809.30);
INSERT INTO orders VALUES (10298, '37', 6, '2017-09-05', '2017-10-03', '2017-09-11', 2, 168.220001, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', NULL, 'Ireland', 'ORD-00413', NULL, '51.6940347,-9.725607800000034', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3294.72);
INSERT INTO orders VALUES (10468, '39', 3, '2018-03-07', '2018-04-04', '2018-03-12', 3, 44.1199989, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00489', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 761.72);
INSERT INTO orders VALUES (11028, '39', 2, '2019-04-16', '2019-05-14', '2019-04-22', 1, 29.5900002, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany', 'ORD-00480', NULL, '51.4299107,7.003655500000036', NULL, NULL, 2, '2019-08-29 06:16:29.770175', 'F', 'F', 1, NULL, 2189.59);
INSERT INTO orders VALUES (10456, '39', 8, '2018-02-25', '2018-04-08', '2018-02-28', 2, 8.11999989, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00491', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 663.82);
INSERT INTO orders VALUES (10325, '39', 1, '2017-10-09', '2017-10-23', '2017-10-14', 3, 64.8600006, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00492', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1561.86);
INSERT INTO orders VALUES (10323, '39', 4, '2017-10-07', '2017-11-04', '2017-10-14', 1, 4.88000011, 'Königlich Essen', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', 'ORD-00493', NULL, '51.4299107,7.003655500000036', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 169.28);
INSERT INTO orders VALUES (11101, '97', 5, '2019-10-05', '2019-10-15', '2019-10-10', 3, 10, 'FabHotel Sahar Garden Marol', 'metro stn, Marol Maroshi Rd', 'Mumbai', '', '400059', 'India', 'ORD-00855', NULL, '19.1090441,72.87868809999998', 2, '2019-10-05 16:36:50.655511', NULL, NULL, 'F', 'F', 6, NULL, 928);
INSERT INTO orders VALUES (10891, '44', 7, '2019-02-17', '2019-03-17', '2019-02-19', 2, 20.3700008, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00319', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 408.67);
INSERT INTO orders VALUES (10862, '44', 8, '2019-01-30', '2019-03-13', '2019-02-02', 2, 53.2299995, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00320', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 634.23);
INSERT INTO orders VALUES (11095, '98', 9, '2019-08-21', '2019-09-04', '2019-08-21', 10, 15, 'Amax Inn', '8145/6, Arakashan Road', 'New Delhi', '', '110055', 'India', 'ORD-00849', NULL, '28.646759,77.21322409999993', 2, '2019-08-21 10:10:48.943081', 2, '2019-08-27 11:24:48.63443', 'F', 'F', 6, NULL, 1629.00);
INSERT INTO orders VALUES (10979, '20', 8, '2019-03-26', '2019-04-23', '2019-03-31', 2, 353.070007, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00100', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:23:46.933486', 'F', 'F', 1, NULL, 5166.57);
INSERT INTO orders VALUES (10795, '20', 8, '2018-12-24', '2019-01-21', '2019-01-20', 2, 126.660004, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00104', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:21.603999', 'F', 'F', 1, NULL, 2625.66);
INSERT INTO orders VALUES (10854, '20', 3, '2019-01-27', '2019-02-24', '2019-02-05', 2, 100.220001, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00102', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:38.80377', 'F', 'F', 1, NULL, 3589.92);
INSERT INTO orders VALUES (10414, '21', 2, '2018-01-14', '2018-02-11', '2018-01-17', 3, 21.4799995, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00582', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 252.83);
INSERT INTO orders VALUES (10386, '21', 9, '2017-12-18', '2018-01-01', '2017-12-25', 3, 13.9899998, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00583', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 179.99);
INSERT INTO orders VALUES (10347, '21', 4, '2017-11-06', '2017-12-04', '2017-11-08', 3, 3.0999999, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00584', NULL, '-23.4811171,-46.68221360000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 930.80);
INSERT INTO orders VALUES (11053, '59', 2, '2019-04-27', '2019-05-25', '2019-04-29', 2, 53.0499992, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00599', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:37:07.019155', 'F', 'F', 1, NULL, 3711.40);
INSERT INTO orders VALUES (10829, '38', 9, '2019-01-13', '2019-02-10', '2019-01-23', 1, 154.720001, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00465', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1918.72);
INSERT INTO orders VALUES (10798, '38', 2, '2018-12-26', '2019-01-23', '2019-01-05', 1, 2.32999992, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00466', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 448.93);
INSERT INTO orders VALUES (10749, '38', 4, '2018-11-20', '2018-12-18', '2018-12-19', 2, 61.5299988, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00467', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1141.53);
INSERT INTO orders VALUES (10674, '38', 4, '2018-09-18', '2018-10-16', '2018-09-30', 2, 0.899999976, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00468', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 45.90);
INSERT INTO orders VALUES (10621, '38', 4, '2018-08-05', '2018-09-02', '2018-08-11', 2, 23.7299995, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00469', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 782.23);
INSERT INTO orders VALUES (10473, '38', 1, '2018-03-13', '2018-03-27', '2018-03-21', 3, 16.3700008, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00470', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 246.77);
INSERT INTO orders VALUES (10321, '38', 3, '2017-10-03', '2017-10-31', '2017-10-11', 2, 3.43000007, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00471', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 147.43);
INSERT INTO orders VALUES (10318, '38', 8, '2017-10-01', '2017-10-29', '2017-10-04', 2, 4.73000002, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00472', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 245.13);
INSERT INTO orders VALUES (10804, '72', 6, '2018-12-30', '2019-01-27', '2019-01-07', 2, 27.3299999, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00623', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2317.58);
INSERT INTO orders VALUES (11096, '98', 10, '2019-08-23', '2019-09-24', '2019-08-22', 8, 10, 'Amax Inn', '8145/6, Arakashan Road', 'New Delhi', '', '110055', 'India', 'ORD-00850', NULL, '28.646759,77.21322409999993', 2, '2019-08-23 11:05:43.500131', 2, '2019-10-06 04:35:40.307298', 'F', 'F', 6, NULL, 3612);
INSERT INTO orders VALUES (10379, '61', 2, '2017-12-11', '2018-01-08', '2017-12-13', 1, 45.0299988, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00141', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1003.93);
INSERT INTO orders VALUES (10291, '61', 6, '2017-08-27', '2017-09-24', '2017-09-04', 2, 6.4000001, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00142', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 558.90);
INSERT INTO orders VALUES (10261, '61', 4, '2017-07-19', '2017-08-16', '2017-07-30', 2, 3.04999995, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00143', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 451.05);
INSERT INTO orders VALUES (10914, '62', 6, '2019-02-27', '2019-03-27', '2019-03-02', 1, 21.1900005, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00670', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 558.69);
INSERT INTO orders VALUES (10923, '41', 7, '2019-03-03', '2019-04-14', '2019-03-13', 3, 68.2600021, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00586', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1003.66);
INSERT INTO orders VALUES (11016, '4', 9, '2019-04-10', '2019-05-08', '2019-04-13', 2, 33.7999992, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00609', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 525.30);
INSERT INTO orders VALUES (10953, '4', 9, '2019-03-16', '2019-03-30', '2019-03-25', 2, 23.7199993, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00610', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4698.62);
INSERT INTO orders VALUES (10920, '4', 4, '2019-03-03', '2019-03-31', '2019-03-09', 2, 29.6100006, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00611', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 419.61);
INSERT INTO orders VALUES (10864, '4', 4, '2019-02-02', '2019-03-02', '2019-02-09', 2, 3.03999996, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00612', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 285.04);
INSERT INTO orders VALUES (11047, '19', 7, '2019-04-24', '2019-05-22', '2019-05-01', 3, 46.6199989, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00638', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1136.62);
INSERT INTO orders VALUES (11036, '17', 8, '2019-04-20', '2019-05-18', '2019-04-22', 3, 149.470001, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', 'ORD-00632', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1841.47);
INSERT INTO orders VALUES (10825, '17', 1, '2019-01-09', '2019-02-06', '2019-01-14', 1, 79.25, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', 'ORD-00633', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1110.01);
INSERT INTO orders VALUES (10797, '17', 7, '2018-12-25', '2019-01-22', '2019-01-05', 2, 33.3499985, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', 'ORD-00634', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 453.35);
INSERT INTO orders VALUES (10391, '17', 3, '2017-12-23', '2018-01-20', '2017-12-31', 3, 5.44999981, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', 'ORD-00635', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 91.85);
INSERT INTO orders VALUES (10363, '17', 4, '2017-11-26', '2017-12-24', '2017-12-04', 3, 30.5400009, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', 'ORD-00636', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 477.74);
INSERT INTO orders VALUES (11067, '17', 1, '2019-05-04', '2019-05-18', '2019-05-06', 2, 7.98000002, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', '', '52066', 'Germany', 'ORD-00631', NULL, '48.008299722437506,9.491831384655825', NULL, NULL, 2, '2019-08-29 05:46:25.542768', 'F', 'F', 1, NULL, 94.83);
INSERT INTO orders VALUES (11024, '19', 4, '2019-04-15', '2019-05-13', '2019-04-20', 1, 74.3600006, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00639', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2041.17);
INSERT INTO orders VALUES (10987, '19', 8, '2019-03-31', '2019-04-28', '2019-04-06', 1, 185.479996, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00640', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2957.48);
INSERT INTO orders VALUES (10726, '19', 4, '2018-11-03', '2018-11-17', '2018-12-05', 1, 16.5599995, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00641', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 671.56);
INSERT INTO orders VALUES (11056, '19', 8, '2019-04-28', '2019-05-12', '2019-05-01', 2, 278.959991, 'Eastern Connection', '35 King George', 'London', '', 'WX3 6FW', 'UK', 'ORD-00637', NULL, '52.1333598,-2.433273500000041', NULL, NULL, 2, '2019-08-29 05:47:52.17889', 'F', 'F', 1, NULL, 4018.96);
INSERT INTO orders VALUES (10532, '19', 7, '2018-05-09', '2018-06-06', '2018-05-12', 3, 74.4599991, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00642', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 870.81);
INSERT INTO orders VALUES (10844, '59', 8, '2019-01-21', '2019-02-18', '2019-01-26', 2, 25.2199993, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00600', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:52.681619', 'F', 'F', 1, NULL, 760.22);
INSERT INTO orders VALUES (10780, '46', 2, '2018-12-16', '2018-12-30', '2018-12-25', 1, 42.1300011, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00342', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 762.13);
INSERT INTO orders VALUES (10887, '29', 8, '2019-02-13', '2019-03-13', '2019-02-16', 3, 1.25, 'Galería del gastronómo', 'Rambla de Cataluña, 23', 'Barcelona', NULL, '8022', 'Spain', 'ORD-00653', NULL, '38.4034665,-0.536018399999989', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 71.25);
INSERT INTO orders VALUES (10568, '29', 3, '2018-06-13', '2018-07-11', '2018-07-09', 3, 6.53999996, 'Galería del gastronómo', 'Rambla de Cataluña, 23', 'Barcelona', NULL, '8022', 'Spain', 'ORD-00654', NULL, '38.4034665,-0.536018399999989', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 161.54);
INSERT INTO orders VALUES (10426, '29', 4, '2018-01-27', '2018-02-24', '2018-02-06', 1, 18.6900005, 'Galería del gastronómo', 'Rambla de Cataluña, 23', 'Barcelona', NULL, '8022', 'Spain', 'ORD-00655', NULL, '38.4034665,-0.536018399999989', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 356.89);
INSERT INTO orders VALUES (10366, '29', 8, '2017-11-28', '2018-01-09', '2017-12-30', 2, 10.1400003, 'Galería del gastronómo', 'Rambla de Cataluña, 23', 'Barcelona', NULL, '8022', 'Spain', 'ORD-00656', NULL, '38.4034665,-0.536018399999989', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 146.14);
INSERT INTO orders VALUES (10928, '29', 1, '2019-03-05', '2019-04-02', '2019-03-18', 1, 1.36000001, 'Galería del gastronómo', 'Rambla de Cataluña, 23', 'Barcelona', '', '8022', 'Spain', 'ORD-00652', NULL, '38.4034665,-0.536018399999989', NULL, NULL, 2, '2019-08-29 05:56:55.504903', 'F', 'F', 1, NULL, 138.86);
INSERT INTO orders VALUES (10660, '36', 8, '2018-09-08', '2018-10-06', '2018-10-15', 1, 111.290001, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', 'ORD-00688', NULL, '42.2860502,-71.23570389999998', NULL, NULL, 2, '2019-08-29 06:11:36.529815', 'F', 'F', 1, NULL, 1812.29);
INSERT INTO orders VALUES (10315, '38', 4, '2017-09-26', '2017-10-24', '2017-10-03', 2, 41.7599983, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00473', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 558.56);
INSERT INTO orders VALUES (10933, '38', 6, '2019-03-06', '2019-04-03', '2019-03-16', 3, 54.1500015, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', 'ORD-00464', NULL, '51.38220689999999,-0.09819560000005367', NULL, NULL, 2, '2019-08-29 06:15:24.909137', 'F', 'F', 1, NULL, 974.75);
INSERT INTO orders VALUES (10543, '46', 8, '2018-05-21', '2018-06-18', '2018-05-23', 2, 48.1699982, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00343', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1817.87);
INSERT INTO orders VALUES (10499, '46', 4, '2018-04-08', '2018-05-06', '2018-04-16', 2, 102.019997, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00344', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1514.02);
INSERT INTO orders VALUES (10461, '46', 1, '2018-02-28', '2018-03-28', '2018-03-05', 3, 148.610001, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00345', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2199.46);
INSERT INTO orders VALUES (10961, '62', 8, '2019-03-19', '2019-04-16', '2019-03-30', 1, 104.470001, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00669', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1226.42);
INSERT INTO orders VALUES (10946, '83', 1, '2019-03-12', '2019-04-09', '2019-03-19', 2, 27.2000008, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00658', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1434.70);
INSERT INTO orders VALUES (10921, '83', 1, '2019-03-03', '2019-04-14', '2019-03-09', 1, 176.479996, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00659', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2112.48);
INSERT INTO orders VALUES (10769, '83', 3, '2018-12-08', '2019-01-05', '2018-12-12', 1, 65.0599976, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00660', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1768.96);
INSERT INTO orders VALUES (10744, '83', 6, '2018-11-17', '2018-12-15', '2018-11-24', 1, 69.1900024, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00661', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 988.99);
INSERT INTO orders VALUES (10688, '83', 4, '2018-10-01', '2018-10-15', '2018-10-07', 2, 299.089996, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00662', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3788.89);
INSERT INTO orders VALUES (10602, '83', 8, '2018-07-17', '2018-08-14', '2018-07-22', 2, 2.92000008, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00663', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 67.67);
INSERT INTO orders VALUES (10591, '83', 1, '2018-07-07', '2018-07-21', '2018-07-16', 1, 55.9199982, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00664', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 868.42);
INSERT INTO orders VALUES (10465, '83', 1, '2018-03-05', '2018-04-02', '2018-03-14', 3, 145.039993, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00665', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2863.84);
INSERT INTO orders VALUES (10399, '83', 8, '2017-12-31', '2018-01-14', '2018-01-08', 3, 27.3600006, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00666', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1792.96);
INSERT INTO orders VALUES (10367, '83', 7, '2017-11-28', '2017-12-26', '2017-12-02', 3, 13.5500002, 'Vaffeljernet', 'Smagsloget 45', 'Århus', NULL, '8200', 'Denmark', 'ORD-00667', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 847.75);
INSERT INTO orders VALUES (10994, '83', 2, '2019-04-02', '2019-04-16', '2019-04-09', 3, 65.5299988, 'Vaffeljernet', 'Smagsloget 45', 'Århus', '', '8200', 'Denmark', 'ORD-00657', NULL, '56.162909129138015,10.20360449933628', NULL, NULL, 2, '2019-08-28 11:24:51.887499', 'F', 'F', 1, NULL, 1055.48);
INSERT INTO orders VALUES (10856, '3', 3, '2019-01-28', '2019-02-25', '2019-02-10', 2, 58.4300003, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00645', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 718.43);
INSERT INTO orders VALUES (10682, '3', 3, '2018-09-25', '2018-10-23', '2018-10-01', 2, 36.1300011, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00646', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 411.63);
INSERT INTO orders VALUES (10677, '3', 1, '2018-09-22', '2018-10-20', '2018-09-26', 3, 4.03000021, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00647', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 960.63);
INSERT INTO orders VALUES (10573, '3', 7, '2018-06-19', '2018-07-17', '2018-06-20', 3, 84.8399963, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00648', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2166.84);
INSERT INTO orders VALUES (10535, '3', 4, '2018-05-13', '2018-06-10', '2018-05-21', 1, 15.6400003, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00649', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2171.74);
INSERT INTO orders VALUES (10507, '3', 7, '2018-04-15', '2018-05-13', '2018-04-22', 1, 47.4500008, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00650', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 928.40);
INSERT INTO orders VALUES (10365, '3', 3, '2017-11-27', '2017-12-25', '2017-12-02', 2, 22, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', NULL, '05023', 'Mexico', 'ORD-00651', NULL, '20.6774226,-103.28022240000001', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 425.20);
INSERT INTO orders VALUES (10400, '19', 1, '2018-01-01', '2018-01-29', '2018-01-16', 3, 83.9300003, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00643', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3146.93);
INSERT INTO orders VALUES (10364, '19', 1, '2017-11-26', '2018-01-07', '2017-12-04', 1, 71.9700012, 'Eastern Connection', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', 'ORD-00644', NULL, '52.1333598,-2.433273500000041', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1021.97);
INSERT INTO orders VALUES (11098, '3', 1, '2019-08-28', '2019-09-30', '2019-08-28', 1, 10, 'Antonio Moreno Taquería', 'Mataderos  2312', 'México D.F.', '', '05023', 'Mexico', 'ORD-00852', NULL, '20.6774226,-103.28022240000001', 2, '2019-08-28 06:03:00.916423', 2, '2019-09-06 04:28:30.118452', 'F', 'F', 1, NULL, 310);
INSERT INTO orders VALUES (10968, '20', 1, '2019-03-23', '2019-04-20', '2019-04-01', 3, 74.5999985, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00101', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:43.965129', 'F', 'F', 1, NULL, 1482.60);
INSERT INTO orders VALUES (10990, '20', 2, '2019-04-01', '2019-05-13', '2019-04-07', 3, 117.610001, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00099', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:48.375918', 'F', 'F', 1, NULL, 5048.16);
INSERT INTO orders VALUES (11008, '20', 7, '2019-04-08', '2019-05-06', '2019-08-28', 3, 79.4599991, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00098', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:53.267368', 'F', 'F', 1, NULL, 4982.86);
INSERT INTO orders VALUES (10258, '20', 1, '2017-07-17', '2017-08-14', '2017-07-23', 1, 140.509995, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00123', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:28:47.801201', 'F', 'F', 1, NULL, 2158.51);
INSERT INTO orders VALUES (10836, '20', 7, '2019-01-16', '2019-02-13', '2019-01-21', 1, 411.880005, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00103', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:28:58.082904', 'F', 'F', 1, NULL, 5117.38);
INSERT INTO orders VALUES (10776, '20', 1, '2018-12-15', '2019-01-12', '2018-12-18', 3, 351.529999, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00105', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:06.48725', 'F', 'F', 1, NULL, 7335.83);
INSERT INTO orders VALUES (10514, '20', 3, '2018-04-22', '2018-05-20', '2018-05-16', 2, 789.950012, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00114', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:19.997213', 'F', 'F', 1, NULL, 9413.40);
INSERT INTO orders VALUES (10571, '20', 8, '2018-06-17', '2018-07-29', '2018-07-04', 3, 26.0599995, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00113', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:25.017072', 'F', 'F', 1, NULL, 673.51);
INSERT INTO orders VALUES (10595, '20', 2, '2018-07-10', '2018-08-07', '2018-07-14', 1, 96.7799988, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00112', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:30.002937', 'F', 'F', 1, NULL, 6396.03);
INSERT INTO orders VALUES (10633, '20', 7, '2018-08-15', '2018-09-12', '2018-08-18', 3, 477.899994, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00111', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:34.704256', 'F', 'F', 1, NULL, 6960.35);
INSERT INTO orders VALUES (10667, '20', 7, '2018-09-12', '2018-10-10', '2018-09-19', 1, 78.0899963, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00110', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:39.043122', 'F', 'F', 1, NULL, 1998.69);
INSERT INTO orders VALUES (10698, '20', 4, '2018-10-09', '2018-11-06', '2018-10-17', 1, 272.470001, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00109', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:42.564918', 'F', 'F', 1, NULL, 3873.00);
INSERT INTO orders VALUES (10764, '20', 6, '2018-12-03', '2018-12-31', '2018-12-08', 3, 145.449997, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00108', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:46.61755', 'F', 'F', 1, NULL, 2685.25);
INSERT INTO orders VALUES (10382, '20', 4, '2017-12-13', '2018-01-10', '2017-12-16', 1, 94.7699966, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00119', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:50.952179', 'F', 'F', 1, NULL, 2994.77);
INSERT INTO orders VALUES (10390, '20', 6, '2017-12-23', '2018-01-20', '2017-12-26', 1, 126.379997, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00118', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:54.687489', 'F', 'F', 1, NULL, 2401.28);
INSERT INTO orders VALUES (10402, '20', 8, '2018-01-02', '2018-02-13', '2018-01-10', 2, 67.8799973, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00117', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:58.5727', 'F', 'F', 1, NULL, 2781.38);
INSERT INTO orders VALUES (10403, '20', 4, '2018-01-03', '2018-01-31', '2018-01-09', 3, 73.7900009, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00116', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:02.340283', 'F', 'F', 1, NULL, 1079.39);
INSERT INTO orders VALUES (10430, '20', 4, '2018-01-30', '2018-02-13', '2018-02-03', 1, 458.779999, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00115', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:05.933158', 'F', 'F', 1, NULL, 6254.38);
INSERT INTO orders VALUES (10771, '20', 9, '2018-12-10', '2019-01-07', '2019-01-02', 2, 11.1899996, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00107', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:09.271323', 'F', 'F', 1, NULL, 355.19);
INSERT INTO orders VALUES (10263, '20', 9, '2017-07-23', '2017-08-20', '2017-07-31', 3, 146.059998, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00122', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:14.630269', 'F', 'F', 1, NULL, 2610.11);
INSERT INTO orders VALUES (10351, '20', 1, '2017-11-11', '2017-12-09', '2017-11-20', 1, 162.330002, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00121', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:18.324222', 'F', 'F', 1, NULL, 5839.78);
INSERT INTO orders VALUES (10368, '20', 2, '2017-11-29', '2017-12-27', '2017-12-02', 2, 101.949997, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00120', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:21.826992', 'F', 'F', 1, NULL, 1935.85);
INSERT INTO orders VALUES (10773, '20', 1, '2018-12-11', '2019-01-08', '2018-12-16', 3, 96.4300003, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00106', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:30:25.144815', 'F', 'F', 1, NULL, 2312.28);
INSERT INTO orders VALUES (10353, '59', 7, '2017-11-13', '2017-12-11', '2017-11-25', 3, 360.630005, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00608', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:19.142838', 'F', 'F', 1, NULL, 11101.83);
INSERT INTO orders VALUES (10489, '59', 6, '2018-03-28', '2018-04-25', '2018-04-09', 2, 5.28999996, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00605', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:26.638731', 'F', 'F', 1, NULL, 507.24);
INSERT INTO orders VALUES (10530, '59', 3, '2018-05-08', '2018-06-05', '2018-05-12', 2, 339.220001, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00604', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:32.027363', 'F', 'F', 1, NULL, 4519.22);
INSERT INTO orders VALUES (10597, '59', 7, '2018-07-11', '2018-08-08', '2018-07-18', 3, 35.1199989, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00603', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:38.992488', 'F', 'F', 1, NULL, 834.82);
INSERT INTO orders VALUES (10686, '59', 2, '2018-09-30', '2018-10-28', '2018-10-08', 1, 96.5, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00602', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:43.36436', 'F', 'F', 1, NULL, 1734.75);
INSERT INTO orders VALUES (10747, '59', 6, '2018-11-19', '2018-12-17', '2018-11-26', 1, 117.330002, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00601', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:47.69697', 'F', 'F', 1, NULL, 2030.18);
INSERT INTO orders VALUES (10392, '59', 2, '2017-12-24', '2018-01-21', '2018-01-01', 3, 122.459999, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00607', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:40:58.917094', 'F', 'F', 1, NULL, 1562.46);
INSERT INTO orders VALUES (10427, '59', 4, '2018-01-27', '2018-02-24', '2018-03-03', 2, 31.2900009, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', 'ORD-00606', NULL, '47.798376,13.067522999999937', NULL, NULL, 2, '2019-08-28 04:41:02.523954', 'F', 'F', 1, NULL, 682.29);
INSERT INTO orders VALUES (11006, '32', 3, '2019-04-07', '2019-05-05', '2019-04-15', 2, 25.1900005, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00781', NULL, '45.1463552,-87.61650960000003', NULL, NULL, 2, '2019-08-19 10:12:35.579597', 'F', 'F', 1, NULL, 435.52);
INSERT INTO orders VALUES (11086, '93', 10, '2019-08-19', '2019-08-19', '2019-08-19', 9, 11, 'Sree Mahalakshmi Food Industries', '18/1348, Palluruthy', 'Kochi', '', ' 682006', 'India', 'ORD-00839', NULL, '10.0458956,76.3135595', 2, '2019-08-19 05:39:28.41565', 2, '2019-08-27 11:20:26.933186', 'F', 'F', 6, NULL, 511.00);
INSERT INTO orders VALUES (11087, '94', 9, '2019-08-19', '2019-09-01', '2019-08-19', 10, 12, 'Camilo Mendid Mellow ', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', '', '682306', 'India', 'ORD-00840', NULL, '9.986262899999998,76.32980889999999', 2, '2019-08-19 10:57:38.143033', 2, '2019-08-27 11:20:35.522237', 'F', 'F', 6, NULL, 822.00);
INSERT INTO orders VALUES (11083, '92', 3, '2019-08-16', '2019-08-27', '2019-08-10', 3, 85, 'Kalyan', 'Chembukavu', 'Thrissur', ',', '123485', 'India', 'ORD-00836', NULL, '10.5281615,76.21781910000004', 2, '2019-08-16 11:03:31.118949', 2, '2019-08-27 11:26:10.918728', 'F', 'F', 6, NULL, 3896.50);
INSERT INTO orders VALUES (10772, '44', 3, '2018-12-10', '2019-01-07', '2018-12-19', 2, 91.2799988, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00321', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3694.50);
INSERT INTO orders VALUES (10593, '44', 7, '2018-07-09', '2018-08-06', '2018-08-13', 2, 174.199997, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00322', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2666.60);
INSERT INTO orders VALUES (10592, '44', 3, '2018-07-08', '2018-08-05', '2018-07-16', 1, 32.0999985, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00323', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 575.65);
INSERT INTO orders VALUES (10557, '44', 9, '2018-06-03', '2018-06-17', '2018-06-06', 2, 96.7200012, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00324', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1249.22);
INSERT INTO orders VALUES (10536, '44', 3, '2018-05-14', '2018-06-11', '2018-06-06', 2, 58.8800011, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00325', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2143.38);
INSERT INTO orders VALUES (10534, '44', 8, '2018-05-12', '2018-06-09', '2018-05-14', 2, 27.9400005, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00326', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 544.94);
INSERT INTO orders VALUES (10522, '44', 4, '2018-04-30', '2018-05-28', '2018-05-06', 1, 45.3300018, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00327', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2702.53);
INSERT INTO orders VALUES (10497, '44', 7, '2018-04-04', '2018-05-02', '2018-04-07', 1, 36.2099991, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00328', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1416.81);
INSERT INTO orders VALUES (10343, '44', 4, '2017-10-31', '2017-11-28', '2017-11-06', 1, 110.370003, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00329', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1696.32);
INSERT INTO orders VALUES (10284, '44', 4, '2017-08-19', '2017-09-16', '2017-08-27', 1, 76.5599976, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00330', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1527.81);
INSERT INTO orders VALUES (10279, '44', 8, '2017-08-13', '2017-09-10', '2017-08-16', 2, 25.8299999, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', NULL, '60528', 'Germany', 'ORD-00331', NULL, '50.7906696,12.88982999999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 493.58);
INSERT INTO orders VALUES (11070, '44', 2, '2019-05-05', '2019-06-02', '2019-08-29', 1, 136, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany', 'ORD-00317', NULL, '50.7906696,12.88982999999996', NULL, NULL, 2, '2019-08-29 06:19:54.341261', 'F', 'F', 1, NULL, 2009.05);
INSERT INTO orders VALUES (10608, '79', 4, '2018-07-23', '2018-08-20', '2018-08-01', 2, 27.7900009, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', 'ORD-00009', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1091.79);
INSERT INTO orders VALUES (11075, '68', 8, '2019-05-06', '2019-06-03', '2019-08-29', 2, 6.19000006, 'Richter Supermarkt', 'Starenweg 5', 'Genève', '', '1204', 'Switzerland', 'ORD-00058', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, 2, '2019-08-29 06:55:49.921738', 'F', 'F', 1, NULL, 591.74);
INSERT INTO orders VALUES (10548, '79', 3, '2018-05-26', '2018-06-23', '2018-06-02', 2, 1.42999995, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', 'ORD-00010', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 276.28);
INSERT INTO orders VALUES (10446, '79', 6, '2018-02-14', '2018-03-14', '2018-02-19', 1, 14.6800003, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', 'ORD-00011', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 287.88);
INSERT INTO orders VALUES (10438, '79', 3, '2018-02-06', '2018-03-06', '2018-02-14', 2, 8.23999977, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', 'ORD-00012', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 575.14);
INSERT INTO orders VALUES (10850, '84', 1, '2019-01-23', '2019-03-06', '2019-01-30', 1, 49.1899986, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France', 'ORD-00028', NULL, '48.7511935,2.4544373999999607', NULL, NULL, 2, '2019-08-29 07:21:56.115537', 'F', 'F', 1, NULL, 788.74);
INSERT INTO orders VALUES (10843, '84', 4, '2019-01-21', '2019-02-18', '2019-01-26', 2, 9.26000023, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00029', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 221.01);
INSERT INTO orders VALUES (10442, '20', 3, '2018-02-11', '2018-03-11', '2018-02-18', 2, 47.9399986, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00001', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:29:14.467374', 'F', 'F', 1, NULL, 1839.94);
INSERT INTO orders VALUES (10895, '20', 3, '2019-02-18', '2019-03-18', '2019-02-23', 1, 162.75, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00002', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:32.384392', 'F', 'F', 1, NULL, 6542.15);
INSERT INTO orders VALUES (10814, '84', 3, '2019-01-05', '2019-02-02', '2019-01-14', 3, 130.940002, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00030', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2200.49);
INSERT INTO orders VALUES (10806, '84', 3, '2018-12-31', '2019-01-28', '2019-01-05', 2, 22.1100006, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', NULL, '69004', 'France', 'ORD-00031', NULL, '48.7511935,2.4544373999999607', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 593.71);
INSERT INTO orders VALUES (11038, '76', 1, '2019-04-21', '2019-05-19', '2019-04-30', 2, 29.5900002, 'Suprêmes délices', 'Boulevard Tirou, 255', 'Charleroi', NULL, 'B-6000', 'Belgium', 'ORD-00038', NULL, '50.413072663069315,4.446182932540864', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 780.39);
INSERT INTO orders VALUES (11022, '34', 9, '2019-04-14', '2019-05-12', '2019-05-04', 2, 6.26999998, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00015', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1408.27);
INSERT INTO orders VALUES (10981, '34', 1, '2019-03-27', '2019-04-24', '2019-04-02', 2, 193.369995, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00016', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 16003.37);
INSERT INTO orders VALUES (10925, '34', 3, '2019-03-04', '2019-04-01', '2019-03-13', 1, 2.26999998, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00017', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 560.97);
INSERT INTO orders VALUES (10922, '34', 5, '2019-03-03', '2019-03-31', '2019-03-05', 3, 62.7400017, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00018', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 805.24);
INSERT INTO orders VALUES (10903, '34', 3, '2019-02-24', '2019-03-24', '2019-03-04', 3, 36.7099991, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00019', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 968.76);
INSERT INTO orders VALUES (10886, '34', 1, '2019-02-13', '2019-03-13', '2019-03-02', 1, 4.98999977, 'Hanari Carnes', 'Rua do Paço, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', 'ORD-00020', NULL, '-22.909811263556207,-43.209625846032736', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3132.49);
INSERT INTO orders VALUES (11029, '14', 4, '2019-04-16', '2019-05-14', '2019-04-27', 1, 47.8400002, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00051', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1334.64);
INSERT INTO orders VALUES (10370, '14', 6, '2017-12-03', '2017-12-31', '2017-12-27', 2, 1.16999996, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00056', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1174.87);
INSERT INTO orders VALUES (10254, '14', 5, '2017-07-11', '2017-08-08', '2017-07-23', 2, 22.9799995, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00057', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 647.88);
INSERT INTO orders VALUES (11041, '14', 3, '2019-04-22', '2019-05-20', '2019-04-28', 2, 48.2200012, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland', 'ORD-00050', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, 2, '2019-08-29 05:37:16.083516', 'F', 'F', 1, NULL, 1935.02);
INSERT INTO orders VALUES (10653, '25', 1, '2018-09-02', '2018-09-30', '2018-09-19', 1, 93.25, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00091', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1296.55);
INSERT INTO orders VALUES (10381, '46', 3, '2017-12-12', '2018-01-09', '2017-12-13', 3, 7.98999977, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00346', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 119.99);
INSERT INTO orders VALUES (11055, '35', 7, '2019-04-28', '2019-05-26', '2019-05-05', 2, 120.919998, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00077', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, 2, '2019-08-29 06:10:23.032288', 'F', 'F', 1, NULL, 1848.42);
INSERT INTO orders VALUES (10976, '35', 1, '2019-03-25', '2019-05-06', '2019-04-03', 1, 37.9700012, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00078', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 949.97);
INSERT INTO orders VALUES (10960, '35', 3, '2019-03-19', '2019-04-02', '2019-04-08', 1, 2.07999992, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00079', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 278.43);
INSERT INTO orders VALUES (10957, '35', 8, '2019-03-18', '2019-04-15', '2019-03-27', 3, 105.360001, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Cristóbal', 'Táchira', '5022', 'Venezuela', 'ORD-00080', NULL, '10.015427376263789,-64.73996012883606', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1868.06);
INSERT INTO orders VALUES (10357, '46', 1, '2017-11-19', '2017-12-17', '2017-12-02', 3, 34.8800011, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00347', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1394.48);
INSERT INTO orders VALUES (11017, '20', 9, '2019-04-13', '2019-05-11', '2019-04-20', 2, 754.26001, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', 'ORD-00097', NULL, '47.07353089999999,15.423941199999945', NULL, NULL, 2, '2019-08-28 04:25:58.2129', 'F', 'F', 1, NULL, 7504.26);
INSERT INTO orders VALUES (10330, '46', 3, '2017-10-16', '2017-11-13', '2017-10-28', 1, 12.75, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00348', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1952.45);
INSERT INTO orders VALUES (10296, '46', 6, '2017-09-03', '2017-10-01', '2017-09-11', 1, 0.119999997, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00349', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1050.72);
INSERT INTO orders VALUES (10283, '46', 3, '2017-08-16', '2017-09-13', '2017-08-23', 3, 84.8099976, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00350', NULL, '10.091195,-69.31222109999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1499.61);
INSERT INTO orders VALUES (11071, '46', 1, '2019-05-05', '2019-06-02', '2019-08-29', 1, 0.930000007, 'LILA-Supermercado', 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', 'ORD-00337', NULL, '10.091195,-69.31222109999999', NULL, NULL, 2, '2019-08-29 06:22:52.921319', 'F', 'F', 1, NULL, 510.83);
INSERT INTO orders VALUES (10905, '88', 9, '2019-02-24', '2019-03-24', '2019-03-06', 2, 13.7200003, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00069', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 373.67);
INSERT INTO orders VALUES (10900, '88', 1, '2019-02-20', '2019-03-20', '2019-03-04', 2, 1.65999997, 'Wellington Importadora', 'Rua do Mercado, 12', 'Resende', 'SP', '08737-363', 'Brazil', 'ORD-00070', NULL, '-22.8203705,-43.1813396', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 46.41);
INSERT INTO orders VALUES (11000, '65', 2, '2019-04-06', '2019-05-04', '2019-04-14', 3, 55.1199989, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00145', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1129.62);
INSERT INTO orders VALUES (10988, '65', 3, '2019-03-31', '2019-04-28', '2019-04-10', 2, 61.1399994, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00146', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3833.04);
INSERT INTO orders VALUES (10889, '65', 9, '2019-02-16', '2019-03-16', '2019-02-23', 3, 280.609985, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00147', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11660.61);
INSERT INTO orders VALUES (10852, '65', 8, '2019-01-26', '2019-02-09', '2019-01-30', 1, 174.050003, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00148', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3158.05);
INSERT INTO orders VALUES (10820, '65', 3, '2019-01-07', '2019-02-04', '2019-01-13', 2, 37.5200005, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00149', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1177.52);
INSERT INTO orders VALUES (10761, '65', 5, '2018-12-02', '2018-12-30', '2018-12-08', 2, 18.6599998, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00150', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 647.91);
INSERT INTO orders VALUES (10598, '65', 1, '2018-07-14', '2018-08-11', '2018-07-18', 3, 44.4199982, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00151', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2432.92);
INSERT INTO orders VALUES (10569, '65', 5, '2018-06-16', '2018-07-14', '2018-07-11', 1, 58.9799995, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00152', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1036.28);
INSERT INTO orders VALUES (10758, '68', 3, '2018-11-28', '2018-12-26', '2018-12-04', 3, 138.169998, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00062', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1782.77);
INSERT INTO orders VALUES (10751, '68', 3, '2018-11-24', '2018-12-22', '2018-12-03', 3, 130.789993, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00063', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1832.05);
INSERT INTO orders VALUES (10666, '68', 7, '2018-09-12', '2018-10-10', '2018-09-22', 2, 232.419998, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00064', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4899.36);
INSERT INTO orders VALUES (10537, '68', 1, '2018-05-14', '2018-05-28', '2018-05-19', 1, 78.8499985, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00065', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1902.65);
INSERT INTO orders VALUES (10419, '68', 4, '2018-01-20', '2018-02-17', '2018-01-30', 2, 137.350006, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00066', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2345.25);
INSERT INTO orders VALUES (10255, '68', 9, '2017-07-12', '2017-08-09', '2017-07-15', 3, 148.330002, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00067', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2638.83);
INSERT INTO orders VALUES (10729, '47', 8, '2018-11-04', '2018-12-16', '2018-11-14', 3, 141.059998, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00720', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1991.06);
INSERT INTO orders VALUES (10697, '47', 3, '2018-10-08', '2018-11-05', '2018-10-14', 1, 45.5200005, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00721', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1118.42);
INSERT INTO orders VALUES (10638, '47', 3, '2018-08-20', '2018-09-17', '2018-09-01', 1, 158.440002, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00722', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2878.49);
INSERT INTO orders VALUES (10485, '47', 4, '2018-03-25', '2018-04-08', '2018-03-31', 2, 64.4499969, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00723', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1824.05);
INSERT INTO orders VALUES (10405, '47', 1, '2018-01-06', '2018-02-03', '2018-01-22', 1, 34.8199997, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00724', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 434.82);
INSERT INTO orders VALUES (11007, '60', 8, '2019-04-08', '2019-05-06', '2019-04-13', 2, 202.240005, 'Princesa Isabel Vinhos', 'Estrada da saúde n. 58', 'Lisboa', '', '1756', 'Portugal', 'ORD-00566', NULL, '38.72634879999999,-9.140951500000028', NULL, NULL, 2, '2019-08-29 06:41:30.968608', 'F', 'F', 1, NULL, 2836.14);
INSERT INTO orders VALUES (10878, '63', 4, '2019-02-10', '2019-03-10', '2019-02-12', 1, 46.6899986, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00251', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1666.64);
INSERT INTO orders VALUES (10865, '63', 2, '2019-02-02', '2019-02-16', '2019-02-12', 1, 348.140015, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00252', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 17598.04);
INSERT INTO orders VALUES (10845, '63', 8, '2019-01-21', '2019-02-04', '2019-01-30', 1, 212.979996, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00253', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4271.58);
INSERT INTO orders VALUES (10788, '63', 1, '2018-12-22', '2019-01-19', '2019-01-19', 2, 42.7000008, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00254', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 812.60);
INSERT INTO orders VALUES (10765, '63', 3, '2018-12-04', '2019-01-01', '2018-12-09', 3, 42.7400017, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00255', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1726.64);
INSERT INTO orders VALUES (10745, '63', 9, '2018-11-18', '2018-12-16', '2018-11-27', 1, 3.51999998, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00256', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4533.32);
INSERT INTO orders VALUES (10721, '63', 5, '2018-10-29', '2018-11-26', '2018-10-31', 3, 48.9199982, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00257', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1021.37);
INSERT INTO orders VALUES (10286, '63', 8, '2017-08-21', '2017-09-18', '2017-08-30', 3, 229.240005, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00271', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3245.24);
INSERT INTO orders VALUES (10564, '65', 4, '2018-06-10', '2018-07-08', '2018-06-16', 3, 13.75, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00153', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1312.60);
INSERT INTO orders VALUES (10781, '87', 2, '2018-12-17', '2019-01-14', '2018-12-19', 3, 73.1600037, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00193', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1205.11);
INSERT INTO orders VALUES (10679, '7', 8, '2018-09-23', '2018-10-21', '2018-09-30', 3, 27.9400005, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00182', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 687.94);
INSERT INTO orders VALUES (10628, '7', 4, '2018-08-12', '2018-09-09', '2018-08-20', 3, 30.3600006, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00183', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 480.36);
INSERT INTO orders VALUES (10584, '7', 4, '2018-06-30', '2018-07-28', '2018-07-04', 1, 59.1399994, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00184', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 684.09);
INSERT INTO orders VALUES (10566, '7', 9, '2018-06-12', '2018-07-10', '2018-06-18', 1, 88.4000015, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00185', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2128.10);
INSERT INTO orders VALUES (10559, '7', 6, '2018-06-05', '2018-07-03', '2018-06-13', 1, 8.05000019, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00186', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 555.75);
INSERT INTO orders VALUES (10449, '7', 3, '2018-02-18', '2018-03-18', '2018-02-27', 2, 53.2999992, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00187', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1891.50);
INSERT INTO orders VALUES (10436, '7', 3, '2018-02-05', '2018-03-05', '2018-02-11', 2, 156.660004, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00188', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2367.16);
INSERT INTO orders VALUES (10360, '7', 4, '2017-11-22', '2017-12-20', '2017-12-02', 3, 131.699997, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00189', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 7521.90);
INSERT INTO orders VALUES (11001, '24', 2, '2019-04-06', '2019-05-04', '2019-04-14', 2, 197.300003, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00163', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2966.30);
INSERT INTO orders VALUES (10993, '24', 7, '2019-04-01', '2019-04-29', '2019-04-10', 3, 8.81000042, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00164', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6535.56);
INSERT INTO orders VALUES (10980, '24', 4, '2019-03-27', '2019-05-08', '2019-04-17', 1, 1.25999999, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00165', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 311.06);
INSERT INTO orders VALUES (10977, '24', 8, '2019-03-26', '2019-04-23', '2019-04-10', 3, 208.5, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00166', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2441.50);
INSERT INTO orders VALUES (10955, '24', 8, '2019-03-17', '2019-04-14', '2019-03-20', 2, 3.25999999, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00167', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 96.06);
INSERT INTO orders VALUES (10902, '24', 1, '2019-02-23', '2019-03-23', '2019-03-03', 1, 44.1500015, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00168', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1059.65);
INSERT INTO orders VALUES (10880, '24', 7, '2019-02-10', '2019-03-24', '2019-02-18', 1, 88.0100021, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00169', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1962.41);
INSERT INTO orders VALUES (10824, '24', 8, '2019-01-09', '2019-02-06', '2019-01-30', 1, 1.23000002, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00170', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 252.03);
INSERT INTO orders VALUES (10774, '24', 4, '2018-12-11', '2018-12-25', '2018-12-12', 1, 48.2000008, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00171', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 922.95);
INSERT INTO orders VALUES (10762, '24', 3, '2018-12-02', '2018-12-30', '2018-12-09', 1, 328.73999, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00172', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4665.74);
INSERT INTO orders VALUES (10929, '25', 6, '2019-03-05', '2019-04-02', '2019-03-12', 1, 33.9300003, 'Frankenversand', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', 'ORD-00208', NULL, '50.87059130000001,12.966142799999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1208.68);
INSERT INTO orders VALUES (11066, '89', 7, '2019-05-01', '2019-05-29', '2019-05-04', 2, 44.7200012, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00223', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, 2, '2019-08-29 07:24:44.116369', 'F', 'F', 1, NULL, 973.47);
INSERT INTO orders VALUES (11032, '89', 2, '2019-04-17', '2019-05-15', '2019-04-23', 3, 606.190002, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00224', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 9508.69);
INSERT INTO orders VALUES (10904, '89', 3, '2019-02-24', '2019-03-24', '2019-02-27', 3, 162.949997, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00225', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2087.20);
INSERT INTO orders VALUES (10861, '89', 4, '2019-01-30', '2019-02-27', '2019-02-17', 2, 14.9300003, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00226', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3538.33);
INSERT INTO orders VALUES (10740, '89', 4, '2018-11-13', '2018-12-11', '2018-11-25', 2, 81.8799973, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00227', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1851.08);
INSERT INTO orders VALUES (10723, '89', 3, '2018-10-30', '2018-11-27', '2018-11-25', 1, 21.7199993, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00228', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 490.17);
INSERT INTO orders VALUES (10696, '89', 8, '2018-10-08', '2018-11-19', '2018-10-14', 3, 102.550003, 'White Clover Markets', '1029 - 12th Ave. S.', 'Seattle', 'WA', '98124', 'USA', 'ORD-00229', NULL, '29.61599958156895,-95.22322738650814', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1098.55);
INSERT INTO orders VALUES (10913, '62', 4, '2019-02-26', '2019-03-26', '2019-03-04', 1, 33.0499992, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00671', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 991.30);
INSERT INTO orders VALUES (11021, '63', 3, '2019-04-14', '2019-05-12', '2019-04-21', 1, 297.179993, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', '', '01307', 'Germany', 'ORD-00246', NULL, '52.5272829,13.3048493', NULL, NULL, 2, '2019-08-29 06:49:42.122932', 'F', 'F', 1, NULL, 7238.17);
INSERT INTO orders VALUES (10996, '63', 4, '2019-04-02', '2019-04-30', '2019-04-10', 2, 1.12, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00247', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 561.12);
INSERT INTO orders VALUES (10785, '33', 1, '2018-12-18', '2019-01-15', '2018-12-24', 3, 1.50999999, 'GROSELLA-Restaurante', '5ª Ave. Los Palos Grandes', 'Caracas', 'DF', '1081', 'Venezuela', 'ORD-00221', NULL, '10.4896638,-66.86179349999998', NULL, NULL, 2, '2019-08-29 06:02:35.006881', 'F', 'F', 1, NULL, 389.01);
INSERT INTO orders VALUES (10268, '33', 8, '2017-07-30', '2017-08-27', '2017-08-02', 3, 66.2900009, 'GROSELLA-Restaurante', '5ª Ave. Los Palos Grandes', 'Caracas', 'DF', '1081', 'Venezuela', 'ORD-00222', NULL, '10.4896638,-66.86179349999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1167.49);
INSERT INTO orders VALUES (10662, '48', 3, '2018-09-09', '2018-10-07', '2018-09-18', 2, 1.27999997, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00448', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 126.28);
INSERT INTO orders VALUES (10544, '48', 4, '2018-05-21', '2018-06-18', '2018-05-30', 1, 24.9099998, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00449', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 442.11);
INSERT INTO orders VALUES (10317, '48', 6, '2017-09-30', '2017-10-28', '2017-10-10', 1, 12.6899996, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00450', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 300.69);
INSERT INTO orders VALUES (10307, '48', 2, '2017-09-17', '2017-10-15', '2017-09-25', 2, 0.560000002, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00451', NULL, '46.3570213,-93.86300160000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 424.56);
INSERT INTO orders VALUES (10991, '63', 1, '2019-04-01', '2019-04-29', '2019-04-07', 1, 38.5099983, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00248', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2907.91);
INSERT INTO orders VALUES (10962, '63', 8, '2019-03-19', '2019-04-16', '2019-03-23', 2, 275.790009, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00249', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3859.79);
INSERT INTO orders VALUES (10938, '63', 3, '2019-03-10', '2019-04-07', '2019-03-16', 2, 31.8899994, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00250', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3673.39);
INSERT INTO orders VALUES (10974, '75', 3, '2019-03-25', '2019-04-08', '2019-04-03', 3, 12.96, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00237', NULL, '34.9294429,-80.80477480000002', NULL, NULL, 2, '2019-08-29 07:14:08.994939', 'F', 'F', 1, NULL, 451.96);
INSERT INTO orders VALUES (10821, '75', 1, '2019-01-08', '2019-02-05', '2019-01-15', 1, 36.6800003, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00238', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 714.68);
INSERT INTO orders VALUES (10756, '75', 8, '2018-11-27', '2018-12-25', '2018-12-02', 2, 73.2099991, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00239', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2559.91);
INSERT INTO orders VALUES (10432, '75', 3, '2018-01-31', '2018-02-14', '2018-02-07', 2, 4.34000015, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00240', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 489.34);
INSERT INTO orders VALUES (10385, '75', 1, '2017-12-17', '2018-01-14', '2017-12-23', 2, 30.9599991, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00241', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 894.36);
INSERT INTO orders VALUES (10369, '75', 8, '2017-12-02', '2017-12-30', '2017-12-09', 2, 195.679993, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00242', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2722.63);
INSERT INTO orders VALUES (10349, '75', 7, '2017-11-08', '2017-12-06', '2017-11-15', 1, 8.63000011, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00243', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 150.23);
INSERT INTO orders VALUES (10329, '75', 4, '2017-10-15', '2017-11-26', '2017-10-23', 2, 191.669998, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00244', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5010.87);
INSERT INTO orders VALUES (10271, '75', 6, '2017-08-01', '2017-08-29', '2017-08-30', 2, 4.53999996, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', 'ORD-00245', NULL, '34.9294429,-80.80477480000002', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 52.54);
INSERT INTO orders VALUES (11080, '30', 9, '2019-08-06', '2019-08-19', '2019-08-06', 4, 15, 'Godos Cocina Típica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain', 'ORD-00833', NULL, '41.99937120000001,-1.6796237999999448', 2, '2019-08-06 09:58:37.932418', NULL, NULL, 'F', 'F', 1, NULL, 1326.57);
INSERT INTO orders VALUES (11081, '51', 3, '2019-08-07', '2019-08-21', '2019-08-07', 4, 10, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00834', NULL, '45.5654695,-73.8973307', 2, '2019-08-07 11:26:39.360418', 2, '2019-08-16 05:58:30.696721', 'F', 'F', 1, NULL, 3113.87);
INSERT INTO orders VALUES (11082, '21', 7, '2019-08-16', '2019-08-16', '2019-08-16', 4, 0, 'Familia Arquibaldo', 'Rua Orós, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', 'ORD-00835', NULL, '-23.4811171,-46.68221360000001', 2, '2019-08-16 06:44:51.328072', 2, '2019-08-28 10:48:45.42041', 'F', 'F', 1, NULL, 335.45);
INSERT INTO orders VALUES (10868, '62', 7, '2019-02-04', '2019-03-04', '2019-02-23', 2, 191.270004, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00672', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2195.77);
INSERT INTO orders VALUES (10786, '62', 8, '2018-12-19', '2019-01-16', '2018-12-23', 1, 110.870003, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00673', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2024.12);
INSERT INTO orders VALUES (10728, '62', 4, '2018-11-04', '2018-12-02', '2018-11-11', 2, 58.3300018, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00674', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1355.08);
INSERT INTO orders VALUES (10704, '62', 6, '2018-10-14', '2018-11-11', '2018-11-07', 1, 4.78000021, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00675', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 600.28);
INSERT INTO orders VALUES (10659, '62', 7, '2018-09-05', '2018-10-03', '2018-09-10', 2, 105.809998, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00676', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1397.26);
INSERT INTO orders VALUES (10637, '62', 6, '2018-08-19', '2018-09-16', '2018-08-26', 1, 201.289993, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00677', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3097.44);
INSERT INTO orders VALUES (10487, '62', 2, '2018-03-26', '2018-04-23', '2018-03-28', 2, 71.0699997, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00678', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 995.92);
INSERT INTO orders VALUES (10406, '62', 7, '2018-01-07', '2018-02-18', '2018-01-13', 1, 108.040001, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00679', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2125.84);
INSERT INTO orders VALUES (10372, '62', 5, '2017-12-04', '2018-01-01', '2017-12-09', 2, 890.780029, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00680', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 13170.98);
INSERT INTO orders VALUES (11068, '62', 8, '2019-05-04', '2019-06-01', '2019-08-28', 2, 81.75, 'Queen Cozinha', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', 'ORD-00668', NULL, '-23.56499059999999,-46.69212199999998', NULL, NULL, 2, '2019-08-28 11:02:49.762899', 'F', 'F', 1, NULL, 2466.1);
INSERT INTO orders VALUES (11027, '10', 1, '2019-04-16', '2019-05-14', '2019-04-20', 1, 52.5200005, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00701', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1222.32);
INSERT INTO orders VALUES (10982, '10', 2, '2019-03-27', '2019-04-24', '2019-04-08', 1, 14.0100002, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00702', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1028.01);
INSERT INTO orders VALUES (10975, '10', 1, '2019-03-25', '2019-04-22', '2019-03-27', 3, 32.2700005, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00703', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 749.77);
INSERT INTO orders VALUES (10949, '10', 2, '2019-03-13', '2019-04-10', '2019-03-17', 3, 74.4400024, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00704', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4496.44);
INSERT INTO orders VALUES (10944, '10', 6, '2019-03-12', '2019-03-26', '2019-03-13', 3, 52.9199982, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00705', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1191.52);
INSERT INTO orders VALUES (10918, '10', 3, '2019-03-02', '2019-03-30', '2019-03-11', 3, 48.8300018, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00706', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1978.33);
INSERT INTO orders VALUES (10742, '10', 3, '2018-11-14', '2018-12-12', '2018-11-18', 3, 243.729996, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00707', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3361.73);
INSERT INTO orders VALUES (10492, '10', 3, '2018-04-01', '2018-04-29', '2018-04-11', 1, 62.8899994, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00708', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 958.79);
INSERT INTO orders VALUES (10431, '10', 4, '2018-01-30', '2018-02-13', '2018-02-07', 2, 44.1699982, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00709', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2566.42);
INSERT INTO orders VALUES (10411, '10', 9, '2018-01-10', '2018-02-07', '2018-01-21', 3, 23.6499996, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00710', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1231.55);
INSERT INTO orders VALUES (10410, '10', 3, '2018-01-10', '2018-02-07', '2018-01-15', 3, 2.4000001, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00711', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 804.40);
INSERT INTO orders VALUES (10389, '10', 4, '2017-12-20', '2018-01-17', '2017-12-24', 2, 47.4199982, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00712', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1880.22);
INSERT INTO orders VALUES (11048, '10', 7, '2019-04-24', '2019-05-22', '2019-04-30', 3, 24.1200008, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00699', NULL, '38.5022232,-122.9980835', NULL, NULL, 2, '2019-08-28 11:14:32.265793', 'F', 'F', 1, NULL, 549.12);
INSERT INTO orders VALUES (10860, '26', 3, '2019-01-29', '2019-02-26', '2019-02-04', 3, 19.2600002, 'France restauration', '54, rue Royale', 'Nantes', NULL, '44000', 'France', 'ORD-00821', NULL, '48.8889585,2.333229899999992', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 538.26);
INSERT INTO orders VALUES (10671, '26', 1, '2018-09-17', '2018-10-15', '2018-09-24', 1, 30.3400002, 'France restauration', '54, rue Royale', 'Nantes', NULL, '44000', 'France', 'ORD-00822', NULL, '48.8889585,2.333229899999992', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 950.44);
INSERT INTO orders VALUES (11079, '2', 8, '2019-08-06', '2019-08-27', '2019-08-06', 4, 10, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', '', '05021', 'Mexico', 'ORD-00832', NULL, '22.1249642,-100.9622', 2, '2019-08-06 05:24:41.350693', 2, '2019-08-16 04:22:20.006252', 'F', 'F', 1, NULL, 834.80);
INSERT INTO orders VALUES (10972, '40', 4, '2019-03-24', '2019-04-21', '2019-03-26', 2, 0.0199999996, 'La corne d''abondance', '67, avenue de l''Europe', 'Versailles', '', '78000', 'France', 'ORD-00828', NULL, '42.5556184,9.441732300000012', NULL, NULL, 2, '2019-08-28 11:46:28.792992', 'F', 'F', 1, NULL, 251.52);
INSERT INTO orders VALUES (10973, '40', 6, '2019-03-24', '2019-04-21', '2019-03-27', 2, 15.1700001, 'La corne d''abondance', '67, avenue de l''Europe', 'Versailles', NULL, '78000', 'France', 'ORD-00827', NULL, '42.5556184,9.441732300000012', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 306.72);
INSERT INTO orders VALUES (11078, '4', 2, '2019-08-05', '2019-08-20', '2019-08-05', 4, 25, 'Around the Horn', '120 Hanover Sq.', 'London', '', 'WA1 1DP', 'UK', 'ORD-00831', NULL, '51.51352860000001,-0.14382079999995767', 2, '2019-08-05 11:53:10.835611', NULL, NULL, 'F', 'F', 1, NULL, 351.90);
INSERT INTO orders VALUES (11018, '48', 4, '2019-04-13', '2019-05-11', '2019-04-16', 2, 11.6499996, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', 'ORD-00444', NULL, '46.3570213,-93.86300160000002', NULL, NULL, 2, '2019-08-29 06:25:37.11741', 'F', 'F', 1, NULL, 1586.65);
INSERT INTO orders VALUES (10441, '55', 3, '2018-02-10', '2018-03-24', '2018-03-14', 2, 73.0199966, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00441', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1828.02);
INSERT INTO orders VALUES (10338, '55', 4, '2017-10-25', '2017-11-22', '2017-10-29', 3, 84.2099991, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00442', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1018.71);
INSERT INTO orders VALUES (11085, '94', 9, '2019-08-19', '2019-09-02', '2019-08-19', 9, 10, 'Camilo Mendid Mellow ', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', '', '682306', 'India', 'ORD-00838', NULL, '9.986262899999998,76.32980889999999', 2, '2019-08-19 04:30:44.906299', 2, '2019-08-27 11:19:56.664384', 'F', 'F', 6, NULL, 435.00);
INSERT INTO orders VALUES (11084, '94', 10, '2019-08-19', '2019-09-10', '2019-08-19', 9, 10, 'Camilo Mendid Mellow ', 'No. 1/15 A, 1/15 B, Eroor Rd', 'Kochi', '', '682306', 'India', 'ORD-00837', NULL, '9.986262899999998,76.32980889999999', 2, '2019-08-19 04:27:42.850892', 2, '2019-08-27 11:20:16.396792', 'F', 'F', 6, NULL, 1368.50);
INSERT INTO orders VALUES (10496, '81', 7, '2018-04-04', '2018-05-02', '2018-04-07', 2, 46.7700005, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00393', NULL, '-23.5394124,-46.6458308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 246.72);
INSERT INTO orders VALUES (10292, '81', 1, '2017-08-28', '2017-09-25', '2017-09-02', 2, 1.35000002, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00394', NULL, '-23.5394124,-46.6458308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1297.35);
INSERT INTO orders VALUES (10839, '81', 3, '2019-01-19', '2019-02-16', '2019-01-22', 3, 35.4300003, 'Tradiçao Hipermercados', 'Av. Inês de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', 'ORD-00389', NULL, '-23.5394124,-46.6458308', NULL, NULL, 2, '2019-08-28 11:07:04.76543', 'F', 'F', 1, NULL, 954.73);
INSERT INTO orders VALUES (10305, '55', 8, '2017-09-13', '2017-10-11', '2017-10-09', 3, 257.619995, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00443', NULL, '34.0774,-117.88928609999999', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4414.32);
INSERT INTO orders VALUES (11034, '55', 8, '2019-04-20', '2019-06-01', '2019-04-27', 1, 40.3199997, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', 'ORD-00434', NULL, '34.0774,-117.88928609999999', NULL, NULL, 2, '2019-08-29 06:33:14.704284', 'F', 'F', 1, NULL, 594.62);
INSERT INTO orders VALUES (10433, '60', 3, '2018-02-03', '2018-03-03', '2018-03-04', 3, 73.8300018, 'Princesa Isabel Vinhos', 'Estrada da saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', 'ORD-00568', NULL, '38.72634879999999,-9.140951500000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 925.03);
INSERT INTO orders VALUES (10397, '60', 5, '2017-12-27', '2018-01-24', '2018-01-02', 1, 60.2599983, 'Princesa Isabel Vinhos', 'Estrada da saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', 'ORD-00569', NULL, '38.72634879999999,-9.140951500000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 903.16);
INSERT INTO orders VALUES (10336, '60', 7, '2017-10-23', '2017-11-20', '2017-10-25', 2, 15.5100002, 'Princesa Isabel Vinhos', 'Estrada da saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', 'ORD-00570', NULL, '38.72634879999999,-9.140951500000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 332.21);
INSERT INTO orders VALUES (10612, '71', 1, '2018-07-28', '2018-08-25', '2018-08-01', 2, 544.080017, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00515', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6919.08);
INSERT INTO orders VALUES (10724, '51', 8, '2018-10-30', '2018-12-11', '2018-11-05', 2, 57.75, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00553', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 696.25);
INSERT INTO orders VALUES (10619, '51', 3, '2018-08-04', '2018-09-01', '2018-08-07', 3, 91.0500031, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00554', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1351.05);
INSERT INTO orders VALUES (10618, '51', 1, '2018-08-01', '2018-09-12', '2018-08-08', 1, 154.679993, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00555', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2852.18);
INSERT INTO orders VALUES (10605, '51', 1, '2018-07-21', '2018-08-18', '2018-07-29', 2, 379.130005, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00556', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4704.93);
INSERT INTO orders VALUES (10590, '51', 4, '2018-07-07', '2018-08-04', '2018-07-14', 3, 44.7700005, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00557', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1184.72);
INSERT INTO orders VALUES (10570, '51', 3, '2018-06-17', '2018-07-15', '2018-06-19', 3, 188.990005, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00558', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2783.89);
INSERT INTO orders VALUES (10565, '51', 8, '2018-06-11', '2018-07-09', '2018-06-18', 2, 7.1500001, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00559', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 717.95);
INSERT INTO orders VALUES (10505, '51', 3, '2018-04-14', '2018-05-12', '2018-04-21', 3, 7.13000011, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00560', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 155.03);
INSERT INTO orders VALUES (10439, '51', 6, '2018-02-07', '2018-03-07', '2018-02-10', 3, 4.07000017, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00561', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1082.07);
INSERT INTO orders VALUES (10424, '51', 7, '2018-01-23', '2018-02-20', '2018-01-27', 2, 370.609985, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00562', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11863.21);
INSERT INTO orders VALUES (10376, '51', 1, '2017-12-09', '2018-01-06', '2017-12-13', 2, 20.3899994, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00563', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 440.34);
INSERT INTO orders VALUES (10339, '51', 2, '2017-10-28', '2017-11-25', '2017-11-04', 2, 15.6599998, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00564', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3478.81);
INSERT INTO orders VALUES (10332, '51', 3, '2017-10-17', '2017-11-28', '2017-10-21', 2, 52.8400002, 'Mère Paillarde', '43 rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', 'ORD-00565', NULL, '45.5654695,-73.8973307', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2285.84);
INSERT INTO orders VALUES (10966, '14', 4, '2019-03-20', '2019-04-17', '2019-04-08', 1, 27.1900005, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00052', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1282.49);
INSERT INTO orders VALUES (10746, '14', 1, '2018-11-19', '2018-12-17', '2018-11-21', 3, 31.4300003, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00053', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2343.13);
INSERT INTO orders VALUES (10731, '14', 7, '2018-11-06', '2018-12-04', '2018-11-14', 1, 96.6500015, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00054', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2086.55);
INSERT INTO orders VALUES (10519, '14', 6, '2018-04-28', '2018-05-26', '2018-05-01', 3, 91.7600021, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', NULL, '3012', 'Switzerland', 'ORD-00055', NULL, '46.71699467859428,6.641042415344259', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2447.66);
INSERT INTO orders VALUES (10285, '63', 1, '2017-08-20', '2017-09-17', '2017-08-26', 2, 76.8300018, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00272', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2255.43);
INSERT INTO orders VALUES (10273, '63', 3, '2017-08-05', '2017-09-02', '2017-08-12', 3, 76.0699997, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00273', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2218.27);
INSERT INTO orders VALUES (11077, '65', 1, '2019-05-06', '2019-06-03', '2019-08-29', 2, 8.52999973, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00144', NULL, '36.8707647,-111.38442580000003', NULL, NULL, 2, '2019-08-29 06:52:03.635107', 'F', 'F', 1, NULL, 1382.44);
INSERT INTO orders VALUES (10989, '61', 2, '2019-03-31', '2019-04-28', '2019-04-02', 1, 34.7599983, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00135', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, 2, '2019-08-28 11:00:20.730242', 'F', 'F', 1, NULL, 1388.36);
INSERT INTO orders VALUES (10794, '61', 6, '2018-12-24', '2019-01-21', '2019-01-02', 1, 21.4899998, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00136', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 414.54);
INSERT INTO orders VALUES (10720, '61', 8, '2018-10-28', '2018-11-11', '2018-11-05', 2, 9.52999973, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00137', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 559.53);
INSERT INTO orders VALUES (10647, '61', 4, '2018-08-27', '2018-09-10', '2018-09-03', 2, 45.5400009, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00138', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 681.54);
INSERT INTO orders VALUES (10587, '61', 1, '2018-07-02', '2018-07-30', '2018-07-09', 1, 62.5200005, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00139', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 869.90);
INSERT INTO orders VALUES (10421, '61', 8, '2018-01-21', '2018-03-04', '2018-01-27', 1, 99.2300034, 'Que Delícia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', 'ORD-00140', NULL, '-22.8657815,-43.27808189999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1371.98);
INSERT INTO orders VALUES (11025, '87', 6, '2019-04-15', '2019-05-13', '2019-04-24', 3, 29.1700001, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland', 'ORD-00192', NULL, '65.011363,25.472508999999945', NULL, NULL, 2, '2019-08-28 11:29:58.08507', 'F', 'F', 1, NULL, 328.97);
INSERT INTO orders VALUES (10858, '40', 2, '2019-01-29', '2019-02-26', '2019-02-03', 1, 52.5099983, 'La corne d''abondance', '67, avenue de l''Europe', 'Versailles', NULL, '78000', 'France', 'ORD-00830', NULL, '42.5556184,9.441732300000012', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 701.51);
INSERT INTO orders VALUES (10927, '40', 4, '2019-03-05', '2019-04-02', '2019-04-08', 1, 19.7900009, 'La corne d''abondance', '67, avenue de l''Europe', 'Versailles', NULL, '78000', 'France', 'ORD-00829', NULL, '42.5556184,9.441732300000012', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 819.79);
INSERT INTO orders VALUES (11020, '56', 2, '2019-04-14', '2019-05-12', '2019-04-16', 2, 43.2999992, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', '', '50739', 'Germany', 'ORD-00125', NULL, '48.62957,9.347358699999972', NULL, NULL, 2, '2019-08-29 06:37:56.722081', 'F', 'F', 1, NULL, 787.15);
INSERT INTO orders VALUES (10259, '13', 4, '2017-07-18', '2017-08-15', '2017-07-25', 3, 3.25, 'Centro comercial Moctezuma', 'Sierras de Granada 9993', 'México D.F.', '', '05022', 'Mexico', 'ORD-00124', NULL, '32.5321636,-116.9460019', NULL, NULL, 2, '2019-08-29 05:33:29.783797', 'F', 'F', 1, NULL, 104.05);
INSERT INTO orders VALUES (10999, '56', 6, '2019-04-03', '2019-05-01', '2019-04-10', 2, 96.3499985, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00126', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1357.20);
INSERT INTO orders VALUES (10833, '56', 6, '2019-01-15', '2019-02-12', '2019-01-23', 2, 71.4899979, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00127', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1078.89);
INSERT INTO orders VALUES (10766, '56', 4, '2018-12-05', '2019-01-02', '2018-12-09', 1, 157.550003, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00128', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2467.55);
INSERT INTO orders VALUES (10684, '56', 3, '2018-09-26', '2018-10-24', '2018-09-30', 1, 145.630005, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00129', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1913.63);
INSERT INTO orders VALUES (10580, '56', 4, '2018-06-26', '2018-07-24', '2018-07-01', 3, 75.8899994, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00130', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1142.84);
INSERT INTO orders VALUES (10554, '56', 4, '2018-05-30', '2018-06-27', '2018-06-05', 3, 120.970001, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00131', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1940.27);
INSERT INTO orders VALUES (10508, '56', 1, '2018-04-16', '2018-05-14', '2018-05-13', 2, 4.98999977, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00132', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 244.99);
INSERT INTO orders VALUES (10407, '56', 2, '2018-01-07', '2018-02-04', '2018-01-30', 2, 91.4800034, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00133', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1285.48);
INSERT INTO orders VALUES (10260, '56', 4, '2017-07-19', '2017-08-16', '2017-07-29', 1, 55.0900002, 'Ottilies Käseladen', 'Mehrheimerstr. 369', 'Köln', NULL, '50739', 'Germany', 'ORD-00134', NULL, '48.62957,9.347358699999972', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1800.54);
INSERT INTO orders VALUES (10479, '65', 3, '2018-03-19', '2018-04-16', '2018-03-21', 3, 708.950012, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00154', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11204.55);
INSERT INTO orders VALUES (10401, '65', 1, '2018-01-01', '2018-01-29', '2018-01-10', 1, 12.5100002, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00155', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3881.11);
INSERT INTO orders VALUES (10346, '65', 3, '2017-11-05', '2017-12-17', '2017-11-08', 3, 142.080002, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00156', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1873.18);
INSERT INTO orders VALUES (10316, '65', 1, '2017-09-27', '2017-10-25', '2017-10-08', 3, 150.149994, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00157', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2985.15);
INSERT INTO orders VALUES (10314, '65', 1, '2017-09-25', '2017-10-23', '2017-10-04', 2, 74.1600037, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00158', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2400.86);
INSERT INTO orders VALUES (10294, '65', 4, '2017-08-30', '2017-09-27', '2017-09-05', 2, 147.259995, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00159', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2034.86);
INSERT INTO orders VALUES (10272, '65', 6, '2017-08-02', '2017-08-30', '2017-08-06', 2, 98.0299988, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00160', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1554.03);
INSERT INTO orders VALUES (10262, '65', 8, '2017-07-22', '2017-08-19', '2017-07-25', 3, 48.2900009, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', 'ORD-00161', NULL, '36.8707647,-111.38442580000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 672.89);
INSERT INTO orders VALUES (10750, '87', 9, '2018-11-21', '2018-12-19', '2018-11-24', 1, 79.3000031, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00194', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1950.10);
INSERT INTO orders VALUES (10636, '87', 4, '2018-08-19', '2018-09-16', '2018-08-26', 1, 1.14999998, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00195', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 630.65);
INSERT INTO orders VALUES (10583, '87', 2, '2018-06-30', '2018-07-28', '2018-07-04', 2, 7.28000021, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00196', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2420.88);
INSERT INTO orders VALUES (10553, '87', 2, '2018-05-30', '2018-06-27', '2018-06-03', 2, 149.490005, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00197', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1695.79);
INSERT INTO orders VALUES (10526, '87', 4, '2018-05-05', '2018-06-02', '2018-05-15', 2, 58.5900002, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00198', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1402.29);
INSERT INTO orders VALUES (10455, '87', 8, '2018-02-24', '2018-04-07', '2018-03-03', 2, 180.449997, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00199', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2864.45);
INSERT INTO orders VALUES (10437, '87', 8, '2018-02-05', '2018-03-05', '2018-02-12', 1, 19.9699993, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00200', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 412.97);
INSERT INTO orders VALUES (10416, '87', 8, '2018-01-16', '2018-02-13', '2018-01-27', 3, 22.7199993, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00201', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 742.72);
INSERT INTO orders VALUES (10412, '87', 8, '2018-01-13', '2018-02-10', '2018-01-15', 2, 3.76999998, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00202', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 375.67);
INSERT INTO orders VALUES (10333, '87', 5, '2017-10-18', '2017-11-15', '2017-10-25', 3, 0.589999974, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00203', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 954.39);
INSERT INTO orders VALUES (10320, '87', 5, '2017-10-03', '2017-10-17', '2017-10-18', 3, 34.5699997, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00204', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 550.57);
INSERT INTO orders VALUES (10270, '87', 1, '2017-08-01', '2017-08-29', '2017-08-02', 1, 136.539993, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00205', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1512.54);
INSERT INTO orders VALUES (10266, '87', 3, '2017-07-26', '2017-09-06', '2017-07-31', 3, 25.7299995, 'Wartian Herkku', 'Torikatu 38', 'Oulu', NULL, '90110', 'Finland', 'ORD-00206', NULL, '65.011363,25.472508999999945', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 390.48);
INSERT INTO orders VALUES (10812, '66', 5, '2019-01-02', '2019-01-30', '2019-01-12', 1, 59.7799988, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00366', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1911.58);
INSERT INTO orders VALUES (10727, '66', 2, '2018-11-03', '2018-12-01', '2018-12-05', 1, 89.9000015, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00367', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1799.75);
INSERT INTO orders VALUES (10655, '66', 1, '2018-09-03', '2018-10-01', '2018-09-11', 2, 4.40999985, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00368', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 197.21);
INSERT INTO orders VALUES (10586, '66', 9, '2018-07-02', '2018-07-30', '2018-07-09', 1, 0.479999989, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00369', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 28.33);
INSERT INTO orders VALUES (10562, '66', 1, '2018-06-09', '2018-07-07', '2018-06-12', 1, 22.9500008, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00370', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 565.75);
INSERT INTO orders VALUES (10443, '66', 8, '2018-02-12', '2018-03-12', '2018-02-14', 1, 13.9499998, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', NULL, '42100', 'Italy', 'ORD-00371', NULL, '44.64407,11.061351999999943', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 551.35);
INSERT INTO orders VALUES (10297, '7', 5, '2017-09-04', '2017-10-16', '2017-09-10', 2, 5.73999977, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00190', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1425.74);
INSERT INTO orders VALUES (10265, '7', 2, '2017-07-25', '2017-08-22', '2017-08-12', 1, 55.2799988, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', 'ORD-00191', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1231.28);
INSERT INTO orders VALUES (10826, '7', 6, '2019-01-12', '2019-02-09', '2019-02-06', 1, 7.09000015, 'Blondel père et fils', '24, place Kléber', 'Strasbourg', '', '67000', 'France', 'ORD-00181', NULL, '48.86333880000001,2.3885539000000335', NULL, NULL, 2, '2019-08-28 11:35:50.792121', 'F', 'F', 1, NULL, 737.09);
INSERT INTO orders VALUES (10511, '9', 4, '2018-04-18', '2018-05-16', '2018-04-21', 3, 350.640015, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00548', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3350.19);
INSERT INTO orders VALUES (10470, '9', 4, '2018-03-11', '2018-04-08', '2018-03-14', 2, 64.5599976, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00549', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1885.36);
INSERT INTO orders VALUES (10362, '9', 3, '2017-11-25', '2017-12-23', '2017-11-28', 1, 96.0400009, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00550', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1645.64);
INSERT INTO orders VALUES (10340, '9', 1, '2017-10-29', '2017-11-26', '2017-11-08', 3, 166.309998, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00551', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2730.56);
INSERT INTO orders VALUES (10331, '9', 9, '2017-10-16', '2017-11-27', '2017-10-21', 1, 10.1899996, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', 'ORD-00552', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 98.69);
INSERT INTO orders VALUES (10609, '18', 7, '2018-07-24', '2018-08-21', '2018-07-30', 2, 1.85000002, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', NULL, '44000', 'France', 'ORD-00462', NULL, '47.1929341,-1.5738794999999755', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 425.85);
INSERT INTO orders VALUES (10311, '18', 1, '2017-09-20', '2017-10-04', '2017-09-26', 3, 24.6900005, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', NULL, '44000', 'France', 'ORD-00463', NULL, '47.1929341,-1.5738794999999755', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 293.49);
INSERT INTO orders VALUES (10890, '18', 7, '2019-02-16', '2019-03-16', '2019-02-18', 1, 32.7599983, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', '', '44000', 'France', 'ORD-00460', NULL, '47.1929341,-1.5738794999999755', NULL, NULL, 2, '2019-08-28 11:42:35.328397', 'F', 'F', 1, NULL, 892.86);
INSERT INTO orders VALUES (10832, '41', 2, '2019-01-14', '2019-02-11', '2019-01-19', 2, 43.2599983, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00587', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 611.61);
INSERT INTO orders VALUES (10413, '41', 3, '2018-01-14', '2018-02-11', '2018-01-16', 2, 95.6600037, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00595', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2218.86);
INSERT INTO orders VALUES (10371, '41', 1, '2017-12-03', '2017-12-31', '2017-12-24', 1, 0.449999988, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00596', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 91.45);
INSERT INTO orders VALUES (10358, '41', 5, '2017-11-20', '2017-12-18', '2017-11-27', 1, 19.6399994, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00597', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 471.49);
INSERT INTO orders VALUES (10350, '41', 6, '2017-11-11', '2017-12-09', '2017-12-03', 2, 64.1900024, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00598', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 777.39);
INSERT INTO orders VALUES (11051, '41', 7, '2019-04-27', '2019-05-25', '2019-08-28', 3, 2.78999996, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France', 'ORD-00585', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, 2, '2019-08-28 11:47:31.057113', 'F', 'F', 1, NULL, 47.59);
INSERT INTO orders VALUES (11033, '68', 7, '2019-04-17', '2019-05-15', '2019-04-23', 3, 84.7399979, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00059', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3676.54);
INSERT INTO orders VALUES (10951, '68', 9, '2019-03-16', '2019-04-27', '2019-04-07', 2, 30.8500004, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00060', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 513.60);
INSERT INTO orders VALUES (10931, '68', 4, '2019-03-06', '2019-03-20', '2019-03-19', 2, 13.6000004, 'Richter Supermarkt', 'Starenweg 5', 'Genève', NULL, '1204', 'Switzerland', 'ORD-00061', NULL, '47.18533179561253,7.696203537434371', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 850.45);
INSERT INTO orders VALUES (10800, '72', 1, '2018-12-26', '2019-01-23', '2019-01-05', 3, 137.440002, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00624', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1769.29);
INSERT INTO orders VALUES (10547, '72', 3, '2018-05-23', '2018-06-20', '2018-06-02', 2, 178.429993, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00625', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2086.28);
INSERT INTO orders VALUES (10523, '72', 7, '2018-05-01', '2018-05-29', '2018-05-30', 2, 77.6299973, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00626', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2793.13);
INSERT INTO orders VALUES (10472, '72', 8, '2018-03-12', '2018-04-09', '2018-03-19', 1, 4.19999981, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00627', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1055.35);
INSERT INTO orders VALUES (10388, '72', 2, '2017-12-19', '2018-01-16', '2017-12-20', 1, 34.8600006, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00628', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1308.46);
INSERT INTO orders VALUES (10377, '72', 1, '2017-12-09', '2018-01-06', '2017-12-13', 3, 22.2099991, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00629', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1037.91);
INSERT INTO orders VALUES (10359, '72', 5, '2017-11-21', '2017-12-19', '2017-11-26', 3, 288.429993, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', NULL, 'OX15 4NB', 'UK', 'ORD-00630', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3942.68);
INSERT INTO orders VALUES (10926, '2', 4, '2019-03-04', '2019-04-01', '2019-03-11', 3, 39.9199982, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', 'ORD-00452', NULL, '22.1249642,-100.9622', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 554.32);
INSERT INTO orders VALUES (10984, '71', 1, '2019-03-30', '2019-04-27', '2019-04-03', 3, 211.220001, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00498', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2020.97);
INSERT INTO orders VALUES (10983, '71', 2, '2019-03-27', '2019-04-24', '2019-04-06', 2, 657.539978, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00499', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1453.89);
INSERT INTO orders VALUES (10941, '71', 7, '2019-03-11', '2019-04-08', '2019-03-20', 2, 400.809998, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00500', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5169.06);
INSERT INTO orders VALUES (10894, '71', 1, '2019-02-18', '2019-03-18', '2019-02-20', 1, 116.129997, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00501', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3013.98);
INSERT INTO orders VALUES (10882, '71', 4, '2019-02-11', '2019-03-11', '2019-02-20', 3, 23.1000004, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00502', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1011.20);
INSERT INTO orders VALUES (10847, '71', 4, '2019-01-22', '2019-02-05', '2019-02-10', 3, 487.570007, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00503', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6651.27);
INSERT INTO orders VALUES (10815, '71', 2, '2019-01-05', '2019-02-02', '2019-01-14', 3, 14.6199999, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00504', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 54.62);
INSERT INTO orders VALUES (10757, '71', 6, '2018-11-27', '2018-12-25', '2018-12-15', 1, 8.18999958, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00505', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3090.19);
INSERT INTO orders VALUES (10748, '71', 3, '2018-11-20', '2018-12-18', '2018-11-28', 1, 232.550003, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00506', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2428.55);
INSERT INTO orders VALUES (10722, '71', 8, '2018-10-29', '2018-12-10', '2018-11-04', 1, 74.5800018, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00507', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1644.58);
INSERT INTO orders VALUES (10714, '71', 5, '2018-10-22', '2018-11-19', '2018-10-27', 3, 24.4899998, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00508', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2964.24);
INSERT INTO orders VALUES (10713, '71', 1, '2018-10-22', '2018-11-19', '2018-10-24', 1, 167.050003, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00509', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2994.95);
INSERT INTO orders VALUES (10711, '71', 5, '2018-10-21', '2018-12-02', '2018-10-29', 2, 52.4099998, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00510', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4504.11);
INSERT INTO orders VALUES (10700, '71', 3, '2018-10-10', '2018-11-07', '2018-10-16', 1, 65.0999985, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00511', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2112.30);
INSERT INTO orders VALUES (10678, '71', 7, '2018-09-23', '2018-10-21', '2018-10-16', 3, 388.980011, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00512', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5645.48);
INSERT INTO orders VALUES (10657, '71', 2, '2018-09-04', '2018-10-02', '2018-09-15', 2, 352.690002, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00513', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4724.29);
INSERT INTO orders VALUES (10627, '71', 8, '2018-08-11', '2018-09-22', '2018-08-21', 3, 107.459999, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00514', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1371.81);
INSERT INTO orders VALUES (10607, '71', 5, '2018-07-22', '2018-08-19', '2018-07-25', 1, 200.240005, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00516', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6675.64);
INSERT INTO orders VALUES (10603, '71', 8, '2018-07-18', '2018-08-15', '2018-08-08', 2, 48.7700005, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00517', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1556.72);
INSERT INTO orders VALUES (10555, '71', 6, '2018-06-02', '2018-06-30', '2018-06-04', 3, 252.490005, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00518', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3931.99);
INSERT INTO orders VALUES (10510, '71', 6, '2018-04-18', '2018-05-16', '2018-04-28', 3, 367.630005, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00519', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5102.97);
INSERT INTO orders VALUES (10452, '71', 8, '2018-02-20', '2018-03-20', '2018-02-26', 1, 140.259995, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00520', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2236.21);
INSERT INTO orders VALUES (10440, '71', 4, '2018-02-10', '2018-03-10', '2018-02-28', 2, 86.5299988, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00521', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5879.03);
INSERT INTO orders VALUES (10398, '71', 2, '2017-12-30', '2018-01-27', '2018-01-09', 3, 89.1600037, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00522', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2825.06);
INSERT INTO orders VALUES (10393, '71', 1, '2017-12-25', '2018-01-22', '2018-01-03', 3, 126.559998, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00523', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3428.16);
INSERT INTO orders VALUES (10324, '71', 9, '2017-10-08', '2017-11-05', '2017-10-10', 1, 214.270004, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00524', NULL, '39.3616792,-74.42970839999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 6369.57);
INSERT INTO orders VALUES (11064, '71', 1, '2019-05-01', '2019-05-29', '2019-05-04', 1, 30.0900002, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', 'ORD-00494', NULL, '39.3616792,-74.42970839999998', NULL, NULL, 2, '2019-08-29 06:59:39.979334', 'F', 'F', 1, NULL, 4752.09);
INSERT INTO orders VALUES (10869, '72', 5, '2019-02-04', '2019-03-04', '2019-02-09', 1, 143.279999, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK', 'ORD-00622', NULL, '51.4823491,-0.21343790000003082', NULL, NULL, 2, '2019-08-29 07:00:56.275108', 'F', 'F', 1, NULL, 1773.28);
INSERT INTO orders VALUES (10793, '4', 3, '2018-12-24', '2019-01-21', '2019-01-08', 3, 4.51999998, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00613', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 195.62);
INSERT INTO orders VALUES (10768, '4', 3, '2018-12-08', '2019-01-05', '2018-12-15', 2, 146.320007, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00614', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1623.32);
INSERT INTO orders VALUES (10743, '4', 1, '2018-11-17', '2018-12-15', '2018-11-21', 2, 23.7199993, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00615', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 359.67);
INSERT INTO orders VALUES (10741, '4', 4, '2018-11-14', '2018-11-28', '2018-11-18', 3, 10.96, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00616', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 295.76);
INSERT INTO orders VALUES (10707, '4', 4, '2018-10-16', '2018-10-30', '2018-10-23', 3, 21.7399998, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00617', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1725.59);
INSERT INTO orders VALUES (10558, '4', 1, '2018-06-04', '2018-07-02', '2018-06-10', 2, 72.9700012, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00618', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2215.87);
INSERT INTO orders VALUES (10453, '4', 1, '2018-02-21', '2018-03-21', '2018-02-26', 2, 25.3600006, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00619', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 478.16);
INSERT INTO orders VALUES (10383, '4', 8, '2017-12-16', '2018-01-13', '2017-12-18', 3, 34.2400017, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00620', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 933.24);
INSERT INTO orders VALUES (10355, '4', 6, '2017-11-15', '2017-12-13', '2017-11-20', 1, 41.9500008, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK', 'ORD-00621', NULL, '51.51352860000001,-0.14382079999995767', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 521.95);
INSERT INTO orders VALUES (10964, '74', 3, '2019-03-20', '2019-04-17', '2019-03-24', 2, 87.3799973, 'Spécialités du monde', '25, rue Lauriston', 'Paris', NULL, '75016', 'France', 'ORD-00824', NULL, '46.77112440000001,-0.8428728000000092', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2139.88);
INSERT INTO orders VALUES (10907, '74', 6, '2019-02-25', '2019-03-25', '2019-02-27', 3, 9.18999958, 'Spécialités du monde', '25, rue Lauriston', 'Paris', NULL, '75016', 'France', 'ORD-00825', NULL, '46.77112440000001,-0.8428728000000092', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 117.69);
INSERT INTO orders VALUES (10738, '74', 2, '2018-11-12', '2018-12-10', '2018-11-18', 1, 2.91000009, 'Spécialités du monde', '25, rue Lauriston', 'Paris', NULL, '75016', 'France', 'ORD-00826', NULL, '46.77112440000001,-0.8428728000000092', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 55.26);
INSERT INTO orders VALUES (11043, '74', 5, '2019-04-22', '2019-05-20', '2019-04-29', 2, 8.80000019, 'Spécialités du monde', '25, rue Lauriston', 'Paris', '', '75016', 'France', 'ORD-00823', NULL, '46.77112440000001,-0.8428728000000092', NULL, NULL, 2, '2019-08-29 07:13:05.937948', 'F', 'F', 1, NULL, 218.8);
INSERT INTO orders VALUES (10967, '79', 2, '2019-03-23', '2019-04-20', '2019-04-02', 2, 62.2200012, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', '', '44087', 'Germany', 'ORD-00008', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, 2, '2019-08-29 07:18:21.942433', 'F', 'F', 1, NULL, 972.62);
INSERT INTO orders VALUES (10924, '5', 3, '2019-03-04', '2019-04-01', '2019-04-08', 2, 151.520004, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', '', 'S-958 22', 'Sweden', 'ORD-00299', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, 2, '2019-08-29 05:18:30.235341', 'F', 'F', 1, NULL, 2185.82);
INSERT INTO orders VALUES (10249, '79', 6, '2017-07-05', '2017-08-16', '2017-07-10', 1, 11.6099997, 'Toms Spezialitäten', 'Luisenstr. 48', 'Münster', NULL, '44087', 'Germany', 'ORD-00013', NULL, '51.59226999999999,7.138982199999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1875.01);
INSERT INTO orders VALUES (10866, '5', 5, '2019-02-03', '2019-03-03', '2019-02-12', 1, 109.110001, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00301', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1569.96);
INSERT INTO orders VALUES (10857, '5', 8, '2019-01-28', '2019-02-25', '2019-02-06', 2, 188.850006, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00302', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2819.30);
INSERT INTO orders VALUES (10837, '5', 9, '2019-01-16', '2019-02-13', '2019-01-23', 3, 13.3199997, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00303', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1266.82);
INSERT INTO orders VALUES (10778, '5', 3, '2018-12-16', '2019-01-13', '2018-12-24', 1, 6.78999996, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00304', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 103.29);
INSERT INTO orders VALUES (10733, '5', 1, '2018-11-07', '2018-12-05', '2018-11-10', 3, 110.110001, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00305', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1569.11);
INSERT INTO orders VALUES (10689, '5', 1, '2018-10-01', '2018-10-29', '2018-10-07', 2, 13.4200001, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00306', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 643.17);
INSERT INTO orders VALUES (10672, '5', 9, '2018-09-17', '2018-10-01', '2018-09-26', 2, 95.75, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00307', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4306.15);
INSERT INTO orders VALUES (10654, '5', 5, '2018-09-02', '2018-09-30', '2018-09-11', 1, 55.2599983, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00308', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 723.66);
INSERT INTO orders VALUES (10626, '5', 1, '2018-08-11', '2018-09-08', '2018-08-20', 2, 138.690002, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00309', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1642.29);
INSERT INTO orders VALUES (10572, '5', 3, '2018-06-18', '2018-07-16', '2018-06-25', 2, 116.43, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00310', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1681.78);
INSERT INTO orders VALUES (10524, '5', 1, '2018-05-01', '2018-05-29', '2018-05-07', 2, 244.789993, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00311', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3437.44);
INSERT INTO orders VALUES (10445, '5', 3, '2018-02-13', '2018-03-13', '2018-02-20', 1, 9.30000019, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00312', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 184.20);
INSERT INTO orders VALUES (10444, '5', 3, '2018-02-12', '2018-03-12', '2018-02-21', 3, 3.5, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00313', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1035.20);
INSERT INTO orders VALUES (10384, '5', 3, '2017-12-16', '2018-01-13', '2017-12-20', 3, 168.639999, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00314', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2391.04);
INSERT INTO orders VALUES (10280, '5', 2, '2017-08-14', '2017-09-11', '2017-09-12', 1, 8.97999954, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00315', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 622.18);
INSERT INTO orders VALUES (10278, '5', 8, '2017-08-12', '2017-09-09', '2017-08-16', 2, 92.6900024, 'Berglunds snabbköp', 'Berguvsvägen  8', 'Luleå', NULL, 'S-958 22', 'Sweden', 'ORD-00316', NULL, '65.81902717899396,15.083486501852349', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1581.49);
INSERT INTO orders VALUES (10853, '6', 9, '2019-01-27', '2019-02-24', '2019-02-03', 2, 53.8300018, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00765', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 678.83);
INSERT INTO orders VALUES (10509, '6', 4, '2018-04-17', '2018-05-15', '2018-04-29', 1, 0.150000006, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00768', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 136.95);
INSERT INTO orders VALUES (10501, '6', 9, '2018-04-09', '2018-05-07', '2018-04-16', 3, 8.85000038, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00769', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 157.85);
INSERT INTO orders VALUES (11058, '6', 9, '2019-04-29', '2019-05-27', '2019-08-29', 3, 31.1399994, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', '', '68306', 'Germany', 'ORD-00763', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, 2, '2019-08-29 05:20:50.872284', 'F', 'F', 1, NULL, 889.14);
INSERT INTO orders VALUES (10538, '11', 9, '2018-05-15', '2018-06-12', '2018-05-16', 3, 4.86999989, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00380', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 144.67);
INSERT INTO orders VALUES (10484, '11', 3, '2018-03-24', '2018-04-21', '2018-04-01', 3, 6.88000011, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00381', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 393.08);
INSERT INTO orders VALUES (10471, '11', 2, '2018-03-11', '2018-04-08', '2018-03-18', 3, 45.5900002, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00382', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1373.59);
INSERT INTO orders VALUES (10289, '11', 7, '2017-08-26', '2017-09-23', '2017-08-28', 3, 22.7700005, 'B''s Beverages', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', 'ORD-00383', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 502.17);
INSERT INTO orders VALUES (11023, '11', 1, '2019-04-14', '2019-04-28', '2019-04-24', 2, 123.830002, 'B''s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK', 'ORD-00374', NULL, '51.6123014,-0.11813699999993332', NULL, NULL, 2, '2019-08-29 05:31:36.959713', 'F', 'F', 1, NULL, 1623.83);
INSERT INTO orders VALUES (11076, '9', 4, '2019-05-06', '2019-06-03', '2019-08-28', 2, 38.2799988, 'Bon app''', '12, rue des Bouchers', 'Marseille', '', '13008', 'France', 'ORD-00536', NULL, '43.7270388,-1.0775916000000052', NULL, NULL, 2, '2019-08-28 11:38:22.437309', 'F', 'F', 1, NULL, 1094.53);
INSERT INTO orders VALUES (10970, '8', 9, '2019-03-24', '2019-04-07', '2019-04-24', 1, 16.1599998, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', '', '28023', 'Spain', 'ORD-00525', NULL, '39.4566454,-0.37177220000000943', NULL, NULL, 2, '2019-08-29 05:25:31.671999', 'F', 'F', 1, NULL, 295.96);
INSERT INTO orders VALUES (10651, '86', 8, '2018-09-01', '2018-09-29', '2018-09-11', 2, 20.6000004, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00416', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 550.50);
INSERT INTO orders VALUES (10640, '86', 4, '2018-08-21', '2018-09-18', '2018-08-28', 1, 23.5499992, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00417', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 968.05);
INSERT INTO orders VALUES (10632, '86', 8, '2018-08-14', '2018-09-11', '2018-08-19', 1, 41.3800011, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00418', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 661.28);
INSERT INTO orders VALUES (10513, '86', 7, '2018-04-22', '2018-06-03', '2018-04-28', 1, 105.650002, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00419', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2532.55);
INSERT INTO orders VALUES (10356, '86', 6, '2017-11-18', '2017-12-16', '2017-11-27', 2, 36.7099991, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00420', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1143.11);
INSERT INTO orders VALUES (10348, '86', 4, '2017-11-07', '2017-12-05', '2017-11-15', 2, 0.779999971, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00421', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 396.63);
INSERT INTO orders VALUES (10312, '86', 2, '2017-09-23', '2017-10-21', '2017-10-03', 2, 40.2599983, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00422', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1655.06);
INSERT INTO orders VALUES (10301, '86', 8, '2017-09-09', '2017-10-07', '2017-09-17', 2, 45.0800018, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', 'ORD-00423', NULL, '51.7883917,10.959931200000028', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 800.08);
INSERT INTO orders VALUES (11046, '86', 8, '2019-04-23', '2019-05-21', '2019-04-24', 2, 71.6399994, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany', 'ORD-00414', NULL, '51.7883917,10.959931200000028', NULL, NULL, 2, '2019-08-29 05:43:22.483922', 'F', 'F', 1, NULL, 1635.49);
INSERT INTO orders VALUES (10703, '24', 6, '2018-10-14', '2018-11-11', '2018-10-20', 2, 152.300003, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00173', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2697.30);
INSERT INTO orders VALUES (10561, '24', 2, '2018-06-06', '2018-07-04', '2018-06-09', 2, 242.210007, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00174', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3086.71);
INSERT INTO orders VALUES (10533, '24', 8, '2018-05-12', '2018-06-09', '2018-05-22', 1, 188.039993, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00175', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2483.14);
INSERT INTO orders VALUES (10460, '24', 8, '2018-02-28', '2018-03-28', '2018-03-03', 1, 16.2700005, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00176', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 250.57);
INSERT INTO orders VALUES (10434, '24', 3, '2018-02-03', '2018-03-03', '2018-02-13', 2, 17.9200001, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00177', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 377.77);
INSERT INTO orders VALUES (10378, '24', 5, '2017-12-10', '2018-01-07', '2017-12-19', 3, 5.44000006, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00178', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 108.64);
INSERT INTO orders VALUES (10327, '24', 2, '2017-10-11', '2017-11-08', '2017-10-14', 1, 63.3600006, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00179', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2325.06);
INSERT INTO orders VALUES (10264, '24', 6, '2017-07-24', '2017-08-21', '2017-08-23', 3, 3.67000008, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', 'ORD-00180', NULL, '59.3377819,18.086277699999982', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 728.02);
INSERT INTO orders VALUES (11050, '24', 8, '2019-04-27', '2019-05-25', '2019-05-05', 2, 59.4099998, 'Folk och fä HB', 'Åkergatan 24', 'Bräcke', '', 'S-844 67', 'Sweden', 'ORD-00162', NULL, '59.3377819,18.086277699999982', NULL, NULL, 2, '2019-08-29 05:49:46.217405', 'F', 'F', 1, NULL, 959.31);
INSERT INTO orders VALUES (10787, '41', 2, '2018-12-19', '2019-01-02', '2018-12-26', 1, 249.929993, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00588', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3010.63);
INSERT INTO orders VALUES (10631, '41', 8, '2018-08-14', '2018-09-11', '2018-08-15', 1, 0.870000005, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00589', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 62.77);
INSERT INTO orders VALUES (10610, '41', 8, '2018-07-25', '2018-08-22', '2018-08-06', 1, 26.7800007, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00590', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 425.53);
INSERT INTO orders VALUES (10500, '41', 6, '2018-04-09', '2018-05-07', '2018-04-17', 1, 42.6800003, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00591', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 593.38);
INSERT INTO orders VALUES (10493, '41', 4, '2018-04-02', '2018-04-30', '2018-04-10', 3, 10.6400003, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00592', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 686.34);
INSERT INTO orders VALUES (10454, '41', 4, '2018-02-21', '2018-03-21', '2018-02-25', 3, 2.74000001, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00593', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 416.14);
INSERT INTO orders VALUES (10425, '41', 6, '2018-01-24', '2018-02-21', '2018-02-14', 2, 7.92999983, 'La maison d''Asie', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', 'ORD-00594', NULL, '47.23280099999999,-1.5656478999999308', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 487.43);
INSERT INTO orders VALUES (10639, '70', 7, '2018-08-20', '2018-09-17', '2018-08-27', 3, 38.6399994, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', 'ORD-00696', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 538.64);
INSERT INTO orders VALUES (10685, '31', 4, '2018-09-29', '2018-10-13', '2018-10-03', 2, 33.75, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00747', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 834.85);
INSERT INTO orders VALUES (10694, '63', 8, '2018-10-06', '2018-11-03', '2018-10-09', 3, 398.359985, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00258', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5223.36);
INSERT INTO orders VALUES (10950, '49', 1, '2019-03-16', '2019-04-13', '2019-03-23', 2, 2.5, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy', 'ORD-00274', NULL, '42.7986667,10.360316099999977', NULL, NULL, 2, '2019-08-29 06:26:55.924939', 'F', 'F', 1, NULL, 112.5);
INSERT INTO orders VALUES (10939, '49', 2, '2019-03-10', '2019-04-07', '2019-03-13', 2, 76.3300018, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00275', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 826.03);
INSERT INTO orders VALUES (10818, '49', 7, '2019-01-07', '2019-02-04', '2019-01-12', 3, 65.4800034, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00276', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 898.48);
INSERT INTO orders VALUES (10784, '49', 4, '2018-12-18', '2019-01-15', '2018-12-22', 3, 70.0899963, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00277', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1719.79);
INSERT INTO orders VALUES (10754, '49', 6, '2018-11-25', '2018-12-23', '2018-11-27', 3, 2.38000011, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00278', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 57.58);
INSERT INTO orders VALUES (10635, '49', 8, '2018-08-18', '2018-09-15', '2018-08-21', 3, 47.4599991, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00279', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1427.51);
INSERT INTO orders VALUES (10467, '49', 8, '2018-03-06', '2018-04-03', '2018-03-11', 2, 4.92999983, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00280', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 240.13);
INSERT INTO orders VALUES (10404, '49', 2, '2018-01-03', '2018-01-31', '2018-01-08', 1, 155.970001, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00281', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1830.82);
INSERT INTO orders VALUES (10300, '49', 2, '2017-09-09', '2017-10-07', '2017-09-18', 2, 17.6800003, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00282', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 625.68);
INSERT INTO orders VALUES (10275, '49', 1, '2017-08-07', '2017-09-04', '2017-08-09', 1, 26.9300003, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', NULL, '24100', 'Italy', 'ORD-00283', NULL, '42.7986667,10.360316099999977', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 334.03);
INSERT INTO orders VALUES (10691, '63', 2, '2018-10-03', '2018-11-14', '2018-10-22', 2, 810.049988, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00259', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 10974.85);
INSERT INTO orders VALUES (10658, '63', 4, '2018-09-05', '2018-10-03', '2018-09-08', 1, 364.149994, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00260', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5032.00);
INSERT INTO orders VALUES (10588, '63', 2, '2018-07-03', '2018-07-31', '2018-07-10', 3, 194.669998, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00261', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4094.27);
INSERT INTO orders VALUES (10549, '63', 5, '2018-05-27', '2018-06-10', '2018-05-30', 1, 171.240005, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00262', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4352.29);
INSERT INTO orders VALUES (10540, '63', 3, '2018-05-19', '2018-06-16', '2018-06-13', 3, 1007.64001, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00263', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 11199.34);
INSERT INTO orders VALUES (10527, '63', 7, '2018-05-05', '2018-06-02', '2018-05-07', 1, 41.9000015, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00264', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1711.70);
INSERT INTO orders VALUES (10515, '63', 2, '2018-04-23', '2018-05-07', '2018-05-23', 1, 204.470001, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00265', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 10792.52);
INSERT INTO orders VALUES (10451, '63', 4, '2018-02-19', '2018-03-05', '2018-03-12', 3, 189.089996, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00266', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4466.09);
INSERT INTO orders VALUES (11069, '80', 1, '2019-05-04', '2019-06-01', '2019-05-06', 2, 15.6700001, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', '', '05033', 'Mexico', 'ORD-00284', NULL, '20.1236882,-104.34118189999998', NULL, NULL, 2, '2019-08-29 07:19:24.825289', 'F', 'F', 1, NULL, 375.67);
INSERT INTO orders VALUES (10915, '80', 2, '2019-02-27', '2019-03-27', '2019-03-02', 2, 3.50999999, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00285', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 543.01);
INSERT INTO orders VALUES (10418, '63', 4, '2018-01-17', '2018-02-14', '2018-01-24', 1, 17.5499992, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00267', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1832.35);
INSERT INTO orders VALUES (10361, '63', 1, '2017-11-22', '2017-12-20', '2017-12-03', 2, 183.169998, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00268', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2456.57);
INSERT INTO orders VALUES (10345, '63', 2, '2017-11-04', '2017-12-02', '2017-11-11', 2, 249.059998, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00269', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3173.86);
INSERT INTO orders VALUES (10313, '63', 2, '2017-09-24', '2017-10-22', '2017-10-04', 2, 1.96000004, 'QUICK-Stop', 'Taucherstraße 10', 'Cunewalde', NULL, '01307', 'Germany', 'ORD-00270', NULL, '52.5272829,13.3048493', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 184.36);
INSERT INTO orders VALUES (10842, '80', 1, '2019-01-20', '2019-02-17', '2019-01-29', 3, 54.4199982, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00286', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1029.42);
INSERT INTO orders VALUES (10676, '80', 2, '2018-09-22', '2018-10-20', '2018-09-29', 2, 2.00999999, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00287', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 536.86);
INSERT INTO orders VALUES (10576, '80', 3, '2018-06-23', '2018-07-07', '2018-06-30', 3, 18.5599995, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00288', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 857.01);
INSERT INTO orders VALUES (10518, '80', 4, '2018-04-25', '2018-05-09', '2018-05-05', 2, 218.149994, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00289', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 4368.20);
INSERT INTO orders VALUES (10319, '80', 7, '2017-10-02', '2017-10-30', '2017-10-11', 3, 64.5, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00290', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1255.70);
INSERT INTO orders VALUES (10304, '80', 1, '2017-09-12', '2017-10-10', '2017-09-17', 2, 63.7900009, 'Tortuga Restaurante', 'Avda. Azteca 123', 'México D.F.', NULL, '05033', 'Mexico', 'ORD-00291', NULL, '20.1236882,-104.34118189999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1018.19);
INSERT INTO orders VALUES (11060, '27', 2, '2019-04-30', '2019-05-28', '2019-05-04', 2, 10.9799995, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy', 'ORD-00735', NULL, '45.1872253,9.172592500000064', NULL, NULL, 2, '2019-08-29 05:51:48.12772', 'F', 'F', 1, NULL, 276.98);
INSERT INTO orders VALUES (11026, '27', 4, '2019-04-15', '2019-05-13', '2019-04-28', 1, 47.0900002, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', 'ORD-00736', NULL, '45.1872253,9.172592500000064', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1077.09);
INSERT INTO orders VALUES (10807, '27', 4, '2018-12-31', '2019-01-28', '2019-01-30', 1, 1.36000001, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', 'ORD-00737', NULL, '45.1872253,9.172592500000064', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 19.76);
INSERT INTO orders VALUES (10753, '27', 3, '2018-11-25', '2018-12-23', '2018-11-27', 1, 7.69999981, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', 'ORD-00738', NULL, '45.1872253,9.172592500000064', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 95.70);
INSERT INTO orders VALUES (10710, '27', 1, '2018-10-20', '2018-11-17', '2018-10-23', 1, 4.98000002, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', 'ORD-00739', NULL, '45.1872253,9.172592500000064', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 98.48);
INSERT INTO orders VALUES (10422, '27', 2, '2018-01-22', '2018-02-19', '2018-01-31', 1, 3.01999998, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', NULL, '10100', 'Italy', 'ORD-00740', NULL, '45.1872253,9.172592500000064', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 52.82);
INSERT INTO orders VALUES (10600, '36', 4, '2018-07-16', '2018-08-13', '2018-07-21', 1, 45.1300011, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', 'ORD-00689', NULL, '42.2860502,-71.23570389999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 524.93);
INSERT INTO orders VALUES (10415, '36', 3, '2018-01-15', '2018-02-12', '2018-01-24', 1, 0.200000003, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', 'ORD-00690', NULL, '42.2860502,-71.23570389999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 102.60);
INSERT INTO orders VALUES (10394, '36', 1, '2017-12-25', '2018-01-22', '2018-01-03', 3, 30.3400002, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', 'ORD-00691', NULL, '42.2860502,-71.23570389999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 472.34);
INSERT INTO orders VALUES (10375, '36', 3, '2017-12-06', '2018-01-03', '2017-12-09', 2, 20.1200008, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', 'ORD-00692', NULL, '42.2860502,-71.23570389999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 358.12);
INSERT INTO orders VALUES (11039, '47', 1, '2019-04-21', '2019-05-19', '2019-08-29', 2, 65, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00713', NULL, '10.9571369,-63.84710659999996', NULL, NULL, 2, '2019-08-29 06:24:33.789648', 'F', 'F', 1, NULL, 3155);
INSERT INTO orders VALUES (11014, '47', 2, '2019-04-10', '2019-05-08', '2019-04-15', 3, 23.6000004, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00714', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 293.70);
INSERT INTO orders VALUES (10954, '47', 5, '2019-03-17', '2019-04-28', '2019-03-20', 1, 27.9099998, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00715', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1929.56);
INSERT INTO orders VALUES (10919, '47', 2, '2019-03-02', '2019-03-30', '2019-03-04', 2, 19.7999992, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00716', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1142.60);
INSERT INTO orders VALUES (10959, '31', 6, '2019-03-18', '2019-04-29', '2019-03-23', 2, 4.98000002, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00742', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 159.83);
INSERT INTO orders VALUES (10840, '47', 4, '2019-01-19', '2019-03-02', '2019-02-16', 2, 2.71000004, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00717', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 266.31);
INSERT INTO orders VALUES (11045, '10', 6, '2019-04-23', '2019-05-21', NULL, 2, 70.5800018, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', 'ORD-00700', NULL, '38.5022232,-122.9980835', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1380.08);
INSERT INTO orders VALUES (10763, '23', 3, '2018-12-03', '2018-12-31', '2018-12-08', 3, 37.3499985, 'Folies gourmandes', '184, chaussée de Tournai', 'Lille', NULL, '59000', 'France', 'ORD-00726', NULL, '45.8378452,1.4911098000000038', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 653.35);
INSERT INTO orders VALUES (10634, '23', 4, '2018-08-15', '2018-09-12', '2018-08-21', 3, 487.380005, 'Folies gourmandes', '184, chaussée de Tournai', 'Lille', NULL, '59000', 'France', 'ORD-00727', NULL, '45.8378452,1.4911098000000038', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 5472.88);
INSERT INTO orders VALUES (10480, '23', 6, '2018-03-20', '2018-04-17', '2018-03-24', 2, 1.35000002, 'Folies gourmandes', '184, chaussée de Tournai', 'Lille', NULL, '59000', 'France', 'ORD-00728', NULL, '45.8378452,1.4911098000000038', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 757.35);
INSERT INTO orders VALUES (10408, '23', 8, '2018-01-08', '2018-02-05', '2018-01-14', 1, 11.2600002, 'Folies gourmandes', '184, chaussée de Tournai', 'Lille', NULL, '59000', 'France', 'ORD-00729', NULL, '45.8378452,1.4911098000000038', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1633.66);
INSERT INTO orders VALUES (10789, '23', 1, '2018-12-22', '2019-01-19', '2018-12-31', 2, 100.599998, 'Folies gourmandes', '184, chaussée de Tournai', 'Lille', '', '59000', 'France', 'ORD-00725', NULL, '45.8378452,1.4911098000000038', NULL, NULL, 2, '2019-08-28 11:43:58.483875', 'F', 'F', 1, NULL, 3787.6);
INSERT INTO orders VALUES (10838, '47', 3, '2019-01-19', '2019-02-16', '2019-01-23', 3, 59.2799988, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00718', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2643.03);
INSERT INTO orders VALUES (10811, '47', 8, '2019-01-02', '2019-01-30', '2019-01-08', 1, 31.2199993, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', 'ORD-00719', NULL, '10.9571369,-63.84710659999996', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 883.22);
INSERT INTO orders VALUES (10909, '70', 1, '2019-02-26', '2019-03-26', '2019-03-10', 2, 53.0499992, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', 'ORD-00694', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 723.05);
INSERT INTO orders VALUES (10831, '70', 3, '2019-01-14', '2019-02-11', '2019-01-23', 2, 72.1900024, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', 'ORD-00695', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 2756.59);
INSERT INTO orders VALUES (10520, '70', 7, '2018-04-29', '2018-05-27', '2018-05-01', 1, 13.3699999, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', 'ORD-00697', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 213.37);
INSERT INTO orders VALUES (10387, '70', 1, '2017-12-18', '2018-01-15', '2017-12-20', 2, 93.6299973, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', NULL, '4110', 'Norway', 'ORD-00698', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1152.03);
INSERT INTO orders VALUES (11015, '70', 2, '2019-04-10', '2019-04-24', '2019-04-20', 2, 4.61999989, 'Santé Gourmet', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway', 'ORD-00693', NULL, '58.76545059999999,5.853168800000049', NULL, NULL, 2, '2019-08-29 06:58:21.781338', 'F', 'F', 1, NULL, 626.97);
INSERT INTO orders VALUES (10898, '54', 4, '2019-02-20', '2019-03-20', '2019-03-06', 2, 1.26999998, 'Océano Atlántico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00732', NULL, '-34.7977576,-58.484311400000024', NULL, NULL, 2, '2019-08-27 11:29:50.771078', 'F', 'F', 1, NULL, 31.27);
INSERT INTO orders VALUES (10531, '54', 7, '2018-05-08', '2018-06-05', '2018-05-19', 1, 8.11999989, 'Océano Atlántico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00733', NULL, '-34.7818764,-58.83877110000003', NULL, NULL, 2, '2019-08-27 11:33:07.956207', 'F', 'F', 1, NULL, 118.12);
INSERT INTO orders VALUES (10409, '54', 3, '2018-01-09', '2018-02-06', '2018-01-14', 1, 29.8299999, 'Océano Atlántico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00734', NULL, '-34.7818764,-58.83877110000003', NULL, NULL, 2, '2019-08-27 11:37:27.517248', 'F', 'F', 1, NULL, 349.03);
INSERT INTO orders VALUES (11057, '53', 3, '2019-04-29', '2019-05-27', '2019-05-01', 3, 4.13000011, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK', 'ORD-00770', NULL, '53.820142,-1.5767510000000584', NULL, NULL, 2, '2019-08-29 06:32:02.514184', 'F', 'F', 1, NULL, 49.13);
INSERT INTO orders VALUES (11061, '32', 4, '2019-04-30', '2019-06-11', '2019-08-29', 3, 14.0100002, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00779', NULL, '45.1463552,-87.61650960000003', NULL, NULL, 2, '2019-08-29 06:00:06.118161', 'F', 'F', 1, NULL, 524.01);
INSERT INTO orders VALUES (11040, '32', 4, '2019-04-22', '2019-05-20', NULL, 3, 18.8400002, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00780', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 218.84);
INSERT INTO orders VALUES (10822, '82', 6, '2019-01-08', '2019-02-05', '2019-01-16', 3, 7, 'Trail''s Head Gourmet Provisioners', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA', 'ORD-00797', NULL, '35.44047990000001,-97.7588596', NULL, NULL, 2, '2019-08-29 07:20:58.199106', 'F', 'F', 1, NULL, 244.9);
INSERT INTO orders VALUES (10577, '82', 9, '2018-06-23', '2018-08-04', '2018-06-30', 2, 25.4099998, 'Trail''s Head Gourmet Provisioners', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA', 'ORD-00798', NULL, '35.4403935,-97.7583813', NULL, NULL, 2, '2019-08-29 07:21:09.34386', 'F', 'F', 1, NULL, 594.41);
INSERT INTO orders VALUES (10574, '82', 4, '2018-06-19', '2018-07-17', '2018-06-30', 2, 37.5999985, 'Trail''s Head Gourmet Provisioners', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA', 'ORD-00799', NULL, '35.4403935,-97.7583813', NULL, NULL, 2, '2019-08-29 07:21:20.592626', 'F', 'F', 1, NULL, 801.9);
INSERT INTO orders VALUES (10936, '32', 3, '2019-03-09', '2019-04-06', '2019-03-18', 2, 33.6800003, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00782', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 603.48);
INSERT INTO orders VALUES (10816, '32', 4, '2019-01-06', '2019-02-03', '2019-02-04', 2, 719.780029, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', 'ORD-00783', NULL, '45.1463552,-87.61650960000003', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 9610.68);
INSERT INTO orders VALUES (10482, '43', 1, '2018-03-21', '2018-04-18', '2018-04-10', 3, 7.48000002, 'Lazy K Kountry Store', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', 'USA', 'ORD-00759', NULL, '34.8094114,-83.04852799999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 154.48);
INSERT INTO orders VALUES (10545, '43', 8, '2018-05-22', '2018-06-19', '2018-06-26', 2, 11.9200001, 'Lazy K Kountry Store', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', 'USA', 'ORD-00758', NULL, '34.8094114,-83.04852799999998', NULL, NULL, 2, '2019-08-29 06:18:44.690113', 'F', 'F', 1, NULL, 221.92);
INSERT INTO orders VALUES (10752, '53', 2, '2018-11-24', '2018-12-22', '2018-11-28', 3, 1.38999999, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK', 'ORD-00771', NULL, '53.820142,-1.5767510000000584', NULL, NULL, 2, '2019-08-29 06:32:16.119386', 'F', 'F', 1, NULL, 253.39);
INSERT INTO orders VALUES (10884, '45', 4, '2019-02-12', '2019-03-12', '2019-02-13', 2, 90.9700012, 'Let''s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', 'ORD-00800', NULL, '33.2333043,-92.67414659999997', NULL, NULL, 2, '2019-08-29 06:21:08.218865', 'F', 'F', 1, NULL, 1541.42);
INSERT INTO orders VALUES (10819, '12', 2, '2019-01-07', '2019-02-04', '2019-01-16', 3, 19.7600002, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00776', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-08-27 11:31:06.549228', 'F', 'F', 1, NULL, 496.76);
INSERT INTO orders VALUES (10828, '64', 9, '2019-01-13', '2019-01-27', '2019-02-04', 1, 90.8499985, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00755', NULL, '-34.37643680000001,-59.11336510000001', NULL, NULL, 2, '2019-08-27 11:30:13.810029', 'F', 'F', 1, NULL, 1022.85);
INSERT INTO orders VALUES (10777, '31', 7, '2018-12-15', '2018-12-29', '2019-01-21', 2, 3.00999999, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00744', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 282.81);
INSERT INTO orders VALUES (10734, '31', 2, '2018-11-07', '2018-12-05', '2018-11-12', 3, 1.63, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00745', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1499.98);
INSERT INTO orders VALUES (10709, '31', 1, '2018-10-17', '2018-11-14', '2018-11-20', 3, 210.800003, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00746', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 3634.80);
INSERT INTO orders VALUES (10652, '31', 4, '2018-09-01', '2018-09-29', '2018-09-08', 2, 7.13999987, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00748', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 338.67);
INSERT INTO orders VALUES (10423, '31', 6, '2018-01-23', '2018-02-06', '2018-02-24', 3, 24.5, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', 'ORD-00749', NULL, '-11.43836,-61.44469099999998', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1044.50);
INSERT INTO orders VALUES (10735, '45', 6, '2018-11-10', '2018-12-08', '2018-11-21', 2, 45.9700012, 'Let''s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', 'ORD-00801', NULL, '33.2333043,-92.67414659999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 641.77);
INSERT INTO orders VALUES (10620, '42', 2, '2018-08-05', '2018-09-02', '2018-08-14', 3, 0.939999998, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada', 'ORD-00761', NULL, '49.43327346597815,-94.0286346239426', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 58.44);
INSERT INTO orders VALUES (10495, '42', 3, '2018-04-03', '2018-05-01', '2018-04-11', 3, 4.6500001, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada', 'ORD-00762', NULL, '49.43327346597815,-94.0286346239426', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 282.65);
INSERT INTO orders VALUES (10810, '42', 2, '2019-01-01', '2019-01-29', '2019-01-07', 3, 4.32999992, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada', 'ORD-00760', NULL, '49.43327346597815,-94.0286346239426', NULL, NULL, 2, '2019-08-28 11:18:16.288146', 'F', 'F', 1, NULL, 191.33);
INSERT INTO orders VALUES (10956, '6', 6, '2019-03-17', '2019-04-28', '2019-03-20', 2, 44.6500015, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00764', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 721.65);
INSERT INTO orders VALUES (10614, '6', 8, '2018-07-29', '2018-08-26', '2018-08-01', 3, 1.92999995, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00766', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 465.93);
INSERT INTO orders VALUES (10582, '6', 3, '2018-06-27', '2018-07-25', '2018-07-14', 2, 27.7099991, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', 'ORD-00767', NULL, '51.76354088251069,10.868423945368932', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 357.71);
INSERT INTO orders VALUES (10462, '16', 2, '2018-03-03', '2018-03-31', '2018-03-18', 1, 6.17000008, 'Consolidated Holdings', 'Berkeley Gardens 12  Brewery', 'London', NULL, 'WX1 6LT', 'UK', 'ORD-00751', NULL, '51.547089915410425,0.6284332644180495', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 162.17);
INSERT INTO orders VALUES (10435, '16', 8, '2018-02-04', '2018-03-18', '2018-02-07', 2, 9.21000004, 'Consolidated Holdings', 'Berkeley Gardens 12  Brewery', 'London', NULL, 'WX1 6LT', 'UK', 'ORD-00752', NULL, '51.547089915410425,0.6284332644180495', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 640.81);
INSERT INTO orders VALUES (10848, '16', 7, '2019-01-23', '2019-02-20', '2019-01-29', 2, 38.2400017, 'Consolidated Holdings', 'Berkeley Gardens 12  Brewery', 'London', '', 'WX1 6LT', 'UK', 'ORD-00750', NULL, '51.547089915410425,0.6284332644180495', NULL, NULL, 2, '2019-08-29 05:41:10.906842', 'F', 'F', 1, NULL, 969.74);
INSERT INTO orders VALUES (10517, '53', 3, '2018-04-24', '2018-05-22', '2018-04-29', 3, 32.0699997, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK', 'ORD-00772', NULL, '53.820142,-1.5767510000000584', NULL, NULL, 2, '2019-08-29 06:32:28.994317', 'F', 'F', 1, NULL, 384.07);
INSERT INTO orders VALUES (10916, '64', 1, '2019-02-27', '2019-03-27', '2019-03-09', 2, 63.7700005, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00754', NULL, '-34.37643680000001,-59.11336510000001', NULL, NULL, 2, '2019-08-27 11:29:21.090609', 'F', 'F', 1, NULL, 750.47);
INSERT INTO orders VALUES (10782, '12', 9, '2018-12-17', '2019-01-14', '2018-12-22', 3, 1.10000002, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00777', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-08-27 11:32:28.962811', 'F', 'F', 1, NULL, 13.60);
INSERT INTO orders VALUES (10448, '64', 4, '2018-02-17', '2018-03-17', '2018-02-24', 2, 38.8199997, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00757', NULL, '-34.37643680000001,-59.11336510000001', NULL, NULL, 2, '2019-08-27 11:36:44.732511', 'F', 'F', 1, NULL, 482.22);
INSERT INTO orders VALUES (11004, '50', 3, '2019-04-07', '2019-05-05', '2019-04-20', 1, 44.8400002, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium', 'ORD-00790', NULL, '50.8029276,4.436011600000029', NULL, NULL, 2, '2019-08-28 04:34:46.240349', 'F', 'F', 1, NULL, 340.22);
INSERT INTO orders VALUES (10952, '1', 1, '2019-03-16', '2019-04-27', '2019-03-24', 1, 40.4199982, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', 'ORD-00815', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 531.57);
INSERT INTO orders VALUES (10910, '90', 1, '2019-02-26', '2019-03-26', '2019-03-04', 3, 38.1100006, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00805', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 491.01);
INSERT INTO orders VALUES (10879, '90', 3, '2019-02-10', '2019-03-10', '2019-02-12', 3, 8.5, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00806', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 619.80);
INSERT INTO orders VALUES (10873, '90', 4, '2019-02-06', '2019-03-06', '2019-02-09', 1, 0.819999993, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00807', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 337.62);
INSERT INTO orders VALUES (10695, '90', 7, '2018-10-07', '2018-11-18', '2018-10-14', 1, 16.7199993, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00808', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 658.72);
INSERT INTO orders VALUES (10673, '90', 2, '2018-09-18', '2018-10-16', '2018-09-19', 1, 22.7600002, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00809', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 435.11);
INSERT INTO orders VALUES (10615, '90', 2, '2018-07-30', '2018-08-27', '2018-08-06', 3, 0.75, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', NULL, '21240', 'Finland', 'ORD-00810', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 120.75);
INSERT INTO orders VALUES (11005, '90', 2, '2019-04-07', '2019-05-05', '2019-04-10', 1, 0.75, 'Wilman Kala', 'Keskuskatu 45', 'Helsinki', '', '21240', 'Finland', 'ORD-00804', NULL, '60.45415964530057,22.2808487030411', NULL, NULL, 2, '2019-08-28 11:34:14.423278', 'F', 'F', 1, NULL, 586.75);
INSERT INTO orders VALUES (10835, '1', 1, '2019-01-15', '2019-02-12', '2019-01-21', 3, 69.5299988, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', 'ORD-00816', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 920.33);
INSERT INTO orders VALUES (10971, '26', 2, '2019-03-24', '2019-04-21', '2019-04-02', 2, 121.82, 'France restauration', '54, rue Royale', 'Nantes', '', '44000', 'France', 'ORD-00820', NULL, '48.8889585,2.333229899999992', NULL, NULL, 2, '2019-08-28 11:45:13.44612', 'F', 'F', 1, NULL, 1854.88);
INSERT INTO orders VALUES (10702, '1', 4, '2018-10-13', '2018-11-24', '2018-10-21', 1, 23.9400005, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', 'ORD-00817', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 353.94);
INSERT INTO orders VALUES (10719, '45', 8, '2018-10-27', '2018-11-24', '2018-11-05', 2, 51.4399986, 'Let''s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', 'ORD-00802', NULL, '33.2333043,-92.67414659999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1176.36);
INSERT INTO orders VALUES (10579, '45', 1, '2018-06-25', '2018-07-23', '2018-07-04', 2, 13.7299995, 'Let''s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', 'ORD-00803', NULL, '33.2333043,-92.67414659999997', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 331.48);
INSERT INTO orders VALUES (11003, '78', 3, '2019-04-06', '2019-05-04', '2019-04-08', 3, 14.9099998, 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA', 'ORD-00811', NULL, '39.17054,-119.764249', NULL, NULL, 2, '2019-08-29 07:16:50.782117', 'F', 'F', 1, NULL, 340.91);
INSERT INTO orders VALUES (10775, '78', 7, '2018-12-12', '2019-01-09', '2018-12-26', 1, 20.25, 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA', 'ORD-00812', NULL, '39.1705405,-119.7641683', NULL, NULL, 2, '2019-08-29 07:17:02.0213', 'F', 'F', 1, NULL, 248.25);
INSERT INTO orders VALUES (10624, '78', 4, '2018-08-07', '2018-09-04', '2018-08-19', 2, 94.8000031, 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA', 'ORD-00813', NULL, '39.1705405,-119.7641683', NULL, NULL, 2, '2019-08-29 07:17:13.34918', 'F', 'F', 1, NULL, 1488.04);
INSERT INTO orders VALUES (11054, '12', 8, '2019-04-28', '2019-05-27', '2019-08-27', 1, 0.330000013, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00773', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-10-05 17:38:49.740302', 'F', 'F', 1, NULL, 0.33);
INSERT INTO orders VALUES (10692, '1', 4, '2018-10-03', '2018-10-31', '2018-10-13', 2, 61.0200005, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', 'ORD-00818', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 939.02);
INSERT INTO orders VALUES (10643, '1', 6, '2018-08-25', '2018-09-22', '2018-09-02', 1, 29.4599991, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', 'ORD-00819', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL, 1114.71);
INSERT INTO orders VALUES (11011, '1', 3, '2019-04-09', '2019-05-07', '2019-04-13', 1, 1.21000004, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany', 'ORD-00814', NULL, '52.48972389999999,13.359195699999987', NULL, NULL, 2, '2019-08-29 05:03:49.748107', 'F', 'F', 1, NULL, 961.16);
INSERT INTO orders VALUES (10881, '12', 4, '2019-02-11', '2019-03-11', '2019-02-18', 1, 2.83999991, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', 'ORD-00775', NULL, '-34.8200921,-58.64443030000001', NULL, NULL, 2, '2019-10-05 18:21:40.430941', 'F', 'F', 1, NULL, 2.84);

--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

 INSERT INTO products VALUES (82, 'Biscuits', 31, 9, '15', 20, 800, 200, 100, 0, 2, '2019-08-21 04:14:39.592258', NULL, NULL, 'F', 'F', 6, NULL);
INSERT INTO products VALUES (1, 'Chai', 8, 1, '10 boxes x 30 bags', 18, 39, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (2, 'Chang', 1, 1, '24 - 12 oz bottles', 19, 17, 40, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10, 13, 70, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (85, 'Palada', 30, 9, 'Ltr', 150, 250, 200, 20, 0, 2, '2019-09-17 09:17:32.981051', NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (83, 'Coffee', 31, 1, 'Kg', 25, 100, 20, 50, 0, 2, '2019-08-26 09:03:30.836998', 2, '2019-10-05 06:35:58.617153', 'F', 'F', 6, NULL);
INSERT INTO products VALUES (79, 'Gulabjamun', 3, 9, '4', 7, 78, 7, 77, 0, 2, '2019-08-12 05:19:21.988365', 2, '2019-10-05 06:37:46.777769', 'F', 'F', 6, NULL);
INSERT INTO products VALUES (53, 'Perth Pasties', 24, 6, '48 pieces', 32.7999992, 500, 400, 100, 1, NULL, NULL, 2, '2019-08-22 09:25:27.830317', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (29, 'Thüringer Rostbratwurst', 12, 6, '50 bags x 30 sausgs.', 123.790001, 750, 500, 250, 1, NULL, NULL, 2, '2019-08-22 09:26:25.714726', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (37, 'Gravad lax', 17, 8, '12 - 500 g pkgs.', 26, 100, 50, 25, 0, NULL, NULL, 2, '2019-08-27 05:18:17.633068', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (5, 'Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.3500004, 200, 10, 75, 0, NULL, NULL, 2, '2019-08-22 09:18:23.970249', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (17, 'Alice Mutton', 7, 6, '20 - 1 kg tins', 39, 200, 150, 50, 0, NULL, NULL, 2, '2019-08-22 09:19:09.376515', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (4, 'Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22, 53, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (30, 'Nord-Ost Matjeshering', 13, 8, '10 - 200 g glasses', 25.8899994, 10, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (31, 'Gorgonzola Telino', 14, 4, '12 - 100 g pkgs', 12.5, 0, 70, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (32, 'Mascarpone Fabioli', 14, 4, '24 - 200 g pkgs.', 32, 9, 40, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (33, 'Geitost', 15, 4, '500 g', 2.5, 112, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (34, 'Sasquatch Ale', 16, 1, '24 - 12 oz bottles', 14, 111, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (35, 'Steeleye Stout', 16, 1, '24 - 12 oz bottles', 18, 20, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (36, 'Inlagd Sill', 17, 8, '24 - 250 g  jars', 19, 112, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (38, 'Côte de Blaye', 18, 1, '12 - 75 cl bottles', 263.5, 17, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (40, 'Boston Crab Meat', 19, 8, '24 - 4 oz tins', 18.3999996, 123, 0, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (41, 'Jack''s New England Clam Chowder', 19, 8, '12 - 12 oz cans', 9.64999962, 85, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (42, 'Singaporean Hokkien Fried Mee', 20, 5, '32 - 1 kg pkgs.', 14, 26, 0, 0, 1, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (43, 'Ipoh Coffee', 20, 1, '16 - 500 g tins', 46, 17, 10, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (44, 'Gula Malacca', 20, 2, '20 - 2 kg bags', 19.4500008, 27, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (45, 'Rogede sild', 21, 8, '1k pkg.', 9.5, 5, 70, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (47, 'Zaanse koeken', 22, 3, '10 - 4 oz boxes', 9.5, 36, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (48, 'Chocolade', 22, 3, '10 pkgs.', 12.75, 15, 70, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (49, 'Maxilaku', 23, 3, '24 - 50 g pkgs.', 20, 10, 60, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (50, 'Valkoinen suklaa', 23, 3, '12 - 100 g bars', 16.25, 65, 0, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (51, 'Manjimup Dried Apples', 24, 7, '50 - 300 g pkgs.', 53, 20, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (52, 'Filo Mix', 24, 5, '16 - 2 kg boxes', 7, 38, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (54, 'Tourtière', 25, 6, '16 pies', 7.44999981, 21, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (55, 'Pâté chinois', 25, 6, '24 boxes x 2 pies', 24, 115, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (56, 'Gnocchi di nonna Alice', 26, 5, '24 - 250 g pkgs.', 38, 21, 10, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (57, 'Ravioli Angelo', 26, 5, '24 - 250 g pkgs.', 19.5, 36, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (58, 'Escargots de Bourgogne', 27, 8, '24 pieces', 13.25, 62, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (59, 'Raclette Courdavault', 28, 4, '5 kg pkg.', 55, 79, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (60, 'Camembert Pierrot', 28, 4, '15 - 300 g rounds', 34, 19, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (61, 'Sirop d''érable', 29, 2, '24 - 500 ml bottles', 28.5, 113, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (62, 'Tarte au sucre', 29, 3, '48 pies', 49.2999992, 17, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (63, 'Vegie-spread', 7, 2, '15 - 625 g jars', 43.9000015, 24, 0, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (64, 'Wimmers gute Semmelknödel', 12, 5, '20 bags x 4 pieces', 33.25, 22, 80, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (65, 'Louisiana Fiery Hot Pepper Sauce', 2, 2, '32 - 8 oz bottles', 21.0499992, 76, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (66, 'Louisiana Hot Spiced Okra', 2, 2, '24 - 8 oz jars', 17, 4, 100, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (67, 'Laughing Lumberjack Lager', 16, 1, '24 - 12 oz bottles', 14, 52, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (68, 'Scottish Longbreads', 8, 3, '10 boxes x 8 pieces', 12.5, 6, 10, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (39, 'Chartreuse verte', 18, 1, '750 cc per bottle', 18, 10000, 0, 200, 0, NULL, NULL, 2, '2019-08-22 11:44:50.998088', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (69, 'Gudbrandsdalsost', 15, 4, '10 kg pkg.', 36, 500, 0, 150, 0, NULL, NULL, 2, '2019-08-22 11:45:25.92393', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (46, 'Spegesild', 21, 8, '4 - 450 g glasses', 12, 2000, 0, 200, 0, NULL, NULL, 2, '2019-08-22 11:46:06.894699', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97, 29, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (84, 'Hot chocolate', 30, 1, 'ltr', 25, 15, 20, 5, 0, 2, '2019-08-29 11:30:20.647043', 2, '2019-10-06 04:38:24.153001', 'F', 'F', 6, NULL);
INSERT INTO products VALUES (78, 'Peda', 4, 9, '10', 5, 700, 12, 50, 0, 2, '2019-08-12 05:18:29.40457', NULL, NULL, 'F', 'F', 6, NULL);
INSERT INTO products VALUES (80, 'Jilebi', 3, 9, '47', 111, 150, 11, 111, 0, 2, '2019-08-12 05:31:16.80523', NULL, NULL, 'F', 'F', 6, NULL);
INSERT INTO products VALUES (81, 'Bottle', 3, 3, '10', 50, 32, 22, 15, 0, 2, '2019-08-12 05:38:30.28149', NULL, NULL, 'F', 'F', 6, NULL);
INSERT INTO products VALUES (70, 'Outback Lager', 7, 1, '24 - 355 ml bottles', 15, 15, 10, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (71, 'Flotemysost', 15, 4, '10 - 500 g pkgs.', 21.5, 26, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (72, 'Mozzarella di Giovanni', 14, 4, '24 - 200 g pkgs.', 34.7999992, 14, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (73, 'Röd Kaviar', 17, 8, '24 - 150 g jars', 15, 101, 0, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (75, 'Rhönbräu Klosterbier', 12, 1, '24 - 0.5 l bottles', 7.75, 125, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (76, 'Lakkalikööri', 23, 1, '500 ml', 18, 57, 0, 20, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (77, 'Original Frankfurter grüne Soße', 12, 2, '12 boxes', 13, 32, 0, 15, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (74, 'Longlife Tofu', 4, 7, '5 kg pkg.', 10, 4, 20, 30, 0, NULL, NULL, 2, '2019-08-27 05:17:27.161996', 'F', 'F', 1, NULL);
INSERT INTO products VALUES (6, 'Grandma''s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25, 120, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (7, 'Uncle Bob''s Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30, 15, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (10, 'Ikura', 4, 8, '12 - 200 ml jars', 31, 31, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21, 22, 30, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38, 86, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (13, 'Konbu', 6, 8, '2 kg box', 6, 24, 0, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (14, 'Tofu', 6, 7, '40 - 100 g pkgs.', 23.25, 35, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (15, 'Genen Shouyu', 6, 2, '24 - 250 ml bottles', 13, 39, 0, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (16, 'Pavlova', 7, 3, '32 - 500 g boxes', 17.4500008, 29, 0, 10, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (18, 'Carnarvon Tigers', 7, 8, '16 kg pkg.', 62.5, 42, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (19, 'Teatime Chocolate Biscuits', 8, 3, '10 boxes x 12 pieces', 9.19999981, 25, 0, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (20, 'Sir Rodney''s Marmalade', 8, 3, '30 gift boxes', 81, 40, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (21, 'Sir Rodney''s Scones', 8, 3, '24 pkgs. x 4 pieces', 10, 3, 40, 5, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (22, 'Gustaf''s Knäckebröd', 9, 5, '24 - 500 g pkgs.', 21, 104, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (23, 'Tunnbröd', 9, 5, '12 - 250 g pkgs.', 9, 61, 0, 25, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (24, 'Guaraná Fantástica', 10, 1, '12 - 355 ml cans', 4.5, 20, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (25, 'NuNuCa Nuß-Nougat-Creme', 11, 3, '20 - 450 g glasses', 14, 76, 0, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (26, 'Gumbär Gummibärchen', 11, 3, '100 - 250 g bags', 31.2299995, 15, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (27, 'Schoggi Schokolade', 11, 3, '100 - 100 g pieces', 43.9000015, 49, 0, 30, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (28, 'Rössle Sauerkraut', 12, 7, '25 - 825 g cans', 45.5999985, 26, 0, 0, 0, NULL, NULL, NULL, NULL, 'F', 'F', 1, NULL);
INSERT INTO products VALUES (8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40, 6, 0, 15, 0, NULL, NULL, 2, '2019-08-27 05:44:17.080748', 'F', 'F', 1, NULL);
 

--
-- Data for Name: shippers; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO shippers VALUES (1, 'Speedy Express', '(503) 555-9831', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (2, 'United Package', '(503) 555-3199', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (3, 'Federal Shipping', '(503) 555-9931', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (4, 'Alliance Shippers', '1-800-222-0451', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (5, 'UPS', '1-800-782-7892', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (6, 'DHL', '1-800-225-5345', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO shippers VALUES (8, 'Kalyan', '25846931', 2, '2019-08-08 08:55:53.375064', NULL, NULL, 'F', 'F', 6);
INSERT INTO shippers VALUES (9, 'Cochin Frozen Food Exports Pvt. Ltd.', '0484 232 7735', 2, '2019-08-19 04:20:31.589759', NULL, NULL, 'F', 'F', 6);
INSERT INTO shippers VALUES (10, 'Mathewsons', 'Mathewsons', 2, '2019-08-19 04:21:10.655656', NULL, NULL, 'F', 'F', 6);
INSERT INTO shippers VALUES (7, 'ABCD', '232343434535', 2, '2019-08-08 08:47:20.998839', 2, '2019-08-08 09:02:34.284984', 'F', 'F', 6);
 
--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: -
--
  INSERT INTO suppliers VALUES (31, 'Thomson Trading Agencies', 'Mr. Thomas', 'Managing Director', 'Door No. 123, 124 & 125, Mullassery Canal Road ', 'Kochi', 'South', '682035', 'India', '9388615532 ', '3046100-103', '', 2, '2019-08-19 04:25:45.558546', NULL, NULL, 'F', 'F', 6);
INSERT INTO suppliers VALUES (30, 'Kalyan', 'Mr. Pattambiraman', 'MD', 'Sobha City', 'Thrissur', 'South', '680732', 'India', '12345678', '2542-986', '', 2, '2019-08-08 07:48:59.357679', NULL, NULL, 'F', 'F', 6);
INSERT INTO suppliers VALUES (1, 'Exotic Liquids', 'Charlotte Cooper', 'Purchasing Manager', '49 Gilbert St.', 'London', NULL, 'EC1 4SD', 'UK', '(171) 555-2222', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (2, 'New Orleans Cajun Delights', 'Shelley Burke', 'Order Administrator', 'P.O. Box 78934', 'New Orleans', 'LA', '70117', 'USA', '(100) 555-4822', NULL, '#CAJUN.HTM#', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (3, 'Grandma Kelly''s Homestead', 'Regina Murphy', 'Sales Representative', '707 Oxford Rd.', 'Ann Arbor', 'MI', '48104', 'USA', '(313) 555-5735', '(313) 555-3349', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (4, 'Tokyo Traders', 'Yoshi Nagase', 'Marketing Manager', '9-8 Sekimai Musashino-shi', 'Tokyo', NULL, '100', 'Japan', '(03) 3555-5011', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (5, 'Cooperativa de Quesos ''Las Cabras''', 'Antonio del Valle Saavedra', 'Export Administrator', 'Calle del Rosal 4', 'Oviedo', 'Asturias', '33007', 'Spain', '(98) 598 76 54', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (6, 'Mayumi''s', 'Mayumi Ohno', 'Marketing Representative', '92 Setsuko Chuo-ku', 'Osaka', NULL, '545', 'Japan', '(06) 431-7877', NULL, 'Mayumi''s (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (8, 'Specialty Biscuits, Ltd.', 'Peter Wilson', 'Sales Representative', '29 King''s Way', 'Manchester', NULL, 'M14 GSD', 'UK', '(161) 555-4448', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (9, 'PB Knäckebröd AB', 'Lars Peterson', 'Sales Agent', 'Kaloadagatan 13', 'Göteborg', NULL, 'S-345 67', 'Sweden', '031-987 65 43', '031-987 65 91', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (10, 'Refrescos Americanas LTDA', 'Carlos Diaz', 'Marketing Manager', 'Av. das Americanas 12.890', 'Sao Paulo', NULL, '5442', 'Brazil', '(11) 555 4640', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (11, 'Heli Süßwaren GmbH & Co. KG', 'Petra Winkler', 'Sales Manager', 'Tiergartenstraße 5', 'Berlin', NULL, '10785', 'Germany', '(010) 9984510', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (12, 'Plutzer Lebensmittelgroßmärkte AG', 'Martin Bein', 'International Marketing Mgr.', 'Bogenallee 51', 'Frankfurt', NULL, '60439', 'Germany', '(069) 992755', NULL, 'Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (13, 'Nord-Ost-Fisch Handelsgesellschaft mbH', 'Sven Petersen', 'Coordinator Foreign Markets', 'Frahmredder 112a', 'Cuxhaven', NULL, '27478', 'Germany', '(04721) 8713', '(04721) 8714', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (7, 'Pavlova, Ltd.', 'Ian Devling', 'Marketing Manager', '74 Rose St. Moonie Ponds', 'Melbourne', 'Victoria', '3058', 'Australia', '(03) 444-2343', '(03) 444-6588', '', NULL, NULL, 2, '2019-10-05 06:36:22.776123', 'F', 'F', 1);
INSERT INTO suppliers VALUES (14, 'Formaggi Fortini s.r.l.', 'Elio Rossi', 'Sales Representative', 'Viale Dante, 75', 'Ravenna', NULL, '48100', 'Italy', '(0544) 60323', '(0544) 60603', '#FORMAGGI.HTM#', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (15, 'Norske Meierier', 'Beate Vileid', 'Marketing Manager', 'Hatlevegen 5', 'Sandvika', NULL, '1320', 'Norway', '(0)2-953010', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (17, 'Svensk Sjöföda AB', 'Michael Björn', 'Sales Representative', 'Brovallavägen 231', 'Stockholm', NULL, 'S-123 45', 'Sweden', '08-123 45 67', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (18, 'Aux joyeux ecclésiastiques', 'Guylène Nodier', 'Sales Manager', '203, Rue des Francs-Bourgeois', 'Paris', NULL, '75004', 'France', '(1) 03.83.00.68', '(1) 03.83.00.62', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (19, 'New England Seafood Cannery', 'Robb Merchant', 'Wholesale Account Agent', 'Order Processing Dept. 2100 Paul Revere Blvd.', 'Boston', 'MA', '02134', 'USA', '(617) 555-3267', '(617) 555-3389', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (20, 'Leka Trading', 'Chandra Leka', 'Owner', '471 Serangoon Loop, Suite #402', 'Singapore', NULL, '0512', 'Singapore', '555-8787', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (21, 'Lyngbysild', 'Niels Petersen', 'Sales Manager', 'Lyngbysild Fiskebakken 10', 'Lyngby', NULL, '2800', 'Denmark', '43844108', '43844115', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (22, 'Zaanse Snoepfabriek', 'Dirk Luchte', 'Accounting Manager', 'Verkoop Rijnweg 22', 'Zaandam', NULL, '9999 ZZ', 'Netherlands', '(12345) 1212', '(12345) 1210', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (23, 'Karkki Oy', 'Anne Heikkonen', 'Product Manager', 'Valtakatu 12', 'Lappeenranta', NULL, '53120', 'Finland', '(953) 10956', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (24, 'G''day, Mate', 'Wendy Mackenzie', 'Sales Representative', '170 Prince Edward Parade Hunter''s Hill', 'Sydney', 'NSW', '2042', 'Australia', '(02) 555-5914', '(02) 555-4873', 'G''day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#', NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (25, 'Ma Maison', 'Jean-Guy Lauzon', 'Marketing Manager', '2960 Rue St. Laurent', 'Montréal', 'Québec', 'H1J 1C3', 'Canada', '(514) 555-9022', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (26, 'Pasta Buttini s.r.l.', 'Giovanni Giudici', 'Order Administrator', 'Via dei Gelsomini, 153', 'Salerno', NULL, '84100', 'Italy', '(089) 6547665', '(089) 6547667', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (27, 'Escargots Nouveaux', 'Marie Delamare', 'Sales Manager', '22, rue H. Voiron', 'Montceau', NULL, '71300', 'France', '85.57.00.07', NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (28, 'Gai pâturage', 'Eliane Noz', 'Sales Representative', 'Bat. B 3, rue des Alpes', 'Annecy', NULL, '74000', 'France', '38.76.98.06', '38.76.98.58', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (29, 'Forêts d''érables', 'Chantal Goulet', 'Accounting Manager', '148 rue Chasseur', 'Ste-Hyacinthe', 'Québec', 'J2S 7S8', 'Canada', '(514) 555-2955', '(514) 555-2921', NULL, NULL, NULL, NULL, NULL, 'F', 'F', 1);
INSERT INTO suppliers VALUES (16, 'Bigfoot Breweries', 'Cheryl Saylor', 'Regional Account Rep.', '3400 - 8th Avenue Suite 210', 'Bend', 'OR', '97101', 'USA', '(503) 555-9931', '', '', NULL, NULL, 2, '2019-10-06 04:37:26.96963', 'F', 'F', 1);

-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO purchases VALUES (2, 'PUR - 00002', NULL, '2019-08-27', 29, 25, 3, 28525, NULL, 2, '2019-08-27 05:07:34.871184', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (3, 'PUR - 00003', NULL, '2019-08-27', 15, 20, 4, 57770, NULL, 2, '2019-08-27 05:09:19.933366', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (4, 'PUR - 00004', NULL, '2019-08-27', 7, 250, 9, 154150, NULL, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (5, 'PUR - 00005', NULL, '2019-08-27', 15, 50, 8, 4010, NULL, 2, '2019-08-27 05:21:58.009801', 2, '2019-08-27 05:24:30.071978', 'F', 'F', 1);
INSERT INTO purchases VALUES (6, 'PUR - 00006', NULL, '2019-08-27', 14, 55, 8, 3211, NULL, 2, '2019-08-27 05:26:38.471335', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (7, 'PUR - 00007', NULL, '2019-08-27', 14, 110, 9, 28508, NULL, 2, '2019-08-27 05:28:01.134515', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (9, 'PUR - 00009', NULL, '2019-08-27', 3, 25, 9, 22150, NULL, 2, '2019-08-27 05:46:05.111477', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (10, 'PUR - 00010', NULL, '2019-08-27', 31, 25, 10, 6625, NULL, 2, '2019-08-27 05:47:25.13864', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (8, 'PUR - 00008', NULL, '2019-08-27', 4, 47, 8, 27147, NULL, 2, '2019-08-27 05:35:21.705537', 2, '2019-08-28 09:48:18.209879', 'F', 'F', 1);
INSERT INTO purchases VALUES (1, 'PUR - 00001', NULL, '2019-08-26', 1, 45, 1, 11795, NULL, 2, '2019-08-26 11:36:34.958114', 2, '2019-08-28 09:58:30.831248', 'F', 'F', 1);
INSERT INTO purchases VALUES (11, 'PUR - 00011', NULL, '2019-08-27', 20, 50, 10, 36530, NULL, 2, '2019-08-27 05:48:25.543408', 2, '2019-08-28 10:00:36.120092', 'F', 'F', 6);
INSERT INTO purchases VALUES (12, 'PUR - 00012', NULL, '2019-07-01', 1, 12, 1, 1512, NULL, 2, '2019-08-30 05:37:43.805408', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (13, 'PUR - 00013', NULL, '2019-07-02', 2, 250, 3, 6225, NULL, 2, '2019-08-30 05:38:57.48009', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (14, 'PUR - 00014', NULL, '2019-07-04', 3, 112, 3, 7522, NULL, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (15, 'PUR - 00015', NULL, '2019-06-03', 5, 11, 5, 1685, NULL, 2, '2019-08-30 05:41:38.368072', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (16, 'PUR - 00016', NULL, '2019-07-01', 30, 10, 10, 1060, NULL, 2, '2019-08-30 05:42:50.523288', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (17, 'PUR - 00017', NULL, '2019-07-17', 2, 120, 10, 79970, NULL, 2, '2019-08-30 05:44:31.67729', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (18, 'PUR - 00018', NULL, '2019-07-22', 20, 11, 10, 2536, NULL, 2, '2019-08-30 05:45:41.509235', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (19, 'PUR - 00019', NULL, '2019-07-25', 31, 10, 10, 4360, NULL, 2, '2019-08-30 05:46:37.819872', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (20, 'PUR - 00020', NULL, '2018-07-02', 30, 10, 10, 410, NULL, 2, '2019-08-30 05:56:14.911104', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (21, 'PUR - 00021', NULL, '2018-06-20', 1, 10, 10, 14010, NULL, 2, '2019-08-30 05:56:58.433411', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (22, 'PUR - 00022', NULL, '2018-12-01', 20, 110, 10, 8910, NULL, 2, '2019-08-30 05:57:59.010467', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (23, 'PUR - 00023', NULL, '2018-10-01', 2, 450, 10, 62258, NULL, 2, '2019-08-30 05:59:28.536613', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (24, 'PUR - 00024', NULL, '2018-12-04', 30, 120, 10, 3870, NULL, 2, '2019-08-30 06:00:56.062078', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (25, 'PUR - 00025', NULL, '2018-09-17', 31, 250, 10, 19250, NULL, 2, '2019-08-30 06:01:43.981106', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchases VALUES (26, 'PUR - 00026', NULL, '2018-06-01', 25, 100, 1, 53200, NULL, 2, '2019-08-30 06:22:25.40694', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (27, 'PUR - 00027', NULL, '2018-10-01', 3, 250, 2, 50750, NULL, 2, '2019-08-30 06:23:24.899864', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (28, 'PUR - 00028', NULL, '2018-08-01', 24, 250, 8, 60250, NULL, 2, '2019-08-30 06:55:29.693273', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (29, 'PUR - 00029', NULL, '2018-08-08', 28, 10, 8, 670, NULL, 2, '2019-08-30 07:37:29.486612', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (30, 'PUR - 00030', NULL, '2018-06-11', 2, 100, 7, 11100, NULL, 2, '2019-08-30 07:49:26.785537', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (31, 'PUR - 00031', NULL, '2018-10-02', 19, 250, 5, 23750, NULL, 2, '2019-08-30 07:50:54.312876', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (32, 'PUR - 00032', NULL, '2018-09-11', 16, 152, 7, 11902, NULL, 2, '2019-08-30 07:52:30.501989', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (33, 'PUR - 00033', NULL, '2018-11-07', 12, 11, 9, 10961, NULL, 2, '2019-08-30 07:53:37.804613', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (34, 'PUR - 00034', NULL, '2018-08-01', 19, 142, 7, 14342, NULL, 2, '2019-08-30 08:43:05.42837', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (35, 'PUR - 00035', NULL, '2018-12-18', 15, 152, 9, 10502, NULL, 2, '2019-08-30 08:44:44.692271', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchases VALUES (36, 'PUR - 00036', NULL, '2019-10-05', 19, 10, 2, 4660, NULL, 2, '2019-10-05 09:18:29.026979', NULL, NULL, 'F', 'F', 1);

-- Data for Name: purchase_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO purchase_details VALUES (3, 61, 25.00, 500.00, 12500.00, 2, 1, 2, '2019-08-27 05:07:34.871184', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (4, 62, 20.00, 800.00, 16000.00, 2, 2, 2, '2019-08-27 05:07:34.871184', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (5, 33, 15.00, 550.00, 8250.00, 3, 1, 2, '2019-08-27 05:09:19.933366', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (6, 69, 25.00, 840.00, 21000.00, 3, 2, 2, '2019-08-27 05:09:19.933366', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (7, 71, 30.00, 950.00, 28500.00, 3, 3, 2, '2019-08-27 05:09:19.933366', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (8, 16, 45.00, 800.00, 36000.00, 4, 1, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (9, 17, 100.00, 470.00, 47000.00, 4, 2, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (10, 18, 50.00, 750.00, 37500.00, 4, 3, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (11, 63, 30.00, 780.00, 23400.00, 4, 4, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (12, 70, 10.00, 1000.00, 10000.00, 4, 5, 2, '2019-08-27 05:12:35.148819', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (13, 33, 20.00, 113.00, 2260.00, 5, 1, 2, '2019-08-27 05:21:58.009801', 2, '2019-08-27 05:24:30.071978', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (14, 69, 25.00, 100.00, 2500.00, 5, 2, 2, '2019-08-27 05:21:58.009801', 2, '2019-08-27 05:24:30.071978', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (15, 31, 12.00, 113.00, 1356.00, 6, 1, 2, '2019-08-27 05:26:38.471335', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (16, 32, 15.00, 120.00, 1800.00, 6, 2, 2, '2019-08-27 05:26:38.471335', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (17, 31, 12.00, 1304.00, 15648.00, 7, 1, 2, '2019-08-27 05:28:01.134515', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (18, 72, 15.00, 850.00, 12750.00, 7, 2, 2, '2019-08-27 05:28:01.134515', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (21, 8, 25.00, 381.00, 9525.00, 9, 1, 2, '2019-08-27 05:46:05.111477', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (22, 7, 28.00, 450.00, 12600.00, 9, 2, 2, '2019-08-27 05:46:05.111477', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (23, 82, 15.00, 250.00, 3750.00, 10, 1, 2, '2019-08-27 05:47:25.13864', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (24, 83, 5.00, 570.00, 2850.00, 10, 2, 2, '2019-08-27 05:47:25.13864', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (19, 74, 25.00, 334.00, 8350.00, 8, 1, 2, '2019-08-27 05:35:21.705537', 2, '2019-08-28 09:48:18.209879', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (20, 10, 75.00, 250.00, 18750.00, 8, 2, 2, '2019-08-27 05:35:21.705537', 2, '2019-08-28 09:48:18.209879', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (69, 34, 20.00, 150.00, 3000.00, 32, 1, 2, '2019-08-30 07:52:30.501989', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (70, 35, 25.00, 100.00, 2500.00, 32, 2, 2, '2019-08-30 07:52:30.501989', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (1, 3, 15.00, 200.00, 3000.00, 1, 1, 2, '2019-08-26 11:36:34.958114', 2, '2019-08-28 09:58:30.831248', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (2, 3, 35.00, 250.00, 8750.00, 1, 2, 2, '2019-08-26 11:36:34.958114', 2, '2019-08-28 09:58:30.831248', 'F', 'F', 1);
INSERT INTO purchase_details VALUES (25, 43, 25.00, 580.00, 14500.00, 11, 1, 2, '2019-08-27 05:48:25.543408', 2, '2019-08-28 10:00:36.120092', 'F', 'F', 6);
INSERT INTO purchase_details VALUES (26, 44, 28.00, 785.00, 21980.00, 11, 2, 2, '2019-08-27 05:48:25.543408', 2, '2019-08-28 10:00:36.120092', 'F', 'F', 6);
INSERT INTO purchase_details VALUES (27, 3, 30.00, 50.00, 1500.00, 12, 1, 2, '2019-08-30 05:37:43.805408', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (28, 4, 25.00, 50.00, 1250.00, 13, 1, 2, '2019-08-30 05:38:57.48009', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (29, 65, 30.00, 75.00, 2250.00, 13, 2, 2, '2019-08-30 05:38:57.48009', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (30, 66, 33.00, 75.00, 2475.00, 13, 3, 2, '2019-08-30 05:38:57.48009', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (31, 6, 25.00, 44.00, 1100.00, 14, 1, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (32, 7, 30.00, 47.00, 1410.00, 14, 2, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (33, 8, 48.00, 75.00, 3600.00, 14, 3, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (34, 79, 10.00, 78.00, 780.00, 14, 4, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (35, 81, 10.00, 52.00, 520.00, 14, 5, 2, '2019-08-30 05:40:47.489572', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (36, 11, 12.00, 77.00, 924.00, 15, 1, 2, '2019-08-30 05:41:38.368072', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (37, 12, 10.00, 75.00, 750.00, 15, 2, 2, '2019-08-30 05:41:38.368072', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (38, 84, 15.00, 70.00, 1050.00, 16, 1, 2, '2019-08-30 05:42:50.523288', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (39, 4, 75.00, 70.00, 5250.00, 17, 1, 2, '2019-08-30 05:44:31.67729', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (40, 65, 78.00, 700.00, 54600.00, 17, 2, 2, '2019-08-30 05:44:31.67729', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (41, 66, 50.00, 400.00, 20000.00, 17, 3, 2, '2019-08-30 05:44:31.67729', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (42, 43, 20.00, 70.00, 1400.00, 18, 1, 2, '2019-08-30 05:45:41.509235', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (43, 44, 15.00, 75.00, 1125.00, 18, 2, 2, '2019-08-30 05:45:41.509235', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (44, 82, 20.00, 200.00, 4000.00, 19, 1, 2, '2019-08-30 05:46:37.819872', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (45, 83, 5.00, 70.00, 350.00, 19, 2, 2, '2019-08-30 05:46:37.819872', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (46, 84, 10.00, 40.00, 400.00, 20, 1, 2, '2019-08-30 05:56:14.911104', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (47, 3, 20.00, 700.00, 14000.00, 21, 1, 2, '2019-08-30 05:56:58.433411', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (48, 43, 12.00, 400.00, 4800.00, 22, 1, 2, '2019-08-30 05:57:59.010467', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (49, 44, 20.00, 200.00, 4000.00, 22, 2, 2, '2019-08-30 05:57:59.010467', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (50, 4, 34.00, 112.00, 3808.00, 23, 1, 2, '2019-08-30 05:59:28.536613', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (51, 65, 45.00, 200.00, 9000.00, 23, 2, 2, '2019-08-30 05:59:28.536613', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (52, 66, 70.00, 700.00, 49000.00, 23, 3, 2, '2019-08-30 05:59:28.536613', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (53, 84, 15.00, 250.00, 3750.00, 24, 1, 2, '2019-08-30 06:00:56.062078', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (54, 82, 12.00, 500.00, 6000.00, 25, 1, 2, '2019-08-30 06:01:43.981106', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (55, 83, 25.00, 520.00, 13000.00, 25, 2, 2, '2019-08-30 06:01:43.981106', NULL, NULL, 'F', 'F', 6);
INSERT INTO purchase_details VALUES (56, 54, 45.00, 400.00, 18000.00, 26, 1, 2, '2019-08-30 06:22:25.40694', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (57, 55, 78.00, 450.00, 35100.00, 26, 2, 2, '2019-08-30 06:22:25.40694', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (58, 6, 45.00, 700.00, 31500.00, 27, 1, 2, '2019-08-30 06:23:24.899864', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (59, 81, 10.00, 1000.00, 10000.00, 27, 2, 2, '2019-08-30 06:23:24.899864', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (60, 7, 20.00, 450.00, 9000.00, 27, 3, 2, '2019-08-30 06:23:24.899864', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (61, 51, 75.00, 200.00, 15000.00, 28, 1, 2, '2019-08-30 06:55:29.693273', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (62, 52, 50.00, 900.00, 45000.00, 28, 2, 2, '2019-08-30 06:55:29.693273', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (63, 59, 15.00, 20.00, 300.00, 29, 1, 2, '2019-08-30 07:37:29.486612', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (64, 60, 12.00, 30.00, 360.00, 29, 2, 2, '2019-08-30 07:37:29.486612', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (65, 65, 15.00, 400.00, 6000.00, 30, 1, 2, '2019-08-30 07:49:26.785537', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (66, 66, 25.00, 200.00, 5000.00, 30, 2, 2, '2019-08-30 07:49:26.785537', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (67, 40, 75.00, 100.00, 7500.00, 31, 1, 2, '2019-08-30 07:50:54.312876', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (68, 41, 80.00, 200.00, 16000.00, 31, 2, 2, '2019-08-30 07:50:54.312876', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (71, 67, 25.00, 250.00, 6250.00, 32, 3, 2, '2019-08-30 07:52:30.501989', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (72, 64, 30.00, 120.00, 3600.00, 33, 1, 2, '2019-08-30 07:53:37.804613', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (73, 75, 50.00, 147.00, 7350.00, 33, 2, 2, '2019-08-30 07:53:37.804613', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (74, 40, 52.00, 100.00, 5200.00, 34, 1, 2, '2019-08-30 08:43:05.42837', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (75, 41, 75.00, 120.00, 9000.00, 34, 2, 2, '2019-08-30 08:43:05.42837', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (76, 33, 25.00, 120.00, 3000.00, 35, 1, 2, '2019-08-30 08:44:44.692271', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (77, 69, 30.00, 125.00, 3750.00, 35, 2, 2, '2019-08-30 08:44:44.692271', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (78, 71, 48.00, 75.00, 3600.00, 35, 3, 2, '2019-08-30 08:44:44.692271', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (79, 41, 50.00, 54.00, 2700.00, 36, 3, 2, '2019-10-05 09:18:29.026979', NULL, NULL, 'F', 'F', 1);
INSERT INTO purchase_details VALUES (80, 40, 25.00, 78.00, 1950.00, 36, 2, 2, '2019-10-05 09:18:29.026979', NULL, NULL, 'F', 'F', 1);

ALTER SEQUENCE orders_id_seq RESTART WITH 11102;
ALTER SEQUENCE categories_id_seq RESTART WITH 11;
ALTER SEQUENCE customers_id_seq RESTART WITH 101;
ALTER SEQUENCE employees_id_seq RESTART WITH 11; 
ALTER SEQUENCE order_details_id_seq RESTART WITH 2231;
ALTER SEQUENCE products_id_seq RESTART WITH 86;;
ALTER SEQUENCE shippers_id_seq RESTART WITH 11;
ALTER SEQUENCE suppliers_id_seq RESTART WITH 31; 
ALTER SEQUENCE purchases_id_seq RESTART WITH 37; 
ALTER SEQUENCE purchase_details_id_seq RESTART WITH 81;   


SELECT (CURRENT_DATE-(select MAX(order_date) FROM orders)) into day_dif;
UPDATE orders set order_date = order_date   + (select * from day_dif);
UPDATE orders set required_date = required_date   + (select * from day_dif);
UPDATE orders set shipped_date = shipped_date   + (select * from day_dif);
					  
-- categories

CREATE INDEX categories_id_idx
    ON categories USING btree
    (id);

CREATE INDEX category_name_id_idx
    ON categories USING btree
    (category_name);

-- customers

CREATE INDEX customers_id_idx
    ON customers USING btree
    (id);

CREATE INDEX customers_customer_id_idx
    ON customers USING btree
    (customer_id);

CREATE INDEX customers_company_name_idx
    ON customers USING btree
    (company_name);

CREATE INDEX customers_city_idx
    ON customers USING btree
    (city);

CREATE INDEX customers_country_idx
    ON customers USING btree
    (country);

-- employees

CREATE INDEX employees_id_idx
    ON employees USING btree
    (id);

CREATE INDEX employees_last_name_idx
    ON employees USING btree
    (last_name);

CREATE INDEX employees_first_name_idx
    ON employees USING btree
    (first_name);

-- order_details

CREATE INDEX order_details_id_idx
    ON order_details USING btree
    (id);

CREATE INDEX order_details_orders_id_idx
    ON order_details USING btree
    (orders_id);

-- orders

CREATE INDEX orders_id_idx
    ON orders USING btree
    (id);

CREATE INDEX orders_customer_id_idx
    ON orders USING btree
    (customer_id);

CREATE INDEX orders_employee_id_idx
    ON orders USING btree
    (employee_id);

CREATE INDEX orders_order_date_idx
    ON orders USING btree
    (order_date);

CREATE INDEX orders_ship_via_idx
    ON orders USING btree
    (ship_via);

CREATE INDEX orders_ship_name_idx
    ON orders USING btree
    (ship_name);

-- products

CREATE INDEX products_id_idx
    ON products USING btree
    (id);

CREATE INDEX products_product_name_idx
    ON products USING btree
    (product_name);

CREATE INDEX products_supplier_id_idx
    ON products USING btree
    (supplier_id);

CREATE INDEX products_category_id_idx
    ON products USING btree
    (category_id);

-- shippers

CREATE INDEX shippers_id_idx
    ON shippers USING btree
    (id);

CREATE INDEX shippers_company_name_idx
    ON shippers USING btree
    (company_name);

-- suppliers

CREATE INDEX suppliers_id_idx
    ON suppliers USING btree
    (id);

CREATE INDEX suppliers_company_name_idx
    ON suppliers USING btree
    (company_name);

CREATE INDEX suppliers_country_idx
    ON suppliers USING btree
    (country);

-- purchase_details

CREATE INDEX purchase_details_id_idx
    ON purchase_details USING btree
    (id);

CREATE INDEX purchase_details_orders_id_idx
    ON purchase_details USING btree
    (purchases_id);

-- purchases

CREATE INDEX purchases_id_idx
    ON purchases USING btree
    (id);

CREATE INDEX purchases_suppliers_id_idx
    ON purchases USING btree
    (suppliers_id);

CREATE INDEX purchases_employee_id_idx
    ON purchases USING btree
    (employee_id);

CREATE INDEX purchase_date_idx
    ON purchases USING btree
    (purchase_date);

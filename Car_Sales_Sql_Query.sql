--#1 The distribution of vehicle sales among different car models

SELECT model,
       count(vehicle_id) AS vehicles_sold
FROM vehicles
WHERE availability = FALSE
GROUP BY model
ORDER BY vehicles_sold DESC;


--#2 Customers who purchased more than two vehicles

WITH vehicles_per_cust AS
  (SELECT customer_id,
          count(vehicle_id) AS vehicles_count
   FROM sales
   GROUP BY customer_id
   HAVING count(vehicle_id) > 2)
SELECT name,
       email,
       vehicles_count
FROM vehicles_per_cust
JOIN customers cust ON cust.customer_id = vehicles_per_cust.customer_id;


--#3 Average number of days between consecutive vehicle purchases for 
-- customers who have bought more than one vehicle?

WITH vehicles_per_cust AS
  (SELECT customer_id,
          count(vehicle_id) AS vehicles_count
   FROM sales
   GROUP BY customer_id
   HAVING count(vehicle_id) > 1),
     days_bwn_purchase AS
  (SELECT vehicles_per_cust.customer_id,
          sale_date,
          lag(sale_date) OVER (PARTITION BY vehicles_per_cust.customer_id
                               ORDER BY sale_date) AS previous_purchase_date
   FROM vehicles_per_cust
   JOIN sales ON vehicles_per_cust.customer_id = sales.customer_id)
SELECT round(avg(sale_date - previous_purchase_date)) AS avg_days_between_purchase
FROM days_bwn_purchase
WHERE previous_purchase_date IS NOT NULL;


--#4 Top 5 cars with the highest sales volume
WITH sales_volume AS
  (SELECT vehicle_models.model,
          vehicle_models.make,
          COUNT(*) AS sales_volume
   FROM vehicles
   JOIN vehicle_models ON vehicles.model = vehicle_models.model
   JOIN sales ON vehicles.vehicle_id = sales.vehicle_id
   GROUP BY vehicle_models.model,
            vehicle_models.make
   ORDER BY sales_volume DESC)
SELECT model,
       make
FROM sales_volume
LIMIT 5;


--#5 Model with the highest sales in each state
WITH sales_volume_by_state AS
  (SELECT model,
          state,
          COUNT(model) AS model_count,
          RANK() OVER (PARTITION BY state
                       ORDER BY COUNT(model) DESC) AS sales_rank
   FROM sales
   JOIN customer_address ON sales.customer_id = customer_address.customer_id
   JOIN zipcodes ON customer_address.zipcode = zipcodes.zipcode
   JOIN customers ON customer_address.customer_id = customers.customer_id
   JOIN vehicles ON customers.customer_id = vehicles.customer_id
   WHERE availability = FALSE
   GROUP BY model,
            state)
SELECT state,
       model
FROM sales_volume_by_state
WHERE sales_rank = 1;


--#6 Add a customer who hasn’t made any vehicle purchases
INSERT INTO customers(customer_id, name, email, phone_number)
VALUES (4000,'Elijah Evans','elijahfevans@example.net',9177523920),
       (4001,'James Case','jamesacase@example.com',5024097921);


--#7 Update customer address
UPDATE customer_address
SET address = '155 Pitts Lodge'
WHERE customer_id = 2582;


--#8 Delete incorrect price from price history
DELETE
FROM price_history
WHERE vehicle_id = 7511
  AND price_recorded_date='2009-04-25';


--#9 Price between range
SELECT min(price) AS lowest,
       max(price) AS highest
FROM price_history
WHERE price BETWEEN 41650 AND 41750;


--#10 Query for web application
WITH vehicles AS
  (SELECT vehicle_id,
          TYPE,
          model,
          YEAR
   FROM vehicles
   WHERE availability = TRUE
     AND model = 'Blazer EV' ),
     vehicle_models AS
  (SELECT model,
          make
   FROM vehicle_models
   WHERE model = 'Blazer EV'
     AND make = 'Chevrolet' ),
     vehicle_details AS
  (SELECT vehicle_id,
          miles_used,
          color,
          engine_type,
          transmission_type,
          number_of_seats
   FROM vehicle_details),
     engines AS
  (SELECT engine_type,
          fuel_type
   FROM engines),
     all_prices AS
  (SELECT *,
          max(price_recorded_date) over(PARTITION BY vehicle_id) AS most_recent_date
   FROM price_history),
     listed_vehicles AS
  (SELECT vehicles.vehicle_id,
          vehicles.type,
          vehicles.model,
          vehicles.year ,
          vehicle_models.make ,
          vehicle_details.miles_used,
          vehicle_details.color,
          vehicle_details.engine_type,
          vehicle_details.transmission_type,
          vehicle_details.number_of_seats ,
          engines.fuel_type
   FROM vehicles
   JOIN vehicle_models ON vehicles.model = vehicle_models.model
   JOIN vehicle_details ON vehicles.vehicle_id = vehicle_details.vehicle_id
   JOIN engines ON vehicle_details.engine_type = engines.engine_type),
     current_price AS
  (SELECT listed_vehicles.*,
          all_prices.price
   FROM listed_vehicles
   JOIN all_prices ON listed_vehicles.vehicle_id = all_prices.vehicle_id
   WHERE all_prices.price_recorded_date = all_prices.most_recent_date )
SELECT *
FROM current_price ORDER BY price;


--#11 Creating index for vehicles, price_history and vehicle_models table
CREATE INDEX IF NOT EXISTS vehicles_availability_idx ON vehicles(availability);
CREATE INDEX IF NOT EXISTS vehicles_model_idx ON vehicles(model);
CREATE INDEX IF NOT EXISTS vehicles_type_idx ON vehicles(type);

CREATE INDEX IF NOT EXISTS price_history_price_idx ON price_history(price);

CREATE INDEX IF NOT EXISTS vehicle_models_make_idx ON vehicle_models(make);

--#12 Creating index for sales table
CREATE INDEX sales_customer_id_idx ON sales(customer_id);

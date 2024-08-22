import streamlit as st
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import plotly.express as px

from urllib.request import urlopen
import plotly.graph_objects as go

# Connect to the PostgreSQL database
def connect_to_db(dbname, user, password, host, port):
  try:
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
    return conn
  except Exception as e:
    st.error(f"Connection error: {e}")
    return None


# Run queries on PostgrSQL database
def run_query(conn, sql):
  if not conn:
    return

  cursor = conn.cursor()
  cursor.execute(sql)

  return cursor.fetchall(), cursor.description


# Generate find cards SQL
def generate_get_cars_sql(make, model, car_condition, sort_by_price):
  if car_condition is None:
    type_filter = ""
  else:
    type_filter = f"AND type = '{car_condition}'"

  if sort_by_price is not None:
    sort_filter = "ORDER BY price"
  else:
    sort_filter = ""

  get_cars_sql = f"""
    WITH vehicles AS (
        SELECT vehicle_id, type, model, year FROM vehicles
        WHERE availability = TRUE AND model = '{model}' {type_filter}
    ),
    vehicle_models AS (
        SELECT model, make FROM vehicle_models WHERE model = '{model}' AND make = '{make}'
    ),
    vehicle_details AS (
        SELECT vehicle_id, miles_used, color, engine_type, transmission_type, number_of_seats FROM vehicle_details
    ),
    engines AS (
        SELECT engine_type, fuel_type FROM engines
    ),
    all_prices AS (
        SELECT *, max(price_recorded_date) over(PARTITION BY vehicle_id) AS most_recent_date
        FROM price_history
    ),
    listed_vehicles AS (
        SELECT
            vehicles.vehicle_id, vehicles.type, vehicles.model, vehicles.year
            , vehicle_models.make
            , vehicle_details.miles_used, vehicle_details.color, vehicle_details.engine_type, vehicle_details.transmission_type, vehicle_details.number_of_seats
            , engines.fuel_type
        FROM
            vehicles JOIN vehicle_models ON vehicles.model = vehicle_models.model
            JOIN vehicle_details ON vehicles.vehicle_id = vehicle_details.vehicle_id
            JOIN engines ON vehicle_details.engine_type = engines.engine_type
    ),
    current_price AS (
        SELECT listed_vehicles.*, all_prices.price
        FROM listed_vehicles JOIN all_prices
        ON listed_vehicles.vehicle_id = all_prices.vehicle_id
        WHERE all_prices.price_recorded_date = all_prices.most_recent_date
    )
    SELECT * FROM current_price {sort_filter};
  """

  return get_cars_sql


def generate_price_history_sql(make, model):

  price_history_sql = f"""
    WITH vehicles AS (
      SELECT vehicle_id, model FROM vehicles WHERE availability = TRUE AND type = 'new'
    ),
    vehicle_models AS (
      SELECT model, make FROM vehicle_models WHERE model = '{model}' AND make = '{make}'
    ),
    price_history AS (
      SELECT vehicle_id, extract(year from price_recorded_date) as year, price FROM price_history
    )
    SELECT
      price_history.year AS year, round(avg(price_history.price)) AS price
    FROM
      vehicles JOIN vehicle_models ON vehicles.model = vehicle_models.model
      JOIN price_history ON vehicles.vehicle_id = price_history.vehicle_id
    GROUP BY
      price_history.year
    ORDER BY
      price_history.year
  """

  return price_history_sql


# Database connection details
dbname = "car_sales"
user = "postgres"
password = "uCLRUGiK5TpYxjW"
host = "rds-instance.cpwqio6e2d4m.us-east-2.rds.amazonaws.com"
port = 5432

conn = connect_to_db(dbname, user, password, host, port)

st.set_page_config(page_title="Car Finder", page_icon="")

# Header with logo (replace "logo.png" with your actual logo image path)
st.header("AutoCars")
st.image("https://cdn.vectorstock.com/i/500p/50/97/sports-car-silhouette-dealer-logo-vector-39355097.jpg", width=100)

# Tabs for Find Cars and Price History
buy_car, price_history, cars_bought = st.tabs(["Buy Car", "Price History", "Cars Sold"])

with buy_car:
  # Buy Car tab content
  st.subheader("Find Your Dream Car")

  # Text input fields for user to enter query parameters
  make = st.selectbox("Make", ["Honda", "Ford", "Nissan", "Chevrolet", "Toyota"], key=101)

  if make == "Honda":
    model = st.selectbox("Model", ["CR-V Hybrid", "HR-V", "Passport", "Pilot", "Ridgeline"], key=102)
  elif make == "Ford":
    model = st.selectbox("Model", ["Bronco Sport", "Edge", "F-150", "Maverick", "Mustang Mach-E"], key=103)
  elif make == "Nissan":
    model = st.selectbox("Model", ["Altima", "Frontier", "Maxima", "Rouge", "Sentra"], key=104)
  elif make == "Chevrolet":
    model = st.selectbox("Model", ["Blazer EV", "Colorado", "Equinox", "Silverado", "Trax"], key=105)
  elif make == "Toyota":
    model = st.selectbox("Model", ["Corolla", "Highlander", "RAV4 Hybrid", "Sienna", "Tundra"], key=106)

  car_condition = st.selectbox("Type", [None, "new", "used"], index=1, key=107)
  sort_by_price = st.selectbox("Sort By", [None, "Price"], index=1, key=108)

  # Submit button
  if st.button("Show Cars", key=109):
    get_cars_sql = generate_get_cars_sql(make, model, car_condition, sort_by_price)
    results, description = run_query(conn, get_cars_sql)
    results_df = pd.DataFrame(results, columns=[desc[0] for desc in description])
    
    st.dataframe(results_df)

with price_history:
  # Price History tab content
  st.subheader("Track Price")

  # Text input fields for user to enter query parameters
  make = st.selectbox("Make", ["Honda", "Ford", "Nissan", "Chevrolet", "Toyota"], key=201)

  if make == "Honda":
    model = st.selectbox("Model", ["CR-V Hybrid", "HR-V", "Passport", "Pilot", "Ridgeline"], key=202)
  elif make == "Ford":
    model = st.selectbox("Model", ["Bronco Sport", "Edge", "F-150", "Maverick", "Mustang Mach-E"], key=203)
  elif make == "Nissan":
    model = st.selectbox("Model", ["Altima", "Frontier", "Maxima", "Rouge", "Sentra"], key=204)
  elif make == "Chevrolet":
    model = st.selectbox("Model", ["Blazer EV", "Colorado", "Equinox", "Silverado", "Trax"], key=205)
  elif make == "Toyota":
    model = st.selectbox("Model", ["Corolla", "Highlander", "RAV4 Hybrid", "Sienna", "Tundra"], key=206)

  # Submit button
  if st.button("Show Cars", key=207):
    price_history_sql = generate_price_history_sql(make, model)
    results, description = run_query(conn, price_history_sql)
    results_df = pd.DataFrame(results, columns=[desc[0] for desc in description])

    fig, ax = plt.subplots()

    ax.plot(results_df["year"], results_df["price"])
    st.pyplot(fig)

with cars_bought:
  # Density of cars bought
  st.subheader("Density of Cars Sold")

  get_zipcodes_sql = """
    SELECT
      zipcodes.zipcode
    FROM
      sales JOIN customer_address ON sales.customer_id = customer_address.customer_id
      JOIN zipcodes ON customer_address.zipcode = zipcodes.zipcode
  """

  results, description = run_query(conn, get_zipcodes_sql)
  post_df = pd.DataFrame(results, columns=[desc[0] for desc in description])
  post_df.zipcode = post_df.zipcode.astype(str)
  
  # Download US zipcodes data
  with open('US.txt', 'rb') as file:
    geo_data = file.readlines()
  geo_data = [line.decode('utf-8').split("\t") for line in geo_data]
  geo_data_df = pd.DataFrame(geo_data, columns=["_1", "zipcode", "City", "State", "_2", "_3", "_4", "_5", "_6", "Latitude", "Longitude", "_7"])
  geo_data_df.drop(columns=["_1", "_2", "_3", "_4", "_5", "_6", "_7"], inplace=True)
  geo_data_df.zipcode = geo_data_df.zipcode.astype(str)
  geo_data_df.City = geo_data_df.City.astype(str)
  geo_data_df.State = geo_data_df.State.astype(str)
  geo_data_df.Latitude = geo_data_df.Latitude.astype(float)
  geo_data_df.Longitude = geo_data_df.Longitude.astype(float)

  combined_df = post_df.merge(geo_data_df, how="left")

  fig = px.scatter_mapbox(combined_df, lat="Latitude", lon="Longitude", hover_name="City", hover_data=["State"], zoom=3, height=600, width=900)
  fig.update_layout(
  mapbox_style="white-bg",
  mapbox_layers=[
      {
          "below": 'traces',
          "sourcetype": "raster",
          "sourceattribution": "United States Geological Survey",
          "source": [
              "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}"
          ]
      }
      ]
  )
  fig.update_traces(
      marker=go.scattermapbox.Marker(
          size=5,
          color='rgb(0, 161, 155)',
          opacity=1.0
      )
  )
  fig.update_layout(margin={"r": 0, "t": 0, "l": 0, "b": 0})
  
  st.plotly_chart(fig, use_container_width=True)

# DineOutside

A place to find your food truck and cart options when in San Francisco.

## Tasks

- [x] Domain model out, let's:
  - [x] Generate a `FoodTruck` context with 
  - [x] `Location` schema to represent what we know about food truck and cart locations
  - [x] `food_items` field needs to be increased in size, from string to text
- [x] Reduce lat-lon precision from micrometers to 1.1 meters, five decimal places
- [ ] Add filter:
  - [x] Haversine distance to truck / cart / service functio: `within_great_circle?/3`
  - [ ] Add form accepting anchor coordinates and button
- [x] Add links to landing page to access the location live view
- [x] Add Quickstart to README
- [ ] Aestheticss and cleanup
  - [x] Trim left margin of index view

## Quickstart

This LiveView web UI allows its user to find food trucks and carts within a variable distance of 
where one is located.  

To get up and running:
```bash
# Clone this repository
git clone git@github.com:alanStrait/dine_outside.git
# Use docker compose to create a `dine_outside` database 
cd dine_outside
docker-compose up -d
# Create dine_outside_* databases and seed database with CSV data
mix ecto.setup
# Enter `psql` in docker container to run SQL if desired
# see bin/pgpsqlenter.sh for candidate commands to run
bash bin/pgpsqlenter.sh
# Start Phoenix server
mix phx.server
# Or start with iex running as well
iex -S mix phx.server
# If you started with iex, you can stop Phoenix server with:
System.halt 
# or
ctl+c
# Stop postgresql in docker container
docker-compose down
```

Once Phoenix server is running, access landing page: [http://localhost:4000](http://localhost:4000)

Notice menu options to link to Location live view `index` at top righthand portion of page.

Suggested anchor coordinates to get best filter results, Union Square.
Additional candidates include:
  * Mission District: `{-122.4204, 37.7601}`
  * Union Square:     `{-122.4046, 37.7895}`
  * Pacific Heights:  `{-122.4346, 37.7932}`
  * Presidio:         `{-122.4662, 37.7985}`
  * SFO University    `{-122.4797, 37.7235}`

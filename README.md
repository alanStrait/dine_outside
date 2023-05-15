# DineOutside

A place to find your food truck and cart options by distance when in San Francisco.

## Domain Overview

`dine_outside` web app allows the user to find food trucks and carts by distance, as-the-crow-flies, according to latitude-longitude coordinates of their own location and that of the vendor.  An `anchor` location is set as the users `latitude-longitude coordinates` and the `distance in meters` that is desirable to walk to dine outside.

The UI is initialized for `Union Square` where the highest density of food trucks and carts appear to be available.  All food trucks and carts are listed on entry to the listing page.  

By way of suggestion, start your search by changing distance and filtering for food trucks and carts at: 50 meters (zero hits), 75 meters (one hit), 100 meters (two hits), and up.  Increase the distance to see more vendors, decrease to see them narrowed.  Feel free to set an anchor point in various parts of the city (some examples are at the bottom of this README).

The filter does have validation to keep the user within a loose bounding box that spans a bit further than San Francisco proper.  The distance is arbitrarily limited to 25_000 meters, well more than one would want to walk.

## Technical Overview

### Design and implementation 
* Phoenix LiveView began supporting streams in 0.18.16 which is used in this web app to grow and shrink the filter result list.
  * This took a bit of reading and experimentation with the `streams` API to make work as I had not used it before but was interested in trying it out.  I do not include this experimentation time as part of the time to complete this exercise.
  * The versions of Erlang/OTP/Elixir required is in the `Quickstart` below.
* The data used came from the [engineering challenge](https://github.com/peck/engineering-assessment) github site.
  * The data was surprising in that it did not offer much insight for what it meant.  E.g., I expected more vendors with a status of `APPROVED` or `ISSUED` but found most to be `EXPIRED` or `REQUESTED`, so I chose to include all the data and trust the user to `let the buyer be ware` by displaying as much data as could be squeezed onto the listing.
  * A `docker-compose.yaml` that describes a container with the latest PostgreSQL is included as well as a bash script for accessing `psql` in-container.  See `Quickstart`.
  * The data was loaded into a `locations` table with a corresponding `Location` schema accessed through a `FoodTruck` context module.
    * The data load is performed in `priv/repo/seeds.exs` and is accounted for as part of the `setup` and `reset` directives in `Quickstart` below.
* Web app:
  * Phoenix provides many `mix` features for bootstrapping its use.  
    * The following was used to bootstrap the project:
      * `mix phx.new dine_outside --no-mailer`
    * The following was used to bootstrap the LiveView views:
      * `mix phx.gen.live FoodTruck Location locations location_id:integer applicant:string type:string description:string address:string status:string food_items:string latitude:float longitude:float approved:string`
    * Incremental implementation related to this coding exercise is found in the following modules and functions, ordered as displayed in VS Code project view:
      * `DineOutside.FoodTruck.Filter`.
      * Complete creation `new/1` function in `DineOutside.FoodTruck.Location`.
      * `DineOutside.FoodTruck.Utility`.
      * `DineOutside.FoodTruck` context module functions to `list_filtered_locations/1`, `within_great_circle/3`.
        * The Haversine formula and logic was implemented in `FoodTruck.within_great_circle?/3`.
      * `root_html.heex` to provide navigation links at top right of web page, which uses `Verified Routes` introduced in `Phoenix 1.7`--another requirement mentioned in `Quickstart` by way of the Phoenix version.
      * `DineOutsideWeb.LocationLive.Index`, `mount/3` initializes the Location listing with `changeset`, `form` and `location` assigns.  Also introduced `handle_event/3` functions for `filter` and `validate` events along with supporting private functions to manage `streams` changes and to properly `assign_form`.
      * `index_html.heex` contains a funtion component `simple_form` for the `Filter` feature, including minimal `html` and `class` for look and feel using the included TailwindCSS library.
      * `DineOutsideWeb.Router`, added live actions to root scope.

### Approach to testing for this exercise
  * Data load is performed in `priv/repo/seeds.exs` and does not have any specific tests.
  * Schema and defstruct modules are tested at a higher level of abstraction through their usage in the new context module, live view test, and data load.
  * Incremental support functions outside schema and and defstruct modules relied heavily on `doctest` test cases.
  * `DineOutsideWeb.LocationLiveTest` verified that new `Filter` form is included in generated HTML.
  * Doc tests are not enable for generated doctest examples.
    * Doc test for newly created modules are enabled.

### Candidate feature enhancements

* As implemented the static food truck and cart data is retrieved from the database for each Location listing event: on entry, and on filtering.
  * I would introduce an `:ets` table for global lookup across HTTP sessions of this static data.  The database would then be accessed once to populate `:ets` and all subsequent requests would be served from the reliable, in-VM shared memory solution provided by `:ets`.
* PostgreSQL has a GIS / spatial extension called PostGIS.  This was not considered as part of this solution for two reasons: 
  * It would be overkill, in particular the ST_Geometry data type carries much additional semantics in order to make spatial queries where we simply need `as-the-crow-flies` distance to trucks and carts, and 
  * It implies having to hit the database for a simple spatial query on every WebSocket round trip which is much unnecessary database load.
* The amount of data presented in the Location list view is a product of `unexpected domain data state` that needs to be explained by a SME.  With domain SME guidance, this presentation could be more discrete.  Given what I know at the moment, this is solved by `showing all` of the data.
* Additional filter candidates:
  * `By food items`,
  * `By approval status` as informed by a domain expert,
  * `By type`, e.g., truck or cart.

## Tasks

- [x] Domain model out, let's:
  - [x] Generate a `FoodTruck` context with 
  - [x] `Location` schema to represent what we know about food truck and cart locations
  - [x] `food_items` field needs to be increased in size, from string to text
- [x] Reduce lat-lon precision from sub-micron to 1.1 meters, five decimal places
- [x] Add filter:
  - [x] Haversine distance to truck / cart / service function: `within_great_circle?/3`
  - [x] Add form accepting anchor coordinates and button
  - [x] Use `streams` in LiveComponent, new since `0.18.16`
    - [x] Work out result set changes using `streams` API
- [x] Add links to landing page to access the location live view
- [x] Add Quickstart to README
- [x] Aestheticss and cleanup
  - [x] Trim left margin of index view

## Quickstart

### Erlang/OTP/Elixir and Phoenix versions used / required.

Erlang/OTP/Elixir:
```bash
elixir -v
Erlang/OTP 25 [erts-13.2] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit:ns]

Elixir 1.14.3 (compiled with Erlang/OTP 25)
```

Phoenix Framework, v1.7.2, which includes the necessary LiveView version:
```bash 
mix help | ack phx.new #(snip)
mix phx.new            # Creates a new Phoenix v1.7.2 application
#[snip]
```

### Up and running
This LiveView web UI allows its user to find food trucks and carts within a variable distance of where one is located.  (Use this outline to inform any refinements necessary due to local setup.)

To get up and running:
```bash
# Clone this repository
git clone git@github.com:alanStrait/dine_outside.git
# Get dependencies
cd dine_outside
mix deps.get
# Use docker compose to create a `dine_outside` database 
# (Requires a Docker engine, such as Docker Desktop)
docker-compose up -d
# Create dine_outside_* databases and seed database with CSV data
mix ecto.setup
# Enter `psql` in docker container to run SQL if desired
# see bin/pgpsqlenter.sh for candidate commands to run
bash bin/pgpsqlenter.sh
# Run tests
mix test
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

Notice menu options to link to [Location](http://localhost:4000/locations) live view `index` at top righthand portion of page.

Suggested anchor coordinates to get best filter results, Union Square.
Additional candidates include:
  * Mission District: `{-122.4204, 37.7601}`
  * Union Square:     `{-122.4046, 37.7895}` (Default location in Location listing)
  * Pacific Heights:  `{-122.4346, 37.7932}`
  * Presidio:         `{-122.4662, 37.7985}`
  * SFO University    `{-122.4797, 37.7235}`

Further web app usage suggestions can be found in the `Domain Overview` above.

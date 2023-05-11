#!/bin/bash
## To enter PostgreSQL `psql` within a Docker container
docker exec -it dine_outside psql -U postgres
##
## Within `psql`, a couple of useful commands:
##  \c <database_name>    ## Connect to database
##  \d                    ## View tables
##  \d+ <table_name>      ## Check details of particular table
##  \q                    ## Exit container

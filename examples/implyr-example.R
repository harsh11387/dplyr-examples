# Copyright 2018 Cloudera, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script requires that the Impala ODBC driver is installed on the host
# Modify .odbc.ini and .odbcinst.ini before running

# install packages
if(!"implyr" %in% rownames(installed.packages())) {
  install.packages("implyr")
}
if(!"odbc" %in% rownames(installed.packages())) {
  install.packages("odbc")
}

# load package
library(implyr)

# connect to Impala
drv <- odbc::odbc()
impala <- src_impala(drv = drv, dsn = "Impala DSN")

# read data
flights_impala <- tbl(impala, "flights")

# see object classes
class(flights_impala)

# query using dplyr
flights_impala %>%
  filter(dest %in% c("SJC", "SFO")) %>%
  group_by(origin, dest) %>%
  summarise(
    num_departures = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) %>%
  arrange(avg_dep_delay)

# disconnect from Impala
dbDisconnect(impala)

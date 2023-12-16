# We need to create new users and assign them to main Snowflake Roles 
# We are going to create a new user called Kasun and make him the accountadmin
# AccountAdmin Role
# AccountAdmin - Kasun
# Creae User : Kasun
step_1 = 'use role useradmin;'
step_2 = 'show warehouses;'
step_3 = 'use warehouse compute_wh;'
step_4 = 'select current_role(), current_warehouse();'
step_5 = "CREATE OR REPLACE USER kasun PASSWORD = 'ucsc1234' DEFAULT_ROLE = ACCOUNTADMIN MUST_CHANGE_PASSWORD = FALSE;"
# Assign Kasun the ACCOUNTADMIN Role
# GRANT ROLE ACCOUNTADMIN TO USER kasun;
# Only a user in accountadmin role can grant the role to another user
step_6 = "use role accountadmin;"
step_7 = "select current_role(), current_warehouse();"
step_8 = "GRANT ROLE ACCOUNTADMIN TO USER kasun;"

# Now we are going to create another user called Amali and assign her the Securityadmin Role
# SecurityAdmin Role
# SecurityAdmin - Amali
# Create User : Amali
step_9 = "use role useradmin;"
step_10 = "select current_role(), current_warehouse();"
step_11 = "CREATE or replace USER amali PASSWORD = 'ucsc1234' DEFAULT_ROLE = SECURITYADMIN MUST_CHANGE_PASSWORD = FALSE;"
#GRANT ROLE SECURITYADMIN TO USER amali;
# We need to be part of securityadmin role to provide another user access to that role
step_12 = "use role securityadmin;"
step_13 = "select current_role(), current_warehouse();"
step_14 = "GRANT ROLE SECURITYADMIN TO USER amali;"

# Now we are going to create another user called Yometh and make him part of the Sysadmin Role
# SYSADMIN Role
# SYSADMIN - Yometh
# Create User : Yometh
step_15 = "use role useradmin;"
step_16 = "select current_role(), current_warehouse();"
step_17 = "CREATE or replace user yometh PASSWORD = 'ucsc1234' DEFAULT_ROLE = SYSADMIN MUST_CHANGE_PASSWORD = FALSE;"
#GRANT ROLE SYSADMIN TO USER yometh;
# We need to be part of Sysadmin role or higher to add another user to the same role
step_18 = "use role securityadmin;"
step_19 = "select current_role(), current_warehouse();"
step_20 = "GRANT ROLE SYSADMIN TO USER yometh;"

create_main_roles = [
    step_1,
    step_2,
    step_3,
    step_4,
    step_5,
    step_6,
    step_7,
    step_8,
    step_9,
    step_10,
    step_11,
    step_12,
    step_13,
    step_14,
    step_15,
    step_16,
    step_17,
    step_18,
    step_19,
    step_20,
]




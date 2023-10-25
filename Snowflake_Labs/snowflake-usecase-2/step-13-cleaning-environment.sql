-- Let's now clean the environment
use role useradmin;
use warehouse common_wh;
select current_role(), current_warehouse();
-- Listing down all the users
show users;
-- Deleting the newly created users
drop user kasun;
drop user amali;
drop user yometh;

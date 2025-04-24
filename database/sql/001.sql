-- Set the timezone
set time zone 'UTC';

-- Create an application user
-- Change the password to match what you have set in your environment
do $$
begin
    if not exists (select 1 from pg_roles where rolname = 'app_user') then
        create role app_user login password 'password'; 
    end if;
end $$;

-- Grant privileges to the application user
grant usage on schema public to app_user;
grant select, insert, update, delete on all tables in schema public to app_user;
grant execute on all functions in schema public to app_user;
grant usage on all sequences in schema public to app_user;

-- Set default privileges for future objects
alter default privileges in schema public grant select, insert, update, delete on tables to app_user;
alter default privileges in schema public grant execute on functions to app_user;
alter default privileges in schema public grant usage on sequences to app_user;

-- Create a table for storing user information
create table if not exists users (
    id uuid primary key default gen_random_uuid(),
    firstname varchar(255) not null,
    lastname varchar(255) not null,
    email varchar(255) not null unique,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp
);

-- Create a function to update the updated_at timestamp
create or replace function update_updated_at()
returns trigger as $$
begin
    new.updated_at = current_timestamp;
    return new;
end;
$$ language plpgsql;
-- Create a trigger to call the function before each update
create trigger update_user_updated_at
before update on users
for each row
execute procedure update_updated_at();
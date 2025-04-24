-- Generate some dummy data for testing

insert into users (firstname, lastname, email)
select
  'FirstName' || gs as firstname,
  'LastName' || gs as lastname,
  'user' || gs || '@example.com' as email
from generate_series(1, 100) as gs;

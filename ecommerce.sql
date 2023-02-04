# sqlite_assignment

Database:
The database stores the sample data of an e-commerce aplication. 
Here, the database consists of user,order_details andproducttables that store the information of users, orders placed, and the products on the platform.

here below there are Screenshots of data/tables:

![Screenshot_20230204_110448](https://user-images.githubusercontent.com/124420859/216751004-d469a5b7-830b-45f1-af1b-d81675add5eb.png)
![Screenshot_20230204_110529](https://user-images.githubusercontent.com/124420859/216751007-9c94c152-dc5c-4793-98c5-afdd43d8d963.png)
![Screenshot_20230204_110609](https://user-images.githubusercontent.com/124420859/216751009-8ca3cf3a-859c-4bcb-81b6-ca3a466f4730.png)
![Screenshot_20230204_110637](https://user-images.githubusercontent.com/124420859/216751010-9547bc49-d667-41c5-85fd-a67522785c6b.png)






/* -- 1) Create a view "user_details" to store the following information of the user
id, name, age, gender, pincode  */

CREATE VIEW user_details AS
SELECT
  id,
  name,
  age,
  gender,
  pincode
FROM
  user;
  
  
/*-- 2) Create a view "user_order_details" to store the following information of the users and their orders --*/.

CREATE VIEW user_order_details AS
SELECT
  user.id AS user_id,
  name,
  age,
  gender,
  pincode,
  order_details.order_id AS order_id,
  order_details.total_amount
FROM
  user
  JOIN order_details ON user.id = order_details.customer_id;


/*-- 3) Get the "user_id" and "pincode" of the customers who shopped for more than 50,000 rupees from the location_order_details view present in the database. --*/

SELECT
  user_id,
  pincode,
  sum(total_amount) AS total_amount_spent
FROM
  location_order_details
GROUP BY
  user_id
HAVING
  total_amount_spent > 50000;
  
/* -- 4) Get the rating variance for every product in the database. --*/

SELECT
  name,
  (
    (
      SELECT
        avg(rating)
      FROM
        product
    ) - rating
  ) AS rating_variance
FROM
  product
GROUP BY
  product_id;
  
/*-- 5) Let's now calculate the rating variance of products in the "MOBILE" category. --*/

SELECT
  name,
  (
    (
      SELECT
        avg(rating)
      FROM
        product
      WHERE
        category = "MOBILE"
    ) - rating
  ) AS rating_variance
FROM
  product
WHERE
  category = "MOBILE";
  
  
/*-- 6) Get all the products from the watch category, where rating is greater than average rating --*/

SELECT
  name,
  rating
FROM
  product
WHERE
  rating > (
    SELECT
      avg(rating)
    FROM
      product
  )
  AND category = "WATCH";
  
/* 7) Get the  users where average amount spent by the user is greater than the average amount spent on all the orders on the platform */

SELECT
  customer_id,
  avg(total_amount) AS avg_amount_spent
FROM
  order_details
GROUP BY
  customer_id
HAVING
  avg_amount_spent > (
    SELECT
      avg(total_amount)
    FROM
      order_details
  );

/* -- 8) Get order ids in which order consists of mobile (product_ids: 291, 292, 293, 294, 296) but not screen guard (product_ids: 301, 302, 303, 304) --*/

SELECT
  order_id
FROM
  order_details
WHERE
  order_id IN (
    SELECT
      order_id
    FROM
      order_product
    WHERE
      product_id IN (291, 292, 293, 294, 296)
  )
  AND NOT order_id IN (
    SELECT
      order_id
    FROM
      order_product
    WHERE
      product_id IN (301, 302, 303, 304)
  );


USE sakila;
SHOW TABLES;


# First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customers_info AS
    SELECT 
        c.CUSTOMER_ID,
        c.FIRST_NAME,
        c.LAST_NAME,
        c.EMAIL,
        COUNT(r.RENTAL_ID) AS rental_count
    FROM
        CUSTOMER c
            JOIN
        RENTAL r ON c.CUSTOMER_ID = r.CUSTOMER_ID
    GROUP BY c.CUSTOMER_ID , c.FIRST_NAME , c.LAST_NAME , c.EMAIL;

# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid AS
SELECT 
    p.CUSTOMER_ID, 
    SUM(p.amount) AS total_paid
FROM 
    customers_info ci
JOIN 
    payment p ON ci.CUSTOMER_ID = p.CUSTOMER_ID
GROUP BY 
    p.CUSTOMER_ID;
    

# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


WITH customer_summary AS (
    SELECT 
        ci.CUSTOMER_ID,
        ci.FIRST_NAME, 
        ci.LAST_NAME, 
        ci.EMAIL, 
        ci.rental_count, 
        tp.total_paid
    FROM 
        customers_info ci
    JOIN 
        total_paid tp ON ci.CUSTOMER_ID = tp.CUSTOMER_ID
)


SELECT 
    cs.first_name, 
    cs.last_name, 
    cs.email, 
    cs.rental_count, 
    cs.total_paid,
    (cs.total_paid / cs.rental_count) AS average_payment_per_rental
FROM 
    customer_summary cs;
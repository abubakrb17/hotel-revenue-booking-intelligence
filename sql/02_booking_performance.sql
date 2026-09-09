-- ============================================================
-- Hotel Revenue & Booking Intelligence
-- 02 - Booking Performance Analysis
-- ============================================================


-- ------------------------------------------------------------
-- 1. Overall booking performance
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean;


-- ------------------------------------------------------------
-- 2. Booking performance by hotel
-- ------------------------------------------------------------

SELECT
    hotel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY hotel
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 3. Average lead time
-- ------------------------------------------------------------

SELECT
    ROUND(AVG(lead_time), 2) AS average_lead_time
FROM hotel_bookings_clean;


-- ------------------------------------------------------------
-- 4. Average lead time by hotel
-- ------------------------------------------------------------

SELECT
    hotel,
    ROUND(AVG(lead_time), 2) AS average_lead_time
FROM hotel_bookings_clean
GROUP BY hotel
ORDER BY average_lead_time DESC;


-- ------------------------------------------------------------
-- 5. Average length of stay for successful bookings
-- ------------------------------------------------------------

SELECT
    ROUND(
        AVG(stays_in_weekend_nights + stays_in_week_nights),
        2
    ) AS average_length_of_stay
FROM hotel_bookings_clean
WHERE is_canceled = 0;


-- ------------------------------------------------------------
-- 6. Length of stay by hotel
-- ------------------------------------------------------------

SELECT
    hotel,
    ROUND(
        AVG(stays_in_weekend_nights + stays_in_week_nights),
        2
    ) AS average_length_of_stay,
    MIN(stays_in_weekend_nights + stays_in_week_nights) AS minimum_stay,
    MAX(stays_in_weekend_nights + stays_in_week_nights) AS maximum_stay
FROM hotel_bookings_clean
WHERE is_canceled = 0
GROUP BY hotel
ORDER BY average_length_of_stay DESC;


-- ------------------------------------------------------------
-- 7. Weekend vs weekday nights
-- ------------------------------------------------------------

SELECT
    hotel,
    SUM(stays_in_weekend_nights) AS total_weekend_nights,
    SUM(stays_in_week_nights) AS total_weekday_nights,
    ROUND(AVG(stays_in_weekend_nights), 2) AS avg_weekend_nights,
    ROUND(AVG(stays_in_week_nights), 2) AS avg_weekday_nights
FROM hotel_bookings_clean
WHERE is_canceled = 0
GROUP BY hotel;


-- ------------------------------------------------------------
-- 8. Booking volume by year
-- ------------------------------------------------------------

SELECT
    arrival_date_year,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY arrival_date_year
ORDER BY arrival_date_year;


-- ------------------------------------------------------------
-- 9. Monthly booking performance
-- ------------------------------------------------------------

SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY
    arrival_date_year,
    arrival_date_month
ORDER BY
    arrival_date_year,
    FIELD(
        arrival_date_month,
        'January', 'February', 'March', 'April',
        'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December'
    );

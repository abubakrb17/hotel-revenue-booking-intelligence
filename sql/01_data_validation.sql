-- ============================================================
-- Hotel Revenue & Booking Intelligence
-- 01 - Data Validation
-- ============================================================

-- Check total number of records
SELECT
    COUNT(*) AS total_rows
FROM hotel_bookings_clean;


-- Validate hotel categories
SELECT
    hotel,
    COUNT(*) AS total_bookings
FROM hotel_bookings_clean
GROUP BY hotel
ORDER BY total_bookings DESC;


-- Check for unexpected or missing hotel values
SELECT
    COUNT(*) AS total_rows,
    SUM(hotel = 'Resort Hotel') AS resort_hotel,
    SUM(hotel = 'City Hotel') AS city_hotel,
    SUM(hotel NOT IN ('Resort Hotel', 'City Hotel')) AS other_hotel,
    SUM(hotel IS NULL) AS null_hotel
FROM hotel_bookings_clean;


-- Validate arrival years
SELECT
    arrival_date_year,
    COUNT(*) AS total_bookings
FROM hotel_bookings_clean
GROUP BY arrival_date_year
ORDER BY arrival_date_year;


-- Check ADR range and average
SELECT
    MIN(adr) AS minimum_adr,
    MAX(adr) AS maximum_adr,
    ROUND(AVG(adr), 2) AS average_adr
FROM hotel_bookings_clean;


-- Check cancellation values
SELECT
    is_canceled,
    COUNT(*) AS records
FROM hotel_bookings_clean
GROUP BY is_canceled
ORDER BY is_canceled;


-- Check distinct distribution channels
SELECT
    distribution_channel,
    COUNT(*) AS total_bookings
FROM hotel_bookings_clean
GROUP BY distribution_channel
ORDER BY total_bookings DESC;


-- Check distinct market segments
SELECT
    market_segment,
    COUNT(*) AS total_bookings
FROM hotel_bookings_clean
GROUP BY market_segment
ORDER BY total_bookings DESC;

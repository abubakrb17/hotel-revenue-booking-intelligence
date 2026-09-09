-- ============================================================
-- Hotel Revenue & Booking Intelligence
-- 03 - Cancellation Driver Analysis
-- ============================================================


-- ------------------------------------------------------------
-- 1. Cancellation by market segment
-- ------------------------------------------------------------

SELECT
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY market_segment
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 2. Cancellation by distribution channel
-- ------------------------------------------------------------

SELECT
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY distribution_channel
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 3. Cancellation by deposit type
-- ------------------------------------------------------------

SELECT
    deposit_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY deposit_type
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 4. Cancellation by lead-time group
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN lead_time <= 7 THEN '0-7 days'
        WHEN lead_time <= 30 THEN '8-30 days'
        WHEN lead_time <= 90 THEN '31-90 days'
        WHEN lead_time <= 180 THEN '91-180 days'
        ELSE '181+ days'
    END AS lead_time_group,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY lead_time_group
ORDER BY
    CASE lead_time_group
        WHEN '0-7 days' THEN 1
        WHEN '8-30 days' THEN 2
        WHEN '31-90 days' THEN 3
        WHEN '91-180 days' THEN 4
        WHEN '181+ days' THEN 5
    END;


-- ------------------------------------------------------------
-- 5. New guests vs repeat guests
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN is_repeated_guest = 1 THEN 'Repeat Guest'
        ELSE 'New Guest'
    END AS guest_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY guest_type
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 6. Cancellation by customer type
-- ------------------------------------------------------------

SELECT
    customer_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY customer_type
ORDER BY total_bookings DESC;


-- ------------------------------------------------------------
-- 7. Cancellation by number of special requests
-- ------------------------------------------------------------

SELECT
    total_of_special_requests,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;


-- ------------------------------------------------------------
-- 8. Top guest countries by booking volume
-- ------------------------------------------------------------

SELECT
    country,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    ROUND(
        100.0 * SUM(is_canceled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_bookings_clean
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_bookings DESC
LIMIT 10;

-- ============================================================
-- Hotel Revenue & Booking Intelligence
-- 04 - Revenue Analysis
-- ============================================================


-- ------------------------------------------------------------
-- 1. Overall estimated room revenue
-- Successful bookings only
-- ------------------------------------------------------------

SELECT
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
FROM hotel_bookings_clean;


-- ------------------------------------------------------------
-- 2. Revenue performance by hotel
-- ------------------------------------------------------------

SELECT
    hotel,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    SUM(stays_in_weekend_nights + stays_in_week_nights) AS total_room_nights,
    ROUND(AVG(CASE WHEN is_canceled = 0 AND adr > 0 THEN adr END), 2) AS average_adr,
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
FROM hotel_bookings_clean
GROUP BY hotel
ORDER BY estimated_room_revenue DESC;


-- ------------------------------------------------------------
-- 3. Monthly revenue trend
-- ------------------------------------------------------------

SELECT
    arrival_date_year,
    arrival_date_month,
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
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


-- ------------------------------------------------------------
-- 4. Revenue by market segment
-- ------------------------------------------------------------

SELECT
    market_segment,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    SUM(stays_in_weekend_nights + stays_in_week_nights) AS total_room_nights,
    ROUND(AVG(CASE WHEN is_canceled = 0 AND adr > 0 THEN adr END), 2) AS average_adr,
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
FROM hotel_bookings_clean
GROUP BY market_segment
ORDER BY estimated_room_revenue DESC;


-- ------------------------------------------------------------
-- 5. Revenue by distribution channel
-- ------------------------------------------------------------

SELECT
    distribution_channel,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    SUM(stays_in_weekend_nights + stays_in_week_nights) AS total_room_nights,
    ROUND(AVG(CASE WHEN is_canceled = 0 AND adr > 0 THEN adr END), 2) AS average_adr,
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
FROM hotel_bookings_clean
GROUP BY distribution_channel
ORDER BY estimated_room_revenue DESC;


-- ------------------------------------------------------------
-- 6. Revenue by assigned room type
-- ------------------------------------------------------------

SELECT
    assigned_room_type,
    COUNT(*) - SUM(is_canceled) AS successful_bookings,
    SUM(stays_in_weekend_nights + stays_in_week_nights) AS total_room_nights,
    ROUND(AVG(CASE WHEN is_canceled = 0 AND adr > 0 THEN adr END), 2) AS average_adr,
    ROUND(
        SUM(
            CASE
                WHEN is_canceled = 0
                     AND adr > 0
                     AND (stays_in_weekend_nights + stays_in_week_nights) > 0
                THEN adr * (stays_in_weekend_nights + stays_in_week_nights)
                ELSE 0
            END
        ),
        2
    ) AS estimated_room_revenue
FROM hotel_bookings_clean
GROUP BY assigned_room_type
ORDER BY estimated_room_revenue DESC;

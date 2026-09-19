-- ============================================================
-- Hotel Revenue & Booking Intelligence
-- 01 - Data Validation
-- ============================================================

SELECT
    hotel,
    SUM(CASE WHEN adr = 0 THEN 1 ELSE 0 END) AS zero_rate_bookings,
    SUM(CASE WHEN adr < 0 THEN 1 ELSE 0 END) AS negative_rate_bookings,
    SUM(CASE WHEN adr IS NULL THEN 1 ELSE 0 END) AS missing_rate_bookings
FROM hotel_bookings_clean
WHERE is_canceled = 0
GROUP BY hotel;

SELECT
    booking_id,
    hotel,
    adr,
    stays_in_weekend_nights,
    stays_in_week_nights,
    reservation_status
FROM hotel_bookings_clean
WHERE is_canceled = 0
  AND adr < 0;
  
  SELECT
    hotel,
    COUNT(*) AS zero_rate_bookings,
    SUM(
        CASE
            WHEN stays_in_weekend_nights + stays_in_week_nights > 0
            THEN 1
            ELSE 0
        END
    ) AS zero_rate_bookings_with_nights,
    SUM(
        stays_in_weekend_nights + stays_in_week_nights
    ) AS zero_rate_booking_nights
FROM hotel_bookings_clean
WHERE is_canceled = 0
  AND adr = 0
GROUP BY hotel;

SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS bookings
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

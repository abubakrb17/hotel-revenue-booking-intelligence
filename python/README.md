# Revenue Audit Template

Analyses a hotel-booking CSV and exports:
- A KPI summary
- Cancellation counts and rates by market segment

## Requirements

Python 3. Uses only Python's standard library.

The script currently expects the column names and booking structure
of this project's dataset. Client files require column mapping and
confirmation of what each row represents before use.

## Input

Place the cleaned CSV at:

data/hotel_bookings_clean.csv

## Report settings

Edit these values near the top of python/revenue_audit.py:

REPORT_HOTEL = "City Hotel"
REPORT_START = datetime(2017, 1, 1).date()
REPORT_END = datetime(2017, 8, 31).date()

Dates filter arrivals and include both boundary dates.

## Run

From the project folder:

python3 python/revenue_audit.py

## Validation

The script checks required columns, booking IDs, cancellation flags,
arrival dates, stay nights, and ADR values across the full input file.

It counts zero-night bookings and non-cancelled zero/negative-rate
bookings separately. Generated row IDs do not establish that the
underlying booking records are unique.

Segment booking and cancellation totals must match the report totals.

## Metric definitions

Estimated room revenue = ADR × stay nights for non-cancelled bookings
with positive ADR and positive stay length.

Positive-rate weighted ADR = estimated room revenue divided by
matching qualifying nights.

Cancellation rate = cancelled bookings / all selected bookings × 100.

Revenue is attributed to the arrival period, not allocated night by night.
Currency must be confirmed. Estimates are not verified payments or profit.

## Outputs

Reports are saved in outputs/, with hotel and dates in their filenames:

- *_kpis.csv
- *_segments.csv

Running the same hotel and dates again replaces those report files.
Cancellation rates are stored as percentage values:
30.76 means 30.76%, not 0.3076.
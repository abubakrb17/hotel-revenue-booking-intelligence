from decimal import Decimal, InvalidOperation
from datetime import datetime
import csv
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
INPUT_FILE = PROJECT_ROOT / "data" / "hotel_bookings_clean.csv"

# Change these settings to select the hotel and arrival period.
REPORT_HOTEL = "City Hotel"
REPORT_START = datetime(2017, 1, 1).date()
REPORT_END = datetime(2017, 8, 31).date()

if REPORT_START > REPORT_END:
    raise ValueError("Report start date must not be after the end date.")

print("Input file:", INPUT_FILE)
print("File exists:", INPUT_FILE.is_file())
with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)
    columns = reader.fieldnames
    row_count = sum(1 for row in reader)

print("Columns:", columns)
print("Total rows:", row_count)
REQUIRED_COLUMNS = {
    "booking_id",
    "hotel",
    "is_canceled",
    "arrival_date_year",
    "arrival_date_month",
    "arrival_date_day_of_month",
    "stays_in_weekend_nights",
    "stays_in_week_nights",
    "adr",
    "market_segment",
    "distribution_channel",
    "lead_time",
}

missing_columns = REQUIRED_COLUMNS - set(columns or [])

if missing_columns:
    raise ValueError(
        "Missing required columns: "
        + ", ".join(sorted(missing_columns))
    )

print("Required-column check: PASSED")
seen_ids = set()
missing_id_count = 0
duplicate_id_count = 0

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        booking_id = (row["booking_id"] or "").strip()

        if not booking_id:
            missing_id_count += 1
        elif booking_id in seen_ids:
            duplicate_id_count += 1
        else:
            seen_ids.add(booking_id)

print("Missing booking IDs:", missing_id_count)
print("Duplicate booking ID occurrences:", duplicate_id_count)

if missing_id_count or duplicate_id_count:
    raise ValueError(
        "Booking ID check failed. Investigate before analysing."
    )

print("Booking ID check: PASSED")
invalid_status_count = 0
invalid_status_examples = []

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        status = (row["is_canceled"] or "").strip()

        if status not in {"0", "1"}:
            invalid_status_count += 1

            if len(invalid_status_examples) < 5:
                invalid_status_examples.append(
                    (row["booking_id"], status)
                )

print("Invalid cancellation flags:", invalid_status_count)

if invalid_status_count:
    print("Examples (booking ID, value):", invalid_status_examples)
    raise ValueError(
        "Cancellation flag check failed. Expected only 0 or 1."
    )

print("Cancellation flag check: PASSED")
invalid_date_count = 0
invalid_date_examples = []
earliest_arrival = None
latest_arrival = None

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        date_text = (
            f"{row['arrival_date_year']}-"
            f"{row['arrival_date_month']}-"
            f"{row['arrival_date_day_of_month']}"
        )

        try:
            arrival = datetime.strptime(
                date_text, "%Y-%B-%d"
            ).date()
        except (ValueError, TypeError):
            invalid_date_count += 1

            if len(invalid_date_examples) < 5:
                invalid_date_examples.append(
                    (row["booking_id"], date_text)
                )
            continue

        if earliest_arrival is None or arrival < earliest_arrival:
            earliest_arrival = arrival

        if latest_arrival is None or arrival > latest_arrival:
            latest_arrival = arrival

print("Invalid arrival dates:", invalid_date_count)

if invalid_date_count:
    print("Examples:", invalid_date_examples)
    raise ValueError("Arrival date check failed.")

print("Earliest arrival:", earliest_arrival)
print("Latest arrival:", latest_arrival)
print("Arrival date check: PASSED")

invalid_night_count = 0
zero_night_count = 0
invalid_night_examples = []

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        try:
            weekend_nights = int(row["stays_in_weekend_nights"])
            week_nights = int(row["stays_in_week_nights"])

            if weekend_nights < 0 or week_nights < 0:
                raise ValueError("Negative stay nights")

        except (ValueError, TypeError):
            invalid_night_count += 1

            if len(invalid_night_examples) < 5:
                invalid_night_examples.append(
                    (
                        row["booking_id"],
                        row["stays_in_weekend_nights"],
                        row["stays_in_week_nights"],
                    )
                )
            continue

        if weekend_nights + week_nights == 0:
            zero_night_count += 1

print("Bookings with invalid stay nights:", invalid_night_count)
print("Zero-night bookings (all statuses):", zero_night_count)

if invalid_night_count:
    print("Examples:", invalid_night_examples)
    raise ValueError("Stay-night check failed.")

print("Stay-night check: PASSED")

invalid_adr_count = 0
zero_rate_count = 0
negative_rate_count = 0

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        try:
            adr = Decimal((row["adr"] or "").strip())

            if not adr.is_finite():
                raise ValueError("ADR must be finite")

        except (InvalidOperation, ValueError):
            invalid_adr_count += 1
            continue

        if row["is_canceled"].strip() == "0":
            if adr == 0:
                zero_rate_count += 1
            elif adr < 0:
                negative_rate_count += 1

print("Missing or invalid ADR (all bookings):", invalid_adr_count)
print("Zero ADR (non-cancelled bookings):", zero_rate_count)
print("Negative ADR (non-cancelled bookings):", negative_rate_count)

if invalid_adr_count:
    raise ValueError("Investigate missing or invalid ADR before analysing.")

print("ADR check: PASSED — rate exceptions counted separately")

total_bookings = 0
cancelled_bookings = 0
eligible_nights = 0
estimated_revenue = Decimal("0")
segment_totals = {}

with INPUT_FILE.open(
    "r", newline="", encoding="utf-8-sig"
) as infile:
    reader = csv.DictReader(infile)

    for row in reader:
        arrival = datetime.strptime(
            f"{row['arrival_date_year']}-"
            f"{row['arrival_date_month']}-"
            f"{row['arrival_date_day_of_month']}",
            "%Y-%B-%d"
        ).date()

        # Skip bookings outside the selected hotel and arrival period.
        if row["hotel"].strip() != REPORT_HOTEL:
            continue
        if not REPORT_START <= arrival <= REPORT_END:
            continue

        total_bookings += 1

        is_canceled = int(row["is_canceled"])
        adr = Decimal(row["adr"].strip())
        nights = (
            int(row["stays_in_weekend_nights"])
            + int(row["stays_in_week_nights"])
        )

        cancelled_bookings += is_canceled
        segment = (row["market_segment"] or "").strip() or "Unknown"

        if segment not in segment_totals:
            segment_totals[segment] = {
                "total_bookings": 0,
                "cancelled_bookings": 0,
            }

        segment_totals[segment]["total_bookings"] += 1
        segment_totals[segment]["cancelled_bookings"] += is_canceled

        if is_canceled == 0 and adr > 0 and nights > 0:
            eligible_nights += nights
            estimated_revenue += adr * nights

if total_bookings == 0:
    raise ValueError("No bookings match the selected hotel and arrival period.")

cancellation_rate = (
    Decimal(cancelled_bookings) / Decimal(total_bookings) * 100
)

print(f"\nREPORT KPIs — {REPORT_HOTEL}")
print(f"Arrival period: {REPORT_START} to {REPORT_END}")
print(f"Total bookings: {total_bookings:,}")
print(f"Cancellation rate: {cancellation_rate:.2f}%")
print(f"Positive-rate booking nights: {eligible_nights:,}")
print(f"Estimated room revenue: {estimated_revenue:,.2f}")

if eligible_nights > 0:
    weighted_adr = estimated_revenue / Decimal(eligible_nights)
    print(f"Positive-rate weighted ADR: {weighted_adr:.2f}")
else:
    print("Positive-rate weighted ADR: unavailable — no qualifying nights")

OUTPUT_DIR = PROJECT_ROOT / "outputs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

hotel_slug = REPORT_HOTEL.lower().replace(" ", "_")
output_file = OUTPUT_DIR / (
    f"{hotel_slug}_{REPORT_START}_{REPORT_END}_kpis.csv"
)

report_row = {
    "hotel": REPORT_HOTEL,
    "arrival_period_start": REPORT_START.isoformat(),
    "arrival_period_end": REPORT_END.isoformat(),
    "total_bookings": total_bookings,
    "cancelled_bookings": cancelled_bookings,
    "cancellation_rate_pct": f"{cancellation_rate:.2f}",
    "positive_rate_booking_nights": eligible_nights,
    "estimated_room_revenue": f"{estimated_revenue:.2f}",
    "positive_rate_weighted_adr": (
        f"{estimated_revenue / Decimal(eligible_nights):.2f}"
        if eligible_nights > 0
        else ""
    ),
}

with output_file.open(
    "w", newline="", encoding="utf-8"
) as outfile:
    writer = csv.DictWriter(
        outfile,
        fieldnames=list(report_row.keys())
    )
    writer.writeheader()
    writer.writerow(report_row)

print("Report exported:", output_file)

print("\nCANCELLATIONS BY MARKET SEGMENT")

for segment, totals in sorted(segment_totals.items()):
    rate = (
        Decimal(totals["cancelled_bookings"])
        / Decimal(totals["total_bookings"])
        * 100
    )

    print(
        f"{segment}: "
        f"{totals['total_bookings']:,} bookings, "
        f"{totals['cancelled_bookings']:,} cancelled, "
        f"{rate:.2f}%"
    )
segment_booking_total = sum(
    totals["total_bookings"]
    for totals in segment_totals.values()
)

segment_cancelled_total = sum(
    totals["cancelled_bookings"]
    for totals in segment_totals.values()
)

if segment_booking_total != total_bookings:
    raise ValueError(
        "Segment booking totals do not match the report total."
    )

if segment_cancelled_total != cancelled_bookings:
    raise ValueError(
        "Segment cancellation totals do not match the report total."
    )

print("Segment reconciliation: PASSED")

# Your existing segment export starts below:
segment_output_file = OUTPUT_DIR / (
    f"{hotel_slug}_{REPORT_START}_{REPORT_END}_segments.csv"
)

segment_columns = [
    "hotel",
    "arrival_period_start",
    "arrival_period_end",
    "market_segment",
    "total_bookings",
    "cancelled_bookings",
    "cancellation_rate_pct",
]

with segment_output_file.open(
    "w", newline="", encoding="utf-8"
) as outfile:
    writer = csv.DictWriter(outfile, fieldnames=segment_columns)
    writer.writeheader()

    for segment, totals in sorted(segment_totals.items()):
        rate = (
            Decimal(totals["cancelled_bookings"])
            / Decimal(totals["total_bookings"])
            * 100
        )

        writer.writerow({
            "hotel": REPORT_HOTEL,
            "arrival_period_start": REPORT_START.isoformat(),
            "arrival_period_end": REPORT_END.isoformat(),
            "market_segment": segment,
            "total_bookings": totals["total_bookings"],
            "cancelled_bookings": totals["cancelled_bookings"],
            "cancellation_rate_pct": f"{rate:.2f}",
        })

print("Segment report exported:", segment_output_file)
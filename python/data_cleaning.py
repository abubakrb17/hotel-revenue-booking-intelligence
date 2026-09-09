"""
Hotel Revenue & Booking Intelligence
Data Cleaning Script

Purpose:
Prepare the hotel bookings dataset for SQL analysis
and Tableau visualization.
"""

import csv
from pathlib import Path


# ------------------------------------------------------------
# File paths
# ------------------------------------------------------------

INPUT_FILE = Path("data/hotel_bookings.csv")
OUTPUT_FILE = Path("data/hotel_bookings_clean.csv")


# ------------------------------------------------------------
# Clean dataset and generate booking ID
# ------------------------------------------------------------

def clean_hotel_bookings(input_file, output_file):
    """
    Read the raw hotel bookings CSV, clean whitespace,
    generate a unique booking_id, and save a cleaned CSV.
    """

    with open(input_file, "r", newline="", encoding="utf-8") as infile, \
         open(output_file, "w", newline="", encoding="utf-8") as outfile:

        reader = csv.DictReader(infile)

        fieldnames = ["booking_id"] + reader.fieldnames

        writer = csv.DictWriter(
            outfile,
            fieldnames=fieldnames
        )

        writer.writeheader()

        booking_count = 0

        for booking_id, row in enumerate(reader, start=1):

            clean_row = {
                "booking_id": booking_id
            }

            for key, value in row.items():
                clean_row[key] = value.strip() if value else ""

            writer.writerow(clean_row)

            booking_count += 1

    print(f"Created: {output_file}")
    print(f"Bookings written: {booking_count}")


# ------------------------------------------------------------
# Run script
# ------------------------------------------------------------

if __name__ == "__main__":

    clean_hotel_bookings(
        INPUT_FILE,
        OUTPUT_FILE
    )

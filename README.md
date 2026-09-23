# Hotel Revenue& Booking Intelligence

## Project Overview

Hotel Revenue & Booking Intelligence analyses **119,390 hotel booking records**, with arrival dates from **July 2015 to August 2017**.

The project uses Python, MySQL/SQL, and Tableau to investigate estimated room revenue, booking patterns, cancellations, and data quality. It demonstrates how booking data can support a **Revenue Performance Audit** with executive KPIs, evidence-based findings, and proposed management actions.

The portfolio includes:

- **Executive Performance Overview** dashboard
- **Booking & Cancellation Drivers** dashboard
- **Online TA Cancellation by Lead Time** worksheet
- A three-page sample audit
- Eight portfolio images

This is a historical portfolio demonstration, not a paid client engagement. Recommendations have not been implemented at the hotels.

## Sample Audit and Portfolio

- [Read the three-page sample audit](reports/Hotel%20Revenue%20Performance%20Audit.pdf)
- [View the portfolio images](images/audit/)

The audit compares **January–August 2017 arrivals with January–August 2016 arrivals**. Its data-quality review covers the full dataset.

## Business Questions

- How did estimated room revenue change between matching arrival periods?
- Were revenue changes accompanied by changes in qualifying booking nights, weighted ADR, or both?
- How did cancellation rates change by hotel and market segment?
- Which distribution channels contributed the most estimated room revenue?
- How did Online TA cancellation rates vary by booking lead time?
- Which assigned room types contributed the most estimated revenue?
- How were special requests associated with cancellation rates?
- Which rate records required clarification before interpretation?

## Full-Dataset KPIs

**Scope: July 2015–August 2017 arrivals.** These totals cover different dates from the sample audit’s comparison period.

| KPI | Result |
|---|---:|
| Total bookings | 119,390 |
| Cancellation rate | 37.04% |
| Estimated room revenue | 25,996,324.21 |
| Positive-rate booking nights | 252,259 |
| Positive-rate weighted ADR | 103.05 |
| Average recorded stay length — non-cancelled bookings | 3.39 nights |

Currency remains unverified; no currency symbol is assigned.

## January–August Performance Comparison

| Metric | City 2016 | City 2017 | Resort 2016 | Resort 2017 |
|---|---:|---:|---:|---:|
| Total bookings | 24,450 | 27,508 | 12,346 | 13,179 |
| Estimated room revenue | 4,462,390.10 | 5,637,958.64 | 3,502,652.61 | 4,173,305.03 |
| Positive-rate booking nights | 42,917 | 47,763 | 35,944 | 38,434 |
| Positive-rate weighted ADR | 103.97 | 118.04 | 97.44 | 108.58 |
| Cancellation rate | 38.70% | 42.50% | 26.78% | 30.76% |

Estimated room revenue increased by **26.34% at City Hotel** and **19.15% at Resort Hotel**. Both hotels recorded more qualifying booking nights and higher positive-rate weighted ADR.

Cancellation rates also increased by **3.80 percentage points at City Hotel** and **3.98 percentage points at Resort Hotel**.

## Metric Definitions and Limitations

- **Estimated room revenue:** ADR multiplied by recorded stay nights, summed for non-cancelled bookings with positive ADR and positive stay length.
- **Positive-rate booking nights:** Recorded nights from bookings meeting those same conditions.
- **Positive-rate weighted ADR:** Estimated room revenue divided by matching positive-rate booking nights. It is not a simple average of booking-level ADR values.
- **Cancellation rate:** Cancelled bookings divided by all bookings in the selected arrival period.
- **Average recorded stay length:** Average weekend plus weekday nights among non-cancelled bookings. Zero-night records remain included.

Revenue is grouped by **arrival month**: the full estimated stay value is assigned to that month, including stays crossing month boundaries. It is not a nightly allocation of revenue.

Revenue estimates do not establish payments collected, profit, or losses caused by cancellations. Occupancy and RevPAR are not calculated because available room inventory has not been established.

Whole-year totals for 2015, 2016, and 2017 are not directly comparable: the dataset contains six, twelve, and eight arrival months, respectively. The sample audit uses matching January–August periods in 2016 and 2017.

## Dashboard Features

### Executive Performance Overview

- Total bookings and cancellation rate
- Estimated room revenue
- Positive-rate weighted ADR
- Average recorded stay length for non-cancelled bookings
- Estimated room revenue by arrival month
- Estimated room revenue by market segment
- Cancellation rate by market segment
- Hotel and year filters

### Booking & Cancellation Drivers

- Estimated room revenue by distribution channel
- Cancellation rate by distribution channel
- Estimated room revenue by assigned room type
- Special requests versus cancellation rate
- Hotel and year filters
- Navigation to the executive overview

The dashboard comparison scope is **January–August arrivals in 2016 or 2017**.

### Online TA Cancellation by Lead Time

Bookings are grouped into:

- 0–7 days before arrival
- 8–30 days
- 31–90 days
- Over 90 days

Tooltips display total bookings, cancelled bookings, and cancellation rates. The portfolio images show January–August 2017 arrivals separately for each hotel.

## Key Findings

### Revenue grew alongside qualifying nights and rates

For January–August arrivals, both hotels recorded higher estimated room revenue in 2017 than in 2016. Growth was accompanied by increases in qualifying booking nights and positive-rate weighted ADR. This does not establish higher profit or occupancy.

### Online TA cancellations warrant investigation

City Hotel’s Online TA cancellation rate increased from **34.12% to 41.08%**, while Resort Hotel’s increased from **33.56% to 40.37%**, comparing January–August 2016 and 2017.

Online TA booking volume also increased at both hotels, making this segment a priority for further investigation.

### Longer-lead Online TA bookings had higher cancellation rates

For January–August 2017 arrivals:

| Booking lead time | City Hotel | Resort Hotel |
|---|---:|---:|
| 0–7 days | 9.43% | 7.60% |
| 8–30 days | 35.19% | 30.45% |
| 31–90 days | 41.67% | 43.72% |
| Over 90 days | 48.94% | 55.05% |

The over-90-day groups recorded **3,608 cancellations at City Hotel** and **1,620 at Resort Hotel**.

These are observed associations, not proof that longer lead times cause cancellations. Further review should examine cancellation timing and booking conditions.

### Rate records require clarification

Across the full dataset’s non-cancelled bookings:

- **1,746 bookings** had zero ADR, representing **2,771 recorded nights**.
- **One booking** had negative ADR: booking **14970**, Resort Hotel, with ADR **−6.38** and a **10-night stay**.
- No missing ADR values were identified by the SQL NULL check.

Zero-rate and negative-rate records are excluded from positive-rate metrics while the original records remain unchanged. Their causes have not been verified.

## Proposed Management Actions

- **Days 1–30:** Clarify rate exceptions, confirm currency, and establish cancellation baselines by hotel and lead-time group.
- **Days 31–60:** With management approval, test one targeted operational change and track outcomes against a comparable group.
- **Days 61–90:** Review available evidence and establish monthly performance reporting. Continue monitoring where bookings have not yet reached their arrival dates.

These actions are proposals, not completed interventions or guarantees of improvement.

## Project Workflow

1. **Data preparation:** Used Python to remove unnecessary whitespace and generate booking IDs.
2. **Data validation:** Checked booking fields, rate exceptions, arrival-date coverage, and reporting-period boundaries.
3. **Analysis:** Used MySQL/SQL to calculate KPIs, compare matching periods, and investigate cancellation patterns.
4. **Reconciliation:** Matched Tableau results to SQL outputs and explained differences between total non-cancelled nights and positive-rate nights.
5. **Visualisation:** Updated dashboards with consistent calculations, filters, labels, and tooltips.
6. **Communication:** Produced a sample audit containing executive KPIs, key findings, limitations, and proposed actions.

## Repository Structure

```text
hotel-revenue-booking-intelligence/
├── images/
│   └── audit/    # Eight portfolio images
├── python/       # Data preparation script
├── reports/      # Three-page sample audit PDF
├── sql/          # Validation and analytical queries
├── tableau/      # Tableau Public dashboard link
└── README.md     # Project documentation
```

## Technology Stack

**Python · SQL · MySQL · Tableau Public · GitHub**

## Author

**Aboubacar Bah**  
Junior BI & Data Analyst | Hospitality & Customer Analytics

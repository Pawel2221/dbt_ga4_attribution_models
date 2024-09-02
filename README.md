

### dbt_ga4_attribution_models

The `dbt_ga4_attribution_models` portfolio project was created to address the need for better analysis of traffic sources that drive key conversions on websites, such as placing an order (for eCommerce) or submitting a form (for B2B). 

By utilizing custom-developed attribution models, the project aims to determine how much credit each marketing channel should receive for these conversions, providing a more accurate and insightful analysis of what truly drives customer actions.

### Technologies

Project Technology Stack:
- Google Analytics 4 - raw data export directly into BigQuery.
- dbt (Core) - data transformation and modeling within the analytics workflow.
- Google Cloud Platform (BigQuery) - primary data warehouse, facilitating scalable storage and analysis of the data.

### What is attribution (marketing)?

Marketing attribution determines which marketing activities (like ads, emails, or social media) had the most impact on a customer’s decision to make a purchase.

For example, a customer sees a Google Ad for shoes, clicks a Meta Ad, and then buys after visiting the site directly:

- First-Click: Conversion credit goes to the Google Ad, the first interaction.
- Last Click Non-Direct: Conversion credit goes to the Meta Ad, the last interaction before the direct visit.
- Linear: Conversion credit is evenly distributed among the Google Ad, Meta Ad, and direct interaction.

In this project, these three attribution models were used to demonstrate how credit can be assigned. However, companies can develop their own custom attribution models tailored to their specific needs.

### Quick Start

The dbt models are organized into the following folders, in this order: 

`staging -> source -> transformed -> attribution_model -> explore`

Models are also referring to the macros (`ga4_select.sql`, `ga4_unnest_key.sql`, `ga4_utm_mapping.sql`)

### Desired outcome

The goal is to create a ready-to-visualize table, `attribution_explore`, that evaluates the effectiveness of various marketing channels using custom-developed attribution models.

These models determine how much credit each channel should receive for key conversions, such as placing an order (for eCommerce) or submitting a form (for B2B). The table supports data-driven decision-making by offering clear insights into the contribution of each marketing source toward these conversion outcomes.

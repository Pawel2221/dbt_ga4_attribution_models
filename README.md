

### dbt_ga4_attribution_models

`dbt_ga4_attribution_models` is a portfolio project developed in response to a recognized need within the marketing industry for improved analysis of traffic sources that drive users to websites.


### Technologies

Tech stack used in the project:

- Google Analytics 4 raw data export to BigQuery
- dbt (Core)
- Google Cloud Platform (BigQuery)

### What is attribution (marketing)?

Attribution in marketing is the process of determining which specific marketing efforts—such as ads, emails, or social media interactions—had the most significant impact on a customer's decision to make a purchase.

Consider a scenario where a customer first encounters a Google ad for a pair of shoes, then clicks on a Meta ad from the same retailer, and finally makes the purchase after a direct interaction. Attribution helps to determine which source should receive credit for the conversion. In this project, three attribution models were used: First-Click, Last Click Non-Direct, and Linear. Here’s how each model would attribute the conversion:

- First-Click: The credit for the purchase would be assigned to the Google Ad, as it was the first interaction that started the customer’s journey.

- Last Click Non-Direct: The credit would be assigned to the Meta Ad, as it was the last interaction before the direct visit, which is excluded in this model.

- Linear: The credit would be distributed evenly among the Google ad, Meta ad, and the direct interaction, acknowledging the role each played in the customer's path to purchase.

### Quick Start

A more comprehensive overview of the project process is provided in the video below:

### Desired outcome

The objective of this project is to develop a ready-to-visualize table `attribution_explore`, facilitating the evaluation of the effectiveness of marketing traffic sources. This evaluation leverages custom-developed attribution models aimed at enhancing the understanding and optimization of marketing channel performance. The table is designed to support data-driven decision-making by offering clear insights into the contribution of each source towards key conversion outcomes.

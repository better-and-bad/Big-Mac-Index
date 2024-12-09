# Big-Mac-Index

![pic2](https://github.com/user-attachments/assets/0920517d-68e9-4c2a-847b-0118048fb752)

# Big Mac Index Analysis

This repository contains the data and R scripts used for the analysis in the article on the Big Mac Index. The Big Mac Index, created and distributed by **The Economist**, is a tool for understanding currency valuation through purchasing power parity (PPP). This repository also includes supplemental data from the **Penn World Table** to provide a broader context for income comparisons across countries.

---

## **Data Sources**
### **1. Big Mac Index**
The Big Mac Index data is sourced from **The Economist**, which originally developed it as a lighthearted way to understand PPP and currency valuation. You can explore their latest updates and methodology on their [github repo](https://github.com/TheEconomist/big-mac-data).

### **2. Penn World Table**
The Penn World Table dataset provides detailed income and economic indicators for cross-border comparisons. [This data](https://www.rug.nl/ggdc/productivity/pwt/?lang=en) supplements the Big Mac Index by offering stable, multi-year PPP-adjusted income data.

---

## Big Mac Data Key

This codebook largely applies to all three files. The exception is the variables suffixed `_raw` or `_adjusted`—these appear (with suffixes) in the "full" file but without suffixes in the respective ("raw" or "adjusted") files.

| **Variable**      | **Definition**                                     | **Source**               |
|--------------------|---------------------------------------------------|--------------------------|
| `date`            | Date of observation                               |                          |
| `iso_a3`          | Three-character ISO 3166-1 country code           |                          |
| `currency_code`   | Three-character ISO 4217 currency code            |                          |
| `name`            | Country name                                      |                          |
| `local_price`     | Price of a Big Mac in the local currency           | McDonalds; The Economist |
| `dollar_ex`       | Local currency units per dollar                   | Reuters                  |
| `dollar_price`    | Price of a Big Mac in dollars                     |                          |
| `USD_raw`         | Raw index, relative to the US dollar              |                          |
| `EUR_raw`         | Raw index, relative to the Euro                   |                          |
| `GBP_raw`         | Raw index, relative to the British pound          |                          |
| `JPY_raw`         | Raw index, relative to the Japanese yen           |                          |
| `CNY_raw`         | Raw index, relative to the Chinese yuan           |                          |
| `GDP_dollar`      | GDP per person, in dollars                        | IMF                      |
| `adj_price`       | GDP-adjusted price of a Big Mac, in dollars       |                          |
| `USD_adjusted`    | Adjusted index, relative to the US dollar         |                          |
| `EUR_adjusted`    | Adjusted index, relative to the Euro              |                          |
| `GBP_adjusted`    | Adjusted index, relative to the British pound     |                          |
| `JPY_adjusted`    | Adjusted index, relative to the Japanese yen      |                          |
| `CNY_adjusted`    | Adjusted index, relative to the Chinese yuan      |                          |

---

## **Usage**
### **1. Running the Analysis**
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/big-mac-index-analysis.git

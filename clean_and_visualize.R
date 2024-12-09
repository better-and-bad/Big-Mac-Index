### BIG MAC INDEX ###
rm(list=ls())
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)

### upload data
### july 2024
big_mac <- read_csv("/Users/jackconnors/Downloads/big-mac-full-index.csv")

### inspect data
glimpse(big_mac)

skimr::skim(big_mac)

### Argentina's uundervalued peso
### dollar_price is the Big Mac PPP adjusted local_price
### so dollar price doesn't rep the market rate
big_mac %>% 
  group_by(date) %>% 
  mutate(usd = local_price[iso_a3=="USA"]) %>% 
  ungroup() %>% 
  filter(name == "Argentina") %>% 
  mutate(usd_peso = usd * dollar_ex) %>%
  ggplot(aes(date, local_price, color = "Arg. Peso")) +
  geom_line(size=2) +
  geom_line(aes(y=usd_peso, color="USD Adjusted"), size=2) +
  labs(title = "Argentina's Hyper-Inflation", y = "Local Price in Pesos",
       x = "", caption = "Source: Big Mac Index") +
  theme_minimal() +
  scale_x_date(breaks = "5 years", date_labels = "%Y") +
  scale_y_continuous(labels = scales::number_format()) +
  theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        axis.title = element_text(size=15, face="bold"),
        axis.text = element_text(size=15, face="bold"),
        plot.caption = element_text(size=14),
        legend.title = element_blank(),
        legend.text = element_text(size=14)) +
  guides(color = guide_legend(override.aes = list(linewidth = 6))
  )

### questions to ask
### 1) how much is this increase in dollars big_mac adjusted?
big_mac_full <-  big_mac %>% 
  group_by(date) %>% 
  mutate(usd = local_price[iso_a3=="USA"]) %>% 
  ungroup() 

### big mac ex rate
### peso : $
arg_bmi <- big_mac_full %>% 
  filter(name == "Argentina") %>% 
  mutate(bmi = local_price / usd,
         bmi_adjusted_dollars = local_price / bmi) %>% 
  select(date, bmi_adjusted_dollars, bmi, local_price, usd)

### determine inflation in the arg big mac
big_mac_full %>% 
  filter(date %in% as.Date(c("2024-07-01", "2019-01-01")) &
           name == "Argentina") %>% 
  mutate(inf_rate = ((local_price - lag(local_price))/ lag(local_price))*100) %>% 
  select(date, inf_rate, local_price)
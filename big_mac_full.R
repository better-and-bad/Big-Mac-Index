

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
  
### under valued currencies
  big_mac %>% 
    group_by(date) %>% 
    mutate(usd = local_price[iso_a3=="USA"]) %>% 
    ungroup() %>% 
    filter(name == "Argentina") %>% 
    mutate(big_mac_ppp = local_price / usd,
           other_rate = local_price/dollar_price) %>% 
    select(big_mac_ppp, other_rate, local_price, usd, dollar_price, dollar_ex)
  
  ### plot undervalued currencies
 big_mac_full %>% 
   filter(date == as.Date("2024-07-01")) %>% 
   group_by(date, name) %>% 
    mutate(big_mac_ppp = local_price / usd,
           relative_value = (big_mac_ppp - dollar_ex) / dollar_ex) %>% 
   ungroup() %>% 
   mutate(name = forcats::fct_reorder(name, relative_value)) %>% 
    ggplot(aes(name, relative_value)) +
    geom_col(aes(fill=name)) +
   coord_flip() +
   guides(fill="none") +
   theme_minimal() +
   labs(title="Under Valued Currencies", subtitle = "June 2024", y="%", x="",
        caption = "Source: Big Mac Index") +
   theme(
     plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
     axis.text.y = element_text(size=13, face="bold"),
     axis.text = element_text(size=15, face="bold"),
     plot.subtitle = element_text(size = 18, face = "bold", hjust = 0.5),
     plot.caption = element_text(size=12),
     axis.title= element_text(size=16, face='bold'),
     legend.title = element_blank()
     )
  
 
 ### gdp per cap and over valuation
 ### gdp big mac is gdp per cap?
 big_mac_full %>% 
   filter(date == as.Date("2024-07-01")) %>% 
   group_by(date, name) %>% 
   mutate(big_mac_ppp = local_price / usd,
          relative_value = ((big_mac_ppp - dollar_ex) / dollar_ex)*100) %>% 
   ggplot(aes(GDP_bigmac, relative_value)) +
   geom_point() +
   scale_x_continuous(labels=scales::dollar_format()) +
   ggrepel::geom_text_repel(aes(label=name)) +
   geom_smooth(aes(GDP_bigmac, relative_value), se=F) +
   theme_minimal() +
   labs(title="Poorer Countries are Under Valued", subtitle="The Penn Effect - July 2024",
        y="Under Valuation (%)", x=" GDP per Person",
        caption = "Source: Big Mac Index") +
   theme(
     plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
     axis.text.y = element_text(size=13, face="bold"),
     axis.text = element_text(size=15, face="bold"),
     plot.subtitle = element_text(size = 18, face = "bold", hjust = 0.5),
     plot.caption = element_text(size=12),
     axis.title= element_text(size=16, face='bold'),
     legend.title = element_blank()
   )
 
 

 #### icp v bmi facet plot
 ### upload pwi data
 pwt <- readxl::read_excel("/Users/jackconnors/Downloads/pwt1001.xlsx",
                           sheet="Data")
 
 ### convert units to dollars per capita
pwt_clean <- pwt %>% 
  rename(name = country) %>% 
  mutate(
    cgdpo_actual = cgdpo * 1e6,  # Convert GDP to actual dollars
    pop_actual = pop * 1e6,      # Convert population to actual count
    pwt_gdp_cap = cgdpo_actual / pop_actual  # Recalculate GDP per capita
  ) %>%
  ungroup() %>% 
  select(year, name, cgdpo_actual, pop_actual, pwt_gdp_cap) %>% 
  mutate(name = case_when(
    name == "United Kingdom" ~ "Britain",
    TRUE ~ name))


### i need to annualize gdp per cap in big mac
big_mac_annual_gdp <- big_mac %>% 
  mutate(year = lubridate::year(date)) %>% 
  group_by(name, year) %>% 
  reframe(gdp_cap = mean(GDP_bigmac, na.rm = T)) %>% 
  drop_na()

countries <- c("United States", "Britain", "Brazil", "Argentina", "Japan",
               "China", "Saudi Arabia", "Sweden", "Switzerland")

### merge two data frames
big_mac_annual_gdp %>%
  left_join(pwt_clean, by = c("year", "name")) %>%
  mutate(year = as.Date(paste0(year, "-01-01"))) %>%
  filter(name %in% countries) %>% 
  ggplot() +
  geom_line(aes(year, gdp_cap, color = "Big Mac GDP per person"), size=1) +
  geom_line(aes(year, pwt_gdp_cap, color = "PWT GDP per person"), size=1) +
  facet_wrap(~name, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar_format()) +
  scale_x_date(breaks = "5 years", date_labels = "%y") +
  theme_minimal() +
  labs(title = "A Difference of Perspective", subtitle="2000-2024",
       y = "", x = "", 
       caption = "Source: Big Mac Index, Penn World Table") + 
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    axis.text.x = element_blank(),
    axis.text = element_text(size=9, face="bold"),
    plot.subtitle = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.caption = element_text(size=10),
    legend.title = element_blank(),
    strip.text = element_text(face="bold")
  ) +
  guides(color = guide_legend(override.aes = list(linewidth = 6))
  )

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
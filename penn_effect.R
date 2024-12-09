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
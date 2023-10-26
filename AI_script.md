# Generative AI script

Me: what are marsupials ?

ChatGPT: Marsupials are a group of mammals characterized by giving birth to relatively undeveloped live young, which then continue to develop outside the womb, typically in a pouch on the mother's belly. The defining feature of marsupials is the presence of this pouch, also known as a marsupium, which is used for protecting and nourishing the developing offspring.

Marsupials are a diverse group that includes well-known animals such as kangaroos, wallabies, koalas, and wombats. They are most commonly associated with Australia, as the continent has the greatest diversity of marsupial species. However, marsupials are not exclusive to Australia; they can also be found in other parts of the world, including the Americas. Some famous American marsupials include opossums and the sugar glider.

The marsupial reproductive system is different from that of placental mammals, such as humans and dogs, where the offspring develop fully inside the mother's womb and are nourished through a placenta. In marsupials, after a short gestation period, the underdeveloped young are born and continue to grow and nurse in the pouch until they are more mature and can survive on their own. This unique reproductive strategy has evolved in marsupials to suit various ecological niches and environmental conditions.


Me: are woylies marsupial ?

ChatGPT: Yes, woylies are indeed marsupials. The woylie, also known as the brush-tailed bettong (Bettongia penicillata), is a small marsupial that is native to Australia. It is part of the kangaroo family (Macropodidae) and possesses the characteristic marsupial features, including giving birth to undeveloped live young, which then continue to develop in a pouch on the mother's belly.

Woylies are known for their distinctive bushy tails, which they use for balance and stability as they hop through their natural habitat. They were once more widely distributed across parts of Australia but have faced population declines and habitat loss in recent years, making them a subject of conservation concern.

Me: set tsibble interval to quarter for the following:

woylie_tsibble <- woylie_narrabri_grouped %>%
  as_tsibble(key = Total_sightings, index = eventDate)
  
ChatGPT: To set the `tsibble` interval to quarterly for the `woylie_tsibble` object, you can use the `quarterly()` function from the `lubridate` package to specify the desired interval. Here's how you can do it:

```R
library(lubridate)
library(tsibble)

woylie_tsibble <- woylie_narrabri_grouped %>%
  as_tsibble(key = Total_sightings, index = eventDate) %>%
  index_by(quarter = quarterly(eventDate))
```

In the code above, we first load the `lubridate` and `tsibble` libraries. Then, we use the `%>%` operator to pipe the `woylie_narrabri_grouped` data into the `as_tsibble` function to create the initial `tsibble` object. Finally, we use the `index_by` function to set the interval to quarterly, specifying the `quarter` column created using `quarterly(eventDate)` as the new index.


Me: woylie_tsibble <- woylie_narrabri_grouped %>%
  as_tsibble(key = Total_sightings, index = eventDate) 

include missing dates in the tribble above

ChatGPT: If you want to include missing dates in your `tsibble` object, you can use the `complete()` function from the `tsibble` package. This function allows you to fill in missing time points in the time series data. Here's how you can include missing dates in your `woylie_tsibble`:

```R
library(tsibble)

woylie_tsibble <- woylie_narrabri_grouped %>%
  as_tsibble(key = Total_sightings, index = eventDate) %>%
  complete()
```

The `complete()` function will fill in any missing dates between the start and end of the time series, ensuring that your `woylie_tsibble` includes all time points.

Me: Add legend to geom_smooth line in ggplot

ChatGPT: To add a legend for the `geom_smooth` line in your ggplot, you can do the following:

```R
library(ggplot2)

# Your code for data preparation...

ggplot(annual_data, aes(x = Year, y = TotalTrips)) +
  geom_line(aes(group = 1), size = 1) +
  geom_point(size = 3, aes(color = "Data Points")) +
  geom_smooth(aes(color = "Smooth Line"), method = 'loess', se = FALSE) +
  annotate("text", x = 2002, y = 75, label = "Peak in 2002", vjust = -1) +
  annotate("text", x = 2016, y = 75, label = "Peak around 2018", vjust = -1) +
  expand_limits(y = 0) +
  labs(
    title = "Annual Trend of Trips",
    x = "Year",
    y = "Total Trips",
    color = "Legend"
  ) +
  scale_color_manual(values = c("Data Points" = "black", "Smooth Line" = "red")) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

In this code, I added `aes(color = "Data Points")` to the `geom_point` and `aes(color = "Smooth Line")` to the `geom_smooth` to give them labels for the legend. Then, I added `scale_color_manual` to specify the colors for the legend items ("Data Points" and "Smooth Line").

The `labs` function is used to set the legend title to "Legend." This way, you will have a legend for both the data points and the smoothed line in your plot.

library(ggplot2)

# Read in the data
video_games_sales <- read.csv("Gaga/Data Analysis/Projects/game/vgsales.csv")

# Top-selling games by region
top_games_na <- video_games_sales[order(video_games_sales$NA_Sales, decreasing = TRUE), c("Name", "Platform", "NA_Sales")]
head(top_games_na, 10)

top_games_eu <- video_games_sales[order(video_games_sales$EU_Sales, decreasing = TRUE), c("Name", "Platform", "EU_Sales")]
head(top_games_eu, 10)

top_games_jp <- video_games_sales[order(video_games_sales$JP_Sales, decreasing = TRUE), c("Name", "Platform", "JP_Sales")]
head(top_games_jp, 10)

top_games_other <- video_games_sales[order(video_games_sales$Other_Sales, decreasing = TRUE), c("Name", "Platform", "Other_Sales")]
head(top_games_other, 10)


# Sales by year
sales_by_year <- aggregate(cbind(NA_Sales, EU_Sales, JP_Sales, Other_Sales) ~ Year, data = video_games_sales, sum)

# Plot sales by year
ggplot(data = sales_by_year, aes(x = factor(Year), y = NA_Sales)) +
  geom_bar(stat = "identity", color = "black", fill = "blue") +
  labs(title = "Video Game Sales by Year (North America)", x = "Year", y = "Sales (millions)") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = sales_by_year, aes(x = factor(Year), y = EU_Sales)) +
  geom_bar(stat = "identity", color = "black", fill = "red") +
  labs(title = "Video Game Sales by Year (Europe)", x = "Year", y = "Sales (millions)") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = sales_by_year, aes(x = factor(Year), y = JP_Sales)) +
  geom_bar(stat = "identity", color = "black", fill = "green") +
  labs(title = "Video Game Sales by Year (Japan)", x = "Year", y = "Sales (millions)") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = sales_by_year, aes(x = factor(Year), y = Other_Sales)) +
  geom_bar(stat = "identity", color = "black", fill = "orange") +
  labs(title = "Video Game Sales by Year (Other Regions)", x = "Year", y = "Sales (millions)") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Sales by platform
# Aggregate sales by platform and region
sales_by_platform_region <- aggregate(cbind(NA_Sales, EU_Sales, JP_Sales, Other_Sales) ~ Platform, data = video_games_sales, sum)

# Reshape the data to long format
sales_by_platform_region_long <- reshape(sales_by_platform_region, varying = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                                         v.names = "Sales", timevar = "Region", times = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                                         direction = "long")

# Plot sales by platform and region
ggplot(data = sales_by_platform_region_long, aes(x = Platform, y = Sales, fill = Region)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Video Game Sales by Platform and Region", x = "Platform", y = "Sales (millions)") +
  scale_fill_manual(values = c("blue", "red", "green", "orange"), name = "Region", labels = c("North America", "Europe", "Japan", "Other Regions")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Sales by genre
# Aggregate sales by genre and region
sales_by_genre_region <- aggregate(cbind(NA_Sales, EU_Sales, JP_Sales, Other_Sales) ~ Genre, data = video_games_sales, sum)

# Reshape the data to long format
sales_by_genre_region_long <- reshape(sales_by_genre_region, varying = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                                      v.names = "Sales", timevar = "Region", times = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                                      direction = "long")

# Plot sales by genre
ggplot(data = sales_by_genre_region_long, aes(x = Genre, y = Sales, fill = Region)) +
  geom_bar(stat = "identity", color = "black", position = position_dodge(width = 0.9)) +
  labs(title = "Video Game Sales by Genre and Region", x = "Genre", y = "Sales (millions)") +
  scale_fill_manual(values = c("red", "green", "blue", "orange"), name = "Region") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Sales by publisher
# Aggregate sales by publisher and region
sales_by_publisher_region <- aggregate(cbind(NA_Sales, EU_Sales, JP_Sales, Other_Sales) ~ Publisher, data = video_games_sales, sum)

# Get top 10 publishers for each region
top_publishers_na <- head(sales_by_publisher_region[order(-sales_by_publisher_region$NA_Sales), ], 10)
top_publishers_eu <- head(sales_by_publisher_region[order(-sales_by_publisher_region$EU_Sales), ], 10)
top_publishers_jp <- head(sales_by_publisher_region[order(-sales_by_publisher_region$JP_Sales), ], 10)
top_publishers_other <- head(sales_by_publisher_region[order(-sales_by_publisher_region$Other_Sales), ], 10)

# Combine the top publishers for each region
top_publishers <- rbind(top_publishers_na, top_publishers_eu, top_publishers_jp, top_publishers_other)

# Reshape the data to long format
top_publishers_long <- reshape(top_publishers, varying = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                               v.names = "Sales", timevar = "Region", times = c("NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"), 
                               direction = "long")

# Plot sales by publisher
ggplot(data = top_publishers_long, aes(x = Publisher, y = Sales, fill = Region)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Top 10 Video Game Publishers by Region", x = "Publisher", y = "Sales (millions)") +
  scale_fill_manual(values = c("red", "green", "blue", "orange"), name = "Region") +
  facet_wrap(~ Region, scales = "free_x") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


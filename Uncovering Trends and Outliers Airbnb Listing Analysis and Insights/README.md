# Airbnb Data Analysis Project
## Uncovering Trends and Outliers: Airbnb Listing Analysis and Insights

## Project Overview

This project focuses on analyzing an Airbnb dataset containing various records of properties listed across several cities in Europe. The goal is to perform comprehensive exploratory data analysis (EDA), identify outliers, and derive actionable insights from different aspects of the dataset, including pricing, guest satisfaction, booking trends, and room types.

Through this analysis, we aim to help Airbnb property managers make informed decisions about pricing, booking strategies, and guest satisfaction to optimize their listings and improve their business performance.

## Key Objectives

- **Identify Outliers**: Detect and remove pricing outliers using interquartile range (IQR) to ensure more accurate insights into average pricing and bookings.
- **Analyze Guest Satisfaction**: Examine the average guest satisfaction score and factors affecting it across different cities and room types.
- **Revenue Analysis**: Calculate the total revenue generated for each city and room type, and compare it across weekdays and weekends.
- **Room Type Insights**: Understand the average price and booking characteristics for each room type to optimize pricing and marketing.
- **City-Wise Insights**: Analyze the geographical distribution of bookings, revenue, and guest satisfaction to help managers target high-performing cities.

---

## Dataset Description

The dataset consists of the following columns:

- **PRICE**: The booking price for each property.
- **ROOM_TYPE**: The type of room (e.g., Entire home/apt, Private room, Shared room).
- **CITY**: The city where the property is located.
- **GUEST_SATISFACTION**: Rating of guest satisfaction for each booking.
- **DAY**: Day of the week when the booking was made.
- **METRO_DISTANCE_KM**: Distance of the property from the nearest metro station in kilometers.
- **CITY_CENTER_KM**: Distance of the property from the city center in kilometers.
- **CLEANLINESS_RATING**: Rating of cleanliness for each property.
  
---

## SQL Queries Overview

This project involves several key SQL queries to explore and analyze the dataset:

1. **Counting Records and Unique Cities**: Retrieve the total number of records and unique cities present in the dataset.
2. **Revenue and Booking Trends**: Analyze total revenue for each city and room type.
3. **Outliers Identification**: Detect and handle outliers in the pricing data using the IQR method.
4. **Guest Satisfaction**: Calculate average guest satisfaction scores for each city.
5. **Room Type Analysis**: Identify revenue, average prices, and booking trends for different room types.
6. **Weekday vs Weekend Analysis**: Compare booking data on weekdays and weekends.
7. **City and Location-Based Insights**: Analyze metro distance and city-center distance for each city.

---

## Approach

1. **Data Cleaning**: Filtered the dataset to remove any irrelevant or missing data. Outliers were identified using interquartile range (IQR) and removed to improve the accuracy of results.
2. **Exploratory Data Analysis (EDA)**: Performed summary statistics (mean, median, mode) and visualized trends to identify key patterns in booking, pricing, and guest satisfaction.
3. **Revenue Analysis**: Calculated total revenue for each city and room type to identify high-earning areas and suggest pricing optimization strategies.
4. **Outlier Detection**: Removed pricing outliers to focus on realistic booking trends and price ranges.
5. **Comparative Analysis**: Compared weekday and weekend bookings, as well as room types, to understand how booking behavior varies across these dimensions.

---

## Key Insights

1. **City-wise Revenue**: Paris and Rome are the highest-earning cities in terms of total revenue, while smaller cities like Berlin and Amsterdam show lower revenue despite a larger number of bookings.
2. **Room Type**: Entire homes and apartments generate more revenue compared to private or shared rooms, suggesting higher demand for full accommodations.
3. **Outliers**: Pricing outliers skewed the overall analysis, so removing them led to a more accurate understanding of average booking prices.
4. **Guest Satisfaction**: Cities with higher guest satisfaction tend to have a higher booking frequency and better revenue generation.
5. **Weekend vs Weekday Bookings**: Weekend bookings are slightly more profitable compared to weekday bookings, indicating potential for targeted weekend promotions.

---

## Recommendations

- **Pricing Optimization**: Adjust pricing strategies in cities with moderate bookings but high revenue potential to increase profitability.
- **Target Marketing**: Focus marketing efforts on high-performing cities like Paris and Rome while ensuring property listings in other cities maintain competitive pricing.
- **Outlier Management**: Continue monitoring outliers and periodically clean the dataset to ensure accuracy in pricing trends.
- **Guest Experience**: Focus on maintaining high cleanliness and guest satisfaction ratings, as these directly correlate with increased bookings and higher revenues.
- **Room Type Strategy**: Consider offering more entire home/apt listings in cities with higher demand for these types of accommodations.

## Connect with Me

Feel free to connect with me on LinkedIn: [Shreyash Supe](www.linkedin.com/in/shreyashsupe)


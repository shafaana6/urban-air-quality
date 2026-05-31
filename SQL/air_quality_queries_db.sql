-- Create database
CREATE DATABASE air_quality_db;
USE air_quality_db;

-- Create table
CREATE TABLE air_quality (
    record_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    zone_type VARCHAR(30),
    date DATE,
    year INT,
    month INT,
    day_of_week VARCHAR(15),
    season VARCHAR(20),
    population BIGINT,
    aqi FLOAT,
    pm2_5 FLOAT,
    pm10 FLOAT,
    no2 FLOAT,
    so2 FLOAT,
    co  FLOAT,
    o3 FLOAT,
    nh3 FLOAT,
    temperature_c FLOAT,
    humidity_pct FLOAT,
    wind_speed_kmh FLOAT,
    rainfall_mm FLOAT,
    num_vehicles BIGINT,
    num_industries INT,
    green_cover_pct FLOAT,
    monitoring_stations INT,
    hospital_admissions INT,
    respiratory_cases INT,
    cardiovascular_cases INT,
    aqi_category VARCHAR(20),
    health_risk_score FLOAT,
    data_source VARCHAR(30),
    data_quality_flag VARCHAR(20)
);

USE air_quality_db;

SELECT COUNT(*) AS total_rows FROM air_quality;
SELECT * FROM air_quality LIMIT 5;

-- What is the overall air quality status across all cities?
SELECT 
    COUNT(*)                AS total_records,
    COUNT(DISTINCT city)    AS total_cities,
    COUNT(DISTINCT state)   AS total_states,
    ROUND(AVG(aqi), 2)      AS avg_aqi,
    MIN(aqi)                AS min_aqi,
    MAX(aqi)                AS max_aqi,
    ROUND(AVG(health_risk_score), 2) AS avg_health_risk
FROM air_quality;

-- Which are the top 10 most polluted cities?
SELECT 
    city,
    state,
    ROUND(AVG(aqi), 2)              AS avg_aqi,
    ROUND(AVG(pm2_5), 2)            AS avg_pm2_5,
    ROUND(AVG(health_risk_score), 2) AS avg_health_risk,
    COUNT(*)                         AS total_records
FROM air_quality
GROUP BY city, state
ORDER BY avg_aqi DESC
LIMIT 10;

-- Which season has the worst air quality?
SELECT 
    season,
    ROUND(AVG(aqi), 2)               AS avg_aqi,
    ROUND(AVG(pm2_5), 2)             AS avg_pm2_5,
    ROUND(AVG(no2), 2)               AS avg_no2,
    ROUND(AVG(so2), 2)               AS avg_so2,
    ROUND(AVG(hospital_admissions), 2) AS avg_hospital_admissions,
    COUNT(*)                          AS total_records
FROM air_quality
GROUP BY season
ORDER BY avg_aqi DESC;

-- Which pollutant has the highest levels on average?
SELECT 
    ROUND(AVG(pm2_5), 2) AS avg_pm2_5,  
    ROUND(AVG(pm10), 2)  AS avg_pm10,  
    ROUND(AVG(no2), 2)   AS avg_no2,    
	ROUND(AVG(so2), 2)   AS avg_so2,    
    ROUND(AVG(co), 2)    AS avg_co,     
    ROUND(AVG(o3), 2)    AS avg_o3,     
    ROUND(AVG(nh3), 2)   AS avg_nh3
FROM air_quality;

-- How does AQI relate to hospital admissions?
SELECT 
    aqi_category,
    COUNT(*)                           AS total_records,          
    ROUND(AVG(aqi), 2)                 AS avg_aqi,
    ROUND(AVG(hospital_admissions), 2) AS avg_hospital_admissions, 
    ROUND(AVG(respiratory_cases), 2)   AS avg_respiratory,       
    ROUND(AVG(cardiovascular_cases), 2) AS avg_cardiovascular     
FROM air_quality
GROUP BY aqi_category
ORDER BY avg_aqi DESC;

-- Which zone type is the most polluted?
SELECT 
    zone_type,
    ROUND(AVG(aqi), 2)               AS avg_aqi,           
    ROUND(AVG(pm2_5), 2)             AS avg_pm2_5,
    ROUND(AVG(health_risk_score), 2) AS avg_health_risk,
    ROUND(AVG(hospital_admissions), 2) AS avg_admissions,   
    COUNT(*)                         AS total_records        
FROM air_quality
GROUP BY zone_type
ORDER BY avg_aqi DESC;

-- Which states have the most hazardous air quality days?
SELECT 
    state,
    COUNT(*)                         AS hazardous_days,     
    ROUND(AVG(aqi), 2)               AS avg_aqi,           
    ROUND(AVG(health_risk_score), 2) AS avg_health_risk     
FROM air_quality
WHERE aqi_category = 'Hazardous'
GROUP BY state
ORDER BY hazardous_days DESC;

-- Is there a difference in AQI on weekdays vs weekends?
SELECT 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') 
        THEN 'Weekend' 
        ELSE 'Weekday' 
    END                              AS day_type,
    COUNT(*)                         AS total_records,      
    ROUND(AVG(aqi), 2)               AS avg_aqi,            
    ROUND(AVG(pm2_5), 2)             AS avg_pm2_5,         
    ROUND(AVG(hospital_admissions), 2) AS avg_admissions    
FROM air_quality
GROUP BY day_type
ORDER BY avg_aqi DESC;
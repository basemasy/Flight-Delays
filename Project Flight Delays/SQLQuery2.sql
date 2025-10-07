use [Flights];
Go
create or Alter view Flights as
select * from Flight_Delays
Go

-- عدد الرحلات في الجدول
create or Alter view total_delays as
SELECT COUNT(*) AS total_flights FROM flight_delays;
Go

-- متوسط التأخير عند الإقلاع 
create or Alter view avg_dep_delay as
SELECT 
    AVG(DepDelay) AS avg_dep_delay
FROM flight_delays;
Go

-- متوسط التأخير عند الوصول
create or Alter view avg_arr_delay as
SELECT 
    AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays;
Go

-- أقل وأعلى تأخير عند الاقلاع والوصول
create or Alter view min_max_dep_arr_delay as
SELECT 
    MIN(DepDelay) AS min_dep_delay,
    MAX(DepDelay) AS max_dep_delay,
    MIN(ArrDelay) AS min_arr_delay,
    MAX(ArrDelay) AS max_arr_delay
FROM flight_delays;
Go


--أكثر شركات الطيران تكرارًا
create or Alter view Airline as
SELECT TOP 5 Airline, COUNT(*) AS num_flights
FROM flight_delays
GROUP BY Airline
ORDER BY num_flights DESC
Go

--أكثر مطارات الانطلاق
create or Alter view Origin_Airport as
SELECT TOP 10 OriginAirport, COUNT(*) AS num_flights
FROM flight_delays
GROUP BY OriginAirport
ORDER BY num_flights DESC
Go

--أكثر مطارات الوصول
create or Alter view Dest_Airport as
SELECT TOP 10 DestAirport, COUNT(*) AS num_flights
FROM flight_delays
GROUP BY DestAirport
ORDER BY num_flights DESC
Go

--عدد الرحلات حسب السنوات
create or Alter view num_flights_year as
SELECT TOP 100 PERCENT Year, COUNT(*) AS num_flights
FROM flight_delays
GROUP BY Year
ORDER BY Year;
Go

--عدد الرحلات حسب الأشهر
create or Alter view num_flights_Month as
SELECT TOP 100 PERCENT Month, COUNT(*) AS num_flights
FROM flight_delays
GROUP BY Month
ORDER BY Month;
Go

--متوسط التأخير عند الإقلاع والوصول حسب شركة الطيران
create or Alter view avg_dep_arr_delay_Airline as
SELECT TOP 100 PERCENT Airline, 
       AVG(DepDelay) AS avg_dep_delay, 
       AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays
GROUP BY Airline
ORDER BY avg_arr_delay DESC;
Go

--متوسط التأخير عند الإقلاع والوصول حسب مطار الانطلاق
create or Alter view avg_dep_arr_delay_Origin_Airport as
SELECT TOP 10 OriginAirport, 
       AVG(DepDelay) AS avg_dep_delay, 
       AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays
GROUP BY OriginAirport
ORDER BY avg_dep_delay DESC;
Go

--متوسط التأخير عند الوصول حسب مطار الوجهة
create or Alter view avg_arr_delay_Dest_Airport as
SELECT TOP 10 DestAirport, 
       AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays
GROUP BY DestAirport
ORDER BY avg_arr_delay DESC;
Go

--أكثر الأيام في الأسبوع التي يحدث فيها تأخير
create or Alter view avg_dep_arr_delay_DayOfWeek as
SELECT TOP 100 PERCENT DayOfWeek, 
       AVG(DepDelay) AS avg_dep_delay,
       AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays
GROUP BY DayOfWeek
ORDER BY avg_dep_delay DESC;
Go

--العلاقة بين المسافة والتأخير (تقسيم الرحلات حسب الفئة)
create or Alter view avg_dep_arr_delay_distance as
SELECT TOP 100 percent
    CASE 
        WHEN Distance < 500 THEN 'Short (<500 km)'
        WHEN Distance BETWEEN 500 AND 1500 THEN 'Medium (500-1500 km)'
        ELSE 'Long (>1500 km)'
    END AS distance,
    AVG(DepDelay) AS avg_dep_delay,
    AVG(ArrDelay) AS avg_arr_delay,
    COUNT(*) AS num_flights
FROM flight_delays
GROUP BY 
    CASE
        WHEN Distance < 500 THEN 'Short (<500 km)'
        WHEN Distance BETWEEN 500 AND 1500 THEN 'Medium (500-1500 km)'
        ELSE 'Long (>1500 km)'
    END
ORDER BY num_flights DESC;
Go

--أكثر 10 رحلات (شركة + رقم رحلة) بها متوسط تأخير
create or Alter view avg_dep_arr_delay_Airline_FlightNumber as
SELECT TOP 10 Airline, FlightNumber, 
       AVG(DepDelay) AS avg_dep_delay,
       AVG(ArrDelay) AS avg_arr_delay
FROM flight_delays
GROUP BY Airline, FlightNumber
ORDER BY avg_arr_delay DESC;
Go

--نسبة الرحلات الملغاة من إجمالي الرحلات
create or Alter view total_flights_cancelled_flights as
SELECT 
    COUNT(*) AS total_flights,
    SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(100.0 * SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancelled_percent
FROM flight_delays;
Go

--نسبة الرحلات المحولة (Diverted)
create or Alter view total_flights_diverted_flights as
SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN Diverted = 1 THEN 1 ELSE 0 END) AS diverted_flights,
    ROUND(100.0 * SUM(CASE WHEN Diverted = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS diverted_percent
FROM flight_delays;
Go

--أكثر شركات الطيران من حيث الإلغاءات
create or Alter view total_flights_cancelled_flights_percent as
SELECT TOP 100 percent Airline, 
       COUNT(*) AS total_flights,
       SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
       ROUND(100.0 * SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancelled_percent
FROM flight_delays
GROUP BY Airline
ORDER BY cancelled_percent DESC;
Go

--أكثر مطارات الانطلاق بها إلغاءات
create or Alter view OriginAirport_cancelled_flights as
SELECT Top 10 OriginAirport, 
       COUNT(*) AS total_flights,
       SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
       ROUND(100.0 * SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancelled_percent
FROM flight_delays
GROUP BY OriginAirport
ORDER BY cancelled_percent DESC;
Go

--أكثر الوجهات بها تحويل رحلات (Diverted)
create or Alter view DestAirport_diverted_flights as
SELECT Top 10 DestAirport, 
       COUNT(*) AS total_flights,
       SUM(CASE WHEN Diverted = 1 THEN 1 ELSE 0 END) AS diverted_flights,
       ROUND(100.0 * SUM(CASE WHEN Diverted = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS diverted_percent
FROM flight_delays
GROUP BY DestAirport
ORDER BY diverted_percent DESC;
Go

--توزيع الإلغاءات حسب الأشهر (هل في مواسم معينة بيزيد الإلغاء؟)
create or Alter view cancelled_flights_By_Month as
SELECT Top 100 percent Month, 
       SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
       ROUND(100.0 * SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancelled_percent
FROM flight_delays
GROUP BY Month
ORDER BY Month;
Go

create or Alter view Airline as
SELECT DISTINCT Airline FROM flight_delays
Go

create or Alter view Origin_Airport as
SELECT DISTINCT OriginAirport FROM flight_delays
Go

create or Alter view Dest_Airport as
SELECT DISTINCT DestAirport FROM flight_delays
Go

create or Alter view Dim_Year as
SELECT DISTINCT Year FROM flight_delays
Go

create or Alter view Dim_Month as
SELECT DISTINCT Month FROM flight_delays
Go

create or Alter view Dim_Day_Of_Weak as
SELECT DISTINCT DayOfWeek FROM flight_delays
Go
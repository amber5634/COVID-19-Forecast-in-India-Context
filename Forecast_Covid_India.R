# Libraries Required
library(covid19.analytics)
library(ggplot2)
library(lubridate)
library(prophet)

# Data
ag <- covid19.data(case='aggregated')
tsc <- covid19.data(case='ts-confirmed')
tsc <- tsc %>% filter(Country.Region == 'India')
tsc<-data.frame(t(tsc))
tsc<-cbind(rownames(tsc),data.frame(tsc,row.names = NULL))
colnames(tsc) <- c('Date' , 'Confirmed')
tsc<-tsc[-c(1:4),]
tsc$Date <- ymd(tsc$Date)
str(tsc)
tsc$Confirmed<-as.numeric(tsc$Confirmed)


# Plot 
qplot(Date,Confirmed,data=tsc,main = 'Covid 19 Confirmed Cases in India')

ds <- tsc$Date
y <- tsc$Confirmed

df <- data.frame(ds, y)

# Forecasting
m <- prophet(df)

# Prediction
future <- make_future_dataframe(m , periods = 15)
forecast<- predict(m, future)

# Plot for forecast
plot(m,forecast)
dyplot.prophet(m,forecast)

#Forecast Components
prophet_plot_components(m,forecast)


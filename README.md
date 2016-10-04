# ga-explorerr

Super simple way to get the data from the GA Explorer directly into R.

    ga_url <- "https://www.googleapis.com/analytics/v3/data/ga?ids=ga%3A**123456789**&start-date=2016-09-01&end-date=2016-09-25&metrics=ga%3AuniqueEvents&dimensions=ga%3Adate%2Cga%3ApagePath%2Cga%3AeventCategory%2Cga%3AeventAction&filters=ga%3ApagePath%3D~wasgij-original-25&max-results=10000&access_token=**ya29....**"
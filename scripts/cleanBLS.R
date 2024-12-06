if (exists("startrun")) {
  print(fortunes::fortune())
} else {
  source(here::here("scripts", "startHere.R"))
}

load(here::here('data',"interim", "CountyPlaceNameLists.rda"))

# 
# Area Codes

## Counties are in the BLSCodes.md

areaCodes <- c(
  "CN4700100000000",
  "CN4700100000000",
  "CN4701300000000",
  "CN4702500000000",
  "CN4702900000000",
  "CN4705700000000",
  "CN4706300000000",
  "CN4708900000000",
  "CN4709300000000",
  "CN4710500000000",
  "CN4712300000000",
  "CN4712900000000",
  'CN4714500000000',
  "CN4715100000000",
  "CN4715500000000",
  'CN4717300000000'
)

# Local Area Unemployment Statistics , format is:
#Series ID    LAUCN281070000000003
#Positions    Value            Field Name
#1-2          LA               Prefix
#3            U                Seasonal Adjustment Code
#4-18         CN2810700000000  Area Code
#19-20        03               Measure Code

# So:
prefix <- "LA"
SeasAdjCode <- "U"
unempCode <- "03"
laborParticipationCode <- "08"

# unemployment 

unemploymentCodes <- c()

for (areacode in areaCodes) {
  unemploymentCodes <- c(unemploymentCodes,str_c(prefix,SeasAdjCode,areacode,unempCode))
  
}


# labor force participation rates
## No county has data for this,
laborPartCodes <- c()

for (areacode in areaCodes) {
  laborPartCodes <- c(laborPartCodes,str_c(prefix,SeasAdjCode,areacode,laborParticipationCode))
  
}

# Combined

apiCodes <- c(laborPartCodes,unemploymentCodes)
# can't run w/out api key

## Pull the data via the API
# payload <- list(
#   'seriesid'=c(unemploymentCodes)
#   # 'startyear'=2023,
#   # 'endyear'=2024
#   )
# response <- blsAPI::blsAPI(payload)
# json <- fromJSON(response)
# blsAPI::apiDF(json)

json[1] # status
json[3] # message

json[4]#data
# blsAPI::apiDF(json[4]$Results$series[[1]]$data) %>% 
#   mutate(
#     place='Anderson County, Tennessee'
#   )

response <- blsAPI::blsAPI(unemploymentCodes[1])
json <- fromJSON(response)
print(ETDDCounties[1])
tmpdf <- blsAPI::apiDF(json[4]$Results$series[[1]]$data) %>% 
  mutate(
    place=ETDDCounties[1]
  )
write_csv(tmpdf,here::here("data","raw",str_c('unemp',ETDDCounties[1],'data.csv')))

allUnEmpDf <- tmpdf

for (i in 2:16){
  response <- blsAPI::blsAPI(unemploymentCodes[i])
  json <- fromJSON(response)
  print(ETDDCounties[i])
  # doing series [[1]] instead of [[i]] bc I'm only requesting one item
  tmpdf <- blsAPI::apiDF(json[4]$Results$series[[1]]$data) %>% 
    mutate(
      place=ETDDCounties[i],
      measure=str_c(as.character(year),'',periodName,'pctunemploymentRate')
      
    )
    write_csv(tmpdf,here::here("data","raw",str_c('unemp',ETDDCounties[i],'data.csv')))
    allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf)
}


## TN

tnAreaCode <- "ST4700000000000"
unemploymentCode <- str_c(prefix,SeasAdjCode,tnAreaCode,unempCode)
laborPartCode <- str_c(prefix,SeasAdjCode,tnAreaCode,laborParticipationCode)

response <- blsAPI::blsAPI(unemploymentCode)
json <- fromJSON(response)
tmpdf <- blsAPI::apiDF(json[4]$Results$series[[1]]$data) %>% 
  mutate(
    place='Tennessee',
    measure=str_c(as.character(year),'',periodName,'pctunemploymentRate')
    
  )
write_csv(tmpdf,here::here("data","raw",str_c('unempTNdata.csv')))

allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf) %>% mutate(
  measure=str_c(as.character(year),'',periodName,'pctunemploymentRate')
)


response <- blsAPI::blsAPI(laborPartCode)
json <- fromJSON(response)
tmpdf <- blsAPI::apiDF(json[4]$Results$series[[1]]$data) %>% 
  mutate(
    place='Tennessee',
    measure=str_c(as.character(year),'',periodName,'pctlaborForceParticipation')
    
  )
write_csv(tmpdf,here::here("data","raw",str_c('laborParticipationTNdata.csv')))

# allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf)

allUnEmpDf <- read_csv(here::here("data","raw",str_c('unemp',ETDDCounties[1],'data.csv')))

for (i in 2:16){

  tmpdf <- read_csv(here::here("data","raw",str_c('unemp',ETDDCounties[i],'data.csv'))) %>%
    mutate(measure=str_c(as.character(year),'',periodName,'unemploymentRate'))
  allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf)
}

tmpdf <- read_csv(here::here("data","raw",str_c('unempTNdata.csv')))

allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf) %>% mutate(
  measure=str_c(as.character(year),'',periodName,'pctUnemploymentRate')
)

tmpdf=read_csv(here::here("data","raw",str_c('laborParticipationTNdata.csv'))) %>% 
  mutate(
    measure=str_c(as.character(year),'',periodName,'pctLaborforceParticipationRate')
    
  )

allUnEmpDf <- bind_rows(allUnEmpDf,tmpdf)

allUnEmpDf <- allUnEmpDf %>%
  select(measure,value,place) %>% 
  group_by(place,measure) %>% 
  # summarize(value=sum(value)) %>%
  pivot_wider(
    names_from=measure,
    values_from = value
  )

write_csv(allUnEmpDf,here::here("data","processed","blsData.csv"))

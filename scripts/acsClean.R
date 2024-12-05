if (exists("startrun")) {
  print(fortunes::fortune())
} else {
  source(here::here("scripts", "startHere.R"))
}

# Grabbing variables from ACS, || Update
ACSYear <- 2022
v2022 <- load_variables(2022, "acs5", cache = TRUE)

# decide on the vars, find these either on data.census.gov
# or the sheet from Tim Kuhn || Update

ACSVars <- c( # epa
  "B28002", "B18101", "B06012", "B27001", "B08202", "B25034",
  # ARC
  # race
  "B02001",
  # foreign-born
  "B05002",
  # language at home
  "B06007",
  # sex by educational attainment
  "B15002",
  # sex by age, for under five and over 65
  "B01001"
)

APIVars <-
  c(
    v2022 %>%
      filter(str_detect(name, paste(ACSVars, collapse = "|"))) %>%
      select(name) %>%
      pull()
  )

if (!file.exists(here::here("data", "interim", "acsPlaceData.csv"))) {
  initDf <- get_acs(
    geography = "place",
    variables = APIVars,
    year = 2022,
    output = "tidy",
    state = c("TN"),
    # county = "Blount",
    key = keyring::key_get("CensusApi"),
    #  moe_level = 95,
    survey = "acs5",
    # show_call = TRUE
    # wide=TRUE
    #  ...
  )

  IntermediateDf <- initDf %>%
    # filter(NAME=="Grainger County, Tennessee") %>%
    left_join(v2022, by = c("variable" = "name")) %>%
    # select(-c(GEOID,geography)) %>%
    select(-c(GEOID, geography)) %>%
    mutate(
      tstLabel = str_split(label, "!"),
      label = str_remove_all(label, "!"),
      geography = "place"
    )

  # filter to just relevant stuff

  IntermediateDf <- IntermediateDf %>%
    # filter(NAME %in% ETDDCounties)
    filter(str_detect(NAME, paste(ETDDPlaces, collapse = "|"))) %>%
    filter(NAME != "Kingston Springs town, Tennessee")

  # check that it got all of them and only them, also look before the length
  IntermediateDf %>%
    select(NAME) %>%
    distinct() %>%
    pull() %>%
    length()

  placedf <- IntermediateDf
  # save the file with all of the data you want
  write_csv(placedf, file = here::here("data", "interim", "acsPlaceData.csv"))
} else {
  placedf <- read_csv(here::here("data", "interim", "acsPlaceData.csv"))
}

if (!file.exists(here::here("data", "interim", "acsCountyData.csv"))) {
  initDf <- get_acs(
    geography = "county",
    variables = APIVars,
    year = 2022,
    output = "tidy",
    state = c("TN"),
    # county = "Blount",
    key = keyring::key_get("CensusApi"),
    #  moe_level = 95,
    survey = "acs5",
    # show_call = TRUE
    # wide=TRUE
    #  ...
  )

  IntermediateDf <- initDf %>%
    # filter(NAME=="Grainger County, Tennessee") %>%
    left_join(v2022, by = c("variable" = "name")) %>%
    # select(-c(GEOID,geography)) %>%
    select(-c(GEOID, geography)) %>%
    mutate(
      tstLabel = str_split(label, "!"),
      label = str_remove_all(label, "!"),
      geography = "county"
    )

  # filter to just relevant stuff

  IntermediateDf <- IntermediateDf %>%
    filter(NAME %in% ETDDCounties)

  # check that it got all of them and only them, also look before the length
  IntermediateDf %>%
    select(NAME) %>%
    distinct() %>%
    pull() %>%
    length()


  countydf <- IntermediateDf
  # save the file with all of the data you want
  write_csv(IntermediateDf, file = here::here("data", "interim", "acsCountyData.csv"))
} else {
  countydf <- read_csv(here::here("data", "interim", "acsCountyData.csv"))
}

if (!file.exists(here::here("data", "interim", "acsCountyData.csv"))) {
  initDf <- get_acs(
    geography = "state",
    variables = APIVars,
    year = 2022,
    output = "tidy",
    state = c("TN"),
    # county = "Blount",
    key = keyring::key_get("CensusApi"),
    #  moe_level = 95,
    survey = "acs5",
    # show_call = TRUE
    # wide=TRUE
    #  ...
  )

  IntermediateDf <- initDf %>%
    # filter(NAME=="Grainger County, Tennessee") %>%
    left_join(v2022, by = c("variable" = "name")) %>%
    # select(-c(GEOID,geography)) %>%
    select(-c(GEOID, geography)) %>%
    mutate(
      tstLabel = str_split(label, "!"),
      label = str_remove_all(label, "!"),
      geography = "state"
    )

  # filter to just relevant stuff

  IntermediateDf
  # check that it got all of them and only them, also look before the length
  IntermediateDf %>%
    select(NAME) %>%
    distinct() %>%
    pull() %>%
    length()


  statedf <- IntermediateDf
  # save the file with all of the data you want
  write_csv(IntermediateDf, file = here::here("data", "interim", "acsStateData.csv"))
} else {
  statedf <- read_csv(here::here("data", "interim", "acsStateData.csv"))
}


IntermediateDf <- statedf %>%
  bind_rows(placedf) %>%
  bind_rows(countydf)

# This is to see the concepts you got
IntermediateDf %>%
  select(concept) %>%
  unique() %>%
  print(n = 50)


# This is where the data is getting processed into the vars needed
# No internet access ACS

internetdf <- IntermediateDf %>%
  filter(concept == "Presence and Types of Internet Subscriptions in Household") %>%
  filter(label == "EstimateTotal:No Internet access" | label == "EstimateTotal:With an Internet subscription") %>%
  select(estimate, label, NAME) %>%
  pivot_wider(names_from = "label", values_from = "estimate") %>%
  group_by(NAME) %>%
  summarize(pctWithoutInternet = `EstimateTotal:No Internet access` /
    (`EstimateTotal:No Internet access` +
      `EstimateTotal:With an Internet subscription`))


# Over five with a disability ACS
disabilitydf <- IntermediateDf %>%
  filter(concept == "Sex by Age by Disability Status") %>%
  filter(str_detect(label, "disability") & !str_detect(label, "Under")) %>%
  mutate(withDisability = ifelse(str_detect(label, "With a disability"), "withADisability", "noDisability")) %>%
  group_by(withDisability, NAME) %>%
  summarize(estimate = sum(estimate)) %>%
  pivot_wider(names_from = "withDisability", values_from = "estimate") %>%
  group_by(NAME) %>%
  summarize(pctWithDisability = withADisability / (withADisability + noDisability))



# living in poverty ACS
povertydf <- IntermediateDf %>%
  filter(concept == "Place of Birth by Poverty Status in the Past 12 Months in the United States") %>%
  filter(label == "EstimateTotal:Below 100 percent of the poverty level" |
    label == "EstimateTotal:100 to 149 percent of the poverty level" |
    label == "EstimateTotal:At or above 150 percent of the poverty level") %>%
  select(estimate, label, NAME) %>%
  pivot_wider(names_from = label, values_from = estimate) %>%
  group_by(NAME) %>%
  summarize(
    inPoverty = `EstimateTotal:Below 100 percent of the poverty level` #+`EstimateTotal:100 to 149 percent of the poverty level`
    ,
    total =
      (`EstimateTotal:Below 100 percent of the poverty level` + `EstimateTotal:100 to 149 percent of the poverty level` + `EstimateTotal:At or above 150 percent of the poverty level`),
    pctInPoverty = inPoverty / total
  )
# Population living without Health Insurance ACS
noInsurancedf <- IntermediateDf %>%
  filter(concept == "Health Insurance Coverage Status by Sex by Age") %>%
  filter(str_detect(label, "insurance")) %>%
  mutate(hasInsurance = ifelse(str_detect(label, "With health insurance"), "hasInsurance", "noInsurance")) %>%
  group_by(hasInsurance, NAME) %>%
  summarize(estimate = sum(estimate)) %>%
  pivot_wider(names_from = hasInsurance, values_from = estimate) %>%
  group_by(NAME) %>%
  summarize(pctNotInsurance = noInsurance / (hasInsurance + noInsurance))

# Housing built before 1980; ACS
housingpre1980df <- IntermediateDf %>%
  filter(concept == "Year Structure Built" & label != "EstimateTotal:") %>%
  mutate(builtBefore1980 = ifelse(
    str_detect(label, "2020") |
      str_detect(label, "2010") |
      str_detect(label, "2000") |
      str_detect(label, "1990"), "builtAfter1980", "builtBefore1980"
  )) %>%
  select(estimate, builtBefore1980, NAME) %>%
  group_by(builtBefore1980, NAME) %>%
  summarize(estimate = sum(estimate)) %>%
  pivot_wider(names_from = "builtBefore1980", values_from = "estimate") %>%
  group_by(NAME) %>%
  summarize(pctBuiltBefore1980 = builtBefore1980 / (builtBefore1980 + builtAfter1980))

# total population
totaldf <- IntermediateDf %>%
  filter(concept == "Sex by Age", label == "EstimateTotal:") %>%
  select(NAME, estimate) %>%
  rename("totalPopulation" = "estimate")



# racial demographics
racedf <- IntermediateDf %>%
  filter(concept == "Race") %>%
  select(NAME, estimate, label) %>%
  pivot_wider(
    names_from = label,
    values_from = estimate
  ) %>%
  mutate(
    pctWhite = `EstimateTotal:White alone` / `EstimateTotal:`,
    pctBlackOrAfricanAmerican = `EstimateTotal:Black or African American alone` / `EstimateTotal:`,
    pctNativeAmerican = `EstimateTotal:American Indian and Alaska Native alone` / `EstimateTotal:`,
    pctAsian = `EstimateTotal:Asian alone` / `EstimateTotal:`,
    pctPacificIslander = `EstimateTotal:Native Hawaiian and Other Pacific Islander alone` / `EstimateTotal:`,
    pctOtherRace = `EstimateTotal:Some Other Race alone` / `EstimateTotal:`,
    pctTwoOrMoreRaces = `EstimateTotal:Two or More Races:` / `EstimateTotal:`
  ) %>%
  select(
    NAME, pctWhite, pctBlackOrAfricanAmerican, pctNativeAmerican, pctAsian, pctPacificIslander,
    pctOtherRace, pctTwoOrMoreRaces
  )



# Children under 5 %
under5df <- IntermediateDf %>%
  filter(concept == "Sex by Age" & label != "EstimateTotal:") %>%
  mutate(underFive = ifelse(str_detect(label, "Under 5 years"), "underFive", "overFive")) %>%
  group_by(underFive, NAME) %>%
  summarize(estimate = sum(estimate)) %>%
  # group_by(NAME) %>%
  pivot_wider(
    names_from = underFive, values_from = estimate
  ) %>%
  ungroup() %>%
  mutate(pctUnderFive = underFive / (underFive + overFive)) %>%
  select(NAME, pctUnderFive)


# PPl over 65 %

over65df <- IntermediateDf %>%
  filter(concept == "Sex by Age" & label != "EstimateTotal:") %>%
  mutate(overSixtyFive = ifelse(str_detect(label, "65") |
    str_detect(label, "67") |
    str_detect(label, "70") |
    str_detect(label, "75") |
    str_detect(label, "80") |
    str_detect(label, "85"),
  "overSixtyFive", "underSixtyFive"
  )) %>%
  group_by(overSixtyFive, NAME) %>%
  summarize(estimate = sum(estimate)) %>%
  # group_by(NAME) %>%
  pivot_wider(
    names_from = overSixtyFive, values_from = estimate
  ) %>%
  ungroup() %>%
  mutate(pctOverSixtyFive = overSixtyFive / (underSixtyFive + overSixtyFive)) %>%
  select(NAME, pctOverSixtyFive)

# Ppl foreign-born %

foreigndf <- IntermediateDf %>%
  filter(concept == "Place of Birth by Nativity and Citizenship Status" & label != "EstimateTotal:") %>%
  filter(label == "EstimateTotal:Native:" | label == "EstimateTotal:Foreign born:") %>%
  select(NAME, estimate, label) %>%
  pivot_wider(
    names_from = label,
    values_from = estimate
  ) %>%
  mutate(
    pctForeignBorn = `EstimateTotal:Foreign born:` / (`EstimateTotal:Native:` + `EstimateTotal:Foreign born:`)
  ) %>%
  select(NAME, pctForeignBorn)

# Ppl speak other than English at home %
esoldf <- IntermediateDf %>%
  filter(concept == "Place of Birth by Language Spoken at Home and Ability to Speak English in the United States") %>%
  # select(label)
  filter(label == "EstimateTotal:Speak Spanish:" |
    label == "EstimateTotal:Speak other languages:" |
    label == "EstimateTotal:") %>%
  select(NAME, label, estimate) %>%
  pivot_wider(
    names_from = label,
    values_from = estimate
  ) %>%
  mutate(
    pctSpeakOtherThanEnglishHome = (`EstimateTotal:Speak Spanish:` + `EstimateTotal:Speak other languages:`) / `EstimateTotal:`
  ) %>%
  select(NAME, pctSpeakOtherThanEnglishHome)


# Educational attainment
edudf <- IntermediateDf %>%
  filter(
    concept == "Sex by Educational Attainment for the Population 25 Years and Over",
    label != "EstimateTotal:Female:",
    label != "EstimateTotal:Male:"
  ) %>%
  mutate(
    educationalAttainment = case_when(
      str_detect(label, "High school") ~ "High school degree",
      str_detect(label, "Associate's") ~ "Associates degree",
      str_detect(label, "Bachelor's") ~ "Bachelors degree",
      str_detect(label, "Master's") ~ "Masters degree",
      str_detect(label, "Doctorate") ~ "Doctorate degree",
      str_detect(label, "Professional") ~ "Professional degree",
      label == "EstimateTotal:" ~ "total",
      .default = "didn't graduate high school"
    )
  ) %>%
  group_by(NAME, educationalAttainment) %>%
  summarize(estimate = sum(estimate)) %>%
  pivot_wider(
    names_from = educationalAttainment,
    values_from = estimate
  ) %>%
  mutate(
    pctNoHS = `didn't graduate high school` / total,
    pctHS = `High school degree` / total,
    pctCollege = (`Associates degree` + `Bachelors degree` + `Masters degree` + `Doctorate degree`) / total,
    pctAssociates = `Associates degree` / total,
    pctBachelors = `Bachelors degree` / total,
    pctMasters = `Masters degree` / total,
    pctDoctorate = `Doctorate degree` / total,
    pctProfessional = `Professional degree` / total
  ) %>%
  select(
    NAME,
    pctNoHS,
    pctHS,
    pctCollege,
    pctAssociates,
    pctBachelors,
    pctMasters,
    pctDoctorate,
    pctProfessional
  )




geographydf <- IntermediateDf %>%
  select(NAME, geography) %>%
  distinct()

acsCleanedDf <-
  internetdf %>%
  left_join(disabilitydf) %>%
  left_join(povertydf) %>%
  left_join(noInsurancedf) %>%
  left_join(housingpre1980df) %>%
  left_join(racedf) %>%
  left_join(under5df) %>%
  left_join(over65df) %>%
  left_join(foreigndf) %>%
  left_join(esoldf) %>%
  left_join(edudf) %>%
  left_join(geographydf)








write_csv(acsCleanedDf, here::here("data", "processed", "etddAreaAcsVars.csv"))

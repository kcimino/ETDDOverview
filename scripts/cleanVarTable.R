if (exists("startrun")) {
  print(fortunes::fortune())
} else {
  source(here::here("scripts", "startHere.R"))
}

# Purpose: to include at the beginning or end so ppl can see if we have the var,
# where the var comes from
# and where it is in the thingy

# name, category, grant, source

# ACS vars
ACSVars <-
  matrix(
    c(
      "people without internet %", "misc", "EPA", "American Community Survey", "pctWithoutInternet",
      "people with a disability %", "labor", "EPA", "American Community Survey", "pctWithDisability",
      "people in poverty %", "economic", "EPA", "American Community Survey", "pctInPoverty",
      "total population", "demographics", "ARC", "American Community Survey", "total",
      "people without insurance %", "misc", "EPA", "American Community Survey", "pctNotInsurance",
      "houses built before 1980 %", "housing", "EPA", "American Community Survey", "pctBuiltBefore1980",
      "White people, %", "demographics", "ARC", "American Community Survey", "pctWhite",
      "Black or African American people, %", "demographics", "ARC", "American Community Survey", "pctBlackOrAfricanAmerican",
      "American Indian or Alaskan Native people, %", "demographics", "ARC", "American Community Survey", "pctNativeAmerican",
      "Asian people, %", "demographics", "ARC", "American Community Survey", "pctAsian",
      "Native Hawaiian and Other Pacific Islander", "demographics", "ARC", "American Community Survey", "pctPacificIslander",
      "People with another race, %", "demographics", "ARC", "American Community Survey", "pctOtherRace",
      "People with two or more races", "demographics", "ARC", "American Community Survey", "pctTwoOrMoreRaces",
      "People under 5, %", "demographics", "ARC", "American Community Survey", "pctUnderFive",
      "People over 65, %", "demographics", "ARC", "American Community Survey", "pctOverSixtyFive",
      "People born in other countries, %", "demographics", "ARC", "American Community Survey", "pctForeignBorn",
      "People speak a language other than English at Home, %", "demographics", "ARC", "American Community Survey", "pctSpeakOtherThanEnglishHome",
      "People over 25 without a highschool degree, %", "demographics", "ARC", "American Community Survey", "pctNoHS",
      "People over 25 with a highschool degree, %", "demographics", "ARC", "American Community Survey", "pctHS",
      "People over 25 with an Associates degree, %", "demographics", "ARC", "American Community Survey", "pctAssociates",
      "People over 25 with a Bachelors degree, %", "demographics", "ARC", "American Community Survey", "pctBachelors",
      "People over 25 with a Masters degree, %", "demographics", "ARC", "American Community Survey", "pctMasters",
      "People over 25 with a Doctorate degree, %", "demographics", "ARC", "American Community Survey", "pctDoctorate",
      "People over 25 with a Professional degree, %", "demographics", "ARC", "American Community Survey", "pctProfessional"
    ),
    nrow = 24, ncol = 5, byrow = TRUE
  )


colnames(ACSVars) <- c("variable", "category", "grant", "source", "varName")

ACSVarsdf <- as_tibble(ACSVars)


# NLCD vars

# Labor vars


# rbind them all together

Varsdf <- ACSVarsdf

write_csv(Varsdf, here::here("data", "processed", "varsdf.csv"))

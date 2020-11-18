# Function to get deprivation indices at a tract level
ndi <- function(){

  states <- c(1, 2, 4, 5, 6, 8, 9,10, 11, 12, 13, 15,16, 17, 18, 19, 20,21, 22, 23, 24, 25, 26, 27, 28, 29, 30,31, 32,
              33, 34, 35,36, 37, 38, 39, 40,41, 42, 44, 45, 46,47, 48, 49, 50, 51, 53, 54, 55, 56)

  vars <- c("B17001_002", "B17001_001", "B06009_002" ,
            "B06009_001", "B09008_011", "B09008_001",
            "B08124_002", "B08124_001", "B25014_005",
            "B25014_006", "B25014_007", "B25014_011",
            "B25014_012", "B25014_013", "B25014_001",
            "B19058_002", "B19058_001", "C23002A_008E",
            "C23002A_021E", "C23002A_006E", "C23002A_019E",
            "B19001_002","B19001_003", "B19001_004",
            "B19001_005", "B19001_006", "B19001_001")

  acs_data <- tidycensus::get_acs(geography = "tract",
                                  state = states,
                                  variables = vars,
                                  output = "wide") %>%
    dplyr::mutate(pct_poverty = B17001_002E / B17001_001E,
           pct_noHS = B06009_002E / B06009_001E,
           pct_FHH = B09008_011E / B09008_001E,
           pct_mgmt = B08124_002E /  B08124_001E,
           pct_crowd =  (B25014_005E + B25014_006E + B25014_007E +
                           B25014_011E + B25014_012E + B25014_013E) / B25014_001E,
           pct_pubassist = B19058_002E / B19058_001E,
           pct_unempl = (C23002A_008E + C23002A_021E) / (C23002A_006E + C23002A_019E),
           pct_under30K =( B19001_002E + B19001_003E + B19001_004E +
                             B19001_005E +  B19001_006E) / B19001_001E)

  values  <-  acs_data %>%
    dplyr::select(pct_poverty,
                  pct_noHS,
                  pct_FHH,
                  pct_mgmt,
                  pct_crowd,
                  pct_pubassist,
                  pct_unempl,
                  pct_under30K) %>%
    as.matrix()

  values[is.nan(values)] <- 0

  ND <- psych::principal(values,
                         nfactors = 1)

  NDI <- cbind(acs_data,
               ND$scores)

  NDI <- NDI %>%
    dplyr::select(NAME,
                  GEOID,
                  PC1,
                  57:64) %>%
    tidyr::separate(NAME,
                    into = c("Tract", "County", "State"),
                    sep = ",") %>%
    dplyr::mutate(County = stringr::str_trim(County),
                  State = stringr::str_trim(State)) %>%
    rename(NDI = PC1)  %>%
    dplyr::as_tibble()

    write_excel_csv(NDI, file = "R\\deprivation_tract.csv")

  return(NDI)

}

# Function to get deprivation indices at a county level
ndi_county <- function(){

  vars <- c("B17001_002", "B17001_001", "B06009_002" ,
            "B06009_001", "B09008_011", "B09008_001",
            "B08124_002", "B08124_001", "B25014_005",
            "B25014_006", "B25014_007", "B25014_011",
            "B25014_012", "B25014_013", "B25014_001",
            "B19058_002", "B19058_001", "C23002A_008E",
            "C23002A_021E", "C23002A_006E", "C23002A_019E",
            "B19001_002","B19001_003", "B19001_004",
            "B19001_005", "B19001_006", "B19001_001")

  acs_data <- tidycensus::get_acs(geography = "county",
                                  variables = vars,
                                  output = "wide") %>%
    dplyr::mutate(pct_poverty = B17001_002E / B17001_001E,
           pct_noHS = B06009_002E / B06009_001E,
           pct_FHH = B09008_011E / B09008_001E,
           pct_mgmt = B08124_002E /  B08124_001E,
           pct_crowd =  (B25014_005E + B25014_006E + B25014_007E +
                           B25014_011E + B25014_012E + B25014_013E) / B25014_001E,
           pct_pubassist = B19058_002E / B19058_001E,
           pct_unempl = (C23002A_008E + C23002A_021E) / (C23002A_006E + C23002A_019E),
           pct_under30K =( B19001_002E + B19001_003E + B19001_004E +
                             B19001_005E +  B19001_006E) / B19001_001E)

  values  <-  acs_data %>%
    dplyr::select(pct_poverty,
                  pct_noHS,
                  pct_FHH,
                  pct_mgmt,
                  pct_crowd,
                  pct_pubassist,
                  pct_unempl,
                  pct_under30K) %>%
    as.matrix()

  values[is.nan(values)] <- 0

  ND <- psych::principal(values,
                         nfactors = 1)

  NDI <- cbind(acs_data,
               ND$scores)

  NDI <- NDI %>%
    dplyr::select(NAME,
                  GEOID,
                  PC1,
                  57:64) %>%
    rename(NDI = PC1)  %>%
    dplyr::as_tibble()

    write_excel_csv(NDI, file = "R\\deprivation.csv")

  return(NDI)

}

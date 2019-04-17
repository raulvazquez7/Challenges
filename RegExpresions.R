# First Part ####

# Load the Data from the follow link https://storage.googleapis.com/um_ds_intro/university_towns.txt


# Create a DataFrame of towns and the states they are in 
# from the university_towns.txt list.

# The format of the DataFrame should be:
# header = ["State", "Region Name", "Acronys"]
#           ["Michigan", "Ann Arbor", "MI"]
#           ["Michigan", "Yipsilanti", "MI"]


# The following cleaning needs to be done:
# 1. For "State", removing characters from "[" to the end.
# 2. For "RegionName", when applicable, removing every character from " (" to the end.
# 3. Depending on how you read the data, you may need to remove newline character '\n'. 
# 4. the states names need to become a acronys of two letter like this list

# 'OH': 'Ohio', 'KY': 'Kentucky', 'AS': 'American Samoa', 'NV': 'Nevada', 'WY': 'Wyoming',
# 'NA': 'National', 'AL': 'Alabama', 'MD': 'Maryland', 'AK': 'Alaska', 'UT': 'Utah',
# 'OR': 'Oregon', 'MT': 'Montana', 'IL': 'Illinois', 'TN': 'Tennessee',
# 'DC': 'District of Columbia', 'VT': 'Vermont', 'ID': 'Idaho',
# 'AR': 'Arkansas', 'ME': 'Maine', 'WA': 'Washington', 'HI': 'Hawaii', 'WI': 'Wisconsin',
# 'MI': 'Michigan', 'IN': 'Indiana', 'NJ': 'New Jersey', 'AZ': 'Arizona', 'GU': 'Guam',
# 'MS': 'Mississippi', 'PR': 'Puerto Rico', 'NC': 'North Carolina', 'TX': 'Texas',
# 'SD': 'South Dakota', 'MP': 'Northern Mariana Islands', 'IA': 'Iowa',
# 'MO': 'Missouri', 'CT': 'Connecticut', 'WV': 'West Virginia', 'SC': 'South Carolina',
# 'LA': 'Louisiana', 'KS': 'Kansas', 'NY': 'New York', 'NE': 'Nebraska',
# 'OK': 'Oklahoma', 'FL': 'Florida', 'CA': 'California', 'CO': 'Colorado',
# 'PA': 'Pennsylvania', 'DE': 'Delaware', 'NM': 'New Mexico', 'RI': 'Rhode Island',
# 'MN': 'Minnesota', 'VI': 'Virgin Islands', 'NH': 'New Hampshire', 'MA': 'Massachusetts',
# 'GA': 'Georgia', 'ND': 'North Dakota', 'VA': 'Virginia'

## PART 1 ##

pacman:: p_load("utils", "tidyr", "dplyr")
univ_towns <- read.delim("https://storage.googleapis.com/um_ds_intro/university_towns.txt", header= FALSE)

univ_towns <- unique(univ_towns) #duplicates detected

state <- grep("edit", univ_towns$V1, value = TRUE)
# university <- sub("^[^(]*", "", univ_towns$V1)

univ_towns$expression <- ifelse(grepl("edit",univ_towns$V1),"state","region")
# expression <- ifelse(grepl("edit",univ_towns$V1),"state","region")


for(st in state){    # go through each expression row and check if it is "city", if it is
  univ_towns$state <- ifelse (univ_towns$expression == "state", # take it, if not, copy the
                              as.character(univ_towns$V1),  # previous/lagged result
                              (lag(univ_towns$state)))
}

# delete state rows -> they are columns now
delete <- univ_towns$expression == "state"
univ_towns <- univ_towns[!delete, ]

region <- sub("\\(.*", "", univ_towns$V1) # everything before the "(", sustituted by "space"


#delete expression column
names(univ_towns)[2]<-paste("regionName")
univ_towns$regionName <- region

# clean state names
state_only <- sub("\\[.*", "", univ_towns$state)
univ_towns$state <- state_only


# Acronys

acronys <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL",
             "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI",
             "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK",
             "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")

states_txt <- unique(univ_towns$state)

acronys_df <- data.frame(states_txt, acronys)

## JOINT ##
univ_towns <- merge(univ_towns, acronys_df, by = "states_txt", "state")
univ_towns$V1 <- NULL
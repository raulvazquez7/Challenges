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
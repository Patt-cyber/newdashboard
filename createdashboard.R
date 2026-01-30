# Exercise Dashboard
# The Dashboard informatino
# https://favstats.github.io/dashboardr/index.html

# Open packages 
pck <- c("dplyr","modelsummary", "haven", "ggplot2", "tidyverse", "psych", "patchwork", "Hmisc")
options(repos = c(CRAN = "https://cran.r-project.org"))
lapply(pck[!(pck %in% installed.packages())],
       install.packages)
lapply(c(pck), library, character.only = TRUE)
rm(pck)

#Open other packages
core_pkgs <- c(
  "devtools",
  "usethis",
  "roxygen2",
  "testthat",
  "pkgdown",
  "fs",
  "cli",
  "glue"
)

data_pkgs <- c(
  "tidyverse",
  "here",
  "janitor",
  "lubridate"
)

pkgs <- c(
  core_pkgs,
  data_pkgs,
  "dashboardr"
)

invisible(lapply(pkgs, library, character.only = TRUE))

# Open data
load("I://Mi unidad//PhD//Thesis//NEPS paper//Data//sc2-wd//Gender_data.RData")
data_num <- data_num%>%
  select(c("gender", "school_type", "child_effort"))

# 1ST LAYER CREATE a container
descriptives <- create_content(data = data_num, type = "bar") %>%
  add_text("This section presents demographics of the respondents") %>% 
  add_viz(x_var = "gender", title = "Gender children", tabgroup = "Demographics") %>% 
  add_viz(x_var = "school_type", title = "School", tabgroup = "Demographics", 
          text =  "**Note:** German school track system.", text_position = "below") %>%
  add_viz(x_var = "child_effort", title = "Effort Distribution", type = "histogram", tabgroup = "Effort") 

# 2. SECOND LAYER: CREATE PAGES
# 2.a) Page
home <- create_page("Home", is_landing_page = TRUE) %>%
  add_text(
    "##This is my Dashboard for the workshop",
    "",
    "With this Dashboard, I can explore the relation between gender and effort.",
    "",
    "For this project, the NEPS SC2 data was used. "
  )

# 2.b) 
visualizations <- create_page("Descriptives", data = data_num) %>% 
  add_content(descriptives)

# 3. THIRD LAYER: CREATE DASHBOARD 
patri_dashboard <- create_dashboard(
  title = "Gender Effort Project",
  output_dir = "Mydashboard",
  publish_dir = "docs",
  theme = "cosmo"
) %>%
  add_pages(home, visualizations)

patri_dashboard %>%
  generate_dashboard(render = TRUE, open = "browser")


# Now PUBLISH in Github (GitHub account needed)
library(usethis)

# Git needs to know your name and email. Run this in R with your information:
use_git_config(
  user.name = "Patt-cyber",
  user.email = "pllabrado45@gmail.com"
)

#Check it worked
git_sitrep()

# Set Up Authentication
# GitHub needs a way to verify it’s really you. 
#We’ll create a Personal Access Token (PAT).

#Create Your Token
#Run this command in R:

usethis::create_github_token()

# This will:
#Open GitHub in your browser
#Pre-fill a token creation form
#On the GitHub page:

# Add a note like “dashboardr publishing” (to remember what it’s for)
#Click the green “Generate token” button at the bottom
#IMPORTANT: Copy the token that appears (it looks like ghp_xxxxxxxxxxxx)
#Save it somewhere safe - you won’t be able to see it again!

#Now tell R about your token:

gitcreds::gitcreds_set()

#When prompted, paste your token and press Enter.

publish_dashboard()  # Uses defaults above

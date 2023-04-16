## load R libraries
options(tidyverse.quiet = TRUE)
library(tidyverse)
library(readxl)
library(zoo, warn.conflicts = FALSE)

## Set ggplot2 theme
theme_set(theme_bw())

theme_update(panel.border = element_blank(),
             axis.line.x = element_line(linewidth = 0.2),
             axis.line.y = element_line(linewidth = 0.2),
             text = element_text(size = 9))


## Read data
ipc_db <- read_xlsx("data/IPCa.xlsx", range = "b9:b322",
                    col_names = "ipc")
ipc <- zooreg(ipc_db$ipc, start = c(1997, 1), frequency = 12)

## Compute inflation rates
lp <- log(ipc)
infl <- 100 * diff(lp, lag = 12)


## #+header: :width 4.0 :height 2.47 :family "Times" :R-dev-args encoding = "ISOLatin9.enc"
## #+begin_src R :results output graphics file :exports results :file figures/infl.pdf

pdf(file = "figures/fig-08a_1027-infl.pdf", family = "Times",
    width = 4.0, height = 2.4, encoding = "ISOLatin9.enc")
autoplot(window(infl, start = "1999-1")) +
    scale_y_continuous(breaks = seq(0, 10, 2)) +
    scale_x_yearmon(breaks = seq(2000, 2023, 5), format = "%Y",
                    minor_breaks = seq(1999, 2023, 1)) +
    labs(x = NULL, y = NULL)
dev.off()


## Trends: GDP
pib_db <- read_xlsx("data/pib.xlsx", range = "b2:b28",
                    col_names = "pib")

pib <- zooreg(pib_db$pib / 1000, start = 1995, frequency = 1)

## #+header: :width 4.0 :height 2.47 :family "Times" :R-dev-args encoding = "ISOLatin9.enc"
## #+begin_src R :results output graphics file :exports results :file figures/pib.pdf

pdf(file = "figures/fig-08a_1027-gdp.pdf", family = "Times",
    width = 4.0, height = 2.4, encoding = "ISOLatin9.enc")
autoplot(pib) +
    scale_x_continuous(breaks = seq(1995, 2023, 5),
                       minor_breaks = seq(1995, 2023, 1)) +
    labs(x = NULL, y = NULL)
dev.off()


## Seasonality:retail trade index
com_db <- read_xlsx("data/IComMinor.xlsx", range = "b9:b285",
                    col_names = "icom")

icom <- zooreg(com_db$icom, start = c(2000, 1), frequency = 12)


## #+header: :width 4.0 :height 2.30 :family "Times" :R-dev-args encoding = "ISOLatin9.enc"
## #+begin_src R :results output graphics file :exports results :file figures/icom.pdf

pdf(file = "figures/fig-08a_1027-retail.pdf", family = "Times",
    width = 4.0, height = 2.3, encoding = "ISOLatin9.enc")
autoplot(window(icom, end = "2022-12")) +
    scale_x_yearmon(breaks = seq(2000, 2023, 5), format = "%Y",
                    minor_breaks = seq(2000, 2023, 1)) +
    labs(x = NULL, y = NULL)
dev.off()

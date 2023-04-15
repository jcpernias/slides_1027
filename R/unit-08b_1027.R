library(zoo)

## Make an AR(1) process with parameter rho from white noise
## series et.
ar1_build <- function(et, rho, start = 0) {
    y <- numeric(length(et))

    y[1] <- start
    for (i in seq_along(et)) {
        y[i + 1] = rho * y[i] + et[i]
    }
    zooreg(y, start = 0)
}

## Returns the the first k sample autocorrelations of x
get_acf <- function(x, k) {
    rho <- acf(x, lag.max = k, plot = FALSE)$acf
    rho[-1]
}

## Write data to a csv file
write_csv <- function(data, file) {
    write.zoo(data, file, sep = ",", quote = FALSE, na = "")
}


## Simulation parameters
T <- 60
seed <- 122345
s2_e <- 4

## Set up simulations
sd_e <- sqrt(s2_e)
set.seed(seed)

## White noise
wn <- rnorm(T, sd = sd_e) |> zooreg(start = 1, frequency = 1)

## First lag of white noise
wn_1 <- lag(wn, k = -1)

## AR(1) simulations
ar8 <- ar1_build(wn, rho =  0.8)
ar8_1 <- lag(ar8, k = -1)

ar5 <- ar1_build(wn, rho =  0.5)
ar5_1 <- lag(ar5, k = -1)

ar2 <- ar1_build(wn, rho =  0.2)
ar2_1 <- lag(ar2, k = -1)

arm6 <- ar1_build(wn, rho =  -0.6)
arm6_1 <- lag(arm6, k = -1)

## Random walk
drw <- zooreg(c(0, wn), start = 0)
rw <- cumsum(drw)

## Random walk with drift
rwd <- cumsum(drw + 1)

## Trend stationarity
tst <- 5 + 0:T + ar5

series <- merge(wn, wn_1, ar8, ar8_1, ar5, ar5_1,
                ar2, ar2_1, arm6, arm6_1, rw, rwd, tst) |>
    window(start = 1, end = T)

write_csv(series, "unit-08b_1027-sim.csv")

## Theoretical autocorrelations
h <- 1:10
rho <- c(0.8, 0.5, 0.2, -0.6)
acf_tab <- sapply(h, \(x) c(x, rho ^ x))  |> t()
colnames(acf_tab) <- c("h", "ar8", "ar5", "ar2", "arm6")
write.csv(acf_tab, file = "unit-08b_1027-acf.csv",
          row.names = FALSE, quote = FALSE)

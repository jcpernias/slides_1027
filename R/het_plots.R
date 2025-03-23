options(tidyverse.quiet = TRUE)
library(tidyverse)
library(rlang, warn.conflicts = FALSE)

mkdb <- function(pars) {
    if (!is.null(pars$seed))
        set.seed(pars$seed)

    x <- seq(pars$rangex[1], pars$rangex[2], length.out = pars$n)

    if (is_formula(pars$sigma))
        sdu <- eval_tidy(f_rhs(pars$sigma))
    else
        sdu <- pars$sigma
    u <- rnorm(pars$n, mean = 0, sd = sdu)
    y <- pars$beta[1] + pars$beta[2] * x + u
    tibble(y, x, u)
}

base_plot <- function(data) {
    ggplot(data = data, mapping = aes(x = x, y = y)) +
        theme_classic() +
        theme(axis.title.x =
                  element_text(family = "Times", face = "italic", size = 12,
                               angle = 0, hjust = 1,
                               margin = margin(t = 0.08, unit = "inches")),
              axis.title.y =
                  element_text(family = "Times", face = "italic", size = 12,
                               angle = 0, hjust = 1,
                               margin = margin(r = 0.08, unit = "inches")),
              axis.line =
                  element_line(colour = 'black', linewidth = 0.5,
                               lineend = "round",
                               arrow = grid::arrow(ends = "last", type = "closed",
                                                   angle = 22.5,
                                                   length = unit(0.05, "inches"))),
              axis.ticks = element_blank(),
              axis.text = element_blank(),
              )
}

mkplot <- function(data, pars, shades = NULL) {
    dx <- (pars$rangex[2] - pars$rangex[1]) / 50
    line_db <- tibble(
  	x0 = pars$rangex[1] - dx,
  	x1 = pars$rangex[2] + dx,
  	y0 = pars$beta[1] + pars$beta[2] * x0,
  	y1 = pars$beta[1] + pars$beta[2] * x1,
        )

    base <- base_plot(data) +
        geom_segment(data = line_db, aes(x = x0, xend = x1, y = y0, yend = y1),
                     linewidth = 0.4, colour = "DarkBlue") +
        scale_y_continuous(expand = c(0, 0),
                           limits = pars$ylimits,
                                        # breaks = NULL
                           ) +
        scale_x_continuous(expand = c(0, 0),
                           limits = pars$xlimits,
                                        # breaks = NULL
                           ) +
        ylab("y") + xlab("x")

    if (is.null(shades))
        final_plot <- base + geom_point(size = 0.2)
    else {
        in_shades <- reduce(map(shades, ~ between(db$x, .x[1], .x[2])), `|`)
        final_plot <- base +
            geom_point(data = filter(data, !in_shades), alpha = 0.1, size = 0.2) +
            geom_point(data = filter(data, in_shades), size = 0.2)
        for (sx in shades) {
            final_plot <- final_plot +
                annotate("rect", xmin = sx[1], xmax = sx[2],
                         ymin = pars$ylimits[1], ymax = pars$ylimits[2],
                         alpha = .1, fill = "Blue")
        }
    }

    final_plot
}


pars <- list(
  seed = 12101492,
  n = 400,
  rangex = c(1, 10),
  sigma = 45,
  beta = c(100, 60),
  ylimits = c(0, 1000),
  xlimits = c(0, 11)
)

shades <- list(c(2.5, 3.5), c(6.5, 7.5))

db <- mkdb(pars)
plot_het1 <- mkplot(db, pars)
ggsave("./img/het1.pdf", plot_het1, dpi = "print",
       width = 6, height = 6, units = "cm")
plot_het2 <- mkplot(db, pars, shades)
ggsave("./img/het2.pdf", plot_het2, dpi = "print",
       width = 6, height = 6, units = "cm")

pars_het <- pars
pars_het$sigma <- ~ 1 + 10 * x + 0.5 * x^2

db_het <- mkdb(pars_het)
plot_het3 <- mkplot(db_het, pars_het)
ggsave("./img/het3.pdf", plot_het3, dpi = "print",
       width = 6, height = 6, units = "cm")

plot_het4 <- mkplot(db_het, pars_het, shades)
ggsave("./img/het4.pdf", plot_het4, dpi = "print",
       width = 6, height = 6, units = "cm")

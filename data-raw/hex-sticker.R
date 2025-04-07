library(cropcircles)
#library(tibble)
library(ggplot2)
library(ggpath)
library(showtext)

# choose a font from Google Fonts
font_add_google("Fira Sans", "firasans")
showtext_auto()

img_cropped <- hex_crop(
  images = here::here("data-raw","spider_orchid.png"),
  bg_fill = "#c6c698",
  border_colour = "#a9bd40",
  border_size = 16
)

ggplot() +
  geom_from_path(aes(0.5, 0.5, path = img_cropped)) +
  annotate("text",
           x = 0.36, y = -0.84, label = "spiderorchid", family = "firasans", size = 15, colour = "white",
           angle = 30, hjust = 0, fontface = "bold"
  ) +
  #annotate("text",
  #         x = 0.5, y = -0.3, label = "spiderorchid", family = "firasans", size = 18, colour = "white",
  #         fontface = "bold"
  #) +
  xlim(-1, 2) +
  ylim(-1, 2) +
  theme_void() +
  coord_fixed()

ggsave("./man/figures/spiderorchid-hex.png", height = 6, width = 6)

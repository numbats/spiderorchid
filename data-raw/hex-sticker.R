library(cropcircles)
library(ggplot2)
library(ggpath)
library(showtext)
library(magick)

# choose a font from Google Fonts
font_add_google("Fira Sans", "firasans")
showtext_auto()

img_cropped <- hex_crop(
  images = here::here("data-raw","spider_orchid.png"),
  bg_fill = "#c6c698",
  border_colour = "#a9bd40",
  border_size = 50
)

ggplot() +
  geom_from_path(aes(0.5, 0.5, path = img_cropped)) +
  annotate("text",
           x = -0.78, y = 1.12, label = "spiderorchid", family = "firasans", size = 16, colour = "white",
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

ggsave("./man/figures/spiderorchid-hex.png", height = 2.5, width = 2.5)

# Trim transparent edges
img <- image_read("./man/figures/spiderorchid-hex.png")
img_trim <- image_trim(img)

image_write(img_trim, "./man/figures/spiderorchid-hex.png")

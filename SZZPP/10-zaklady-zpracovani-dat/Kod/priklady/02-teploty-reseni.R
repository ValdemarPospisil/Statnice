# ============================================================
# Cvičný příklad 2 — teploty (řešení)
# ============================================================
# Cvičí OPAČNÝ směr pivotu než ukázková úloha (long místo wide)
# a hlavně práci s chybějícími hodnotami.

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2)
})

teploty <- read.csv("teploty.csv", stringsAsFactors = FALSE)
teploty$datum <- as.Date(teploty$datum)     # POZOR: z CSV se načte jako text!

cat("=== POPIS DAT ===\n")
str(teploty)
cat("Řádků:", nrow(teploty), "\n")
cat("Období:", format(min(teploty$datum)), "až", format(max(teploty$datum)), "\n")
cat("Chybějících hodnot celkem:", sum(is.na(teploty)), "\n")
print(colSums(is.na(teploty)))

# --- ÚKOL 1: převod do dlouhého formátu ---------------------
# Tři sloupce s teplotami -> jeden sloupec "teplota" + sloupec "denni_doba".
# Tohle je OPAK pivot_wider z ukázkové úlohy.
cat("\n=== ÚKOL 1: dlouhý formát ===\n")
dlouhy <- teploty %>%
  pivot_longer(
    cols = starts_with("teplota_"),
    names_to = "denni_doba",
    names_prefix = "teplota_",     # odstraní prefix -> zůstane rano/poledne/vecer
    values_to = "teplota"
  )
cat("Před:", nrow(teploty), "řádků ×", ncol(teploty), "sloupců\n")
cat("Po:  ", nrow(dlouhy), "řádků ×", ncol(dlouhy), "sloupců\n")
print(head(as.data.frame(dlouhy), 6))

# --- ÚKOL 2: denní průměr, ošetření NA ----------------------
cat("\n=== ÚKOL 2: průměr podle stanic ===\n")
# BEZ na.rm by stačila jediná NA a celý průměr by byl NA:
cat("Bez na.rm:", mean(teploty$teplota_rano), "\n")
cat("S na.rm:  ", round(mean(teploty$teplota_rano, na.rm = TRUE), 2), "\n\n")

prumery <- dlouhy %>%
  group_by(stanice) %>%
  summarise(
    mereni      = n(),
    chybi       = sum(is.na(teplota)),
    prumer      = round(mean(teplota, na.rm = TRUE), 2),
    median      = round(median(teplota, na.rm = TRUE), 2),
    min         = min(teplota, na.rm = TRUE),
    max         = max(teplota, na.rm = TRUE),
    .groups = "drop"
  )
print(as.data.frame(prumery))

# --- ÚKOL 3: dny nad 30 °C ----------------------------------
cat("\n=== ÚKOL 3: dny s teplotou nad 30 °C ===\n")
horke <- dlouhy %>%
  filter(!is.na(teplota), teplota > 30) %>%     # !is.na() PŘED porovnáním
  arrange(desc(teplota))

cat("Počet měření nad 30 °C:", nrow(horke), "\n")
if (nrow(horke) > 0) {
  print(head(as.data.frame(horke), 5))
  cat("\nPodle stanic:\n")
  print(table(horke$stanice))
}

# --- ÚKOL 4: boxploty ---------------------------------------
cat("\n=== ÚKOL 4: boxploty ===\n")
p1 <- ggplot(filter(dlouhy, !is.na(teplota)), aes(x = stanice, y = teplota, fill = stanice)) +
  geom_boxplot(show.legend = FALSE) +
  labs(title = "Rozdělení teplot podle stanic", x = NULL, y = "Teplota (°C)") +
  theme_minimal()
ggsave("/tmp/zzd/t1-stanice.png", p1, width = 8, height = 5, dpi = 100)

# faceting: rozdělí graf na podgrafy podle denní doby
p2 <- dlouhy %>%
  filter(!is.na(teplota)) %>%
  mutate(denni_doba = factor(denni_doba, levels = c("rano","poledne","vecer"))) %>%
  ggplot(aes(x = stanice, y = teplota, fill = stanice)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~ denni_doba) +
  labs(title = "Teploty podle stanice a denní doby", x = NULL, y = "Teplota (°C)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("/tmp/zzd/t2-facet.png", p2, width = 10, height = 5, dpi = 100)
cat("Uloženy dva boxploty\n")
# POZOR na factor: bez levels by ggplot seřadil abecedně (poledne, rano, vecer)

# --- ÚKOL 5: průběh v čase ----------------------------------
cat("\n=== ÚKOL 5: spojnicový graf ===\n")
denni <- dlouhy %>%
  filter(!is.na(teplota)) %>%
  group_by(stanice, datum) %>%
  summarise(prumer = mean(teplota), .groups = "drop")

p3 <- ggplot(denni, aes(x = datum, y = prumer, colour = stanice)) +
  geom_line(alpha = .8) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x, linewidth = 1.2) +
  labs(title = "Průběh denních průměrných teplot",
       x = NULL, y = "Průměrná teplota (°C)", colour = "Stanice") +
  theme_minimal()
ggsave("/tmp/zzd/t3-prubeh.png", p3, width = 10, height = 5, dpi = 100)
cat("Uložen spojnicový graf\n")

# --- INTERPRETACE -------------------------------------------
cat("\n=== INTERPRETACE ===\n")
nej <- prumery %>% arrange(desc(prumer))
cat("Nejteplejší stanice:", nej$stanice[1], nej$prumer[1], "°C\n")
cat("Nejchladnější:      ", nej$stanice[nrow(nej)], nej$prumer[nrow(nej)], "°C\n")
cat("Rozdíl:", round(nej$prumer[1] - nej$prumer[nrow(nej)], 2), "°C\n")
cat("\nPozn.: chybějící hodnoty tvoří",
    round(100 * sum(is.na(dlouhy$teplota)) / nrow(dlouhy), 1),
    "% měření — ošetřeno přes na.rm = TRUE.\n")

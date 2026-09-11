# ============================================================
# Cvičný příklad 1 — prodeje podle poboček (řešení)
# ============================================================
# U zkoušky by tohle byl .qmd protokol; tady je to .R skript,
# aby šel rychle spustit. Struktura úkolů je stejná.

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(stringr); library(ggplot2)
})

prodeje <- read.csv("prodeje.csv", stringsAsFactors = FALSE)

cat("=== POPIS DAT ===\n")
str(prodeje)
cat("Řádků:", nrow(prodeje), "| chybějících hodnot:", sum(is.na(prodeje)), "\n")
cat("Pobočky:", paste(unique(prodeje$pobocka), collapse = ", "), "\n\n")

# --- ÚKOL 1: průměrná cena za kus ---------------------------
# PAST: pocet_kusu může být 0 -> dělení nulou dá Inf.
# Ošetřeno přes ifelse: kde je nula, dáme NA.
cat("=== ÚKOL 1: průměrná cena ===\n")
prodeje <- prodeje %>%
  mutate(prumerna_cena = ifelse(pocet_kusu > 0, trzba / pocet_kusu, NA))

cat("Řádků s nulovým počtem kusů:", sum(prodeje$pocet_kusu == 0), "\n")
cat("Vzniklo NA:", sum(is.na(prodeje$prumerna_cena)), "\n")
print(head(prodeje[, c("pobocka", "kategorie", "trzba", "pocet_kusu", "prumerna_cena")], 3))

# --- ÚKOL 2: filtr poboček obsahujících "Praha" -------------
cat("\n=== ÚKOL 2: jen pražské pobočky ===\n")
praha <- prodeje %>% filter(str_detect(pobocka, "Praha"))
cat("Před:", nrow(prodeje), "| po filtru:", nrow(praha), "\n")
print(table(praha$pobocka))

# --- ÚKOL 3: celková tržba pobočka x kategorie --------------
cat("\n=== ÚKOL 3: tržba podle pobočky a kategorie ===\n")
souhrn <- prodeje %>%
  group_by(pobocka, kategorie) %>%
  summarise(
    celkem_trzba = sum(trzba),
    celkem_kusu  = sum(pocet_kusu),
    prum_cena    = mean(prumerna_cena, na.rm = TRUE),   # na.rm kvůli NA z úkolu 1
    .groups = "drop"
  )
print(as.data.frame(souhrn))

# --- ÚKOL 4: široký formát ----------------------------------
cat("\n=== ÚKOL 4: kategorie jako sloupce ===\n")
siroky <- souhrn %>%
  select(pobocka, kategorie, celkem_trzba) %>%
  pivot_wider(names_from = kategorie, values_from = celkem_trzba)
print(as.data.frame(siroky))

# --- ÚKOL 5: grafy ------------------------------------------
cat("\n=== ÚKOL 5: grafy ===\n")

# geom_col, protože data jsou UŽ zagregovaná (geom_bar by počítal řádky)
p1 <- souhrn %>%
  group_by(pobocka) %>%
  summarise(trzba = sum(celkem_trzba), .groups = "drop") %>%
  ggplot(aes(x = reorder(pobocka, trzba), y = trzba / 1000, fill = pobocka)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +                      # vodorovně, ať se vejdou názvy
  labs(title = "Celková tržba podle poboček", x = NULL, y = "Tržba (tis. Kč)") +
  theme_minimal()
ggsave("/tmp/zzd/p1-trzby.png", p1, width = 8, height = 5, dpi = 100)

p2 <- ggplot(prodeje, aes(x = trzba / 1000)) +
  geom_histogram(bins = 25, fill = "steelblue", colour = "white") +
  labs(title = "Rozdělení tržeb", x = "Tržba (tis. Kč)", y = "Počet záznamů") +
  theme_minimal()
ggsave("/tmp/zzd/p2-histogram.png", p2, width = 8, height = 5, dpi = 100)

p3 <- ggplot(prodeje, aes(x = kategorie, y = trzba / 1000, fill = kategorie)) +
  geom_boxplot(show.legend = FALSE) +
  labs(title = "Rozdělení tržeb podle kategorie", x = NULL, y = "Tržba (tis. Kč)") +
  theme_minimal()
ggsave("/tmp/zzd/p3-boxplot.png", p3, width = 8, height = 5, dpi = 100)

cat("Uloženy tři grafy do /tmp/zzd/\n")

# --- INTERPRETACE -------------------------------------------
cat("\n=== INTERPRETACE ===\n")
nej <- souhrn %>% group_by(pobocka) %>%
  summarise(t = sum(celkem_trzba), .groups = "drop") %>% arrange(desc(t))
cat("Nejvyšší tržba:", nej$pobocka[1], round(nej$t[1]/1000), "tis. Kč\n")
cat("Nejnižší tržba:", nej$pobocka[nrow(nej)], round(nej$t[nrow(nej)]/1000), "tis. Kč\n")
cat("Poměr:", round(nej$t[1] / nej$t[nrow(nej)], 2), "x\n")

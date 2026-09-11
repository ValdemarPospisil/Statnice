# ============================================================
# Vygeneruje testovací data pro okruh 10
# Spuštění:  Rscript vytvor-data.R    nebo v RStudiu source()
# ============================================================
# Vytvoří:
#   StudentsPerformance.csv  — replika datové sady z ukázkové úlohy
#   prodeje.csv              — data pro cvičný příklad 1
#   teploty.csv              — data pro cvičný příklad 2 (s NA!)

set.seed(42)

# --- 1) StudentsPerformance.csv ------------------------------
n <- 1000
gender <- sample(c("female", "male"), n, replace = TRUE)
race <- sample(paste("group", LETTERS[1:5]), n, replace = TRUE,
               prob = c(.09, .19, .32, .26, .14))
edu <- sample(c("bachelor's degree", "some college", "master's degree",
                "associate's degree", "high school", "some high school"),
              n, replace = TRUE, prob = c(.12, .23, .06, .22, .20, .17))
lunch <- sample(c("standard", "free/reduced"), n, replace = TRUE, prob = c(.65, .35))
prep <- sample(c("none", "completed"), n, replace = TRUE, prob = c(.64, .36))

# skóre závisí na kategoriích -> v datech jsou vidět rozdíly mezi skupinami
base <- 55 + (gender == "female") * 2 +
        match(race, paste("group", LETTERS[1:5])) * 2.5 +
        (prep == "completed") * 7 + (lunch == "standard") * 6

df <- data.frame(
  gender                      = gender,
  race.ethnicity              = race,
  parental.level.of.education = edu,
  lunch                       = lunch,
  test.preparation.course     = prep,
  math.score    = pmin(100, pmax(0, round(base + (gender == "male")   * 5 + rnorm(n, 0, 14)))),
  reading.score = pmin(100, pmax(0, round(base + (gender == "female") * 6 + rnorm(n, 0, 13)))),
  writing.score = pmin(100, pmax(0, round(base + (gender == "female") * 7 + rnorm(n, 0, 13))))
)
write.csv(df, "StudentsPerformance.csv", row.names = FALSE)

# --- 2) prodeje.csv (cvičný příklad 1) -----------------------
pobocky <- c("Praha - Smíchov", "Praha - Vinohrady", "Brno - centrum",
             "Ostrava - Poruba", "Ústí nad Labem")
kategorie <- c("Elektronika", "Potraviny", "Drogerie", "Oblečení")
mesice <- month.name[1:6]

prodeje <- expand.grid(pobocka = pobocky, mesic = mesice,
                       kategorie = kategorie, stringsAsFactors = FALSE)
prodeje$pocet_kusu <- rpois(nrow(prodeje), lambda = 120)
prodeje$trzba <- round(prodeje$pocet_kusu *
                       runif(nrow(prodeje), 50, 800) *
                       (1 + 0.3 * grepl("Praha", prodeje$pobocka)), 2)
# schválně pár nulových prodejů -> past na dělení nulou
prodeje$pocet_kusu[sample(nrow(prodeje), 5)] <- 0
prodeje$trzba[prodeje$pocet_kusu == 0] <- 0
write.csv(prodeje, "priklady/prodeje.csv", row.names = FALSE)

# --- 3) teploty.csv (cvičný příklad 2) -----------------------
stanice <- c("Praha-Ruzyně", "Brno-Tuřany", "Ostrava-Mošnov", "Churáňov")
dny <- seq(as.Date("2026-06-01"), as.Date("2026-08-31"), by = "day")

teploty <- expand.grid(stanice = stanice, datum = dny, stringsAsFactors = FALSE)
den_v_roce <- as.numeric(format(teploty$datum, "%j"))
sezonni <- 18 + 8 * sin((den_v_roce - 100) / 365 * 2 * pi)
vyska <- ifelse(teploty$stanice == "Churáňov", -5, 0)   # horská stanice je chladnější

teploty$teplota_rano    <- round(sezonni + vyska - 4 + rnorm(nrow(teploty), 0, 2.5), 1)
teploty$teplota_poledne <- round(sezonni + vyska + 5 + rnorm(nrow(teploty), 0, 3.0), 1)
teploty$teplota_vecer   <- round(sezonni + vyska + 1 + rnorm(nrow(teploty), 0, 2.5), 1)

# CHYBĚJÍCÍ HODNOTY — schválně, kvůli na.rm = TRUE
for (sl in c("teplota_rano", "teplota_poledne", "teplota_vecer")) {
  teploty[sample(nrow(teploty), 20), sl] <- NA
}
write.csv(teploty, "priklady/teploty.csv", row.names = FALSE)

cat("Hotovo:\n")
cat("  StudentsPerformance.csv  ", nrow(df), "řádků\n")
cat("  priklady/prodeje.csv     ", nrow(prodeje), "řádků\n")
cat("  priklady/teploty.csv     ", nrow(teploty), "řádků,",
    sum(is.na(teploty)), "chybějících hodnot\n")

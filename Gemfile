source "https://rubygems.org"

# Stavíme přes GitHub Actions, ne přes starý Pages builder — proto čistý Jekyll,
# a ne gem `github-pages`. Ten pinuje Jekyll 3.9 + liquid 4.0.3, které volají
# `tainted?` odstraněné v Ruby 3.2, takže by build spadl.
gem "jekyll", "~> 4.4"

# kramdown s `input: GFM` (viz _config.yml) potřebuje v Jekyllu 4 vlastní parser
gem "kramdown-parser-gfm"

# Ruby 3.4 přesunulo tyhle knihovny z default gems mezi bundled — pod bundlerem
# je proto musíme uvést, jinak build spadne na `cannot load such file -- erb`.
gem "erb"
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"

group :jekyll_plugins do
  gem "jekyll-remote-theme"      # téma pages-themes/primer
  gem "jekyll-include-cache"     # vyžaduje primer
  gem "jekyll-github-metadata"   # vyžaduje primer
  gem "jekyll-seo-tag"           # titulky a metadata stránek

  # Tyhle tři zapínal github-pages gem sám za nás, teď je musíme uvést ručně —
  # bez nich se poznámky vůbec nevykreslí:
  gem "jekyll-optional-front-matter"  # README.md bez YAML hlavičky je pořád stránka
  gem "jekyll-readme-index"           # README.md v okruhu se stane index.html složky
  gem "jekyll-relative-links"         # odkazy typu ../PLAN.md vedou na správné URL
end

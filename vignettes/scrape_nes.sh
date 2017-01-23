touch res.csv

for page in 11 12 13
do
  echo $page
  Rscript scrape_nes.R $page
done

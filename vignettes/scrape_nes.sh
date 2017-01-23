pages=`cat pages.txt`

touch res.csv

for page in $pages
do
  echo $page
  Rscript scrape_nes.R $page
done

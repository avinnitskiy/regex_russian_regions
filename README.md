# Regex for Russian Regions (RRR)
An R regex function that creates primary keys for Russian regions.

## 1. Issue
Russian regional data often does not include any primary keys for each region with the exeption of their names. At the same time, the names of Russian regions vary no less often from dataset to dataset. For example, there are several common diffusions in naming of the same region: 
* Federal cities: "г. Москва" vs "Москва";
* Presence of republic status and its order: "Чечня" vs "Чеченская республика" vs "Республика Чечня";
* Co-existing of Russian and indigenous names: "Якутия" vs "Саха";
* Informal/nonofficial and official names: "Башкирия" vs "Башкортостан".

The absence of any primary keys other than widely varying names makes it very difficult for researchers to analyze the data. Especially when work requires merging either several regional level datasets or individual-level dataset containing regional attributes for each respondent. In both cases, you have to ad hoc bring the names to uniformity, even if you use the string distance (for example, the Levenshtein distance between the "Omsk region" and the "Tomsk region" is 1).

## 2. Regex Solution
To overcome the above issues, I created a simple R function based on regex. It takes a raw vector of russian regions as an input and produces corresponding vector of primary keys. It consists of two obligatory arguments:
1. `russian_regions` — a vector input, that takes raw names of Russian regions from your data;
2. `code` — a character/string, that indicates which primary key you want to get. Currently could be either "[ISO_3166_2](https://www.iso.org/obp/ui/#iso:code:3166:RU)" or "[GOST_7_67](https://protect.gost.ru/document.aspx?control=7&id=129611)". The latter one is Latin 3-letter version.

Quick illustration of functionality:

```r
russian_regions_raw <- c("г. Москва", "Санкт-Петербург", "Башкирия", 
                         "ХМАО", "Саха", "Якутия", "Крым", "Читинская область",  
                         "Российская Федерация", "Северо-Кавказский федеральный округ")

primary_keys_iso <- get_regional_id(russian_regions_raw, code = "ISO_3166_2")
primary_keys_iso
# [1] "RU-MOW" "RU-SPE" "RU-BA" "RU-KHM" "RU-SA" "RU-SA" "UA-43" "RU-CHI" NA NA

primary_keys_gost <- get_regional_id(russian_regions_raw, code = "GOST_7_67")
primary_keys_gost
# [1] "RU-MOW" "RU-SPB" "RU-BAS" "RU-KHM" "RU-SAH" "RU-SAH" "RU-CRI*" "RU-CHI" NA NA
```

The basis of the function is a dictionary with a pair of key (regex-pattern) - value (code-ids). In the keys, the regions follow the order prescribed in the Constitution of the Russian Federation — that is, according to the administrative-territorial hierarchy (republics $\to$ krais $\to$ oblasts $\to$ federal cities $\to$ autonomous oblast $\to$ autonomous okrugs). Within each administrative unit, regions are sorted alphabetically, while the administrative-territorial division is ignored in alphabetical order.

## 3. Limitations and testing
Currently the function supports regional names only in Russian as an input. It has been tested and robust to territorial changes since 1993 to the present. It does not take into account the Chechen-Ingush Republic, which ceased to exist in 1992, but takes into account the regions that existed before the unification — "Читинская область", "Агинский Бурятский автономный округ", "Коми-Пермяцкий автономный округ", "Корякский автономный округ", "Таймырский (Долгано-Ненецкий) автономный округ", "Усть-Ордынский Бурятский автономный округ", "Эвенкийский автономный округ". The dictionary does not contain new regions after 2022, but function can work with the old ones to the present. It is also resistant to situations where federal districts or the name of the country appear in the same column along with regions. It was tested via [regex101](https://regex101.com/). In addition to, functionality was checked on three datasets containing popular Russian regional-level data:
1. [Rosstat Census 2020 data](https://rosstat.gov.ru/vpn/2020);
2. [Environmental data of "Если быть точным" project](https://tochno.st/datasets/environment);
3. [COVID-19 Yandex DataLens data](https://datalens.yandex/7o7is1q6ikh23?tab=0Ze).
 
 Despite the successful completion of all tests, it is always possible to detect the limitations of the function. Especially when it comes to tricky nature of regex, and at least because the human imagination in naming knows no boundaries. Therefore, if a study uses the function, it is highly recommended to carry out at least a minimal verification of the keys received. If the dataset is not large, you can briefly compare the raw names with the resulting code abbreviations. Otherwise, you can use the following ways for testing:
1. In case of failling to detect a region — in order to test whether the regex capture all obtained regions or not, you can use: `sum(is.na(primary_keys))`. If NAs are detected, you should pay attention to the missings, whether they are the result of a dataset itself or the result of a regex flaws;
2. In case of wrong detection — in order to test whether the regex doesn't classify regions wrongly, you can try: `data.table::uniqueN(primary_keys) == data.table::uniqueN(raw_regions)`. If there are no missings, the result should be TRUE. Otherwise, it is possible that several different regions have received the same id. However, this method does not work if regex incorrectly identified an equal number of regions.

If you found any issue/inconsistency/way to improve regarding regex or anything, please, consider a contribution, I'll be very grateful! 

## 4. Plans to do
* [ ] Create an English-version regex for merging with [geoBoundaries](https://www.geoboundaries.org/) and international data;
* [ ] Create a Python-compatible version;
* [ ] Add scripts with testing;
* [ ] Add other primary keys to facilitate merging with data that does not contain the names of regions (for example, "ОКАТО").
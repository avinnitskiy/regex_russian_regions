# 1. Loading libraries
library(stringr)
library(tibble)

# 2. Function creation
get_regional_id <- function(russian_regions, code) {
  
  regex_dict <- list(
                     # republics
                     "\\D*Адыг\\D*" = c("RU-AD", "RU-ADY", "79"),
                     "\\D*Алтай$" = c("RU-AL", "RU-ALI", "84"),
                     "\\D*Башк\\D*" = c("RU-BA", "RU-BAS", "80"),
                     "\\D*Бурят\\D*" = c("RU-BU", "RU-BUR", "81"),
                     "\\D*Дагестан\\D*" = c("RU-DA", "RU-DAG", "82"),
                     "\\D*Ингушети\\D*" = c("RU-IN", "RU-ING", "26"),
                     "\\D*Кабардин\\D*" = c("RU-KB", "RU-KAB", "83"),
                     "\\D*Калмык\\D*" = c("RU-KL", "RU-KAI", "85"),
                     "\\D*Карачаев\\D*" = c("RU-KC", "RU-KAO", "91"),
                     "\\D*Карел\\D*" = c("RU-KR", "RU-KAR", "86"),
                     "\\D*Коми\\D*" = c("RU-KO", "RU-KOM", "87"),
                     "\\D*Крым\\D*" = c("UA-43", "RU-CRI*", "35"),
                     "\\D*Марий\\D*" = c("RU-ME", "RU-MAR", "88"),
                     "\\D*Мордов\\D*" = c("RU-MO", "RU-MOR", "89"),
                     "\\D*Якут\\D*|\\D*Саха$" = c("RU-SA", "RU-SAH", "98"),
                     "\\D*Осети\\D*|\\D*Алани\\D*" = c("RU-SE", "RU-NOR", "90"),
                     "\\D*Татар\\D*" = c("RU-TA", "RU-TAT", "92"),
                     "\\D*Т.ва\\D*" = c("RU-TY", "RU-TUV", "93"),
                     "\\D*Удмурт\\D*" = c("RU-UD", "RU-UDM", "94"),
                     "\\D*Хакас\\D*" = c("RU-KK", "RU-KHK", "95"),
                     "\\D*Чеч[ен|ня]\\D*" = c("RU-CE", "RU-CHA", "96"),
                     "\\D*Чуваш\\D*" = c("RU-CU", "RU-CHV", "97"),
                     # krais / administrative territories
                     "\\D*Алтайск\\D*" = c("RU-ALT", "RU-ALT", "01"),
                     "\\D*Забайкальск\\D*" = c("RU-ZAB", "RU-ZAB", "76"),
                     "\\D*Камчат\\D*" = c("RU-KAM", "RU-KAM", "30"),
                     "\\D*Краснодар\\D*" = c("RU-KDA", "RU-KRA", "03"),
                     "\\D*Красноярск\\D*" = c("RU-KYA", "RU-KYA", "04"),
                     "\\D*Пермск\\D*" = c("RU-PER", "RU-PER", "57"),
                     "\\D*Примор\\D*" = c("RU-PRI", "RU-PRI", "05"),
                     "\\D*Ставрополь\\D*" = c("RU-STA", "RU-STA", "07"),
                     "\\D*Хабаровск\\D*" = c("RU-KHA", "RU-KHA", "08"),
                     # oblasts / administrative regions
                     "\\D*Амурск\\D*" = c("RU-AMU", "RU-AMU", "10"),
                     "\\D*Архангельска\\D*" = c("RU-ARK", "RU-ARK", "11"),
                     "\\D*Астраханск\\D*" = c("RU-AST", "RU-AST", "12"),
                     "\\D*Белгородск\\D*" = c("RU-BEL", "RU-BEL", "14"),
                     "\\D*Брянска\\D*" = c("RU-BRY", "RU-BRY", "15"),
                     "\\D*Владимирск\\D*" = c("RU-VLA", "RU-VLA", "17"),
                     "\\D*Волгоградск\\D*" = c("RU-VGG", "RU-VGG", "18"),
                     "\\D*Вологодск\\D*" = c("RU-VLG", "RU-VLG", "19"),
                     "\\D*Воронежск\\D*" = c("RU-VOR", "RU-VOR", "20"),
                     "\\D*Ивановск\\D*" = c("RU-IVA", "RU-IVA", "24"),
                     "\\D*Иркутск\\D*" = c("RU-IRK", "RU-IRK", "25"),
                     "\\D*Калининградск\\D*" = c("RU-KGD", "RU-KAG", "27"),
                     "\\D*Калужск\\D*" = c("RU-KLU", "RU-KLU", "29"),
                     "\\D*Кемеровск\\D*|\\D*Кузбас\\D*" = c("RU-KEM", "RU-KEM", "32"),
                     "\\D*Кировск\\D*" = c("RU-KIR", "RU-KIR", "33"),
                     "\\D*Костромск\\D*" = c("RU-KOS", "RU-KOS", "34"),
                     "\\D*Курганск\\D*" = c("RU-KGN", "RU-KUG", "37"),
                     "\\D*Курск\\D*" = c("RU-KRS", "RU-KUR", "38"),
                     "\\D*Ленинградск\\D*" = c("RU-LEN", "RU-LEN", "41"),
                     "\\D*Липецк\\D*" = c("RU-LIP", "RU-LIP", "42"),
                     "\\D*Магаданск\\D*" = c("RU-MAG", "RU-MAG", "44"),
                     "\\D*Московск\\D*" = c("RU-MOS", "RU-MOS", "46"),
                     "\\D*Мурманск\\D*" = c("RU-MUR", "RU-MUR", "47"),
                     "\\D*Нижегородск\\D*" = c("RU-NIZ", "RU-NIZ", "22"),
                     "\\D*Новгородск\\D*" = c("RU-NGR", "RU-NGR", "49"),
                     "\\D*Новосибирск\\D*" = c("RU-NVS", "RU-NVS", "50"),
                     "\\D*Омск\\D*" = c("RU-OMS", "RU-OMS", "52"),
                     "\\D*Оренбург\\D*" = c("RU-ORE", "RU-ORE", "53"),
                     "\\D*Орловск\\D*" = c("RU-ORL", "RU-ORL", "54"),
                     "\\D*Пензенск\\D*" = c("RU-PNZ", "RU-PNZ", "56"),
                     "\\D*Псковск\\D*" = c("RU-PSK", "RU-PSK", "58"),
                     "\\D*Ростовск\\D*" = c("RU-ROS", "RU-ROS", "60"),
                     "\\D*Рязанск\\D*" = c("RU-RYA", "RU-RYA", "61"),
                     "\\D*Самарск\\D*" = c("RU-SAM", "RU-SAM", "36"),
                     "\\D*Саратовск\\D*" = c("RU-SAR", "RU-SAR", "63"),
                     "^Сахалинск\\D*" = c("RU-SAK", "RU-SAK", "64"),
                     "\\D*Свердловск\\D*" = c("RU-SVE", "RU-SVE", "65"),
                     "\\D*Смоленск\\D*" = c("RU-SMO", "RU-SMO", "66"),
                     "\\D*Тамбовск\\D*" = c("RU-TAM", "RU-TAM", "68"),
                     "\\D*Тверск\\D*" = c("RU-TVE", "RU-TVE", "28"),
                     "\\D*Томск\\D*" = c("RU-TOM", "RU-TOM", "69"),
                     "\\D*Тульск\\D*" = c("RU-TUL", "RU-TUL", "70"),
                     "\\D*Тюменск\\D*" = c("RU-TYU", "RU-TYU", "71"),
                     "\\D*Ульяновск\\D*" = c("RU-ULY", "RU-ULY", "73"),
                     "\\D*Челябинск\\D*" = c("RU-CHE", "RU-CHE", "75"),
                     "\\D*Читинск\\D*" = c("RU-CHI", "RU-CHI", "76"), # Читинская область
                     "\\D*Ярославск\\D*" = c("RU-YAR", "RU-YAR", "78"),
                     # cities of federal importance, federal cities / autonomous cities
                     "\\D*Москв\\D*" = c("RU-MOW", "RU-MOW", "45"),
                     "\\D*Петербург\\D*" = c("RU-SPE", "RU-SPB", "40"),
                     "\\D*Севастоп\\D*" = c("UA-40", "RU-SEV*", "67"),
                     # autonomous oblast / autonomous region
                     "\\D*Еврейск\\D*" = c("RU-YEV", "RU-JEW", "99"),
                     # autonomous okrugs / autonomous districts
                     "\\D*Агинск\\D*" = c("RU-AGB", "RU-AGB", "761"), # Агинский Бурятский автономный округ
                     "\\D*Пермяцк\\D*" = c("RU-KOP", "RU-KIM", "571"), # Коми-Пермяцкий автономный округ
                     "\\D*Корякск\\D*" = c("RU-KOR", "RU-KOR", "301"), # Корякский автономный округ
                     "^Ненецк\\D*|^НАО$" = c("RU-NEN", "RU-NEN", "111"),
                     "\\D*Таймырск\\D*|\\D*Долгано-Ненецк\\D*" = c("RU-TAY", "RU-TAY", "041"), # Таймырский (Долгано-Ненецкий) автономный округ
                     "\\D*Ордынск\\D*" = c("RU-UOB", "RU-UOB", "251"), # Усть-Ордынский Бурятский автономный округ
                     "\\D*Мансийск\\D*|\\D*ХМАО\\D*" = c("RU-KHM", "RU-KHM", "71100"), 
                     "\\D*Чукот.\\D*" = c("RU-CHU", "RU-CHU", "77"),
                     "\\D*Эвенкийск\\D*" = c("RU-EVE", "RU-EVE", "0413"), # Эвенкийский автономный округ
                     "\\D*Ямало\\D*|^ЯНАО$" = c("RU-YAN", "RU-YAN", "71140")) |>
    as_tibble() |>
    t() |>
    as.data.frame() |>
    setNames(c("ISO_3166_2", "GOST_7_67", "OKATO"))
  
  output_vec <- str_replace_all(russian_regions, 
                                setNames(regex_dict[, code], rownames(regex_dict)))
  
  output_vec <- ifelse(output_vec %in% regex_dict[, code], output_vec, NA)
  
  return(output_vec)

}

# 3. Execution example
russian_regions_raw <- c("г. Москва", "Санкт-Петербург", "Башкирия", 
                         "ХМАО", "Саха", "Якутия", "Крым", "Читинская область",  
                         "Российская Федерация", "Северо-Кавказский федеральный округ")

primary_keys_iso <- get_regional_id(russian_regions_raw, code = "ISO_3166_2")
primary_keys_iso

primary_keys_gost <- get_regional_id(russian_regions_raw, code = "GOST_7_67")
primary_keys_gost

primary_keys_okato <- get_regional_id(russian_regions_raw, code = "OKATO")
primary_keys_okato

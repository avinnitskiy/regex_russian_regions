# 1. Loading libraries
library(stringr)
library(tibble)

# 2. Function creation
get_regional_id <- function(russian_regions, code) {
  
  regex_dict <- list(
                     # republics
                     "\\D*Адыг\\D*" = c("RU-AD", "RU-ADY"),
                     "\\D*Алтай$" = c("RU-AL", "RU-ALI"),
                     "\\D*Башк\\D*" = c("RU-BA", "RU-BAS"),
                     "\\D*Бурят\\D*" = c("RU-BU", "RU-BUR"),
                     "\\D*Дагестан\\D*" = c("RU-DA", "RU-DAG"),
                     "\\D*Ингушети\\D*" = c("RU-IN", "RU-ING"),
                     "\\D*Кабардин\\D*" = c("RU-KB", "RU-KAB"),
                     "\\D*Калмык\\D*" = c("RU-KL", "RU-KAI"),
                     "\\D*Карачаев\\D*" = c("RU-KC", "RU-KAO"),
                     "\\D*Карел\\D*" = c("RU-KR", "RU-KAR"),
                     "\\D*Коми\\D*" = c("RU-KO", "RU-KOM"),
                     "\\D*Крым\\D*" = c("UA-43", "RU-CRI*"),
                     "\\D*Марий\\D*" = c("RU-ME", "RU-MAR"),
                     "\\D*Мордов\\D*" = c("RU-MO", "RU-MOR"),
                     "\\D*Якут\\D*|\\D*Саха$" = c("RU-SA", "RU-SAH"),
                     "\\D*Осети\\D*|\\D*Алани\\D*" = c("RU-SE", "RU-NOR"),
                     "\\D*Татар\\D*" = c("RU-TA", "RU-TAT"),
                     "\\D*Т.ва\\D*" = c("RU-TY", "RU-TUV"),
                     "\\D*Удмурт\\D*" = c("RU-UD", "RU-UDM"),
                     "\\D*Хакас\\D*" = c("RU-KK", "RU-KHK"),
                     "\\D*Чеч[ен|ня]\\D*" = c("RU-CE", "RU-CHA"),
                     "\\D*Чуваш\\D*" = c("RU-CU", "RU-CHV"),
                     # krais / administrative territories
                     "\\D*Алтайск\\D*" = c("RU-ALT", "RU-ALT"),
                     "\\D*Забайкальск\\D*" = c("RU-ZAB", "RU-ZAB"),
                     "\\D*Камчат\\D*" = c("RU-KAM", "RU-KAM"),
                     "\\D*Краснодар\\D*" = c("RU-KDA", "RU-KRA"),
                     "\\D*Красноярск\\D*" = c("RU-KYA", "RU-KYA"),
                     "\\D*Пермск\\D*" = c("RU-PER", "RU-PER"),
                     "\\D*Примор\\D*" = c("RU-PRI", "RU-PRI"),
                     "\\D*Ставрополь\\D*" = c("RU-STA", "RU-STA"),
                     "\\D*Хабаровск\\D*" = c("RU-KHA", "RU-KHA"),
                     # oblasts / administrative regions
                     "\\D*Амурск\\D*" = c("RU-AMU", "RU-AMU"),
                     "\\D*Архангельска\\D*" = c("RU-ARK", "RU-ARK"),
                     "\\D*Астраханск\\D*" = c("RU-AST", "RU-AST"),
                     "\\D*Белгородск\\D*" = c("RU-BEL", "RU-BEL"),
                     "\\D*Брянска\\D*" = c("RU-BRY", "RU-BRY"),
                     "\\D*Владимирск\\D*" = c("RU-VLA", "RU-VLA"),
                     "\\D*Волгоградск\\D*" = c("RU-VGG", "RU-VGG"),
                     "\\D*Вологодск\\D*" = c("RU-VLG", "RU-VLG"),
                     "\\D*Воронежск\\D*" = c("RU-VOR", "RU-VOR"),
                     "\\D*Ивановск\\D*" = c("RU-IVA", "RU-IVA"),
                     "\\D*Иркутск\\D*" = c("RU-IRK", "	RU-IRK"),
                     "\\D*Калининградск\\D*" = c("RU-KGD", "RU-KAG"),
                     "\\D*Калужск\\D*" = c("RU-KLU", "RU-KLU"),
                     "\\D*Кемеровск\\D*|\\D*Кузбас\\D*" = c("RU-KEM", "RU-KEM"),
                     "\\D*Кировск\\D*" = c("RU-KIR", "RU-KIR"),
                     "\\D*Костромск\\D*" = c("RU-KOS", "RU-KOS"),
                     "\\D*Курганск\\D*" = c("RU-KGN", "RU-KUG"),
                     "\\D*Курск\\D*" = c("RU-KRS", "RU-KUR"),
                     "\\D*Ленинградск\\D*" = c("RU-LEN", "RU-LEN"),
                     "\\D*Липецк\\D*" = c("RU-LIP", "RU-LIP"),
                     "\\D*Магаданск\\D*" = c("RU-MAG", "RU-MAG"),
                     "\\D*Московск\\D*" = c("RU-MOS", "RU-MOS"),
                     "\\D*Мурманск\\D*" = c("RU-MUR", "RU-MUR"),
                     "\\D*Нижегородск\\D*" = c("RU-NIZ", "RU-NIZ"),
                     "\\D*Новгородск\\D*" = c("RU-NGR", "RU-NGR"),
                     "\\D*Новосибирск\\D*" = c("RU-NVS", "RU-NVS"),
                     "\\D*Омск\\D*" = c("RU-OMS", "RU-OMS"),
                     "\\D*Оренбург\\D*" = c("RU-ORE", "RU-ORE"),
                     "\\D*Орловск\\D*" = c("RU-ORL", "RU-ORL"),
                     "\\D*Пензенск\\D*" = c("RU-PNZ", "RU-PNZ"),
                     "\\D*Псковск\\D*" = c("RU-PSK", "RU-PSK"),
                     "\\D*Ростовск\\D*" = c("RU-ROS", "RU-ROS"),
                     "\\D*Рязанск\\D*" = c("RU-RYA", "RU-RYA"),
                     "\\D*Самарск\\D*" = c("RU-SAM", "RU-SAM"),
                     "\\D*Саратовск\\D*" = c("RU-SAR", "RU-SAR"),
                     "^Сахалинск\\D*" = c("RU-SAK", "RU-SAK"),
                     "\\D*Свердловск\\D*" = c("RU-SVE", "RU-SVE"),
                     "\\D*Смоленск\\D*" = c("RU-SMO", "RU-SMO"),
                     "\\D*Тамбовск\\D*" = c("RU-TAM", "RU-TAM"),
                     "\\D*Тверск\\D*" = c("RU-TVE", "RU-TVE"),
                     "\\D*Томск\\D*" = c("RU-TOM", "RU-TOM"),
                     "\\D*Тульск\\D*" = c("RU-TUL", "RU-TUL"),
                     "\\D*Тюменск\\D*" = c("RU-TYU", "RU-TYU"),
                     "\\D*Ульяновск\\D*" = c("RU-ULY", "RU-ULY"),
                     "\\D*Челябинск\\D*" = c("RU-CHE", "RU-CHE"),
                     "\\D*Читинск\\D*" = c("RU-CHI", "RU-CHI"), # Читинская область
                     "\\D*Ярославск\\D*" = c("RU-YAR", "RU-YAR"),
                     # cities of federal importance, federal cities / autonomous cities
                     "\\D*Москв\\D*" = c("RU-MOW", "RU-MOW"),
                     "\\D*Петербург\\D*" = c("RU-SPE", "RU-SPB"),
                     "\\D*Севастоп\\D*" = c("UA-40", "RU-SEV*"),
                     # autonomous oblast / autonomous region
                     "\\D*Еврейск\\D*" = c("RU-YEV", "RU-JEW"),
                     # autonomous okrugs / autonomous districts
                     "\\D*Агинск\\D*" = c("RU-AGB", "RU-AGB"), # Агинский Бурятский автономный округ
                     "\\D*Пермяцк\\D*" = c("RU-KOP", "RU-KOP"), # Коми-Пермяцкий автономный округ
                     "\\D*Корякск\\D*" = c("RU-KOR", "RU-KOR"), # Корякский автономный округ
                     "^Ненецк\\D*|^НАО$" = c("RU-NEN", "RU-NEN"),
                     "\\D*Таймырск\\D*|\\D*Долгано-Ненецк\\D*" = c("RU-TAY", "RU-TAY"), # Таймырский (Долгано-Ненецкий) автономный округ
                     "\\D*Ордынск\\D*" = c("RU-UOB", "RU-UOB"), # Усть-Ордынский Бурятский автономный округ
                     "\\D*Мансийск\\D*|\\D*ХМАО\\D*" = c("RU-KHM", "RU-KHM"), 
                     "\\D*Чукот.\\D*" = c("RU-CHU", "RU-CHU"),
                     "\\D*Эвенкийск\\D*" = c("RU-EVE", "RU-EVE"), # Эвенкийский автономный округ
                     "\\D*Ямало\\D*|^ЯНАО$" = c("RU-YAN", "RU-YAN")) |>
    as_tibble() |>
    t() |>
    as.data.frame() |>
    setNames(c("ISO_3166_2", "GOST_7_67"))
  
  output_vec <- str_replace_all(russian_regions, 
                                setNames(regex_dict[, code], rownames(regex_dict)))
  
  output_vec <- ifelse(output_vec %in% regex_dict[, code], output_vec, NA)
  
  return(output_vec)

}

# 3. Execution example
russian_regions_raw <- c("г. Москва", "Санкт-Петербург", "Башкирия", 
                         "ХМАО", "Саха", "Якутия", "Крым", "Читинская область",  
                         "Российская Федерация", "Северо-Кавказский федеральный округ")

primary_keys_iso <- get_regional_id(russian_regions_raw, 
                                    code = "ISO_3166_2")
primary_keys_iso

primary_keys_gost <- get_regional_id(russian_regions_raw, 
                                    code = "GOST_7_67")
primary_keys_gost

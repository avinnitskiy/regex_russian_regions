# 1. Loading libraries
import pandas as pd

# 2. Function creation
def get_regional_id(russian_regions, code):
    
    regex_dict = {
                  # republics
                  "\\D*Адыг\\D*": ["RU-AD", "RU-ADY"],
                  "\\D*Алтай$": ["RU-AL", "RU-ALI"],
                  "\\D*Башк\\D*": ["RU-BA", "RU-BAS"],
                  "\\D*Бурят\\D*": ["RU-BU", "RU-BUR"],
                  "\\D*Дагестан\\D*": ["RU-DA", "RU-DAG"],
                  "\\D*Ингушети\\D*": ["RU-IN", "RU-ING"],
                  "\\D*Кабардин\\D*": ["RU-KB", "RU-KAB"],
                  "\\D*Калмык\\D*": ["RU-KL", "RU-KAI"],
                  "\\D*Карачаев\\D*": ["RU-KC", "RU-KAO"],
                  "\\D*Карел\\D*": ["RU-KR", "RU-KAR"],
                  "\\D*Коми\\D*": ["RU-KO", "RU-KOM"],
                  "\\D*Крым\\D*": ["UA-43", "RU-CRI*"],
                  "\\D*Марий\\D*": ["RU-ME", "RU-MAR"],
                  "\\D*Мордов\\D*": ["RU-MO", "RU-MOR"],
                  "\\D*Якут\\D*|\\D*Саха$": ["RU-SA", "RU-SAH"],
                  "\\D*Осети\\D*|\\D*Алани\\D*": ["RU-SE", "RU-NOR"],
                  "\\D*Татар\\D*": ["RU-TA", "RU-TAT"],
                  "\\D*Т.ва\\D*": ["RU-TY", "RU-TUV"],
                  "\\D*Удмурт\\D*": ["RU-UD", "RU-UDM"],
                  "\\D*Хакас\\D*": ["RU-KK", "RU-KHK"],
                  "\\D*Чеч[ен|ня]\\D*": ["RU-CE", "RU-CHA"],
                  "\\D*Чуваш\\D*": ["RU-CU", "RU-CHV"],
                  # krais / administrative territories
                  "\\D*Алтайск\\D*": ["RU-ALT", "RU-ALT"],
                  "\\D*Забайкальск\\D*": ["RU-ZAB", "RU-ZAB"],
                  "\\D*Камчат\\D*": ["RU-KAM", "RU-KAM"],
                  "\\D*Краснодар\\D*": ["RU-KDA", "RU-KRA"],
                  "\\D*Красноярск\\D*": ["RU-KYA", "RU-KYA"],
                  "\\D*Пермск\\D*": ["RU-PER", "RU-PER"],
                  "\\D*Примор\\D*": ["RU-PRI", "RU-PRI"],
                  "\\D*Ставрополь\\D*": ["RU-STA", "RU-STA"],
                  "\\D*Хабаровск\\D*": ["RU-KHA", "RU-KHA"],
                  # oblasts / administrative regions
                  "\\D*Амурск\\D*": ["RU-AMU", "RU-AMU"],
                  "\\D*Архангельска\\D*": ["RU-ARK", "RU-ARK"],
                  "\\D*Астраханск\\D*": ["RU-AST", "RU-AST"],
                  "\\D*Белгородск\\D*": ["RU-BEL", "RU-BEL"],
                  "\\D*Брянска\\D*": ["RU-BRY", "RU-BRY"],
                  "\\D*Владимирск\\D*": ["RU-VLA", "RU-VLA"],
                  "\\D*Волгоградск\\D*": ["RU-VGG", "RU-VGG"],
                  "\\D*Вологодск\\D*": ["RU-VLG", "RU-VLG"],
                  "\\D*Воронежск\\D*": ["RU-VOR", "RU-VOR"],
                  "\\D*Ивановск\\D*": ["RU-IVA", "RU-IVA"],
                  "\\D*Иркутск\\D*": ["RU-IRK", "RU-IRK"],
                  "\\D*Калининградск\\D*": ["RU-KGD", "RU-KAG"],
                  "\\D*Калужск\\D*": ["RU-KLU", "RU-KLU"],
                  "\\D*Кемеровск\\D*|\\D*Кузбас\\D*": ["RU-KEM", "RU-KEM"],
                  "\\D*Кировск\\D*": ["RU-KIR", "RU-KIR"],
                  "\\D*Костромск\\D*": ["RU-KOS", "RU-KOS"],
                  "\\D*Курганск\\D*": ["RU-KGN", "RU-KUG"],
                  "\\D*Курск\\D*": ["RU-KRS", "RU-KUR"],
                  "\\D*Ленинградск\\D*": ["RU-LEN", "RU-LEN"],
                  "\\D*Липецк\\D*": ["RU-LIP", "RU-LIP"],
                  "\\D*Магаданск\\D*": ["RU-MAG", "RU-MAG"],
                  "\\D*Московск\\D*": ["RU-MOS", "RU-MOS"],
                  "\\D*Мурманск\\D*": ["RU-MUR", "RU-MUR"],
                  "\\D*Нижегородск\\D*": ["RU-NIZ", "RU-NIZ"],
                  "\\D*Новгородск\\D*": ["RU-NGR", "RU-NGR"],
                  "\\D*Новосибирск\\D*": ["RU-NVS", "RU-NVS"],
                  "\\D*Омск\\D*": ["RU-OMS", "RU-OMS"],
                  "\\D*Оренбург\\D*": ["RU-ORE", "RU-ORE"],
                  "\\D*Орловск\\D*": ["RU-ORL", "RU-ORL"],
                  "\\D*Пензенск\\D*": ["RU-PNZ", "RU-PNZ"],
                  "\\D*Псковск\\D*": ["RU-PSK", "RU-PSK"],
                  "\\D*Ростовск\\D*": ["RU-ROS", "RU-ROS"],
                  "\\D*Рязанск\\D*": ["RU-RYA", "RU-RYA"],
                  "\\D*Самарск\\D*": ["RU-SAM", "RU-SAM"],
                  "\\D*Саратовск\\D*": ["RU-SAR", "RU-SAR"],
                  "^Сахалинск\\D*": ["RU-SAK", "RU-SAK"],
                  "\\D*Свердловск\\D*": ["RU-SVE", "RU-SVE"],
                  "\\D*Смоленск\\D*": ["RU-SMO", "RU-SMO"],
                  "\\D*Тамбовск\\D*": ["RU-TAM", "RU-TAM"],
                  "\\D*Тверск\\D*": ["RU-TVE", "RU-TVE"],
                  "\\D*Томск\\D*": ["RU-TOM", "RU-TOM"],
                  "\\D*Тульск\\D*": ["RU-TUL", "RU-TUL"],
                  "\\D*Тюменск\\D*": ["RU-TYU", "RU-TYU"],
                  "\\D*Ульяновск\\D*": ["RU-ULY", "RU-ULY"],
                  "\\D*Челябинск\\D*": ["RU-CHE", "RU-CHE"],
                  "\\D*Читинск\\D*": ["RU-CHI", "RU-CHI"], # Читинская область
                  "\\D*Ярославск\\D*": ["RU-YAR", "RU-YAR"],
                  # cities of federal importance, federal cities / autonomous cities
                  "\\D*Москв\\D*": ["RU-MOW", "RU-MOW"],
                  "\\D*Петербург\\D*": ["RU-SPE", "RU-SPB"],
                  "\\D*Севастоп\\D*": ["UA-40", "RU-SEV*"],
                  # autonomous oblast / autonomous region
                  "\\D*Еврейск\\D*": ["RU-YEV", "RU-JEW"],
                  # autonomous okrugs / autonomous districts
                  "\\D*Агинск\\D*": ["RU-AGB", "RU-AGB"], # Агинский Бурятский автономный округ
                  "\\D*Пермяцк\\D*": ["RU-KOP", "RU-KIM"], # Коми-Пермяцкий автономный округ
                  "\\D*Корякск\\D*": ["RU-KOR", "RU-KOR"], # Корякский автономный округ
                  "^Ненецк\\D*|^НАО$": ["RU-NEN", "RU-NEN"],
                  "\\D*Таймырск\\D*|\\D*Долгано-Ненецк\\D*": ["RU-TAY", "RU-TAY"], # Таймырский (Долгано-Ненецкий) автономный округ
                  "\\D*Ордынск\\D*": ["RU-UOB", "RU-UOB"], # Усть-Ордынский Бурятский автономный округ
                  "\\D*Мансийск\\D*|\\D*ХМАО\\D*": ["RU-KHM", "RU-KHM"], 
                  "\\D*Чукот.\\D*": ["RU-CHU", "RU-CHU"],
                  "\\D*Эвенкийск\\D*": ["RU-EVE", "RU-EVE"], # Эвенкийский автономный округ
                  "\\D*Ямало\\D*|^ЯНАО$": ["RU-YAN", "RU-YAN"]
                  }

    regex_dict_df = pd.DataFrame.from_dict(regex_dict, orient = 'index', columns = ['ISO_3166_2', 'GOST_7_67']).reset_index()
    regex_dict_df.columns = ['regex_pattern', 'ISO_3166_2', 'GOST_7_67']

    output_vec = russian_regions.replace(regex_dict_df.set_index('regex_pattern')[code].to_dict(), regex = True)
    
    output_vec = output_vec.where(output_vec.isin(regex_dict_df[code]), other = None)
    
    return output_vec

# 3. Execution example
russian_regions_raw = ["г. Москва", "Санкт-Петербург", "Башкирия", 
                       "ХМАО", "Саха", "Якутия", "Крым", "Читинская область",  
                       "Российская Федерация", "Северо-Кавказский федеральный округ"]

primary_keys_iso = get_regional_id(pd.Series(russian_regions_raw), code = "ISO_3166_2")
print(primary_keys_iso)

primary_keys_gost = get_regional_id(pd.Series(russian_regions_raw), code = "GOST_7_67")
print(primary_keys_gost)

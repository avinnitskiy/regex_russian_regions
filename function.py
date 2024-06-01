# 1. Loading libraries
import pandas as pd

# 2. Function creation
def get_regional_id(russian_regions, code):
    regex_dict = {
                  # republics
                  r"\D*Адыг\D*": ["RU-AD", "RU-ADY", "79"],
                  r"\D*Алтай$": ["RU-AL", "RU-ALI", "84"],
                  r"\D*Башк\D*": ["RU-BA", "RU-BAS", "80"],
                  r"\D*Бурят\D*": ["RU-BU", "RU-BUR", "81"],
                  r"\D*Дагестан\D*": ["RU-DA", "RU-DAG", "82"],
                  r"\D*Ингушети\D*": ["RU-IN", "RU-ING", "26"],
                  r"\D*Кабардин\D*": ["RU-KB", "RU-KAB", "83"],
                  r"\D*Калмык\D*": ["RU-KL", "RU-KAI", "85"],
                  r"\D*Карачаев\D*": ["RU-KC", "RU-KAO", "91"],
                  r"\D*Карел\D*": ["RU-KR", "RU-KAR", "86"],
                  r"\D*Коми\D*": ["RU-KO", "RU-KOM", "87"],
                  r"\D*Крым\D*": ["UA-43", "RU-CRI*", "35"],
                  r"\D*Марий\D*": ["RU-ME", "RU-MAR", "88"],
                  r"\D*Мордов\D*": ["RU-MO", "RU-MOR", "89"],
                  r"\D*Якут\D*|\D*Саха$": ["RU-SA", "RU-SAH", "98"],
                  r"\D*Осети\D*|\D*Алани\D*": ["RU-SE", "RU-NOR", "90"],
                  r"\D*Татар\D*": ["RU-TA", "RU-TAT", "92"],
                  r"\D*Т.ва\D*": ["RU-TY", "RU-TUV", "93"],
                  r"\D*Удмурт\D*": ["RU-UD", "RU-UDM", "94"],
                  r"\D*Хакас\D*": ["RU-KK", "RU-KHK", "95"],
                  r"\D*Чеч[ен|ня]\D*": ["RU-CE", "RU-CHA", "96"],
                  r"\D*Чуваш\D*": ["RU-CU", "RU-CHV", "97"],
                  # krais / administrative territories
                  r"\D*Алтайск\D*": ["RU-ALT", "RU-ALT", "01"],
                  r"\D*Забайкальск\D*": ["RU-ZAB", "RU-ZAB", "76"],
                  r"\D*Камчат\D*": ["RU-KAM", "RU-KAM", "30"],
                  r"\D*Краснодар\D*": ["RU-KDA", "RU-KRA", "03"],
                  r"\D*Красноярск\D*": ["RU-KYA", "RU-KYA", "04"],
                  r"\D*Пермск\D*": ["RU-PER", "RU-PER", "57"],
                  r"\D*Примор\D*": ["RU-PRI", "RU-PRI", "05"],
                  r"\D*Ставрополь\D*": ["RU-STA", "RU-STA", "07"],
                  r"\D*Хабаровск\D*": ["RU-KHA", "RU-KHA", "08"],
                  # oblasts / administrative regions
                  r"\D*Амурск\D*": ["RU-AMU", "RU-AMU", "10"],
                  r"\D*Архангельска\D*": ["RU-ARK", "RU-ARK", "11"],
                  r"\D*Астраханск\D*": ["RU-AST", "RU-AST", "12"],
                  r"\D*Белгородск\D*": ["RU-BEL", "RU-BEL", "14"],
                  r"\D*Брянска\D*": ["RU-BRY", "RU-BRY", "15"],
                  r"\D*Владимирск\D*": ["RU-VLA", "RU-VLA", "17"],
                  r"\D*Волгоградск\D*": ["RU-VGG", "RU-VGG", "18"],
                  r"\D*Вологодск\D*": ["RU-VLG", "RU-VLG", "19"],
                  r"\D*Воронежск\D*": ["RU-VOR", "RU-VOR", "20"],
                  r"\D*Ивановск\D*": ["RU-IVA", "RU-IVA", "24"],
                  r"\D*Иркутск\D*": ["RU-IRK", "RU-IRK", "25"],
                  r"\D*Калининградск\D*": ["RU-KGD", "RU-KAG", "27"],
                  r"\D*Калужск\D*": ["RU-KLU", "RU-KLU", "29"],
                  r"\D*Кемеровск\D*|\D*Кузбас\D*": ["RU-KEM", "RU-KEM", "32"],
                  r"\D*Кировск\D*": ["RU-KIR", "RU-KIR", "33"],
                  r"\D*Костромск\D*": ["RU-KOS", "RU-KOS", "34"],
                  r"\D*Курганск\D*": ["RU-KGN", "RU-KUG", "37"],
                  r"\D*Курск\D*": ["RU-KRS", "RU-KUR", "38"],
                  r"\D*Ленинградск\D*": ["RU-LEN", "RU-LEN", "41"],
                  r"\D*Липецк\D*": ["RU-LIP", "RU-LIP", "42"],
                  r"\D*Магаданск\D*": ["RU-MAG", "RU-MAG", "44"],
                  r"\D*Московск\D*": ["RU-MOS", "RU-MOS", "46"],
                  r"\D*Мурманск\D*": ["RU-MUR", "RU-MUR", "47"],
                  r"\D*Нижегородск\D*": ["RU-NIZ", "RU-NIZ", "22"],
                  r"\D*Новгородск\D*": ["RU-NGR", "RU-NGR", "49"],
                  r"\\D*Новосибирск\D*": ["RU-NVS", "RU-NVS", "50"],
                  r"\D*Омск\D*": ["RU-OMS", "RU-OMS", "52"],
                  r"\D*Оренбург\D*": ["RU-ORE", "RU-ORE", "53"],
                  r"\D*Орловск\D*": ["RU-ORL", "RU-ORL", "54"],
                  r"\D*Пензенск\D*": ["RU-PNZ", "RU-PNZ", "56"],
                  r"\D*Псковск\D*": ["RU-PSK", "RU-PSK", "58"],
                  r"\D*Ростовск\D*": ["RU-ROS", "RU-ROS", "60"],
                  r"\D*Рязанск\D*": ["RU-RYA", "RU-RYA", "61"],
                  r"\D*Самарск\D*": ["RU-SAM", "RU-SAM", "36"],
                  r"\D*Саратовск\D*": ["RU-SAR", "RU-SAR", "63"],
                  r"^Сахалинск\D*": ["RU-SAK", "RU-SAK", "64"],
                  r"\D*Свердловск\D*": ["RU-SVE", "RU-SVE", "65"],
                  r"\D*Смоленск\D*": ["RU-SMO", "RU-SMO", "66"],
                  r"\D*Тамбовск\D*": ["RU-TAM", "RU-TAM", "68"],
                  r"\D*Тверск\D*": ["RU-TVE", "RU-TVE", "28"],
                  r"\D*Томск\D*": ["RU-TOM", "RU-TOM", "69"],
                  r"\D*Тульск\D*": ["RU-TUL", "RU-TUL", "70"],
                  r"\D*Тюменск\D*": ["RU-TYU", "RU-TYU", "71"],
                  r"\D*Ульяновск\D*": ["RU-ULY", "RU-ULY", "73"],
                  r"\D*Челябинск\D*": ["RU-CHE", "RU-CHE", "75"],
                  r"\D*Читинск\D*": ["RU-CHI", "RU-CHI", "76"], 
                  r"\D*Ярославск\D*": ["RU-YAR", "RU-YAR", "78"],
                  # cities of federal importance, federal cities / autonomous cities
                  r"\D*Москв\D*": ["RU-MOW", "RU-MOW", "45"],
                  r"\D*Петербург\D*": ["RU-SPE", "RU-SPB", "40"],
                  r"\D*Севастоп\D*": ["UA-40", "RU-SEV*", "67"],
                  # autonomous oblast / autonomous region
                  r"\D*Еврейск\D*": ["RU-YEV", "RU-JEW", "99"],
                  # autonomous okrugs / autonomous districts
                  r"\D*Агинск\D*": ["RU-AGB", "RU-AGB", "761"], 
                  r"\D*Пермяцк\D*": ["RU-KOP", "RU-KIM", "571"], 
                  r"\D*Корякск\D*": ["RU-KOR", "RU-KOR", "301"], 
                  r"^Ненецк\D*|^НАО$": ["RU-NEN", "RU-NEN", "111"],
                  r"\D*Таймырск\D*|\D*Долгано-Ненецк\D*": ["RU-TAY", "RU-TAY", "041"], 
                  r"\D*Ордынск\D*": ["RU-UOB", "RU-UOB", "251"], 
                  r"\D*Мансийск\D*|\D*ХМАО\D*": ["RU-KHM", "RU-KHM", "71100"], 
                  r"\D*Чукот\D*": ["RU-CHU", "RU-CHU", "77"],
                  r"\D*Эвенкийск\D*": ["RU-EVE", "RU-EVE", "0413"], 
                  r"\D*Ямало\D*|^ЯНАО$": ["RU-YAN", "RU-YAN", "71140"]
                  }

    regex_dict_df = pd.DataFrame.from_dict(regex_dict, orient = 'index', columns = ['ISO_3166_2', 'GOST_7_67', 'OKATO']).reset_index()
    regex_dict_df.columns = ['regex_pattern', 'ISO_3166_2', 'GOST_7_67', 'OKATO']

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

primary_keys_okato = get_regional_id(pd.Series(russian_regions_raw), code = "OKATO")
print(primary_keys_okato)

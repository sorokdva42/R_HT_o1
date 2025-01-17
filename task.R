
# Preparation -------------------------------------------------------------

# Somebody asked us to perform trend analysis of discharge data from the territory of Czechia in order to prove that climate change exists.
# We need to provide some evidence based on as many as possible water-gauging stations.
# We already collected mean daily discharge series between 1. 11. 1980 and 31. 12. 2022 (see OL2 Lesson and the QDdata2023_gzipped.rds file).
# We also know that in the file with the time series, we do not have every time series complete so we will base our analysis only on complete time series between 1. 1. 1981 and 31. 12. 2020.
# The tasks, therefore, will be as follows:


# Tasks for solving -------------------------------------------------------

# 1) select only complete time series of discharge on the territory of Czechia for the calendar period 1981-2020; functional programming and the complete() function applied after the nest() function application may be helpful (see their help pages and a vignette)
# 2) for each selected water-gauging station, compute mean annual discharge for each year; do not forget about arranging according to the year in an ascending order (otherwise, trend analysis is useless)
# 3) for each selected water-gauging station, perform a trend analysis using the linear model (function lm()); do not forget about placing proper dates (similar to beginnings of months) to the lm model
# 4) using the metadata in the QDmeta2023.rds file (see OL1 Lesson) and the kraje() function from the RCzechia package, construct a simple (point) map showing gauges with significant trends (at 0.05 level) in discharge (either the ggplot2 or the tmap package may be used)
# 5) do not forget about labeling the map, and adding the scale bar; do not forget about distinguishing the increasing trends (blue color) from decreasing trends (red color); insignificant trends may be shown by points with default settings (i.e. black circles)
# 6) upload the working R script (R file) and the final map figure (png, tif or pdf file) to our Classroom; the ggsave() function may be used to save the ggplot products

?complete()


# Preparation -------------------------------------------------------------

# Хтось попросив нас провести трендовий аналіз даних про скиди з території Чехії, 
# щоб довести, що кліматичні зміни існують.
# Нам потрібно надати деякі докази на основі якомога більшої кількості водомірних станцій.
# Ми вже зібрали середньодобові ряди стоку за період з 1.11.1980 р. по 31.12.1980 р. 1980 року до 31. 12. 2022 року 
# (див. урок OL2 та файл QDdata2023_gzipped.rds).
# Ми також знаємо, що у файлі з часовими рядами не всі часові ряди є повними, тому ми будемо 
# базувати наш аналіз лише на повних часових рядах між 1. 1. 1981 та 31. 12. 2020.
# Завдання, таким чином, будуть наступними:






# Завдання для розв'язання -------------------------------------------------------

# 1) відібрати тільки повні часові ряди стоку на території Чехії за календарний період 1981-2020 рр.; 
# у нагоді може стати функціональне програмування та функція complete(), що застосовується після застосування 
# функції nest() (див. їхні довідкові сторінки та віньєтку)
# 2) для кожного обраного водомірного поста обчислити середньорічні витрати для кожного року; 
# не забудьте впорядкувати дані по роках у порядку зростання (інакше аналіз тренду не матиме сенсу)
# 3) для кожного обраного поста виконати трендовий аналіз за допомогою лінійної моделі (функція lm()); 
# не забудьте підставити в модель lm відповідні дати (наприклад, початок місяця)
# 4) використовуючи метадані у файлі QDmeta2023.rds (див. урок OL1) та функцію kraje() з пакету RCzechia, 
# побудуйте просту (точкову) карту, на якій будуть показані опади зі значущими трендами (на рівні 0.05) 
# у витратах (можна використати пакет ggplot2 або tmap)
# 5) не забудьте підписати карту та додати масштабну лінійку; не забудьте відрізняти зростаючі тренди 
# (синій колір) від спадаючих (червоний колір); незначні тренди можуть бути показані точками 
# з налаштуваннями за замовчуванням (тобто чорними кружечками)
# 6) завантажте робочий R-скрипт (R-файл) та кінцевий рисунок карти (png, tif або pdf-файл) 
# у наш Classroom; для збереження продуктів ggplot можна використовувати функцію ggsave()


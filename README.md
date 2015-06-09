# Тестовое задание для wheely
Сдесь выполнено тестовое задание для wheely


## Особенность реализации:
Есть модель Car с аттрибутами num, available, location. num - ключевое поле (подразумевает номер машины)

ETA расчитывается по формуле, похожей на данной в задании.

Кэшируется по ключу ``` "#{lat.round}_#{long.round}:car1.car2.car3"```

Если одна из машин меняет местоположение больше, чем на константу - ключ из кэша удаляется.

Если в "закэшированной" зоне появляется новая машина - ключ из кэша удаляется

Константы взяты наобум, т.к. с геолокациями и геокодированием я дел никогда не имел.

Тестирование проводил бегло, может быть масса багов. Код местами не оптимизирован. И вообще я кодил во сне=)

## Installation


```shell
bundle install
cp config/mongoid.yml.example config/mongoid.yml
cp config/redis.yml.example config/redis.yml
rake mongoid:db:create_indexes
```

## Usage
Реализовано 2 endpoint
/cars
/eta

Чтобы добавить машину
```
POST /cars {"num":"car1","available":true,"location":[30.335,21.22]}
```

```shell
curl -X "POST" "http://wheely.borisaka.net/cars" \
	-d "{\"num\":\"car1\",\"available\":true,\"location\":[30.335,21.22]}"
```

Обновить координаты и/или статус доступности:
```
PATCH /cars/car1 {"location":[20,40],"available":false}
```

```shell
curl -X "PATCH" "http://wheely.borisaka.net/cars/car1" \
	-d "{\"location\":[20,40],\"available\":false}"
```

получить ETA
```
GET /eta?long=33.3334&lat=32.3334
```

```shell
curl -X "GET" "http://wheely.borisaka.net/eta?long=33.3334&lat=32.3334"
```
Для удобства, кроме ETA возвращает флаг cached 


Инфа о машине
```
GET /cars/car1
```

```shell
curl -X "GET" "http://wheely.borisaka.net/cars/car1"
```

Список машин
```
GET /cars
```

```shell
curl -X "GET" "http://wheely.borisaka.net/cars" 
```
## Демо версия

Работает на

[http://wheely.borisaka.net](http://wheely.borisaka.net)  (мой тестовый сервачок на амазоне)

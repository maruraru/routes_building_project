// Функция ymaps.ready() будет вызвана, когда
// загрузятся все компоненты API, а также когда будет готово DOM-дерево.
ymaps.ready(init);
var myMap;
function init(){
    // Создание карты.
    myMap = new ymaps.Map("map", {
        // Координаты центра карты.
        // Порядок по умолчанию: «широта, долгота».
        // Чтобы не определять координаты центра карты вручную,
        // воспользуйтесь инструментом Определение координат.
        center: [44.57, 33.50],
        // Уровень масштабирования. Допустимые значения:
        // от 0 (весь мир) до 19.
        zoom: 13
    });

    myMap.panes.get('ground').getElement().style.filter = 'saturate(150%)';

    // Выпадающая панель с поисковыми подсказками
    var suggestView = new ymaps.SuggestView(
        "address_search", // ID input'а
        {
            offset: [-2, 3], // Отступы панели подсказок от её положения по умолчанию.
            results: 3, // Максимальное количество показываемых подсказок.
        });

    let addresses = document.getElementsByClassName('address_item');
    if (addresses.length > 1) {
        let addressesArray = [];
        Array.from(addresses).forEach(function (sourceAddress, indexSource) {
            let text = sourceAddress.innerText;
            addressesArray[indexSource] = text.substring(0, text.length - 1);
        });
        addressesArray[addressesArray.length] = addressesArray[0];
        console.log(addressesArray);

        let multiRoute = new ymaps.multiRouter.MultiRoute({
            // Описание опорных точек мультимаршрута.
            referencePoints: addressesArray,
            // Параметры маршрутизации.
            params: {
                boundsAutoApply: true
            }
        });
        let routeLength = 0;
        let routeTime = 0;
        let routeTimeWithTraffic = 0;
        multiRoute.model.events.add("requestsuccess", function (event) {
            let properties = multiRoute.model.getRoutes()[0].properties._data;
            routeLength = properties.distance.text;
            routeTime = properties.duration.text;
            routeTimeWithTraffic = properties.durationInTraffic.text;
            let resultText = "<p>Маршрут построен.</p>";
            resultText += "<p>Длина пути: "+routeLength+"</p>";
            resultText += "<p>Ожидаемое время завершения с учетом дорожной ситуации: "+routeTimeWithTraffic+"</p>";
            resultText += "<p>Ожидаемое время завершения без учета дорожной ситуации: "+routeTime+"</p>";
            $("#result").html(resultText);
        });
        myMap.geoObjects.add(multiRoute);
    }
}

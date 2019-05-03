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

    // Выпадающая панель с поисковыми подсказками
    var suggestView = new ymaps.SuggestView(
        "address_search", // ID input'а
        {
            offset: [-2, 3], // Отступы панели подсказок от её положения по умолчанию. Задаётся в виде смещений по горизонтали и вертикали относительно левого нижнего угла элемента input.
            width: 300, // Ширина панели подсказок
            results: 3, // Максимальное количество показываемых подсказок.
        });

    let addresses = document.getElementsByClassName('address_item');
    if (addresses.length !== 0) {
        let addressesArray = [];
        Array.from(addresses).forEach(function (sourceAddress, indexSource) {
            let text = sourceAddress.innerText;
            addressesArray[indexSource] = text.substring(0, text.length - 3);
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
        myMap.geoObjects.add(multiRoute);
    }
}

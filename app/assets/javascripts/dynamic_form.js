var countOfFields = 1; // Текущее число полей
var curFieldNameId = 1; // Уникальное значение для атрибута name
var maxFieldLimit = 10; // Максимальное число возможных полей
function deleteField(a) {
    // Получаем доступ к ДИВу, содержащему поле
    var contDiv = a.parentNode;
    // Удаляем этот ДИВ из DOM-дерева
    contDiv.parentNode.removeChild(contDiv);
    // Уменьшаем значение текущего числа полей
    countOfFields--;
    // Возвращаем false, чтобы не было перехода по сслыке
    return false;
}
function addField() {
    // Проверяем, не достигло ли число полей максимума
    if (countOfFields >= maxFieldLimit) {
        alert("Число полей достигло своего максимума = " + maxFieldLimit);
        return false;
    }
    // Увеличиваем текущее значение числа полей
    countOfFields++;
    // Увеличиваем ID
    curFieldNameId++;
    // Создаем элемент ДИВ
    var div = document.createElement("div");
    div.className = 'address_item';
    // Добавляем HTML-контент с пом. свойства innerHTML
    div.innerHTML = "<span>" + document.getElementById("address_search").value + "</span> <a onclick='return deleteField(this)' href='#'>[X]</a>";
    // Добавляем новый узел в конец списка полей
    document.getElementById("address_input").appendChild(div);
    // Возвращаем false, чтобы не было перехода по сслыке
    create_placemark(document.getElementById("address_search").value);
    return false;
}

//Появление новых адресов на карте
function create_placemark(address) {
    // Ищем координаты указанного адреса
    var geocoder = ymaps.geocode(address);

    // После того, как поиск вернул результат, вызывается callback-функция
    geocoder.then(
        function (res) {

            // координаты объекта
            var coordinates = res.geoObjects.get(0).geometry.getCoordinates();

            // Добавление метки (Placemark) на карту
            var placemark = new ymaps.Placemark(
                coordinates, {
                    'hintContent': address,
                }, {
                    'preset': 'islands#redDotIcon'
                }
            );
            myMap.geoObjects.add(placemark);
        }
    );
}
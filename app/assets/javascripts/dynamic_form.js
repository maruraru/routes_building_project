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

//Формирование матрицы расстояний и отправка данных
function sendLengthMatrix() {
    let addresses = document.getElementsByClassName('address_item');
    let addressesMatrix = [];
    let promises = [];
    Array.from(addresses).forEach(function (sourceAddress, indexSource) {
        addressesMatrix[indexSource] = [];
        Array.from(addresses).forEach(function (destinationAddress, indexDest) {
            promises.push(getRouteLength(sourceAddress.firstChild.innerText, destinationAddress.firstChild.innerText,
                indexSource, indexDest, addressesMatrix));
       })
    });
    Promise.all(promises).then(() => {
        console.log("final result = " + addressesMatrix);
        let inputForm = document.getElementById('address_input');
        buildInHiddenInput(inputForm,'length_matrix', addressesMatrix);
        inputForm.submit();
        return true;
    },
    () => {
        return false;
    })
}

//Встраивание матрицы в хиддент-поле формы
function buildInHiddenInput(inputForm, key, data) {
    let input = document.createElement('input');
    input.type = 'hidden';
    input.name = key; // 'the key/name of the attribute/field that is sent to the server
    input.value = JSON.stringify(data);
    inputForm.appendChild(input);
}

//Получуние длины маршрута между двумя адресами
function getRouteLength(addressFrom, addressTo, indexFrom, indexTo, resultArray) {
    let coordinates = [];
    return new Promise(function (resolve, reject) {
        if (indexFrom === indexTo) {
            resultArray[indexFrom][indexTo] = Infinity;
            resolve();
        }
        else {
            ymaps.geocode(addressFrom)
                .then(function (res) {
                    coordinates.push(res.geoObjects.get(0).geometry.getCoordinates());
                })
                .then(() => ymaps.geocode(addressTo))
                .then(res => coordinates[1] = res.geoObjects.get(0).geometry.getCoordinates())
                .then(() => {
                    let multiRoute = new ymaps.multiRouter.MultiRoute({
                        // Описание опорных точек мультимаршрута.
                        referencePoints: coordinates,
                        // Автоматически устанавливать границы карты так, чтобы маршрут был виден целиком.
                        boundsAutoApply: true
                    });
                    multiRoute.model.events.add("requestsuccess", function (event) {
                        var routes = event.get("target")
                            .getRoutes();
                        resultArray[indexFrom][indexTo] = routes[0].properties.get("distance").text;
                        resolve();
                    });
                }).catch ((error) => {
                console.log('Error: ', error);
                reject();
            });
        }
    });
}

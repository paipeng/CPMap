/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Window 2.5
import QtQuick.Controls 2.5
import QtLocation 5.12
import QtPositioning 5.12

import com.yourcompany.xyz 1.0

Item {
    id: win
    visible: true
    width: Window.width
    height: Window.height
    property string text: "myGlobalObject.counter + 1"
    property MapQuickItem poiItem
    property MapQuickItem poiItem2
    property string poisJsonString
    property bool poiVisible: true
    property var poi
    property var mousePosition

    Component.onCompleted: {
        console.log('item component onCompleted')
        var JsonString = '{"a":"A whatever, run","b":"B fore something happens"}';
        var JsonObject= JSON.parse(JsonString);
        console.log(JsonObject)
        //poisJsonString = myGlobalObject.getJson();

        poi = JSON.parse(myGlobalObject.getJson())

        map.zoomLevel = poi.map.zoomLevel
        map.maximumZoomLevel = poi.map.maximumZoomLevel
        map.minimumZoomLevel = poi.map.minimumZoomLevel
        map.center = QtPositioning.coordinate(poi.map.center.latitude, poi.map.center.longitude)

        mapPolyline.path = poi.borderCoordinations
        //mapPolygon.path = borderPoints
        //console.log('json: ' + mapPolyline.path)

        var index = 0
        for (var i = 0; i < poi.pois.length; i++) {
            var item = poi.pois[i]
            console.log(index + ': ' + item.type + ', ' + item.longitude)
            var imagePOI = 'imagePOI'
            if (item.type === 1) {
                imagePOI = 'poi.png'
            } else if (item.type === 2) {
                imagePOI = 'poi-parking.png'
            } else if (item.type === 3) {
                imagePOI = 'poi-police.png'
            } else if (item.type === 4) {
                imagePOI = 'poi-wc.png'
            } else if (item.type === 5) {
                imagePOI = 'poi-restaurant.png'
            } else if (item.type === 6) {
                imagePOI = 'poi-first-aid.png'
            }
            console.log('imagePOI: ' + imagePOI)

            var qmlImage = Qt.createQmlObject('
                import QtQuick 2.12
                import QtQuick.Window 2.5
                import QtQuick.Controls 2.5
                import QtLocation 5.12
                import QtPositioning 5.12
                Image {
                    source: "qrc:/icons/' +  imagePOI + '"
                    height: 50
                    width: 40
                }', map);
            //console.log(qmlImage)

            var qmlObjectStr = '
                import QtLocation 5.12;
                import QtPositioning 5.12;    // 这里只画中线
                MapQuickItem {
                    id: poiItem_' + item.name + '
                    anchorPoint.x: sourceItem.width/2
                    anchorPoint.y: sourceItem.height

                    coordinate: QtPositioning.coordinate(' + item.latitude + ', ' + item.longitude +')

                }'
            var poiItem = Qt.createQmlObject(qmlObjectStr, map, 'poiItem_' + item.name)
            poiItem.sourceItem = qmlImage
            map.addMapItem(poiItem)
            index++
        }
/*
        poiItem = Qt.createQmlObject('import QtLocation 5.12;import QtPositioning 5.12;    // 这里只画中线
        MapQuickItem {
            id: poiItem
            anchorPoint.x: sourceItem.width/2
            anchorPoint.y: sourceItem.height

            coordinate: QtPositioning.coordinate(41.8374,123.4240)

            sourceItem: imageParkingPOI
        }', map, "poiItem");
        //console.log(newMapLaneMedian.coordinate)
        //map.addMapItem(newMapLaneMedian)


        poiItem2 = Qt.createQmlObject('import QtLocation 5.12;import QtPositioning 5.12;    // 这里只画中线
        MapQuickItem {
            id: poiItem2
            anchorPoint.x: sourceItem.width/2
            anchorPoint.y: sourceItem.height

            coordinate: QtPositioning.coordinate(41.84745,123.42143)

            sourceItem: imageWCPOI
        }', map, "poiItem2");
        */
    }

    function focusOnLocation() {
        console.log(map.center)
    }

    function zoomIn() {
        if (map.zoomLevel < map.maximumZoomLevel) {
            map.zoomLevel = map.zoomLevel + 1
        }

    }

    function zoomOut() {
        if (map.zoomLevel > map.minimumZoomLevel) {
            map.zoomLevel = map.zoomLevel - 1
        }
    }

    function showPoi(visible) {
        console.log('showPoi: ' + visible)

        var imageSrc = ''
        if (poiVisible) {
            imageSrc = 'poi-off.png'
        } else {
            imageSrc = 'poi-on.png'
        }

        var qmlImage = Qt.createQmlObject('
            import QtQuick 2.12
            import QtQuick.Window 2.5
            import QtQuick.Controls 2.5
            import QtLocation 5.12
            import QtPositioning 5.12
            Image {
                source: "qrc:/icons/' +  imageSrc + '"
                height: 26
                width: 18
            }', map);

        poiButton.background = qmlImage
        for (var i = 0; i < map.mapItems.length; i++) {
            var poiItem = map.mapItems[i]
            console.log('poiItem type: ' + poiItem.constructor)
            //console.log('poiItem type: ' + typeof poiItem)
            //console.log('poiItem path: ' + poiItem.path)

            if (poiItem.path === undefined) {
                poiItem.visible = !visible
            }
        }
        poiVisible = !visible
    }

    function setMapCenteri() {
        console.log('setMapCenter')
        map.center = QtPositioning.coordinate(poi.map.center.latitude, poi.map.center.longitude)
    }

    // Example 2: Custom QML Type implemented with C++
    // NOTE: This type is declared in main.cpp and available after using "import com.yourcompany.xyz 1.0"
    MyQMLType {
        id: typeFromCpp

        // 2.1: Property Binding for MyQMLType::message property
        // NOTE: Similar to types created purely with QML, you may use property bindings to keep your property values updated
        message: "counter / 2 = " + Math.floor(myGlobalObject.counter / 2)

        // 2.2: Reacting to property changes
        // NOTE: With the onMessageChanged signal, you can add code to handle property changes
        onMessageChanged: console.log("typeFromCpp message changed to '" + typeFromCpp.message+"'")

        // 2.3: Run code at creation of the QML component
        // NOTE: The Component.onCompleted signal is available for every QML item, even for items defined with C++.
        // The signal is fired when the QML Engine creates the item at runtime.
        Component.onCompleted: myGlobalObject.counter = typeFromCpp.increment(myGlobalObject.counter)

        // 2.4: Handling a custom signal
        onCppTaskFinished: {
            console.log("onCppTaskFinished")
            myGlobalObject.counter = 0 // reset counter to zero, this will also update the message
        }
    }

    Location {
        // Define location that will be "center" of map
        id: mapCenter
        coordinate {
            latitude: 41.8481
            longitude: 123.4216
        }
    }

    Map {
        id: map
        anchors.fill: parent
        activeMapType: map.supportedMapTypes[1]
        zoomLevel: 14
        maximumZoomLevel: 16
        minimumZoomLevel:13

        plugin: Plugin {
            id: mapPlugin
            name: 'osm';
            PluginParameter {
                name: 'osm.mapping.offline.directory'
                value: ':/map_tiles/'
            }
            //PluginParameter { name: "osm.mapping.host"; value: "" }
            PluginParameter { name: "osm.mapping.copyright"; value: "All mine" }
            //PluginParameter { name: "osm.routing.host"; value: "" }
            //PluginParameter { name: "osm.geocoding.host"; value: "" }
            PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: true}
            PluginParameter { name: "osm.mapping.cache.disk.size"; value: 0}

            // specify plugin parameters if necessary
            // PluginParameter {
            //     name:
            //     value:
            // }
        }
        copyrightsVisible : false
        center: mapCenter.coordinate//QtPositioning.coordinate() // Shenyang
        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture

        //If user doubleclicks on map update coordinates of pixel to coordinates on UI
        signal qmlSignalUpdateLat(string msg)
        signal qmlSignalUpdateLon(string msg)

        Component.onCompleted: {
            console.log("map Component.onCompleted")


            //map.addMapItem(poiItem)
            //map.addMapItem(poiItem2)

            console.log('mapItems size: ' + map.mapItems.length)
        }

        PinchArea {
            id: pincharea
            property double _oldZoom
            anchors.fill: parent
            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }
            onPinchStarted: {
                oldZoom = map.zoomLevel
            }

            onPinchUpdated: {
                map.zoomLevel = calcZoomDelta(oldZoom, pinch.scale)
            }

            onPinchFinished: {
                map.zoomLevel = calcZoomDelta(oldZoom, pinch.scale)
            }
        }

        Menu {
            id: contextMenu
            width: 100
            MenuItem {
                text: 'Add POI'
                icon.source: "qrc:/icons/poi.png"
                icon.width: 20
                icon.height: 20

                onTriggered: {
                    console.log('add poi: ' + mousePosition.x + '-' + mousePosition.y)
                }

            }
            MenuItem {
                text: 'Edit POI'
                enabled: false
                onTriggered: {
                    console.log('edit poi:' + mousePosition)

                }
            }
            MenuItem {
                text: 'Delete POI'
                onTriggered: {
                    console.log('delete poi+ ' + mousePosition)

                }
            }
        }

        MouseArea
        {
            id: mousearea
            hoverEnabled: true
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                console.log(mouse.x + '-' + mouse.y)
                mousePosition = {x: mouse.x, y: mouse.y};
                console.log('coordination: ' + map.toCoordinate(Qt.point(mouseX,mouseY)))
                if (mouse.button == Qt.RightButton) {
                    contextMenu.popup()
                } else {
                    myGlobalObject.doSomething("TEXT FROM QML")
                    typeFromCpp.startCppTask()
                    if (contextMenu.visible) {
                        contextMenu.close()
                    }
                }
            }
            onDoubleClicked: {
                map.center.latitude = map.toCoordinate(Qt.point(mouseX,mouseY)).latitude
                map.center.longitude = map.toCoordinate(Qt.point(mouseX,mouseY)).longitude
                map.qmlSignalUpdateLat(map.center.latitude)
                map.qmlSignalUpdateLon(map.center.longitude)

                //myGlobalObject.doSomething("TEXT FROM QML double click")

                myGlobalObject.counter = myGlobalObject.counter + 1
                //text: "Global Context Property Counter: " + myGlobalObject.counter
                //console.log(text)

                text: "Custom QML Type Message:\n" + typeFromCpp.message
                myGlobalObject.doSomething(text)
            }

            onPressed: {

            }

            onReleased: {

            }

            onPositionChanged: {

            }

            onCanceled: {

            }
        }

        function updateMap(lat,lon,bear){
            map.center.latitude = lat;
            map.center.longtitude = lon;
            map.bearing = bear;
        }

        onCenterChanged: {
            // As soon as map center changed -- we'll check if coordinates differs from our
            //   mapCenter coordinates and if so, set map center coordinates equal to mapCenter
            //if (map.center != mapCenter.coordinate) {
            //    map.center = mapCenter.coordinate
            //}
        }
/*
        MapCircle {
            // Circle just for ability to check if it zooms correctly
            center: mapCenter.coordinate
            radius: 50.0
            color: "green"
            border.width: 3
        }

        Image {
            id: imageWCPOI

            source: "qrc:/icons/poi-wc.png"
            height: 50
            width: 50
        }

        Image {
            id: imageParkingPOI

            source: "qrc:/icons/poi-parking.png"
            height: 50
            width: 50
        }

        Image {
            id: imageFirstAidPOI

            source: "qrc:/icons/poi-first-aid.png"
            height: 50
            width: 50
        }

        Image {
            id: imagePolicePOI

            source: "qrc:/icons/poi-police.png"
            height: 50
            width: 50
        }

        Image {
            id: imageRestaurantPOI

            source: "qrc:/icons/poi-restaurant.png"
            height: 50
            width: 50
        }


        Image {
            id: imagePOI

            source: "qrc:/icons/poi.png"
            height: 50
            width: 50
        }

        MapQuickItem {
            id: marker
            anchorPoint.x: image.width/2
            anchorPoint.y: image.height

            coordinate: mapCenter.coordinate//QtPositioning.coordinate(20.5, -2.5)

            sourceItem: Image {
                id: image

                source: "qrc:/icons/poi.png"
                height: 50
                width: 50
            }
        }

        MapQuickItem {
            id: markerWC
            anchorPoint.x: image.width/2
            anchorPoint.y: image.height

            coordinate: QtPositioning.coordinate(41.83896,123.42097)

            sourceItem: imageWCPOI
        }


        MapQuickItem {
            id: markerPARK
            anchorPoint.x: imageParkingPOI.width/2
            anchorPoint.y: imageParkingPOI.height

            coordinate: QtPositioning.coordinate(41.8448,123.4314)

            sourceItem: imageParkingPOI
        }
*/


        MapPolyline {
            id: mapPolyline
            line.width: 3
            line.color: 'green'
            path: [

            ]
        }

        MapPolygon {
            id: mapPolygon
            color: 'blue'
            path: [

            ]
        }


        Image {
            id: imageZoomIn
            source: "qrc:/icons/zoom-in.png"
            height: 30
            width: 30
        }
        Image {
            id: imageZoomOut
            source: "qrc:/icons/zoom-out.png"
            height: 30
            width: 30
        }

        Button {
            id: zoomInButton
            x: map.width - 10 - 40
            y:10
            width:40
            height: 40
            //text: "+"
            background: imageZoomIn
            onClicked: {
                zoomIn()
            }
        }

        Button {
            id: zoomOutButton
            x: map.width - 10 - 40
            y:10 + 40 + 10
            width:40
            height: 40
//            text: "-"
            background: imageZoomOut
            onClicked: {
                zoomOut()
            }
        }

        Button {
            id: poiButton
            x: map.width - 10 - 40
            y:10 + 40 + 10 + 50
            width:40
            height: 40
            background: Image {
                id: imagePOIOn
                source: "qrc:/icons/poi-on.png"
                height: 40
                width: 30
            }
            onClicked: {
                showPoi(poiVisible)
            }
        }
        Button {
            id: mapCenterButton
            x: map.width - 10 - 40
            y:10 + 40 + 10 + 50 + 50
            width:40
            height: 40
            background: Image {
                id: imageMapCenter
                source: "qrc:/icons/map-center.png"
                height: 30
                width: 30
            }
            onClicked: {
                setMapCenteri()
            }
        }

    }
}

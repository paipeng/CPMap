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

    Component.onCompleted: {
        console.log('item component onCompleted')
        var JsonString = '{"a":"A whatever, run","b":"B fore something happens"}';
        var JsonObject= JSON.parse(JsonString);
        console.log(JsonObject)
        poisJsonString = myGlobalObject.getJson();

        var poiJsons = JSON.parse(myGlobalObject.getJson())
        mapPolyline.path = poiJsons.borderCoordinations
        //mapPolygon.path = borderPoints
        //console.log('json: ' + mapPolyline.path)

        var index = 0
        for (var i = 0; i < poiJsons.pois.length; i++) {
            var item = poiJsons.pois[i]
            console.log(index + ': ' + item.type + ', ' + item.longitude)
            var imagePOI = 'imagePOI'
            if (item.type === 1) {
                imagePOI = 'imagePOI'
            } else if (item.type === 2) {
                imagePOI = 'imageParkingPOI'
            } else if (item.type === 3) {
                imagePOI = 'imagePolicePOI'
            } else if (item.type === 4) {
                imagePOI = 'imageWCPOI'
            } else if (item.type === 5) {
                imagePOI = 'imageRestaurantPOI'
            } else if (item.type === 6) {
                imagePOI = 'imageFirstAidPOI'
            }

            var qmlObjectStr = 'import QtLocation 5.12;import QtPositioning 5.12;    // 这里只画中线
                MapQuickItem {
                    id: poiItem_' + item.name + '
                    anchorPoint.x: sourceItem.width/2
                    anchorPoint.y: sourceItem.height

                    coordinate: QtPositioning.coordinate(' + item.latitude + ', ' + item.longitude +')

                    sourceItem: ' + imagePOI + ' }'
            var poiItem = Qt.createQmlObject(qmlObjectStr, map, 'poiItem-' + item.name)
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

        MouseArea
        {
            id: mousearea
            hoverEnabled: true
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: {
                myGlobalObject.doSomething("TEXT FROM QML")
                typeFromCpp.startCppTask()
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
*/
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
/*
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

        Button {
            id: zoomInButton
            x: map.width - 10 - 40
            y:10
            width:40
            height: 40
            text: "Zoom +"
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
            text: "Zoom -"
            onClicked: {
                zoomOut()
            }
        }
    }
}

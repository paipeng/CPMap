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

import QtQuick 2.7
import QtQuick.Window 2.2
import QtLocation 5.8
import QtPositioning 5.8

import com.yourcompany.xyz 1.0

Item {
    id: win
    visible: true
    width: Window.width
    height: Window.height
    property string text: "myGlobalObject.counter + 1"


    Component.onCompleted: {
        console.log('item component onCompleted')
        var JsonString = '{"a":"A whatever, run","b":"B fore something happens"}';
        var JsonObject= JSON.parse(JsonString);
        var json = myGlobalObject.getJson();
        console.log('json: ' + json)
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
            latitude: 41.8341
            longitude: 123.4281
        }
    }
    Map {
        id: map
        anchors.fill: parent
        activeMapType: map.supportedMapTypes[1]
        zoomLevel: 16
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
            if (map.center != mapCenter.coordinate) {
                map.center = mapCenter.coordinate
            }
        }

        MapCircle {
            // Circle just for ability to check if it zooms correctly
            center: mapCenter.coordinate
            radius: 50.0
            color: "green"
            border.width: 3
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

        MapPolyline {
            line.width: 3
            line.color: 'green'
            path: [
                { latitude: 41.8560700, longitude: 123.4120900 },
                { latitude: 41.85529, longitude: 123.41214 },
                { latitude: 41.85423, longitude: 123.41224 },
                { latitude: 41.85120, longitude: 123.41257 },
                { latitude: 41.85124, longitude: 123.41395 },

                { latitude: 41.85062, longitude: 123.41423 },
                { latitude: 41.84968, longitude: 123.41648 },
                { latitude: 41.84982, longitude: 123.41755 },
                { latitude: 41.84878, longitude: 123.41763 },
                { latitude: 41.84837, longitude: 123.41732 },

                { latitude: 41.84811, longitude: 123.41297 },
                { latitude: 41.84586, longitude: 123.41309 },
                { latitude: 41.84560, longitude: 123.41487 },
                { latitude: 41.84479, longitude: 123.41605 },
                { latitude: 41.84263, longitude: 123.41363 },
                { latitude: 41.84191, longitude: 123.41343 },
                { latitude: 41.83908, longitude: 123.41751 },
                { latitude: 41.83863, longitude: 123.41769 },
                { latitude: 41.83862, longitude: 123.41769 },

                { latitude: 41.83706, longitude: 123.41747 },
                { latitude: 41.83669, longitude: 123.41734 },
                { latitude: 41.83692, longitude: 123.42167 },
                { latitude: 41.83756, longitude: 123.42164 },
                { latitude: 41.83762, longitude: 123.42289 },
                { latitude: 41.83702, longitude: 123.42303 },
                { latitude: 41.83707, longitude: 123.42333 },

                { latitude: 41.83742, longitude: 123.42488 },
                { latitude: 41.83774, longitude: 123.42622 },
                { latitude: 41.83807, longitude: 123.42689 },
                { latitude: 41.83806, longitude: 123.42691 },
                { latitude: 41.83985, longitude: 123.42950 },
                { latitude: 41.84199, longitude: 123.43176 },
                { latitude: 41.84361, longitude: 123.43284 },
                { latitude: 41.84369, longitude: 123.43193 },
                { latitude: 41.84383, longitude: 123.43123 },
                { latitude: 41.84375, longitude: 123.42922 },
                { latitude: 41.84637, longitude: 123.42919 },

                { latitude: 41.8463505009051, longitude: 123.429255889729 },
                { latitude: 41.8458692018638, longitude: 123.431073022287 },
                { latitude: 41.8458391205534, longitude: 123.432163301822 },
                { latitude: 41.8491289276155, longitude: 123.431404216147 },
                { latitude: 41.854951926661, longitude: 123.429790132015 },
                { latitude: 41.8557055580592, longitude: 123.42950104232 },
                { latitude: 41.860146416828, longitude: 123.427453323645 },
                { latitude: 41.8605052608818, longitude: 123.426875144255 },
                { latitude: 41.8605949715806, longitude: 123.426296964864 },
                { latitude: 41.860577029451, longitude: 123.426236737844 },
                { latitude: 41.8605321741047, longitude: 123.425357423355 },
                { latitude: 41.8598862536298, longitude: 123.421322213025 },
                { latitude: 41.8588366189429, longitude: 123.414540650591 },
                { latitude: 41.8585450506946, longitude: 123.413866107969 },
                { latitude: 41.8578991101482, longitude: 123.413492700446 },
                { latitude: 41.857145504598, longitude: 123.413203610751 },
                { latitude: 41.8565174931892, longitude: 123.41262543136 },
                { latitude: 41.8560700, longitude: 123.4120900 },
            ]
        }
    }
}

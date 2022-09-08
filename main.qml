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

Item {
    id: win
    visible: true
    width: Window.width
    height: Window.height



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
            onDoubleClicked: {
                map.center.latitude = map.toCoordinate(Qt.point(mouseX,mouseY)).latitude
                map.center.longitude = map.toCoordinate(Qt.point(mouseX,mouseY)).longitude
                map.qmlSignalUpdateLat(map.center.latitude)
                map.qmlSignalUpdateLon(map.center.longitude)
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

        MapCircle {
            // Circle just for ability to check if it zooms correctly
            center: mapCenter.coordinate
            radius: 50.0
            color: "green"
            border.width: 3
        }
    }
}

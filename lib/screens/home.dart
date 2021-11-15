/*
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:lx_mobility/config/server.dart';
import 'dart:io' show Platform;

import 'package:lx_mobility/constants/strings.dart';
import 'package:lx_mobility/screens/term_of_use.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;
  bool _currentPositionDetermined = false;

  double _currentLatitude = 0;
  double _currentLongitude = 0;

  String markerImageURL = 'https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color/254000/66-512.png';

  //region OVERRIDE METHODS
  @override
  void initState() {
    super.initState();
    _toggleServiceStatusStream();
    _determinePos();
  }

  void _determinePos() async{
    await _getCurrentPosition();
  }


  @override
  void dispose() {
    if(_positionStreamSubscription != null){
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  } //endregion

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(_PositionItemType.log,
            'Location service has been $serviceStatusValue');
      });
    }
  }

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        _updatePositionList(
          _PositionItemType.position,
          position.toString(),
        );
      });
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(_PositionItemType.log, displayValue);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      return;
    }

    _currentPositionDetermined = true;
    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(_PositionItemType.position, position.toString());
    _currentLongitude = position.longitude;
    _currentLatitude = position.latitude;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updatePositionList(
        _PositionItemType.log,
        ConstantStrings.messagePermissionDeniedForever,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _updatePositionList(
          _PositionItemType.log,
          ConstantStrings.messageLocationServiceDisabled,
        );

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _updatePositionList(
        _PositionItemType.log,
        ConstantStrings.messagePermissionDeniedForever,
      );

      return false;
    }
    _updatePositionList(
      _PositionItemType.log,
      ConstantStrings.messagePermissionGranted,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  void _showInfoDialog(String title, String content, int listLength) {
    var dialog = AlertDialog(
      title: Text(
        title.isNotEmpty ? title : '안내',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      scrollable: true,
      actionsAlignment: MainAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: Text(
              '현재 찾은 위치 정보들 : ' + listLength.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 8.0)),
          SizedBox(
            height: 200,
            width: 300,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  child: Text(content,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ),
              ],
            )),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'))
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  void _showCurrentPositionHistory() {
    if (_positionItems.isEmpty) return;
    var _positionInfo = '';
    var _position = _positionItems
        .where((element) => element.type == _PositionItemType.position)
        .toList();
    for (var element in _position) {
      if (_positionInfo.isNotEmpty) {
        _positionInfo += '\n';
      }
      _positionInfo += element.displayValue;
    }
    _showInfoDialog('위치 안내', _positionInfo, _position.length);
  }

  //region WIDGETS
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    WebViewController _mapController;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body:  SafeArea(
        child: SizedBox(
          height: _size.height,
          width: _size.width,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                width: _size.width,
                color: Colors.black,
                child: KakaoMapView(
                  draggableMarker: true,
                  showMapTypeControl: true,
                  showZoomControl: true,
                  width: _size.width,
                  height: _size.height,
                  kakaoMapKey: ServerConfig.kakaoAppKey,
                  mapController: (controller) {
                    _mapController = controller;
                  },
                  cameraIdle: (p0) async {
                    _currentPositionDetermined = false;
                    setState(() {});
                  },
                  onTapMarker: (p0) {
                    print('TAP MARKER ' + p0.toString());
                  },
                  zoomChanged: (p0) {
                    print('ZOOM CHANGED ' + p0.toString());
                  },
                  lat: _currentLatitude,
                  lng: _currentLongitude,
                  polygon: KakaoPolygon(
                      polygon: [
                      KakaoLatLng(
                            33.45086654081833, 126.56906858718982),
                        KakaoLatLng(
                            33.45010890948828, 126.56898629127468),
                        KakaoLatLng(
                            33.44979857909499, 126.57049357211622),
                        KakaoLatLng(
                            33.450137483918496, 126.57202991943016),
                        KakaoLatLng(
                            33.450706188506054, 126.57223147947938),
                        KakaoLatLng(33.45164068091554, 126.5713126693152)

                      ],
                      polygonColor: Colors.red,
                      polygonColorOpacity: 0.3,
                      strokeColor: Colors.deepOrange,
                      strokeWeight: 2.5,
                      strokeColorOpacity: 0.9),
                  markerImageURL:  'https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color/254000/66-512.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                    onPressed: () {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.openEndDrawer();
                      } else {
                        scaffoldKey.currentState!.openDrawer();
                      }
                    },
                    icon: const Icon(Icons.subject,
                        color: Colors.black, size: 32)),
              ),
              _bottomCurrentPositionButton(),
              _bottomOverlayContainer(),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: SizedBox(
            height: _size.height,
            width: _size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[_drawerMenuItems()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomCurrentPositionButton() {
    return Positioned(
      bottom: 78,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: _getCurrentPosition,
          child: Icon(
            Icons.my_location_outlined,
            color: _currentPositionDetermined
                ? Colors.blue
                : Colors.blue.withOpacity(0.2),
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _bottomOverlayContainer() {
    return Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Container(
            color: Colors.white.withOpacity(0.9),
            height: 70,
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      '주변경고: 보행자 무단 횡단 감지',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_up_outlined,
                      size: 52,
                      color: Colors.blue,
                    ),
                  ],
                ))));
  }

  Widget _drawerMenuItems() {
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 100.0, left: 32.0),
        child: const Text(
          'modim@gmail.com',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 16.0, left: 32.0),
        child: const Text(
          '일반 보행자',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 32.0, 20.0),
        child: const Divider(
          color: Colors.grey,
          thickness: 1.5,
        ),
      ),
      menuItem(
          1,
          '마이페이지',
          const Icon(
            Icons.badge_outlined,
            color: Colors.black,
            size: 32,
          )),
      menuItem(2, '기록',
          const Icon(Icons.subject_outlined, color: Colors.black, size: 32)),
      menuItem(3, '이용약관',
          const Icon(Icons.assignment_outlined, color: Colors.black, size: 32)),
      menuItem(4, '설정',
          const Icon(Icons.settings_outlined, color: Colors.black, size: 32)),
      menuItem(5, '위치 목록',
          const Icon(Icons.map_outlined, color: Colors.black, size: 32)),
      menuItem(6, '위치 목록 삭제',
          const Icon(Icons.delete_outlined, color: Colors.black, size: 32)),
    ]);
  }

  Widget menuItem(int id, String title, Icon icon) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 0.0),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0))),
        contentPadding: const EdgeInsets.only(left: 30.0),
        dense: true,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        leading: icon,
        onTap: () {
          setState(() {
            if(id == 1){

            }
            else if(id == 2){

            }
            else if(id == 3){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TermOfUse(),));
            }
            else if (id == 5) {
              _showCurrentPositionHistory();
            } else if (id == 6) {
              if (_positionItems.isNotEmpty) {
                _positionItems.clear();
                showTopSnackBar(context,
                    const CustomSnackBar.success(message: '목록을 삭제했음.'));
              }
            }
          });
          setState(() {
            Navigator.pop(context);
            if (id == 1) {
              currentPage = DrawerSections.testHistory;
            } else if (id == 2) {
              currentPage = DrawerSections.testMethod;
            } else if (id == 3) {
              currentPage = DrawerSections.privacyPolicy;
            } else if (id == 4) {
              currentPage = DrawerSections.settings;
            }
          });

        },
      ),
    );
  }
  //endregion
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  final _PositionItemType type;
  final String displayValue;

  _PositionItem(this.type, this.displayValue);
}
*/

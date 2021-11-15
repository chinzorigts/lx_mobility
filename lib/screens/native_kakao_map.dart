import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lx_mobility/screens/term_of_use.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NativeKakaoMap extends StatefulWidget{

  const NativeKakaoMap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NativeKakaoMapState();
  }

}

class _NativeKakaoMapState extends State<NativeKakaoMap>{

  static const ANDROID_ACTIVITY = "com.modim.lx_mobility";
  static const ANDROID_CALL_KAKAO_MAP = "CALL_KAKAO_MAP";
  static const MethodChannel _channel = MethodChannel(ANDROID_ACTIVITY);
  String _mapResult = "Unknown";

  @override
  void initState() {
    super.initState();
    _callAndroidKakaoMap();
  }

  @override
  Widget build(BuildContext context) {

    var _size = MediaQuery.of(context).size;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final String viewType = 'hybrid-view-type';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SizedBox(
            height: _size.height,
            width: _size.width,
            child: Container(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: PlatformViewLink(
                  surfaceFactory: (context, controller) {
                    return AndroidViewSurface(
                        controller: controller as AndroidViewController,
                        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                    );
                  },
                  onCreatePlatformView: (params) {
                    return PlatformViewsService.initSurfaceAndroidView(
                        id: params.id,
                        viewType: viewType,
                        layoutDirection: TextDirection.ltr,
                        creationParams: creationParams,
                        creationParamsCodec: StandardMessageCodec(),
                    )
                      ..addOnPlatformViewCreatedListener( params.onPlatformViewCreated)
                      ..create();
                  },
                  viewType: viewType
              ),
            ),
          )
      ),
      drawer:  Drawer(
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
            } else if (id == 6) {

            }
          });
        },
      ),
    );
  }

  void _callAndroidKakaoMap() async{
    String mapData = "wait";
    try{
      String result = await _channel.invokeMethod(ANDROID_CALL_KAKAO_MAP);
      mapData = result;
    } on PlatformException catch(e){
      showTopSnackBar(context, CustomSnackBar.error(message: e.message.toString()));
    }

    setState(() {
      _mapResult = mapData;
    });
  }

}
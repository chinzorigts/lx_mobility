/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:lx_mobility/config/server.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class KakaoMapTest extends StatelessWidget{

  const KakaoMapTest({Key? key}) : super(key: key);

  final _currentLatitude = 33.450701;
  final _currentLongitude = 126.570667;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
            height: _size.height,
            width: _size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    height: 400,
                    kakaoMapKey: ServerConfig.kakaoAppKey,
                    cameraIdle: (p0) async {
                    },
                    onTapMarker: (marker) async {
                      showTopSnackBar(context, const CustomSnackBar.info(message: 'Marker is clicked'));
                    },
                    zoomChanged: (p0) {
                      print('ZOOM CHANGED ' + p0.toString());
                    },
                    lat: _currentLatitude,
                    lng: _currentLongitude,
                    markerImageURL:  'https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color/254000/66-512.png',
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await _openKakaoMapScreen(context);
                    }, 
                    child: const Text('Kakao map screen'))
              ],
            )
          )
      ),
    );
  }
  
  Future<void> _openKakaoMapScreen(BuildContext context) async{
    KakaoMapUtil mapUtil = KakaoMapUtil();
    String url = await mapUtil.getMapScreenURL(37.402056, 127.108212, name: '카카오 본사');
    Navigator.push(context,MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url,)));
  }

}
*/

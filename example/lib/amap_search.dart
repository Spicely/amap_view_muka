import 'package:amap_location_muka/amap_location_muka.dart';
import 'package:amap_search_muka/amap_search_muka.dart';
import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_muka/flutter_muka.dart';

class AmapSearchLoc extends StatefulWidget {
  const AmapSearchLoc({Key? key}) : super(key: key);

  @override
  _AmapSearchLocState createState() => _AmapSearchLocState();
}

class _AmapSearchLocState extends State<AmapSearchLoc> {
  AmapViewController? _amapViewController;

  ITextEditingController _search = ITextEditingController(text: '');

  EasyRefreshController _controller = EasyRefreshController();

  List<AMapPoi> _data = [];

  int _page = 1;

  LatLng? _latLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AmapView(
              onCreated: (amapViewController) async {
                _amapViewController = amapViewController;
                Location _loc = await AmapLocation.fetch();
                _amapViewController?.setCameraPosition(CameraPosition(LatLng(_loc.latitude!, _loc.longitude!), 13, 0, 20, duration: 200));
                _amapViewController?.addMarker(
                  AmapDefaultMarker(
                    id: '1',
                    position: LatLng(_loc.latitude!, _loc.longitude!),
                    icon: AMapViewImage.asset('assets/images/map.png'),
                  ),
                );
              },
              onMapIdle: (_cameraPosition) {
                _amapViewController?.updateMarker(
                  AmapDefaultMarker(
                    id: '1',
                    position: _cameraPosition.latLng,
                  ),
                );
                _latLng = _cameraPosition.latLng;
                _controller.callRefresh();
              },
              onMapMove: (_cameraPosition) async {
                _amapViewController?.updateMarker(
                  AmapDefaultMarker(
                    id: '1',
                    position: _cameraPosition.latLng,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 35,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ITextField(
                      prefixIcon: Icon(Icons.search, color: Colors.black.withOpacity(0.2)),
                      controller: _search,
                      hintText: '搜索地点',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: EasyRefresh.custom(
                      controller: _controller,
                      header: ClassicalHeader(
                        enableInfiniteRefresh: false,
                        enableHapticFeedback: false,
                        infoColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColor,
                        refreshText: '下拉可刷新',
                        refreshReadyText: '松开立即刷新',
                        refreshingText: '正在刷新',
                        refreshedText: '刷新成功',
                        refreshFailedText: '刷新成功',
                        noMoreText: '没有更多数据',
                      ),
                      footer: ClassicalFooter(
                        enableInfiniteLoad: false,
                        enableHapticFeedback: false,
                        loadText: '上拉加载更多',
                        loadReadyText: '松开立即加载',
                        loadingText: '加载数据中',
                        loadedText: '加载完成',
                        loadFailedText: '加载完成',
                        noMoreText: '没有更多了',
                      ),
                      onRefresh: () async {
                        List<AMapPoi> data = await AMapSearch.searchAround(_latLng!);
                        _data = data;

                        setState(() {});
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 1), () async {});
                      },
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ListItem(
                                fieldType: FieldType.TITLE,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _data[index].name!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      _data[index].address!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: _data.length,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEmpty() {
    return Empty(
      extend: Padding(
        padding: EdgeInsets.only(top: 10),
        child: OutlinedButton(
          child: Text('重新加载'),
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}

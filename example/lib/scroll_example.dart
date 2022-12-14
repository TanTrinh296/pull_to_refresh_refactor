import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScrollExample extends StatefulWidget {
  const ScrollExample({Key? key}) : super(key: key);

  @override
  State<ScrollExample> createState() => _ScrollExampleState();
}

class _ScrollExampleState extends State<ScrollExample> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<int> listItem = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> hardItem = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  Future _onRefresh() async {
    // listItem = [];
    await Future.delayed(const Duration(seconds: 2));
    listItem = List.generate(hardItem.length, (index) => hardItem[index]);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Future _onLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    listItem.addAll(List.generate(hardItem.length, (index) => hardItem[index]));
    _refreshController.loadComplete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        scrollDirection: Axis.vertical,
        enablePullUp: true,
        enableTwoLevel: true,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus? mode) {
            Widget body;
            switch (mode) {
              // case RefreshStatus.canRefresh:
              //   body = Text("Pull out to refresh");
              //   break;
              case RefreshStatus.refreshing:
                body = const CupertinoActivityIndicator();
                break;

              default:
                return Container();
            }
            return SizedBox(
              height: 30.0,
              child: Center(child: body),
            );
          },
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            switch (mode) {
              case LoadStatus.idle:
                body = const Text("Vuốt lên để tải");
                break;
              case LoadStatus.loading:
                body = const CupertinoActivityIndicator();
                break;
              case LoadStatus.failed:
                body = const Text("Thất bại, bấm để tải lại");
                break;
              case LoadStatus.canLoading:
                body = const Text("Thả ra để tải bắt đầu tải");
                break;
              default:
                return const SizedBox.shrink();
            }
            return SizedBox(
              height: 30.0,
              width: 30,
              child: Center(child: body),
            );
          },
        ),
        child: ListView.builder(
          itemCount: listItem.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              '${listItem[index]}',
            ),
          ),
        ),
      ),
    );
  }
}

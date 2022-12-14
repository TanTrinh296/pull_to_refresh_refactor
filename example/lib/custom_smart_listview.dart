import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomSmartListView extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoading;
  final Axis? scrollDirection;
  final bool enablePullDown;
  final bool canLoadmore;
  final bool enableTwoLevel;
  const CustomSmartListView(
      {Key? key,
      required this.onRefresh,
      required this.onLoading,
      this.scrollDirection,
      required this.child,
      this.enablePullDown = true,
      this.canLoadmore = true,
      this.enableTwoLevel = true})
      : super(key: key);

  @override
  State<CustomSmartListView> createState() => _CustomSmartListViewState();
}

class _CustomSmartListViewState extends State<CustomSmartListView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future _onRefresh() async {
    await widget.onRefresh();
    _refreshController.refreshCompleted();
  }

  Future _onLoading() async {
    await widget.onLoading();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: widget.enablePullDown,
        scrollDirection: widget.scrollDirection,
        enablePullUp: widget.canLoadmore,
        enableTwoLevel: widget.enableTwoLevel,
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
        child: widget.child);
  }
}

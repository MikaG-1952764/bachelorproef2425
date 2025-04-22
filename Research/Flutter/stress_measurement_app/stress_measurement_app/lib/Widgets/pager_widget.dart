import 'package:flutter/material.dart';

class PagerWidget extends StatefulWidget {
  final List<Widget> pages;
  final PageController? controller;

  const PagerWidget({
    Key? key,
    required this.pages,
    this.controller,
  }) : super(key: key);

  @override
  _PagerWidgetState createState() => _PagerWidgetState();
}

class _PagerWidgetState extends State<PagerWidget> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: widget.pages,
    );
  }
}

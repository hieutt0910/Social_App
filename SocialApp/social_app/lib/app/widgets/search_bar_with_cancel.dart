import 'package:flutter/material.dart';
import 'package:social_app/app/widgets/search_bar_widget.dart';

class SearchBarWithCancel extends StatefulWidget {
  const SearchBarWithCancel({super.key});

  @override
  State<SearchBarWithCancel> createState() => _SearchBarWithCancelState();
}

class _SearchBarWithCancelState extends State<SearchBarWithCancel> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _cancelSearch() {
    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: _controller,
            focusNode: _focusNode,
            hintText: 'Search',
            onChanged: (v) => debugPrint('Search input: $v'),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child:
              _hasFocus
                  ? TextButton(
                    key: const ValueKey('cancel'),
                    onPressed: _cancelSearch,
                    child: const Text('Cancel'),
                  )
                  : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}

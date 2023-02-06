import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/views/components/search_grid_view.dart';
import 'package:nexus/views/constants/strings.dart';
import 'package:nexus/views/extension/dismiss_keyboard.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(
      () {
        controller.addListener(() {
          searchTerm.value = controller.text;
        });
        return () {};
      },
      [controller],
    );
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: Strings.enterYourSearchTermHere,
                focusColor: Colors.blueGrey,
                fillColor: Colors.blueGrey,
                hintStyle: const TextStyle(
                  color: Colors.blueGrey,
                ),
                labelStyle: const TextStyle(
                  color: Colors.blueGrey,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blueGrey,
                  onPressed: () {
                    controller.clear();
                    dismissKeyboard();
                  },
                ),
              ),
            ),
          ),
        ),
        SearchGridView(
          searchTerm: searchTerm.value,
        ),
      ],
    );
  }
}

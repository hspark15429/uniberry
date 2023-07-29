import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart'; // NEW
import '../model/app_state_model.dart';
import '../product_list_tab.dart'; // NEW

class CafeteriaPage extends StatelessWidget {
  const CafeteriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<AppStateModel>(
        create: (_) => AppStateModel()..loadProducts(), // NEW
        child: Scaffold(
          appBar: CafeteriaAppBar(),
          body: const ProductListTab(), // NEW
        ),
      ),
    );
  }
}

class CafeteriaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CafeteriaAppBar({
    super.key,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // default AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('OIC Cafeteria'),
      backgroundColor: Colors.black,
      actions: [
        Row(
          children: [
            Paragraph(
                'Total: ${context.select((AppStateModel m) => m.totalCost)}¥'),
            IconButton(
              icon: const Icon(Icons.cleaning_services_outlined),
              onPressed: () {
                final model =
                    Provider.of<AppStateModel>(context, listen: false);
                model.clearCart();
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class CupertinoStoreHomePage extends StatelessWidget {
  const CupertinoStoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Cupertino Store'),
      ),
      child: SizedBox(),
    );
  }
}

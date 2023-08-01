import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/shopping_cart_tab.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart'; // NEW
import '../model/app_state_model.dart';
import '../product_list_tab.dart'; // NEW

class CafeteriaPage extends StatelessWidget {
  const CafeteriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CafeteriaAppBar(),
        body: const ProductListTab(), // NEW
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
      centerTitle: false,
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
              onPressed: () async {
                return showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => true,
                      child: ShoppingCartTab(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

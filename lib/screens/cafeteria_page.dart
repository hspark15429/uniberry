import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/shopping_cart_tab.dart';
import 'package:provider/provider.dart'; // NEW

import '../model/app_state_model.dart';
import '../model/product.dart';
import '../product_list_tab.dart'; // NEW

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({super.key});

  @override
  State<CafeteriaPage> createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  Key productListTabKey = UniqueKey(); // Create a unique key for ProductListTab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CafeteriaAppBar(onReload: _reloadProductList),
      body: ProductListTab(key: productListTabKey), // NEW
    );
  }

  _reloadProductList() {
    setState(() {
      productListTabKey = UniqueKey(); // Generate a new unique key
    });
  }
}

class CafeteriaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onReload;

  const CafeteriaAppBar({
    super.key,
    required this.onReload,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // default AppBar height

  @override
  Widget build(
    BuildContext context,
  ) {
    String _cafeteriaName = context.select(
        (AppStateModel m) => getCafeteriaByIndex(m.selectedCafeteria.index));
    return AppBar(
      centerTitle: false,
      title: Text(
        _cafeteriaName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 30, 30),
      automaticallyImplyLeading: false,
      actions: [
        Row(
          children: [
            Text(
              '合計: ${context.select((AppStateModel m) => m.totalCost).toStringAsFixed(0)}¥  ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
            IconButton(
              icon: const Icon(CupertinoIcons.bars),
              tooltip: 'Select Cafeteria',
              onPressed: () {
                // handle the press
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('カフェテリアを選択してください'),
                        content: Text('カフェテリアを選択してください'),
                        actions: List<Widget>.generate(
                          8,
                          (index) => TextButton(
                            onPressed: () => {
                              Provider.of<AppStateModel>(context, listen: false)
                                  .setCafeteria(Cafeteria.values[index]),
                              Navigator.of(context).pop(),
                              onReload(),
                            },
                            // timetableSwitch(context, index: index + 1),

                            child: Text(getCafeteriaByIndex(index)),
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}

String getCafeteriaByIndex(int index) {
  List<String> _cafeteriaList = [
    "OIC Cafeteria",
    "ユニオンカフェテリア",
    "リンクカフェテリア",
    "ユニオンフードコート",
    "以学館食堂E-platz",
    "諒友館食堂",
    "存心館食堂",
    "ALL"
  ];
  return _cafeteriaList[index];
}

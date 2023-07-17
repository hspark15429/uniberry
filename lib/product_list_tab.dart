import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';
import 'product_row_item.dart'; // NEW

class ProductListTab extends StatelessWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final products = model.getProducts();
        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
            // const CupertinoSliverNavigationBar(
            //   largeTitle: Center(child: Text('OIC Cafeteria')),
            // ),
            SliverSafeArea(
              // ADD from here...
              top: false,
              minimum: const EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: CupertinoListSection(
                  topMargin: 0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 1, top: 1),
                    ),
                    for (var product in products)
                      ProductRowItem(
                        product: product,
                      )
                  ],
                ),
              ),
            ), // ...to here.
          ],
        );
      },
    );
  }
}

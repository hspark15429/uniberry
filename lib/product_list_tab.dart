import 'package:flutter/cupertino.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';
import 'model/product.dart';
import 'product_row_item.dart'; // NEW

class ProductListTab extends StatelessWidget {
  ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        // NEW
        final products = model.getProducts();
        final categoryMapping = {
          "デザート Dessert": Category.dessert,
          "丼・カレー Rice bowl / Curry": Category.rice,
          "麺類 Noodles": Category.noodle,
          "副菜 Side dish": Category.sideDish,
          "主菜 Main dish": Category.mainDish,
          // add the rest of your mappings here
          "All": Category.all,
          "Ethnic": Category.ethnic,
          "Quickbite": Category.quickbite,
        };
        final reversedCategoryMapping =
            categoryMapping.map((key, value) => MapEntry(value, key));

        List<Widget> createMenuWidgets() {
          List<Widget> list = [SizedBox(height: 0)];
          for (Category category in Category.values) {
            var _subProducts =
                products.where((p) => p.category == category).toList();
            if (_subProducts.isEmpty) continue;
            list.add(Header(reversedCategoryMapping[category]!));
            for (var product in _subProducts) {
              list.add(ProductRowItem(
                product: product,
              ));
            }
          }

          return list;
        }

        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
            SliverSafeArea(
              // ADD from here...
              top: false,
              minimum: const EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: CupertinoListSection(
                  topMargin: 0,
                  children: createMenuWidgets(),
                ),
              ),
            ), // ...to here.
            // circular progress indicator
          ],
        );
      },
    );
  }
}

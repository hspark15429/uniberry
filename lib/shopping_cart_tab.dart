import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/product.dart'; // NEW

import 'model/app_state_model.dart';
import 'styles.dart'; // NEW

class ShoppingCartTab extends StatefulWidget {
  const ShoppingCartTab({super.key});

  @override
  State<ShoppingCartTab> createState() {
    return _ShoppingCartTabState();
  }
}

class _ShoppingCartTabState extends State<ShoppingCartTab> {
  final _currencyFormat = NumberFormat.currency(
      symbol: '¥', decimalDigits: 0, locale: 'ja_JP'); // NEW

  SliverChildBuilderDelegate _buildSliverChildBuilderDelegate(
      AppStateModel model) {
    return SliverChildBuilderDelegate(
      (context, index) {
        final productIndex = index;
        switch (index) {
          default:
            if (model.productsInCart.length > productIndex) {
              return ShoppingCartItem(
                index: index,
                product: model.getProductById(
                    model.productsInCart.keys.toList()[productIndex]),
                quantity: model.productsInCart.values.toList()[productIndex],
                lastItem: productIndex == model.productsInCart.length - 1,
                formatter: _currencyFormat,
              );
            } else if (model.productsInCart.keys.length == productIndex &&
                model.productsInCart.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Text(
                        //   'Shipping '
                        //   '${_currencyFormat.format(model.shippingCost)}',
                        //   style: Styles.productRowItemPrice,
                        // ),
                        // const SizedBox(height: 6),
                        // Text(
                        //   'Tax ${_currencyFormat.format(model.tax)}',
                        //   style: Styles.productRowItemPrice,
                        // ),
                        const SizedBox(height: 6),
                        Text(
                          'Total ${_currencyFormat.format(model.totalCost)}',
                          style: Styles.productRowTotal,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            DefaultTextStyle(
                              style: Styles.nutrition,
                              child: Column(children: [
                                Text('Total calories'),
                                Text('Total Protein'),
                                Text('Total Fat'),
                                Text('Total Carbohydrates'),
                                Text('Total Salt'),
                                Text('Total calcium'),
                                Text('Total Veg'),
                                Text('Total Iron'),
                                Text('Total VitaminA'),
                                Text('Total VitaminB1'),
                                Text('Total VitaminB2'),
                                Text('Total VitaminC'),
                              ]),
                            ),
                            SizedBox(width: 10),
                            DefaultTextStyle(
                              style: Styles.nutrition,
                              child: Column(
                                children: [
                                  Text(
                                      '${model.subtotalNutrition.energy.toStringAsFixed(0)} Kcal'),
                                  Text(
                                      '${model.subtotalNutrition.protein.toStringAsFixed(1)} g'),
                                  Text(
                                      '${model.subtotalNutrition.fat.toStringAsFixed(1)} g'),
                                  Text(
                                      '${model.subtotalNutrition.carbohydrates.toStringAsFixed(1)} g'),
                                  Text(
                                      '${model.subtotalNutrition.salt.toStringAsFixed(1)} g'),
                                  Text(
                                      '${model.subtotalNutrition.calcium.toStringAsFixed(1)} mg'),
                                  Text(
                                      '${model.subtotalNutrition.veg.toStringAsFixed(1)} g'),
                                  Text(
                                      '${model.subtotalNutrition.iron.toStringAsFixed(1)} mg'),
                                  Text(
                                      '${model.subtotalNutrition.vitA.toStringAsFixed(1)} μg'),
                                  Text(
                                      '${model.subtotalNutrition.vitB1.toStringAsFixed(1)} mg'),
                                  Text(
                                      '${model.subtotalNutrition.vitB2.toStringAsFixed(1)} mg'),
                                  Text(
                                      '${model.subtotalNutrition.vitC.toStringAsFixed(1)} mg'),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }
        }
        return null;
      },
    );
  } // TO HERE

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        return CustomScrollView(
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Shopping Cart'),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 4),
              sliver: SliverList(
                delegate: _buildSliverChildBuilderDelegate(model),
              ),
            )
          ],
        );
      },
    );
  }
}

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    required this.index,
    required this.product,
    required this.lastItem,
    required this.quantity,
    required this.formatter,
    super.key,
  });

  final Product product;
  final int index;
  final bool lastItem;
  final int quantity;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      child: CupertinoListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),
        leadingSize: 40,
        title: Text(
          product.name_jp,
          style: Styles.productRowItemName,
        ),
        subtitle: Text(
          '${quantity > 1 ? '$quantity x ' : ''}'
          '${formatter.format(product.price)}',
          style: Styles.productRowItemPrice,
        ),
        trailing: Text(
          formatter.format(quantity * product.price),
          style: Styles.productRowItemName,
        ),
      ),
    );

    return row;
  }
}

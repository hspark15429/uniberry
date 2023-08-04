import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/main_page.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';
import 'model/product.dart';

class ProductRowItem extends StatelessWidget {
  const ProductRowItem({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 0,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () {
              final exp = RegExp(r'(\d+).png');
              final match = exp.firstMatch(product.image);
              openUrl(
                  'https://west2-univ.jp/sp/detail.php?t=650337&c=${match!.group(1)}');
            },
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              width: 68,
              height: 68,
            ),
          ),
        ),
        visualDensity: VisualDensity(vertical: -4),
        // leadingSize: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${product.name_jp}",
            ),
            Text("${product.name_en}", style: TextStyle(fontSize: 10)),
            Text(
              "🤗${product.evaluation.good} 😐${product.evaluation.average} 😠${product.evaluation.bad}",
            ),
          ],
        ),
        subtitle: Text(
          '\¥${product.price}',
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            final model = Provider.of<AppStateModel>(context, listen: false);
            model.addProductToCart(product.id);
          },
          child: const Icon(
            CupertinoIcons.plus_circled,
            semanticLabel: 'Add',
          ),
        ),
      ),
    );
  }
}

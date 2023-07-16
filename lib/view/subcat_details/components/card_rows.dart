// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/utilities/reusable.dart';
import '../../products_card/product.dart';
import '../../var_lib.dart' as vars;

class CardRows extends StatefulWidget {
  CardRows({
    Key? key,
    required this.maincat,
  }) : super(key: key);

  final String maincat;

  @override
  State<CardRows> createState() => _CardRowsState();
}

class _CardRowsState extends State<CardRows> {
  final _subCategories = vars.get_subCategoriesOption();

  Future<List<Product>> productGetter(String subcat) async {
    List<Product> products = await getProductsBySubCat(subcat);
    return products;
  }

  bool _isLoading = true;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _subCategories[widget.maincat].length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 10.h);
      },
      itemBuilder: (context, index) {
        String subcat = _subCategories[widget.maincat][index];
        return ProductRows(getProducts: productGetter(subcat), title: subcat);
      },
    );
  }
}

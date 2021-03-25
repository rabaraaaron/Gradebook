import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/services/category_service.dart';

// ignore: must_be_immutable
class DeleteCategoryConfirmation extends StatelessWidget{
  CategoryService catServ;
  List<Category> categories;
  int index;

  DeleteCategoryConfirmation(CategoryService catService, List<Category> cat, int i){
    catServ = catService;
    categories = cat;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Delete Category",
              style: Theme.of(context).textTheme.headline4,
            ),
            Divider(color: Theme.of(context).dividerColor,),
            Text(
              "Are you sure you want to delete the ${categories[index].categoryName} category?",
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.red,
              height: 40,
              onPressed: () {
                catServ.deleteCategory(categories[index].id);
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
                textScaleFactor: 1.25,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ]
      ),

    );
  }

}
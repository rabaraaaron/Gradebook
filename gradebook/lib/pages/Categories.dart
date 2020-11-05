import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    List<String> categories = ["Assignments", "Homework", "Quizzes", "Exams", "Other"];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 30,
            onPressed: (){
              Navigator.pop(context);
            }),
        actions: [IconButton(icon: Icon(Icons.add), iconSize: 35, color: Colors.white,
            onPressed: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    NewCategoriesPopUp(context, categories),
              );
              setState(() {});
            }
        )],
      ),

      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.white,
          indent: 25.0,
          endIndent: 25.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) => Container(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        size: 35,
                      ),
                      onPressed: (){
                        print("Icons pressed");
                      },
                    ),
                    padding: EdgeInsets.all(10.0),),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        //Todo: make items in categories drop down
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(20.0),
                        child: Text(
                          "${categories[index]}",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ),
                  ),
                  Text("20%", textScaleFactor: 2,style: Theme.of(context).textTheme.headline3,)
                ],
              )
          ),
        ),
      ),
    );
  }
}

class NewCategoriesPopUp extends StatefulWidget {
  var c;
  var categories;
  NewCategoriesPopUp(context, categ){
    c = context;
    categories = categ;
  }
  @override
  _NewCategoriesPopUpState createState() => _NewCategoriesPopUpState(c, categories);
}

class _NewCategoriesPopUpState extends State<NewCategoriesPopUp> {
  var context;
  var categories;
  var categoryTitle;
  var categoryPercentage;
  TextEditingController categoryTitleController = new TextEditingController();
  TextEditingController categoryWeightController = new TextEditingController();


  _NewCategoriesPopUpState(cont, categ){
    context = cont;
    categories = categ;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a new Category", style: Theme.of(context).textTheme.headline2,),
        content: SizedBox(
          child: Form(
              child: Column(children: [
                TextFormField(
                  controller: categoryTitleController,
                  decoration: const InputDecoration(
                    hintText: "ex Project",
                    labelText: 'Category',
                  ),
                ),
                TextFormField(

                  controller: categoryWeightController,
                  decoration: const InputDecoration(
                    hintText: "ex 25",
                    labelText: 'Weight',
                  ),
                ),
                RaisedButton(
                    onPressed: (){
                      categories.insert(0, categoryTitleController.text);
                      if(int.parse(categoryWeightController.text) is int){
                        print(categoryWeightController.text);
                      } else{
                        print("Input is invalid");
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Submit")
                )
              ])
          ),
          width: 100,
          height: 175,
        ));
  }
}


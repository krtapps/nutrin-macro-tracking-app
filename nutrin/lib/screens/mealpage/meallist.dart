import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/model/mealmodel.dart';
import 'package:mobileapp/model/tracked_food.dart';
import 'package:mobileapp/model/tracker.dart';
import 'package:mobileapp/model/user.dart';
import 'package:mobileapp/screens/search/searchpage.dart';
import 'package:mobileapp/services/database.dart';
import 'package:provider/provider.dart';

class MealList extends StatefulWidget {
  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  @override
  Widget build(BuildContext context) {
    var tracker = Provider.of<Tracker>(context);
    if (tracker != null) {
      var meals = tracker.meals;
      return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var currentMeal = meals[index];
              return generateMeal(currentMeal, index);
            },
            itemCount: meals.length),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget foodtiles(MealModel currentMeal) {
    var widgets = <Widget>[];

    for (var i = 0; i < currentMeal.foods.length; i++) {
      TrackedFood food = currentMeal.foods[i];
      Widget foodTile = InkWell(
        onTap: () {},
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      food.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "OpenSans"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            food.carbohydrates + "C",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 10),
                          ),
                          Text(
                            food.protein + "P",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 10),
                          ),
                          Text(
                            food.fat + "F",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 10),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Pressed");
                            },
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      food.serving + " " + food.unit,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: "OpenSans", fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      widgets.add(foodTile);
    }
    return Column(
      children: widgets,
    );
  }

  Widget generateMeal(MealModel currentMeal, int index) {
    var user = Provider.of<User>(context);
    var children2 = <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .75,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0) //
                    ),
              ),
              child: Text(
                currentMeal.mealName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "OpenSans", color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                var tracker = Provider.of<Tracker>(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(currentMeal.mealName),
                  ),
                );
              },
              child: Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      boxOutline(currentMeal),
    ];
    return StreamProvider.value(
      value: DatabaseService(uid: user.uid).tracker,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children2,
      ),
    );
  }

  Widget boxOutline(MealModel currentMeal) {
    if (currentMeal.foods.length == 0) {
      return Container(
        width: 0,
        height: 0,
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(15.0) //
              ),
        ),
        child: foodtiles(currentMeal),
      );
    }
  }
}

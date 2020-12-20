import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/database/DBHelper.dart';
import 'package:flutter_app/model/Grocery.dart';

class Cart extends StatefulWidget {
  final String title;

  Cart({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  Future<List<Grocery>> groceries;
  List<Grocery> groceries2 = [];
  TextEditingController controllerName,
      controllerPrice,
      controllerQuantity = TextEditingController();
  int id, price, quantity, grandTotalPrice;
  String name;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    controllerName = TextEditingController(text: ' ');
    controllerPrice = TextEditingController(text: ' ');
    controllerQuantity = TextEditingController(text: ' ');
    refreshList();
  }

  refreshList() {
    setState(() {
      groceries = dbHelper.getGroceries();
      groceries2 = dbHelper.getGroceries();
    });
    regenerateTotal();
  }

  regenerateTotal() {
    int total;
    List<Grocery> listGroceries;
    int listLength = listGroceries == null ? 0 : listGroceries.length;
    if (listLength > 0) {
      for (int i = 0; i < listGroceries.length; i++) {
        total = total + (listGroceries[i].price * listGroceries[i].quantity);
      }
    } else {
      total = 0;
    }
    setState(() {
      grandTotalPrice = total;
    });
  }

  clearName() {
    controllerName.text = '';
    controllerPrice.text = '';
    controllerQuantity.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Grocery e = Grocery(id, name, price, quantity);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Grocery e = Grocery(null, name, price, quantity);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              maxLength: 3,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controllerPrice,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(labelText: 'Price'),
              validator: (val) => val.length == 0 ? 'Enter Price' : null,
              onSaved: (val) => price = int.parse(val),
            ),
            TextFormField(
              controller: controllerQuantity,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(labelText: 'Quantity'),
              validator: (val) => val.length == 0 ? 'Enter Quantity' : null,
              onSaved: (val) => quantity = int.parse(val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'INSERT'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Grocery> groceries) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FittedBox(
          child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('PRICE'),
          ),
          DataColumn(
            label: Text('QUANTITY'),
          ),
          // DataColumn(
          //   label: Text('EDIT'),
          // ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: groceries
            .map(
              (groceries) => DataRow(cells: [
                DataCell(Text(groceries.name)),
                DataCell(Text(groceries.price.toString())),
                DataCell(Text(groceries.quantity.toString())),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(groceries.id);
                    refreshList();
                  },
                )),
              ]),
            )
            .toList(),
      )),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: groceries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No groceries were found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Cart'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            list(),
            Text("GRAND TOTAL : $grandTotalPrice"),
          ],
        ),
      ),
    );
  }
}

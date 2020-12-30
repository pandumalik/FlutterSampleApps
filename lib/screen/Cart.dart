// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app/database/DBHelper.dart';
// import 'package:flutter_app/model/Grocery.dart';
//
// class Cart extends StatefulWidget {
//   final String title;
//
//   Cart({Key key, this.title}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _CartState();
//   }
// }
//
// class _CartState extends State<Cart> {
//   Future<List<Grocery>> groceries;
//   List<Grocery> groceries2 = [];
//   TextEditingController controllerName,
//       controllerPrice,
//       controllerQuantity = TextEditingController();
//   int id, price, quantity, grandTotalPrice;
//   String name;
//
//   final formKey = new GlobalKey<FormState>();
//   var dbHelper;
//   bool isUpdating;
//
//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DBHelper();
//     isUpdating = false;
//     controllerName = TextEditingController(text: ' ');
//     controllerPrice = TextEditingController(text: ' ');
//     controllerQuantity = TextEditingController(text: ' ');
//     refreshList();
//   }
//
//   refreshList() {
//     setState(() {
//       groceries = dbHelper.getGroceries();
//       groceries2 = dbHelper.getGroceries();
//     });
//     regenerateTotal();
//   }
//
//   regenerateTotal() {
//     int total;
//     List<Grocery> listGroceries;
//     int listLength = listGroceries == null ? 0 : listGroceries.length;
//     if (listLength > 0) {
//       for (int i = 0; i < listGroceries.length; i++) {
//         total = total + (listGroceries[i].price * listGroceries[i].quantity);
//       }
//     } else {
//       total = 0;
//     }
//     setState(() {
//       grandTotalPrice = total;
//     });
//   }
//
//   clearName() {
//     controllerName.text = '';
//     controllerPrice.text = '';
//     controllerQuantity.text = '';
//   }
//
//   validate() {
//     if (formKey.currentState.validate()) {
//       formKey.currentState.save();
//       if (isUpdating) {
//         Grocery e = Grocery(id, name, price, quantity);
//         dbHelper.update(e);
//         setState(() {
//           isUpdating = false;
//         });
//       } else {
//         Grocery e = Grocery(null, name, price, quantity);
//         dbHelper.save(e);
//       }
//       clearName();
//       refreshList();
//     }
//   }
//
//   form() {
//     return Form(
//       key: formKey,
//       child: Padding(
//         padding: EdgeInsets.all(15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           verticalDirection: VerticalDirection.down,
//           children: <Widget>[
//             TextFormField(
//               controller: controllerName,
//               keyboardType: TextInputType.text,
//               maxLength: 3,
//               decoration: InputDecoration(labelText: 'Name'),
//               validator: (val) => val.length == 0 ? 'Enter Name' : null,
//               onSaved: (val) => name = val,
//             ),
//             TextFormField(
//               controller: controllerPrice,
//               keyboardType: TextInputType.number,
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.digitsOnly
//               ],
//               decoration: InputDecoration(labelText: 'Price'),
//               validator: (val) => val.length == 0 ? 'Enter Price' : null,
//               onSaved: (val) => price = int.parse(val),
//             ),
//             TextFormField(
//               controller: controllerQuantity,
//               keyboardType: TextInputType.number,
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.digitsOnly
//               ],
//               decoration: InputDecoration(labelText: 'Quantity'),
//               validator: (val) => val.length == 0 ? 'Enter Quantity' : null,
//               onSaved: (val) => quantity = int.parse(val),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 FlatButton(
//                   onPressed: validate,
//                   child: Text(isUpdating ? 'UPDATE' : 'INSERT'),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     setState(() {
//                       isUpdating = false;
//                     });
//                     clearName();
//                   },
//                   child: Text('CANCEL'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   SingleChildScrollView dataTable(List<Grocery> groceries) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: FittedBox(
//           child: DataTable(
//         columns: [
//           DataColumn(
//             label: Text('NAME'),
//           ),
//           DataColumn(
//             label: Text('PRICE'),
//           ),
//           DataColumn(
//             label: Text('QUANTITY'),
//           ),
//           // DataColumn(
//           //   label: Text('EDIT'),
//           // ),
//           DataColumn(
//             label: Text('DELETE'),
//           )
//         ],
//         rows: groceries
//             .map(
//               (groceries) => DataRow(cells: [
//                 DataCell(Text(groceries.name)),
//                 DataCell(Text(groceries.price.toString())),
//                 DataCell(Text(groceries.quantity.toString())),
//                 DataCell(IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     dbHelper.delete(groceries.id);
//                     refreshList();
//                   },
//                 )),
//               ]),
//             )
//             .toList(),
//       )),
//     );
//   }
//
//   list() {
//     return Expanded(
//       child: FutureBuilder(
//         future: groceries,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return dataTable(snapshot.data);
//           }
//
//           if (null == snapshot.data || snapshot.data.length == 0) {
//             return Text("No groceries were found");
//           }
//
//           return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Cart'),
//       ),
//       body: new Container(
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           verticalDirection: VerticalDirection.down,
//           children: <Widget>[
//             list(),
//             Text("GRAND TOTAL : $grandTotalPrice"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import "package:scoped_model/scoped_model.dart";
import "../database/ScopeManage.dart";

class Cart extends StatefulWidget{
  static final String route = "Cart-route";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart>{

  Widget generateCart(Data d){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey[100],
                  width: 1.0
              ),
              top: BorderSide(
                  color: Colors.grey[100],
                  width: 1.0
              ),
            )
        ),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                  ),
                  image: DecorationImage(image: NetworkImage(d.image),fit: BoxFit.fill)
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0,left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(d.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                          ),
                          Container(
                              alignment: Alignment.bottomRight,
                              child: ScopedModelDescendant<AppModel>(
                                builder: (cotext,child,model){
                                  return InkResponse(
                                      onTap: (){
                                        model.removeCart(d);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.remove_circle,color: Colors.red,),
                                      )
                                  );
                                },
                              )
                          )
                        ],
                      ),
                      SizedBox(height: 5.0,),
                      Text("Price ${d.price.toString()}"),

                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        appBar:AppBar(
          elevation: 0.0,
          title: Text("Cart List"),
        ),
        backgroundColor: Colors.white,
        body:Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Colors.grey[300],
                      width: 1.0
                  )
              )
          ),
          child: ScopedModelDescendant<AppModel>(
            builder: (context,child,model){
              return ListView(
                shrinkWrap: true,
                children: model.cartListing.map((d)=>generateCart(d)).toList(),
              );
            },
          ),
        )
    );
  }
}

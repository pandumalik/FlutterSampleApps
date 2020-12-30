import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:localstorage/localstorage.dart';

var data = [
  {
    "name": "The Man from Earth",
    "price": 25.0,
    "fav": true,
    "rating": 4.5,
    "image":
        "https://m.media-amazon.com/images/M/MV5BMzQ5NGQwOTUtNWJlZi00ZTFiLWI0ZTEtOGU3MTA2ZGU5OWZiXkEyXkFqcGdeQXVyMTczNjQwOTY@._V1_UX140_CR0,0,140,209_AL_.jpg"
  },
  {
    "name": "The Quest",
    "price": 200.0,
    "fav": true,
    "rating": 4.5,
    "image":
        "https://m.media-amazon.com/images/M/MV5BMWIyYjMxZTMtZGUyNy00N2UwLTgwNjctOWQ1OGMzN2VlMDExXkEyXkFqcGdeQXVyNDc2NjEyMw@@._V1_UY209_CR0,0,140,209_AL_.jpg"
  },
  {
    "name": "Puma Descendant Ind",
    "price": 299.0,
    "fav": false,
    "rating": 4.5,
    "image":
        "https://n4.sdlcdn.com/imgs/d/h/i/Asian-Gray-Running-Shoes-SDL691594953-1-2127d.jpg"
  },
  {
    "name": "Tucker and Dale vs Evil",
    "price": 214.0,
    "fav": false,
    "rating": 4.0,
    "image":
        "https://m.media-amazon.com/images/M/MV5BODQ5NDQ0MjkwMF5BMl5BanBnXkFtZTcwNDg1OTU4NQ@@._V1_UY209_CR0,0,140,209_AL_.jpg"
  },
  {
    "name": "Quills",
    "price": 205.0,
    "fav": true,
    "rating": 4.0,
    "image":
        "https://m.media-amazon.com/images/M/MV5BYzEwMTExODAtNWQ2NS00ZWNiLTlhNDctYmMwNmM0OTAwNTIzL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_UY209_CR0,0,140,209_AL_.jpg"
  },
  {
    "name": "Marvin's Room",
    "price": 200.0,
    "fav": false,
    "rating": 4.9,
    "image":
        "https://m.media-amazon.com/images/M/MV5BOTk0ZDk3YWItZDZlOC00Y2FiLTgxNzYtODZmYzdkYWVmNmRiXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg"
  }
];

class AppModel extends Model {
  List<Item> _items = [];
  List<Data> _data = [];
  List<Data> _cart = [];
  String cartMsg = "";
  bool success = false;
  Database _db;
  Directory tempDir;
  String tempPath;
  final LocalStorage storage = new LocalStorage('app_data');

  AppModel() {
    createDB();
  }

  deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cart.db');

    await deleteDatabase(path);
    if (storage.getItem("isFirst") != null) {
      await storage.deleteItem("isFirst");
    }
  }

  createDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'cart.db');

      print(path);
//      await storage.deleteItem("isFirst");
//      await this.deleteDB();

      var database =
          await openDatabase(path, version: 1, onOpen: (Database db) {
        this._db = db;
        print("OPEN DBV");
        this.createTable();
      }, onCreate: (Database db, int version) async {
        this._db = db;
        print("DB Crated");
      });
    } catch (e) {
      print("ERRR >>>>");
      print(e);
    }
  }

  createTable() async {
    try {
      var qry = "CREATE TABLE IF NOT EXISTS shopping ( "
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "fav INTEGER,"
          "rating REAL,"
          "datetime DATETIME)";
      await this._db.execute(qry);
      qry = "CREATE TABLE IF NOT EXISTS cart_list ( "
          "id INTEGER PRIMARY KEY,"
          "shop_id INTEGER,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "fav INTEGER,"
          "rating REAL,"
          "datetime DATETIME)";

      await this._db.execute(qry);

      var _flag = storage.getItem("isFirst");
      print("FLAG IS FIRST ${_flag}");
      if (_flag == "true") {
        this.FetchLocalData();
        this.FetchCartList();
      } else {
        this.InsertInLocal();
      }
    } catch (e) {
      print("ERRR ^^^");
      print(e);
    }
  }

  FetchLocalData() async {
    try {
      // Get the records
      List<Map> list = await this._db.rawQuery('SELECT * FROM shopping');
      list.map((dd) {
        Data d = new Data();
        d.id = dd["id"];
        d.name = dd["name"];
        d.image = dd["image"];
        d.price = dd["price"];
        d.fav = dd["fav"] == 1 ? true : false;
        d.rating = dd["rating"];
        _data.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR %%%");
      print(e);
    }
  }

  InsertInLocal() async {
    try {
      await this._db.transaction((tx) async {
        for (var i = 0; i < data.length; i++) {
          print("Called insert ${i}");
          Data d = new Data();
          d.id = i + 1;
          d.name = data[i]["name"];
          d.image = data[i]["image"];
          d.price = data[i]["price"];
          d.fav = data[i]["fav"];
          d.rating = data[i]["rating"];
          try {
            var qry =
                'INSERT INTO shopping(name, price, image,rating,fav) VALUES("${d.name}",${d.price}, "${d.image}",${d.rating},${d.fav ? 1 : 0})';
            var _res = await tx.rawInsert(qry);
          } catch (e) {
            print("ERRR >>>");
            print(e);
          }
          _data.add(d);
          notifyListeners();
        }

        storage.setItem("isFirst", "true");
      });
    } catch (e) {
      print("ERRR ## > ");
      print(e);
    }
  }

  InsertInCart(Data d) async {
    await this._db.transaction((tx) async {
      try {
        var qry =
            'INSERT INTO cart_list(shop_id,name, price, image,rating,fav) VALUES(${d.id},"${d.name}",${d.price}, "${d.image}",${d.rating},${d.fav ? 1 : 0})';
        var _res = await tx.execute(qry);
        this.FetchCartList();
      } catch (e) {
        print("ERRR @@ @@");
        print(e);
      }
    });
  }

  FetchCartList() async {
    try {
      // Get the records
      _cart = [];
      List<Map> list = await this._db.rawQuery('SELECT * FROM cart_list');
      print("Cart len ${list.length.toString()}");
      list.map((dd) {
        Data d = new Data();
        d.id = dd["id"];
        d.name = dd["name"];
        d.image = dd["image"];
        d.price = dd["price"];
        d.shop_id = dd["shop_id"];
        d.fav = dd["fav"] == 1 ? true : false;
        d.rating = dd["rating"];
        _cart.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  UpdateFavItem(Data data) async {
    try {
      var qry =
          "UPDATE shopping set fav = ${data.fav ? 1 : 0} where id = ${data.id}";
      this._db.rawUpdate(qry).then((res) {
        print("UPDATE RES ${res}");
      }).catchError((e) {
        print("UPDATE ERR ${e}");
      });
    } catch (e) {
      print("ERRR @@");
      print(e);
    }
  }

  // Add In fav list
  addToFav(Data data) {
    var _index = _data.indexWhere((d) => d.id == data.id);
    data.fav = !data.fav;
    _data.insert(_index, data);
    this.UpdateFavItem(data);
    notifyListeners();
  }

  // Item List
  List<Data> get itemListing => _data;

  // Item Add
  void addItem(Data dd) {
    Data d = new Data();
    d.id = _data.length + 1;
    d.name = "New";
    d.image =
        "https://rukminim1.flixcart.com/image/832/832/jao8uq80/shoe/3/r/q/sm323-9-sparx-white-original-imaezvxwmp6qz6tg.jpeg?q=70";
    d.price = 154.0;
    d.fav = false;
    d.rating = 4.0;
    _data.add(d);
    notifyListeners();
  }

  // Cart Listing
  List<Data> get cartListing => _cart;

  // Add Cart
  void addCart(Data dd) {
    print(dd);
    print(_cart);
    int _index = _cart.indexWhere((d) => d.shop_id == dd.id);
    if (_index > -1) {
      success = false;
      cartMsg = "${dd.name.toUpperCase()} already added in Cart list.";
    } else {
      this.InsertInCart(dd);
      success = true;
      cartMsg = "${dd.name.toUpperCase()} successfully added in cart list.";
    }
  }

  RemoveCartDB(Data d) async {
    try {
      var qry = "DELETE FROM cart_list where id = ${d.id}";
      this._db.rawDelete(qry).then((data) {
        print(data);
        int _index = _cart.indexWhere((dd) => dd.id == d.id);
        _cart.removeAt(_index);
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print("ERR rm cart${e}");
    }
  }

  // Remove Cart
  void removeCart(Data dd) {
    this.RemoveCartDB(dd);
  }
}

class Item {
  final String name;

  Item(this.name);
}

class Data {
  String name;
  int id;
  String image;
  double rating;
  double price;
  bool fav;
  int shop_id;
}

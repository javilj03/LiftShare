import '../DayRoutine.dart';
import '../Routine.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User.dart';
import '../../constants.dart';

class MongoDb {
  static var db, collectionUser;

  static connect() async {
    // db = await Db.create(CONNECTION);
    await db.open();
    collectionUser = db.collection(USERCOLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final users = await collectionUser.find().toList();
      print(users.toString());
      return users;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<ObjectId?> verifyUser(String username, String password) async {
    try {
      var user = await collectionUser.findOne(where.eq('username', username));
      if (user['password'] == password) {
        print('Contraseña correcta');
        return user['_id'];
      } else {
        print("Contraseña incorrecta");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insertUser(User user) async {
    await collectionUser.insertAll([user.toMap()]);
    print('añadido con exito');
  }

  static update(User user) async {
    var u = await collectionUser.findOne({'_id': user.id});
    u['name'] = user.name;
    u['lastName'] = user.lastName;
    u['birth_date'] = user.birth_date;
    u['weigth'] = user.weight;
    u['height'] = user.height;
    u['username'] = user.username;
    u['email'] = user.email;
    u['visibility'] = user.visibility;
    u['password'] = user.password;
    await collectionUser.save(u);
  }

  static delete(User user) async {
    // await collectionUser.remove(where.id(user.id));
  }

  static Future<List<Routine>> getRoutinesForUser(ObjectId? userId) async {
    if (userId == null) {
      final routines = getRoutines();
      return routines;
    } else {
      try {
        final res =
            await db.collection(USERCOLLECTION).findOne({'_id': userId});

        // Añadir new
        final routineIds = res['routines'].map((id) => ObjectId.parse(id)).toList();

        final resRoutines = await db
            .collection(ROUTINECOLLECTION)
            .find(where.oneFrom('_id', routineIds))
            .toList();
        print((resRoutines));

        final routines = <Routine>[]; // inicializamos la lista vacía

        for (final e in resRoutines) {
          final routine;
          // iteramos los resultados
          if (e['days_of_week'] != null) {
            routine = Routine(
              id: e['_id'],
              name: e['name'],
              desc: e['desc'],
              days: e['days_of_week'],
              visibility: e['visibility'],
            );
          } else {
            routine = Routine(
              id: e['_id'],
              name: e['name'],
              desc: e['desc'],
              visibility: e['visibility'],
            );
          }

          routines.add(routine); // agregamos la rutina a la lista
        }

        return routines; // devolvemos la lista completa de rutinas
      } catch (e) {
        print('ERROR DE PETICION getRoutinesForUser');
        print(e);

        return Future.value([]);
      }
    }
  }

  static Future<List<Routine>> getRoutines() async {
    try {
      final res = await db.collection(ROUTINECOLLECTION).find().toList();
      final routines = <Routine>[]; // inicializamos la lista vacía
      for (final e in res) {
        // iteramos los resultados
        final routine = Routine(
          id: e['_id'],
          name: e['name'],
          desc: e['desc'],
          days: e['exercises'],
          visibility: e['visibility'],
        );

        routines.add(routine); // agregamos la rutina a la lista
      }

      return routines; // devolvemos la lista completa de rutinas
    } catch (e) {
      print(e);
      return Future.value([]);
    }
  }

  static insertRoutine(Routine routine, ObjectId userId) async {
    await db.collection(ROUTINECOLLECTION).insertAll([routine.toMap()]);

    await db.collection(USERCOLLECTION).update(
          where.eq('_id', userId),
          modify.push('routines', routine.id),
        );
    print('añadido con exito');
  }

  static CreateDayRoutine(DayRoutine dayRoutine) async {
    try {
      await db.collection(DAYROUTINE).insertAll([dayRoutine.toMap()]);
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('DayRoutinesId${dayRoutine.day_of_week}',
          dayRoutine.id.toString().split('\"')[1]);
      print('Añadido con exito');
    } catch (e) {
      print(e);
    }
  }
}

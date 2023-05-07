import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'bxhpayym2ira8gfkfvvt-mysql.services.clever-cloud.com',
      user = 'undulbqjhkeo6jts',
      password = 'QG5U62E9Yn3CNrmajWyN',
      db = 'bxhpayym2ira8gfkfvvt';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}

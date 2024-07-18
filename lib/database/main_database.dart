import 'package:mysql_client/mysql_client.dart';

class MainDatabase{

  static Future<MySQLConnection> connectDatabase() async{
    return await MySQLConnection.createConnection(
      host: "localhost", // Add your host IP address or server name
      port: 3306, // Add the port the server is running on
      userName: "admin", // Your username
      password: "password", // Your password
      databaseName: "playpaldb", // Your DataBase name
    );
    // return MySQLConnection.createConnection(host: 'localhost', port: 3306, userName: 'admin', password: 'password', secure: true, databaseName: 'playpaldb');
  }

  static Future<List> readData(MySQLConnection conn) async{
    var result = await conn.execute('SELECT * FROM tb_users');
    for (var item in result.rows){
      Map data = item.assoc();
      print('showing data ${data}');
    }
    return [];
  }
}

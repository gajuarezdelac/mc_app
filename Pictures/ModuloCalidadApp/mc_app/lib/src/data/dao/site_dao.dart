import 'package:mc_app/src/database/db_context.dart';

class SiteDao {
  DBContext context = DBContext();

  Future<String> getSiteId() async {
    final db = await context.database;
    List<Map<String, dynamic>> res;

    res = await db.query('SiteConfig', columns: ['SiteId'], limit: 1);
    String siteId = res[0]['SiteId'];

    return siteId;
  }
}

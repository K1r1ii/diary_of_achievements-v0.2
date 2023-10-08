import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration7 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("accessToken", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.deleteColumn("_User", "successToken");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    
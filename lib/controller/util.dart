import 'package:keratoplastysurvey/configuration.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Util {
  static Future<String> getProjectName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectName = packageInfo.appName;
    return projectName;
  }

  static Map<String, dynamic> anstoFlat() {
    Map<String, dynamic> result = {};

    for (var value in ans['data']) {
      result[value['variable']] = value["value"];
    }

    ans['recorderID'] = ans['recorderID'];
    ans["surveryId"] = ans["surveryId"];
    ans["STATUS"] = "CREATED";
    ans["createAt"] = ans['CREATE-DATE-TIME'];

    return result;
  }
}

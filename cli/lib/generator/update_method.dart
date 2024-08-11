import 'swagger.dart';
import 'to_json_encodable.dart';

String generateUpdateMethod(
  Map<String, Column> columns,
) {
  var code = 'static Map<String, dynamic> update({\n';

  columns.forEach((columnName, columnDetails) {
    code += '${columnDetails.dartType}? $columnName,\n';
  });

  code += '}) {\n';
  code += 'return {\n';

  columns.forEach((columnName, columnDetails) {
    code +=
        "if ($columnName != null) '$columnName': ${toJsonEncodable(columnDetails.dartType, columnDetails.postgresFormat, columnName, columnDetails)},\n";
  });

  code += '};\n';
  code += '}\n\n';

  return code;
}

/* import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/API.dart';
import 'package:keratoplastysurvey/configuration.dart';

class SectionAForm extends StatefulWidget {
  const SectionAForm({super.key});

  @override
  State<SectionAForm> createState() => _SectionAFormState();
}

class _SectionAFormState extends State<SectionAForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  final List<String> examinationStatusOptions = [
    'Examined',
    'Not available',
    'Refused'
  ];

  late List<String> district;
  late Map<String, String> cluster;

  @override
  void initState() async {
    super.initState();

    district = await API.getDistrict();
    //cluster = API.getCluster();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                ),
                value: ans.districtCode,
                items: district.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.districtCode = value!;
                  });
                },
                onSaved: (value) {
                  ans.districtCode = value!;
                },
              ),
              const SizedBox(height: 10),
            ]));
  }
}
 */
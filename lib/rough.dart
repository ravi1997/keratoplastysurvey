/* import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:keratoplastysurvey/pages/survey_form_start_page.dart'; */

/* 

class Answers {
  late String graderCode;
  late String recorderCode;
  late String districtCode;
  late String clusterCode;
  late String houseNumber;
  late String individualNo;
  late String residentName;
  late int age;
  late String gender = "Male";
  late String education;
  late String examinationStatus = "Examined";
  late String rightEyeCO = "Absent";
  late String leftEyeCO = "Absent";
  late String rightEyeKeratoplasty = "No";
  late String leftEyeKeratoplasty = "No";

  // Right Eye Form variables
  late String coAgeRE = '';
  late String traumaRE = 'No';
  late String traumacorrelationRE = 'No';
  late String traumaobjectRE = 'Vegetative Matter';
  late String traumatreatmentRE = 'No';
  late String infectionRE = 'No';
  late String infectiontreatmentRE = 'No';
  late String birthRE = 'No';
  late String childhoodhistoryRE = 'No';
  late String childhoodallergyRE = 'No';
  late String childhoodallergyttRE = 'No';
  late String nutritionRE = 'No';
  late String vitaminattRE = 'No';
  late String trachomaRE = 'No';
  late String trachomattRE = 'No';
  late String causeOthRE = '';

  // Left Eye Form variables
  late String coAgeLE = '';
  late String traumaLE = 'No';
  late String traumacorrelationLE = 'No';
  late String traumaobjectLE = 'Vegetative Matter';
  late String traumatreatmentLE = 'No';
  late String infectionLE = 'No';
  late String infectiontreatmentLE = 'No';
  late String birthLE = 'No';
  late String childhoodhistoryLE = 'No';
  late String childhoodallergyLE = 'No';
  late String childhoodallergyttLE = 'No';
  late String nutritionLE = 'No';
  late String vitaminattLE = 'No';
  late String trachomaLE = 'No';
  late String trachomattLE = 'No';
  late String causeOthLE = '';
  late int pvaRE = 1;
  late int pinRE = 1;
  late int pvaLE = 1;
  late int pinLE = 1;
  late int lensRE = 1;
  late int lensLE = 1;
  late int cataractsxRE = 1;
  late int cataractcorrelationRE = 1;
  late int cataractsxLE = 1;
  late int cataractcorrelationLE = 1;

  late int dateofsurgeryRE = 1;
  late int dateofsurgeryLE = 1;

  late int suspectCauseRE = 1;
  late int suspectCauseLE = 1;

  late int q1 = 1;
  late int q11 = 1;
  late int q2 = 2;
  late int q21 = 1;
  late int q22 = 0;
}


 Question(
              question: "house Type",
              variable: "houseType",
              hint: "house type",
              required: true,
              lastSaved: true,
              type: QuestionType.radiobutton,
              valueType: "Number",
              valueRange: ["New House", "Old House"]),
          Question(
              question: "House Number",
              variable: "hNo",
              hint: "2 characters",
              required: true,
              constraint: getCondition(r"REGEX ^ [0-99]{2}$"),
              constraintMessage: "Should be of length 2",
              lastSaved: true,
              type: QuestionType.textfield,
              valueType: "String",
              valueRange: []),






class SectionA extends StatefulWidget {
  const SectionA({Key? key}) : super(key: key);

  @override
  State<SectionA> createState() => _SectionAState();
}

class _SectionAState extends State<SectionA> {
  final _formKey = GlobalKey<FormState>();

  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  final List<String> examinationStatusOptions = [
    'Examined',
    'Not available',
    'Refused'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Form'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Grader Code *',
                            hintText: 'Enter 4 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Grader Code';
                            }
                            if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                              return 'Grader Code must be exactly 4 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.graderCode = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Recorder Code *',
                            hintText: 'Enter 4 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Recorder Code';
                            }
                            if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                              return 'Recorder Code must be exactly 4 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.recorderCode = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'District Code *',
                            hintText: 'Enter 5 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the District Code';
                            }
                            if (!RegExp(r'^[0-9]{5}$').hasMatch(value)) {
                              return 'District Code must be exactly 5 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.districtCode = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Cluster Code *',
                            hintText: 'Enter 3 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Cluster Code';
                            }
                            if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
                              return 'Cluster Code must be exactly 3 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.clusterCode = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'House Number *',
                            hintText: 'Enter 2 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the House Number';
                            }
                            if (!RegExp(r'^[0-9]{2}$').hasMatch(value)) {
                              return 'House Number must be exactly 2 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.houseNumber = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Individual No *',
                            hintText: 'Enter 2 numbers',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Individual No';
                            }
                            if (!RegExp(r'^[0-9]{2}$').hasMatch(value)) {
                              return 'Individual No must be exactly 2 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.individualNo = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name of the Resident *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Name of the Resident';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.residentName = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Age in years',
                            hintText: 'Enter age between 0 and 100',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Age';
                            }
                            final ageValue = int.tryParse(value);
                            if (ageValue == null ||
                                ageValue < 0 ||
                                ageValue > 100) {
                              return 'Age must be between 0 and 100';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            ans.age = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          value: ans.gender,
                          items: genderOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              ans.gender = value!;
                            });
                          },
                          onSaved: (value) {
                            ans.gender = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Examination Status',
                            border: OutlineInputBorder(),
                          ),
                          value: ans.examinationStatus,
                          items: examinationStatusOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              ans.examinationStatus = value!;
                            });
                          },
                          onSaved: (value) {
                            ans.examinationStatus = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Education',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            ans.education = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              logger.i('Grader Code: ${ans.graderCode}');
                              logger.i('Recorder Code: ${ans.recorderCode}');
                              logger.i('District Code: ${ans.districtCode}');
                              logger.i('Cluster Code: ${ans.clusterCode}');
                              logger.i('House Number: ${ans.houseNumber}');
                              logger.i('Individual No: ${ans.individualNo}');
                              logger.i(
                                  'Name of the Resident: ${ans.residentName}');
                              logger.i('Age: ${ans.age}');
                              logger.i('Gender: ${ans.gender}');
                              logger.i(
                                  'Examination Status: ${ans.examinationStatus}');
                              logger.i('Education: ${ans.education}');

                              navKey.currentState?.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SectionB()),
                              );
                            }
                          },
                          child: const Text('Next'),
                        ),
                      ],
                    )))));
  }
}

class SectionB extends StatefulWidget {
  const SectionB({Key? key}) : super(key: key);

  @override
  State<SectionB> createState() => _SectionBState();
}

class _SectionBState extends State<SectionB> {
  final _formKey = GlobalKey<FormState>();

  final List<String> presentAbsentOptions = ['Present', 'Absent'];
  final List<String> yesNoOptions = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section B'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Right Eye - CO',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.rightEyeCO,
                  items: presentAbsentOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.rightEyeCO = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.rightEyeCO = value!;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Left Eye - CO',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.leftEyeCO,
                  items: presentAbsentOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.leftEyeCO = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.leftEyeCO = value!;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Right Eye - Keratoplasty',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.rightEyeKeratoplasty,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.rightEyeKeratoplasty = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.rightEyeKeratoplasty = value!;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Left Eye - Keratoplasty',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.leftEyeKeratoplasty,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.leftEyeKeratoplasty = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.leftEyeKeratoplasty = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      logger.i('Right Eye - CO: ${ans.rightEyeCO}');
                      logger.i('Left Eye - CO: ${ans.leftEyeCO}');
                      logger.i(
                          'Right Eye - Keratoplasty: ${ans.rightEyeKeratoplasty}');
                      logger.i(
                          'Left Eye - Keratoplasty: ${ans.leftEyeKeratoplasty}');

                      if (ans.rightEyeCO == 'Present') {
                        navKey.currentState?.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RightEye()),
                        );
                      } else if (ans.leftEyeCO == 'Present') {
                        navKey.currentState?.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeftEye()),
                        );
                      }

                      // Perform the desired action
                      // For example, navigate to the next section or submit the form
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RightEye extends StatefulWidget {
  const RightEye({super.key});

  @override
  State<RightEye> createState() => _RightEyeFormState();
}

class _RightEyeFormState extends State<RightEye> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown options
  List<String> yesNoOptions = ['Yes', 'No'];
  List<String> traumaObjectOptions = [
    'Vegetative Matter',
    'Animal/ Livestock',
    'Sharp object/ instrument',
    'Blunt object/ Instrument',
    'Self',
    'Other human',
    'Chemical',
    'Hot/Cold object'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Right Eye Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Right Eye: Age of onset of CO',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
                onSaved: (value) {
                  ans.coAgeRE = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Right Eye: Did you have any injury/trauma to this eye?',
                  border: OutlineInputBorder(),
                ),
                value: ans.traumaRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.traumaRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.traumaRE = value!;
                },
              ),
              if (ans.traumaRE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Right Eye: Did the opacity occur after trauma to the right eye?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.traumacorrelationRE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.traumacorrelationRE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.traumacorrelationRE = value!;
                  },
                ),
                if (ans.traumacorrelationRE == 'Yes') ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText:
                          'Right eye: - With what object did the injury occur?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.traumaobjectRE,
                    items: traumaObjectOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.traumaobjectRE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.traumaobjectRE = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText:
                          'Right Eye: Did you take any treatment for injury?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.traumatreatmentRE,
                    items: yesNoOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.traumatreatmentRE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.traumatreatmentRE = value!;
                    },
                  ),
                ]
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Right Eye:- Do you have any history of episode/s of redness/infection/keratitis/phoola?',
                  border: OutlineInputBorder(),
                ),
                value: ans.infectionRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.infectionRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.infectionRE = value!;
                },
              ),
              if (ans.infectionRE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Right Eye: - Did you take any treatment for the infection?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.infectiontreatmentRE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.infectiontreatmentRE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.infectiontreatmentRE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Right Eye: Any opacity since birth?',
                  border: OutlineInputBorder(),
                ),
                value: ans.birthRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.birthRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.birthRE = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Right Eye: Any opacity since childhood?',
                  border: OutlineInputBorder(),
                ),
                value: ans.childhoodhistoryRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.childhoodhistoryRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.childhoodhistoryRE = value!;
                },
              ),
              if (ans.childhoodhistoryRE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Right Eye: - Did you have any childhood allergy/itching after which opacity developed?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.childhoodallergyRE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.childhoodallergyRE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.childhoodallergyRE = value!;
                  },
                ),
                if (ans.childhoodallergyRE == 'Yes') ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Right Eye: Did you receive any treatment?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.childhoodallergyttRE,
                    items: yesNoOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.childhoodallergyttRE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.childhoodallergyttRE = value!;
                    },
                  ),
                ],
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Right Eye: - Do you have any nutritional deficiency/disorder realted to eating in childhood?',
                  border: OutlineInputBorder(),
                ),
                value: ans.nutritionRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.nutritionRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.nutritionRE = value!;
                },
              ),
              if (ans.nutritionRE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Right Eye: - Did you receive any treatment for the nutrional deficiency?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.vitaminattRE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.vitaminattRE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.vitaminattRE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Right Eye: - Do/did you have any eyelashes rubbing against the cornea/Putli?',
                  border: OutlineInputBorder(),
                ),
                value: ans.trachomaRE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.trachomaRE = value!;
                  });
                },
                onSaved: (value) {
                  ans.trachomaRE = value!;
                },
              ),
              if (ans.trachomaRE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Right Eye: - Did you go to any doctor/take treatment for it?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.trachomattRE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.trachomattRE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.trachomattRE = value!;
                  },
                ),
              ],
              if (ans.traumaRE == 'No' &&
                  ans.infectionRE == 'No' &&
                  ans.birthRE == 'No' &&
                  ans.childhoodhistoryRE == 'No' &&
                  ans.nutritionRE == 'No' &&
                  ans.trachomaRE == 'No') ...[
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Right eye:- Other specify',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the specifics';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.causeOthRE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Perform form submission here
                    // Log the values
                    logger.i('ans.coAgeRE: ${ans.coAgeRE}');
                    logger.i('ans.traumaRE: ${ans.traumaRE}');
                    logger.i(
                        'ans.traumacorrelationRE: ${ans.traumacorrelationRE}');
                    logger.i('ans.traumaobjectRE: ${ans.traumaobjectRE}');
                    logger.i('ans.traumatreatmentRE: ${ans.traumatreatmentRE}');
                    logger.i('ans.infectionRE: ${ans.infectionRE}');
                    logger.i(
                        'ans.infectiontreatmentRE: ${ans.infectiontreatmentRE}');
                    logger.i('ans.birthRE: ${ans.birthRE}');
                    logger
                        .i('ans.childhoodhistoryRE: ${ans.childhoodhistoryRE}');
                    logger
                        .i('ans.childhoodallergyRE: ${ans.childhoodallergyRE}');
                    logger.i(
                        'ans.childhoodallergyttRE: ${ans.childhoodallergyttRE}');
                    logger.i('ans.nutritionRE: ${ans.nutritionRE}');
                    logger.i('ans.vitaminattRE: ${ans.vitaminattRE}');
                    logger.i('ans.trachomaRE: ${ans.trachomaRE}');
                    logger.i('ans.trachomattRE: ${ans.trachomattRE}');
                    logger.i('ans.causeOthRE: ${ans.causeOthRE}');

                    if (ans.leftEyeCO == 'Present') {
                      navKey.currentState?.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeftEye()),
                      );
                    } else if (ans.rightEyeCO == 'Present' ||
                        ans.leftEyeCO == 'Present' ||
                        ans.rightEyeKeratoplasty == 'Yes' ||
                        ans.leftEyeKeratoplasty == 'Yes') {
                      navKey.currentState?.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SectionBrest()),
                      );
                    }
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeftEye extends StatefulWidget {
  const LeftEye({super.key});

  @override
  State<LeftEye> createState() => _LeftEyeFormState();
}

class _LeftEyeFormState extends State<LeftEye> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown options
  List<String> yesNoOptions = ['Yes', 'No'];
  List<String> traumaObjectOptions = [
    'Vegetative Matter',
    'Animal/ Livestock',
    'Sharp object/ instrument',
    'Blunt object/ Instrument',
    'Self',
    'Other human',
    'Chemical',
    'Hot/Cold object'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Left Eye Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Left Eye: Age of onset of CO',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
                onSaved: (value) {
                  ans.coAgeLE = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Left Eye: Did you have any injury/trauma to this eye?',
                  border: OutlineInputBorder(),
                ),
                value: ans.traumaLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.traumaLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.traumaLE = value!;
                },
              ),
              if (ans.traumaLE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Left Eye: Did the opacity occur after trauma to the left eye?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.traumacorrelationLE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.traumacorrelationLE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.traumacorrelationLE = value!;
                  },
                ),
                if (ans.traumacorrelationLE == 'Yes') ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText:
                          'Left eye: - With what object did the injury occur?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.traumaobjectLE,
                    items: traumaObjectOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.traumaobjectLE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.traumaobjectLE = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText:
                          'Left Eye: Did you take any treatment for injury?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.traumatreatmentLE,
                    items: yesNoOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.traumatreatmentLE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.traumatreatmentLE = value!;
                    },
                  ),
                ]
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Left Eye:- Do you have any history of episode/s of redness/infection/keratitis/phoola?',
                  border: OutlineInputBorder(),
                ),
                value: ans.infectionLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.infectionLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.infectionLE = value!;
                },
              ),
              if (ans.infectionLE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Left Eye: - Did you take any treatment for the infection?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.infectiontreatmentLE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.infectiontreatmentLE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.infectiontreatmentLE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Left Eye: Any opacity since birth?',
                  border: OutlineInputBorder(),
                ),
                value: ans.birthLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.birthLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.birthLE = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Left Eye: Any opacity since childhood?',
                  border: OutlineInputBorder(),
                ),
                value: ans.childhoodhistoryLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.childhoodhistoryLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.childhoodhistoryLE = value!;
                },
              ),
              if (ans.childhoodhistoryLE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Left Eye: - Did you have any childhood allergy/itching after which opacity developed?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.childhoodallergyLE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.childhoodallergyLE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.childhoodallergyLE = value!;
                  },
                ),
                if (ans.childhoodallergyLE == 'Yes') ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Left Eye: Did you receive any treatment?',
                      border: OutlineInputBorder(),
                    ),
                    value: ans.childhoodallergyttLE,
                    items: yesNoOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.childhoodallergyttLE = value!;
                      });
                    },
                    onSaved: (value) {
                      ans.childhoodallergyttLE = value!;
                    },
                  ),
                ],
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Left Eye: - Do you have any nutritional deficiency/disorder realted to eating in childhood?',
                  border: OutlineInputBorder(),
                ),
                value: ans.nutritionLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.nutritionLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.nutritionLE = value!;
                },
              ),
              if (ans.nutritionLE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Left Eye: - Did you receive any treatment for the nutrional deficiency?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.vitaminattLE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.vitaminattLE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.vitaminattLE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText:
                      'Left Eye: - Do/did you have any eyelashes rubbing against the cornea/Putli?',
                  border: OutlineInputBorder(),
                ),
                value: ans.trachomaLE,
                items: yesNoOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.trachomaLE = value!;
                  });
                },
                onSaved: (value) {
                  ans.trachomaLE = value!;
                },
              ),
              if (ans.trachomaLE == 'Yes') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        'Left Eye: - Did you go to any doctor/take treatment for it?',
                    border: OutlineInputBorder(),
                  ),
                  value: ans.trachomattLE,
                  items: yesNoOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.trachomattLE = value!;
                    });
                  },
                  onSaved: (value) {
                    ans.trachomattLE = value!;
                  },
                ),
              ],
              if (ans.traumaLE == 'No' &&
                  ans.infectionLE == 'No' &&
                  ans.birthLE == 'No' &&
                  ans.childhoodhistoryLE == 'No' &&
                  ans.nutritionLE == 'No' &&
                  ans.trachomaLE == 'No') ...[
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Left eye:- Other specify',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the specifics';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ans.causeOthLE = value!;
                  },
                ),
              ],
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Perform form submission here
                    // Log the values
                    logger.i('ans.coAgeLE: ${ans.coAgeLE}');
                    logger.i('ans.traumaLE: ${ans.traumaLE}');
                    logger.i(
                        'ans.traumacorrelationLE: ${ans.traumacorrelationLE}');
                    logger.i('ans.traumaobjectLE: ${ans.traumaobjectLE}');
                    logger.i('ans.traumatreatmentLE: ${ans.traumatreatmentLE}');
                    logger.i('ans.infectionLE: ${ans.infectionLE}');
                    logger.i(
                        'ans.infectiontreatmentLE: ${ans.infectiontreatmentLE}');
                    logger.i('ans.birthLE: ${ans.birthLE}');
                    logger
                        .i('ans.childhoodhistoryLE: ${ans.childhoodhistoryLE}');
                    logger
                        .i('ans.childhoodallergyLE: ${ans.childhoodallergyLE}');
                    logger.i(
                        'ans.childhoodallergyttLE: ${ans.childhoodallergyttLE}');
                    logger.i('ans.nutritionLE: ${ans.nutritionLE}');
                    logger.i('ans.vitaminattLE: ${ans.vitaminattLE}');
                    logger.i('ans.trachomaLE: ${ans.trachomaLE}');
                    logger.i('ans.trachomattLE: ${ans.trachomattLE}');
                    logger.i('ans.causeOthLE: ${ans.causeOthLE}');

                    if (ans.rightEyeCO == 'Present' ||
                        ans.leftEyeCO == 'Present' ||
                        ans.rightEyeKeratoplasty == 'Yes' ||
                        ans.leftEyeKeratoplasty == 'Yes') {
                      navKey.currentState?.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SectionBrest()),
                      );
                    }
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionBrest extends StatefulWidget {
  const SectionBrest({super.key});

  @override
  State<SectionBrest> createState() => _SectionBrestFormState();
}

class _SectionBrestFormState extends State<SectionBrest> {
  final _formKey = GlobalKey<FormState>();

  // Variables for the values

  Map<int, String> visionlb = {
    1: 'Can see 6/12',
    2: "Can't see 6/12 but can see 6/18",
    3: "Can't see 6/18 but can see 6/60",
    4: "Can't see 6/60 but can see 3/60",
    5: "Can't see 3/60 but can see 1/60",
    6: 'Light Perception (PL+)',
    7: 'No light perception (PL-)',
    8: 'Yes follows light (≤5 years of Age)',
    9: 'No follows light (≤5 years of Age)',
  };

  Map<int, String> lenslb = {
    1: 'Clear',
    2: 'Obvious lens opacity',
    3: 'Pseudophakia',
    4: 'Aphakia',
    5: 'Cannot Visualize lens',
  };

  Map<int, String> yesNoOption = {
    1: 'Yes',
    2: 'No',
  };

  Map<int, String> dateofsurgerylb = {
    1: 'past 6 months',
    2: '6 months to 1 year',
    3: '1 year to 5 years',
    4: '5 years to 10 years',
    5: '> 10 years',
  };

  Map<int, String> suspectCauselb = {
    1: 'Corneal opacity',
    2: 'Cataract',
    3: 'Glaucoma',
    4: 'Retinal disease including DR',
    5: 'Phthisis/Globe abnormality',
    6: 'Squint/Nystagmus',
    7: 'Any other',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section B rest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: ans.pvaRE,
                onChanged: (newValue) {
                  setState(() {
                    ans.pvaRE = newValue!;
                  });
                },
                items: visionlb.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                    labelText: 'Right eye: Presenting Vision'),
              ),
              if (ans.pvaRE != 1 &&
                  ans.pvaRE != 7 &&
                  ans.age > 5 &&
                  ans.pvaRE < 8) ...[
                DropdownButtonFormField<int>(
                  value: ans.pinRE,
                  onChanged: (newValue) {
                    setState(() {
                      ans.pinRE = newValue!;
                    });
                  },
                  items: visionlb.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText: 'Right eye: Pinhole Vision'),
                ),
              ],
              DropdownButtonFormField<int>(
                value: ans.lensRE,
                decoration:
                    const InputDecoration(labelText: 'Right eye: Lens Status'),
                items: lenslb.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    ans.lensRE = value!;
                  });
                },
              ),
              if (ans.lensRE == 4) ...[
                DropdownButtonFormField<int>(
                  value: ans.cataractsxRE,
                  onChanged: (value) {
                    setState(() {
                      ans.cataractsxRE = value!;
                    });
                  },
                  items: yesNoOption.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Right eye: Have you undergone cataract surgery?'),
                ),
              ],
              if (ans.cataractsxRE == 1 || ans.lensRE == 3) ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      labelText: 'Right eye: When did you undergo surgery?'),
                  value: ans.dateofsurgeryRE,
                  items: dateofsurgerylb.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.dateofsurgeryRE = value!;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  value: ans.cataractcorrelationRE,
                  onChanged: (value) {
                    setState(() {
                      ans.cataractcorrelationRE = value!;
                    });
                  },
                  items: yesNoOption.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Right eye: Did the opacity occur after the cataract surgery?'),
                ),
              ],
              if (ans.pvaRE == 7 || ans.pinRE > 1) ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      labelText: 'Right eye: Suspected Cause of BCVA <6/12'),
                  items: suspectCauselb.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.suspectCauseRE = value!;
                    });
                  },
                ),
              ],
              DropdownButtonFormField<int>(
                value: ans.pvaLE,
                onChanged: (newValue) {
                  setState(() {
                    ans.pvaLE = newValue!;
                  });
                },
                items: visionlb.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                    labelText: 'Left eye: Presenting Vision'),
              ),
              if (ans.pvaLE != 1 &&
                  ans.pvaLE != 7 &&
                  ans.age > 5 &&
                  ans.pvaLE < 8) ...[
                DropdownButtonFormField<int>(
                  value: ans.pinLE,
                  onChanged: (newValue) {
                    setState(() {
                      ans.pinLE = newValue!;
                    });
                  },
                  items: visionlb.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText: 'Left eye: Pinhole Vision'),
                ),
              ],
              DropdownButtonFormField<int>(
                value: ans.lensLE,
                decoration:
                    const InputDecoration(labelText: 'Left eye: Lens Status'),
                items: lenslb.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    ans.lensLE = value!;
                  });
                },
              ),
              if (ans.lensLE == 4) ...[
                DropdownButtonFormField<int>(
                  value: ans.cataractsxLE,
                  onChanged: (value) {
                    setState(() {
                      ans.cataractsxLE = value!;
                    });
                  },
                  items: yesNoOption.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Left eye: Have you undergone cataract surgery?'),
                ),
              ],
              if (ans.cataractsxLE == 1 || ans.lensLE == 3) ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      labelText: 'Left eye: When did you undergo surgery?'),
                  value: ans.dateofsurgeryLE,
                  items: dateofsurgerylb.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.dateofsurgeryLE = value!;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  value: ans.cataractcorrelationLE,
                  onChanged: (value) {
                    setState(() {
                      ans.cataractcorrelationLE = value!;
                    });
                  },
                  items: yesNoOption.entries
                      .map((entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Left eye: Did the opacity occur after the cataract surgery?'),
                ),
              ],
              if (ans.pvaLE == 7 || ans.pinLE > 1) ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      labelText: 'Left eye: Suspected Cause of BCVA <6/12'),
                  items: suspectCauselb.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.suspectCauseLE = value!;
                    });
                  },
                ),
              ],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Perform form submission here
                    // Log the values
                    logger.i('Right Eye: Presenting Vision: ${ans.pvaRE}');
                    logger.i('Right Eye: Pinhole Vision: ${ans.pinRE}');
                    logger.i('Right Eye: Lens Status: ${ans.lensRE}');
                    logger
                        .i('Right Eye: Cataract Surgery: ${ans.cataractsxRE}');
                    logger.i(
                        'Right Eye: Date of Surgery: ${ans.dateofsurgeryRE}');
                    logger.i(
                        'Right Eye: Cataract Correlation: ${ans.cataractcorrelationRE}');
                    logger
                        .i('Right Eye: Suspected Cause: ${ans.suspectCauseRE}');

                    logger.i('Left Eye: Presenting Vision: ${ans.pvaLE}');
                    logger.i('Left Eye: Pinhole Vision: ${ans.pinLE}');
                    logger.i('Left Eye: Lens Status: ${ans.lensLE}');
                    logger.i('Left Eye: Cataract Surgery: ${ans.cataractsxLE}');
                    logger
                        .i('Left Eye: Date of Surgery: ${ans.dateofsurgeryLE}');
                    logger.i(
                        'Left Eye: Cataract Correlation: ${ans.cataractcorrelationLE}');
                    logger
                        .i('Left Eye: Suspected Cause: ${ans.suspectCauseLE}');

                    if (ans.rightEyeCO == 'Present' ||
                        ans.leftEyeCO == 'Present') {
                      navKey.currentState?.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SectionC()),
                      );
                    } else {
                      navKey.currentState?.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Submit()),
                      );
                    }
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionC extends StatefulWidget {
  const SectionC({super.key});

  @override
  State<SectionC> createState() => _SectionCFormState();
}

class _SectionCFormState extends State<SectionC> {
  final _formKey = GlobalKey<FormState>();

  Map<int, String> yesNoOption = {
    1: 'Yes',
    2: 'No',
  };

  Map<int, String> barrier7lb = {
    1: 'Financial constraint',
    2: 'Distance to health facility',
    3: 'Lack of awareness of disease and its treatment',
    4: 'No one to accompany/old age',
    5: 'Fear of surgery/lack of faith in hospital services',
    6: 'Can carry out routine activities with other eye/not a priority',
    7: 'Told by doctor that it is irreversible/No treatment available',
  };

  Map<int, String> barrier8lb = {
    0: 'Registered for keratoplasty',
    1: 'Financial',
    2: 'Distance to health facility',
    3: 'No one to accompany/old age',
    4: 'Fear of surgery/lack of faith in hospital services',
    5: 'Can carry out routine activities with other eye/not a priority',
    6: 'Long follow up/Lifelong medications',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section C'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText:
                      'Have you taken treatment of Corneal opacity from an eye hospital?',
                ),
                value: ans.q1,
                items: yesNoOption.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ans.q1 = value!;
                  });
                },
              ),
              if (ans.q1 == 2)
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText:
                        'If no, what are the barriers preventing them from availing treatment for corneal opacity?',
                  ),
                  value: ans.q11,
                  items: barrier7lb.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.q11 = value!;
                    });
                  },
                ),
              if (ans.q1 == 1) ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Has Keratoplasty been advised?',
                  ),
                  value: ans.q2,
                  items: yesNoOption.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ans.q2 = value!;
                    });
                  },
                ),
                if (ans.q2 == 1)
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText:
                          'If yes, has the patient undergone Keratoplasty?',
                    ),
                    value: ans.q21,
                    items: yesNoOption.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.q21 = value!;
                      });
                    },
                  ),
                if (ans.q2 == 1)
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText:
                          'If not undergone keratoplasty, what are the barriers preventing them from availing keratoplasty services?',
                    ),
                    value: ans.q22,
                    items: barrier8lb.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ans.q22 = value!;
                      });
                    },
                  ),
              ],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Perform form submission here
                    // Log the values
                    logger.d('ans.q1: ${ans.q1}');
                    logger.d('ans.q11: ${ans.q11}');
                    logger.d('ans.q2: ${ans.q2}');
                    logger.d('ans.q21: ${ans.q21}');
                    logger.d('ans.q22: ${ans.q22}');

                    navKey.currentState?.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SectionD()),
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionD extends StatefulWidget {
  const SectionD({super.key});

  @override
  State<SectionD> createState() => _SectionDState();
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    // Fetch the available cameras
    final cameras = await availableCameras();
    // Use the first available camera
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _takePhoto() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      // Do something with the captured image
      // For example, you can display the image in a new screen or save it to storage
      logger.i('Image captured: ${image.path}');
    } catch (e) {
      logger.i('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SectionDState extends State<SectionD> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: const [],
          ),
        ),
      ),
    );
  }
}

class Submit extends StatefulWidget {
  const Submit({super.key});

  @override
  State<Submit> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<Submit> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: const [],
          ),
        ),
      ),
    );
  }
}
 */

/* 
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickImage();
                  }),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickImageC();
                  }),
              const SizedBox(
                height: 20,
              ),
              image != null
                  ? Image.file(image!)
                  : const Text("No image selected")
            ],
          ),
        ));
  }
}
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/controller/hive_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/home_page.dart';
import 'package:keratoplastysurvey/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keratoplastysurvey/util.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;

void testData(my_hive_interface.HiveInterface hiveInterface) {
  surveys.clear();

  surveys = my_api.API.fromHive.loadSurveys(hiveInterface);

  print(surveys.length);

  if (surveys.isEmpty) {
    Survey keratoplasty = Survey(
        surveyName: "Keratoplasty Survey",
        description: "This is a survey about keratoplasty",
        sections: [
          Section(sectionID: 1, sectionName: "Demography", questions: [
            Question(
                question: "Grader Code",
                variable: "grader",
                hint: "4 Characters",
                required: true,
                constraint: getCondition(r"REGEX ^ [1000 - 9999]{ 4}$"),
                constraintMessage: "Grader Code Must be Exactly 4 numbers",
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "District Code",
                variable: "distCode",
                hint: "5 characters",
                required: true,
                constraint: getCondition(r"REGEX ^ [0 - 99999]{ 5}$"),
                constraintMessage: "District Code Must be Exactly 5 numbers",
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "Cluster Code",
                variable: "clusCode",
                hint: "3 characters",
                required: true,
                constraint: getCondition(r"REGEX ^ [0 - 999]{ 3}$"),
                constraintMessage: "Cluster Code Must be Exactly 3 numbers",
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "House Number",
                variable: "hNo",
                hint: "2 characters",
                required: true,
                constraint: getCondition(r"REGEX ^ [0 - 99]{ 2}$"),
                constraintMessage:
                    "House No.be Exactly 2 numbers or Correct code",
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "Individual no",
                variable: "indNo",
                hint: "2 characters",
                required: true,
                constraint: getCondition(r"REGEX ^ [0 - 99]{ 2}$"),
                constraintMessage:
                    "Individual Number Must be Exactly 2 numbers",
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "Name of the Resident",
                variable: "name",
                required: true,
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "String",
                valueRange: []),
            Question(
                question: "Age in years",
                variable: "age",
                required: true,
                constraint: getCondition(r"${ age } >= 0 and ${ age } < 100"),
                lastSaved: true,
                type: QuestionType.textfield,
                valueType: "Number",
                valueRange: []),
            Question(
                question: "Gender",
                variable: "gender",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Male", "Female", "Others"]),
            Question(
                question: "Education",
                variable: "education",
                required: true,
                visibilityCondition: getCondition(r"${ age } > 6"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Illiterate",
                  "Literate/Primary (1 to 5 class passed)",
                  "Middle school (6 to 8 class passed)",
                  "High School (9 to 10 class passed)",
                  "Senior secondary school (11 to 12 class passed)",
                  "Graduate/Diploma and above (13 and above)",
                  "Not applicable if age≤6 years",
                ]),
            Question(
                question: "Examination Status",
                variable: "examination",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Examined", "Not available", "Refused"]),
          ], jumps: [
            Jump(sectionID: 2, condition: getCondition(r"${ examination }=1")),
            Jump(sectionID: 8),
          ]),
          Section(sectionID: 2, sectionName: "Section B", questions: [
            Question(
                question: "Right eye: - CO ",
                variable: "coRE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Present", "Absent"]),
            Question(
                question: "Central or Peripheral ? ",
                variable: "cpRE",
                required: true,
                visibilityCondition: getCondition(r"${ coRE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Central", "Peripheral"]),
            Question(
                question: "Size",
                variable: "sizeRE",
                required: true,
                visibilityCondition: getCondition(r"${ coRE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["<5 mm", ">5 mm"]),
            Question(
                question: "Left eye: - CO ",
                variable: "coLE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Present", "Absent"]),
            Question(
                question: "Central or Peripheral ? ",
                variable: "cpLE",
                required: true,
                visibilityCondition: getCondition(r"${ coLE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Central", "Peripheral"]),
            Question(
                question: "Size",
                variable: "sizeLE",
                required: true,
                visibilityCondition: getCondition(r"${ coLE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["<5 mm", ">5 mm"]),
            Question(
                question: "Right eye: - Keratoplasty",
                variable: "kerRE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Left eye: - Keratoplasty ",
                variable: "kerLE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
          ], jumps: [
            Jump(sectionID: 3, condition: getCondition(r"${ coRE }=1 ")),
            Jump(sectionID: 4, condition: getCondition(r"${ coLE }=1 ")),
            Jump(
                sectionID: 5,
                condition: getCondition(
                    r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerRE }=1")),
            Jump(
                sectionID: 7,
                condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
          ]),
          Section(
              sectionID: 3,
              sectionName: "Section B - Right Eye",
              questions: [
                Question(
                    question: "Right eye: - Age of onset of CO",
                    variable: "coAgeRE",
                    required: true,
                    constraint: getCondition(r"${ coAgeRE } <= ${ age }"),
                    constraintMessage: "Age of onset cannot greater then Age",
                    lastSaved: true,
                    type: QuestionType.textfield,
                    valueType: "Number",
                    valueRange: []),
                Question(
                    question:
                        "Right eye: - Did you have any injury / trauma to this eye ? ",
                    variable: "traumaRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right eye: - Did the opacity occur after trauma to the right eye ",
                    variable: "traumacorrelationRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ traumaRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right eye: - With what object did the injury occur ? ",
                    variable: "traumaobjectRE",
                    required: true,
                    visibilityCondition:
                        getCondition(r"${ traumacorrelationRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: [
                      "Vegetative Matter",
                      "Animal/ Livestock",
                      "Sharp object/ instrument",
                      "Blunt object/ Instrument",
                      "Self",
                      "Other human",
                      "Chemical",
                      "Hot/Cold object"
                    ]),
                Question(
                    question:
                        "Right Eye: - Did you take any treatment for the injury ? ",
                    variable: "traumatreatmentRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ traumacorrelationRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Do you have any history of episode / s of redness / infection / keratitis / 'phoola' ? ",
                    variable: "infectionRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Did you take any treatment for the infection ? ",
                    variable: "infectiontreatmentRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ infectionRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Has the opacity been present since birth ? ",
                    variable: "birthRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Has the opacity developed later on in childhood ? ",
                    variable: "childhoodhistoryRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Did you have any childhood allergy / rash / itching / fever after which opacity developed ? ",
                    variable: "childhoodallergyRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ childhoodhistoryRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Did you take any treatment for it prior to the opacity ? ",
                    variable: "childhoodallergyttRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ childhoodallergyRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Do you have any nutritional deficiency / disorder related to eating in childhood ? ",
                    variable: "nutritionRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Did you receive any treatment for the nutrional deficiency ? ",
                    variable: "vitaminattRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ nutritionRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Did you take immunization according to age ? ",
                    variable: "immunisationRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ nutritionRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Do / did you have any eyelashes rubbing against the cornea / 'Putli', any history of 'parbaal' / 'kukure' ? ",
                    variable: "trachomaRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Right Eye: - Did you go to any doctor / take treatment for it ? ",
                    variable: "trachomattRE",
                    required: true,
                    visibilityCondition: getCondition(r"${ trachomaRE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Right eye: - Other specify",
                    variable: "causeOthRE",
                    required: true,
                    visibilityCondition: getCondition(
                        r"${traumaRE}=2 and ${infectionRE}=2 and ${birthRE}=2 and ${childhoodhistoryRE}=2 and ${nutritionRE}=2 and ${trachomaRE}=2"),
                    lastSaved: true,
                    type: QuestionType.textfield,
                    valueType: "Number",
                    valueRange: []),
              ],
              jumps: [
                Jump(sectionID: 4, condition: getCondition(r"${ coLE }=1 ")),
                Jump(
                    sectionID: 5,
                    condition: getCondition(
                        r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerRE }=1")),
                Jump(
                    sectionID: 7,
                    condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
              ]),
          Section(
              sectionID: 4,
              sectionName: "Section B - Left Eye",
              questions: [
                Question(
                    question: "Left eye: - Age of onset of CO",
                    variable: "coAgeLE",
                    required: true,
                    constraint: getCondition(r"${ coAgeLE } <= ${ age }"),
                    constraintMessage: "Age of onset cannot greater then Age",
                    lastSaved: true,
                    type: QuestionType.textfield,
                    valueType: "Number",
                    valueRange: []),
                Question(
                    question:
                        "Left eye: - Did you have any injury / trauma to this eye ? ",
                    variable: "traumaLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did the opacity occur after trauma to the right eye ",
                    variable: "traumacorrelationLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ traumaLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - With what object did the injury occur ? ",
                    variable: "traumaobjectLE",
                    required: true,
                    visibilityCondition:
                        getCondition(r"${ traumacorrelationLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: [
                      "Vegetative Matter",
                      "Animal/ Livestock",
                      "Sharp object/ instrument",
                      "Blunt object/ Instrument",
                      "Self",
                      "Other human",
                      "Chemical",
                      "Hot/Cold object"
                    ]),
                Question(
                    question:
                        "Left eye: - Did you take any treatment for the injury ? ",
                    variable: "traumatreatmentLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ traumacorrelationLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Do you have any history of episode / s of redness / infection / keratitis / 'phoola' ? ",
                    variable: "infectionLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did you take any treatment for the infection ? ",
                    variable: "infectiontreatmentLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ infectionLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Has the opacity been present since birth ? ",
                    variable: "birthLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Has the opacity developed later on in childhood ? ",
                    variable: "childhoodhistoryLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did you have any childhood allergy / rash / itching / fever after which opacity developed ? ",
                    variable: "childhoodallergyLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ childhoodhistoryLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did you take any treatment for it prior to the opacity ? ",
                    variable: "childhoodallergyttLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ childhoodallergyLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Do you have any nutritional deficiency / disorder related to eating in childhood ? ",
                    variable: "nutritionLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did you receive any treatment for the nutrional deficiency ? ",
                    variable: "vitaminattLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ nutritionLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Did you take immunization according to age ? ",
                    variable: "immunisationLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ nutritionLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Do / did you have any eyelashes rubbing against the cornea / 'Putli', any history of 'parbaal' / 'kukure' ? ",
                    variable: "trachomaLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Left eye: - Did you go to any doctor / take treatment for it ? ",
                    variable: "trachomattLE",
                    required: true,
                    visibilityCondition: getCondition(r"${ trachomaLE }=1"),
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Left eye: - Other specify",
                    variable: "causeOthLE",
                    required: true,
                    visibilityCondition: getCondition(
                        r"${traumaLE}=2 and ${infectionLE}=2 and ${birthLE}=2 and ${childhoodhistoryLE}=2 and ${nutritionLE}=2 and ${trachomaLE}=2"),
                    lastSaved: true,
                    type: QuestionType.textfield,
                    valueType: "Number",
                    valueRange: []),
              ],
              jumps: [
                Jump(
                    sectionID: 5,
                    condition: getCondition(
                        r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerRE }=1")),
                Jump(
                    sectionID: 7,
                    condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
              ]),
          Section(sectionID: 5, sectionName: "Section B-End", questions: [
            Question(
                question: "Right eye: - Presenting Vision",
                variable: "pvaRE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Can see 6/12",
                  "Can't see 6/12 but can see 6/18",
                  "Can't see 6/18 but can see 6/60",
                  "Can't see 6/60 but can see 3/60",
                  "Can't see 3/60 but can see 1/60",
                  "Light Perception (PL+)",
                  "No light perception (PL-)",
                  "Yes follows light (≤5 year of Age)",
                  "No follows light (≤5 year of Age)"
                ]),
            Question(
                question: "Right eye: - Pinhole Vision",
                variable: "pinRE",
                required: true,
                visibilityCondition: getCondition(
                    r"${ pvaRE } != 1 and ${ pvaRE } != 7 and ${ age } > 5 and ${ pvaRE } < 8"),
                constraint: getCondition(r"${ pinRE } <= ${ pvaRE }"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Can see 6/12",
                  "Can't see 6/12 but can see 6/18",
                  "Can't see 6/18 but can see 6/60",
                  "Can't see 6/60 but can see 3/60",
                  "Can't see 3/60 but can see 1/60",
                  "Light Perception (PL+)",
                  "No light perception (PL-)",
                  "Yes follows light (≤5 year of Age)",
                  "No follows light (≤5 year of Age)"
                ]),
            Question(
                question: "Right eye: - Lens Status",
                variable: "lensRE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Clear",
                  "Obvious lens opacity",
                  "Pseudophakia",
                  "Aphakia",
                  "Cannot Visualize lens"
                ]),
            Question(
                question: "Right eye: - Have you undergone cataract surgery ? ",
                variable: "cataractsxRE",
                required: true,
                visibilityCondition: getCondition(r"${ lensRE } = 4"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Right eye: - When did you undergo surgery ? ",
                variable: "dateofsurgeryRE",
                required: true,
                visibilityCondition:
                    getCondition(r"${ cataractsxRE } = 1 or ${ lensRE } = 3"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "past 6 months",
                  "6 months to 1 year",
                  "1 year to 5 years",
                  "5 years to 10 years",
                  "> 10 years"
                ]),
            Question(
                question:
                    "Right eye: - Did the opacity occur after the cataract surgery ? ",
                variable: "cataractcorrelationRE",
                required: true,
                visibilityCondition: getCondition(r"${ cataractsxRE } = 1 or ${ lensRE } = 3"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Right eye: - Suspected Cause of BCVA < 6 / 12 ",
                variable: "suspectCauseRE",
                required: true,
                visibilityCondition:
                    getCondition(r"${ pvaRE } = 7 or ${ pinRE } > 1"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Corneal opacity",
                  "Cataract",
                  "Glaucoma",
                  "Retinal disease including DR",
                  "Phthisis/Globe abnormality ",
                  "Squint/Nystagmus",
                  "Any other"
                ]),
            Question(
                question: "Left eye: - Presenting Vision",
                variable: "pvaLE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Can see 6/12",
                  "Can't see 6/12 but can see 6/18",
                  "Can't see 6/18 but can see 6/60",
                  "Can't see 6/60 but can see 3/60",
                  "Can't see 3/60 but can see 1/60",
                  "Light Perception (PL+)",
                  "No light perception (PL-)",
                  "Yes follows light (≤5 year of Age)",
                  "No follows light (≤5 year of Age)"
                ]),
            Question(
                question: "Left eye: - Pinhole Vision",
                variable: "pinLE",
                required: true,
                visibilityCondition: getCondition(
                    r"${ pvaLE } != 1 and ${ pvaLE } != 7 and ${ age } > 5  and ${ pvaLE } < 8"),
                constraint: getCondition(r"${ pinLE } <= ${ pvaLE }"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Can see 6/12",
                  "Can't see 6/12 but can see 6/18",
                  "Can't see 6/18 but can see 6/60",
                  "Can't see 6/60 but can see 3/60",
                  "Can't see 3/60 but can see 1/60",
                  "Light Perception (PL+)",
                  "No light perception (PL-)",
                  "Yes follows light (≤5 year of Age)",
                  "No follows light (≤5 year of Age)"
                ]),
            Question(
                question: "Left eye: - Lens Status",
                variable: "lensLE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Clear",
                  "Obvious lens opacity",
                  "Pseudophakia",
                  "Aphakia",
                  "Cannot Visualize lens"
                ]),
            Question(
                question: "Left eye: - Have you undergone cataract surgery ? ",
                variable: "cataractsxLE",
                required: true,
                visibilityCondition: getCondition(r"${ lensLE } = 4"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Left eye: - When did you undergo surgery ? ",
                variable: "dateofsurgeryLE",
                required: true,
                visibilityCondition:
                    getCondition(r"${ cataractsxLE } = 1 or ${ lensLE } = 3"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "past 6 months",
                  "6 months to 1 year",
                  "1 year to 5 years",
                  "5 years to 10 years",
                  "> 10 years"
                ]),
            Question(
                question:
                    "Left eye: - Did the opacity occur after the cataract surgery ? ",
                variable: "cataractcorrelationLE",
                required: true,
                visibilityCondition: getCondition(r"${ cataractsxLE } = 1 or ${ lensLE } = 3"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Left eye: - Suspected Cause of BCVA < 6 / 12 ",
                variable: "suspectCauseLE",
                required: true,
                visibilityCondition:
                    getCondition(r"${ pvaLE } = 7 or ${ pinLE } > 1"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Corneal opacity",
                  "Cataract",
                  "Glaucoma",
                  "Retinal disease including DR",
                  "Phthisis/Globe abnormality ",
                  "Squint/Nystagmus",
                  "Any other"
                ]),
          ], jumps: [
            Jump(
                sectionID: 7,
                condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
            Jump(
              sectionID: 8,),
          ]),
          Section(sectionID: 7, sectionName: "Section D: Barriers", questions: [
            Question(
                question:
                    "Have you taken treatment of Corneal opacity from an eye hospital ? ",
                variable: "vara",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question:
                    "If no, what are the barriers preventing them from availing treatment for corneal opacity",
                variable: "varaa",
                required: true,
                visibilityCondition: getCondition(r"${vara} = 2"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Financial",
                  "Distance to health facility",
                  "Lack of awareness of disease and its treatment",
                  "No one to accompany/old age",
                  "Fear of surgery/ lack of faith in hospital services",
                  "Associated Comorbidities",
                  "Can carry out routine activities with other eye/not a priority",
                  "Health care worker said condition cannot be treated",
                  "Long follow up/Lifelong medications"
                ]),
            Question(
                question: "Has Keratoplasty been advised ? ",
                variable: "varb",
                required: true,
                visibilityCondition: getCondition(r"${ vara } = 1"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "If yes, has the patient undergone Keratoplasty ? ",
                variable: "varba",
                required: true,
                visibilityCondition: getCondition(r"${ varb } = 1"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question:
                    "If not undergone keratoplasty,what are the barriers preventing them from availing keratoplasty services ? ",
                variable: "varbb",
                required: true,
                visibilityCondition: getCondition(r"${ varba } = 2"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "Registered for keratoplasty",
                  "Financial",
                  "Distance to health facility",
                  "Lack of awareness of disease and its treatment",
                  "No one to accompany/old age",
                  "Fear of surgery/ lack of faith in hospital services",
                  "Associated Comorbidities",
                  "Can carry out routine activities with other eye/not a priority",
                  "Health care worker said condition cannot be treated",
                  "Long follow up/Lifelong medications"
                ]),
          ], jumps: [
            Jump(
                sectionID: 8,),
          ]),
          Section(
              sectionID: 8,
              sectionName: "Section E",
              questions: [
                Question(
                    question: "Right eye:- Photo",
                    variable: "photoRE",
                    required: false,
                    lastSaved: true,
                    type: QuestionType.imagePicker,
                    valueType: "String",
                    valueRange: []),
                Question(
                    question: "Left eye:- Photo",
                    variable: "photoLE",
                    required: false,
                    lastSaved: true,
                    type: QuestionType.imagePicker,
                    valueType: "String",
                    valueRange: []),
              ],
              jumps: [],
              finalSection: true)
        ],
        createAt: DateTime.now(),
        activeFrom: DateTime.now(),
        activeTill: DateTime(2024));

    my_api.API.toHive.storeSurvey(hiveInterface, keratoplasty.toJson());
    surveys.add(keratoplasty);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HIVE ENCRYPTION----------------------------------------
  const secureStorage = FlutterSecureStorage();

  final encryptionKey = await secureStorage.read(key: 'key');
  if (encryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64Encode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptKey = base64Url.decode(key!);
  if (kDebugMode) {
    print('Encryption key: $encryptKey');
  }
  // HIVE ENCRYPTION----------------------------------------

  // HIVE INIT---------------------------------------------
  var path = "/assets/db";
  Directory? directory;
  try {
    directory = await getApplicationDocumentsDirectory();
  } catch (err) {
    if (kDebugMode) {
      print("Cannot get download folder path");
    }
  }

  String projectName = await Util.getProjectName();

  if (!Directory("${directory!.path}/$projectName").existsSync()) {
    Directory("${directory.path}/$projectName").create(recursive: true);
  }else{
    Directory("${directory.path}/$projectName").delete(recursive: true);
    Directory("${directory.path}/$projectName").create(recursive: true);
  }
  directory = Directory("${directory.path}/$projectName");
  path = directory.path;
  if (kDebugMode) {
    print("path : $path");
  }
  //Hive.init(path);
  await Hive.initFlutter();
  // HIVE INIT---------------------------------------------

  var userBox = await Hive.openBox('user',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));
  var surveyBox = await Hive.openBox('survey',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));
  var answersBox = await Hive.openBox('answers',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));

  my_hive_interface.HiveInterface hiveInterface =
      my_hive_interface.HiveInterface(collection: {
    'user': userBox,
    'survey': surveyBox,
    'answers': answersBox,
  });
  try {
    await my_api.API.fromHive.loadUser(hiveInterface);
  } catch (e, stack) {
    if (kDebugMode) {
      print(e);
      print(stack);
    }
  }

  File file = await File('$path/env.json')
      .create(recursive: true, exclusive: true)
      .then((File file) {
    file.writeAsStringSync(json
        .encode({"baseurl": "https://rpcapplication.aiims.edu/keratoplasty"}));
    return file;
  }).onError((error, stackTrace) {
    return File('$path/env.json');
  });

  String jsonText = await file.readAsString();
  final data = await json.decode(jsonText);

  configuration = Configuration(data['baseurl']);
/*   

  my_api.API.uploadSurvey(hiveInterface: hiveInterface, survey: keratoplasty);
  if (user.token != "") {
    my_api.API.sync(hiveInterface: hiveInterface);
  } else {
  my_api.API.fromHive.loadSurveys(hiveInterface);
  }
 */

  testData(hiveInterface);

  if (kDebugMode) {
    print("User id : ${user.loginId}");
  }

  runApp(MyApp(hiveInterface: hiveInterface));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.hiveInterface}) : super(key: key);

  final my_hive_interface.HiveInterface hiveInterface;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keratoplasty Survey',
      navigatorKey: navKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: "/LoginPage",
      routes: {
        "/LoginPage": (context) => LoginPage(hiveInterface: hiveInterface),
        "/HomePage": (context) => HomePage(hiveInterface: hiveInterface),
      },
      home: (user.signedIn)
          ? HomePage(hiveInterface: hiveInterface)
          : LoginPage(hiveInterface: hiveInterface),
    );
  }
}

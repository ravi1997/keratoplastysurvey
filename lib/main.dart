import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/home_page.dart';
import 'package:keratoplastysurvey/pages/login_page.dart';
import 'package:keratoplastysurvey/util.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:math';


void testData(my_hive_interface.LocalStoreInterface localInterface) {
  surveys.clear();

  surveys = my_api.API.fromFile.loadSurveys(localInterface);

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
            Jump(sectionID:9),
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
                valueRange: ["Central (covering atleast half the pupil)", "Peripheral (covering less than half the pupil)","Total"]),
            Question(
                question: "Size",
                variable: "sizeRE",
                required: true,
                visibilityCondition: getCondition(r"${ coRE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["<5 mm (less than 2 times the pupil size)", ">=5 mm (equal to or more than 2 times the pupil size)"]),
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
                valueRange: ["Central (covering atleast half the pupil)", "Peripheral (covering less than half the pupil)","Total"]),
            Question(
                question: "Size",
                variable: "sizeLE",
                required: true,
                visibilityCondition: getCondition(r"${ coLE }=1 "),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["<5 mm (less than 2 times the pupil size)", ">=5 mm (equal to or more than 2 times the pupil size)"]),
            Question(
                question: "Right eye: - Has Keratoplasty been done previously?",
                variable: "kerRE",
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "Left eye: - Has Keratoplasty been done previously? ",
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
                    r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerLE }=1")),
            Jump(
                sectionID: 7,
                condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
            Jump(sectionID:8),
          ]),
          Section(
              sectionID: 3,
              sectionName: "Section B - Right Eye",
              questions: [
                Question(
                    question: "Age of onset of CO",
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
                        "Did the opacity occur after trauma to the right eye ",
                    variable: "traumacorrelationRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "With what object did the injury occur ? ",
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
                        "Right Eye: - Did the opacity occur in childhood after an episode of febrile illness with rash ? ",
                    variable: "childhoodRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                    "Did the CO occur after eye pain & redness due to ucler / infection/ 'phoola' in childhood?",
                    variable: "painRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                        "Do / did you have any eyelashes rubbing against the cornea / 'Putli', any history of 'parbaal' / 'kukure' ? ",
                    variable: "trachomaRE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Any Other relavant history / details related to development of CO",
                    variable: "causeOthRE",
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
                        r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerLE }=1")),
                Jump(
                    sectionID: 7,
                    condition: getCondition(r"${ coLE } = 1 or ${ coRE } = 1")),
              ]),
          Section(
              sectionID: 4,
              sectionName: "Section B - Left Eye",
              questions: [
                Question(
                    question: "Age of onset of CO",
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
                    "Did the opacity occur after trauma to the left eye ",
                    variable: "traumacorrelationLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                    "With what object did the injury occur ? ",
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
                    "Did the opacity occur in childhood after an episode of febrile illness with rash ? ",
                    variable: "childhoodLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question:
                    "Did the CO occur after eye pain & redness due to ucler / infection/ 'phoola' in childhood?",
                    variable: "painLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),

                Question(
                    question:
                    "Do / did you have any eyelashes rubbing against the cornea / 'Putli', any history of 'parbaal' / 'kukure' ? ",
                    variable: "trachomaLE",
                    required: true,
                    lastSaved: true,
                    type: QuestionType.dropdown,
                    valueType: "Number",
                    valueRange: ["Yes", "No"]),
                Question(
                    question: "Any Other relavant history / details related to development of CO",
                    variable: "causeOthLE",
                    lastSaved: true,
                    type: QuestionType.textfield,
                    valueType: "Number",
                    valueRange: []),
              ],
              jumps: [
                Jump(
                    sectionID: 5,
                    condition: getCondition(
                        r"${coRE}=1 or ${coLE}=1 or ${kerRE}=1 or ${ kerLE }=1")),
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
                  "6/6",
                  "6/7.5",
                  "6/9.5",
                  "6/12",
                  "6/15",
                  "6/18",
                  "6/24",
                  "6/30",
                  "6/38",
                  "6/48",
                  "6/60",
                  "3/60",
                  "Finger counting close to face",
                  "Hand movement close to face",
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
                    r"${ pvaRE } != 1 and ${ pvaRE } != 2 and ${ pvaRE } != 3 and ${ pvaRE } != 4 and ${ pvaRE } != 16 and ${ age } > 5  and ${ pvaRE } < 17"),
                constraint: getCondition(r"${ pinRE } <= ${ pvaRE }"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "6/6",
                  "6/7.5",
                  "6/9.5",
                  "6/12",
                  "6/15",
                  "6/18",
                  "6/24",
                  "6/30",
                  "6/38",
                  "6/48",
                  "6/60",
                  "3/60",
                  "Finger counting close to face",
                  "Hand movement close to face",
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
                    "Right eye: - Did the corneal opacity occur after the cataract surgery ? ",
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
                    getCondition(r"${ pinRE } > 4  and ${ age } > 5 "),
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
                  "6/6",
                  "6/7.5",
                  "6/9.5",
                  "6/12",
                  "6/15",
                  "6/18",
                  "6/24",
                  "6/30",
                  "6/38",
                  "6/48",
                  "6/60",
                  "3/60",
                  "Finger counting close to face",
                  "Hand movement close to face",
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
                    r"${ pvaLE } != 1 and ${ pvaLE } != 2 and ${ pvaLE } != 3 and ${ pvaLE } != 4 and ${ pvaLE } != 16 and ${ age } > 5  and ${ pvaLE } < 17"),
                constraint: getCondition(r"${ pinLE } <= ${ pvaLE }"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: [
                  "6/6",
                  "6/7.5",
                  "6/9.5",
                  "6/12",
                  "6/15",
                  "6/18",
                  "6/24",
                  "6/30",
                  "6/38",
                  "6/48",
                  "6/60",
                  "3/60",
                  "Finger counting close to face",
                  "Hand movement close to face",
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
                    getCondition(r"${ pinLE } > 4 and ${ age } > 5"),
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
                visibilityCondition: getCondition(r"${ vara } = 2"),
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
                visibilityCondition: getCondition(r"${ vara } = 1"),
                required: true,
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question: "If yes, has the patient undergone Keratoplasty ? ",
                variable: "varba",
                required: true,
                visibilityCondition: getCondition(r"${ vara } = 1 and ${ varb } = 1"),
                lastSaved: true,
                type: QuestionType.dropdown,
                valueType: "Number",
                valueRange: ["Yes", "No"]),
            Question(
                question:
                    "If not undergone keratoplasty,what are the barriers preventing them from availing keratoplasty services ? ",
                variable: "varbb",
                required: true,
                visibilityCondition: getCondition(r"${ vara } = 1 and ${ varba } = 2"),
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
              sectionName: "Section E - Photo",
              questions: [
                Question(
                    question: "Right eye",
                    variable: "photoRE",
                    required: false,
                    lastSaved: true,
                    type: QuestionType.imagePicker,
                    valueType: "String",
                    valueRange: []),
                Question(
                    question: "Left eye",
                    variable: "photoLE",
                    required: false,
                    lastSaved: true,
                    type: QuestionType.imagePicker,
                    valueType: "String",
                    valueRange: []),
              ],
              jumps: [
                Jump(
                    sectionID: 9
                )
              ],
          ),
              Section(
              sectionID: 9,
              sectionName: "Section - Other",
                  questions: [
                    Question(
                        question: "Comments",
                        variable: "comment",
                        required: false,
                        lastSaved: true,
                        type: QuestionType.textfield,
                        valueType: "String",
                        valueRange: []),
                    ],
                  jumps: [],
                  finalSection:true
              )
        ],
        createAt: DateTime.now(),
        activeFrom: DateTime.now(),
        activeTill: DateTime(2024));

    my_api.API.toFile.storeSurvey(localInterface, keratoplasty.toJson());
    surveys.add(keratoplasty);
  }
}



List<int> generateUniqueRandomIntegers(int length, int min, int max) {
  if (length <= 0 || min >= max) {
    throw ArgumentError('Invalid input parameters');
  }

  List<int> uniqueList = [];
  Set<int> uniqueSet = Set<int>();

  while (uniqueList.length < length) {
    int randomNumber = Random().nextInt(max - min + 1) + min;
    if (!uniqueSet.contains(randomNumber)) {
      uniqueSet.add(randomNumber);
      uniqueList.add(randomNumber);
    }
  }

  return uniqueList;
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HIVE ENCRYPTION----------------------------------------

  var path = "";
  Directory? directory;
  try {
    if(Platform.isAndroid) {
      directory = (await getExternalStorageDirectory());
    } else {
      directory = (await getApplicationDocumentsDirectory());
    }

  } catch (err) {
    if (kDebugMode) {
      print("Cannot get download folder path");
    }
  }

  String projectName = await Util.getProjectName();
  if (!Directory("${directory!.path}/$projectName").existsSync()) {
    Directory("${directory.path}/$projectName").create(recursive: true);
  }

  directory = Directory("${directory.path}/$projectName");
  path = directory.path;
  if (kDebugMode) {
    print("path : $path");
  }
  //Hive.init(path);
  String jsonText = await rootBundle.loadString("assets/env.json");
  final data = await json.decode(jsonText);

  configuration = Configuration(data['baseurl']);



  my_hive_interface.LocalStoreInterface localInterface =
      my_hive_interface.LocalStoreInterface(collection: [
    'user',
    'survey',
    'answers',
    'aiResult',
  ],path:path
      );


  try {
    surveys = my_api.API.fromFile.loadSurveys(localInterface);


    if(surveys.isEmpty){
      testData(localInterface);
    }
    my_api.API.fromFile.loadUser(localInterface);
  } catch (e, stack) {
    if (kDebugMode) {
      print(e);
      print(stack);
    }
  }



  if (kDebugMode) {
    print("User id : ${user.loginId}");
  }

  runApp(MyApp(localInterface: localInterface));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.localInterface}) : super(key: key);

  final my_hive_interface.LocalStoreInterface localInterface;
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
        "/LoginPage": (context) => LoginPage(hiveInterface: localInterface),
        "/HomePage": (context) => HomePage(hiveInterface: localInterface),
      },
      home: (user.signedIn)
          ? HomePage(hiveInterface: localInterface)
          : LoginPage(hiveInterface: localInterface),
    );
  }
}

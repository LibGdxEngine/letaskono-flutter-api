import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';
import 'package:letaskono_flutter/features/auth/domain/entities/AuthEntity.dart';
import 'package:letaskono_flutter/features/auth/domain/entities/ProfileSetupEntity.dart';
import 'package:letaskono_flutter/features/auth/presentation/widgets/gender_selection_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth_bloc.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final PageController _controller = PageController(initialPage: 0);
  late SharedPreferences _prefs;

  int _currentStep = 0;

  String? _selectedGender;

  String? _genderError; // To display error message
  String? _selectedSkinColor;
  String? _selectedCountry;
  int? _selectedQuranParts;
  String? _selectedFatherKnowAboutApp;
  String? _selectedFatherAcceptMarriageWithoutQaima;
  bool _selectedYouAcceptMarriageWithoutQaima = true;
  String? _selectedState;
  String _selectedPhoneCode = '';
  String? _selectedEducationLevel;
  String? _selectedMaritalStatus;

  bool hasChildren = false;

  bool isFatherAlive = true;
  bool isMotherAlive = true;

  String? _selectedPrayFrequency;
  String? _selectedAzkarPractice;

  // Form keys for each step
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _familyInfoFormKey = GlobalKey<FormState>();
  final _religiousInfoFormKey = GlobalKey<FormState>();

  // Form controllers
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final skinColorController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final fatherPhoneNumberController = TextEditingController();
  final professionController = TextEditingController();
  final aboutMeController = TextEditingController();
  final aboutMyPartnerController = TextEditingController();
  final boysController = TextEditingController();
  final girlsController = TextEditingController();
  final brothersController = TextEditingController();
  final sistersController = TextEditingController();
  final fatherJobController = TextEditingController();
  final motherJobController = TextEditingController();
  final wantIslamicMarriageController = TextEditingController();
  final relationWithFamilyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefs = GetIt.instance<SharedPreferences>();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _loadFormData(); // Load saved data on initialization
  }

  // Save data on each step
  void _saveFormData(step) {
    switch (step) {
      case 0:
        _prefs.setString('profile_setup_gender', _selectedGender ?? '');
        _prefs.setString('profile_setup_age', ageController.text);
        _prefs.setString('profile_setup_height', heightController.text);
        _prefs.setString('profile_setup_weight', weightController.text);
        _prefs.setString('profile_setup_skinColor', _selectedSkinColor ?? '');
        break;
      case 1:
        _prefs.setString('profile_setup_country', _selectedCountry ?? '');
        _prefs.setString('profile_setup_state', _selectedState ?? '');
        _prefs.setString('profile_setup_city', cityController.text);
        _prefs.setString('profile_setup_phone', phoneController.text);
        _prefs.setString('profile_setup_fathersPhoneNumber',
            fatherPhoneNumberController.text);
        _prefs.setString('profile_setup_fatherKnowAboutApp',
            _selectedFatherKnowAboutApp ?? '');
        _prefs.setString('profile_setup_fatherAcceptMarriageWithoutQaima',
            _selectedFatherAcceptMarriageWithoutQaima ?? '');
        _prefs.setBool('youAcceptMarriageWithoutQaima',
            _selectedYouAcceptMarriageWithoutQaima);
        break;
      case 2:
        _prefs.setString('profile_setup_profession', professionController.text);
        _prefs.setString(
            'profile_setup_maritalStatus', _selectedMaritalStatus!);
        _prefs.setString('profile_setup_aboutMe', aboutMeController.text);
        _prefs.setString(
            'profile_setup_aboutMyPartner', aboutMyPartnerController.text);
        _prefs.setString('profile_setup_numberOfBoys', boysController.text);
        _prefs.setString('profile_setup_numberOfGirls', girlsController.text);
        _prefs.setString(
            'profile_setup_education', _selectedEducationLevel ?? '');
        break;
      case 3:
        _prefs.setBool('profile_setup_fatherAlive', isFatherAlive);
        _prefs.setBool('profile_setup_motherAlive', isMotherAlive);
        _prefs.setString('profile_setup_fatherJob', fatherJobController.text);
        _prefs.setString('profile_setup_motherJob', motherJobController.text);
        _prefs.setString(
            'profile_setup_numberOfBrothers', brothersController.text);
        _prefs.setString(
            'profile_setup_numberOfSisters', sistersController.text);
        break;
      case 4:
        _prefs.setInt('profile_setup_quran', _selectedQuranParts ?? 0);
        _prefs.setString('profile_setup_wantIslamicMarriage',
            wantIslamicMarriageController.text);
        _prefs.setString('profile_setup_relationWithFamily',
            relationWithFamilyController.text);
        _prefs.setString(
            'profile_setup_prayFrequency', _selectedPrayFrequency ?? '');
        _prefs.setString(
            'profile_setup_azkarPractice', _selectedAzkarPractice ?? '');
        break;
      default:
        break;
    }
  }

  // Load data when re-entering the page
  void _loadFormData() {
    setState(() {
      _selectedGender = _prefs.getString('profile_setup_gender') ?? '';
      ageController.text = _prefs.getString('profile_setup_age') ?? '';
      heightController.text = _prefs.getString('profile_setup_height') ?? '';
      weightController.text = _prefs.getString('profile_setup_weight') ?? '';
      fatherPhoneNumberController.text =
          _prefs.getString('profile_setup_fathersPhoneNumber') ?? '';

      _selectedSkinColor =
          _prefs.getString("profile_setup_skinColor")?.isNotEmpty == true
              ? _prefs.getString("profile_setup_skinColor")
              : null;
      cityController.text = _prefs.getString('profile_setup_city') ?? '';
      _selectedCountry =
          (_prefs.getString('profile_setup_country')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_country')
              : null;
      _selectedFatherKnowAboutApp =
          (_prefs.getString('profile_setup_fatherKnowAboutApp')?.isNotEmpty ??
                  false)
              ? _prefs.getString('profile_setup_fatherKnowAboutApp')
              : null;
      _selectedFatherAcceptMarriageWithoutQaima = (_prefs
                  .getString('profile_setup_fatherAcceptMarriageWithoutQaima')
                  ?.isNotEmpty ??
              false)
          ? _prefs.getString('profile_setup_fatherAcceptMarriageWithoutQaima')
          : null;
      _selectedYouAcceptMarriageWithoutQaima =
          _prefs.getBool('profile_setup_youAcceptMarriageWithoutQaima') ?? true;

      _selectedState = (_selectedCountry != null &&
              _prefs.getString('profile_setup_state')?.isNotEmpty == true)
          ? _prefs.getString('profile_setup_state')
          : null;
      phoneController.text = _prefs.getString('profile_setup_phone') ?? '';
      professionController.text =
          _prefs.getString('profile_setup_profession') ?? '';
      _selectedMaritalStatus =
          (_prefs.getString('profile_setup_maritalStatus')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_maritalStatus')
              : null;

      _selectedEducationLevel =
          (_prefs.getString('profile_setup_education')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_education')
              : null;
      aboutMeController.text = _prefs.getString('profile_setup_aboutMe') ?? '';
      wantIslamicMarriageController.text =
          _prefs.getString('profile_setup_wantIslamicMarriage') ?? '';
      aboutMyPartnerController.text =
          _prefs.getString('profile_setup_aboutMyPartner') ?? '';
      boysController.text =
          _prefs.getString('profile_setup_numberOfBoys') ?? '';
      girlsController.text =
          _prefs.getString('profile_setup_numberOfGirls') ?? '';
      isFatherAlive = _prefs.getBool('profile_setup_fatherAlive') ?? false;
      isMotherAlive = _prefs.getBool('profile_setup_motherAlive') ?? false;
      fatherJobController.text =
          _prefs.getString('profile_setup_fatherJob') ?? '';
      motherJobController.text =
          _prefs.getString('profile_setup_motherJob') ?? '';
      brothersController.text =
          _prefs.getString('profile_setup_numberOfBrothers') ?? '';
      sistersController.text =
          _prefs.getString('profile_setup_numberOfSisters') ?? '';
      _selectedQuranParts = _prefs.getInt('profile_setup_quran') ?? 0;
      relationWithFamilyController.text =
          _prefs.getString('profile_setup_relationWithFamily') ?? '';
      _selectedPrayFrequency =
          (_prefs.getString('profile_setup_prayFrequency')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_prayFrequency')
              : null;

      _selectedAzkarPractice =
          (_prefs.getString('profile_setup_azkarPractice')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_azkarPractice')
              : null;
    });
  }

  // Clear data when submission is successful
  Future<void> _clearFormData() async {
    await _prefs.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    heightController.dispose();
    ageController.dispose();
    weightController.dispose();
    skinColorController.dispose();
    stateController.dispose();
    countryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    aboutMeController.dispose();
    aboutMyPartnerController.dispose();
    boysController.dispose();
    girlsController.dispose();
    brothersController.dispose();
    sistersController.dispose();
    fatherJobController.dispose();
    motherJobController.dispose();
    relationWithFamilyController.dispose();
    fatherPhoneNumberController.dispose();
    wantIslamicMarriageController.dispose();
    professionController.dispose();
    super.dispose();
  }

  void nextPage() {
    // Validate based on the current step
    bool isValid = false;
    switch (_currentStep) {
      case 0:
        if (_selectedGender?.isEmpty ?? true) {
          setState(() {
            _genderError =
                "Please select a gender"; // Set error message if no gender selected
          });
        } else {
          setState(() {
            _genderError = null;
          });
        }
        isValid = _basicInfoFormKey.currentState!.validate() &&
            _selectedGender!.isNotEmpty;
        break;
      case 1:
        isValid = _locationFormKey.currentState!.validate();
        break;
      case 2:
        isValid = _personalInfoFormKey.currentState!.validate();
        break;
      case 3:
        isValid = _familyInfoFormKey.currentState!.validate();
        break;
      case 4:
        isValid = _religiousInfoFormKey.currentState!.validate();
        break;
      default:
        isValid = true;
    }

    if (isValid) {
      _saveFormData(_currentStep);
      if (_currentStep < 5) {
        _controller.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  // In the final step, clear data on successful submission
  void _onSubmit() async {
    // Submit the form (do your submission logic)
    await _clearFormData(); // Clear saved data after submission
    // TODO: send request to fill user data
    BlocProvider.of<AuthBloc>(context).add(SubmitProfileEvent(ProfileCompletion(
      gender: _selectedGender == "male" ? 'M' : 'F',
      age: int.parse(ageController.text),
      aboutMe: aboutMeController.text,
      azkar: _selectedAzkarPractice,
      children: hasChildren,
      city: cityController.text,
      country: _selectedCountry,
      educationLevel: _selectedEducationLevel,
      fatherAlive: isFatherAlive,
      motherAlive: isMotherAlive,
      fatherOccupation: fatherJobController.text,
      motherOccupation: fatherJobController.text,
      height: int.parse(heightController.text),
      maritalStatus: _selectedMaritalStatus,
      memorizedQuranParts: _selectedQuranParts,
      phoneNumber: "$_selectedPhoneCode ${phoneController.text}",
      profession: professionController.text,
      numberOfBrothers: int.parse(brothersController.text),
      numberOfSisters: int.parse(sistersController.text),
      numberOfChildBoys: int.tryParse(boysController.text),
      numberOfChildGirls: int.parse(girlsController.text),
      skinColor: _selectedSkinColor,
      state: _selectedState,
      relationWithFamily: relationWithFamilyController.text,
      prayerFrequency: _selectedPrayFrequency,
      weight: int.parse(weightController.text),
      fathersPhone: fatherPhoneNumberController.text,
      fatherAcceptMarriageWithoutQaima:
          _selectedFatherAcceptMarriageWithoutQaima,
      fatherKnowAboutThisWebsite: _selectedFatherKnowAboutApp,
      islamicMarriage: _selectedYouAcceptMarriageWithoutQaima,
      lookingFor: aboutMyPartnerController.text,
      wantQaima: _selectedYouAcceptMarriageWithoutQaima,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthFailure():
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            case AuthProfileSubmitted():
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile setup completed")),
                );
              }
          }
        },
        child: Column(
          children: [
            // Horizontal step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      _currentStep == index ? Colors.blue : Colors.grey,
                  child: Text('${index + 1}'),
                );
              }),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (page) {
                  setState(() {
                    _currentStep = page;
                  });
                },
                children: [
                  buildBasicInfoStep(context),
                  buildLocationStep(context),
                  buildPersonalInfoStep(context),
                  buildFamilyInfoStep(context),
                  buildReligiousInfoStep(context),
                  buildDocumentUploadStep(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                        onPressed: previousPage, child: const Text('Previous')),
                  ElevatedButton(
                    onPressed: _currentStep == 5 ? _onSubmit : nextPage,
                    child: Text(_currentStep == 5 ? 'Finish' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Basic Information
  Widget buildBasicInfoStep(BuildContext context) {
    final List<String> _skinColors = [
      'فاتح جدًا',
      'فاتح',
      'متوسط',
      'برونزي',
      'غامق',
      'داكن جدًا',
    ];
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _basicInfoFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GenderSelectionWidget(
                  selectedGender: _selectedGender,
                  onGenderSelected: (gender) {
                    _selectedGender = gender;
                    _selectedMaritalStatus = null;
                    _genderError =
                        null; // Clear error when a gender is selected
                  },
                ),
                Text(_genderError ?? '',
                    style: const TextStyle(color: Colors.red)),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Age must be greater than 0';
                    }
                    if (int.parse(value) >= 100) {
                      return 'Age must be less than 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: const InputDecoration(labelText: 'Height'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.tryParse(value)! >= 220.0) {
                      return 'Please enter a valid number';
                    }
                    if (double.tryParse(value)! <= 40) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.tryParse(value)! >= 250) {
                      return 'Please enter a valid number';
                    }
                    if (double.tryParse(value)! <= 25) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Skin Color',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedSkinColor,
                  items: _skinColors.map((color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSkinColor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a skin color';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 2: Location Information
  Widget buildLocationStep(BuildContext context) {
    // Predefined lists of cities and countries

    final Map<String, String> fatherKnowsOptions = {
      'yes': 'Yes, knows',
      'no': 'No',
      'no_but_tell': 'No, but I can tell him later',
    };
    final Map<String, String> fatherAcceptMarriageWithoutQaima = {
      'yes': 'Yes',
      'no': 'No',
      'maybe': 'Maybe',
    };
    final Map<String, String> youAcceptMarriageWithoutQaima = {
      'yes': 'Yes',
      'no': 'No',
    };

    // Update phone code when country is selected
    void _onCountryChanged(String? country) {
      setState(() {
        _selectedCountry = country;
        _selectedPhoneCode = Constants.countryPhoneCodeMap[country!]!;
        // Reset city when country changes
        _selectedState = null;
      });
    }

    // Validate phone number (basic validation)
    String? _validatePhoneNumber(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your phone number';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Enter a valid phone number';
      }
      return null;
    }

    return Form(
      key: _locationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(labelText: 'Country'),
                items: Constants.countryStateMap.keys.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: _onCountryChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // City Dropdown (depends on selected country)
              if (_selectedCountry != null)
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: const InputDecoration(labelText: 'State'),
                  items:
                      Constants.countryStateMap[_selectedCountry]!.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (state) {
                    setState(() {
                      _selectedState = state;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),

              // Phone number field with country phone code
              TextFormField(
                controller: cityController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone number field with country phone code
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText:
                      _selectedPhoneCode, // Display phone code as a prefix
                ),
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 16),

              _selectedGender == 'female'
                  ? Column(
                      children: [
                        TextFormField(
                          controller: fatherPhoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Fathers phone number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the father phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedFatherKnowAboutApp,
                          // Initially selected value
                          decoration: const InputDecoration(
                            labelText: 'Does your father know about this app?',
                            border: OutlineInputBorder(),
                          ),
                          items: fatherKnowsOptions.entries
                              .map((entry) => DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _selectedFatherKnowAboutApp = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedFatherAcceptMarriageWithoutQaima,
                          // Initially selected value
                          decoration: const InputDecoration(
                            labelText:
                                'Does your father accept marriage without qaima?',
                            border: OutlineInputBorder(),
                          ),
                          items: fatherAcceptMarriageWithoutQaima.entries
                              .map((entry) => DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _selectedFatherAcceptMarriageWithoutQaima = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedYouAcceptMarriageWithoutQaima == true
                              ? 'yes'
                              : 'no',
                          // Initially selected value
                          decoration: const InputDecoration(
                            labelText:
                                'Does you accept marriage without qaima?',
                            border: OutlineInputBorder(),
                          ),
                          items: youAcceptMarriageWithoutQaima.entries
                              .map((entry) => DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value?.toLowerCase() == "yes") {
                              _selectedYouAcceptMarriageWithoutQaima = true;
                            } else if (value?.toLowerCase() == "no") {
                              _selectedYouAcceptMarriageWithoutQaima = false;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // Step 3: Personal Information
  Widget buildPersonalInfoStep(BuildContext context) {
    final List<String> educationLevels = [
      'شهادة إبتدائية',
      'شهادة إعدادية',
      'شهادة ثانوية',
      'شهادة فني',
      'شهادة متوسطة',
      'شهادة بكالريوس',
      'شهادة ماجستير',
      'شهادة دكتوراه',
      'تعليم منزلي',
    ];
    // Define marital status options based on gender
    List<String> getMaritalStatusOptions() {
      if (_selectedGender == 'male') {
        return ['متزوج', 'مطلق', 'أرمل', 'أعزب'];
      } else if (_selectedGender == 'female') {
        return ['مطلقة', 'أرملة', 'عزباء'];
      }
      return [];
    }

    // Validator for required fields
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    return Form(
      key: _personalInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Profession input with validation
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Education Level',
                  border: OutlineInputBorder(),
                ),
                value: _selectedEducationLevel,
                items: educationLevels.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEducationLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an education level';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Profession'),
                validator: _requiredFieldValidator,
                controller: professionController,
              ),
              const SizedBox(height: 16),

              // Marital Status dropdown with validation
              DropdownButtonFormField<String>(
                value: _selectedMaritalStatus,
                decoration: const InputDecoration(labelText: 'Marital Status'),
                items: getMaritalStatusOptions().map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMaritalStatus = value;
                    // Show child inputs if the marital status is not "Single"
                    var keyword = _selectedGender == "male" ? 'أعزب' : 'عزباء';
                    hasChildren = value != keyword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your marital status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Conditionally show child input fields if marital status is not "Single"
              if (hasChildren) ...[
                // Number of boys input
                TextFormField(
                  controller: boysController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Number of Boys'),
                  validator: (value) {
                    if (hasChildren && (value == null || value.isEmpty)) {
                      return 'Please enter the number of boys';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Number of girls input
                TextFormField(
                  controller: girlsController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Number of Girls'),
                  validator: (value) {
                    if (hasChildren && (value == null || value.isEmpty)) {
                      return 'Please enter the number of girls';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 16),
              // About Me input with validation
              TextFormField(
                controller: aboutMeController,
                decoration: const InputDecoration(labelText: 'About Me'),
                maxLines: 3,
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              // About my partner input with validation
              TextFormField(
                controller: aboutMyPartnerController,
                decoration:
                    const InputDecoration(labelText: 'About My Partner'),
                maxLines: 3,
                validator: _requiredFieldValidator,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 4: Family Information
  Widget buildFamilyInfoStep(BuildContext context) {
    // Validators
    String? _requiredNumberValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a valid number';
      }
      if (int.tryParse(value) == null) {
        return 'Please enter a valid integer';
      }
      return null;
    }

    String? _requiredTextValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    return Form(
      key: _familyInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Father Alive Switch
              SwitchListTile(
                title: const Text('Father Alive'),
                value: isFatherAlive,
                onChanged: (value) {
                  setState(() {
                    isFatherAlive = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Conditionally show Father's Job field
              if (isFatherAlive)
                TextFormField(
                  controller: fatherJobController,
                  decoration: const InputDecoration(labelText: 'Father\'s Job'),
                  validator: _requiredTextValidator,
                ),
              const SizedBox(height: 16),

              // Mother Alive Switch
              SwitchListTile(
                title: const Text('Mother Alive'),
                value: isMotherAlive,
                onChanged: (value) {
                  setState(() {
                    isMotherAlive = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Conditionally show Mother's Job field
              if (isMotherAlive)
                TextFormField(
                  controller: motherJobController,
                  decoration: const InputDecoration(labelText: 'Mother\'s Job'),
                  validator: _requiredTextValidator,
                ),
              const SizedBox(height: 16),

              // Number of Brothers
              TextFormField(
                controller: brothersController,
                decoration:
                    const InputDecoration(labelText: 'Number of Brothers'),
                keyboardType: TextInputType.number,
                validator: _requiredNumberValidator,
              ),
              const SizedBox(height: 16),

              // Number of Sisters
              TextFormField(
                controller: sistersController,
                decoration:
                    const InputDecoration(labelText: 'Number of Sisters'),
                keyboardType: TextInputType.number,
                validator: _requiredNumberValidator,
              ),
              const SizedBox(height: 16),

              // Submit Button
            ],
          ),
        ),
      ),
    );
  }

  // Step 5: Religious Information
  Widget buildReligiousInfoStep(BuildContext context) {
    // Praying frequency options
    List<Map<String, String>> prayFrequencyOptions = [
      {"value": "كل الصلوات في المسجد", "label": "كل الصلوات في المسجد"},
      {"value": "معظم الصلوات في المسجد", "label": "معظم الصلوات في المسجد"},
      {"value": "معظم الصلوات في البيت", "label": "معظم الصلوات في البيت"},
      {"value": "متقطع في الصلاة", "label": "متقطع في الصلاة"},
      {"value": "لا أصلي والعياذ بالله", "label": "لا أصلي والعياذ بالله"},
    ];
    if (_selectedGender == "female") {
      prayFrequencyOptions.removeRange(0, 2);
    }
    // Azkar practice options
    List<Map<String, String>> azkarPracticeOptions = [
      {"value": "دائمًا", "label": "دائمًا"},
      {"value": "أحيانًا", "label": "أحيانًا"},
      {"value": "لا", "label": "لا"},
    ];

    List<Map<String, dynamic>> quranMemorizationChoices =
        List.generate(31, (index) {
      if (index == 0) {
        return {"value": 0, "label": "قصار السور"};
      } else if (index == 1) {
        return {"value": 1, "label": "جزء واحد"};
      } else if (index == 2) {
        return {"value": 2, "label": "جزءان"};
      } else if (index >= 3 && index <= 10) {
        return {"value": index, "label": "$index أجزاء"};
      } else {
        return {"value": index, "label": "$index جزءًا"};
      }
    });

    // Validators
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    return Form(
      key: _religiousInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Memorized Quran Parts input with validation
              DropdownButtonFormField<int>(
                value: _selectedQuranParts,
                // Default value: 0
                decoration:
                    const InputDecoration(labelText: 'أجزاء القرآن المحفوظة'),
                items: quranMemorizationChoices
                    .map((choice) => DropdownMenuItem<int>(
                          value: choice["value"],
                          child: Text(choice["label"]),
                        ))
                    .toList(),
                onChanged: (value) {
                  // Save the selected value
                  _selectedQuranParts = value;
                },
                validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: relationWithFamilyController,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(labelText: 'Relation with Family'),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPrayFrequency,
                decoration:
                    const InputDecoration(labelText: 'Praying Frequency'),
                items: prayFrequencyOptions.map((option) {
                  return DropdownMenuItem(
                    value: option["value"],
                    child: Text(option["label"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPrayFrequency = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a praying frequency';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAzkarPractice,
                decoration: const InputDecoration(labelText: 'Azkar Practice'),
                items: azkarPracticeOptions.map((option) {
                  return DropdownMenuItem(
                    value: option["value"],
                    child: Text(option["label"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAzkarPractice = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an azkar practice';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: wantIslamicMarriageController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Do you want Islamic marriage ?'),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

// Step 6: Document Upload
  Widget buildDocumentUploadStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text(
                "أقسم بالله العظيم أن التزم بالأدب والأخلاق الإسلامية، وأن يكون هدفي من التسجيل في هذا التطبيق هو الزواج الشرعي بما يرضي الله تعالى، وليس لأي غرض آخر.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

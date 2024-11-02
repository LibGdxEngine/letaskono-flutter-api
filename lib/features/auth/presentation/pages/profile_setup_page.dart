import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/auth/presentation/widgets/gender_selection_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? selectedCountry = null;
  String? selectedState = null;
  String selectedPhoneCode = '';

  String? selectedMaritalStatus = 'Single';
  bool hasChildren = false;

  bool isFatherAlive = true;
  bool isMotherAlive = true;

  String? selectedPrayFrequency = null;
  String? selectedAzkarPractice = null;

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
  final professionController = TextEditingController();
  final aboutMeController = TextEditingController();
  final boysController = TextEditingController();
  final girlsController = TextEditingController();
  final brothersController = TextEditingController();
  final sistersController = TextEditingController();
  final fatherJobController = TextEditingController();
  final motherJobController = TextEditingController();
  final memorizedQuranController = TextEditingController();
  final relationWithFamilyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFormData(); // Load saved data on initialization
  }

  // Save data on each step
  void _saveFormData(step) {
    switch (step) {
      case 0:
        _prefs.setString('gender', _selectedGender ?? '');
        _prefs.setString('age', ageController.text);
        _prefs.setString('height', heightController.text);
        _prefs.setString('weight', weightController.text);
        break;
      case 1:
        _prefs.setString('country', selectedCountry ?? '');
        _prefs.setString('state', selectedState ?? '');
        _prefs.setString('city', cityController.text);
        _prefs.setString('phone', phoneController.text);
        break;
      case 2:
        _prefs.setString('profession', professionController.text);
        _prefs.setString('maritalStatus', selectedMaritalStatus!);
        _prefs.setString('aboutMe', aboutMeController.text);
        _prefs.setString('numberOfBoys', boysController.text);
        _prefs.setString('numberOfGirls', girlsController.text);
        break;
      case 3:
        _prefs.setBool('fatherAlive', isFatherAlive);
        _prefs.setBool('motherAlive', isMotherAlive);
        _prefs.setString('fatherJob', fatherJobController.text);
        _prefs.setString('motherJob', motherJobController.text);
        _prefs.setString('numberOfBrothers', brothersController.text);
        _prefs.setString('numberOfSisters', sistersController.text);
        break;
      case 4:
        _prefs.setString('quran', memorizedQuranController.text);
        _prefs.setString(
            'relationWithFamily', relationWithFamilyController.text);
        _prefs.setString('prayFrequency', selectedPrayFrequency ?? '');
        _prefs.setString('azkarPractice', selectedAzkarPractice ?? '');
        break;
      default:
        break;
    }
  }

  // Load data when re-entering the page
  void _loadFormData() {
    setState(() {
      _selectedGender = _prefs.getString('gender') ?? '';
      ageController.text = _prefs.getString('age') ?? '';
      heightController.text = _prefs.getString('height') ?? '';
      weightController.text = _prefs.getString('weight') ?? '';
      cityController.text = _prefs.getString('city') ?? '';
      String? loadedCountry = _prefs.getString('country') ?? '';
      String? loadedState = _prefs.getString('state') ?? '';
      // Ensure `selectedCountry` is valid or set to `null`
      if (loadedCountry.isNotEmpty) {
        selectedCountry = loadedCountry;
      } else {
        selectedCountry = null;
      }
      if (selectedCountry != null && loadedState.isNotEmpty) {
        selectedState = loadedState;
      } else {
        selectedState = null;
      }
      phoneController.text = _prefs.getString('phone') ?? '';
      professionController.text = _prefs.getString('profession') ?? '';
      selectedMaritalStatus = _prefs.getString('maritalStatus') ?? '';
      aboutMeController.text = _prefs.getString('aboutMe') ?? '';
      boysController.text = _prefs.getString('numberOfBoys') ?? '';
      girlsController.text = _prefs.getString('numberOfGirls') ?? '';
      isFatherAlive = _prefs.getBool('fatherAlive') ?? false;
      isMotherAlive = _prefs.getBool('motherAlive') ?? false;
      fatherJobController.text = _prefs.getString('fatherJob') ?? '';
      motherJobController.text = _prefs.getString('motherJob') ?? '';
      brothersController.text = _prefs.getString('numberOfBrothers') ?? '';
      sistersController.text = _prefs.getString('numberOfSisters') ?? '';
      memorizedQuranController.text = _prefs.getString('quran') ?? '';
      relationWithFamilyController.text =
          _prefs.getString('relationWithFamily') ?? '';
      String? loadedPrayFrequency = _prefs.getString('prayFrequency') ?? '';
      String? loadedAzkarPractice = _prefs.getString('azkarPractice') ?? '';
      if (loadedPrayFrequency.isNotEmpty) {
        selectedPrayFrequency = loadedPrayFrequency;
      } else {
        selectedPrayFrequency = null;
      }
      if (loadedAzkarPractice.isNotEmpty) {
        selectedAzkarPractice = loadedAzkarPractice;
      } else {
        selectedAzkarPractice = null;
      }
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
    boysController.dispose();
    girlsController.dispose();
    brothersController.dispose();
    sistersController.dispose();
    fatherJobController.dispose();
    motherJobController.dispose();
    memorizedQuranController.dispose();
    relationWithFamilyController.dispose();
    professionController.dispose();
    super.dispose();
  }

  void nextPage() {
    // Validate based on the current step
    bool isValid = false;
    switch (_currentStep) {
      case 0:
        if (_selectedGender == null) {
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
            _selectedGender != null;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Column(
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
    );
  }

  // Step 1: Basic Information
  Widget buildBasicInfoStep(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _basicInfoFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenderSelectionWidget(
                selectedGender: _selectedGender,
                onGenderSelected: (gender) {
                  _selectedGender = gender;
                  _genderError = null; // Clear error when a gender is selected
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
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 2: Location Information
  Widget buildLocationStep(BuildContext context) {
    // Predefined lists of cities and countries
    Map<String, List<String>> countryStateMap = {
      'USA': ['New York', 'Los Angeles', 'Chicago'],
      'Canada': ['Toronto', 'Vancouver', 'Montreal'],
      'UK': ['London', 'Manchester', 'Birmingham'],
    };

    Map<String, String> countryPhoneCodeMap = {
      'USA': '+1',
      'Canada': '+1',
      'UK': '+44',
    };
    // Update phone code when country is selected
    void _onCountryChanged(String? country) {
      setState(() {
        selectedCountry = country;
        selectedPhoneCode = countryPhoneCodeMap[country!]!;
        // Reset city when country changes
        selectedState = null;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Country Dropdown
            DropdownButtonFormField<String>(
              value: selectedCountry,
              decoration: const InputDecoration(labelText: 'Country'),
              items: countryStateMap.keys.map((country) {
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
            if (selectedCountry != null)
              DropdownButtonFormField<String>(
                value: selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: countryStateMap[selectedCountry]!.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (state) {
                  setState(() {
                    selectedState = state;
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
                prefixText: selectedPhoneCode, // Display phone code as a prefix
              ),
              validator: _validatePhoneNumber,
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Personal Information
  Widget buildPersonalInfoStep(BuildContext context) {
    // Define marital status options based on gender
    List<String> getMaritalStatusOptions() {
      if ("male" == 'male') {
        return ['Married', 'Divorced', 'Widowed', 'Single'];
      } else if ("male" == 'female') {
        return ['Divorced', 'Widowed', 'Single'];
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
              // Profession input with validation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Profession'),
                validator: _requiredFieldValidator,
                controller: professionController,
              ),
              const SizedBox(height: 16),

              // Marital Status dropdown with validation
              DropdownButtonFormField<String>(
                value: selectedMaritalStatus,
                decoration: const InputDecoration(labelText: 'Marital Status'),
                items: getMaritalStatusOptions().map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMaritalStatus = value;
                    // Show child inputs if the marital status is not "Single"
                    hasChildren = value != 'Single';
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

              // About Me input with validation
              TextFormField(
                controller: aboutMeController,
                decoration: const InputDecoration(labelText: 'About Me'),
                maxLines: 4,
                validator: _requiredFieldValidator,
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
      {"value": "ALL_IN_MOSQUE", "label": "ALL IN MOSQUE"},
      {"value": "MOST_IN_MOSQUE", "label": "MOST IN MOSQUE"},
      {"value": "MOST_IN_HOME", "label": "MOST IN HOME"},
      {"value": "INTERMITTENT", "label": "INTERMITTENT"},
      {"value": "NOT_PRAYING", "label": "NOT PRAYING"},
    ];

    // Azkar practice options
    List<Map<String, String>> azkarPracticeOptions = [
      {"value": "ALWAYS", "label": "ALWAYS"},
      {"value": "SOME_TIMES", "label": "SOME TIMES"},
      {"value": "NO", "label": "NO"},
    ];

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
              TextFormField(
                controller: memorizedQuranController,
                decoration:
                    const InputDecoration(labelText: 'Memorized Quran Parts'),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),

              // Relation with Family input with validation
              TextFormField(
                controller: relationWithFamilyController,
                decoration:
                    const InputDecoration(labelText: 'Relation with Family'),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),

              // Praying Frequency dropdown
              DropdownButtonFormField<String>(
                value: selectedPrayFrequency,
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
                    selectedPrayFrequency = value;
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

              // Azkar Practice dropdown
              DropdownButtonFormField<String>(
                value: selectedAzkarPractice,
                decoration: const InputDecoration(labelText: 'Azkar Practice'),
                items: azkarPracticeOptions.map((option) {
                  return DropdownMenuItem(
                    value: option["value"],
                    child: Text(option["label"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAzkarPractice = value;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for national ID front
            },
            child: const Text('Upload National ID Front'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for national ID back
            },
            child: const Text('Upload National ID Back'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for holding ID photo
            },
            child: const Text('Upload ID Holding Photo'),
          ),
        ],
      ),
    );
  }
}

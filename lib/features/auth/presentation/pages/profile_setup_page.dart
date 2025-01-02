import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/SecureStorage.dart';
import 'package:letaskono_flutter/core/utils/SingleSelectionDropdown.dart';
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
  String? _selectedLe7ya;
  String? _selectedHijab;

  String? _genderError; // To display error message
  String? _selectedSkinColor;
  String? _selectedCountry;
  String? _selectedNationality;
  int? _selectedQuranParts;
  String? _selectedFatherKnowAboutApp;
  String? _selectedFatherAcceptMarriageWithoutQaima;
  bool? _selectedYouAcceptMarriageWithoutQaima;
  String? _selectedState;
  String _selectedPhoneCode = '';
  String? _selectedEducationLevel;
  String? _selectedMaritalStatus;

  bool hasChildren = false;

  bool? isFatherAlive;
  bool? isMotherAlive;

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
        _prefs.setString('profile_setup_le7ya', _selectedLe7ya ?? '');
        _prefs.setString('profile_setup_hijab', _selectedHijab ?? '');
        _prefs.setString('profile_setup_age', ageController.text);
        _prefs.setString('profile_setup_height', heightController.text);
        _prefs.setString('profile_setup_weight', weightController.text);
        _prefs.setString('profile_setup_skinColor', _selectedSkinColor ?? '');
        break;
      case 1:
        _prefs.setString('profile_setup_country', _selectedCountry ?? '');
        _prefs.setString(
            'profile_setup_nationality', _selectedNationality ?? '');
        _prefs.setString('profile_setup_state', _selectedState ?? '');
        _prefs.setString('profile_setup_city', cityController.text);
        _prefs.setString('profile_setup_phone', phoneController.text);
        _prefs.setString('profile_setup_phone_code', _selectedPhoneCode);
        _prefs.setString('profile_setup_fathersPhoneNumber',
            fatherPhoneNumberController.text);
        _prefs.setString('profile_setup_fatherKnowAboutApp',
            _selectedFatherKnowAboutApp ?? '');
        _prefs.setString('profile_setup_fatherAcceptMarriageWithoutQaima',
            _selectedFatherAcceptMarriageWithoutQaima ?? '');
        _prefs.setBool('youAcceptMarriageWithoutQaima',
            _selectedYouAcceptMarriageWithoutQaima ?? true);
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
        _prefs.setBool('profile_setup_fatherAlive', isFatherAlive!);
        _prefs.setBool('profile_setup_motherAlive', isMotherAlive!);
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
      _selectedLe7ya =
          _prefs.getString('profile_setup_le7ya')?.isNotEmpty == true
              ? _prefs.getString('profile_setup_le7ya')
              : null;
      _selectedHijab =
          _prefs.getString('profile_setup_hijab')?.isNotEmpty == true
              ? _prefs.getString('profile_setup_hijab')
              : null;
      ageController.text = _prefs.getString('profile_setup_age') ?? '';
      heightController.text = _prefs.getString('profile_setup_height') ?? '';
      weightController.text = _prefs.getString('profile_setup_weight') ?? '';
      _selectedPhoneCode = _prefs.getString('profile_setup_phone_code') ?? '';
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
      _selectedNationality =
          (_prefs.getString('profile_setup_nationality')?.isNotEmpty ?? false)
              ? _prefs.getString('profile_setup_nationality')
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
          _prefs.getBool('profile_setup_youAcceptMarriageWithoutQaima');

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
      isFatherAlive = _prefs.getBool('profile_setup_fatherAlive');
      isMotherAlive = _prefs.getBool('profile_setup_motherAlive');
      fatherJobController.text =
          _prefs.getString('profile_setup_fatherJob') ?? '';
      motherJobController.text =
          _prefs.getString('profile_setup_motherJob') ?? '';
      brothersController.text =
          _prefs.getString('profile_setup_numberOfBrothers') ?? '';
      sistersController.text =
          _prefs.getString('profile_setup_numberOfSisters') ?? '';
      _selectedQuranParts = _prefs.getInt('profile_setup_quran') ?? null;
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
    await _prefs.remove('profile_setup_gender');
    await _prefs.remove('profile_setup_age');
    await _prefs.remove('profile_setup_height');
    await _prefs.remove('profile_setup_weight');
    await _prefs.remove('profile_setup_fathersPhoneNumber');
    await _prefs.remove('profile_setup_skinColor');
    await _prefs.remove('profile_setup_city');
    await _prefs.remove('profile_setup_country');
    await _prefs.remove('profile_setup_nationality');
    await _prefs.remove('profile_setup_fatherKnowAboutApp');
    await _prefs.remove('profile_setup_fatherAcceptMarriageWithoutQaima');
    await _prefs.remove('profile_setup_youAcceptMarriageWithoutQaima');
    await _prefs.remove('profile_setup_state');
    await _prefs.remove('profile_setup_phone');
    await _prefs.remove('profile_setup_profession');
    await _prefs.remove('profile_setup_maritalStatus');
    await _prefs.remove('profile_setup_education');
    await _prefs.remove('profile_setup_aboutMe');
    await _prefs.remove('profile_setup_wantIslamicMarriage');
    await _prefs.remove('profile_setup_aboutMyPartner');
    await _prefs.remove('profile_setup_numberOfBoys');
    await _prefs.remove('profile_setup_numberOfGirls');
    await _prefs.remove('profile_setup_fatherAlive');
    await _prefs.remove('profile_setup_motherAlive');
    await _prefs.remove('profile_setup_fatherJob');
    await _prefs.remove('profile_setup_motherJob');
    await _prefs.remove('profile_setup_numberOfBrothers');
    await _prefs.remove('profile_setup_numberOfSisters');
    await _prefs.remove('profile_setup_quran');
    await _prefs.remove('profile_setup_relationWithFamily');
    await _prefs.remove('profile_setup_prayFrequency');
    await _prefs.remove('profile_setup_azkarPractice');
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
                "اختر ما إذا كنت رجلا أم امرأة"; // Set error message if no gender selected
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
    _submitProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استكمال بيانات الحساب')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          switch (state) {
            case AuthFailure():
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            case AuthProfileSubmitted():
              {
                _clearFormData(); // Clear saved data after submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم استكمال بيانات الحساب")),
                );
                Navigator.pushReplacementNamed(context, "/users");
              }
          }
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Horizontal step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: _currentStep == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      ElevatedButton(
                          onPressed: previousPage, child: const Text('عودة')),
                    if (_currentStep == 0) const Spacer(),
                    ElevatedButton(
                      onPressed: _currentStep == 5 ? _onSubmit : nextPage,
                      child: Text(_currentStep == 5 ? 'استكمال' : 'التالي'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    return Padding(
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
                  _genderError = null; // Clear error when a gender is selected
                },
              ),
              Text(_genderError ?? '',
                  style: const TextStyle(color: Colors.red)),
              CustomTextField(
                controller: ageController,
                hintText: 'العمر',
                keyboardType: TextInputType.number,
                preIconPadding: 11,
                prefixIcon: const Icon(Icons.numbers_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل عمرك';
                  }
                  if (int.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (int.parse(value) <= 0) {
                    return 'يجب أن يكون عمرك أكبر من ذلك';
                  }
                  if (int.parse(value) >= 100) {
                    return 'أنت كبير للغاية للتسجيل لدينا';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: heightController,
                hintText: 'الطول',
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                preIconPadding: 11,
                prefixIcon: Image.asset(
                  "assets/images/height_icon.png",
                  width: 15,
                  height: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل طولك';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (double.tryParse(value)! >= 220.0) {
                    return 'يجب أن يكون طولك اقل من ذلك';
                  }
                  if (double.tryParse(value)! <= 40) {
                    return 'يجب أن يكون طولك أكثر من ذلك';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: weightController,
                hintText: 'الوزن',
                keyboardType: TextInputType.number,
                preIconPadding: 11,
                prefixIcon: Image.asset(
                  "assets/images/weight_icon.png",
                  width: 15,
                  height: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل وزنك';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (double.tryParse(value)! >= 250) {
                    return 'يجب أن يكون وزك أقل من ذلك';
                  }
                  if (double.tryParse(value)! <= 25) {
                    return 'يجب أن يكون وزنك أكبر من ذلك';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                title: 'لون البشرة',
                items: _skinColors,
                selectedItem: _selectedSkinColor,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedSkinColor = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر لون بشرتك';
                  }
                  return null;
                },
                hintText: 'اختر لون البشرة',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Step 2: Location Information
  Widget buildLocationStep(BuildContext context) {
    // Predefined lists of cities and countries
    final Map<String, String> fatherKnowsOptions = {
      'نعم': 'Yes, knows',
      "لا يعلم ولكن يمكنني إخباره": 'No',
      "لا يعلم وأحتاج مساعدة لإخباره": 'No, but I can tell him later',
    };
    final Map<String, String> fatherAcceptMarriageWithoutQaima = {
      'نعم': 'Yes',
      'لا': 'No',
      'ربما': 'Maybe',
    };
    final Map<String, String> youAcceptMarriageWithoutQaima = {
      'نعم': 'Yes',
      'لا': 'No',
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
        return 'من فضلك أدخل رقم هاتفك';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'رقم الهاتف غير صالح!';
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
              SingleSelectionDropdown(
                title: 'بلد الإقامة',
                items: Constants.countryStateMap.keys.toList(),
                selectedItem: _selectedCountry,
                onSelected: _onCountryChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر بلد الإقامة';
                  }
                  return null;
                },
                hintText: 'اختر بلد الإقامة',
              ),
              const SizedBox(height: 16),
              if (_selectedCountry != null) ...[
                SingleSelectionDropdown(
                  title: 'المحافظة',
                  items: Constants.countryStateMap[_selectedCountry]!.toList(),
                  selectedItem: _selectedState,
                  onSelected: (state) {
                    setState(() {
                      _selectedState = state;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر محافظتك';
                    }
                    return null;
                  },
                  isEnabled: _selectedCountry != null,
                  hintText: 'اختر محافظتك',
                ),
                const SizedBox(height: 16),
              ],
              SingleSelectionDropdown(
                title: 'الجنسية',
                items: Constants.countryStateMap.keys.toList(),
                selectedItem: _selectedNationality,
                onSelected: (item) => {
                  setState(() {
                    _selectedNationality = item;
                  })
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر جنسيتك';
                  }
                  return null;
                },
                hintText: 'اختر جنسيتك',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: cityController,
                hintText: 'القرية/المدينة',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل المدينة التي تعيش فيها';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                hintText: 'رقم الهاتف',
                keyboardType: TextInputType.phone,
                preIconPadding: 11,
                prefexText: _selectedPhoneCode,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 16),
              _selectedGender == 'female'
                  ? Column(
                      children: [
                        CustomTextField(
                          controller: fatherPhoneNumberController,
                          hintText: 'رقم هاتف ولي أمرك',
                          keyboardType: TextInputType.phone,
                          preIconPadding: 11,
                          prefexText: _selectedPhoneCode,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك أدخلي رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SingleSelectionDropdown(
                          title:
                              'هل يعلم ولي أمرك بشأن تسجيلك في هذا التطبيق ؟',
                          items: fatherKnowsOptions.keys.toList(),
                          selectedItem: _selectedFatherKnowAboutApp,
                          onSelected: (item) => {
                            setState(() {
                              _selectedFatherKnowAboutApp = item;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل ولي أمرك يعلم بتسجيلك هنا ؟',
                        ),
                        const SizedBox(height: 16),
                        SingleSelectionDropdown(
                          title: 'هل يعلم يقبل ولي أمرك بالزواج الشرعي ؟',
                          items: fatherAcceptMarriageWithoutQaima.keys.toList(),
                          selectedItem:
                              _selectedFatherAcceptMarriageWithoutQaima,
                          onSelected: (item) => {
                            setState(() {
                              _selectedFatherAcceptMarriageWithoutQaima = item;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل يقبل ولي أمرك بالزواج الشرعي ؟',
                        ),
                        const SizedBox(height: 16),
                        SingleSelectionDropdown(
                          title: 'هل أنت تقبلين بالزواج الشرعي ؟ ',
                          items: youAcceptMarriageWithoutQaima.keys.toList(),
                          selectedItem:
                              _selectedYouAcceptMarriageWithoutQaima == true
                                  ? 'نعم'
                                  : _selectedYouAcceptMarriageWithoutQaima ==
                                          false
                                      ? 'لا'
                                      : null,
                          onSelected: (item) => {
                            setState(() {
                              _selectedYouAcceptMarriageWithoutQaima =
                                  item == "نعم" ? true : false;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل تقبلين بالزواج الشرعي ؟',
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
        return ["مطلقة قبل الدخول", 'مطلقة', 'أرملة', 'عزباء'];
      }
      return [];
    }

    // Validator for required fields
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'هذا الحقل مطلوب';
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
              SingleSelectionDropdown(
                title: 'الشهادة التعليمية',
                items: educationLevels,
                selectedItem: _selectedEducationLevel,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedEducationLevel = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر شهادتك التعليمية';
                  }
                  return null;
                },
                hintText: 'اختر شهادتك التعليمية',
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                title: 'الحالة الاجتماعية',
                items: getMaritalStatusOptions(),
                selectedItem: _selectedMaritalStatus,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedMaritalStatus = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر حالتك الاجتماعية';
                  }
                  return null;
                },
                hintText: 'اختر حالتك الاجتماعية',
              ),

              // Conditionally show child input fields if marital status is not "Single"
              if (_selectedMaritalStatus != null &&
                  _selectedMaritalStatus!.isNotEmpty &&
                  !['أعزب', 'عزباء'].contains(_selectedMaritalStatus!)) ...[
                const SizedBox(height: 16),
                // Number of boys input
                CustomTextField(
                  controller: boysController,
                  hintText: 'عدد الأولاد (الذكور)',
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  preIconPadding: 11,
                  prefixIcon: Icon(
                    Icons.boy_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'من فضلك ادخل عدد أولادك الذكور';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Number of girls input
                CustomTextField(
                  controller: girlsController,
                  hintText: 'عدد الأولاد (الإناث)',
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  preIconPadding: 11,
                  prefixIcon: Icon(
                    Icons.girl_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'من فضلك ادخل عدد أولادك البنات';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              CustomTextField(
                controller: professionController,
                hintText: 'الوظيفة/العمل',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.work_outline_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              // About Me input with validation
              CustomTextField(
                controller: aboutMeController,
                hintText: 'تكلم عن نفسك أو ما يقوله الناس عنك',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.more_horiz_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 5,
              ),

              const SizedBox(height: 16),
              // About my partner input with validation
              CustomTextField(
                controller: aboutMyPartnerController,
                hintText: 'ما هي المواصفات التي تريدها في زوجك ؟',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.more_horiz_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
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
        return 'هذا الحقل مطلوب';
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
              SingleSelectionDropdown(
                title: 'هل والدك حي ؟',
                items: const ['نعم, حفظه الله', 'متوفى, رحمه الله'],
                selectedItem: isFatherAlive == true
                    ? "نعم, حفظه الله"
                    : isFatherAlive == false
                        ? "متوفى, رحمه الله"
                        : null,

                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    isFatherAlive = item == "نعم, حفظه الله" ? true : false;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الوالد',
              ),
              const SizedBox(height: 16),
              if (isFatherAlive != null) ...[
                CustomTextField(
                  controller: fatherJobController,
                  hintText: "عمل الوالد",
                  keyboardType: TextInputType.text,
                  preIconPadding: 11,
                  prefixIcon: Icon(
                    Icons.work_outline_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'من فضلك ادخل عمل الوالد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              SingleSelectionDropdown(
                title: 'هل والدتك على قيد الحياة ؟',
                items: const ['نعم, حفظها الله', 'متوفاة, رحمها الله'],
                selectedItem: isMotherAlive == true
                    ? 'نعم, حفظها الله'
                    : isMotherAlive == false
                        ? 'متوفاة, رحمها الله'
                        : null,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    isMotherAlive = item == "نعم, حفظها الله" ? true : false;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الوالدة',
              ),
              const SizedBox(height: 16),
              if (isMotherAlive != null) ...[
                CustomTextField(
                  controller: motherJobController,
                  hintText: "عمل الوالدة",
                  keyboardType: TextInputType.text,
                  preIconPadding: 11,
                  prefixIcon: Icon(
                    Icons.work_outline_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'من فضلك ادخل عمل الوالدة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                controller: brothersController,
                hintText: "عدد الإخوة الذكور",
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.numbers_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'من فضلك ادخل عدد اخوانك';
                  }
                  final result = int.tryParse(value);
                  if (result == null) {
                    return "يجب ادخال رقم صحيح مثل (1و2و3)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: sistersController,
                hintText: "عدد الأخوات البنات",
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.numbers_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'من فضلك ادخل عدد اخواتك';
                  }
                  final result = int.tryParse(value);
                  if (result == null) {
                    return "يجب ادخال رقم صحيح مثل (1و2و3)";
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

  // Step 5: Religious Information
  Widget buildReligiousInfoStep(BuildContext context) {
    // Praying frequency options
    List<String> prayFrequencyOptionsStrings = [
      'كل الصلوات في المسجد',
      'معظم الصلوات في المسجد',
      'معظم الصلوات في البيت',
      'متقطع في الصلاة',
      'لا أصلي والعياذ بالله',
    ];
    if (_selectedGender == "female") {
      prayFrequencyOptionsStrings.removeRange(0, 2);
    }
    // Azkar practice options
    List<String> azkarPracticeOptionsStrings = [
      "دائمًا",
      "أحيانًا",
      "لا",
    ];

    Map<int, String> quranMemorizationChoices = {
      0: 'قصار السور',
      1: 'جزء واحد',
      2: 'جزءان',
      3: '3 أجزاء',
      4: '4 أجزاء',
      5: '5 أجزاء',
      6: '6 أجزاء',
      7: '7 أجزاء',
      8: '8 أجزاء',
      9: '9 أجزاء',
      10: '10 أجزاء',
      11: '11 جزءًا',
      12: '12 جزءًا',
      13: '13 جزءًا',
      14: '14 جزءًا',
      15: '15 جزءًا',
      16: '16 جزءًا',
      17: '17 جزءًا',
      18: '18 جزءًا',
      19: '19 جزءًا',
      20: '20 جزءًا',
      21: '21 جزءًا',
      22: '22 جزءًا',
      23: '23 جزءًا',
      24: '24 جزءًا',
      25: '25 جزءًا',
      26: '26 جزءًا',
      27: '27 جزءًا',
      28: '28 جزءًا',
      29: '29 جزءًا',
      30: '30 جزءًا',
    };

    // Validators
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'هذا الحقل مطلوب';
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
              SingleSelectionDropdown(
                title: 'أجزاء القرآن المحفوظة',
                items: quranMemorizationChoices.keys
                    .map((item) => item.toString())
                    .toList(),
                selectedItem: quranMemorizationChoices[_selectedQuranParts],
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedQuranParts = int.tryParse(item!);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'حفظ القرآن',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: relationWithFamilyController,
                hintText: 'كيف هي علاقتك مع أهلك وأسرتك ؟',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: const Icon(Icons.people_outline_outlined),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                title: 'كيف أنت مع الصلاة ؟',
                items: prayFrequencyOptionsStrings,
                selectedItem: _selectedPrayFrequency,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedPrayFrequency = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الصلاة',
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                title: 'هل تحافظ على أذكار الصباح والمساء ؟',
                items: azkarPracticeOptionsStrings,
                selectedItem: _selectedAzkarPractice,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  setState(() {
                    _selectedAzkarPractice = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الأذكار',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: wantIslamicMarriageController,
                hintText: 'ما هو مفهومك عن الزواج الشرعي ؟',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: const Icon(Icons.check),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              if (_selectedGender != null && _selectedGender == "male")
                SingleSelectionDropdown(
                  title: 'شكل الوجه',
                  items: const ["ملتحي", "لحية خفيفة", "أملس"],
                  selectedItem:
                      (_selectedLe7ya == null || _selectedLe7ya!.isEmpty)
                          ? null
                          : _selectedLe7ya,
                  // Optional: set an initial selected item
                  onSelected: (String? item) {
                    setState(() {
                      _selectedLe7ya = item;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر خيارا محددا';
                    }
                    return null;
                  },
                  hintText: 'شكل الوجه',
                )
              else if (_selectedGender != null && _selectedGender == "female")
                SingleSelectionDropdown(
                  title: 'شكل الحجاب',
                  items: const [
                    "منتقبة سواد",
                    "منتقبة ألوان",
                    "مختمرة",
                    "طرح وفساتين",
                    "طرح وبناطيل",
                    "غير محجبة",
                  ],
                  selectedItem:
                      (_selectedHijab == null || _selectedHijab!.isEmpty)
                          ? null
                          : _selectedHijab,
                  // Optional: set an initial selected item
                  onSelected: (String? item) {
                    setState(() {
                      _selectedHijab = item;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر خيارا محددا';
                    }
                    return null;
                  },
                  hintText: 'شكل الحجاب',
                )
            ],
          ),
        ),
      ),
    );
  }

// Step 6: Document Upload
  Widget buildDocumentUploadStep(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "أقسم بالله العظيم أن التزم الآداب والأخلاق الإسلامية، وأن يكون هدفي من التسجيل في هذا التطبيق هو الزواج الشرعي بما يرضي الله تعالى، وليس لأي غرض آخر.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitProfileData() {
    // Submit the form (do your submission logic)
    final profile = ProfileCompletion(
      gender: _selectedGender == "male" ? 'M' : 'F',
      le7ya: _selectedLe7ya,
      hijab: _selectedHijab,
      age: int.parse(ageController.text),
      aboutMe: aboutMeController.text,
      azkar: _selectedAzkarPractice,
      children: hasChildren,
      city: cityController.text,
      country: _selectedCountry,
      nationality: _selectedNationality,
      educationLevel: _selectedEducationLevel,
      fatherAlive: isFatherAlive,
      motherAlive: isMotherAlive,
      fatherOccupation: fatherJobController.text,
      motherOccupation: motherJobController.text,
      height: int.parse(heightController.text),
      maritalStatus: _selectedMaritalStatus,
      memorizedQuranParts: _selectedQuranParts,
      phoneNumber: "$_selectedPhoneCode ${phoneController.text}",
      profession: professionController.text,
      numberOfBrothers: int.tryParse(brothersController.text),
      numberOfSisters: int.tryParse(sistersController.text),
      numberOfChildBoys: boysController.text.isNotEmpty
          ? int.tryParse(boysController.text)
          : 0,
      numberOfChildGirls:
          girlsController.text.isNotEmpty ? int.parse(girlsController.text) : 0,
      skinColor: _selectedSkinColor,
      state: _selectedState,
      relationWithFamily: relationWithFamilyController.text,
      prayerFrequency: _selectedPrayFrequency,
      weight: int.parse(weightController.text),
      fathersPhone: fatherPhoneNumberController.text.isNotEmpty
          ? "$_selectedPhoneCode ${fatherPhoneNumberController.text}"
          : null,
      fatherAcceptMarriageWithoutQaima:
          _selectedFatherAcceptMarriageWithoutQaima,
      fatherKnowAboutThisWebsite: _selectedFatherKnowAboutApp,
      islamicMarriage: _selectedYouAcceptMarriageWithoutQaima ?? true,
      lookingFor: aboutMyPartnerController.text,
      wantQaima: _selectedYouAcceptMarriageWithoutQaima ?? true,
    );
    BlocProvider.of<AuthBloc>(context).add(SubmitProfileEvent(profile));
  }
}
